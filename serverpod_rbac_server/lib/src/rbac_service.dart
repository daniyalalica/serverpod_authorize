import 'package:serverpod/serverpod.dart';
import 'abac_service.dart';
import 'generated/protocol.dart';
import 'rbac_cache.dart';

/// Callback to customize superuser determination.
typedef SuperuserResolver =
    Future<bool> Function(Session session, String userIdentifier);

/// Primary service for Role-Based Access Control (RBAC) and Attribute-Based Access Control (ABAC).
class RbacService {
  RbacService._();

  /// Singleton instance of the RBAC service.
  static final RbacService instance = RbacService._();

  /// Cache manager for RBAC.
  final RbacCache cache = RbacCache();

  /// ABAC service for domain-aware queries.
  final AbacService abac = AbacService.instance;

  /// Optional custom resolver for superuser status.
  SuperuserResolver? customSuperuserResolver;

  // ==========================================
  // PERMISSION PARSING & NORMALIZATION
  // ==========================================

  /// Normalizes a permission string into (resource, codename).
  static (String resource, String codename) parsePermission(
    String permission, {
    String defaultResource = 'global',
  }) {
    final trimmed = permission.trim().toLowerCase();
    final dotIndex = trimmed.indexOf('.');
    if (dotIndex != -1) {
      final resource = trimmed.substring(0, dotIndex).trim();
      final codename = trimmed.substring(dotIndex + 1).trim();
      return (resource, codename);
    }
    return (defaultResource, trimmed);
  }

  /// Formats resource and codename into canonical string `'resource.codename'`.
  static String formatPermissionKey(String resource, String codename) =>
      '${resource.trim().toLowerCase()}.${codename.trim().toLowerCase()}';

  /// Evaluates whether a permission definition matches a target permission.
  /// Supports wildcards: `*.*`, `resource.*`, and exact matches.
  static bool matchesPermission({
    required String targetResource,
    required String targetCodename,
    required String permissionResource,
    required String permissionCodename,
  }) {
    final tr = targetResource.trim().toLowerCase();
    final tc = targetCodename.trim().toLowerCase();
    final pr = permissionResource.trim().toLowerCase();
    final pc = permissionCodename.trim().toLowerCase();

    if (pr == '*' && pc == '*') return true;
    if (pr == tr && pc == '*') return true;
    if (pr == '*' && pc == tc) return true;
    return pr == tr && pc == tc;
  }

  // ==========================================
  // USER IDENTIFIER EXTRACTION
  // ==========================================

  /// Extracts user identifier from the current session or throws [RbacException].
  String requireUserIdentifier(Session session, [String? explicitIdentifier]) {
    final identifier =
        explicitIdentifier ?? session.authenticated?.userIdentifier;
    if (identifier == null || identifier.isEmpty) {
      throw RbacException(
        message: 'Authentication required to perform authorization check',
        reason: RbacExceptionReason.notAuthenticated,
      );
    }
    return identifier;
  }

  /// Resolves user identifier from current session, returning null if unauthenticated.
  String? getUserIdentifier(Session session, [String? explicitIdentifier]) {
    return explicitIdentifier ?? session.authenticated?.userIdentifier;
  }

  // ==========================================
  // SUPERUSER CHECK
  // ==========================================

  /// Determines whether a user has superuser privileges.
  Future<bool> isSuperuser(
    Session session, {
    String? userIdentifier,
  }) async {
    final uid = getUserIdentifier(session, userIdentifier);
    if (uid == null) return false;

    // 1. Check Serverpod native Scope.admin
    if (session.authenticated?.userIdentifier == uid &&
        session.authenticated?.scopes.contains(Scope.admin) == true) {
      return true;
    }

    // 2. Check custom resolver if configured
    if (customSuperuserResolver != null) {
      final isSuper = await customSuperuserResolver!(session, uid);
      if (isSuper) return true;
    }

    // 3. Check user roles in database
    final assignments = await getUserRoleAssignments(session, uid);
    return assignments.any((ur) => ur.role?.isSuperuser == true);
  }

