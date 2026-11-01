# Serverpod RBAC: Beginner-Friendly Technical Guide

This guide explains how the `serverpod_rbac` workspace works, in the order a
request normally travels through it. It is intended for developers who are new
to this codebase and want to understand which file to use, what each function
does, and how the pieces fit together.

> **Scope:** This describes the current implementation in this repository.
> `serverpod_rbac_server` checks permissions and returns stored domain
> expressions. It does not parse those expressions or run your application
> queries. Install a query-filtering package such as
> `serverpod_filters_server` separately in your Serverpod application if you
> want to compile supported expressions into ORM conditions.

## 1. Start with the mental model

There are four important records:

1. A **permission** names an action, such as `invoice.create`.
2. A **role** groups permissions, such as `invoice_creator`.
3. A **user-role assignment** gives a user a role.
4. A **domain rule** optionally limits a role's access to rows for a resource,
   such as invoices where `city = Karachi`.

The normal relationship is:

```text
User -> assigned roles -> role permissions -> permission
                         -> role domain rules -> filter expression
```

In this implementation, a permission key is represented by two pieces:

```text
resource.codename
invoice.create
```

The resource identifies the model or data type being protected. The codename
identifies the action. Domain rules can be resource-wide or scoped to one
permission.

## 2. Workspace map

| Location | Purpose |
|---|---|
| `serverpod_rbac_server/lib/src/models/*.spy.yaml` | Source definitions for database and protocol models. These are hand-edited. |
| `serverpod_rbac_server/lib/src/rbac_service.dart` | Main RBAC implementation: permissions, roles, assignments, and checks. |
| `serverpod_rbac_server/lib/src/abac_service.dart` | Stores, retrieves, and evaluates role domain rules. |
| `serverpod_rbac_server/lib/src/rbac_cache.dart` | Caches permission/role summaries using request memory and Serverpod's global cache. |
| `serverpod_rbac_server/lib/src/session_rbac_extension.dart` | Convenient `session.rbac` and `session.rbac.abac` APIs. |
| `serverpod_rbac_server/lib/src/endpoints/rbac_endpoint.dart` | Authenticated RPC methods for users to inspect their own authorization. |
| `serverpod_rbac_server/lib/src/endpoints/rbac_admin_endpoint.dart` | RPC methods for administrators to manage authorization data. |
| `serverpod_rbac_server/lib/src/generated/` | Serverpod-generated server models, table descriptors, and endpoint dispatch. Do not edit by hand. |
| `serverpod_rbac_client/lib/src/protocol/` | Generated client protocol and typed RPC client. Do not edit by hand. |
| `serverpod_rbac_server/migrations/` | Database schema history generated from table model changes. |
| `serverpod_rbac_server/test/integration/` | Integration tests for service and endpoint behavior. |

The server package exports its main APIs from
`serverpod_rbac_server/lib/serverpod_rbac_server.dart`. The client package
exports generated protocol/client APIs from
`serverpod_rbac_client/lib/serverpod_rbac_client.dart`.

## 3. Data models: what is stored

Model source lives under `serverpod_rbac_server/lib/src/models/`. A
`.spy.yaml` file describes the model; Serverpod generates the Dart classes,
serialization, ORM table definitions, and client protocol types.

### `RbacPermission`

Defined in `models/rbac_permission.spy.yaml`.

- `resource`: normalized model/resource name, for example `invoice`.
- `codename`: normalized action, for example `create`.
- `name`: display label.
- `description`: optional explanation.
- `roles`: reverse relation to role-permission links.
- `createdAt`: creation timestamp.

The `(resource, codename)` pair has a unique index, so the same permission key
cannot be registered twice.

### `RbacRole`

Defined in `models/rbac_role.spy.yaml`.

