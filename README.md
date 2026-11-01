# Serverpod RBAC & ABAC

Production-ready, highly efficient Role-Based & Attribute-Based Access Control (RBAC/ABAC) for Serverpod 4.0.4.

Define named permissions, assign them to roles, assign roles to users (globally or scoped to domains/tenants), and enforce access or retrieve domain filters seamlessly in server-side endpoints.

## Features

- **Strict, Reliable RBAC**: Only roles are assigned to users, and permissions are assigned to roles.
- **ABAC Domain Service**: Built-in `AbacService` evaluates domain access. If `hasDomains` is true, it returns the assigned domains (`getDomains`) for developers to pass directly into query filters (e.g. `serverpod_filters`).
- **Zero Third-Party Coupling**: `serverpod_rbac` returns stored domains without depending on `serverpod_filters`.
- **Standard Global Redis Caching**: Standardized on Serverpod's distributed cache (`session.caches.global`) with request-scoped caching and instant generation invalidation. No complex config toggles needed.
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

// Assign role to user globally (unrestricted)
await rbac.assignRoleToUser(
  session,
  userIdentifier: 'user-123',
  roleName: 'editor',
);

// Or assign role to user within specific domains (ABAC)
await rbac.assignRoleToUserDomains(
  session,
  userIdentifier: 'user-456',
  roleName: 'editor',
  domains: ['finance', 'operations'],
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

    // Or check domain-scoped permission
    await session.rbac.requirePermission('document.edit', domain: 'finance');
  }
}
```

### 3. ABAC Domain Filtering (Using with `serverpod_filters`)

When retrieving records, use `session.rbac.abac` to check if the user is restricted to specific domains:

```dart
class DocumentEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<List<Document>> listDocuments(Session session) async {
    await session.rbac.requirePermission('document.read');

    // 1. Check if user access is constrained by domains
    final hasDomains = await session.rbac.abac.hasDomains('document.read');

    if (hasDomains) {
      // 2. Fetch the domains the user is permitted to access
      final domains = await session.rbac.abac.getDomains('document.read');

      // 3. Apply domains in your database query or pass to serverpod_filters
      return Document.db.find(
        session,
        where: (t) => t.domain.inSet(domains.toSet()),
      );
    }

    // Unrestricted (superuser or global role): return without domain restrictions
    return Document.db.find(session);
  }
}
```

## Architecture

| Component | Description |
|---|---|
| `RbacService` | Core singleton handling role/permission queries, single & bulk mutations, and cache management. |
| `AbacService` | Attribute-based access control determining domain constraints (`hasDomains`, `getDomains`, `getDomainAccess`). |
| `RbacCache` | High-performance Redis distributed cache (`session.caches.global`) with request-level memoization. |
| `RbacEndpoint` | Self-service inspection endpoint for authenticated clients (`getMyPermissions`, `hasPermission`, `getMyDomains`). |
| `RbacAdminEndpoint` | Administrative endpoint for managing permissions, roles, and user assignments with bulk capabilities. |