  // ==========================================
  // PERMISSION RESOLUTION & EVALUATION
  // ==========================================

  /// Fetches all role assignments for [userIdentifier] with eagerly loaded
  /// role definitions and role permissions in a single optimized ORM query.
  Future<List<RbacUserRole>> getUserRoleAssignments(
    Session session,
    String userIdentifier,
  ) async {
    return RbacUserRole.db.find(
      session,
      where: (t) => t.userIdentifier.equals(userIdentifier),
      include: RbacUserRole.include(
        role: RbacRole.include(
          permissions: RbacRolePermission.includeList(
            include: RbacRolePermission.include(
              permission: RbacPermission.include(),
            ),
          ),
        ),
      ),
    );
  }

  /// Resolves the comprehensive permissions snapshot for a user.
  Future<RbacUserPermissionsInfo> getUserPermissionsInfo(
    Session session,
    String userIdentifier, {
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh) {
      final cached = await cache.getUserPermissionsInfo(
        session,
        userIdentifier,
      );
      if (cached != null) return cached;
    }

    final isSuper = await isSuperuser(session, userIdentifier: userIdentifier);
    final assignments = await getUserRoleAssignments(session, userIdentifier);

    final roleNames = <String>{};
    final permissions = <String>{};
    final domains = <String>{};

    for (final ur in assignments) {
      final role = ur.role;
      if (role == null) continue;

      roleNames.add(role.name);
      if (ur.domain != null && ur.domain!.isNotEmpty) {
        domains.add(ur.domain!);
      }

      for (final rp in role.permissions ?? <RbacRolePermission>[]) {
        final p = rp.permission;
        if (p != null) {
          permissions.add(formatPermissionKey(p.resource, p.codename));
        }
      }
    }

    final info = RbacUserPermissionsInfo(
      userIdentifier: userIdentifier,
      isSuperuser: isSuper,
      roles: roleNames.toList(),
      permissions: permissions.toList(),
      domains: domains.toList(),
    );

    await cache.putUserPermissionsInfo(session, userIdentifier, info);
    return info;
  }

  /// Checks if the user has a specific permission, optionally scoped to [domain].
  Future<bool> hasPermission(
    Session session,
    String permission, {
    String? domain,
    String? userIdentifier,
  }) async {
    final uid = getUserIdentifier(session, userIdentifier);
    if (uid == null) return false;

    if (await isSuperuser(session, userIdentifier: uid)) return true;

    final (targetResource, targetCodename) = parsePermission(permission);
    final assignments = await getUserRoleAssignments(session, uid);

    for (final ur in assignments) {
      final role = ur.role;
      if (role == null) continue;
      if (role.isSuperuser) return true;

      // If domain check is requested:
      // The role assignment must be global (ur.domain == null) OR match the specified domain.
      if (domain != null && ur.domain != null && ur.domain != domain) {
        continue;
      }

      for (final rp in role.permissions ?? <RbacRolePermission>[]) {
        final p = rp.permission;
        if (p == null) continue;
        if (matchesPermission(
          targetResource: targetResource,
          targetCodename: targetCodename,
          permissionResource: p.resource,
          permissionCodename: p.codename,
        )) {
          return true;
        }
      }
    }

    return false;
  }

  /// Checks if the user has ALL of the specified permissions.
  Future<bool> hasAllPermissions(
    Session session,
    List<String> permissions, {
    String? domain,
    String? userIdentifier,
  }) async {
    final uid = getUserIdentifier(session, userIdentifier);
    if (uid == null) return false;

    for (final permission in permissions) {
      final has = await hasPermission(
        session,
        permission,
        domain: domain,
        userIdentifier: uid,
      );
      if (!has) return false;
    }
    return true;
  }

