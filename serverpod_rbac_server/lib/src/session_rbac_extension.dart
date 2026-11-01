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

  /// Checks if the current session user has a specific permission, optionally scoped to [domain].
  Future<bool> hasPermission(String permission, {String? domain}) =>
      RbacService.instance.hasPermission(session, permission, domain: domain);

  /// Checks if the current session user has ALL of the specified permissions.
  Future<bool> hasAllPermissions(List<String> permissions, {String? domain}) =>
      RbacService.instance.hasAllPermissions(session, permissions, domain: domain);

  /// Checks if the current session user has AT LEAST ONE of the specified permissions.
  Future<bool> hasAnyPermission(List<String> permissions, {String? domain}) =>
      RbacService.instance.hasAnyPermission(session, permissions, domain: domain);

  /// Checks if the current session user has a specific role, optionally scoped to [domain].
  Future<bool> hasRole(String roleName, {String? domain}) =>
      RbacService.instance.hasRole(session, roleName, domain: domain);

  /// Checks if the current session user has AT LEAST ONE of the specified roles.
  Future<bool> hasAnyRole(List<String> roleNames, {String? domain}) =>
      RbacService.instance.hasAnyRole(session, roleNames, domain: domain);

  /// Checks if the current session user has ALL of the specified roles.
  Future<bool> hasAllRoles(List<String> roleNames, {String? domain}) =>
      RbacService.instance.hasAllRoles(session, roleNames, domain: domain);

  /// Enforces that the current session user has [permission], throwing [RbacException] if denied.
  Future<void> requirePermission(String permission, {String? domain}) =>
      RbacService.instance.requirePermission(session, permission, domain: domain);

  /// Enforces that the current session user has ALL of [permissions].
  Future<void> requireAllPermissions(List<String> permissions, {String? domain}) =>
      RbacService.instance.requireAllPermissions(session, permissions, domain: domain);

  /// Enforces that the current session user has AT LEAST ONE of [permissions].
  Future<void> requireAnyPermission(List<String> permissions, {String? domain}) =>
      RbacService.instance.requireAnyPermission(session, permissions, domain: domain);

  /// Enforces that the current session user has [roleName].
  Future<void> requireRole(String roleName, {String? domain}) =>
      RbacService.instance.requireRole(session, roleName, domain: domain);

  /// Enforces that the current session user has ALL of [roleNames].
  Future<void> requireAllRoles(List<String> roleNames, {String? domain}) =>
      RbacService.instance.requireAllRoles(session, roleNames, domain: domain);

  /// Enforces that the current session has any of [roleNames].
  Future<void> requireAnyRole(List<String> roleNames, {String? domain}) =>
      RbacService.instance.requireAnyRole(session, roleNames, domain: domain);

  /// Enforces that the current session user has superuser privileges.
  Future<void> requireSuperuser() =>
      RbacService.instance.requireSuperuser(session);

  /// Checks if access to [permission] is domain-restricted for the current user.
  Future<bool> hasDomains(String permission) =>
      AbacService.instance.hasDomains(session, permission: permission);

  /// Returns the stored domains granted for [permission] to the current user.
  Future<List<String>> getDomains(String permission) =>
      AbacService.instance.getDomains(session, permission: permission);

  /// Returns full domain access information for [permission].
  Future<RbacAbacResult> getDomainAccess(String permission) =>
      AbacService.instance.getDomainAccess(session, permission: permission);

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
  Future<List<String>> getRoles({String? domain}) async {
    final uid = userIdentifier;
    if (uid == null) return [];
    final roles = await RbacService.instance.getUserRoles(
      session,
      uid,
      domain: domain,
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
  Future<bool> hasDomains(String permission) =>
      AbacService.instance.hasDomains(session, permission: permission);

  /// Returns the domains granted for [permission] to the current user.
  Future<List<String>> getDomains(String permission) =>
      AbacService.instance.getDomains(session, permission: permission);

  /// Returns domain evaluation details for [permission].
  Future<RbacAbacResult> getDomainAccess(String permission) =>
      AbacService.instance.getDomainAccess(session, permission: permission);

  /// Checks if access to [roleName] is restricted to specific domains.
  Future<bool> hasDomainsForRole(String roleName) =>
      AbacService.instance.hasDomainsForRole(session, roleName: roleName);

  /// Returns the domains granted for [roleName] to the current user.
  Future<List<String>> getDomainsForRole(String roleName) =>
      AbacService.instance.getDomainsForRole(session, roleName: roleName);

  /// Returns domain evaluation details for [roleName].
  Future<RbacAbacResult> getRoleDomainAccess(String roleName) =>
      AbacService.instance.getRoleDomainAccess(session, roleName: roleName);

  /// Returns all distinct domains assigned to the current user.
  Future<List<String>> getAllDomains() =>
      AbacService.instance.getAllDomains(session);
}
