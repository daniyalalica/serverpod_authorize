import 'package:serverpod/serverpod.dart';
import 'abac_service.dart';
import 'generated/protocol.dart';
import 'rbac_service.dart';

/// Extension on [Session] providing direct access to the RBAC context and checks.
extension RbacSessionExtension on Session {
  /// Accesses the RBAC context for this session.
  SessionRbacContext get rbac => SessionRbacContext(this);
}

/// Session-scoped RBAC helper providing authorization checks and ABAC domain access.
class SessionRbacContext {
  /// The underlying session.
  final Session session;

  /// Creates a new [SessionRbacContext] for the given [session].
  SessionRbacContext(this.session);

  /// The authenticated user identifier for this session, or null if unauthenticated.
  String? get userIdentifier => session.authenticated?.userIdentifier;

  /// Whether the session user is authenticated.
  bool get isAuthenticated => userIdentifier != null;

  /// Accesses the session-scoped ABAC domain helper.
  SessionAbacContext get abac => SessionAbacContext(session);

  /// Checks if the current session user has superuser privileges.
  Future<bool> isSuperuser() => RbacService.instance.isSuperuser(session);

  /// Checks if the current session user has a specific permission.
  Future<bool> hasPermission(String permission) =>
      RbacService.instance.hasPermission(session, permission);

  /// Checks if the current session user has ALL of the specified permissions.
  Future<bool> hasAllPermissions(List<String> permissions) =>
      RbacService.instance.hasAllPermissions(session, permissions);

  /// Checks if the current session user has AT LEAST ONE of the specified permissions.
  Future<bool> hasAnyPermission(List<String> permissions) =>
      RbacService.instance.hasAnyPermission(session, permissions);

  /// Checks if the current session user has a specific role.
  Future<bool> hasRole(String roleName) =>
      RbacService.instance.hasRole(session, roleName);

  /// Checks if the current session user has AT LEAST ONE of the specified roles.
  Future<bool> hasAnyRole(List<String> roleNames) =>
      RbacService.instance.hasAnyRole(session, roleNames);

  /// Checks if the current session user has ALL of the specified roles.
  Future<bool> hasAllRoles(List<String> roleNames) =>
      RbacService.instance.hasAllRoles(session, roleNames);

  /// Enforces that the current session user has [permission], throwing [RbacException] if denied.
  Future<void> requirePermission(String permission) =>
      RbacService.instance.requirePermission(session, permission);

  /// Enforces that the current session user has ALL of [permissions].
  Future<void> requireAllPermissions(List<String> permissions) =>
      RbacService.instance.requireAllPermissions(session, permissions);

  /// Enforces that the current session user has AT LEAST ONE of [permissions].
  Future<void> requireAnyPermission(List<String> permissions) =>
      RbacService.instance.requireAnyPermission(session, permissions);

  /// Enforces that the current session user has [roleName].
  Future<void> requireRole(String roleName) =>
      RbacService.instance.requireRole(session, roleName);

  /// Enforces that the current session user has ALL of [roleNames].
  Future<void> requireAllRoles(List<String> roleNames) =>
      RbacService.instance.requireAllRoles(session, roleNames);

  /// Enforces that the current session has any of [roleNames].
  Future<void> requireAnyRole(List<String> roleNames) =>
      RbacService.instance.requireAnyRole(session, roleNames);

  /// Enforces that the current session user has superuser privileges.
  Future<void> requireSuperuser() =>
      RbacService.instance.requireSuperuser(session);

  /// Checks if access to [permission] requires row-level domain filtering.
  Future<bool> hasDomains(String permission, {String? resource}) =>
      AbacService.instance.hasDomains(
        session,
        permission: permission,
        resource: resource,
      );

  /// Returns the stored Odoo-style JSON domain filter expressions for [permission].
  Future<List<String>> getDomainFilters(
    String permission, {
    String? resource,
  }) => AbacService.instance.getDomainFilters(
    session,
    permission: permission,
    resource: resource,
  );

  /// Returns full ABAC domain evaluation for [permission].
  Future<RbacAbacResult> getDomainAccess(
    String permission, {
    String? resource,
  }) => AbacService.instance.getDomainAccess(
    session,
    permission: permission,
    resource: resource,
  );

  /// Returns all resolved permissions for the current user.
  Future<Set<String>> getAllPermissions() async {
    final uid = userIdentifier;
    if (uid == null) return {};
    final info = await RbacService.instance.getUserPermissionsInfo(
      session,
      uid,
    );
    return info.permissions.toSet();
  }

  /// Returns all assigned role names for the current user.
  Future<List<String>> getRoles() async {
    final uid = userIdentifier;
    if (uid == null) return [];
    final roles = await RbacService.instance.getUserRoles(
      session,
      uid,
    );
    return roles.map((r) => r.name).toList();
  }

  /// Returns the complete [RbacUserPermissionsInfo] summary for the current user.
  Future<RbacUserPermissionsInfo?> getPermissionsInfo() async {
    final uid = userIdentifier;
    if (uid == null) return null;
    return RbacService.instance.getUserPermissionsInfo(
      session,
      uid,
    );
  }
}

/// Session-scoped ABAC helper for domain evaluation.
class SessionAbacContext {
  /// The underlying session.
  final Session session;

  /// Creates a new [SessionAbacContext].
  SessionAbacContext(this.session);

  /// Checks if access to [permission] is restricted to specific domains.
  Future<bool> hasDomains(String permission, {String? resource}) =>
      AbacService.instance.hasDomains(
        session,
        permission: permission,
        resource: resource,
      );

  /// Returns the domain filter expressions granted for [permission] to the current user.
  Future<List<String>> getDomainFilters(
    String permission, {
    String? resource,
  }) => AbacService.instance.getDomainFilters(
    session,
    permission: permission,
    resource: resource,
  );

  /// Returns domain evaluation details for [permission].
  Future<RbacAbacResult> getDomainAccess(
    String permission, {
    String? resource,
  }) => AbacService.instance.getDomainAccess(
    session,
    permission: permission,
    resource: resource,
  );

  /// Evaluates domain access for a specific role.
  Future<RbacAbacResult> getRoleDomainAccess(
    String roleName, {
    String? resource,
    String? permission,
  }) => AbacService.instance.getRoleDomainAccess(
    session,
    roleName: roleName,
    resource: resource,
    permission: permission,
  );

  /// Returns all distinct domain filter expressions across all roles for the current user.
  Future<List<String>> getAllDomainFilters({
    String? resource,
    String? permission,
  }) => AbacService.instance.getAllDomainFilters(
    session,
    resource: resource,
    permission: permission,
  );
}
