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
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_rbac_server/src/generated/rbac_domain_rule.dart'
    as _i4vx2l3o;
import 'package:serverpod_rbac_server/src/generated/rbac_permission.dart'
    as _i44dc49h;
import 'package:serverpod_rbac_server/src/generated/rbac_role.dart'
    as _inzb62ef;
import '../endpoints/rbac_admin_endpoint.dart' as _i6tj1yeq;
import '../endpoints/rbac_endpoint.dart' as _iuygqbq6;

class Endpoints extends _is.EndpointDispatch {
  @override
  void initializeEndpoints(_is.Server server) {
    var endpoints = <String, _is.Endpoint>{
      'rbacAdmin': _i6tj1yeq.RbacAdminEndpoint()
        ..initialize(
          server,
          'rbacAdmin',
          'serverpod_rbac',
        ),
      'rbac': _iuygqbq6.RbacEndpoint()
        ..initialize(
          server,
          'rbac',
          'serverpod_rbac',
        ),
    };
    connectors['rbacAdmin'] = _is.EndpointConnector(
      name: 'rbacAdmin',
      endpoint: endpoints['rbacAdmin']!,
      methodConnectors: {
        'createPermission': _is.MethodConnector(
          name: 'createPermission',
          params: {
            'resource': _is.ParameterDescription(
              name: 'resource',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'codename': _is.ParameterDescription(
              name: 'codename',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'name': _is.ParameterDescription(
              name: 'name',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'description': _is.ParameterDescription(
              name: 'description',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['rbacAdmin'] as _i6tj1yeq.RbacAdminEndpoint)
                  .createPermission(
                    session,
                    resource: params['resource'],
                    codename: params['codename'],
                    name: params['name'],
                    description: params['description'],
                  ),
        ),
        'createPermissions': _is.MethodConnector(
          name: 'createPermissions',
          params: {
            'permissions': _is.ParameterDescription(
              name: 'permissions',
              type: _is.getType<List<_i44dc49h.RbacPermission>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['rbacAdmin'] as _i6tj1yeq.RbacAdminEndpoint)
                  .createPermissions(
                    session,
                    params['permissions'],
                  ),
        ),
        'listPermissions': _is.MethodConnector(
          name: 'listPermissions',
          params: {
            'resource': _is.ParameterDescription(
              name: 'resource',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['rbacAdmin'] as _i6tj1yeq.RbacAdminEndpoint)
                  .listPermissions(
                    session,
                    resource: params['resource'],
                  ),
        ),
        'deletePermission': _is.MethodConnector(
          name: 'deletePermission',
          params: {
            'permissionId': _is.ParameterDescription(
              name: 'permissionId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['rbacAdmin'] as _i6tj1yeq.RbacAdminEndpoint)
                  .deletePermission(
                    session,
                    params['permissionId'],
                  ),
        ),
        'deletePermissions': _is.MethodConnector(
          name: 'deletePermissions',
          params: {
            'permissionIds': _is.ParameterDescription(
              name: 'permissionIds',
              type: _is.getType<List<int>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['rbacAdmin'] as _i6tj1yeq.RbacAdminEndpoint)
                  .deletePermissions(
                    session,
                    params['permissionIds'],
                  ),
        ),
        'createRole': _is.MethodConnector(
          name: 'createRole',
          params: {
            'name': _is.ParameterDescription(
              name: 'name',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'description': _is.ParameterDescription(
              name: 'description',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'isSuperuser': _is.ParameterDescription(
              name: 'isSuperuser',
              type: _is.getType<bool?>(),
              nullable: true,
            ),
            'isSystemRole': _is.ParameterDescription(
              name: 'isSystemRole',
              type: _is.getType<bool?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['rbacAdmin'] as _i6tj1yeq.RbacAdminEndpoint)
                  .createRole(
                    session,
                    name: params['name'],
                    description: params['description'],
                    isSuperuser: params['isSuperuser'],
                    isSystemRole: params['isSystemRole'],
                  ),
        ),
        'createRoles': _is.MethodConnector(
          name: 'createRoles',
          params: {
            'roles': _is.ParameterDescription(
              name: 'roles',
              type: _is.getType<List<_inzb62ef.RbacRole>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['rbacAdmin'] as _i6tj1yeq.RbacAdminEndpoint)
                  .createRoles(
                    session,
                    params['roles'],
                  ),
        ),
        'listRoles': _is.MethodConnector(
          name: 'listRoles',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['rbacAdmin'] as _i6tj1yeq.RbacAdminEndpoint)
                  .listRoles(session),
        ),
        'deleteRole': _is.MethodConnector(
          name: 'deleteRole',
          params: {
            'name': _is.ParameterDescription(
              name: 'name',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['rbacAdmin'] as _i6tj1yeq.RbacAdminEndpoint)
                  .deleteRole(
                    session,
                    params['name'],
                  ),
        ),
        'deleteRoles': _is.MethodConnector(
          name: 'deleteRoles',
          params: {
            'names': _is.ParameterDescription(
              name: 'names',
              type: _is.getType<List<String>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['rbacAdmin'] as _i6tj1yeq.RbacAdminEndpoint)
                  .deleteRoles(
                    session,
                    params['names'],
                  ),
        ),
        'assignPermissionsToRole': _is.MethodConnector(
          name: 'assignPermissionsToRole',
          params: {
            'roleName': _is.ParameterDescription(
              name: 'roleName',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'permissions': _is.ParameterDescription(
              name: 'permissions',
              type: _is.getType<List<String>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['rbacAdmin'] as _i6tj1yeq.RbacAdminEndpoint)
                  .assignPermissionsToRole(
                    session,
                    roleName: params['roleName'],
                    permissions: params['permissions'],
                  ),
        ),
        'removePermissionsFromRole': _is.MethodConnector(
          name: 'removePermissionsFromRole',
          params: {
            'roleName': _is.ParameterDescription(
              name: 'roleName',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'permissions': _is.ParameterDescription(
              name: 'permissions',
              type: _is.getType<List<String>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['rbacAdmin'] as _i6tj1yeq.RbacAdminEndpoint)
                  .removePermissionsFromRole(
                    session,
                    roleName: params['roleName'],
                    permissions: params['permissions'],
                  ),
        ),
        'getRolePermissions': _is.MethodConnector(
          name: 'getRolePermissions',
          params: {
            'roleName': _is.ParameterDescription(
              name: 'roleName',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['rbacAdmin'] as _i6tj1yeq.RbacAdminEndpoint)
                  .getRolePermissions(
                    session,
                    params['roleName'],
                  ),
        ),
        'assignRoleToUser': _is.MethodConnector(
          name: 'assignRoleToUser',
          params: {
            'userIdentifier': _is.ParameterDescription(
              name: 'userIdentifier',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'roleName': _is.ParameterDescription(
              name: 'roleName',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['rbacAdmin'] as _i6tj1yeq.RbacAdminEndpoint)
                  .assignRoleToUser(
                    session,
                    userIdentifier: params['userIdentifier'],
                    roleName: params['roleName'],
                  ),
        ),
        'assignRolesToUser': _is.MethodConnector(
          name: 'assignRolesToUser',
          params: {
            'userIdentifier': _is.ParameterDescription(
              name: 'userIdentifier',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'roleNames': _is.ParameterDescription(
              name: 'roleNames',
              type: _is.getType<List<String>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['rbacAdmin'] as _i6tj1yeq.RbacAdminEndpoint)
                  .assignRolesToUser(
                    session,
                    userIdentifier: params['userIdentifier'],
                    roleNames: params['roleNames'],
                  ),
        ),
        'assignRoleToUsers': _is.MethodConnector(
          name: 'assignRoleToUsers',
          params: {
            'userIdentifiers': _is.ParameterDescription(
              name: 'userIdentifiers',
              type: _is.getType<List<String>>(),
              nullable: false,
            ),
            'roleName': _is.ParameterDescription(
              name: 'roleName',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['rbacAdmin'] as _i6tj1yeq.RbacAdminEndpoint)
                  .assignRoleToUsers(
                    session,
                    userIdentifiers: params['userIdentifiers'],
                    roleName: params['roleName'],
                  ),
        ),
        'removeRoleFromUser': _is.MethodConnector(
          name: 'removeRoleFromUser',
          params: {
            'userIdentifier': _is.ParameterDescription(
              name: 'userIdentifier',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'roleName': _is.ParameterDescription(
              name: 'roleName',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['rbacAdmin'] as _i6tj1yeq.RbacAdminEndpoint)
                  .removeRoleFromUser(
                    session,
                    userIdentifier: params['userIdentifier'],
                    roleName: params['roleName'],
                  ),
        ),
        'removeRolesFromUser': _is.MethodConnector(
          name: 'removeRolesFromUser',
          params: {
            'userIdentifier': _is.ParameterDescription(
              name: 'userIdentifier',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'roleNames': _is.ParameterDescription(
              name: 'roleNames',
              type: _is.getType<List<String>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['rbacAdmin'] as _i6tj1yeq.RbacAdminEndpoint)
                  .removeRolesFromUser(
                    session,
                    userIdentifier: params['userIdentifier'],
                    roleNames: params['roleNames'],
                  ),
        ),
        'listUserRoles': _is.MethodConnector(
          name: 'listUserRoles',
          params: {
            'userIdentifier': _is.ParameterDescription(
              name: 'userIdentifier',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'roleName': _is.ParameterDescription(
              name: 'roleName',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['rbacAdmin'] as _i6tj1yeq.RbacAdminEndpoint)
                  .listUserRoles(
                    session,
                    userIdentifier: params['userIdentifier'],
                    roleName: params['roleName'],
                  ),
        ),
        'getUserRoles': _is.MethodConnector(
          name: 'getUserRoles',
          params: {
            'userIdentifier': _is.ParameterDescription(
              name: 'userIdentifier',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['rbacAdmin'] as _i6tj1yeq.RbacAdminEndpoint)
                  .getUserRoles(
                    session,
                    params['userIdentifier'],
                  ),
        ),
        'getUserPermissionsInfo': _is.MethodConnector(
          name: 'getUserPermissionsInfo',
          params: {
            'userIdentifier': _is.ParameterDescription(
              name: 'userIdentifier',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['rbacAdmin'] as _i6tj1yeq.RbacAdminEndpoint)
                  .getUserPermissionsInfo(
                    session,
                    userIdentifier: params['userIdentifier'],
                  ),
        ),
        'addDomainRule': _is.MethodConnector(
          name: 'addDomainRule',
          params: {
            'roleName': _is.ParameterDescription(
              name: 'roleName',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'resource': _is.ParameterDescription(
              name: 'resource',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'filterExpression': _is.ParameterDescription(
              name: 'filterExpression',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'permission': _is.ParameterDescription(
              name: 'permission',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'description': _is.ParameterDescription(
              name: 'description',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['rbacAdmin'] as _i6tj1yeq.RbacAdminEndpoint)
                  .addDomainRule(
                    session,
                    roleName: params['roleName'],
                    resource: params['resource'],
                    filterExpression: params['filterExpression'],
                    permission: params['permission'],
                    description: params['description'],
                  ),
        ),
        'addDomainRules': _is.MethodConnector(
          name: 'addDomainRules',
          params: {
            'rules': _is.ParameterDescription(
              name: 'rules',
              type: _is.getType<List<_i4vx2l3o.RbacDomainRule>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['rbacAdmin'] as _i6tj1yeq.RbacAdminEndpoint)
                  .addDomainRules(
                    session,
                    params['rules'],
                  ),
        ),
        'removeDomainRule': _is.MethodConnector(
          name: 'removeDomainRule',
          params: {
            'ruleId': _is.ParameterDescription(
              name: 'ruleId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['rbacAdmin'] as _i6tj1yeq.RbacAdminEndpoint)
                  .removeDomainRule(
                    session,
                    params['ruleId'],
                  ),
        ),
        'clearDomainRules': _is.MethodConnector(
          name: 'clearDomainRules',
          params: {
            'roleName': _is.ParameterDescription(
              name: 'roleName',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'resource': _is.ParameterDescription(
              name: 'resource',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'permission': _is.ParameterDescription(
              name: 'permission',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['rbacAdmin'] as _i6tj1yeq.RbacAdminEndpoint)
                  .clearDomainRules(
                    session,
                    roleName: params['roleName'],
                    resource: params['resource'],
                    permission: params['permission'],
                  ),
        ),
        'listDomainRules': _is.MethodConnector(
          name: 'listDomainRules',
          params: {
            'roleName': _is.ParameterDescription(
              name: 'roleName',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'resource': _is.ParameterDescription(
              name: 'resource',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'permission': _is.ParameterDescription(
              name: 'permission',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['rbacAdmin'] as _i6tj1yeq.RbacAdminEndpoint)
                  .listDomainRules(
                    session,
                    roleName: params['roleName'],
                    resource: params['resource'],
                    permission: params['permission'],
                  ),
        ),
        'getUserDomainFilters': _is.MethodConnector(
          name: 'getUserDomainFilters',
          params: {
            'userIdentifier': _is.ParameterDescription(
              name: 'userIdentifier',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'permission': _is.ParameterDescription(
              name: 'permission',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'resource': _is.ParameterDescription(
              name: 'resource',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['rbacAdmin'] as _i6tj1yeq.RbacAdminEndpoint)
                  .getUserDomainFilters(
                    session,
                    userIdentifier: params['userIdentifier'],
                    permission: params['permission'],
                    resource: params['resource'],
                  ),
        ),
        'getUserDomainAccess': _is.MethodConnector(
          name: 'getUserDomainAccess',
          params: {
            'userIdentifier': _is.ParameterDescription(
              name: 'userIdentifier',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'permission': _is.ParameterDescription(
              name: 'permission',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'resource': _is.ParameterDescription(
              name: 'resource',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['rbacAdmin'] as _i6tj1yeq.RbacAdminEndpoint)
                  .getUserDomainAccess(
                    session,
                    userIdentifier: params['userIdentifier'],
                    permission: params['permission'],
                    resource: params['resource'],
                  ),
        ),
        'getAllUserDomainFilters': _is.MethodConnector(
          name: 'getAllUserDomainFilters',
          params: {
            'userIdentifier': _is.ParameterDescription(
              name: 'userIdentifier',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'resource': _is.ParameterDescription(
              name: 'resource',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['rbacAdmin'] as _i6tj1yeq.RbacAdminEndpoint)
                  .getAllUserDomainFilters(
                    session,
                    userIdentifier: params['userIdentifier'],
                    resource: params['resource'],
                  ),
        ),
      },
    );
    connectors['rbac'] = _is.EndpointConnector(
      name: 'rbac',
      endpoint: endpoints['rbac']!,
      methodConnectors: {
        'isSuperuser': _is.MethodConnector(
          name: 'isSuperuser',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['rbac'] as _iuygqbq6.RbacEndpoint)
                  .isSuperuser(session),
        ),
        'getMyPermissions': _is.MethodConnector(
          name: 'getMyPermissions',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['rbac'] as _iuygqbq6.RbacEndpoint)
                  .getMyPermissions(session),
        ),
        'getMyRoles': _is.MethodConnector(
          name: 'getMyRoles',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['rbac'] as _iuygqbq6.RbacEndpoint)
                  .getMyRoles(session),
        ),
        'hasDomains': _is.MethodConnector(
          name: 'hasDomains',
          params: {
            'permission': _is.ParameterDescription(
              name: 'permission',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'resource': _is.ParameterDescription(
              name: 'resource',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['rbac'] as _iuygqbq6.RbacEndpoint).hasDomains(
                    session,
                    params['permission'],
                    resource: params['resource'],
                  ),
        ),
        'getMyDomainFilters': _is.MethodConnector(
          name: 'getMyDomainFilters',
          params: {
            'permission': _is.ParameterDescription(
              name: 'permission',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'resource': _is.ParameterDescription(
              name: 'resource',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['rbac'] as _iuygqbq6.RbacEndpoint)
                  .getMyDomainFilters(
                    session,
                    params['permission'],
                    resource: params['resource'],
                  ),
        ),
        'getMyDomainAccess': _is.MethodConnector(
          name: 'getMyDomainAccess',
          params: {
            'permission': _is.ParameterDescription(
              name: 'permission',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'resource': _is.ParameterDescription(
              name: 'resource',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['rbac'] as _iuygqbq6.RbacEndpoint)
                  .getMyDomainAccess(
                    session,
                    params['permission'],
                    resource: params['resource'],
                  ),
        ),
        'getMyAllDomainFilters': _is.MethodConnector(
          name: 'getMyAllDomainFilters',
          params: {
            'resource': _is.ParameterDescription(
              name: 'resource',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['rbac'] as _iuygqbq6.RbacEndpoint)
                  .getMyAllDomainFilters(
                    session,
                    resource: params['resource'],
                  ),
        ),
        'hasPermission': _is.MethodConnector(
          name: 'hasPermission',
          params: {
            'permission': _is.ParameterDescription(
              name: 'permission',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['rbac'] as _iuygqbq6.RbacEndpoint).hasPermission(
                    session,
                    params['permission'],
                  ),
        ),
        'hasAllPermissions': _is.MethodConnector(
          name: 'hasAllPermissions',
          params: {
            'permissions': _is.ParameterDescription(
              name: 'permissions',
              type: _is.getType<List<String>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['rbac'] as _iuygqbq6.RbacEndpoint)
                  .hasAllPermissions(
                    session,
                    params['permissions'],
                  ),
        ),
        'hasAnyPermission': _is.MethodConnector(
          name: 'hasAnyPermission',
          params: {
            'permissions': _is.ParameterDescription(
              name: 'permissions',
              type: _is.getType<List<String>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['rbac'] as _iuygqbq6.RbacEndpoint)
                  .hasAnyPermission(
                    session,
                    params['permissions'],
                  ),
        ),
        'hasRole': _is.MethodConnector(
          name: 'hasRole',
          params: {
            'role': _is.ParameterDescription(
              name: 'role',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['rbac'] as _iuygqbq6.RbacEndpoint).hasRole(
                session,
                params['role'],
              ),
        ),
        'hasAnyRole': _is.MethodConnector(
          name: 'hasAnyRole',
          params: {
            'roles': _is.ParameterDescription(
              name: 'roles',
              type: _is.getType<List<String>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['rbac'] as _iuygqbq6.RbacEndpoint).hasAnyRole(
                    session,
                    params['roles'],
                  ),
        ),
        'hasAllRoles': _is.MethodConnector(
          name: 'hasAllRoles',
          params: {
            'roles': _is.ParameterDescription(
              name: 'roles',
              type: _is.getType<List<String>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['rbac'] as _iuygqbq6.RbacEndpoint).hasAllRoles(
                    session,
                    params['roles'],
                  ),
        ),
        'requirePermission': _is.MethodConnector(
          name: 'requirePermission',
          params: {
            'permission': _is.ParameterDescription(
              name: 'permission',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['rbac'] as _iuygqbq6.RbacEndpoint)
                  .requirePermission(
                    session,
                    params['permission'],
                  ),
        ),
        'requireAllPermissions': _is.MethodConnector(
          name: 'requireAllPermissions',
          params: {
            'permissions': _is.ParameterDescription(
              name: 'permissions',
              type: _is.getType<List<String>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['rbac'] as _iuygqbq6.RbacEndpoint)
                  .requireAllPermissions(
                    session,
                    params['permissions'],
                  ),
        ),
        'requireAnyPermission': _is.MethodConnector(
          name: 'requireAnyPermission',
          params: {
            'permissions': _is.ParameterDescription(
              name: 'permissions',
              type: _is.getType<List<String>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['rbac'] as _iuygqbq6.RbacEndpoint)
                  .requireAnyPermission(
                    session,
                    params['permissions'],
                  ),
        ),
        'requireRole': _is.MethodConnector(
          name: 'requireRole',
          params: {
            'role': _is.ParameterDescription(
              name: 'role',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['rbac'] as _iuygqbq6.RbacEndpoint).requireRole(
                    session,
                    params['role'],
                  ),
        ),
        'requireAllRoles': _is.MethodConnector(
          name: 'requireAllRoles',
          params: {
            'roles': _is.ParameterDescription(
              name: 'roles',
              type: _is.getType<List<String>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['rbac'] as _iuygqbq6.RbacEndpoint).requireAllRoles(
                    session,
                    params['roles'],
                  ),
        ),
        'requireAnyRole': _is.MethodConnector(
          name: 'requireAnyRole',
          params: {
            'roles': _is.ParameterDescription(
              name: 'roles',
              type: _is.getType<List<String>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['rbac'] as _iuygqbq6.RbacEndpoint).requireAnyRole(
                    session,
                    params['roles'],
                  ),
        ),
        'requireSuperuser': _is.MethodConnector(
          name: 'requireSuperuser',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['rbac'] as _iuygqbq6.RbacEndpoint)
                  .requireSuperuser(session),
        ),
      },
    );
  }
}
