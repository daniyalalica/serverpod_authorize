import 'package:serverpod/serverpod.dart';
import 'generated/protocol.dart';
import 'rbac_service.dart';

/// Attribute-Based Access Control (ABAC) service.
///
/// Returns Odoo-style domain filter expressions stored on roles so that
/// developers can apply fine-grained row-level security.
///
/// Expressions are stored and returned as JSON strings. This package does not
/// validate or compile them; applications can pass supported expressions to a
/// separately installed filtering library such as `serverpod_filters_server`.
///
/// ## Concept
/// An ABAC domain rule is a filter expression stored on a role:
/// ```
/// [['status', '=', 'draft'], ['owner_id', '=', 42]]
/// ```
/// When a user has a role with domain rules for resource `'articles'` and
/// permission `'articles.read'`, calling `getDomainAccess` returns those
/// filter expressions. The developer then passes them to
/// `ServerpodFilters.where()` from their separately installed filter package.
///
/// ## Flow
/// 1. `hasDomains` = `true` → access is granted but row-level filters apply
/// 2. `hasDomains` = `false` + `isAllowed` = `true` → unrestricted access
/// 3. `isAllowed` = `false` → no access at all
class AbacService {
  /// Singleton instance.
  static final AbacService instance = AbacService._();
  AbacService._();

  // =========================================================================
  // DOMAIN RULE MANAGEMENT
  // =========================================================================

  /// Stores a domain filter rule on a role for a specific [resource].
  ///
  /// [roleName] - the role to attach the rule to.
  /// [resource] - the resource/model name this rule applies to (e.g. `'articles'`).
  /// [permission] - optional specific permission (e.g. `'invoice.create'`).
  ///   When omitted, the rule applies to all permissions on the resource.
  /// [filterExpression] - an Odoo-style filter JSON string,
  ///   e.g. `'[["status", "=", "draft"]]'` or `'[["owner_id", "=", 42]]'`.
  /// [description] - optional human-readable description of the rule.
  ///
  /// Returns the created [RbacDomainRule].
  Future<RbacDomainRule> addDomainRule(
    Session session, {
    required String roleName,
    required String resource,
    required String filterExpression,
    String? permission,
    String? description,
  }) async {
    final normalizedRoleName = roleName.trim().toLowerCase();
    final normalizedResource = _normalizeResource(resource);
    final normalizedPermission = permission == null
        ? null
        : _normalizePermission(permission);
    final normalizedExpression = _normalizeFilterExpression(filterExpression);

    final role = await RbacRole.db.findFirstRow(
      session,
      where: (t) => t.name.equals(normalizedRoleName),
    );
    if (role == null || role.id == null) {
      throw RbacException(
        message: 'Role "$roleName" not found',
        reason: RbacExceptionReason.roleNotFound,
      );
    }

    final rule = await RbacDomainRule.db.insertRow(
      session,
      RbacDomainRule(
        roleId: role.id!,
        resource: normalizedResource,
        permission: normalizedPermission,
        filterExpression: normalizedExpression,
        description: description,
      ),
    );

    await RbacService.instance.cache.invalidateAll(session);
    return rule;
  }

  /// Stores multiple domain filter rules in bulk using [insert].
  Future<List<RbacDomainRule>> addDomainRules(
    Session session,
    List<RbacDomainRule> rules,
  ) async {
    if (rules.isEmpty) return const [];

    final normalizedRules = rules
        .map(
          (rule) => rule.copyWith(
            resource: _normalizeResource(rule.resource),
            permission: rule.permission == null
                ? null
                : _normalizePermission(rule.permission!),
            filterExpression: _normalizeFilterExpression(
              rule.filterExpression,
            ),
          ),
        )
        .toList(growable: false);
    final inserted = await RbacDomainRule.db.insert(session, normalizedRules);
    await RbacService.instance.cache.invalidateAll(session);
    return inserted;
  }

  /// Removes a domain rule by ID.
  Future<void> removeDomainRule(Session session, int ruleId) async {
    final rule = await RbacDomainRule.db.findById(session, ruleId);
    if (rule != null) {
      await RbacDomainRule.db.deleteRow(session, rule);
      await RbacService.instance.cache.invalidateAll(session);
    }
  }

