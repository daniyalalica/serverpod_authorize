---
name: serverpod-rbac-flutter
description: "Use when integrating serverpod_rbac into a Flutter app: install the generated client package, call self-service RBAC endpoints, display roles and permissions, handle ABAC access results, or gate UI based on the signed-in user's access."
---

# Serverpod RBAC: Flutter Client Use

Use `serverpod_rbac_client` from Flutter/client code. The client package
provides generated RPC endpoint references and serializable protocol models;
it does not expose server-only `RbacService`, `AbacService`, `Session`, or
database APIs.

For server-side checks and query enforcement, load `serverpod-rbac-server`.
For administrative RPC operations, load `serverpod-rbac-admin`.
Keep this skill versioned with the package so consuming projects can use it.

## Setup and Authentication

Add the client package to the Flutter app:

```yaml
dependencies:
  serverpod_rbac_client: ^1.0.0
```

Use the generated client supplied by the Serverpod project and configure its
normal authentication session manager. The library endpoint nickname is
`rbac`; after generator registration, its self-service API is
`client.rbac`.

```dart
import 'package:serverpod_rbac_client/serverpod_rbac_client.dart';

final info = await client.rbac.getMyPermissions();
```

The user's identity is the authenticated Serverpod session identity. The
self-service endpoint takes no user ID: do not send an arbitrary ID to inspect
another account. Make sure the app's auth manager is signed in before calling
these endpoints.

Both `RbacEndpoint` and `RbacAdminEndpoint` require login. RPC calls are
asynchronous and can throw Serverpod/RBAC exceptions; present errors or
reauthenticate explicitly rather than treating failures as an allow decision.

## Complete Self-Service `client.rbac` API

Every method below is generated in `EndpointRbac`; it operates on the current
authenticated user:

| Method | Return / purpose |
|---|---|
| `isSuperuser()` | `Future<bool>`; current user's superuser state. |
| `getMyPermissions()` | `Future<RbacUserPermissionsInfo>`; user ID, role names, permission keys, and `isSuperuser`. |
| `getMyRoles()` | `Future<List<String>>`; current role names. |
| `hasPermission(permission)` | `Future<bool>`; one permission check. |
| `hasAllPermissions(permissions)` | `Future<bool>`; all requested permissions (AND). |
| `hasAnyPermission(permissions)` | `Future<bool>`; any requested permission (OR). |
| `hasRole(role)` | `Future<bool>`; one role check. |
| `hasAllRoles(roles)` | `Future<bool>`; all requested roles (AND). |
| `hasAnyRole(roles)` | `Future<bool>`; any requested role (OR). |
| `requirePermission(permission)` | `Future<void>`; throws on unauthenticated or denied access. |
| `requireAllPermissions(permissions)` | `Future<void>`; throws unless every permission is granted. |
| `requireAnyPermission(permissions)` | `Future<void>`; throws unless any permission is granted. |
| `requireRole(role)` | `Future<void>`; throws unless the role is granted. |
| `requireAllRoles(roles)` | `Future<void>`; throws unless every role is granted. |
| `requireAnyRole(roles)` | `Future<void>`; throws unless any role is granted. |
| `requireSuperuser()` | `Future<void>`; throws unless current user is a superuser. |
| `hasDomains(permission, resource:)` | `Future<bool>`; whether row filters apply; not an allow/deny result by itself. |
| `getMyDomainFilters(permission, resource:)` | `Future<List<String>>`; expressions only; empty list is ambiguous. |
| `getMyDomainAccess(permission, resource:)` | `Future<RbacAbacResult>`; full allowed/unrestricted/restricted decision. |
| `getMyAllDomainFilters(resource:)` | `Future<List<String>>`; inspection of all current-user role filters, not a permission grant check. |

Examples:

```dart
final allowed = await client.rbac.hasPermission('invoice.read');
final roles = await client.rbac.getMyRoles();
final snapshot = await client.rbac.getMyPermissions();

if (allowed) {
  // Show the relevant control for convenience.
}
```

For a protected RPC, the server must still independently authorize. Flutter
checks only shape the user experience; a client can be modified or bypassed.
Prefer handling a server-side denial rather than assuming a prior UI check
remains valid indefinitely.

## Reading Permission and ABAC Results

`RbacUserPermissionsInfo` provides `userIdentifier`, `isSuperuser`, `roles`,
and `permissions`. Permission strings are normalized keys such as
`invoice.read`; role and permission sets may be presented for UI purposes.

Use `getMyDomainAccess` for row-scoped behavior:

```dart
final access = await client.rbac.getMyDomainAccess(
  'invoice.read',
  resource: 'invoice',
);

if (!access.isAllowed) {
  // Hide/deny the feature and do not request protected data.
} else if (access.isUnrestricted) {
  // The server may query without a row filter.
} else {
  // access.filterExpressions contains opaque JSON filter expressions.
}
```

`RbacAbacResult` includes `isAllowed`, `hasDomains`, `isUnrestricted`,
`filterExpressions`, `permission`, `resource`, `roleName`, and
`userIdentifier` where available. Do not equate `hasDomains == false` with
allowed: check `isAllowed`. An empty expression list can represent denial or
unrestricted access. The Flutter app should not compile or apply row filters
to secure data; the server must apply them to its database query. The server
library does not validate/execute domain expressions.

## Using the Admin Client Surface

Privileged client interfaces call `client.rbacAdmin`; all its operations are
listed in `serverpod-rbac-admin`. The endpoint enforces authorization on the
server and permits a superuser or a user granted `rbac.manage`. Hiding admin
screens in Flutter is not a substitute for this server-side check.

## Source of Truth

Generated endpoint signatures and models are in the `serverpod_rbac_client`
package. Relevant source files in this repository include:

- `serverpod_rbac_client/lib/src/protocol/client.dart`
- `serverpod_rbac_client/lib/src/protocol/protocol.dart`
- `serverpod_rbac_server/lib/src/endpoints/rbac_endpoint.dart`
- `TECHNICAL_GUIDE.md` at the package repository root
