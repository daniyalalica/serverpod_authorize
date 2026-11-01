import 'package:serverpod/serverpod.dart';
import 'generated/protocol.dart';
import 'rbac_service.dart';

/// Attribute-Based Access Control (ABAC) service for domain-aware authorization.
///
/// Returns domains stored in RBAC so developers can feed them into query filters
/// (e.g. using `serverpod_filters` or native Serverpod expressions).
class AbacService {
  /// Singleton instance.
  static final AbacService instance = AbacService._();
  AbacService._();

  /// Evaluates domain access for a specific permission.
  ///
  /// Returns a [RbacAbacResult] detailing:
  /// - `isAllowed`: Whether the user has access (globally or within specific domains).
  /// - `hasDomains`: `true` if access is restricted to specific domains (developer should apply filters).
  /// - `domains`: The list of domains the user is granted access to.
  /// - `isUnrestricted`: `true` if access is global / unrestricted (no domain filtering needed).
  Future<RbacAbacResult> getDomainAccess(
    Session session, {
    required String permission,
    String? userIdentifier,
  }) async {
    final uid = RbacService.instance.getUserIdentifier(session, userIdentifier);
    if (uid == null) {
      return RbacAbacResult(
        userIdentifier: '',
        permission: permission,
        isAllowed: false,
        hasDomains: false,
        domains: const [],
        isUnrestricted: false,
      );
    }

    // 1. Check superuser status
    final isSuper = await RbacService.instance.isSuperuser(
      session,
      userIdentifier: uid,
    );
    if (isSuper) {
      return RbacAbacResult(
        userIdentifier: uid,
        permission: permission,
        isAllowed: true,
        hasDomains: false,
        domains: const [],
        isUnrestricted: true,
      );
    }

    final (resource, codename) = RbacService.parsePermission(permission);
    final userRoles = await RbacService.instance.getUserRoleAssignments(session, uid);

    bool isUnrestricted = false;
    final grantedDomains = <String>{};
    bool permissionFound = false;

    for (final ur in userRoles) {
      final role = ur.role;
      if (role == null) continue;

      if (role.isSuperuser) {
        return RbacAbacResult(
          userIdentifier: uid,
          permission: permission,
          isAllowed: true,
          hasDomains: false,
          domains: const [],
          isUnrestricted: true,
        );
      }

      final rolePermissions = role.permissions ?? [];
      final matches = rolePermissions.any((rp) {
        final p = rp.permission;
        if (p == null) return false;
        return RbacService.matchesPermission(
          targetResource: resource,
          targetCodename: codename,
          permissionResource: p.resource,
          permissionCodename: p.codename,
        );
      });

      if (matches) {
        permissionFound = true;
        if (ur.domain == null || ur.domain!.isEmpty) {
          isUnrestricted = true;
        } else {
          grantedDomains.add(ur.domain!);
        }
      }
    }

    if (!permissionFound) {
      return RbacAbacResult(
        userIdentifier: uid,
        permission: permission,
        isAllowed: false,
        hasDomains: false,
        domains: const [],
        isUnrestricted: false,
      );
    }

    if (isUnrestricted) {
      return RbacAbacResult(
        userIdentifier: uid,
        permission: permission,
        isAllowed: true,
        hasDomains: false,
        domains: const [],
        isUnrestricted: true,
      );
    }

    return RbacAbacResult(
      userIdentifier: uid,
      permission: permission,
      isAllowed: true,
      hasDomains: grantedDomains.isNotEmpty,
      domains: grantedDomains.toList(),
      isUnrestricted: false,
    );
  }

  /// Checks if the user has domain-restricted access for [permission].
  ///
  /// Returns `true` if the developer should filter by domains, `false` otherwise.
  Future<bool> hasDomains(
    Session session, {
    required String permission,
    String? userIdentifier,
  }) async {
    final result = await getDomainAccess(
      session,
      permission: permission,
      userIdentifier: userIdentifier,
    );
    return result.hasDomains;
  }

