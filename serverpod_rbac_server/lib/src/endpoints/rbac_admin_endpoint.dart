import 'package:serverpod/serverpod.dart';
import '../abac_service.dart';
import '../generated/protocol.dart';
import '../rbac_service.dart';
import '../session_rbac_extension.dart';

/// Administrative endpoint for managing RBAC roles, permissions, user-role
/// assignments, and ABAC domain rules.
class RbacAdminEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<void> _checkAdminAccess(Session session) async {
    final isSuper = await session.rbac.isSuperuser();
    if (isSuper) return;

    final canManage = await session.rbac.hasPermission('rbac.manage');
    if (!canManage) {
      throw RbacException(
        message:
            'Administrative permission required: "rbac.manage" or superuser',
        reason: RbacExceptionReason.permissionDenied,
        requiredPermission: 'rbac.manage',
        userIdentifier: session.authenticated?.userIdentifier,
      );
    }
  }

  // ==========================================
  // PERMISSIONS (Single & Bulk)
  // ==========================================

  /// Creates a single permission using [insertRow].
  Future<RbacPermission> createPermission(
    Session session, {
    required String resource,
    required String codename,
    required String name,
    String? description,
  }) async {
    await _checkAdminAccess(session);
    return RbacService.instance.createPermission(
      session,
      resource: resource,
      codename: codename,
      name: name,
      description: description,
    );
  }

  /// Creates multiple permissions in bulk using [insert].
  Future<List<RbacPermission>> createPermissions(
    Session session,
    List<RbacPermission> permissions,
  ) async {
    await _checkAdminAccess(session);
    return RbacService.instance.createPermissions(session, permissions);
  }

  /// Lists registered permissions, optionally filtered by resource.
  Future<List<RbacPermission>> listPermissions(
    Session session, {
    String? resource,
  }) async {
    await _checkAdminAccess(session);
    return RbacService.instance.listPermissions(session, resource: resource);
  }

  /// Deletes a permission by ID using [deleteRow].
  Future<void> deletePermission(
    Session session,
    int permissionId,
  ) async {
    await _checkAdminAccess(session);
    await RbacService.instance.deletePermission(session, permissionId);
  }

  /// Deletes multiple permissions by IDs in bulk.
  Future<void> deletePermissions(
    Session session,
    List<int> permissionIds,
  ) async {
    await _checkAdminAccess(session);
    await RbacService.instance.deletePermissions(session, permissionIds);
  }

  // ==========================================
  // ROLES (Single & Bulk)
  // ==========================================

  /// Creates a single role using [insertRow].
  Future<RbacRole> createRole(
    Session session, {
    required String name,
    String? description,
    bool? isSuperuser,
    bool? isSystemRole,
  }) async {
    await _checkAdminAccess(session);
    return RbacService.instance.createRole(
      session,
      name: name,
      description: description,
      isSuperuser: isSuperuser ?? false,
      isSystemRole: isSystemRole ?? false,
    );
  }

  /// Creates multiple roles in bulk using [insert].
  Future<List<RbacRole>> createRoles(
    Session session,
    List<RbacRole> roles,
  ) async {
    await _checkAdminAccess(session);
    return RbacService.instance.createRoles(session, roles);
  }

  /// Lists all roles.
  Future<List<RbacRole>> listRoles(Session session) async {
    await _checkAdminAccess(session);
    return RbacService.instance.listRoles(session);
  }

  /// Deletes a role by name using [deleteRow].
  Future<void> deleteRole(Session session, String name) async {
    await _checkAdminAccess(session);
    await RbacService.instance.deleteRole(session, name);
  }

  /// Deletes multiple roles by names in bulk.
  Future<void> deleteRoles(Session session, List<String> names) async {
    await _checkAdminAccess(session);
    await RbacService.instance.deleteRoles(session, names);
  }

  // ==========================================
  // ROLE-PERMISSION ASSIGNMENTS (Bulk)
  // ==========================================

  /// Assigns permissions to a role in bulk using [insert].
  Future<void> assignPermissionsToRole(
    Session session, {
    required String roleName,
    required List<String> permissions,
  }) async {
    await _checkAdminAccess(session);
    await RbacService.instance.assignPermissionsToRole(
      session,
      roleName: roleName,
      permissions: permissions,
    );
  }

  /// Removes permissions from a role in bulk.
  Future<void> removePermissionsFromRole(
    Session session, {
    required String roleName,
    required List<String> permissions,
  }) async {
    await _checkAdminAccess(session);
    await RbacService.instance.removePermissionsFromRole(
      session,
      roleName: roleName,
      permissions: permissions,
    );
  }

  /// Gets all permissions assigned to a role.
  Future<List<RbacPermission>> getRolePermissions(
    Session session,
    String roleName,
  ) async {
    await _checkAdminAccess(session);
    return RbacService.instance.getRolePermissions(session, roleName);
  }

  // ==========================================
  // USER-ROLE ASSIGNMENTS (Single & Bulk)
  // ==========================================

  /// Assigns a role to a user using [insertRow].
  Future<RbacUserRole> assignRoleToUser(
    Session session, {
    required String userIdentifier,
    required String roleName,
  }) async {
    await _checkAdminAccess(session);
    return RbacService.instance.assignRoleToUser(
      session,
      userIdentifier: userIdentifier,
      roleName: roleName,
    );
  }

  /// Assigns multiple roles to a user in bulk using [insert].
  Future<void> assignRolesToUser(
    Session session, {
    required String userIdentifier,
    required List<String> roleNames,
  }) async {
    await _checkAdminAccess(session);
    await RbacService.instance.assignRolesToUser(
      session,
      userIdentifier: userIdentifier,
      roleNames: roleNames,
    );
  }

  /// Assigns a role to multiple users in bulk using [insert].
  Future<void> assignRoleToUsers(
    Session session, {
    required List<String> userIdentifiers,
    required String roleName,
  }) async {
    await _checkAdminAccess(session);
    await RbacService.instance.assignRoleToUsers(
      session,
      userIdentifiers: userIdentifiers,
      roleName: roleName,
    );
  }

  /// Removes a role from a user using [deleteRow].
  Future<void> removeRoleFromUser(
    Session session, {
    required String userIdentifier,
    required String roleName,
  }) async {
    await _checkAdminAccess(session);
    await RbacService.instance.removeRoleFromUser(
      session,
      userIdentifier: userIdentifier,
      roleName: roleName,
    );
  }

  /// Removes multiple roles from a user in bulk.
  Future<void> removeRolesFromUser(
    Session session, {
    required String userIdentifier,
    required List<String> roleNames,
  }) async {
    await _checkAdminAccess(session);
    await RbacService.instance.removeRolesFromUser(
      session,
      userIdentifier: userIdentifier,
      roleNames: roleNames,
    );
  }

  /// Lists user-role assignment records matching filters.
  Future<List<RbacUserRole>> listUserRoles(
    Session session, {
    String? userIdentifier,
    String? roleName,
  }) async {
    await _checkAdminAccess(session);
    return RbacService.instance.listUserRoles(
      session,
      userIdentifier: userIdentifier,
      roleName: roleName,
    );
  }

  /// Gets all roles assigned to a user.
  Future<List<RbacRole>> getUserRoles(
    Session session,
    String userIdentifier,
  ) async {
    await _checkAdminAccess(session);
    return RbacService.instance.getUserRoles(
      session,
      userIdentifier,
    );
  }

  /// Inspects the full permissions snapshot for any user.
  Future<RbacUserPermissionsInfo> getUserPermissionsInfo(
    Session session, {
    required String userIdentifier,
  }) async {
    await _checkAdminAccess(session);
    return RbacService.instance.getUserPermissionsInfo(
      session,
      userIdentifier,
    );
  }

  // ==========================================
  // ABAC DOMAIN RULES MANAGEMENT
  // ==========================================

  /// Adds an Odoo-style domain filter rule to a role.
  Future<RbacDomainRule> addDomainRule(
    Session session, {
    required String roleName,
    required String resource,
    required String filterExpression,
    String? permission,
    String? description,
  }) async {
    await _checkAdminAccess(session);
    return AbacService.instance.addDomainRule(
      session,
      roleName: roleName,
      resource: resource,
      filterExpression: filterExpression,
      permission: permission,
      description: description,
    );
  }

  /// Adds multiple domain filter rules in bulk.
  Future<List<RbacDomainRule>> addDomainRules(
    Session session,
    List<RbacDomainRule> rules,
  ) async {
    await _checkAdminAccess(session);
    return AbacService.instance.addDomainRules(session, rules);
  }

  /// Removes a domain filter rule by its ID.
  Future<void> removeDomainRule(
    Session session,
    int ruleId,
  ) async {
    await _checkAdminAccess(session);
    await AbacService.instance.removeDomainRule(session, ruleId);
  }

  /// Clears domain filter rules for a role, optionally restricted to a specific [resource].
  Future<void> clearDomainRules(
    Session session, {
    required String roleName,
    String? resource,
    String? permission,
  }) async {
    await _checkAdminAccess(session);
    await AbacService.instance.clearDomainRules(
      session,
      roleName: roleName,
      resource: resource,
      permission: permission,
    );
  }

  /// Lists domain filter rules configured for a role.
  Future<List<RbacDomainRule>> listDomainRules(
    Session session, {
    required String roleName,
    String? resource,
    String? permission,
  }) async {
    await _checkAdminAccess(session);
    return AbacService.instance.listDomainRules(
      session,
      roleName: roleName,
      resource: resource,
      permission: permission,
    );
  }

  // ==========================================
  // ABAC DOMAIN INSPECTION FOR USER
  // ==========================================

  /// Retrieves the domain filter expressions granted to [userIdentifier] for [permission].
  Future<List<String>> getUserDomainFilters(
    Session session, {
    required String userIdentifier,
    required String permission,
    String? resource,
  }) async {
    await _checkAdminAccess(session);
    return AbacService.instance.getDomainFilters(
      session,
      permission: permission,
      resource: resource,
      userIdentifier: userIdentifier,
    );
  }

  /// Evaluates full ABAC domain access for [userIdentifier] and [permission].
  Future<RbacAbacResult> getUserDomainAccess(
    Session session, {
    required String userIdentifier,
    required String permission,
    String? resource,
  }) async {
    await _checkAdminAccess(session);
    return AbacService.instance.getDomainAccess(
      session,
      permission: permission,
      resource: resource,
      userIdentifier: userIdentifier,
    );
  }

  /// Retrieves all domain filter expressions across all roles for [userIdentifier].
  Future<List<String>> getAllUserDomainFilters(
    Session session, {
    required String userIdentifier,
    String? resource,
  }) async {
    await _checkAdminAccess(session);
    return AbacService.instance.getAllDomainFilters(
      session,
      resource: resource,
      userIdentifier: userIdentifier,
    );
  }
}
