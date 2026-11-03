---
name: serverpod-rbac-server
description: "Use when adding server-side authorization with serverpod_rbac: protect Serverpod endpoints, check roles and permissions, manage authorization data, resolve ABAC domain access, or integrate the RbacService and Session.rbac APIs."
---

# Serverpod RBAC: Server-Side Use

Use the `serverpod_rbac_server` package from Serverpod server code. This skill
covers the full server-side public API: `RbacService`, `AbacService`,
`RbacCache`, `SessionRbacContext`, and `SessionAbacContext`.

For Flutter client calls, load `serverpod-rbac-flutter`. For authorization
administration through RPC, load `serverpod-rbac-admin`.
Keep this skill versioned with the package so consuming projects can use it.

## Setup

Add the server package to the Serverpod server package:

```yaml
dependencies:
  serverpod_rbac_server: ^1.0.0
```

Register the module in the server's `config/generator.yaml` and generate
protocol/endpoint code:

```yaml
modules:
  serverpod_rbac:
    nickname: rbac
```

Run `serverpod generate` and apply the generated database migrations as part of
the host project's migration workflow. Import the public server library:

```dart
import 'package:serverpod_rbac_server/serverpod_rbac_server.dart';
```

## Model and Permission Conventions

- The authorization model is **permissions -> roles -> users**. Assign
  permissions to roles and roles to Serverpod `userIdentifier` values.
- Permission keys are canonical `resource.codename` strings, for example
  `invoice.read`. Matching and stored keys are trimmed and lowercased.
- `RbacService.parsePermission` splits on the first dot; a key without a dot
  uses `defaultResource`, which defaults to `global`.
- `RbacService.formatPermissionKey` returns a normalized `resource.codename`.
- `RbacService.matchesPermission` supports exact matches, `resource.*`,
  `*.codename`, and `*.*`.
- Create concrete permission definitions before assigning them to a role.
  `assignPermissionsToRole` skips unknown permission keys.
- Role names, resources, and permission keys are normalized case-insensitively
  by service methods.

The generated protocol includes `RbacPermission`, `RbacRole`,
`RbacRolePermission`, `RbacUserRole`, `RbacDomainRule`,
`RbacUserPermissionsInfo`, `RbacAbacResult`, `RbacException`, and
`RbacExceptionReason`.

## Protecting an Endpoint

Set `requireLogin` and authorize on the server for every protected operation.
Do not rely on Flutter UI checks as security enforcement.
If the application compiles domain expressions into ORM conditions, install
`serverpod_filters_server` separately; it is not a dependency of this package.

```dart
import 'package:serverpod_filters_server/serverpod_filters_server.dart';

class InvoiceEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<List<Invoice>> list(Session session) async {
    final access = await session.rbac.abac.getDomainAccess(
      'invoice.read',
      resource: 'invoice',
    );
    if (!access.isAllowed) {
      throw RbacException(
        message: 'Permission denied: required "invoice.read"',
        reason: RbacExceptionReason.permissionDenied,
        requiredPermission: 'invoice.read',
        userIdentifier: session.authenticated?.userIdentifier,
      );
    }

    if (access.isUnrestricted) return Invoice.db.find(session);
    return Invoice.db.find(
      session,
      where: (table) => access.filterExpressions
          .map(
            (expression) => ServerpodFilters.toWhere(
              expression,
              table,
              allowedFields: {'ownerId'},
              strict: true,
            ),
          )
          .reduce((left, right) => left | right),
    );
  }
}
```

Use `await session.rbac.requirePermission('invoice.update')` for ordinary
permission checks that do not need row scoping. It throws `RbacException` when
authentication or authorization fails. `require*` checks do not apply ABAC
filters.

## Identity, Checks, and Enforcement API