  /// Checks if the user has AT LEAST ONE of the specified permissions.
  Future<bool> hasAnyPermission(
    Session session,
    List<String> permissions, {
    String? domain,
    String? userIdentifier,
  }) async {
    final uid = getUserIdentifier(session, userIdentifier);
    if (uid == null) return false;

    for (final permission in permissions) {
      final has = await hasPermission(
        session,
        permission,
        domain: domain,
        userIdentifier: uid,
      );
      if (has) return true;
    }
    return false;
  }

  /// Checks if the user has a specific role, optionally scoped to [domain].
  Future<bool> hasRole(
    Session session,
    String roleName, {
    String? domain,
    String? userIdentifier,
  }) async {
    final uid = getUserIdentifier(session, userIdentifier);
    if (uid == null) return false;

    if (await isSuperuser(session, userIdentifier: uid)) return true;

    final normalized = roleName.trim().toLowerCase();
    final assignments = await getUserRoleAssignments(session, uid);

    for (final ur in assignments) {
      final role = ur.role;
      if (role == null) continue;
      if (role.isSuperuser) return true;

      if (role.name.trim().toLowerCase() == normalized) {
        if (domain == null || ur.domain == null || ur.domain == domain) {
          return true;
        }
      }
    }
    return false;
  }

  /// Checks if the user has AT LEAST ONE of the specified roles.
  Future<bool> hasAnyRole(
    Session session,
    List<String> roleNames, {
    String? domain,
    String? userIdentifier,
  }) async {
    final uid = getUserIdentifier(session, userIdentifier);
    if (uid == null) return false;

    for (final role in roleNames) {
      final has = await hasRole(
        session,
        role,
        domain: domain,
        userIdentifier: uid,
      );
      if (has) return true;
    }
    return false;
  }

  /// Checks if the user has ALL of the specified roles.
  Future<bool> hasAllRoles(
    Session session,
    List<String> roleNames, {
    String? domain,
    String? userIdentifier,
  }) async {
    final uid = getUserIdentifier(session, userIdentifier);
    if (uid == null) return false;

    for (final role in roleNames) {
      final has = await hasRole(
        session,
        role,
        domain: domain,
        userIdentifier: uid,
      );
      if (!has) return false;
    }
    return true;
  }

  // ==========================================
  // REQUIREMENT ENFORCERS (THROWS ON DENIAL)
  // ==========================================

  /// Enforces that the user has [permission], throwing [RbacException] if denied.
  Future<void> requirePermission(
    Session session,
    String permission, {
    String? domain,
    String? userIdentifier,
  }) async {
    final uid = requireUserIdentifier(session, userIdentifier);
    final allowed = await hasPermission(
      session,
      permission,
      domain: domain,
      userIdentifier: uid,
    );
    if (!allowed) {
      throw RbacException(
        message: 'Permission denied: required "$permission"${domain != null ? ' in domain "$domain"' : ''}',
        reason: RbacExceptionReason.permissionDenied,
        requiredPermission: permission,
        requiredDomain: domain,
        userIdentifier: uid,
      );
    }
  }

  /// Enforces that the user has ALL of [permissions].
  Future<void> requireAllPermissions(
    Session session,
    List<String> permissions, {
    String? domain,
    String? userIdentifier,
  }) async {
    final uid = requireUserIdentifier(session, userIdentifier);
    final allowed = await hasAllPermissions(
      session,
      permissions,
      domain: domain,
      userIdentifier: uid,
    );
    if (!allowed) {
      throw RbacException(
        message: 'Permission denied: required all of [${permissions.join(", ")}]',
        reason: RbacExceptionReason.permissionDenied,
        userIdentifier: uid,
      );
    }
  }

