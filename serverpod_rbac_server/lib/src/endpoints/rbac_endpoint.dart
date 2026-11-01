import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../session_rbac_extension.dart';

/// Endpoint allowing authenticated clients to inspect their own RBAC permissions,
/// roles, and ABAC domains.
class RbacEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Checks if the current authenticated user is a superuser.
  Future<bool> isSuperuser(Session session) async {
    return session.rbac.isSuperuser();
  }

  /// Retrieves the current authenticated user's permissions, roles, and domains snapshot.
  Future<RbacUserPermissionsInfo> getMyPermissions(Session session) async {
    final info = await session.rbac.getPermissionsInfo();
    if (info == null) {
      throw RbacException(
        message: 'Unable to resolve permissions for unauthenticated user',
        reason: RbacExceptionReason.notAuthenticated,
      );
    }
    return info;
  }

  /// Retrieves the current authenticated user's assigned role names.
  Future<List<String>> getMyRoles(Session session, {String? domain}) async {
    return session.rbac.getRoles(domain: domain);
  }

  /// Retrieves the domains granted to the current user, optionally filtered by permission.
  Future<List<String>> getMyDomains(Session session, {String? permission}) async {
    if (permission != null) {
      return session.rbac.getDomains(permission);
    }
    return session.rbac.abac.getAllDomains();
  }

  /// Checks if access to [permission] is domain-restricted for the current user.
  Future<bool> hasDomains(Session session, String permission) async {
    return session.rbac.hasDomains(permission);
  }

  /// Retrieves full domain access details for [permission] for the current user.
  Future<RbacAbacResult> getMyDomainAccess(Session session, String permission) async {
    return session.rbac.getDomainAccess(permission);
  }

  /// Checks if the current authenticated user has a specific permission.
  Future<bool> hasPermission(
    Session session,
    String permission, {
    String? domain,
  }) async {
    return session.rbac.hasPermission(permission, domain: domain);
  }

  /// Checks if the current authenticated user has all specified permissions.
  Future<bool> hasAllPermissions(
    Session session,
    List<String> permissions, {
    String? domain,
  }) async {
    return session.rbac.hasAllPermissions(permissions, domain: domain);
  }

  /// Checks if the current authenticated user has any specified permission.
  Future<bool> hasAnyPermission(
    Session session,
    List<String> permissions, {
    String? domain,
  }) async {
    return session.rbac.hasAnyPermission(permissions, domain: domain);
  }

  /// Checks if the current authenticated user has a specific role.
  Future<bool> hasRole(
    Session session,
    String role, {
    String? domain,
  }) async {
    return session.rbac.hasRole(role, domain: domain);
  }

  /// Checks if the current authenticated user has any specified role.
  Future<bool> hasAnyRole(
    Session session,
    List<String> roles, {
    String? domain,
  }) async {
    return session.rbac.hasAnyRole(roles, domain: domain);
  }

  /// Checks if the current authenticated user has all specified roles.
  Future<bool> hasAllRoles(
    Session session,
    List<String> roles, {
    String? domain,
  }) async {
    return session.rbac.hasAllRoles(roles, domain: domain);
  }

  /// Enforces that the current authenticated user has [permission].
  Future<void> requirePermission(
    Session session,
    String permission, {
    String? domain,
  }) async {
    await session.rbac.requirePermission(permission, domain: domain);
  }

  /// Enforces that the current authenticated user has all [permissions].
  Future<void> requireAllPermissions(
    Session session,
    List<String> permissions, {
    String? domain,
  }) async {
    await session.rbac.requireAllPermissions(permissions, domain: domain);
  }

  /// Enforces that the current authenticated user has any [permissions].
  Future<void> requireAnyPermission(
    Session session,
    List<String> permissions, {
    String? domain,
  }) async {
    await session.rbac.requireAnyPermission(permissions, domain: domain);
  }

  /// Enforces that the current authenticated user has [role].
  Future<void> requireRole(
    Session session,
    String role, {
    String? domain,
  }) async {
    await session.rbac.requireRole(role, domain: domain);
  }

  /// Enforces that the current authenticated user has all [roles].
  Future<void> requireAllRoles(
    Session session,
    List<String> roles, {
    String? domain,
  }) async {
    await session.rbac.requireAllRoles(roles, domain: domain);
  }

  /// Enforces that the current authenticated user has any [roles].
  Future<void> requireAnyRole(
    Session session,
    List<String> roles, {
    String? domain,
  }) async {
    await session.rbac.requireAnyRole(roles, domain: domain);
  }

  /// Enforces that the current authenticated user is a superuser.
  Future<void> requireSuperuser(Session session) async {
    await session.rbac.requireSuperuser();
  }
}
