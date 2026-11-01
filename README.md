# Serverpod RBAC & ABAC

Production-ready, highly efficient Role-Based & Attribute-Based Access Control (RBAC/ABAC) for Serverpod 4.0.4.

Define named permissions, assign them to roles, assign roles to users, and attach Odoo-style row-filter expressions to roles. The server library returns the stored JSON expressions; your application installs a query-filtering library separately to apply them.

## Features

- **Strict, Reliable RBAC**: Only roles are assigned to users, and permissions are assigned to roles.
- **Odoo-Style ABAC Domains**: Store row-filter JSON expressions per role and resource, then retrieve permission-scoped access decisions. Resolved decisions are cached for one minute and invalidated when authorization data changes.
- **Zero Filtering-Library Coupling**: `serverpod_rbac` does not parse or execute filters. Install `serverpod_filters_server` separately if you want to compile its supported filter syntax into Serverpod ORM queries.
- **Standard Global Redis Caching**: Uses Serverpod's distributed cache (`session.caches.global`) when Redis is configured, plus request-scoped memoization and generation-based invalidation. Without Redis, caching is limited to the current session/request.
- **Single & Bulk Endpoint Operations**: Full administrative support for single (`insertRow`, `deleteRow`) and high-throughput bulk operations (`insert`, `delete`) directly via endpoints. No seeder needed.
- **Latest Serverpod ORM Relations**: Bidirectional object relations on `RbacRole`, `RbacPermission`, `RbacRolePermission`, and `RbacUserRole` for single-query eager loading (`include`).
- **Superuser Support**: Native `Scope.admin` integration and role-level `isSuperuser` flags.

## Installation

Add `serverpod_rbac_server` to your Serverpod server's `pubspec.yaml`:

```yaml
dependencies:
  serverpod_rbac_server: ^1.0.0
```

Add `serverpod_rbac_client` to your client or Flutter app's `pubspec.yaml`:

```yaml
dependencies:
  serverpod_rbac_client: ^1.0.0
```

If your server will compile stored domains into ORM queries, add the filter package separately to the server's `pubspec.yaml`:

```yaml
dependencies:
  serverpod_filters_server: ^1.1.0
```

Register the module in `config/generator.yaml`:

```yaml
modules:
  serverpod_rbac:
    nickname: rbac
```

Run code generation and apply migrations:

```powershell
serverpod generate
```

## Quick Start

### 1. Managing Roles and Permissions (Admin Endpoint or Service)

Everything can be managed via `RbacAdminEndpoint` or `RbacService.instance` using single (`insertRow`) or bulk (`insert`) methods:

```dart
final rbac = RbacService.instance;

// Bulk create permissions
await rbac.createPermissions(session, [
  RbacPermission(resource: 'document', codename: 'read', name: 'Read Document'),
  RbacPermission(resource: 'document', codename: 'edit', name: 'Edit Document'),
]);

// Single role creation
await rbac.createRole(session, name: 'editor');

// Bulk assign permissions to role
await rbac.assignPermissionsToRole(
  session,
  roleName: 'editor',
  permissions: ['document.read', 'document.edit'],
);

await rbac.assignRoleToUser(
  session,
  userIdentifier: 'user-123',
  roleName: 'editor',
);

```

### 2. Enforcing RBAC in Endpoints

```dart
class DocumentEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<void> editDocument(Session session, int docId) async {
    // Throws RbacException if not permitted
    await session.rbac.requirePermission('document.edit');

  }
}
```

### 3. ABAC Row Filtering (Using with `serverpod_filters_server`)

Attach a JSON domain to a role, scoped to the resource being queried:

```dart
await AbacService.instance.addDomainRule(
  session,
  roleName: 'editor',
  resource: 'document',
  permission: 'document.read',
  filterExpression: '[["ownerId", "=", 42]]',
);
```

In the application server, install `serverpod_filters_server` separately and apply the returned expression. Check `isAllowed` before querying; OR-combine multiple matching role rules:

```dart
import 'package:serverpod_filters_server/serverpod_filters_server.dart';

class DocumentEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<List<Document>> listDocuments(Session session) async {
    final access = await session.rbac.abac.getDomainAccess(
      'document.read',
      resource: 'document',
    );
    if (!access.isAllowed) {
      throw RbacException(
        message: 'Permission denied: required "document.read"',
        reason: RbacExceptionReason.permissionDenied,
        requiredPermission: 'document.read',
        userIdentifier: session.authenticated?.userIdentifier,
      );
    }

    if (!access.hasDomains) return Document.db.find(session);

    return Document.db.find(
      session,
      where: (table) => access.filterExpressions
          .map(
            (domain) => ServerpodFilters.toWhere(
              domain,
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

Rules may be scoped to a permission (`resource: 'invoice'`, `permission: 'invoice.create'`); a rule with no permission remains a resource-wide rule for backwards compatibility. When a user has several restricted roles for the same permission, each returned expression is an alternative and should be OR-combined. Multiple criteria inside one expression are AND-combined by `serverpod_filters_server`. If any matching role has no applicable rule, that role grants unrestricted access, so the resulting access is unrestricted.

## Architecture

| Component | Description |
|---|---|
| `RbacService` | Core singleton handling role/permission queries, single & bulk mutations, and cache management. |
| `AbacService` | Retrieves Odoo-style row-filter expressions for a user's role/permission access. |
| `RbacCache` | High-performance Redis distributed cache (`session.caches.global`) with request-level memoization. |
| `RbacEndpoint` | Self-service inspection endpoint for authenticated clients (`getMyPermissions`, `hasPermission`, `getMyDomainFilters`). |
| `RbacAdminEndpoint` | Administrative endpoint for managing permissions, roles, user assignments, and ABAC rules. |

For a beginner-friendly, file-by-file explanation of the implementation and
every service/API function, see the [Technical Guide](./TECHNICAL_GUIDE.md).