  /// Enforces that the user has AT LEAST ONE of [permissions].
  Future<void> requireAnyPermission(
    Session session,
    List<String> permissions, {
    String? domain,
    String? userIdentifier,
  }) async {
    final uid = requireUserIdentifier(session, userIdentifier);
    final allowed = await hasAnyPermission(
      session,
      permissions,
      domain: domain,
      userIdentifier: uid,
    );
    if (!allowed) {
      throw RbacException(
        message: 'Permission denied: required any of [${permissions.join(", ")}]',
        reason: RbacExceptionReason.permissionDenied,
        userIdentifier: uid,
      );
    }
  }

  /// Enforces that the user has [roleName].
  Future<void> requireRole(
    Session session,
    String roleName, {
    String? domain,
    String? userIdentifier,
  }) async {
    final uid = requireUserIdentifier(session, userIdentifier);
    final allowed = await hasRole(
      session,
      roleName,
      domain: domain,
      userIdentifier: uid,
    );
    if (!allowed) {
      throw RbacException(
        message: 'Role denied: required "$roleName"${domain != null ? ' in domain "$domain"' : ''}',
        reason: RbacExceptionReason.roleDenied,
        requiredRole: roleName,
        requiredDomain: domain,
        userIdentifier: uid,
      );
    }
  }

  /// Enforces that the user has ALL of [roleNames].
  Future<void> requireAllRoles(
    Session session,
    List<String> roleNames, {
    String? domain,
    String? userIdentifier,
  }) async {
    final uid = requireUserIdentifier(session, userIdentifier);
    final allowed = await hasAllRoles(
      session,
      roleNames,
      domain: domain,
      userIdentifier: uid,
    );
    if (!allowed) {
      throw RbacException(
        message: 'Roles required: [${roleNames.join(", ")}]',
        reason: RbacExceptionReason.roleDenied,
        userIdentifier: uid,
      );
    }
  }

  /// Enforces that the user has AT LEAST ONE of [roleNames].
  Future<void> requireAnyRole(
    Session session,
    List<String> roleNames, {
    String? domain,
    String? userIdentifier,
  }) async {
    final uid = requireUserIdentifier(session, userIdentifier);
    final allowed = await hasAnyRole(
      session,
      roleNames,
      domain: domain,
      userIdentifier: uid,
    );
    if (!allowed) {
      throw RbacException(
        message: 'Role denied: required any of [${roleNames.join(", ")}]',
        reason: RbacExceptionReason.roleDenied,
        userIdentifier: uid,
      );
    }
  }

  /// Enforces that the user has superuser privileges.
  Future<void> requireSuperuser(
    Session session, {
    String? userIdentifier,
  }) async {
    final uid = requireUserIdentifier(session, userIdentifier);
    final isSuper = await isSuperuser(session, userIdentifier: uid);
    if (!isSuper) {
      throw RbacException(
        message: 'Superuser privilege required',
        reason: RbacExceptionReason.permissionDenied,
        userIdentifier: uid,
      );
    }
  }

  // ==========================================
  // MANAGEMENT: PERMISSIONS (Single & Bulk)
  // ==========================================

  /// Creates a single permission using [RbacPermission.db.insertRow].
  Future<RbacPermission> createPermission(
    Session session, {
    required String resource,
    required String codename,
    required String name,
    String? description,
  }) async {
    final res = resource.trim().toLowerCase();
    final code = codename.trim().toLowerCase();

    final existing = await RbacPermission.db.findFirstRow(
      session,
      where: (t) => t.resource.equals(res) & t.codename.equals(code),
    );
    if (existing != null) return existing;

    final perm = RbacPermission(
      resource: res,
      codename: code,
      name: name,
      description: description,
      createdAt: DateTime.now(),
    );

    final inserted = await RbacPermission.db.insertRow(session, perm);
    await cache.invalidateAll(session);
    return inserted;
  }