  /// Removes all domain rules for a role and optionally a specific [resource].
  Future<void> clearDomainRules(
    Session session, {
    required String roleName,
    String? resource,
    String? permission,
  }) async {
    final role = await RbacRole.db.findFirstRow(
      session,
      where: (t) => t.name.equals(roleName.trim().toLowerCase()),
    );
    if (role == null || role.id == null) return;

    final normalizedResource = resource == null
        ? null
        : _normalizeResource(resource);
    final normalizedPermission = permission == null
        ? null
        : _normalizePermission(permission);
    await RbacDomainRule.db.deleteWhere(
      session,
      where: (t) {
        var where = t.roleId.equals(role.id!);
        if (normalizedResource != null) {
          where = where & t.resource.equals(normalizedResource);
        }
        if (normalizedPermission != null) {
          where = where & t.permission.equals(normalizedPermission);
        }
        return where;
      },
    );

    await RbacService.instance.cache.invalidateAll(session);
  }

  /// Lists all domain rules for [roleName], optionally filtered by [resource].
  Future<List<RbacDomainRule>> listDomainRules(
    Session session, {
    required String roleName,
    String? resource,
    String? permission,
  }) async {
    final role = await RbacRole.db.findFirstRow(
      session,
      where: (t) => t.name.equals(roleName.trim().toLowerCase()),
    );
    if (role == null || role.id == null) return const [];

    return RbacDomainRule.db.find(
      session,
      where: (t) {
        var where = t.roleId.equals(role.id!);
        if (resource != null) {
          where = where & t.resource.equals(_normalizeResource(resource));
        }
        if (permission != null) {
          where = where & t.permission.equals(_normalizePermission(permission));
        }
        return where;
      },
    );
  }

  // =========================================================================
  // ABAC EVALUATION
  // =========================================================================

  /// Evaluates domain filter access for a specific [permission] and [resource].
  ///
  /// Returns an [RbacAbacResult] with:
  /// - `isAllowed`: user has the permission (via roles or superuser).
  /// - `hasDomains`: `true` if row-level filter expressions apply.
  /// - `filterExpressions`: list of Odoo-style JSON filter strings.
  ///   Pass each to `ServerpodFilters.where()` and OR-combine them.
  /// - `isUnrestricted`: `true` if user has access with no row-level filter.
  ///
  /// [resource] is the model/table name (e.g. `'articles'`). Defaults to the
  /// resource portion of the [permission] string. Rules with an exact
  /// permission, a matching permission wildcard, or no permission (legacy
  /// resource-wide rule) are included.
  Future<RbacAbacResult> getDomainAccess(
    Session session, {
    required String permission,
    String? resource,
    String? userIdentifier,
  }) async {
    final (targetResource, targetCodename) = RbacService.parsePermission(
      permission,
    );
    final normalizedPermission = RbacService.formatPermissionKey(
      targetResource,
      targetCodename,
    );
    final effectiveResource = resource == null
        ? targetResource
        : _normalizeResource(resource);

    final uid = RbacService.instance.getUserIdentifier(session, userIdentifier);
    if (uid == null) {
      return RbacAbacResult(
        userIdentifier: '',
        permission: permission,
        resource: effectiveResource,
        isAllowed: false,
        hasDomains: false,
        filterExpressions: const [],
        isUnrestricted: false,
      );
    }

    final rbac = RbacService.instance;
    if (session.authenticated?.userIdentifier == uid &&
        session.authenticated?.scopes.contains(Scope.admin) == true) {
      return RbacAbacResult(
        userIdentifier: uid,
        permission: permission,
        resource: effectiveResource,
        isAllowed: true,
        hasDomains: false,
        filterExpressions: const [],
        isUnrestricted: true,
      );
    }

    if (rbac.customSuperuserResolver != null &&
        await rbac.customSuperuserResolver!(session, uid)) {
      return RbacAbacResult(
        userIdentifier: uid,
        permission: permission,
        resource: effectiveResource,
        isAllowed: true,
        hasDomains: false,
        filterExpressions: const [],
        isUnrestricted: true,
      );
    }

    final cached = await rbac.cache.getDomainAccess(
      session,
      userIdentifier: uid,
      resource: effectiveResource,
      permission: permission,
    );
    if (cached != null) return cached;

    Future<RbacAbacResult> cacheResult(RbacAbacResult result) async {
      await rbac.cache.putDomainAccess(
        session,
        userIdentifier: uid,
        resource: effectiveResource,
        permission: permission,
        result: result,
      );
      return result;
    }

    final userRoles = await rbac.getUserRoleAssignments(session, uid);

    final matchingRoleIds = <int>{};

    for (final ur in userRoles) {
      final role = ur.role;
      if (role == null) continue;

      if (role.isSuperuser) {
        return cacheResult(
          RbacAbacResult(
            userIdentifier: uid,
            permission: permission,
            resource: effectiveResource,
            isAllowed: true,
            hasDomains: false,
            filterExpressions: const [],
            isUnrestricted: true,
          ),
        );
      }

      // Check if this role grants the requested permission
      final rolePermissions = role.permissions ?? <RbacRolePermission>[];
      final hasPermission = rolePermissions.any((rp) {
        final p = rp.permission;
        if (p == null) return false;
        return RbacService.matchesPermission(
          targetResource: targetResource,
          targetCodename: targetCodename,
          permissionResource: p.resource,
          permissionCodename: p.codename,
        );
      });

      if (!hasPermission) continue;
      if (role.id == null) continue;
      matchingRoleIds.add(role.id!);
    }

    if (matchingRoleIds.isEmpty) {
      return cacheResult(
        RbacAbacResult(
          userIdentifier: uid,
          permission: permission,
          resource: effectiveResource,
          isAllowed: false,
          hasDomains: false,
          filterExpressions: const [],
          isUnrestricted: false,
        ),
      );
    }

    final rules = await _loadDomainRulesForRoles(
      session,
      roleIds: matchingRoleIds,
      resource: effectiveResource,
      permission: normalizedPermission,
    );
    final restrictedRoleIds = rules.map((rule) => rule.roleId).toSet();

    // If ANY role grants unrestricted access, skip domain filtering entirely
    if (matchingRoleIds.any((roleId) => !restrictedRoleIds.contains(roleId))) {
      return cacheResult(
        RbacAbacResult(
          userIdentifier: uid,
          permission: permission,
          resource: effectiveResource,
          isAllowed: true,
          hasDomains: false,
          filterExpressions: const [],
          isUnrestricted: true,
        ),
      );
    }

    final expressions = rules
        .map((rule) => rule.filterExpression)
        .toSet()
        .toList();
    return cacheResult(
      RbacAbacResult(
        userIdentifier: uid,
        permission: permission,
        resource: effectiveResource,
        isAllowed: true,
        hasDomains: expressions.isNotEmpty,
        filterExpressions: expressions,
        isUnrestricted: false,
      ),
    );
  }