`RbacService.instance` is the singleton; it has the public `cache` property and
the optional mutable `customSuperuserResolver` callback
(`Future<bool> Function(Session, String)`). Superuser evaluation checks, in
order: native `Scope.admin` for the matching authenticated user, the custom
resolver, then an assigned role whose `isSuperuser` is true.

The following complete `RbacService` identity and decision API takes a
`Session`; checks that accept `userIdentifier:` can also resolve a trusted
server-supplied user's permissions:

| Method | Behavior |
|---|---|
| `getUserIdentifier(session, [explicitIdentifier])` | Returns the explicit identifier or current authenticated identifier; can return null. |
| `requireUserIdentifier(session, [explicitIdentifier])` | Same resolution, but throws `RbacException(notAuthenticated)` when missing or empty. |
| `isSuperuser(session, userIdentifier:)` | Checks native admin scope, custom resolver, and superuser role. |
| `getUserRoleAssignments(session, userIdentifier)` | Gets assignment rows with roles, role-permission rows, and permissions eagerly included. |
| `getUserPermissionsInfo(session, userIdentifier, forceRefresh:)` | Resolves/caches the user's roles, permissions, and superuser snapshot; `forceRefresh` bypasses cached read. |
| `hasPermission(session, permission, userIdentifier:)` | Returns whether one permission is granted; unauthenticated returns false. |
| `hasAllPermissions(session, permissions, userIdentifier:)` | Requires every permission (AND); unauthenticated returns false. |
| `hasAnyPermission(session, permissions, userIdentifier:)` | Requires at least one permission (OR); unauthenticated returns false. |
| `hasRole(session, roleName, userIdentifier:)` | Checks a role name; a superuser passes any role check. |
| `hasAllRoles(session, roleNames, userIdentifier:)` | Requires every role (AND); unauthenticated returns false. |
| `hasAnyRole(session, roleNames, userIdentifier:)` | Requires at least one role (OR); unauthenticated returns false. |
| `requirePermission(session, permission, userIdentifier:)` | Requires sign-in and permission; throws `permissionDenied` on denial. |
| `requireAllPermissions(session, permissions, userIdentifier:)` | Requires all listed permissions; throws `permissionDenied`. |
| `requireAnyPermission(session, permissions, userIdentifier:)` | Requires any listed permission; throws `permissionDenied`. |
| `requireRole(session, roleName, userIdentifier:)` | Requires one role; throws `roleDenied`. |
| `requireAllRoles(session, roleNames, userIdentifier:)` | Requires all listed roles; throws `roleDenied`. |
| `requireAnyRole(session, roleNames, userIdentifier:)` | Requires any listed role; throws `roleDenied`. |
| `requireSuperuser(session, userIdentifier:)` | Requires superuser status; throws `permissionDenied`. |

For authenticated users, `hasAll*([])` is true and `hasAny*([])` is false. An
explicit user identifier is for trusted server-side code only: never let a
caller choose another user's ID and then treat the result as their own
authorization.

## Permission and Role Management API

All methods below are on `RbacService.instance`. The caller is responsible for
admin authorization when using these service methods directly.

| Method | Behavior |
|---|---|
| `createPermission(session, resource:, codename:, name:, description:)` | Normalizes key fields; returns an existing resource/codename match or inserts and invalidates caches. |
| `createPermissions(session, permissions)` | Bulk-normalizes and inserts ignoring conflicts; empty input returns an empty list. |
| `listPermissions(session, resource:)` | Lists all permissions or filters by normalized resource. |
| `deletePermission(session, permissionId)` | Deletes a matching ID if present. |
| `deletePermissions(session, permissionIds)` | Bulk-deletes matching IDs; empty input is a no-op. |
| `createRole(session, name:, description:, isSuperuser:, isSystemRole:)` | Normalizes the name; returns an existing match or creates the role with the requested flags. |
| `createRoles(session, roles)` | Bulk-normalizes names and inserts ignoring conflicts; empty input returns an empty list. |
| `getRole(session, name)` | Finds a role by normalized name and includes its permissions. |
| `listRoles(session)` | Lists roles with permission relations included. |
| `deleteRole(session, name)` | Deletes a role; throws `roleDenied` for a system role. |
| `deleteRoles(session, names)` | Bulk-deletes matching non-system roles; system roles are skipped. |
| `assignPermissionsToRole(session, roleName:, permissions:)` | Links registered permissions, ignoring duplicate links and skipping unknown permissions; missing role throws `roleNotFound`. |
| `removePermissionsFromRole(session, roleName:, permissions:)` | Removes matching links; missing role or permission is a no-op. |
| `getRolePermissions(session, roleName)` | Returns linked permission models; missing role returns an empty list. |