  /// Returns the stored domains granted for [permission].
  ///
  /// If the user has unrestricted (global) access, returns an empty list
  /// (use [hasDomains] to distinguish between unrestricted and no access).
  Future<List<String>> getDomains(
    Session session, {
    required String permission,
    String? userIdentifier,
  }) async {
    final result = await getDomainAccess(
      session,
      permission: permission,
      userIdentifier: userIdentifier,
    );
    return result.domains;
  }

  /// Evaluates domain access for a specific role name.
  Future<RbacAbacResult> getRoleDomainAccess(
    Session session, {
    required String roleName,
    String? userIdentifier,
  }) async {
    final uid = RbacService.instance.getUserIdentifier(session, userIdentifier);
    if (uid == null) {
      return RbacAbacResult(
        userIdentifier: '',
        roleName: roleName,
        isAllowed: false,
        hasDomains: false,
        domains: const [],
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
        isAllowed: true,
        hasDomains: false,
        domains: const [],
        isUnrestricted: true,
      );
    }

    final userRoles = await RbacService.instance.getUserRoleAssignments(session, uid);
    final normalizedRole = roleName.trim().toLowerCase();

    bool isUnrestricted = false;
    final grantedDomains = <String>{};
    bool roleFound = false;

    for (final ur in userRoles) {
      final role = ur.role;
      if (role == null) continue;
      if (role.name.trim().toLowerCase() == normalizedRole) {
        roleFound = true;
        if (ur.domain == null || ur.domain!.isEmpty) {
          isUnrestricted = true;
        } else {
          grantedDomains.add(ur.domain!);
        }
      }
    }

    if (!roleFound) {
      return RbacAbacResult(
        userIdentifier: uid,
        roleName: roleName,
        isAllowed: false,
        hasDomains: false,
        domains: const [],
        isUnrestricted: false,
      );
    }

    if (isUnrestricted) {
      return RbacAbacResult(
        userIdentifier: uid,
        roleName: roleName,
        isAllowed: true,
        hasDomains: false,
        domains: const [],
        isUnrestricted: true,
      );
    }

    return RbacAbacResult(
      userIdentifier: uid,
      roleName: roleName,
      isAllowed: true,
      hasDomains: grantedDomains.isNotEmpty,
      domains: grantedDomains.toList(),
      isUnrestricted: false,
    );
  }

  /// Checks if the user has domain-restricted access for [roleName].
  Future<bool> hasDomainsForRole(
    Session session, {
    required String roleName,
    String? userIdentifier,
  }) async {
    final result = await getRoleDomainAccess(
      session,
      roleName: roleName,
      userIdentifier: userIdentifier,
    );
    return result.hasDomains;
  }

  /// Returns the stored domains granted for [roleName].
  Future<List<String>> getDomainsForRole(
    Session session, {
    required String roleName,
    String? userIdentifier,
  }) async {
    final result = await getRoleDomainAccess(
      session,
      roleName: roleName,
      userIdentifier: userIdentifier,
    );
    return result.domains;
  }

  /// Returns all distinct domains assigned to the user across all their roles.
  Future<List<String>> getAllDomains(
    Session session, {
    String? userIdentifier,
  }) async {
    final uid = RbacService.instance.getUserIdentifier(session, userIdentifier);
    if (uid == null) return const [];

    final userRoles = await RbacService.instance.getUserRoleAssignments(session, uid);
    final domains = <String>{};
    for (final ur in userRoles) {
      if (ur.domain != null && ur.domain!.isNotEmpty) {
        domains.add(ur.domain!);
      }
    }
    return domains.toList();
  }

  /// Returns all distinct domains recorded across all user role assignments in the database.
  Future<List<String>> listAllDomains(Session session) async {
    final rows = await RbacUserRole.db.find(
      session,
      where: (t) => t.domain.notEquals(null),
    );
    final domains = <String>{};
    for (final row in rows) {
      if (row.domain != null && row.domain!.isNotEmpty) {
        domains.add(row.domain!);
      }
    }
    return domains.toList()..sort();
  }
}