- `name`: unique, normalized role name.
- `description`: optional role details.
- `isSuperuser`: if true, assignment of this role grants superuser bypass.
- `isSystemRole`: protects the role from the single-role delete method.
- `permissions`: linked permissions.
- `userRoles`: users assigned to the role.
- `domainRules`: rules attached to the role.
- `createdAt`: creation timestamp.

### `RbacRolePermission`

Defined in `models/rbac_role_permission.spy.yaml`. This is the join table
between a role and a permission. A unique index on `(roleId, permissionId)`
prevents duplicate assignments.

### `RbacUserRole`

Defined in `models/rbac_user_role.spy.yaml`. This joins a Serverpod
`userIdentifier` to a role. A unique index on `(userIdentifier, roleId)`
prevents duplicate role assignment for a user.

### `RbacDomainRule`

Defined in `models/rbac_domain_rule.spy.yaml`.

- `role`: role that owns the rule.
- `resource`: model/resource the expression filters, normalized to lowercase.
- `permission`: optional permission key such as `invoice.create`. `null` means
  the legacy/resource-wide rule can apply to any permission on that resource.
- `filterExpression`: JSON string returned to the application unchanged except
  trimming leading/trailing whitespace.
- `description`: optional human-readable explanation.
- `createdAt`: creation timestamp.

Domain rules are indexed by role/resource/permission and resource.

### Result and exception models

- `RbacUserPermissionsInfo` is a summary containing a user identifier,
  superuser flag, role names, and permission keys.
- `RbacAbacResult` describes one domain-access evaluation. Its main fields are
  `isAllowed`, `hasDomains`, `filterExpressions`, and `isUnrestricted`, plus
  user/permission/role/resource context.
- `RbacException` is the serializable exception used by authorization helpers.
  `RbacExceptionReason` distinguishes permission denial, role denial,
  authentication failure, missing role, and related cases.

The generated versions of these models are protocol/ORM code, not the source
of truth. Edit the `.spy.yaml` files, then regenerate.

## 4. Permission keys and normalization

These helper functions are in `RbacService`:

### `parsePermission(permission, defaultResource: 'global')`

Trims and lowercases the input, then splits at the first dot.

```text
invoice.create -> ('invoice', 'create')
create         -> ('global', 'create')
```

The no-dot form is accepted by this parser for normal RBAC checks. Domain-rule
permission input is stricter: it must include a resource and a codename.

### `formatPermissionKey(resource, codename)`

Trims and lowercases both parts and returns `resource.codename`.

### `matchesPermission(...)`

Compares a requested permission with a permission assigned to a role. It
supports these permission definitions:

- `invoice.create`: exact match.
- `invoice.*`: every action on invoice.
- `*.create`: create action on every resource.
- `*.*`: every permission.

The permission grants are additive: a user receives a permission if any
assigned role (or superuser status) grants it.

## 5. Main request flow

For a protected server operation, the safe sequence is:

1. Serverpod authenticates the request and creates a `Session`.
2. The endpoint calls `session.rbac.requirePermission(...)` or obtains a
   complete domain result from `session.rbac.abac.getDomainAccess(...)`.
3. `RbacService` resolves the user's assignments and checks matching role
   permissions. Superusers bypass ordinary permission checks.
4. For domain access, `AbacService` loads rules matching the resource and
   permission.
5. The endpoint denies the request, queries without a row filter for
   unrestricted access, or applies the returned expressions for restricted
   access.
6. If filtering expressions, the application compiles them to database
   conditions using its own filtering library and an explicit field allowlist.

RBAC answers **whether an action is granted**. ABAC supplies **which rows are
within that grant**. The returned expressions do not secure a query unless the
application actually applies them.

## 6. `RbacService`: function-by-function

File: `serverpod_rbac_server/lib/src/rbac_service.dart`.

`RbacService.instance` is the singleton used by the package. Its `cache`
property is the `RbacCache` instance. `customSuperuserResolver` is an optional
callback for application-specific superuser rules.

### User identity and superuser checks