  /// Evaluates domain filter access scoped to a [roleName].
  ///
  /// If [resource] or [permission] is omitted, rules across that dimension are
  /// returned. Such a result is useful for inspection but must not be applied
  /// to a query without first selecting the rules for that query's resource
  /// and permission.
  Future<RbacAbacResult> getRoleDomainAccess(
    Session session, {
    required String roleName,
    String? resource,
    String? permission,
    String? userIdentifier,
  }) async {
    final effectiveResource = resource == null
        ? null
        : _normalizeResource(resource);
    final normalizedPermission = permission == null
        ? null
        : _normalizePermission(permission);
    final uid = RbacService.instance.getUserIdentifier(session, userIdentifier);
    if (uid == null) {
      return RbacAbacResult(
        userIdentifier: '',
        roleName: roleName,
        resource: effectiveResource,
        isAllowed: false,
        hasDomains: false,
        filterExpressions: const [],
        isUnrestricted: false,
      );
    }

    final isSuper = await RbacService.instance.isSuperuser(
      session,
      userIdentifier: uid,
    );
    if (isSuper) {
      return RbacAbacResult(
        userIdentifier: uid,
        roleName: roleName,
        resource: effectiveResource,
        isAllowed: true,
        hasDomains: false,
        filterExpressions: const [],
        isUnrestricted: true,
      );
    }

    final userRoles = await RbacService.instance.getUserRoleAssignments(
      session,
      uid,
    );
    final normalizedRole = roleName.trim().toLowerCase();

    final matchingRoleIds = <int>{};

    for (final ur in userRoles) {
      final role = ur.role;
      if (role == null) continue;
      if (role.isSuperuser) {
        return RbacAbacResult(
          userIdentifier: uid,
          roleName: roleName,
          resource: effectiveResource,
          isAllowed: true,
          hasDomains: false,
          filterExpressions: const [],
          isUnrestricted: true,
        );
      }
      if (role.name.trim().toLowerCase() != normalizedRole) continue;
      if (role.id == null) continue;
      matchingRoleIds.add(role.id!);
    }

    if (matchingRoleIds.isEmpty) {
      return RbacAbacResult(
        userIdentifier: uid,
        roleName: roleName,
        resource: effectiveResource,
        isAllowed: false,
        hasDomains: false,
        filterExpressions: const [],
        isUnrestricted: false,
      );
    }

    final rules = await _loadDomainRulesForRoles(
      session,
      roleIds: matchingRoleIds,
      resource: effectiveResource,
      permission: normalizedPermission,
    );
    final expressions = rules
        .map((rule) => rule.filterExpression)
        .toSet()
        .toList();
    return RbacAbacResult(
      userIdentifier: uid,
      roleName: roleName,
      resource: effectiveResource,
      isAllowed: true,
      hasDomains: expressions.isNotEmpty,
      filterExpressions: expressions,
      isUnrestricted: expressions.isEmpty,
    );
  }