  /// Creates multiple permissions in bulk using [RbacPermission.db.insert].
  Future<List<RbacPermission>> createPermissions(
    Session session,
    List<RbacPermission> permissions,
  ) async {
    if (permissions.isEmpty) return const [];

    final normalized = permissions.map((p) {
      return p.copyWith(
        resource: p.resource.trim().toLowerCase(),
        codename: p.codename.trim().toLowerCase(),
        createdAt: DateTime.now(),
      );
    }).toList();

    final inserted = await RbacPermission.db.insert(
      session,
      normalized,
      ignoreConflicts: true,
    );
    await cache.invalidateAll(session);
    return inserted;
  }

  /// Lists registered permissions, optionally filtered by resource.
  Future<List<RbacPermission>> listPermissions(
    Session session, {
    String? resource,
  }) async {
    return RbacPermission.db.find(
      session,
      where: resource != null
          ? (t) => t.resource.equals(resource.trim().toLowerCase())
          : null,
      orderBy: (t) => t.resource,
    );
  }

  /// Deletes a permission by ID using [RbacPermission.db.deleteRow].
  Future<void> deletePermission(Session session, int permissionId) async {
    final perm = await RbacPermission.db.findById(session, permissionId);
    if (perm != null) {
      await RbacPermission.db.deleteRow(session, perm);
      await cache.invalidateAll(session);
    }
  }

  /// Deletes multiple permissions by IDs in bulk.
  Future<void> deletePermissions(Session session, List<int> permissionIds) async {
    if (permissionIds.isEmpty) return;
    final perms = await RbacPermission.db.find(
      session,
      where: (t) => t.id.inSet(permissionIds.toSet()),
    );
    if (perms.isNotEmpty) {
      await RbacPermission.db.delete(session, perms);
      await cache.invalidateAll(session);
    }
  }

  // ==========================================
  // MANAGEMENT: ROLES (Single & Bulk)
  // ==========================================

  /// Creates a single role using [RbacRole.db.insertRow].
  Future<RbacRole> createRole(
    Session session, {
    required String name,
    String? description,
    bool isSuperuser = false,
    bool isSystemRole = false,
  }) async {
    final normalized = name.trim().toLowerCase();
    final existing = await RbacRole.db.findFirstRow(
      session,
      where: (t) => t.name.equals(normalized),
    );
    if (existing != null) return existing;

    final role = RbacRole(
      name: normalized,
      description: description,
      isSuperuser: isSuperuser,
      isSystemRole: isSystemRole,
      createdAt: DateTime.now(),
    );

    final inserted = await RbacRole.db.insertRow(session, role);
    await cache.invalidateAll(session);
    return inserted;
  }

  /// Creates multiple roles in bulk using [RbacRole.db.insert].
  Future<List<RbacRole>> createRoles(
    Session session,
    List<RbacRole> roles,
  ) async {
    if (roles.isEmpty) return const [];

    final normalized = roles.map((r) {
      return r.copyWith(
        name: r.name.trim().toLowerCase(),
        createdAt: DateTime.now(),
      );
    }).toList();

    final inserted = await RbacRole.db.insert(
      session,
      normalized,
      ignoreConflicts: true,
    );
    await cache.invalidateAll(session);
    return inserted;
  }

  /// Retrieves a role by name.
  Future<RbacRole?> getRole(Session session, String name) async {
    return RbacRole.db.findFirstRow(
      session,
      where: (t) => t.name.equals(name.trim().toLowerCase()),
      include: RbacRole.include(
        permissions: RbacRolePermission.includeList(
          include: RbacRolePermission.include(
            permission: RbacPermission.include(),
          ),
        ),
      ),
    );
  }

  /// Lists all roles.
  Future<List<RbacRole>> listRoles(Session session) async {
    return RbacRole.db.find(
      session,
      orderBy: (t) => t.name,
      include: RbacRole.include(
        permissions: RbacRolePermission.includeList(
          include: RbacRolePermission.include(
            permission: RbacPermission.include(),
          ),
        ),
      ),
    );
  }