| Function | What it does |
|---|---|
| `requireUserIdentifier(session, explicitIdentifier)` | Gets an explicit ID or the authenticated session ID. Throws `RbacException(notAuthenticated)` if missing or empty. |
| `getUserIdentifier(session, explicitIdentifier)` | Same resolution, but returns `null` instead of throwing when no ID is available. |
| `isSuperuser(session, userIdentifier:)` | Checks Serverpod `Scope.admin` for the currently authenticated matching user, then the optional custom resolver, then assigned roles with `isSuperuser == true`. |
| `getUserRoleAssignments(session, userIdentifier)` | Loads assignment rows and eagerly includes each role, its role-permission rows, and permission definitions. Used by checks and summaries. |

The explicit identifier parameter is useful for trusted server-side
administrative operations. Do not let an untrusted client choose another
user's identifier for an authorization decision.

### Permission and role inspection

| Function | What it does |
|---|---|
| `getUserPermissionsInfo(session, userIdentifier, forceRefresh:)` | Gets a cached summary unless forced to refresh; otherwise loads assignments, builds distinct role and permission lists, checks superuser status, then caches the summary. |
| `hasPermission(session, permission, userIdentifier:)` | Returns false if unauthenticated, true for superusers, otherwise checks all assigned roles using exact/wildcard permission matching. |
| `hasAllPermissions(session, permissions, userIdentifier:)` | Returns true only if every requested permission passes `hasPermission`. |
| `hasAnyPermission(session, permissions, userIdentifier:)` | Returns true as soon as one requested permission passes. |
| `hasRole(session, roleName, userIdentifier:)` | Checks assigned role names case-insensitively. A superuser is treated as having any role for this helper. |
| `hasAnyRole(session, roleNames, userIdentifier:)` | Returns true if any requested role passes `hasRole`. |
| `hasAllRoles(session, roleNames, userIdentifier:)` | Returns true only if all requested roles pass `hasRole`. |

For an authenticated user, the list checks use the usual logic:
`hasAll...` is AND; `hasAny...` is OR. An empty list therefore returns true
for `hasAll...` and false for `hasAny...`. For an unauthenticated user both
helpers return false.

### Enforcing a check with exceptions

| Function | What it does |
|---|---|
| `requirePermission(...)` | Requires authentication, then throws `RbacException(permissionDenied)` if the permission check fails. |
| `requireAllPermissions(...)` | Requires every listed permission or throws `permissionDenied`. |
| `requireAnyPermission(...)` | Requires at least one listed permission or throws `permissionDenied`. |
| `requireRole(...)` | Requires a role or throws `roleDenied`. |
| `requireAllRoles(...)` | Requires every listed role or throws `roleDenied`. |
| `requireAnyRole(...)` | Requires at least one listed role or throws `roleDenied`. |
| `requireSuperuser(...)` | Requires superuser status or throws `permissionDenied`. |

These helpers are convenient for endpoint entry checks. They do not apply ABAC
row filters; use `getDomainAccess` when the query needs row-level constraints.

### Permission management

| Function | What it does |
|---|---|
| `createPermission(...)` | Normalizes resource and codename, returns an existing matching permission if found, otherwise inserts one and invalidates authorization caches. |
| `createPermissions(...)` | Bulk-normalizes permission keys, inserts while ignoring conflicts, invalidates caches, and returns inserted rows. Empty input returns an empty list. |
| `listPermissions(resource:)` | Lists registered permissions, optionally for one normalized resource. |
| `deletePermission(permissionId)` | Finds and deletes one permission if present, then invalidates caches. |
| `deletePermissions(permissionIds)` | Bulk-finds/deletes matching permissions and invalidates caches if any existed. |

Register permissions before linking them to roles. `assignPermissionsToRole`
skips permission strings that do not resolve to a registered permission.

### Role management