  /// Returns `true` if row-level domain filter expressions apply for [permission].
  ///
  /// When `true`, the developer must apply [getDomainFilters] to queries.
  /// When `false` (and user has access), the developer may query without filters.
  Future<bool> hasDomains(
    Session session, {
    required String permission,
    String? resource,
    String? userIdentifier,
  }) async {
    final result = await getDomainAccess(
      session,
      permission: permission,
      resource: resource,
      userIdentifier: userIdentifier,
    );
    return result.hasDomains;
  }

  /// Returns the Odoo-style JSON filter expressions for [permission].
  ///
  /// These strings can be passed directly to `ServerpodFilters.where()`.
  /// An empty list means unrestricted access (check `isAllowed` separately).
  Future<List<String>> getDomainFilters(
    Session session, {
    required String permission,
    String? resource,
    String? userIdentifier,
  }) async {
    final result = await getDomainAccess(
      session,
      permission: permission,
      resource: resource,
      userIdentifier: userIdentifier,
    );
    return result.filterExpressions;
  }

  /// Returns all distinct filter expressions across all roles for the user.
  ///
  /// Optionally filtered by [resource].
  Future<List<String>> getAllDomainFilters(
    Session session, {
    String? resource,
    String? permission,
    String? userIdentifier,
  }) async {
    final uid = RbacService.instance.getUserIdentifier(session, userIdentifier);
    if (uid == null) return const [];

    final normalizedResource = resource == null
        ? null
        : _normalizeResource(resource);
    final normalizedPermission = permission == null
        ? null
        : _normalizePermission(permission);
    final userRoles = await RbacService.instance.getUserRoleAssignments(
      session,
      uid,
    );
    final roleIds = userRoles
        .map((assignment) => assignment.role?.id)
        .whereType<int>()
        .toSet();
    if (roleIds.isEmpty) return const [];

    final rules = await _loadDomainRulesForRoles(
      session,
      roleIds: roleIds,
      resource: normalizedResource,
      permission: normalizedPermission,
    );
    return rules.map((rule) => rule.filterExpression).toSet().toList();
  }

  // =========================================================================
  // PRIVATE HELPERS
  // =========================================================================

  Future<List<RbacDomainRule>> _loadDomainRulesForRoles(
    Session session, {
    required Set<int> roleIds,
    String? resource,
    String? permission,
  }) async {
    return RbacDomainRule.db.find(
      session,
      where: (t) {
        var where = t.roleId.inSet(roleIds);
        if (resource != null) {
          where = where & t.resource.equals(resource);
        }
        if (permission != null) {
          where =
              where &
              (t.permission.equals(null) |
                  t.permission.inSet(_permissionPatterns(permission)));
        }
        return where;
      },
    );
  }

  String _normalizeResource(String resource) {
    final normalized = resource.trim().toLowerCase();
    if (normalized.isEmpty) {
      throw ArgumentError.value(resource, 'resource', 'Must not be empty.');
    }
    return normalized;
  }

  String _normalizeFilterExpression(String filterExpression) {
    final normalized = filterExpression.trim();
    if (normalized.isEmpty) {
      throw ArgumentError.value(
        filterExpression,
        'filterExpression',
        'Must not be empty.',
      );
    }
    return normalized;
  }

  String _normalizePermission(String permission) {
    final trimmed = permission.trim().toLowerCase();
    if (!trimmed.contains('.')) {
      throw ArgumentError.value(
        permission,
        'permission',
        'Must include a resource and codename, for example "invoice.create".',
      );
    }
    final (resource, codename) = RbacService.parsePermission(permission);
    if (resource.isEmpty || codename.isEmpty) {
      throw ArgumentError.value(
        permission,
        'permission',
        'Must include a resource and codename, for example "invoice.create".',
      );
    }
    return RbacService.formatPermissionKey(resource, codename);
  }

  Set<String> _permissionPatterns(String permission) {
    final (resource, codename) = RbacService.parsePermission(permission);
    return {
      RbacService.formatPermissionKey(resource, codename),
      RbacService.formatPermissionKey(resource, '*'),
      RbacService.formatPermissionKey('*', codename),
      '*.*',
    };
  }
}