  /// Deletes a role by name using [RbacRole.db.deleteRow].
  Future<void> deleteRole(Session session, String name) async {
    final role = await getRole(session, name);
    if (role != null) {
      if (role.isSystemRole) {
        throw RbacException(
          message: 'Cannot delete system role "${role.name}"',
          reason: RbacExceptionReason.roleDenied,
        );
      }
      await RbacRole.db.deleteRow(session, role);
      await cache.invalidateAll(session);
    }
  }

  /// Deletes multiple roles by name in bulk.
  Future<void> deleteRoles(Session session, List<String> names) async {
    if (names.isEmpty) return;
    final normalized = names.map((n) => n.trim().toLowerCase()).toSet();
    final roles = await RbacRole.db.find(
      session,
      where: (t) => t.name.inSet(normalized),
    );
    final nonSystem = roles.where((r) => !r.isSystemRole).toList();
    if (nonSystem.isNotEmpty) {
      await RbacRole.db.delete(session, nonSystem);
      await cache.invalidateAll(session);
    }
  }

  // ==========================================
  // MANAGEMENT: ROLE PERMISSIONS (Bulk)
  // ==========================================

  /// Assigns one or more permissions to a role in bulk using [RbacRolePermission.db.insert].
  Future<void> assignPermissionsToRole(
    Session session, {
    required String roleName,
    required List<String> permissions,
  }) async {
    final role = await getRole(session, roleName);
    if (role == null || role.id == null) {
      throw RbacException(
        message: 'Role "$roleName" not found',
        reason: RbacExceptionReason.roleNotFound,
        requiredRole: roleName,
      );
    }

    final rowsToInsert = <RbacRolePermission>[];
    for (final permStr in permissions) {
      final (res, code) = parsePermission(permStr);
      final perm = await RbacPermission.db.findFirstRow(
        session,
        where: (t) => t.resource.equals(res) & t.codename.equals(code),
      );
      if (perm == null || perm.id == null) continue;

      rowsToInsert.add(
        RbacRolePermission(
          roleId: role.id!,
          permissionId: perm.id!,
          createdAt: DateTime.now(),
        ),
      );
    }

    if (rowsToInsert.isNotEmpty) {
      await RbacRolePermission.db.insert(
        session,
        rowsToInsert,
        ignoreConflicts: true,
        noReturn: true,
      );
    }

    await cache.invalidateAll(session);
  }

  /// Removes permissions from a role in bulk.
  Future<void> removePermissionsFromRole(
    Session session, {
    required String roleName,
    required List<String> permissions,
  }) async {
    final role = await getRole(session, roleName);
    if (role == null || role.id == null) return;

    for (final permStr in permissions) {
      final (res, code) = parsePermission(permStr);
      final perm = await RbacPermission.db.findFirstRow(
        session,
        where: (t) => t.resource.equals(res) & t.codename.equals(code),
      );
      if (perm == null || perm.id == null) continue;

      final existing = await RbacRolePermission.db.findFirstRow(
        session,
        where: (t) =>
            t.roleId.equals(role.id!) & t.permissionId.equals(perm.id!),
      );
      if (existing != null) {
        await RbacRolePermission.db.deleteRow(session, existing);
      }
    }

    await cache.invalidateAll(session);
  }

  /// Gets all permissions assigned to a role.
  Future<List<RbacPermission>> getRolePermissions(
    Session session,
    String roleName,
  ) async {
    final role = await getRole(session, roleName);
    if (role == null || role.id == null) return const [];

    final rolePerms = await RbacRolePermission.db.find(
      session,
      where: (t) => t.roleId.equals(role.id!),
      include: RbacRolePermission.include(
        permission: RbacPermission.include(),
      ),
    );
    return rolePerms
        .map((rp) => rp.permission)
        .whereType<RbacPermission>()
        .toList();
  }

  // ==========================================
  // MANAGEMENT: USER ROLES & DOMAINS (Single & Bulk)
  // ==========================================