| Function | What it does |
|---|---|
| `createRole(...)` | Normalizes the name, returns an existing role with that name if present, otherwise inserts it with the requested superuser/system-role flags and invalidates caches. |
| `createRoles(roles)` | Bulk-normalizes names, inserts while ignoring conflicts, and invalidates caches. |
| `getRole(name)` | Finds one role case-insensitively and includes its permissions. |
| `listRoles()` | Lists roles alphabetically and includes their permissions. |
| `deleteRole(name)` | Deletes a found role, but throws `roleDenied` if it is marked `isSystemRole`. Related records use the model relations' cascade behavior. |
| `deleteRoles(names)` | Bulk deletes matching non-system roles; system roles are skipped. |

### Role-permission assignments

| Function | What it does |
|---|---|
| `assignPermissionsToRole(roleName, permissions)` | Resolves the role and each registered permission, inserts join rows while ignoring duplicates, then invalidates caches. Missing role throws `roleNotFound`; unknown permissions are skipped. |
| `removePermissionsFromRole(roleName, permissions)` | Removes matching join rows for a role, then invalidates caches. Missing role/permission is treated as no-op. |
| `getRolePermissions(roleName)` | Returns permission models linked to the role; returns an empty list if the role is missing. |

### User-role assignments

| Function | What it does |
|---|---|
| `assignRoleToUser(userIdentifier, roleName)` | Resolves the role, returns an existing assignment if present, otherwise inserts it and invalidates that user's cached summary. Missing role throws `roleNotFound`. |
| `assignRolesToUser(userIdentifier, roleNames)` | Bulk assigns all matching named roles to one user, ignores duplicate rows, and invalidates that user's cache. Empty input is a no-op. |
| `assignRoleToUsers(userIdentifiers, roleName)` | Assigns one role to many distinct user IDs, ignores duplicate rows, and invalidates each user's cache. Missing role throws `roleNotFound`. |
| `removeRoleFromUser(userIdentifier, roleName)` | Deletes matching assignment rows and invalidates that user's cache. Missing role/assignment is a no-op. |
| `removeRolesFromUser(userIdentifier, roleNames)` | Bulk-removes matching role assignments and invalidates that user's cache if something was removed. |
| `getUserRoles(userIdentifier)` | Returns distinct role models assigned to the user. |
| `listUserRoles(userIdentifier:, roleName:)` | Lists assignment rows using either optional filter, includes each role, and orders by assignment time. |

## 7. `AbacService`: function-by-function

File: `serverpod_rbac_server/lib/src/abac_service.dart`.
`AbacService.instance` is the singleton. This service owns domain-rule CRUD
and evaluation. It does **not** import or call `serverpod_filters_server`.

### Managing rules

| Function | What it does |
|---|---|
| `addDomainRule(...)` | Normalizes role/resource and optional permission, trims the expression, looks up the role, inserts one rule, invalidates authorization caches, and returns the inserted row. Empty resource/expression or malformed permission throws `ArgumentError`; missing role throws `roleNotFound`. |
| `addDomainRules(rules)` | Applies the same resource/permission/expression normalization to bulk model instances, inserts them, and invalidates caches. Empty input returns an empty list. It accepts role IDs directly, so callers must supply valid IDs. |
| `removeDomainRule(ruleId)` | Deletes one rule if it exists and invalidates caches. Missing ID is a no-op. |
| `clearDomainRules(roleName, resource:, permission:)` | Deletes rules for a role. Optional resource and permission narrow the deletion; if both are omitted, all that role's rules are cleared. If only permission is supplied, matching permission rules are cleared across resources. |
| `listDomainRules(roleName, resource:, permission:)` | Lists rules for a role, optionally filtered by resource and/or exact normalized permission. |

The service only rejects empty expressions. It does not parse the JSON, verify
field names against an application model, or guarantee that an expression is
accepted by a filtering package. Validate and test configured expressions in
the application that applies them.

### Evaluating permission access

`getDomainAccess(permission, resource:, userIdentifier:)` is the main ABAC
method:

1. It parses the permission and determines the effective resource. If no
   resource is supplied, the permission's resource is used.
2. If there is no user ID, it returns denied.
3. If the user is a superuser, it returns allowed and unrestricted.
4. It loads the user's role assignments and finds roles that grant the
   requested permission, including permission wildcards.
5. It loads rules for those roles and the resource. When a permission is
   supplied for lookup, it includes:
   - a rule with no permission (legacy resource-wide rule);
   - an exact permission rule;
   - a matching `resource.*`, `*.codename`, or `*.*` rule.
6. If a role grants the permission but has no matching rule for this resource
   and permission, that role makes access unrestricted.
7. Otherwise it returns the distinct matching expression strings.

Returned `RbacAbacResult` values mean:

| Fields | Meaning |
|---|---|
| `isAllowed == false` | No matching permission or no authenticated user. Do not query protected data. |
| `isAllowed == true`, `isUnrestricted == true` | Superuser or at least one matching permission-granting role has no applicable filter rule. Query without a policy filter. |
| `isAllowed == true`, `hasDomains == true` | Access is restricted. Apply the returned expressions to the query. |
| `filterExpressions` | Distinct stored JSON strings; this service does not combine them into a query expression. |

`hasDomains(...)` calls `getDomainAccess(...)` and returns only its
`hasDomains` flag. For a security decision, prefer the full result because a
false `hasDomains` alone does not distinguish denial from unrestricted access.

`getDomainFilters(...)` calls `getDomainAccess(...)` and returns only the
expression list. An empty list can mean denied **or** unrestricted, so check
access separately or use `getDomainAccess(...)`.

### Role-specific and discovery methods

| Function | What it does |
|---|---|
| `getRoleDomainAccess(roleName, resource:, permission:, userIdentifier:)` | Checks that the user has that role, then returns its matching rules. It does not require the role to grant a particular permission. Omitting resource/permission includes rules across that dimension; treat such output as inspection-only. A user superuser or any assigned superuser role returns unrestricted access. |
| `getAllDomainFilters(resource:, permission:, userIdentifier:)` | Returns distinct expressions found across the user's assigned roles. It does not check whether those roles grant the requested permission and does not return the `isAllowed`/`isUnrestricted` distinction. Use for inspection, not as a substitute for `getDomainAccess` in a protected query. |

### Internal `AbacService` helpers

| Helper | What it does |
|---|---|
| `_loadDomainRulesForRoles(roleIds, resource:, permission:)` | Performs one ORM query for a set of role IDs, optionally filtering by resource and by permission patterns plus legacy null-permission rules. |
| `_normalizeResource(resource)` | Trims/lowercases the resource and rejects an empty value. |
| `_normalizeFilterExpression(expression)` | Trims expression whitespace and rejects an empty value. It does not JSON-parse it. |
| `_normalizePermission(permission)` | Requires a dot-separated resource/action, then returns its lowercase canonical key. |
| `_permissionPatterns(permission)` | Produces the exact, resource-wildcard, action-wildcard, and global-wildcard keys used to load applicable rules. |

### How multiple role rules combine

The service returns distinct strings; **your application combines them**.
The current policy is a union of grants:

- Rules for matching roles that grant the same permission are OR alternatives.
- One expression may itself contain multiple criteria; the filter parser's
  implicit sequential behavior combines those criteria with AND.
- A matching role that grants the permission but has no applicable rule makes
  the overall result unrestricted.
- Rules belonging to roles that do not grant the requested permission are
  ignored by `getDomainAccess`.

For example:

```text
Role A: invoice.create + city = Karachi
Role B: invoice.create + city = Lahore
```

The expression list represents Karachi **OR** Lahore. If Role B grants
`invoice.create` but has no applicable rule, Role B grants access to all
invoices, and the overall result is unrestricted. Adding another role can
therefore expand access. This is not an intersection/deny-overrides policy.

## 8. `RbacCache`: how authorization decisions are cached

