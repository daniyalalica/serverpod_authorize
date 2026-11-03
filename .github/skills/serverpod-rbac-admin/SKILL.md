---
name: serverpod-rbac-admin
description: "Use when building or operating an RBAC administration workflow with serverpod_rbac: create permissions and roles, grant/revoke assignments, manage ABAC domain rules, inspect users, or call the protected rbacAdmin Serverpod endpoint."
---

# Serverpod RBAC: Administration

Use `RbacAdminEndpoint` for administrator-facing RPC operations, normally from
a protected admin interface via `client.rbacAdmin`. Server code can also use
`RbacService.instance` and `AbacService.instance` directly, but those services
do not perform admin authorization automatically.

For end-user self-service calls, load `serverpod-rbac-flutter`. For endpoint
authorization and server-side query filtering, load `serverpod-rbac-server`.
Keep this skill versioned with the package so consuming projects can use it.

## Authorization Requirements

`RbacAdminEndpoint` requires login and checks each operation on the server.
The caller must be either:

1. A superuser (Serverpod `Scope.admin`, the server-configured custom
   superuser resolver, or an assigned role with `isSuperuser: true`); or
2. A user with the `rbac.manage` permission.

The endpoint returns `RbacException` with reason `permissionDenied` when
neither applies. Because `rbac.manage` must itself be granted, bootstrap an
initial superuser or create the initial admin assignment through trusted
server-side setup. Never let an untrusted client assign `rbac.manage`,
superuser status, or `isSystemRole`.

## Client Setup

With the project's generated Serverpod client and authentication session
manager configured, call `client.rbacAdmin` from a signed-in administrator
flow. Add `serverpod_rbac_client` to the client package and import its public
library for generated models:

```dart
import 'package:serverpod_rbac_client/serverpod_rbac_client.dart';

final role = await client.rbacAdmin.createRole(
  name: 'invoice_reader',
);
```

The `RbacAdminEndpoint` methods require no manually supplied `Session` from
Flutter; Serverpod supplies the authenticated request context. In server
integration tests, call through the generated `endpoints.rbacAdmin` test
connector.

## Complete `client.rbacAdmin` API

### Permissions

| Method | Purpose |
|---|---|
| `createPermission({required resource, required codename, required name, description})` | Creates or returns the matching normalized permission. |
| `createPermissions(List<RbacPermission> permissions)` | Bulk-creates permission definitions; duplicate conflicts are ignored. |
| `listPermissions({resource})` | Lists all permissions or filters by resource. |
| `deletePermission(int permissionId)` | Deletes one permission by ID if present. |
| `deletePermissions(List<int> permissionIds)` | Deletes many permission definitions by ID. |

Create permission definitions before connecting them to roles. Permission
keys such as `invoice.read` use the normalized `resource.codename` format.

### Roles

| Method | Purpose |
|---|---|
| `createRole({required name, description, isSuperuser, isSystemRole})` | Creates or returns a normalized role; flags default to false. |
| `createRoles(List<RbacRole> roles)` | Bulk-creates roles; duplicate conflicts are ignored. |
| `listRoles()` | Lists roles with their permission information. |
| `deleteRole(String name)` | Deletes a role; deletion of a system role throws `roleDenied`. |
| `deleteRoles(List<String> names)` | Bulk-deletes matching roles but skips system roles. |

Only trusted administrators should be able to set `isSuperuser` or
`isSystemRole`. Single-role deletion rejects a system role; bulk deletion
silently skips system roles, so do not present it as an all-or-nothing delete.

### Role-Permission Assignments

| Method | Purpose |
|---|---|
| `assignPermissionsToRole({required roleName, required permissions})` | Adds links for known permissions; duplicate links are ignored and unknown permission keys skipped. |
| `removePermissionsFromRole({required roleName, required permissions})` | Removes matching role-permission links. |
| `getRolePermissions(String roleName)` | Returns the permission definitions linked to the role. |

An unknown role when assigning permissions throws `roleNotFound`; removal for
a missing role is a no-op.

### User-Role Assignments and Inspection

