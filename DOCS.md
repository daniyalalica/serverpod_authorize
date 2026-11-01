# Serverpod RBAC Developer Guide

This guide describes the authorization model, public APIs, setup, operations,
and limitations of this Serverpod RBAC module. It is written against the code
in this repository; generated protocol files are not the source of truth.

## Contents

1. [What this package provides](#what-this-package-provides)
2. [Packages and project layout](#packages-and-project-layout)
3. [Authorization concepts and evaluation](#authorization-concepts-and-evaluation)
4. [Installation and Serverpod integration](#installation-and-serverpod-integration)
5. [Configuration](#configuration)
6. [Defining permissions and roles](#defining-permissions-and-roles)
7. [Seeding initial data](#seeding-initial-data)
8. [Enforcing authorization in server code](#enforcing-authorization-in-server-code)
9. [Client endpoints](#client-endpoints)
10. [Managing permissions, roles, and assignments](#managing-permissions-roles-and-assignments)
11. [Data model and database behavior](#data-model-and-database-behavior)
12. [Caching and invalidation](#caching-and-invalidation)
13. [Audit logging](#audit-logging)
14. [Errors and expected behavior](#errors-and-expected-behavior)
15. [Scope and security boundaries](#scope-and-security-boundaries)
16. [Migrations and upgrades](#migrations-and-upgrades)
17. [Testing and analysis](#testing-and-analysis)
18. [Production checklist](#production-checklist)
19. [Troubleshooting](#troubleshooting)

## What this package provides

This repository contains a reusable, Django-inspired role-based authorization
module for Serverpod 4.0.4. It provides:

- Global permissions named as `resource.codename`.
- Reusable roles with any number of permissions.
- User-to-role assignments.
- Direct per-user permission grants and explicit denials.
- Superuser checks, including Serverpod's `Scope.admin`.
- A `Session.rbac` helper for server-side authorization.
- Authenticated self-service and administrative Serverpod endpoints.
- Request-local and Serverpod process/shared permission snapshot caching.
- Optional database audit records.
- An idempotent, additive permission/role seeder.

The module supplies authorization primitives; it does not implement an
application's authentication, user lifecycle, tenant model, data filtering,
or deployment. The host application must call authorization checks at each
server-side trust boundary.

## Packages and project layout

The Dart workspace has two packages:

| Package | Role |
|---|---|
| `serverpod_rbac_server` | Runtime service, models, endpoints, cache, auditing, seeder, and `Session.rbac` |
| `serverpod_rbac_client` | Generated protocol models and client endpoint connectors |

The server package has the `serverpod_rbac` module nickname. Its model
definitions are in `serverpod_rbac_server/lib/src/models/*.spy.yaml`; endpoint
implementations are in `serverpod_rbac_server/lib/src/endpoints/`. The server
package's public barrel is
`serverpod_rbac_server/lib/serverpod_rbac_server.dart`. The client package's
public barrel is `serverpod_rbac_client/lib/serverpod_rbac_client.dart`.

Generated files under `lib/src/generated/` and the generated protocol files
in the client package must not be edited by hand. Change the source model or
endpoint and regenerate instead.

The `serverpod_rbac_server` and `serverpod_rbac_client` packages are released
together at version `1.0.0`, target Serverpod 4.0.4, and require Dart SDK
`^3.12.2`.
The root `pubspec.yaml` is a workspace for the two packages, rather than a
runnable application/server.

## Authorization concepts and evaluation

### Permissions

A permission is a named capability with a `resource`, `codename`, human-readable
`name`, optional `description`, and creation timestamp. For example:

| Resource | Codename | Canonical key |
|---|---|---|
| `article` | `view` | `article.view` |
| `invoice` | `approve` | `invoice.approve` |
| `global` | `manage` | `global.manage` |

Use stable, lowercase resource names and codenames. The database enforces
uniqueness on `(resource, codename)`. A permission key passed to a check may
be fully qualified (`article.view`) or a bare codename (`view`).

Permission parsing splits a qualified key at its first dot and trims the
resource and remaining codename. Prefer fully qualified names to avoid
ambiguity. For a bare codename, a check first uses the configured
`defaultResource` to form the canonical key and also matches a permission with
that codename in any resource. A bare permission therefore should not be used
when the same codename has different meanings across resources.

Permission checks recognize the following stored wildcard grants:

- `resource.*` allows any codename for that resource.
- `*.*` allows any resource/codename combination.

Wildcards are permission records too: define them, assign them to a role or
user, and treat their grant as broadly privileged.

### Roles and assignments

A role is a reusable named group of permissions. Users may hold multiple
roles; their permissions are the union of the permissions attached to those
roles, plus any direct grants, subject to direct denials.

Role names are trimmed and lowercased by the service. The database enforces
unique role names. A role may also be flagged `isSuperuser`; assigning that
role makes the user a superuser. `isSystemRole` is stored on roles created via
the service, and system roles cannot be deleted through `deleteRole`.

### Direct user permissions and denials

A direct user grant adds a permission even when no assigned role grants it.
An explicit deny (`isGranted: false`) removes that permission from the
resolved permission snapshot, including when it was inherited from one or
more roles. There is at most one direct entry per user and permission:

- Granting a permission changes an existing explicit deny into a grant.
- Revoking with `explicitDeny: true` creates or updates an explicit deny.
- Revoking with `explicitDeny: false` deletes the direct entry. It does not
  remove a grant inherited from a role.

The normal permission-check logic does not consult the direct deny after a
user has been identified as a superuser and the superuser bypass is enabled.

### Superusers

`isSuperuser` is true when one of these applies:

1. The current authenticated user has `Scope.admin`.
2. The configured custom superuser resolver returns `true`.
3. The user is assigned a role whose `isSuperuser` flag is true.

By default, superusers bypass all permission and role checks. This is
controlled by `superusersBypassAll`. `requireSuperuser` checks superuser
status itself and does not depend on that bypass option.

The `RbacUserPermissionsInfo` response still includes the user's resolved
roles and permissions; a superuser bypass does not insert every possible
permission into the returned permission list.

### AND/OR checks

- `hasAllPermissions` and `hasAllRoles` require every requested item (AND).
- `hasAnyPermission` and `hasAnyRole` require at least one requested item (OR).
- An empty `all` list passes because all zero requested items are present.
- An empty `any` list fails because none of the zero requested items is present.

With the default superuser bypass, a superuser passes an `all` check, and
passes an `any` check only when the requested list is non-empty.

## Installation and Serverpod integration

### Add the packages

Add the server package to the host Serverpod server:

```powershell
dart pub add serverpod_rbac_server
```

Add the companion client package to each Flutter/client project that calls
the generated RBAC endpoints:

```powershell
dart pub add serverpod_rbac_client
```

These are separate packages because Pub dependencies belong to one project;
adding a dependency to the server cannot modify a separate Flutter project's
`pubspec.yaml`. The server package includes the module definition and its
client package path so Serverpod can generate the module protocol and
endpoints. Keep both packages at the same RBAC release version.

Run `dart pub get` in the host workspace after changing its dependencies.
The root workspace here already contains both packages.

### Integrate the module

Add the module to the host server's `pubspec.yaml` dependencies and register
its nickname in the host `config/generator.yaml`:

```yaml
modules:
  serverpod_rbac:
    nickname: rbac
```

The package's own generator configuration is in
`serverpod_rbac_server/config/generator.yaml`; it declares the module's
nickname and relative client package path.

The generated module endpoints are named `rbac` and `rbacAdmin`. Regenerate
the host server and client protocol with Serverpod after adding the module:

```powershell
dart pub get
serverpod generate
```

The host server must include the generated RBAC protocol and endpoints in its
Serverpod setup; follow the generated integration pattern for the Serverpod
version in use. This repository is a module workspace and does not contain a
runnable host server or its `server.dart`.

Apply the module's database migrations in each target environment before
using the RBAC tables. See [Migrations and upgrades](#migrations-and-upgrades).

### Configure startup

Configure the singleton once during host server startup, before requests are
served:

```dart
import 'package:serverpod_rbac_server/serverpod_rbac_server.dart';

void configureAuthorization() {
  RbacService.instance.configure(
    RbacConfig(
      cacheMedium: RbacCacheMedium.global,
      cacheLifetime: const Duration(minutes: 2),
      enableRequestCache: true,
      enableAuditLog: true,
      defaultResource: 'global',
      superusersBypassAll: true,
    ),
  );
}
```

The example selects the shared cache and therefore assumes the host
Serverpod deployment has configured its global cache backend. Choose settings
appropriate to the deployment; the defaults and trade-offs are described
below.

## Configuration

`RbacService.instance.config` is the singleton's mutable `RbacConfig`.
`configure` replaces the current configuration; `copyWith` creates a
configuration with selected fields changed.

| Setting | Default | Behavior |
|---|---:|---|
| `cacheMedium` | `RbacCacheMedium.local` | `local` uses the Serverpod node-local cache; `global` uses the shared cache; `disabled` skips process-level cache operations. |
| `cacheLifetime` | 1 minute | Lifetime of a cached permission snapshot. |
| `enableRequestCache` | `true` | Reuses permission snapshots and cache-generation reads in the same Serverpod session/request. |
| `enableAuditLog` | `true` | Writes authorization decisions and administrative operations to the audit table. |
| `defaultResource` | `global` | Resource prefix for bare permission keys during checks and seeding. Prefer fully qualified keys for management calls. |
| `superusersBypassAll` | `true` | Makes superusers pass normal permission and role checks. |

`disabled` process caching does not disable the request cache if
`enableRequestCache` remains true. For always-fresh database resolution, disable
both.

An optional `RbacService.instance.customSuperuserResolver` can integrate an
application-specific superuser source:

```dart
RbacService.instance.customSuperuserResolver =
    (Session session, String userIdentifier) async {
      // Query the application's trusted superuser source.
      return false;
    };
```

The resolver supplements the built-in `Scope.admin` and `isSuperuser` role
checks; returning `false` does not veto either built-in mechanism. Configure
it during startup and ensure its data source and failure behavior meet the
application's authorization requirements.

## Defining permissions and roles

Design permission names around actions on a resource, not UI controls.
Examples include `report.view`, `report.export`, and `report.delete`. Keep
permission meanings stable and use roles to bundle capabilities appropriate
to application responsibilities.

The general setup order is:

1. Create each permission.
2. Create roles.
3. Attach permissions to roles.
4. Assign roles to users.
5. Enforce permission checks in the server-side operations that protect data.

Role and permission assignments are global in this module. There is no
inheritance between roles; attach the required permissions to each role
explicitly.

## Seeding initial data

Use `RbacSeeder.seed` for trusted bootstrap or deployment setup. It inserts
missing permission and role definitions and role-permission links, and ignores
duplicate inserts. It is safe to run repeatedly and is **additive**, not a
declarative synchronizer:

- Existing permission names/descriptions are not updated.
- Existing role descriptions or `isSuperuser` values are not updated.
- Existing role-permission links are retained.
- Links listed in a later seed are added, but omitted links are not removed.
- Seeding does not assign roles to users.

If you need to remove grants or change existing definitions, use the
management service/endpoint deliberately rather than assuming a seed removes
or updates old records. Validate that every role permission is included in
the seed's permission definitions; the seeder throws `ArgumentError` when a
role references an omitted definition. Resource, codename, and role values
are normalized to lowercase; role names are also trimmed.

```dart
await RbacSeeder.seed(
  session,
  permissions: const [
    RbacSeedPermission(
      resource: 'article',
      codename: 'view',
      name: 'Can view articles',
    ),
    RbacSeedPermission(
      resource: 'article',
      codename: 'edit',
      name: 'Can edit articles',
    ),
    RbacSeedPermission(
      resource: 'rbac',
      codename: 'manage',
      name: 'Can manage RBAC',
    ),
  ],
  roles: const [
    RbacSeedRole(
      name: 'reader',
      description: 'Can read articles',
      permissions: ['article.view'],
    ),
    RbacSeedRole(
      name: 'editor',
      description: 'Can read and edit articles',
      permissions: ['article.view', 'article.edit'],
    ),
    RbacSeedRole(
      name: 'rbac_manager',
      description: 'Can manage roles, permissions, and assignments',
      permissions: ['rbac.manage'],
    ),
  ],
);
```

Seed a superuser role only from trusted deployment/bootstrap code, protect its
assignment carefully, and do not expose the seeder or unchecked role
assignment to public clients. An initial administrator can also be
provisioned through trusted server-side code with `assignRoleToUser`; an
unauthorized client cannot bootstrap itself through the admin endpoint.

## Enforcing authorization in server code

Import the server package's public barrel. The `Session.rbac` extension
provides checks for the authenticated session user:

```dart
import 'package:serverpod_rbac_server/serverpod_rbac_server.dart';

class ArticleEndpoint extends Endpoint {
  Future<Article> updateArticle(Session session, Article article) async {
    await session.rbac.requirePermission('article.edit');

    // Also validate that this user can access this particular article.
    return Article.db.updateRow(session, article);
  }
}
```

Use `require*` methods before the protected operation. The caller can handle
the resulting `RbacException` through the application's standard Serverpod
error flow. A boolean check is useful for optional behavior, but remember to
protect the server operation itself:

```dart
if (await session.rbac.hasPermission('article.export')) {
  // Optional server-side behavior.
}
```

### Session helper API

All methods below operate on the authenticated user attached to the supplied
`Session`.

| Method | Result |
|---|---|
| `session.rbac.userIdentifier` | Authenticated identifier, or `null`. |
| `session.rbac.isAuthenticated` | Whether the session has a user identifier. |
| `session.rbac.isSuperuser()` | Whether the current user is a superuser. |
| `session.rbac.hasPermission(permission)` | Whether one permission is granted. |
| `session.rbac.hasAllPermissions(permissions)` | Whether every listed permission is granted. |
| `session.rbac.hasAnyPermission(permissions)` | Whether at least one listed permission is granted. |
| `session.rbac.hasRole(role)` | Whether one role is assigned (or superuser bypass applies). |
| `session.rbac.hasAnyRole(roles)` | Whether any listed role is assigned. |
| `session.rbac.hasAllRoles(roles)` | Whether all listed roles are assigned. |
| `session.rbac.requirePermission(permission)` | Enforces one permission. |
| `session.rbac.requireAllPermissions(permissions)` | Enforces all listed permissions. |
| `session.rbac.requireAnyPermission(permissions)` | Enforces at least one listed permission. |
| `session.rbac.requireRole(role)` | Enforces one role. |
| `session.rbac.requireAllRoles(roles)` | Enforces all listed roles. |
| `session.rbac.requireAnyRole(roles)` | Enforces at least one listed role. |
| `session.rbac.requireSuperuser()` | Enforces superuser status. |
| `session.rbac.getPermissionsInfo()` | Returns the current user's summary, or `null` if unauthenticated. |
| `session.rbac.getAllPermissions()` | Returns a `Set<String>` of effective permission keys; empty when unauthenticated. |
| `session.rbac.getRoles()` | Returns assigned role names; empty when unauthenticated. |

`getAllPermissions`, `getRoles`, and `getPermissionsInfo` are for inspection;
they are not enforcement substitutes.

### Service API and explicit user identifiers

Use `RbacService.instance` directly for management and trusted background
work. Most service checks accept an optional `userIdentifier`, allowing a
trusted server task to inspect a user other than the current session user:

```dart
final rbac = RbacService.instance;
final allowed = await rbac.hasPermission(
  session,
  'article.edit',
  userIdentifier: targetUserIdentifier,
);
```

An explicit identifier is not proof that the caller may act for that user.
Never pass a client-supplied identifier into privileged code without
independently authorizing the caller.

`getUserPermissionsInfo(session, userIdentifier, forceRefresh: true)` can
bypass the cached snapshot and resolve that user's current records from the
database. The subsequent resolution is stored in the configured cache.

The service also exposes `parsePermission` and `formatPermissionKey` for
normalizing permission keys. `requireUserIdentifier` throws
`RbacException(notAuthenticated)` when no non-empty explicit or authenticated
identifier exists; `getUserIdentifier` returns `null` instead.

## Client endpoints

The generated client exposes `client.rbac` for self-inspection and
`client.rbacAdmin` for management. Authenticate the client using the host
application's normal Serverpod authentication integration before calling
either endpoint.

### `rbac` self-service endpoint

Every method requires login and acts on the current authenticated user. The
endpoint exposes:

- `isSuperuser()`
- `getMyPermissions()`
- `hasPermission(permission)`
- `hasAllPermissions(permissions)` / `hasAnyPermission(permissions)`
- `hasRole(role)` / `hasAnyRole(roles)` / `hasAllRoles(roles)`
- `requirePermission(permission)`
- `requireAllPermissions(permissions)` / `requireAnyPermission(permissions)`
- `requireRole(role)` / `requireAllRoles(roles)` / `requireAnyRole(roles)`
- `requireSuperuser()`

For example, in a client that already has its authenticated Serverpod client:

```dart
final info = await client.rbac.getMyPermissions();
final canEdit = await client.rbac.hasPermission('article.edit');
```

Use this endpoint to render user-specific presentation (for example, hiding
an unavailable action). It does not secure the corresponding server method;
always enforce permission and object access on the server as well.

### `rbacAdmin` management endpoint

Every method requires login and then requires either superuser status or the
`rbac.manage` permission:

| Method | Purpose |
|---|---|
| `createPermission(...)` | Create or retrieve a permission. |
| `listPermissions(resource: ...)` | List permissions, optionally filtered by resource. |
| `deletePermission(permissionId)` | Delete a permission by ID. |
| `createRole(...)` | Create or retrieve a role. |
| `listRoles()` | List roles. |
| `deleteRole(name)` | Delete a role by name. |
| `assignPermissionsToRole(roleName, permissions)` | Add permissions to a role. |
| `removePermissionsFromRole(roleName, permissions)` | Remove permissions from a role. |
| `getRolePermissions(roleName)` | List a role's permission records. |
| `assignRoleToUser(userIdentifier, roleName)` | Assign a role. |
| `removeRoleFromUser(userIdentifier, roleName)` | Remove a role assignment. |
| `getUserRoles(userIdentifier)` | List a user's roles. |
| `grantPermissionToUser(userIdentifier, permission)` | Add a direct grant. |
| `revokePermissionFromUser(userIdentifier, permission, explicitDeny)` | Remove a direct entry or store an explicit deny. |
| `getUserPermissionsInfo(userIdentifier)` | Inspect a user's resolved permission summary. |

The admin endpoint authorizes the caller, not the target user. Admin clients
must still follow the application's policies for who may manage which users
or resources; this module does not impose per-tenant administration.

## Managing permissions, roles, and assignments

The same operations are available directly from `RbacService.instance`.
Service methods do not automatically authorize their caller. Use these
methods only inside trusted server code or behind a properly protected
endpoint.

```dart
final rbac = RbacService.instance;

final permission = await rbac.createPermission(
  session,
  resource: 'invoice',
  codename: 'approve',
  name: 'Approve invoice',
);

final role = await rbac.createRole(
  session,
  name: 'approver',
  description: 'Can approve invoices',
);

await rbac.assignPermissionsToRole(
  session,
  roleName: role.name,
  permissions: ['invoice.approve'],
);

await rbac.assignRoleToUser(
  session,
  userIdentifier: userIdentifier,
  roleName: role.name,
);
```

### Management method behavior

- `createPermission` returns an existing exact-match permission if found;
  otherwise it inserts a lowercased resource/codename. The existing record's
  name and description are not updated.
- `listPermissions(resource: ...)` sorts by resource and optionally filters
  for the exact resource string supplied.
- `deletePermission(id)` deletes when the ID exists and otherwise does
  nothing. Related role/direct-user links cascade-delete in the database.
- `createRole` trims and lowercases its name and returns an existing role
  with that normalized name without updating its metadata.
- `getRole(name)` normalizes the name. `listRoles()` sorts by name.
- `deleteRole(name)` does nothing if the role is missing and throws
  `RbacException(roleDenied)` if it is marked as a system role. Related
  assignments cascade-delete.
- `assignPermissionsToRole` throws `RbacException(roleNotFound)` if the role
  is missing. Unknown permission keys are skipped; create definitions first.
  Existing links and duplicate permission arguments do not create duplicate
  links. An unqualified permission uses the parser's default resource
  (`global`) here.
- `removePermissionsFromRole` is idempotent; a missing role or permission
  link is a no-op. It also parses unqualified keys using `global`.
- `getRolePermissions` returns an empty list for a missing role or a role
  without permission links.
- `assignRoleToUser` throws `RbacException(roleNotFound)` for a missing role
  and is idempotent for an existing assignment.
- `removeRoleFromUser` is idempotent; a missing role or assignment is a
  no-op.
- `getUserRoles` returns an empty list when the user has no role assignments.
- `grantPermissionToUser` throws `RbacException(permissionNotFound)` for an
  undefined permission and changes an existing explicit deny into a grant.
- `revokePermissionFromUser` with an unknown permission is a no-op. With
  `explicitDeny: false`, it removes the direct entry; with
  `explicitDeny: true`, it inserts/updates a deny.

Mutating operations invalidate affected permission snapshots and emit audit
events when auditing is enabled.

## Data model and database behavior

The module's Serverpod models are defined in `serverpod_rbac_server/lib/src/models`.

| Model | Table | Important fields and constraints |
|---|---|---|
| `RbacPermission` | `serverpod_rbac_permission` | `resource`, `codename`, `name`, optional `description`, `createdAt`; unique `(resource, codename)`. |
| `RbacRole` | `serverpod_rbac_role` | Unique `name`, optional `description`, `isSuperuser`, `isSystemRole`, `createdAt`. |
| `RbacRolePermission` | `serverpod_rbac_role_permission` | `roleId`, `permissionId`, `createdAt`; unique role/permission pair. Both parent references cascade on delete. |
| `RbacUserRole` | `serverpod_rbac_user_role` | `userIdentifier`, `roleId`, `createdAt`; unique user/role pair and an index on user. Role deletion cascades. |
| `RbacUserPermission` | `serverpod_rbac_user_permission` | `userIdentifier`, `permissionId`, `isGranted`, `createdAt`; unique user/permission pair and an index on user. Permission deletion cascades. |
| `RbacAuditLog` | `serverpod_rbac_audit_log` | Optional user, action, optional resource/codename/role/details, allow/deny result, timestamp; indexes on user and timestamp. |
| `RbacUserPermissionsInfo` | No table (protocol object) | `userIdentifier`, `isSuperuser`, role names, effective permission keys. |
| `RbacException` | No table (protocol exception) | Message, reason, optional required permission/role, optional user identifier. |

`userIdentifier` is a Serverpod authentication identifier stored as a string;
it is not a foreign key to an application user table. The host application is
responsible for validating that identifiers refer to valid users and for
handling user deletion/retention.

## Caching and invalidation

The service resolves the roles, role permissions, direct grants, direct
denials, and superuser state into one `RbacUserPermissionsInfo` snapshot.
Repeated checks reuse that snapshot when caching is enabled.

| Cache layer | Setting | Scope and use |
|---|---|---|
| Request/session cache | `enableRequestCache` | Avoids repeated snapshot and generation lookups within the same Serverpod session/request. |
| Local cache | `RbacCacheMedium.local` | Serverpod node-local cache; suitable for development or single-node use. |
| Global cache | `RbacCacheMedium.global` | Serverpod shared cache for multi-node deployments; all nodes must use the same backend. |
| No process cache | `RbacCacheMedium.disabled` | Resolves from the database after request-cache misses. |

The snapshot lifetime defaults to one minute. The exact maximum revocation
staleness depends on the selected backend, generation visibility, and the
request already in progress. A permission decision already made during an
active request is not retroactively withdrawn.

RBAC service mutations invalidate one user's generation for user-specific
changes and the global generation for role/permission definition changes.
Cache generation entries use a long lifetime and are updated on invalidation.
In `local` mode, invalidation is node-local; use `global` in a multi-node
deployment to share generation changes.

Writes made directly through the ORM or SQL bypass RBAC invalidation. After
such writes, call:

```dart
await RbacService.instance.cache.invalidateUser(session, userIdentifier);
// Or invalidate all snapshots after a global permission/role change:
await RbacService.instance.cache.invalidateAll(session);
```

Cache read/write failures are logged as warnings. Reads fall back to database
resolution; cache write failures do not change the authorization result.
Monitor these warnings and verify the shared cache configuration in a
multi-node deployment.

## Audit logging

Auditing is enabled by default. When enabled, the module writes decisions and
management actions to `serverpod_rbac_audit_log`. Audit rows can include:
user identifier, action name, resource, permission codename, role name,
allowed/denied result, optional details, and timestamp.

`RbacService.instance.audit.log(...)` records one event, and
`RbacService.instance.audit.logMany(...)` records a batch. Service checks and
mutations call the audit service automatically where implemented. Some
short-circuit cases (for example, unauthenticated role checks) can return
without an audit row; do not treat the table as a guaranteed complete
compliance ledger without verifying the application's requirements.

Audit persistence failures are logged as warnings and do not change the
authorization result or stop the management operation. Do not put secrets,
tokens, or unnecessary personal data in audit details. Define access,
retention, backup, export, and deletion policies for the records. Audit
logging can create a database write for each checked decision; measure this
cost under real request volume before disabling it or relying on it for
compliance.

## Errors and expected behavior

The module defines the serializable `RbacException` and
`RbacExceptionReason` protocol types:

| Reason | Meaning |
|---|---|
| `permissionDenied` | A required permission or superuser check failed; also used by the admin endpoint when the caller lacks `rbac.manage`. |
| `roleDenied` | A required role check failed, or a protected system role was targeted for deletion. |
| `userInactive` | Available enum value; no current check in this module emits it. |
| `notAuthenticated` | A `require*` check could not identify an authenticated or explicitly supplied user. |
| `roleNotFound` | A role required by an assignment operation does not exist. |
| `permissionNotFound` | A direct grant references an undefined permission. |

Boolean `has*` methods generally return `false` for an unauthenticated session
rather than throwing. `require*` methods throw on authentication or
authorization failure. `RbacEndpoint` and `RbacAdminEndpoint` both set
`requireLogin = true`, so Serverpod also enforces authentication at the RPC
boundary. `getMyPermissions` explicitly throws `notAuthenticated` if it
cannot obtain the authenticated user's snapshot.

Administrative service methods are not authorization boundaries. The
`rbacAdmin` endpoint checks for login and then superuser status or
`rbac.manage`; direct calls to `RbacService` from your own endpoint must be
protected by that endpoint.

## Scope and security boundaries

This module implements **global role and permission checks only**. It does
not implement tenant scopes, object-level grants, ownership rules, or
row-level query filtering. In particular, it does not provide a
`hasObjectPermission` API or a table of per-object grants.

For tenant- or record-specific data:

1. Check the user's tenant membership/ownership in server code.
2. Apply tenant and ownership constraints in the database query itself.
3. Use the global RBAC permission as an additional capability check where
   appropriate.
4. Never fetch unrestricted rows and rely on filtering in a client/UI.

Do not trust a client-side permission check, an explicit user identifier
provided by a client, a hidden UI control, or a role name supplied by a
caller as proof of authorization. Enforce authorization on every server
request that reads or mutates protected data, including background jobs and
internal code paths where relevant.

`Scope.admin` is treated as superuser for the current authenticated user.
Use it only according to the host application's Serverpod authentication
and token issuance policy. Superuser roles and wildcard grants are highly
privileged and should be granted sparingly.

## Migrations and upgrades

The models require the RBAC database tables and indexes to be present. When
changing a `.spy.yaml` model:

1. Edit the model source, not generated Dart.
2. Run Serverpod generation from the host Serverpod project/workspace.
3. Review the generated model/protocol changes.
4. Create a migration, inspect its SQL, and apply it to a disposable or
   staging database.
5. Verify existing data and indexes before production rollout.
6. Apply the migration in each deployed environment before serving code that
   depends on the new schema.

Typical Serverpod commands in the host project are:

```powershell
serverpod generate
serverpod create-migration --tag descriptive_change
```

Use the host project's standard migration-application workflow; commands and
deployment automation can differ between Serverpod applications. The CLI
commands above must be run from the host Serverpod project, which owns the
module configuration and migration lifecycle.

### Current schema and historical scope removal

The current schema has global user-role and user-permission assignments. It
does not have an object-permission table or `scope`/`objectId` audit fields.
The latest migration in this repository,
`20261015050330456-remove-scopes-object-permissions`, removes the old
`serverpod_rbac_object_permission` table and those audit metadata columns. It
also removes scope columns from user-role and user-permission assignments,
deduplicates assignment rows, and adds global unique indexes.

When that migration is applied to a database containing the earlier scoped
schema:

- Duplicate user/permission and user/role rows are collapsed, keeping the
  row with the most recent `createdAt` (then greatest ID as a tiebreaker).
- The object-permission table and its grants are dropped.
- Scope and object identifiers on audit rows are dropped.
- Assignment scope columns are dropped.

Back up the database and review this data loss before upgrading. The
migration is forward-only with respect to the removed object grants and
audit metadata; the new schema cannot restore those values. Applications
upgrading from earlier scoped APIs must remove scope arguments and replace
object checks with application-owned membership/ownership enforcement.

## Testing and analysis

The server package contains integration tests for seeding, permission
resolution, role assignments, direct grants/denials, superuser behavior,
cache invalidation, and endpoint access. Tests use the test configuration
under `serverpod_rbac_server/config/`; its database is configured at
`localhost:9090`. Start/configure the test PostgreSQL service as required by
the local Serverpod test setup. The repository includes a Compose service
definition in `serverpod_rbac_server/docker-compose.yaml`.

From the workspace root, run:

```powershell
cd serverpod_rbac_server
dart test
```

Run static analysis for both packages from the workspace root:

```powershell
dart analyze serverpod_rbac_server serverpod_rbac_client
```

When changing generated models or endpoints, regenerate through Serverpod
before running analysis and tests. Add integration coverage for changes to
permission resolution, bypass rules, invalidation, or endpoint authorization.
Test tenant/ownership policy in the host application because it is outside
this module.

## Production checklist

- [ ] Use global/shared caching across all nodes for multi-node deployments.
- [ ] Set snapshot lifetime to an acceptable authorization-staleness window.
- [ ] Configure RBAC once before serving requests; avoid changing singleton
  settings during concurrent requests.
- [ ] Seed definitions and bootstrap trusted administrators through
  deployment/server-side code, not a public client endpoint.
- [ ] Grant least privilege; review direct user entries, superuser roles,
  `Scope.admin`, and wildcard permissions.
- [ ] Put `require*` checks at server-side trust boundaries and add
  application-specific tenant/ownership checks to data queries.
- [ ] Decide whether audit persistence, retention, and access meet the
  application's operational/compliance requirements.
- [ ] Monitor database/cache latency, cache warnings, audit write warnings,
  and audit table growth.
- [ ] Back up the database and rehearse migrations against production-like
  data, especially the historical scope-removal migration.
- [ ] Apply the migration before deploying code that expects its schema.
- [ ] Test permission revocation and cache invalidation across all server
  nodes in staging.
- [ ] Ensure all client-visible permission information is used for
  presentation only, never as the sole enforcement.

## Troubleshooting

| Symptom | Check |
|---|---|
| A permission check returns `false` | Verify the permission exists, resource/codename spelling and case, role links, user-role assignment, direct deny entry, and whether a bare codename is ambiguous. |
| Assigning a role permission has no effect | `assignPermissionsToRole` skips unknown permissions. Create/seed the permission first, use the right resource, then invalidate/reload any externally written state. |
| A direct grant throws `permissionNotFound` | Create the permission record before granting it. |
| Changes appear stale | Use service mutation methods, confirm correct cache medium/shared backend, check generation invalidation, account for the current request cache, or resolve with `forceRefresh: true` while debugging. |
| One node sees a revocation but another does not | Do not use `local` cache in a multi-node system when cross-node consistency is required; configure `global` cache on all nodes. |
| `rbacAdmin` rejects an authenticated caller | The caller needs superuser status or `rbac.manage`; `requireLogin` alone is insufficient. |
| A role cannot be deleted | Check whether `isSystemRole` is true. This module prevents deleting system roles through `deleteRole`. |
| An unauthenticated check behaves differently from enforcement | `has*` returns `false`; `require*` throws `RbacException(notAuthenticated)`. RPC endpoints additionally require login. |
| Audit rows are missing | Confirm `enableAuditLog`, check whether the code path writes audit records, and inspect server warnings and database connectivity. Some check paths do not write an audit event. |
| Test setup cannot connect to PostgreSQL | Confirm the configured test database at `localhost:9090` is running and matches `config/test.yaml` and the local test setup. |