File: `serverpod_rbac_server/lib/src/rbac_cache.dart`.

The cache stores both `RbacUserPermissionsInfo` snapshots and
permission/resource-scoped `RbacAbacResult` decisions. Domain decisions have a
one-minute lifetime; permission summaries have a five-minute lifetime.

| Member | What it does |
|---|---|
| `defaultLifetime` | Sets the permission-summary global-cache lifetime to five minutes. |
| `domainAccessLifetime` | Sets the domain-decision cache lifetime to one minute. |
| `prefix` | Names this package's cache keys. |
| `_sessionCaches` | An `Expando` providing per-`Session` memory for repeated lookups during one request. |
| `_getSessionCache(session)` | Gets or creates the request-local map. |
| `_readGeneration(session)` | Reads the global generation marker, reusing the request value when available. Cache read errors are treated as a cache miss. |
| `_readUserGeneration(session, userIdentifier)` | Reads a per-user generation for invalidating domain decisions after that user's role assignments change. |
| `_buildUserKey(session, userIdentifier)` | URL-safe-base64 encodes the user ID and includes the current generation in the cache key. |
| `_buildDomainAccessKey(...)` | Keys a domain decision by global generation, user generation, user, resource, and permission. |
| `getUserPermissionsInfo(...)` | Checks request memory, then the Serverpod global cache. Read failures fall back to a cache miss so the caller can load from the database. |
| `putUserPermissionsInfo(...)` | Stores the snapshot locally and in global cache. Write failures do not prevent the authorization result from being returned. |
| `getDomainAccess(...)` | Checks request memory and then the Serverpod global cache for a resolved decision. |
| `putDomainAccess(...)` | Stores a resolved decision locally and globally for the short domain-decision lifetime. |
| `invalidateUser(...)` | Removes the user's local/global summary key and advances that user's generation so their old domain decisions are not reused. |
| `invalidateAll(...)` | Clears this request's local cache and changes the global generation marker so old permission-summary and domain-decision keys are no longer selected. |

`RbacService` calls cache invalidation from its management methods;
`AbacService` does so when rules are added or removed. If an application writes
directly to these tables instead of using the service, it must handle cache
invalidation itself. Global caching requires a working Serverpod global cache
(normally Redis); if global cache operations fail, authorization is resolved
from the database and only same-session memoization remains. Domain decisions
are cached only after checking the current request's native admin scope and
custom superuser resolver.

## 9. `session.rbac`: endpoint-friendly helpers

File: `serverpod_rbac_server/lib/src/session_rbac_extension.dart`.

### `RbacSessionExtension`

Adds the getter `session.rbac`, which creates a `SessionRbacContext` wrapping
that session.

### `SessionRbacContext`

This is the convenient current-user facade. Its `userIdentifier`,
`isAuthenticated`, and `abac` getters expose session identity and ABAC helpers.
Its methods delegate to `RbacService` or `AbacService`:

- Identity and information: `userIdentifier`, `isAuthenticated`,
  `getAllPermissions`, `getRoles`, `getPermissionsInfo`.
- Checks: `isSuperuser`, `hasPermission`, `hasAllPermissions`,
  `hasAnyPermission`, `hasRole`, `hasAnyRole`, `hasAllRoles`.
- Enforcers: `requirePermission`, `requireAllPermissions`,
  `requireAnyPermission`, `requireRole`, `requireAllRoles`,
  `requireAnyRole`, `requireSuperuser`.
- ABAC shortcut methods: `hasDomains`, `getDomainFilters`, and
  `getDomainAccess`.

Unauthenticated information getters return safe empty/null summaries; use
`require...` or inspect `isAllowed` when authorization is required.

### `SessionAbacContext`

Available through `session.rbac.abac`. It delegates:

- `hasDomains(permission, resource:)`
- `getDomainFilters(permission, resource:)`
- `getDomainAccess(permission, resource:)`
- `getRoleDomainAccess(roleName, resource:, permission:)`
- `getAllDomainFilters(resource:, permission:)`

