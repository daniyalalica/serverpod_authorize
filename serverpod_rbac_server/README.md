# `serverpod_rbac_server`

Server-side authorization and ABAC library for Serverpod 4.0.4. Import
`package:serverpod_rbac_server/serverpod_rbac_server.dart` to access
`RbacService`, `AbacService`, generated protocol types, and the `Session.rbac` extension.

## Overview

- **Standard Global Redis Caching**: Utilizes `session.caches.global` with zero configuration overhead.
- **Strict Role-Based Model**: Permissions are assigned to roles; roles are assigned to users.
- **ABAC Domain Service**: Check domain restrictions via `session.rbac.abac.hasDomains(permission)` and retrieve domains via `session.rbac.abac.getDomains(permission)` to plug into filters.
- **Single & Bulk Operations**: Endpoints and service support both single (`insertRow`) and bulk (`insert`) operations for maximum performance.
- **Modern Serverpod ORM**: Fully typed bidirectional relations with eager inclusion.

## Authorization & ABAC Example

```dart
// Require permission
await session.rbac.requirePermission('article.edit');

// Domain evaluation for query filtering
if (await session.rbac.abac.hasDomains('article.read')) {
  final domains = await session.rbac.abac.getDomains('article.read');
  // Pass domains to serverpod_filters or native ORM
}
```
