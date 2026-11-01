# `serverpod_rbac_server`

Server-side authorization and ABAC library for Serverpod 4.0.4. Import
`package:serverpod_rbac_server/serverpod_rbac_server.dart` to access
`RbacService`, `AbacService`, generated protocol types, and the `Session.rbac` extension.

## Overview

- **Authorization Decision Caching**: Caches permission-scoped domain decisions for one minute and invalidates them on authorization changes. Uses `session.caches.global` when Redis is configured, with request-local memoization as a fallback.
- **Strict Role-Based Model**: Permissions are assigned to roles; roles are assigned to users.
- **ABAC Domain Service**: Store Odoo-style row-filter JSON on roles and retrieve expressions via `session.rbac.abac.getDomainFilters(permission)`.
- **Single & Bulk Operations**: Endpoints and service support both single (`insertRow`) and bulk (`insert`) operations for maximum performance.
- **Modern Serverpod ORM**: Fully typed bidirectional relations with eager inclusion.

## Authorization & ABAC Example

```dart
// Require permission
await session.rbac.requirePermission('article.edit');

// Retrieve Odoo-style row-filter expressions for the model.
final access = await session.rbac.abac.getDomainAccess(
  'article.read',
  resource: 'article',
);
if (!access.isAllowed) {
  throw RbacException(
    message: 'Permission denied: required "article.read"',
    reason: RbacExceptionReason.permissionDenied,
    requiredPermission: 'article.read',
  );
}
// If access.hasDomains is true, apply access.filterExpressions to your query
// using your application's filter library (for example serverpod_filters_server).
```