This context uses the current authenticated user. Service-level methods also
accept an explicit user identifier for trusted server-side inspection.

## 10. RPC endpoints: what clients may call

Serverpod endpoints are remote procedure calls. Both endpoints require login.
The endpoint layer is a thin wrapper around services; it performs no direct
database authorization beyond its stated access checks.

### `RbacEndpoint`: self-service methods

File: `serverpod_rbac_server/lib/src/endpoints/rbac_endpoint.dart`.

| Method | Purpose |
|---|---|
| `isSuperuser()` | Reports current user's superuser state. |
| `getMyPermissions()` | Returns current user's summary; throws not-authenticated if no summary can be resolved. |
| `getMyRoles()` | Returns current user's role names. |
| `hasDomains(permission, resource:)` | Reports whether row filters apply. |
| `getMyDomainFilters(permission, resource:)` | Returns expressions for current user and permission. |
| `getMyDomainAccess(permission, resource:)` | Returns the complete ABAC result. Prefer this when querying protected data. |
| `getMyAllDomainFilters(resource:)` | Returns expression strings across current user's roles; intended for inspection. |
| `hasPermission`, `hasAllPermissions`, `hasAnyPermission` | Boolean permission checks. |
| `hasRole`, `hasAnyRole`, `hasAllRoles` | Boolean role checks. |
| `requirePermission`, `requireAllPermissions`, `requireAnyPermission` | Throw when permission requirements fail. |
| `requireRole`, `requireAllRoles`, `requireAnyRole` | Throw when role requirements fail. |
| `requireSuperuser()` | Throws unless current user is a superuser. |

The self-service all-domain-filters endpoint currently accepts a resource but
not a permission. For a permission-specific query, use `getMyDomainAccess`
instead.

### `RbacAdminEndpoint`: administrative methods

File: `serverpod_rbac_server/lib/src/endpoints/rbac_admin_endpoint.dart`.

Every method first calls `_checkAdminAccess(session)`. Access is allowed to a
superuser or a user with `rbac.manage`; otherwise it throws
`RbacException(permissionDenied)`. Because the endpoint also requires login,
anonymous RPC calls are rejected before its methods run.

The public methods are grouped as follows:

- **Permissions:** `createPermission`, `createPermissions`,
  `listPermissions`, `deletePermission`, `deletePermissions`.
- **Roles:** `createRole`, `createRoles`, `listRoles`, `deleteRole`,
  `deleteRoles`.
- **Role permissions:** `assignPermissionsToRole`,
  `removePermissionsFromRole`, `getRolePermissions`.
- **User roles:** `assignRoleToUser`, `assignRolesToUser`,
  `assignRoleToUsers`, `removeRoleFromUser`, `removeRolesFromUser`,
  `listUserRoles`, `getUserRoles`, `getUserPermissionsInfo`.
- **ABAC rules:** `addDomainRule`, `addDomainRules`, `removeDomainRule`,
  `clearDomainRules`, `listDomainRules`.
- **ABAC inspection:** `getUserDomainFilters`, `getUserDomainAccess`,
  `getAllUserDomainFilters`.

`addDomainRule` accepts an optional `permission` for a rule such as
`invoice.create`. `clearDomainRules` and `listDomainRules` can also filter by
resource and permission. The administrative all-domain-filters method accepts
resource but not permission; use `getUserDomainAccess` to evaluate one
permission.

Private helper `_checkAdminAccess` centralizes the admin authorization check.
Each endpoint operation then calls the relevant `RbacService` or
`AbacService` method.

## 11. Safely applying returned filters

The package intentionally returns strings instead of importing a query
compiler. A server application may install `serverpod_filters_server`
separately. Check access first, and never query protected rows if access is
denied.