| Method | Purpose |
|---|---|
| `assignRoleToUser({required userIdentifier, required roleName})` | Assigns one role; returns the assignment; duplicate assignment returns the existing record. |
| `assignRolesToUser({required userIdentifier, required roleNames})` | Bulk-assigns matching roles to one user. |
| `assignRoleToUsers({required userIdentifiers, required roleName})` | Bulk-assigns one role to multiple users. |
| `removeRoleFromUser({required userIdentifier, required roleName})` | Removes one assignment. |
| `removeRolesFromUser({required userIdentifier, required roleNames})` | Removes multiple assignments from one user. |
| `listUserRoles({userIdentifier, roleName})` | Lists assignment records; either or both filters may be omitted. |
| `getUserRoles(String userIdentifier)` | Gets role models assigned to a user. |
| `getUserPermissionsInfo({required userIdentifier})` | Gets a user's roles, permissions, and superuser snapshot. |

The service does not create identity-provider users: `userIdentifier` must be
the identifier used by the host Serverpod authentication system. Verify that
the admin operator is authorized to target the selected account.

### ABAC Domain Rules

| Method | Purpose |
|---|---|
| `addDomainRule({required roleName, required resource, required filterExpression, permission, description})` | Adds one rule. If `permission` is omitted, the rule applies resource-wide. |
| `addDomainRules(List<RbacDomainRule> rules)` | Adds multiple rules in bulk. |
| `removeDomainRule(int ruleId)` | Deletes one rule by ID if present. |
| `clearDomainRules({required roleName, resource, permission})` | Clears all rules for a role, optionally narrowed by resource and permission. |
| `listDomainRules({required roleName, resource, permission})` | Lists a role's rules, optionally filtered by resource and permission. |

The library trims expressions and rejects empty resources/expressions; it does
not parse or validate the filter grammar. Validate rules against the
application's schema and allowed fields before saving. Use dot-separated
permission keys, for example `invoice.read`.

### User Domain Inspection

| Method | Purpose |
|---|---|
| `getUserDomainFilters({required userIdentifier, required permission, resource})` | Returns expressions for a user's permission decision. |
| `getUserDomainAccess({required userIdentifier, required permission, resource})` | Returns the complete allowed/restricted/unrestricted result. |
| `getAllUserDomainFilters({required userIdentifier, resource})` | Returns distinct expressions across a user's roles for inspection. |

Use `getUserDomainAccess` when inspecting an actual protected decision.
`getUserDomainFilters` returns expressions only, and `getAllUserDomainFilters`
does not check whether every role grants the queried permission; do not use
either list-only result as an access decision.

## Operational Guidance

- Assign permissions to roles, then assign roles to users. Use stable
  application permission names and role names; the service trims and
  lowercases them.
- Batch operations (`createPermissions`, `createRoles`,
  `assignPermissionsToRole`, `assignRolesToUser`, `assignRoleToUsers`,
  `removeRolesFromUser`, `addDomainRules`, and `deletePermissions`/
  `deleteRoles`) reduce RPC overhead for admin screens.
- Empty bulk inputs are generally no-ops or empty results. Unknown role
  assignments are not created; role-required operations throw
  `RbacException(roleNotFound)`.
- Treat permission deletion carefully: permissions may be linked to roles and
  relation delete behavior is defined by the generated model/database schema.
- Service and ABAC mutations invalidate authorization caches. If a separate
  trusted process writes the models directly, it must invalidate the cache.
- Admin RPC access and UI hiding are separate: the server's
  `_checkAdminAccess` is the security boundary. Do not remove it or rely on
  client-side role state for enforcement.

## Server-Side Bootstrap

The RPC endpoint and service methods are thin wrappers over these server
singletons:

```dart
final rbac = RbacService.instance;
final abac = AbacService.instance;

await rbac.createRole(session, name: 'rbac_admin', isSuperuser: true);
await rbac.assignRoleToUser(
  session,
  userIdentifier: trustedBootstrapUserIdentifier,
  roleName: 'rbac_admin',
);
```

Only execute bootstrap with a trusted user identifier in a controlled
server-side setup path. Normal runtime clients should use the protected admin
RPC API.

## Related Complete API Index

The full self-service Flutter endpoint (`client.rbac`), including all
permission/role checks and `require*` methods, is documented in
`serverpod-rbac-flutter`. Server-side `RbacService`, `AbacService`,
`SessionRbacContext`, `SessionAbacContext`, and cache methods are documented
in `serverpod-rbac-server`.

Implementation source of truth:

- `serverpod_rbac_server/lib/src/endpoints/rbac_admin_endpoint.dart`
- `serverpod_rbac_server/lib/src/rbac_service.dart`
- `serverpod_rbac_server/lib/src/abac_service.dart`
- `serverpod_rbac_client/lib/src/protocol/client.dart`
- `TECHNICAL_GUIDE.md` at the package repository root
