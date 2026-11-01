/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _ida;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'package:serverpod_rbac_client/src/protocol/rbac_abac_result.dart'
    as _i3qazro9;
import 'package:serverpod_rbac_client/src/protocol/rbac_domain_rule.dart'
    as _i48gp0es;
import 'package:serverpod_rbac_client/src/protocol/rbac_permission.dart'
    as _i6wtmqv0;
import 'package:serverpod_rbac_client/src/protocol/rbac_role.dart' as _iepuelvo;
import 'package:serverpod_rbac_client/src/protocol/rbac_user_permissions_info.dart'
    as _iratp19g;
import 'package:serverpod_rbac_client/src/protocol/rbac_user_role.dart'
    as _ibcgqhlb;

/// Administrative endpoint for managing RBAC roles, permissions, user-role
/// assignments, and ABAC domain rules.
/// {@category Endpoint}
class EndpointRbacAdmin extends _isc.EndpointRef {
  EndpointRbacAdmin(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'serverpod_rbac.rbacAdmin';

  /// Creates a single permission using [insertRow].
  _ida.Future<_i6wtmqv0.RbacPermission> createPermission({
    required String resource,
    required String codename,
    required String name,
    String? description,
  }) => caller.callServerEndpoint<_i6wtmqv0.RbacPermission>(
    'serverpod_rbac.rbacAdmin',
    'createPermission',
    {
      'resource': resource,
      'codename': codename,
      'name': name,
      'description': description,
    },
  );

  /// Creates multiple permissions in bulk using [insert].
  _ida.Future<List<_i6wtmqv0.RbacPermission>> createPermissions(
    List<_i6wtmqv0.RbacPermission> permissions,
  ) => caller.callServerEndpoint<List<_i6wtmqv0.RbacPermission>>(
    'serverpod_rbac.rbacAdmin',
    'createPermissions',
    {'permissions': permissions},
  );

  /// Lists registered permissions, optionally filtered by resource.
  _ida.Future<List<_i6wtmqv0.RbacPermission>> listPermissions({
    String? resource,
  }) => caller.callServerEndpoint<List<_i6wtmqv0.RbacPermission>>(
    'serverpod_rbac.rbacAdmin',
    'listPermissions',
    {'resource': resource},
  );

  /// Deletes a permission by ID using [deleteRow].
  _ida.Future<void> deletePermission(int permissionId) =>
      caller.callServerEndpoint<void>(
        'serverpod_rbac.rbacAdmin',
        'deletePermission',
        {'permissionId': permissionId},
      );

  /// Deletes multiple permissions by IDs in bulk.
  _ida.Future<void> deletePermissions(List<int> permissionIds) =>
      caller.callServerEndpoint<void>(
        'serverpod_rbac.rbacAdmin',
        'deletePermissions',
        {'permissionIds': permissionIds},
      );

  /// Creates a single role using [insertRow].
  _ida.Future<_iepuelvo.RbacRole> createRole({
    required String name,
    String? description,
    bool? isSuperuser,
    bool? isSystemRole,
  }) => caller.callServerEndpoint<_iepuelvo.RbacRole>(
    'serverpod_rbac.rbacAdmin',
    'createRole',
    {
      'name': name,
      'description': description,
      'isSuperuser': isSuperuser,
      'isSystemRole': isSystemRole,
    },
  );

  /// Creates multiple roles in bulk using [insert].
  _ida.Future<List<_iepuelvo.RbacRole>> createRoles(
    List<_iepuelvo.RbacRole> roles,
  ) => caller.callServerEndpoint<List<_iepuelvo.RbacRole>>(
    'serverpod_rbac.rbacAdmin',
    'createRoles',
    {'roles': roles},
  );

  /// Lists all roles.
  _ida.Future<List<_iepuelvo.RbacRole>> listRoles() =>
      caller.callServerEndpoint<List<_iepuelvo.RbacRole>>(
        'serverpod_rbac.rbacAdmin',
        'listRoles',
        {},
      );

  /// Deletes a role by name using [deleteRow].
  _ida.Future<void> deleteRole(String name) => caller.callServerEndpoint<void>(
    'serverpod_rbac.rbacAdmin',
    'deleteRole',
    {'name': name},
  );

  /// Deletes multiple roles by names in bulk.
  _ida.Future<void> deleteRoles(List<String> names) =>
      caller.callServerEndpoint<void>(
        'serverpod_rbac.rbacAdmin',
        'deleteRoles',
        {'names': names},
      );

  /// Assigns permissions to a role in bulk using [insert].
  _ida.Future<void> assignPermissionsToRole({
    required String roleName,
    required List<String> permissions,
  }) => caller.callServerEndpoint<void>(
    'serverpod_rbac.rbacAdmin',
    'assignPermissionsToRole',
    {
      'roleName': roleName,
      'permissions': permissions,
    },
  );

  /// Removes permissions from a role in bulk.
  _ida.Future<void> removePermissionsFromRole({
    required String roleName,
    required List<String> permissions,
  }) => caller.callServerEndpoint<void>(
    'serverpod_rbac.rbacAdmin',
    'removePermissionsFromRole',
    {
      'roleName': roleName,
      'permissions': permissions,
    },
  );

  /// Gets all permissions assigned to a role.
  _ida.Future<List<_i6wtmqv0.RbacPermission>> getRolePermissions(
    String roleName,
  ) => caller.callServerEndpoint<List<_i6wtmqv0.RbacPermission>>(
    'serverpod_rbac.rbacAdmin',
    'getRolePermissions',
    {'roleName': roleName},
  );

  /// Assigns a role to a user using [insertRow].
  _ida.Future<_ibcgqhlb.RbacUserRole> assignRoleToUser({
    required String userIdentifier,
    required String roleName,
  }) => caller.callServerEndpoint<_ibcgqhlb.RbacUserRole>(
    'serverpod_rbac.rbacAdmin',
    'assignRoleToUser',
    {
      'userIdentifier': userIdentifier,
      'roleName': roleName,
    },
  );

  /// Assigns multiple roles to a user in bulk using [insert].
  _ida.Future<void> assignRolesToUser({
    required String userIdentifier,
    required List<String> roleNames,
  }) => caller.callServerEndpoint<void>(
    'serverpod_rbac.rbacAdmin',
    'assignRolesToUser',
    {
      'userIdentifier': userIdentifier,
      'roleNames': roleNames,
    },
  );

  /// Assigns a role to multiple users in bulk using [insert].
  _ida.Future<void> assignRoleToUsers({
    required List<String> userIdentifiers,
    required String roleName,
  }) => caller.callServerEndpoint<void>(
    'serverpod_rbac.rbacAdmin',
    'assignRoleToUsers',
    {
      'userIdentifiers': userIdentifiers,
      'roleName': roleName,
    },
  );

  /// Removes a role from a user using [deleteRow].
  _ida.Future<void> removeRoleFromUser({
    required String userIdentifier,
    required String roleName,
  }) => caller.callServerEndpoint<void>(
    'serverpod_rbac.rbacAdmin',
    'removeRoleFromUser',
    {
      'userIdentifier': userIdentifier,
      'roleName': roleName,
    },
  );

  /// Removes multiple roles from a user in bulk.
  _ida.Future<void> removeRolesFromUser({
    required String userIdentifier,
    required List<String> roleNames,
  }) => caller.callServerEndpoint<void>(
    'serverpod_rbac.rbacAdmin',
    'removeRolesFromUser',
    {
      'userIdentifier': userIdentifier,
      'roleNames': roleNames,
    },
  );

  /// Lists user-role assignment records matching filters.
  _ida.Future<List<_ibcgqhlb.RbacUserRole>> listUserRoles({
    String? userIdentifier,
    String? roleName,
  }) => caller.callServerEndpoint<List<_ibcgqhlb.RbacUserRole>>(
    'serverpod_rbac.rbacAdmin',
    'listUserRoles',
    {
      'userIdentifier': userIdentifier,
      'roleName': roleName,
    },
  );

  /// Gets all roles assigned to a user.
  _ida.Future<List<_iepuelvo.RbacRole>> getUserRoles(String userIdentifier) =>
      caller.callServerEndpoint<List<_iepuelvo.RbacRole>>(
        'serverpod_rbac.rbacAdmin',
        'getUserRoles',
        {'userIdentifier': userIdentifier},
      );

  /// Inspects the full permissions snapshot for any user.
  _ida.Future<_iratp19g.RbacUserPermissionsInfo> getUserPermissionsInfo({
    required String userIdentifier,
  }) => caller.callServerEndpoint<_iratp19g.RbacUserPermissionsInfo>(
    'serverpod_rbac.rbacAdmin',
    'getUserPermissionsInfo',
    {'userIdentifier': userIdentifier},
  );

  /// Adds an Odoo-style domain filter rule to a role.
  _ida.Future<_i48gp0es.RbacDomainRule> addDomainRule({
    required String roleName,
    required String resource,
    required String filterExpression,
    String? permission,
    String? description,
  }) => caller.callServerEndpoint<_i48gp0es.RbacDomainRule>(
    'serverpod_rbac.rbacAdmin',
    'addDomainRule',
    {
      'roleName': roleName,
      'resource': resource,
      'filterExpression': filterExpression,
      'permission': permission,
      'description': description,
    },
  );

  /// Adds multiple domain filter rules in bulk.
  _ida.Future<List<_i48gp0es.RbacDomainRule>> addDomainRules(
    List<_i48gp0es.RbacDomainRule> rules,
  ) => caller.callServerEndpoint<List<_i48gp0es.RbacDomainRule>>(
    'serverpod_rbac.rbacAdmin',
    'addDomainRules',
    {'rules': rules},
  );

  /// Removes a domain filter rule by its ID.
  _ida.Future<void> removeDomainRule(int ruleId) =>
      caller.callServerEndpoint<void>(
        'serverpod_rbac.rbacAdmin',
        'removeDomainRule',
        {'ruleId': ruleId},
      );

  /// Clears domain filter rules for a role, optionally restricted to a specific [resource].
  _ida.Future<void> clearDomainRules({
    required String roleName,
    String? resource,
    String? permission,
  }) => caller.callServerEndpoint<void>(
    'serverpod_rbac.rbacAdmin',
    'clearDomainRules',
    {
      'roleName': roleName,
      'resource': resource,
      'permission': permission,
    },
  );

  /// Lists domain filter rules configured for a role.
  _ida.Future<List<_i48gp0es.RbacDomainRule>> listDomainRules({
    required String roleName,
    String? resource,
    String? permission,
  }) => caller.callServerEndpoint<List<_i48gp0es.RbacDomainRule>>(
    'serverpod_rbac.rbacAdmin',
    'listDomainRules',
    {
      'roleName': roleName,
      'resource': resource,
      'permission': permission,
    },
  );

  /// Retrieves the domain filter expressions granted to [userIdentifier] for [permission].
  _ida.Future<List<String>> getUserDomainFilters({
    required String userIdentifier,
    required String permission,
    String? resource,
  }) => caller.callServerEndpoint<List<String>>(
    'serverpod_rbac.rbacAdmin',
    'getUserDomainFilters',
    {
      'userIdentifier': userIdentifier,
      'permission': permission,
      'resource': resource,
    },
  );

  /// Evaluates full ABAC domain access for [userIdentifier] and [permission].
  _ida.Future<_i3qazro9.RbacAbacResult> getUserDomainAccess({
    required String userIdentifier,
    required String permission,
    String? resource,
  }) => caller.callServerEndpoint<_i3qazro9.RbacAbacResult>(
    'serverpod_rbac.rbacAdmin',
    'getUserDomainAccess',
    {
      'userIdentifier': userIdentifier,
      'permission': permission,
      'resource': resource,
    },
  );

  /// Retrieves all domain filter expressions across all roles for [userIdentifier].
  _ida.Future<List<String>> getAllUserDomainFilters({
    required String userIdentifier,
    String? resource,
  }) => caller.callServerEndpoint<List<String>>(
    'serverpod_rbac.rbacAdmin',
    'getAllUserDomainFilters',
    {
      'userIdentifier': userIdentifier,
      'resource': resource,
    },
  );
}

/// Endpoint allowing authenticated clients to inspect their own RBAC permissions,
/// roles, and ABAC domains.
/// {@category Endpoint}
class EndpointRbac extends _isc.EndpointRef {
  EndpointRbac(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'serverpod_rbac.rbac';

  /// Checks if the current authenticated user is a superuser.
  _ida.Future<bool> isSuperuser() => caller.callServerEndpoint<bool>(
    'serverpod_rbac.rbac',
    'isSuperuser',
    {},
  );

  /// Retrieves the current authenticated user's permissions and roles snapshot.
  _ida.Future<_iratp19g.RbacUserPermissionsInfo> getMyPermissions() =>
      caller.callServerEndpoint<_iratp19g.RbacUserPermissionsInfo>(
        'serverpod_rbac.rbac',
        'getMyPermissions',
        {},
      );

  /// Retrieves the current authenticated user's assigned role names.
  _ida.Future<List<String>> getMyRoles() =>
      caller.callServerEndpoint<List<String>>(
        'serverpod_rbac.rbac',
        'getMyRoles',
        {},
      );

  /// Checks if access to [permission] requires row-level domain filtering for the current user.
  _ida.Future<bool> hasDomains(
    String permission, {
    String? resource,
  }) => caller.callServerEndpoint<bool>(
    'serverpod_rbac.rbac',
    'hasDomains',
    {
      'permission': permission,
      'resource': resource,
    },
  );

  /// Retrieves the domain filter expressions granted to the current user for [permission].
  _ida.Future<List<String>> getMyDomainFilters(
    String permission, {
    String? resource,
  }) => caller.callServerEndpoint<List<String>>(
    'serverpod_rbac.rbac',
    'getMyDomainFilters',
    {
      'permission': permission,
      'resource': resource,
    },
  );

  /// Retrieves full domain access details for [permission] for the current user.
  _ida.Future<_i3qazro9.RbacAbacResult> getMyDomainAccess(
    String permission, {
    String? resource,
  }) => caller.callServerEndpoint<_i3qazro9.RbacAbacResult>(
    'serverpod_rbac.rbac',
    'getMyDomainAccess',
    {
      'permission': permission,
      'resource': resource,
    },
  );

  /// Retrieves all domain filter expressions across all roles for the current user.
  _ida.Future<List<String>> getMyAllDomainFilters({String? resource}) =>
      caller.callServerEndpoint<List<String>>(
        'serverpod_rbac.rbac',
        'getMyAllDomainFilters',
        {'resource': resource},
      );

  /// Checks if the current authenticated user has a specific permission.
  _ida.Future<bool> hasPermission(String permission) =>
      caller.callServerEndpoint<bool>(
        'serverpod_rbac.rbac',
        'hasPermission',
        {'permission': permission},
      );

  /// Checks if the current authenticated user has all specified permissions.
  _ida.Future<bool> hasAllPermissions(List<String> permissions) =>
      caller.callServerEndpoint<bool>(
        'serverpod_rbac.rbac',
        'hasAllPermissions',
        {'permissions': permissions},
      );

  /// Checks if the current authenticated user has any specified permission.
  _ida.Future<bool> hasAnyPermission(List<String> permissions) =>
      caller.callServerEndpoint<bool>(
        'serverpod_rbac.rbac',
        'hasAnyPermission',
        {'permissions': permissions},
      );

  /// Checks if the current authenticated user has a specific role.
  _ida.Future<bool> hasRole(String role) => caller.callServerEndpoint<bool>(
    'serverpod_rbac.rbac',
    'hasRole',
    {'role': role},
  );

  /// Checks if the current authenticated user has any specified role.
  _ida.Future<bool> hasAnyRole(List<String> roles) =>
      caller.callServerEndpoint<bool>(
        'serverpod_rbac.rbac',
        'hasAnyRole',
        {'roles': roles},
      );

  /// Checks if the current authenticated user has all specified roles.
  _ida.Future<bool> hasAllRoles(List<String> roles) =>
      caller.callServerEndpoint<bool>(
        'serverpod_rbac.rbac',
        'hasAllRoles',
        {'roles': roles},
      );

  /// Enforces that the current authenticated user has [permission].
  _ida.Future<void> requirePermission(String permission) =>
      caller.callServerEndpoint<void>(
        'serverpod_rbac.rbac',
        'requirePermission',
        {'permission': permission},
      );

  /// Enforces that the current authenticated user has all [permissions].
  _ida.Future<void> requireAllPermissions(List<String> permissions) =>
      caller.callServerEndpoint<void>(
        'serverpod_rbac.rbac',
        'requireAllPermissions',
        {'permissions': permissions},
      );

  /// Enforces that the current authenticated user has any [permissions].
  _ida.Future<void> requireAnyPermission(List<String> permissions) =>
      caller.callServerEndpoint<void>(
        'serverpod_rbac.rbac',
        'requireAnyPermission',
        {'permissions': permissions},
      );

  /// Enforces that the current authenticated user has [role].
  _ida.Future<void> requireRole(String role) => caller.callServerEndpoint<void>(
    'serverpod_rbac.rbac',
    'requireRole',
    {'role': role},
  );

  /// Enforces that the current authenticated user has all [roles].
  _ida.Future<void> requireAllRoles(List<String> roles) =>
      caller.callServerEndpoint<void>(
        'serverpod_rbac.rbac',
        'requireAllRoles',
        {'roles': roles},
      );

  /// Enforces that the current authenticated user has any [roles].
  _ida.Future<void> requireAnyRole(List<String> roles) =>
      caller.callServerEndpoint<void>(
        'serverpod_rbac.rbac',
        'requireAnyRole',
        {'roles': roles},
      );

  /// Enforces that the current authenticated user is a superuser.
  _ida.Future<void> requireSuperuser() => caller.callServerEndpoint<void>(
    'serverpod_rbac.rbac',
    'requireSuperuser',
    {},
  );
}

class Caller extends _isc.ModuleEndpointCaller {
  Caller(_isc.ServerpodClientShared client) : super(client) {
    rbacAdmin = EndpointRbacAdmin(this);
    rbac = EndpointRbac(this);
  }

  late final EndpointRbacAdmin rbacAdmin;

  late final EndpointRbac rbac;

  @override
  Map<String, _isc.EndpointRef> get endpointRefLookup => {
    'serverpod_rbac.rbacAdmin': rbacAdmin,
    'serverpod_rbac.rbac': rbac,
  };
}