```dart
final access = await session.rbac.abac.getDomainAccess(
  'invoice.read',
  resource: 'invoice',
);

if (!access.isAllowed) {
  throw RbacException(
    message: 'Permission denied: invoice.read is required',
    reason: RbacExceptionReason.permissionDenied,
    requiredPermission: 'invoice.read',
    userIdentifier: session.authenticated?.userIdentifier,
  );
}

if (access.isUnrestricted) {
  return Invoice.db.find(session);
}

const allowedFields = {'city', 'status', 'ownerId'};
return Invoice.db.find(
  session,
  where: (table) {
    final filters = access.filterExpressions.map(
      (expression) => ServerpodFilters.toWhere(
        expression,
        table,
        allowedFields: allowedFields,
        strict: true,
      ),
    );
    return filters.reduce((left, right) => left | right);
  },
);
```

Here, `map` converts every stored string to a query condition. `reduce`
combines the conditions into one expression using OR (`|`). If the result is
restricted, `filterExpressions` should be non-empty; if there is only one
expression, it is the entire condition. The example uses strict field
allowlisting so a bad rule fails instead of silently broadening access.

Important safeguards:

1. Perform authorization on the **server**, not only in a Flutter client.
2. Use the complete `RbacAbacResult`; an empty expression list by itself cannot
   distinguish denied from unrestricted access.
3. Pass the correct model resource and permission every time.
4. Treat stored expressions as trusted administrator configuration, but still
   validate them against your filtering library and field allowlist.
5. If client filters are supported too, AND the validated client filter with
   the authorization predicate. Never let a client replace the authorization
   predicate.
6. A list-query filter does not automatically protect writes. For update/delete,
   select the target row under the authorization predicate before changing it.
   For create, validate the new record's fields with server-side policy.

The filter package supports its own documented list/prefix syntax; it is not
automatically a complete implementation of every Odoo feature or dynamic
variable. See the `serverpod_filters_server` documentation for the exact
supported operators and grammar.

## 12. Generated code, migrations, and testing

### When changing models or endpoints

1. Edit `.spy.yaml` model sources or endpoint source files under `lib/src/`.
2. Run `serverpod generate` from the server package to update generated server
   and client protocol code.
3. When a table model/index changes, create a migration and apply it in the
   target environment before deploying.
4. Do not hand-edit `lib/src/generated/` or generated client protocol files.

For example, `RbacDomainRule.permission` is nullable so older resource-wide
rules remain valid. Its schema migration adds a nullable database column,
preserving existing rows.

### Tests in this workspace

- `test/integration/rbac_test.dart` exercises service-level behavior such as
  permission matching, role assignments, superusers, and domain rules.
- `test/integration/rbac_endpoints_test.dart` exercises self-service and admin
  RPC behavior, including admin access checks.
- `test/integration/test_tools/serverpod_test_tools.dart` is generated test
  support; do not hand-edit it.

Run focused tests from the server package:

```powershell
dart test test\integration\rbac_test.dart test\integration\rbac_endpoints_test.dart
dart analyze
```

## 13. Quick navigation by task

| I want to... | Start here |
|---|---|
| Check a permission in a server endpoint | `session.rbac.requirePermission(...)` |
| Check a user's permission without throwing | `session.rbac.hasPermission(...)` |
| Restrict invoice rows by permission | `AbacService.addDomainRule(...)`, then `session.rbac.abac.getDomainAccess(...)` |
| Manage roles and permissions through RPC | `RbacAdminEndpoint` |
| Let a user inspect their own access | `RbacEndpoint` |
| Change database/protocol models | `.spy.yaml` files, then Serverpod generation and migration |
| Understand cache behavior | `rbac_cache.dart` |
| Understand permission wildcard matching | `RbacService.parsePermission` and `matchesPermission` |
| Understand why all matching role rules are returned | `AbacService.getDomainAccess` and “How multiple role rules combine” above |

For a short getting-started overview, see `README.md`. For the broader developer
guide and examples, see `DOCS.md`.