## User-Role Assignment and Lookup API

| Method | Behavior |
|---|---|
| `assignRoleToUser(session, userIdentifier:, roleName:)` | Assigns one role, returning an existing assignment if already linked; missing role throws `roleNotFound`. |
| `assignRolesToUser(session, userIdentifier:, roleNames:)` | Bulk-assigns matching role names, ignores duplicate links, and no-ops for empty input. Unknown names are not inserted. |
| `assignRoleToUsers(session, userIdentifiers:, roleName:)` | Bulk-assigns one role to distinct user IDs; missing role throws `roleNotFound`; empty IDs are a no-op. |
| `removeRoleFromUser(session, userIdentifier:, roleName:)` | Removes one assignment; missing role or assignment is a no-op. |
| `removeRolesFromUser(session, userIdentifier:, roleNames:)` | Removes matching assignments in bulk; empty names are a no-op. |
| `getUserRoles(session, userIdentifier)` | Returns distinct role models assigned to the user. |
| `listUserRoles(session, userIdentifier:, roleName:)` | Lists assignment rows, optionally filtered by user and/or role; unknown role returns an empty list. |

Service mutations invalidate relevant caches. If application code changes RBAC
tables directly instead of using these methods, it must invalidate the cache
itself.

## ABAC Domain Rule and Access API

`AbacService.instance` methods accept a `Session`. The domain expressions are
stored as trimmed strings; the library does not parse, validate, or execute
them. Permission-scoped domain keys must be dot-separated `resource.codename`.

| Method | Behavior |
|---|---|
| `addDomainRule(session, roleName:, resource:, filterExpression:, permission:, description:)` | Adds one rule; permission is optional (null means resource-wide); missing role throws `roleNotFound`. Empty resource/expression throws `ArgumentError`. |
| `addDomainRules(session, rules)` | Bulk-adds normalized rules; empty list returns an empty list. |
| `removeDomainRule(session, ruleId)` | Removes a rule if it exists. |
| `clearDomainRules(session, roleName:, resource:, permission:)` | Clears all rules for a role or narrows deletion by optional resource and permission. |
| `listDomainRules(session, roleName:, resource:, permission:)` | Lists role rules, optionally filtered by resource and permission; missing role returns empty list. |
| `getDomainAccess(session, permission:, resource:, userIdentifier:)` | Full authorization decision: permission check plus applicable filters. Defaults resource from the permission key. |
| `getRoleDomainAccess(session, roleName:, resource:, permission:, userIdentifier:)` | Inspects a role's domain access for a user; this is not itself a check that the role grants the permission. |
| `hasDomains(session, permission:, resource:, userIdentifier:)` | Reports whether matching access is restricted; use `getDomainAccess` when deciding if access is allowed. |
| `getDomainFilters(session, permission:, resource:, userIdentifier:)` | Returns only expressions; empty can mean denied or unrestricted, so prefer the full result for authorization. |
| `getAllDomainFilters(session, resource:, permission:, userIdentifier:)` | Returns distinct expressions found across assigned roles; it does not verify each role grants the permission. Use for inspection, not authorization. |

Interpret `RbacAbacResult` using all of `isAllowed`, `isUnrestricted`,
`hasDomains`, and `filterExpressions`:

