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
import 'package:serverpod_rbac_client/src/protocol/rbac_permission.dart'
    as _i6wtmqv0;
import 'package:serverpod_rbac_client/src/protocol/rbac_role.dart' as _iepuelvo;
import 'package:serverpod_rbac_client/src/protocol/rbac_user_permissions_info.dart'
    as _iratp19g;
import 'package:serverpod_rbac_client/src/protocol/rbac_user_role.dart'
    as _ibcgqhlb;

/// Administrative endpoint for managing RBAC roles, permissions, user-role
/// assignments, and ABAC domains.
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

  /// Assigns a role to a user using [insertRow], optionally scoped to [domain].
  _ida.Future<_ibcgqhlb.RbacUserRole> assignRoleToUser({
    required String userIdentifier,
    required String roleName,
    String? domain,
  }) => caller.callServerEndpoint<_ibcgqhlb.RbacUserRole>(
    'serverpod_rbac.rbacAdmin',
    'assignRoleToUser',
    {
      'userIdentifier': userIdentifier,
      'roleName': roleName,
      'domain': domain,
    },
  );

  /// Assigns multiple roles to a user in bulk using [insert].
  _ida.Future<void> assignRolesToUser({
    required String userIdentifier,
    required List<String> roleNames,
    String? domain,
  }) => caller.callServerEndpoint<void>(
    'serverpod_rbac.rbacAdmin',
    'assignRolesToUser',
    {
      'userIdentifier': userIdentifier,
      'roleNames': roleNames,
      'domain': domain,
    },
  );

  /// Assigns a role to multiple users in bulk using [insert].
  _ida.Future<void> assignRoleToUsers({
    required List<String> userIdentifiers,
    required String roleName,
    String? domain,
  }) => caller.callServerEndpoint<void>(
    'serverpod_rbac.rbacAdmin',
    'assignRoleToUsers',
    {
      'userIdentifiers': userIdentifiers,
      'roleName': roleName,
      'domain': domain,
    },
  );

  /// Assigns a role to a user across multiple domains in bulk using [insert].
  _ida.Future<void> assignRoleToUserDomains({
    required String userIdentifier,
    required String roleName,
    required List<String> domains,
  }) => caller.callServerEndpoint<void>(
    'serverpod_rbac.rbacAdmin',
    'assignRoleToUserDomains',
    {
      'userIdentifier': userIdentifier,
      'roleName': roleName,
      'domains': domains,
    },
  );

  /// Removes a role from a user using [deleteRow] or scoped deletion.
  _ida.Future<void> removeRoleFromUser({
    required String userIdentifier,
    required String roleName,
    String? domain,
  }) => caller.callServerEndpoint<void>(
    'serverpod_rbac.rbacAdmin',
    'removeRoleFromUser',
    {
      'userIdentifier': userIdentifier,
      'roleName': roleName,
      'domain': domain,
    },
  );

  /// Removes multiple roles from a user in bulk.
  _ida.Future<void> removeRolesFromUser({
    required String userIdentifier,
    required List<String> roleNames,
    String? domain,
  }) => caller.callServerEndpoint<void>(
    'serverpod_rbac.rbacAdmin',
    'removeRolesFromUser',
    {
      'userIdentifier': userIdentifier,
      'roleNames': roleNames,
      'domain': domain,
    },
  );

  /// Lists user-role assignment records matching filters.
  _ida.Future<List<_ibcgqhlb.RbacUserRole>> listUserRoles({
    String? userIdentifier,
    String? roleName,
    String? domain,
  }) => caller.callServerEndpoint<List<_ibcgqhlb.RbacUserRole>>(
    'serverpod_rbac.rbacAdmin',
    'listUserRoles',
    {
      'userIdentifier': userIdentifier,
      'roleName': roleName,
      'domain': domain,
    },
  );

  /// Gets all roles assigned to a user, optionally filtered by domain.
  _ida.Future<List<_iepuelvo.RbacRole>> getUserRoles(
    String userIdentifier, {
    String? domain,
  }) => caller.callServerEndpoint<List<_iepuelvo.RbacRole>>(
    'serverpod_rbac.rbacAdmin',
    'getUserRoles',
    {
      'userIdentifier': userIdentifier,
      'domain': domain,
    },
  );

  /// Inspects the full permissions snapshot for any user.
  _ida.Future<_iratp19g.RbacUserPermissionsInfo> getUserPermissionsInfo({
    required String userIdentifier,
  }) => caller.callServerEndpoint<_iratp19g.RbacUserPermissionsInfo>(
    'serverpod_rbac.rbacAdmin',
    'getUserPermissionsInfo',
    {'userIdentifier': userIdentifier},
  );

  /// Retrieves domains assigned to [userIdentifier], optionally filtered by permission.
  _ida.Future<List<String>> getUserDomains({
    required String userIdentifier,
    String? permission,
  }) => caller.callServerEndpoint<List<String>>(
    'serverpod_rbac.rbacAdmin',
    'getUserDomains',
    {
      'userIdentifier': userIdentifier,
      'permission': permission,
    },
  );

  /// Evaluates full ABAC domain access for [userIdentifier] and [permission].
  _ida.Future<_i3qazro9.RbacAbacResult> getUserDomainAccess({
    required String userIdentifier,
    required String permission,
  }) => caller.callServerEndpoint<_i3qazro9.RbacAbacResult>(
    'serverpod_rbac.rbacAdmin',
    'getUserDomainAccess',
    {
      'userIdentifier': userIdentifier,
      'permission': permission,
    },
  );

  /// Lists all distinct domains recorded across all user role assignments.
  _ida.Future<List<String>> listAllDomains() =>
      caller.callServerEndpoint<List<String>>(
        'serverpod_rbac.rbacAdmin',
        'listAllDomains',
        {},
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

  /// Retrieves the current authenticated user's permissions, roles, and domains snapshot.
  _ida.Future<_iratp19g.RbacUserPermissionsInfo> getMyPermissions() =>
      caller.callServerEndpoint<_iratp19g.RbacUserPermissionsInfo>(
        'serverpod_rbac.rbac',
        'getMyPermissions',
        {},
      );

  /// Retrieves the current authenticated user's assigned role names.
  _ida.Future<List<String>> getMyRoles({String? domain}) =>
      caller.callServerEndpoint<List<String>>(
        'serverpod_rbac.rbac',
        'getMyRoles',
        {'domain': domain},
      );

  /// Retrieves the domains granted to the current user, optionally filtered by permission.
  _ida.Future<List<String>> getMyDomains({String? permission}) =>
      caller.callServerEndpoint<List<String>>(
        'serverpod_rbac.rbac',
        'getMyDomains',
        {'permission': permission},
      );

  /// Checks if access to [permission] is domain-restricted for the current user.
  _ida.Future<bool> hasDomains(String permission) =>
      caller.callServerEndpoint<bool>(
        'serverpod_rbac.rbac',
        'hasDomains',
        {'permission': permission},
      );

  /// Retrieves full domain access details for [permission] for the current user.
  _ida.Future<_i3qazro9.RbacAbacResult> getMyDomainAccess(String permission) =>
      caller.callServerEndpoint<_i3qazro9.RbacAbacResult>(
        'serverpod_rbac.rbac',
        'getMyDomainAccess',
        {'permission': permission},
      );

  /// Checks if the current authenticated user has a specific permission.
  _ida.Future<bool> hasPermission(
    String permission, {
    String? domain,
  }) => caller.callServerEndpoint<bool>(
    'serverpod_rbac.rbac',
    'hasPermission',
    {
      'permission': permission,
      'domain': domain,
    },
  );

  /// Checks if the current authenticated user has all specified permissions.
  _ida.Future<bool> hasAllPermissions(
    List<String> permissions, {
    String? domain,
  }) => caller.callServerEndpoint<bool>(
    'serverpod_rbac.rbac',
    'hasAllPermissions',
    {
      'permissions': permissions,
      'domain': domain,
    },
  );

  /// Checks if the current authenticated user has any specified permission.
  _ida.Future<bool> hasAnyPermission(
    List<String> permissions, {
    String? domain,
  }) => caller.callServerEndpoint<bool>(
    'serverpod_rbac.rbac',
    'hasAnyPermission',
    {
      'permissions': permissions,
      'domain': domain,
    },
  );

  /// Checks if the current authenticated user has a specific role.
  _ida.Future<bool> hasRole(
    String role, {
    String? domain,
  }) => caller.callServerEndpoint<bool>(
    'serverpod_rbac.rbac',
    'hasRole',
    {
      'role': role,
      'domain': domain,
    },
  );

  /// Checks if the current authenticated user has any specified role.
  _ida.Future<bool> hasAnyRole(
    List<String> roles, {
    String? domain,
  }) => caller.callServerEndpoint<bool>(
    'serverpod_rbac.rbac',
    'hasAnyRole',
    {
      'roles': roles,
      'domain': domain,
    },
  );

  /// Checks if the current authenticated user has all specified roles.
  _ida.Future<bool> hasAllRoles(
    List<String> roles, {
    String? domain,
  }) => caller.callServerEndpoint<bool>(
    'serverpod_rbac.rbac',
    'hasAllRoles',
    {
      'roles': roles,
      'domain': domain,
    },
  );

  /// Enforces that the current authenticated user has [permission].
  _ida.Future<void> requirePermission(
    String permission, {
    String? domain,
  }) => caller.callServerEndpoint<void>(
    'serverpod_rbac.rbac',
    'requirePermission',
    {
      'permission': permission,
      'domain': domain,
    },
  );

  /// Enforces that the current authenticated user has all [permissions].
  _ida.Future<void> requireAllPermissions(
    List<String> permissions, {
    String? domain,
  }) => caller.callServerEndpoint<void>(
    'serverpod_rbac.rbac',
    'requireAllPermissions',
    {
      'permissions': permissions,
      'domain': domain,
    },
  );

  /// Enforces that the current authenticated user has any [permissions].
  _ida.Future<void> requireAnyPermission(
    List<String> permissions, {
    String? domain,
  }) => caller.callServerEndpoint<void>(
    'serverpod_rbac.rbac',
    'requireAnyPermission',
    {
      'permissions': permissions,
      'domain': domain,
    },
  );

  /// Enforces that the current authenticated user has [role].
  _ida.Future<void> requireRole(
    String role, {
    String? domain,
  }) => caller.callServerEndpoint<void>(
    'serverpod_rbac.rbac',
    'requireRole',
    {
      'role': role,
      'domain': domain,
    },
  );

  /// Enforces that the current authenticated user has all [roles].
  _ida.Future<void> requireAllRoles(
    List<String> roles, {
    String? domain,
  }) => caller.callServerEndpoint<void>(
    'serverpod_rbac.rbac',
    'requireAllRoles',
    {
      'roles': roles,
      'domain': domain,
    },
  );

  /// Enforces that the current authenticated user has any [roles].
  _ida.Future<void> requireAnyRole(
    List<String> roles, {
    String? domain,
  }) => caller.callServerEndpoint<void>(
    'serverpod_rbac.rbac',
    'requireAnyRole',
    {
      'roles': roles,
      'domain': domain,
    },
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
