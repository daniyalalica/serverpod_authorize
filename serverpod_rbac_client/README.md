# `serverpod_rbac_client`

Generated Serverpod client protocol package for `serverpod_rbac_server`.
It contains serialized RBAC and ABAC models and endpoint connectors (`rbac`, `rbacAdmin`) used by Serverpod clients.

The server package exposes the authorization APIs (`session.rbac`), ABAC domain services, and endpoints. Permission decisions must be enforced on the server. Client-side checks may be used for presentation only.

Regenerate this package together with the server protocol after changing Serverpod models or endpoint signatures (`serverpod generate`). Do not edit generated protocol files by hand.