- `isAllowed == false`: deny the operation.
- `isAllowed == true && isUnrestricted == true`: query without a row filter.
- Restricted access: apply every returned expression as an OR alternative,
  using a filtering library separately installed by the application and an
  explicit allowlist of filterable fields.
- Criteria within an expression are interpreted by the filtering library, not
  by this package. The library treats stored expressions as opaque data.
- If any role grants the permission without a matching domain rule, access is
  unrestricted. Rules from roles that do not grant the requested permission
  are ignored in `getDomainAccess`.
- A null-permission legacy rule applies resource-wide. Permission-specific
  rules support exact and wildcard permission keys.

Do not treat `hasDomains == false` or an empty filter list as an allow decision.
Use the complete `getDomainAccess` result before protected queries.

## Session Convenience API

Importing the public library adds `session.rbac` via `RbacSessionExtension`.
Use it inside request-scoped endpoint methods; never retain the `Session`
outside the request.

`SessionRbacContext` exposes:

- Properties: `session`, `userIdentifier`, `isAuthenticated`, `abac`.
- Checks: `isSuperuser()`, `hasPermission(permission)`,
  `hasAllPermissions(permissions)`, `hasAnyPermission(permissions)`,
  `hasRole(roleName)`, `hasAllRoles(roleNames)`, `hasAnyRole(roleNames)`.
- Enforcement: `requirePermission(permission)`,
  `requireAllPermissions(permissions)`, `requireAnyPermission(permissions)`,
  `requireRole(roleName)`, `requireAllRoles(roleNames)`,
  `requireAnyRole(roleNames)`, `requireSuperuser()`.
- Domain shortcuts: `hasDomains(permission, resource:)`,
  `getDomainFilters(permission, resource:)`,
  `getDomainAccess(permission, resource:)`.
- Current-user inspection: `getAllPermissions()`, `getRoles()`,
  `getPermissionsInfo()`. These return empty/null values if unauthenticated.

`session.rbac.abac` returns `SessionAbacContext` with
`hasDomains(permission, resource:)`,
`getDomainFilters(permission, resource:)`,
`getDomainAccess(permission, resource:)`,
`getRoleDomainAccess(roleName, resource:, permission:)`, and
`getAllDomainFilters(resource:, permission:)`.

## Cache API

`RbacService.instance.cache` exposes `RbacCache`. Its public members are:

- Constants: `defaultLifetime` (five minutes),
  `domainAccessLifetime` (one minute), and `prefix`.
- `getUserPermissionsInfo(session, userIdentifier)` /
  `putUserPermissionsInfo(session, userIdentifier, info, lifetime:)`.
- `getDomainAccess(session, userIdentifier:, resource:, permission:)` /
  `putDomainAccess(session, userIdentifier:, resource:, permission:, result, lifetime:)`.
- `invalidateUser(session, userIdentifier)` and `invalidateAll(session)`.

The cache uses session-local memoization and Serverpod's global cache when
available. Cache failures fall back to resolving from the database. Keep cache
invalidation when changing authorization data.

## Exception Handling

`RbacException` contains `message`, `reason`, and optional
`requiredPermission`, `requiredRole`, `requiredDomain`, and `userIdentifier`.
Reasons include `permissionDenied`, `roleDenied`, `domainDenied`,
`userInactive`, `notAuthenticated`, `roleNotFound`, and `permissionNotFound`.
Handle expected authorization failures explicitly at the application
boundary; do not silently turn exceptions into successful access.

## Source of Truth

For signatures and implementation details, consult the server package:

- `serverpod_rbac_server/lib/src/rbac_service.dart`
- `serverpod_rbac_server/lib/src/abac_service.dart`
- `serverpod_rbac_server/lib/src/rbac_cache.dart`
- `serverpod_rbac_server/lib/src/session_rbac_extension.dart`
- `TECHNICAL_GUIDE.md` at the package repository root
