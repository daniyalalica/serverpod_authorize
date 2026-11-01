import 'dart:convert';
import 'package:serverpod/serverpod.dart';
import 'generated/protocol.dart';

/// Cache manager for RBAC permissions, roles, and domains using Serverpod's
/// standard global distributed cache (Redis) with request-scoped caching.
class RbacCache {
  /// Default TTL for cached authorization snapshots.
  static const Duration defaultLifetime = Duration(minutes: 5);

  /// Domain decisions are short-lived and invalidated when authorization data changes.
  static const Duration domainAccessLifetime = Duration(minutes: 1);

  /// Key prefix for RBAC cache entries.
  static const String prefix = 'serverpod_rbac';

  /// Request-scoped cache using [Expando] for zero-roundtrip repeated checks within a session.
  static final Expando<Map<String, Object?>> _sessionCaches =
      Expando<Map<String, Object?>>();

  Map<String, Object?> _getSessionCache(Session session) {
    return _sessionCaches[session] ??= <String, Object?>{};
  }

  Future<String?> _readGeneration(Session session) async {
    const genKey = '$prefix:generation';
    final requestCache = _getSessionCache(session);
    final cachedGen = requestCache[genKey];
    if (cachedGen is String) return cachedGen;

    try {
      final gen = await session.caches.global.get<String>(genKey);
      requestCache[genKey] = gen ?? '0';
      return gen;
    } catch (_) {
      requestCache[genKey] = '0';
      return null;
    }
  }

  Future<String> _buildUserKey(Session session, String userIdentifier) async {
    final encodedUser = base64Url.encode(utf8.encode(userIdentifier));
    final generation = await _readGeneration(session) ?? '0';
    return '$prefix:g:$generation:u:$encodedUser';
  }

  Future<String?> _readUserGeneration(
    Session session,
    String userIdentifier,
  ) async {
    final encodedUser = base64Url.encode(utf8.encode(userIdentifier));
    final generationKey = '$prefix:user_generation:$encodedUser';
    final requestCache = _getSessionCache(session);
    final cachedGeneration = requestCache[generationKey];
    if (cachedGeneration is String) return cachedGeneration;

    try {
      final generation = await session.caches.global.get<String>(
        generationKey,
      );
      requestCache[generationKey] = generation ?? '0';
      return generation;
    } catch (_) {
      requestCache[generationKey] = '0';
      return null;
    }
  }

  Future<String> _buildDomainAccessKey(
    Session session, {
    required String userIdentifier,
    required String resource,
    required String permission,
  }) async {
    final encodedUser = base64Url.encode(utf8.encode(userIdentifier));
    final encodedResource = base64Url.encode(utf8.encode(resource));
    final encodedPermission = base64Url.encode(utf8.encode(permission));
    final generation = await _readGeneration(session) ?? '0';
    final userGeneration =
        await _readUserGeneration(session, userIdentifier) ?? '0';

    return '$prefix:domain:g:$generation:u:$encodedUser:ug:$userGeneration'
        ':r:$encodedResource:p:$encodedPermission';
  }

  RbacAbacResult _copyDomainAccess(RbacAbacResult result) {
    return result.copyWith(
      filterExpressions: List<String>.of(result.filterExpressions),
    );
  }

  /// Returns a cached permission-scoped domain decision, if available.
  Future<RbacAbacResult?> getDomainAccess(
    Session session, {
    required String userIdentifier,
    required String resource,
    required String permission,
  }) async {
    final key = await _buildDomainAccessKey(
      session,
      userIdentifier: userIdentifier,
      resource: resource,
      permission: permission,
    );
    final requestCache = _getSessionCache(session);
    final cached = requestCache[key];
    if (cached is RbacAbacResult) return _copyDomainAccess(cached);

    try {
      final fromGlobal = await session.caches.global.get<RbacAbacResult>(key);
      if (fromGlobal != null) {
        requestCache[key] = _copyDomainAccess(fromGlobal);
        return _copyDomainAccess(fromGlobal);
      }
    } catch (_) {
      // Cache failures fall back to resolving the decision from the database.
    }
    return null;
  }

  /// Caches a permission-scoped domain decision for subsequent requests.
  Future<void> putDomainAccess(
    Session session, {
    required String userIdentifier,
    required String resource,
    required String permission,
    required RbacAbacResult result,
    Duration lifetime = domainAccessLifetime,
  }) async {
    final key = await _buildDomainAccessKey(
      session,
      userIdentifier: userIdentifier,
      resource: resource,
      permission: permission,
    );
    final snapshot = _copyDomainAccess(result);
    _getSessionCache(session)[key] = snapshot;

    try {
      await session.caches.global.put(key, snapshot, lifetime: lifetime);
    } catch (_) {
      // Cache failures must not prevent authorization from being resolved.
    }
  }

  /// Gets cached permissions for a user, if available.
  Future<RbacUserPermissionsInfo?> getUserPermissionsInfo(
    Session session,
    String userIdentifier,
  ) async {
    final key = await _buildUserKey(session, userIdentifier);
    final requestCache = _getSessionCache(session);
    final cached = requestCache[key];
    if (cached is RbacUserPermissionsInfo) return cached;

    try {
      final fromGlobal = await session.caches.global
          .get<RbacUserPermissionsInfo>(key);
      if (fromGlobal != null) {
        requestCache[key] = fromGlobal;
        return fromGlobal;
      }
    } catch (_) {
      // Safe fallback on cache read failure
    }
    return null;
  }

  /// Caches permissions for a user.
  Future<void> putUserPermissionsInfo(
    Session session,
    String userIdentifier,
    RbacUserPermissionsInfo info, {
    Duration lifetime = defaultLifetime,
  }) async {
    final key = await _buildUserKey(session, userIdentifier);
    _getSessionCache(session)[key] = info;

    try {
      await session.caches.global.put(key, info, lifetime: lifetime);
    } catch (_) {
      // Safe fallback on cache write failure
    }
  }

  /// Invalidates cached permissions for a specific user.
  Future<void> invalidateUser(Session session, String userIdentifier) async {
    final key = await _buildUserKey(session, userIdentifier);
    final encodedUser = base64Url.encode(utf8.encode(userIdentifier));
    final userGenerationKey = '$prefix:user_generation:$encodedUser';
    final requestCache = _getSessionCache(session)
      ..remove(key)
      ..remove(userGenerationKey);
    requestCache.removeWhere(
      (cacheKey, _) =>
          cacheKey.startsWith('$prefix:domain:') &&
          cacheKey.contains(':u:$encodedUser:'),
    );
    final newGeneration = DateTime.now().microsecondsSinceEpoch.toString();
    requestCache[userGenerationKey] = newGeneration;

    try {
      await session.caches.global.invalidateKey(key);
      await session.caches.global.put(
        userGenerationKey,
        newGeneration,
        lifetime: const Duration(days: 1),
      );
    } catch (_) {
      // Safe fallback
    }
  }

  /// Invalidates all cached RBAC permissions globally across all instances.
  Future<void> invalidateAll(Session session) async {
    final requestCache = _getSessionCache(session)..clear();
    const genKey = '$prefix:generation';
    final newGen = DateTime.now().microsecondsSinceEpoch.toString();
    requestCache[genKey] = newGen;

    try {
      await session.caches.global.put(
        genKey,
        newGen,
        lifetime: const Duration(days: 365),
      );
    } catch (_) {
      // Safe fallback
    }
  }
}