  /// Assigns a role to a user using [RbacUserRole.db.insertRow].
  Future<RbacUserRole> assignRoleToUser(
    Session session, {
    required String userIdentifier,
    required String roleName,
    String? domain,
  }) async {
    final role = await getRole(session, roleName);
    if (role == null || role.id == null) {
      throw RbacException(
        message: 'Role "$roleName" not found',
        reason: RbacExceptionReason.roleNotFound,
        requiredRole: roleName,
      );
    }

    final normalizedDomain = domain?.trim();
    final existing = await RbacUserRole.db.findFirstRow(
      session,
      where: (t) =>
          t.userIdentifier.equals(userIdentifier) &
          t.roleId.equals(role.id!) &
          (normalizedDomain == null
              ? t.domain.equals(null)
              : t.domain.equals(normalizedDomain)),
    );

    if (existing != null) return existing;

    final userRole = RbacUserRole(
      userIdentifier: userIdentifier,
      roleId: role.id!,
      domain: normalizedDomain,
      createdAt: DateTime.now(),
    );

    final inserted = await RbacUserRole.db.insertRow(session, userRole);
    await cache.invalidateUser(session, userIdentifier);
    return inserted;
  }

  /// Assigns multiple roles to a user in bulk using [RbacUserRole.db.insert].
  Future<void> assignRolesToUser(
    Session session, {
    required String userIdentifier,
    required List<String> roleNames,
    String? domain,
  }) async {
    if (roleNames.isEmpty) return;

    final normalizedNames = roleNames.map((n) => n.trim().toLowerCase()).toSet();
    final roles = await RbacRole.db.find(
      session,
      where: (t) => t.name.inSet(normalizedNames),
    );

    final normalizedDomain = domain?.trim();
    final rows = roles.map((r) {
      return RbacUserRole(
        userIdentifier: userIdentifier,
        roleId: r.id!,
        domain: normalizedDomain,
        createdAt: DateTime.now(),
      );
    }).toList();

    if (rows.isNotEmpty) {
      await RbacUserRole.db.insert(
        session,
        rows,
        ignoreConflicts: true,
        noReturn: true,
      );
      await cache.invalidateUser(session, userIdentifier);
    }
  }

  /// Assigns a role to multiple users in bulk using [RbacUserRole.db.insert].
  Future<void> assignRoleToUsers(
    Session session, {
    required List<String> userIdentifiers,
    required String roleName,
    String? domain,
  }) async {
    if (userIdentifiers.isEmpty) return;

    final role = await getRole(session, roleName);
    if (role == null || role.id == null) {
      throw RbacException(
        message: 'Role "$roleName" not found',
        reason: RbacExceptionReason.roleNotFound,
        requiredRole: roleName,
      );
    }

    final normalizedDomain = domain?.trim();
    final rows = userIdentifiers.toSet().map((uid) {
      return RbacUserRole(
        userIdentifier: uid,
        roleId: role.id!,
        domain: normalizedDomain,
        createdAt: DateTime.now(),
      );
    }).toList();

    if (rows.isNotEmpty) {
      await RbacUserRole.db.insert(
        session,
        rows,
        ignoreConflicts: true,
        noReturn: true,
      );
      for (final uid in userIdentifiers) {
        await cache.invalidateUser(session, uid);
      }
    }
  }

  /// Assigns a role to a user across multiple domains in bulk using [RbacUserRole.db.insert].
  Future<void> assignRoleToUserDomains(
    Session session, {
    required String userIdentifier,
    required String roleName,
    required List<String> domains,
  }) async {
    if (domains.isEmpty) return;

    final role = await getRole(session, roleName);
    if (role == null || role.id == null) {
      throw RbacException(
        message: 'Role "$roleName" not found',
        reason: RbacExceptionReason.roleNotFound,
        requiredRole: roleName,
      );
    }

    final rows = domains.toSet().map((d) {
      return RbacUserRole(
        userIdentifier: userIdentifier,
        roleId: role.id!,
        domain: d.trim(),
        createdAt: DateTime.now(),
      );
    }).toList();

    if (rows.isNotEmpty) {
      await RbacUserRole.db.insert(
        session,
        rows,
        ignoreConflicts: true,
        noReturn: true,
      );
      await cache.invalidateUser(session, userIdentifier);
    }
  }

