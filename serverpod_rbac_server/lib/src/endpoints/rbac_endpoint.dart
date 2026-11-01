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

  /// Retrieves the current authenticated user's permissions and roles snapshot.
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
  Future<List<String>> getMyRoles(Session session) async {
    return session.rbac.getRoles();
  }

  // ==========================================
  // ABAC DOMAIN EVALUATION
  // ==========================================

  /// Checks if access to [permission] requires row-level domain filtering for the current user.
  Future<bool> hasDomains(
    Session session,
    String permission, {
    String? resource,
  }) async {
    return session.rbac.hasDomains(permission, resource: resource);
  }

  /// Retrieves the domain filter expressions granted to the current user for [permission].
  Future<List<String>> getMyDomainFilters(
    Session session,
    String permission, {
    String? resource,
  }) async {
    return session.rbac.getDomainFilters(permission, resource: resource);
  }

  /// Retrieves full domain access details for [permission] for the current user.
  Future<RbacAbacResult> getMyDomainAccess(
    Session session,
    String permission, {
    String? resource,
  }) async {
    return session.rbac.getDomainAccess(permission, resource: resource);
  }

  /// Retrieves all domain filter expressions across all roles for the current user.
  Future<List<String>> getMyAllDomainFilters(
    Session session, {
    String? resource,
  }) async {
    return session.rbac.abac.getAllDomainFilters(resource: resource);
  }

  // ==========================================
  // RBAC PERMISSION CHECKS
  // ==========================================

  /// Checks if the current authenticated user has a specific permission.
  Future<bool> hasPermission(
    Session session,
    String permission,
  ) async {
    return session.rbac.hasPermission(permission);
  }

  /// Checks if the current authenticated user has all specified permissions.
  Future<bool> hasAllPermissions(
    Session session,
    List<String> permissions,
  ) async {
    return session.rbac.hasAllPermissions(permissions);
  }

  /// Checks if the current authenticated user has any specified permission.
  Future<bool> hasAnyPermission(
    Session session,
    List<String> permissions,
  ) async {
    return session.rbac.hasAnyPermission(permissions);
  }

  /// Checks if the current authenticated user has a specific role.
  Future<bool> hasRole(
    Session session,
    String role,
  ) async {
    return session.rbac.hasRole(role);
  }

  /// Checks if the current authenticated user has any specified role.
  Future<bool> hasAnyRole(
    Session session,
    List<String> roles,
  ) async {
    return session.rbac.hasAnyRole(roles);
  }

  /// Checks if the current authenticated user has all specified roles.
  Future<bool> hasAllRoles(
    Session session,
    List<String> roles,
  ) async {
    return session.rbac.hasAllRoles(roles);
  }

  /// Enforces that the current authenticated user has [permission].
  Future<void> requirePermission(
    Session session,
    String permission,
  ) async {
    await session.rbac.requirePermission(permission);
  }

  /// Enforces that the current authenticated user has all [permissions].
  Future<void> requireAllPermissions(
    Session session,
    List<String> permissions,
  ) async {
    await session.rbac.requireAllPermissions(permissions);
  }

  /// Enforces that the current authenticated user has any [permissions].
  Future<void> requireAnyPermission(
    Session session,
    List<String> permissions,
  ) async {
    await session.rbac.requireAnyPermission(permissions);
  }

  /// Enforces that the current authenticated user has [role].
  Future<void> requireRole(
    Session session,
    String role,
  ) async {
    await session.rbac.requireRole(role);
  }

  /// Enforces that the current authenticated user has all [roles].
  Future<void> requireAllRoles(
    Session session,
    List<String> roles,
  ) async {
    await session.rbac.requireAllRoles(roles);
  }

  /// Enforces that the current authenticated user has any [roles].
  Future<void> requireAnyRole(
    Session session,
    List<String> roles,
  ) async {
    await session.rbac.requireAnyRole(roles);
  }

  /// Enforces that the current authenticated user is a superuser.
  Future<void> requireSuperuser(Session session) async {
    await session.rbac.requireSuperuser();
  }
}