  /// Removes a role from a user using [RbacUserRole.db.deleteRow].
  Future<void> removeRoleFromUser(
    Session session, {
    required String userIdentifier,
    required String roleName,
    String? domain,
  }) async {
    final role = await getRole(session, roleName);
    if (role == null || role.id == null) return;

    final normalizedDomain = domain?.trim();
    final existing = await RbacUserRole.db.find(
      session,
      where: (t) =>
          t.userIdentifier.equals(userIdentifier) &
          t.roleId.equals(role.id!) &
          (normalizedDomain == null
              ? (t.domain.equals(null) | t.domain.notEquals(null))
              : t.domain.equals(normalizedDomain)),
    );

    if (existing.isNotEmpty) {
      await RbacUserRole.db.delete(session, existing);
      await cache.invalidateUser(session, userIdentifier);
    }
  }

  /// Removes multiple roles from a user in bulk.
  Future<void> removeRolesFromUser(
    Session session, {
    required String userIdentifier,
    required List<String> roleNames,
    String? domain,
  }) async {
    if (roleNames.isEmpty) return;

    final normalized = roleNames.map((n) => n.trim().toLowerCase()).toSet();
    final roles = await RbacRole.db.find(
      session,
      where: (t) => t.name.inSet(normalized),
    );
    final roleIds = roles.map((r) => r.id!).toSet();

    final normalizedDomain = domain?.trim();
    final rows = await RbacUserRole.db.find(
      session,
      where: (t) =>
          t.userIdentifier.equals(userIdentifier) &
          t.roleId.inSet(roleIds) &
          (normalizedDomain == null
              ? (t.domain.equals(null) | t.domain.notEquals(null))
              : t.domain.equals(normalizedDomain)),
    );

    if (rows.isNotEmpty) {
      await RbacUserRole.db.delete(session, rows);
      await cache.invalidateUser(session, userIdentifier);
    }
  }

  /// Lists all roles assigned to a user, optionally filtered by domain.
  Future<List<RbacRole>> getUserRoles(
    Session session,
    String userIdentifier, {
    String? domain,
  }) async {
    final assignments = await getUserRoleAssignments(session, userIdentifier);
    final roles = <RbacRole>[];
    final seen = <int>{};

    for (final ur in assignments) {
      final role = ur.role;
      if (role == null || role.id == null) continue;
      if (domain != null && ur.domain != null && ur.domain != domain) {
        continue;
      }
      if (seen.add(role.id!)) {
        roles.add(role);
      }
    }
    return roles;
  }

  /// Lists all user-role assignment records matching filters.
  Future<List<RbacUserRole>> listUserRoles(
    Session session, {
    String? userIdentifier,
    String? roleName,
    String? domain,
  }) async {
    int? roleId;
    if (roleName != null) {
      final r = await getRole(session, roleName);
      roleId = r?.id;
      if (roleId == null) return const [];
    }

    return RbacUserRole.db.find(
      session,
      where: (t) {
        Expression expr = Constant.bool(true);
        if (userIdentifier != null) {
          expr = expr & t.userIdentifier.equals(userIdentifier);
        }
        if (roleId != null) {
          expr = expr & t.roleId.equals(roleId);
        }
        if (domain != null) {
          expr = expr & t.domain.equals(domain);
        }
        return expr;
      },
      include: RbacUserRole.include(
        role: RbacRole.include(),
      ),
      orderBy: (t) => t.createdAt,
    );
  }
}
