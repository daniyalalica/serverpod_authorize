import 'dart:convert';
import 'package:serverpod/serverpod.dart';
import 'generated/protocol.dart';

/// Cache manager for RBAC permissions, roles, and domains using Serverpod's
/// standard global distributed cache (Redis) with request-scoped caching.
class RbacCache {
  /// Default TTL for cached authorization snapshots.
  static const Duration defaultLifetime = Duration(minutes: 5);

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
      if (gen != null) {
        requestCache[genKey] = gen;
      }
      return gen;
    } catch (_) {
      return null;
    }
  }

  Future<String> _buildUserKey(Session session, String userIdentifier) async {
    final encodedUser = base64Url.encode(utf8.encode(userIdentifier));
    final generation = await _readGeneration(session) ?? '0';
    return '$prefix:g:$generation:u:$encodedUser';
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
      final fromGlobal = await session.caches.global.get<RbacUserPermissionsInfo>(key);
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
    _getSessionCache(session).remove(key);

    try {
      await session.caches.global.invalidateKey(key);
    } catch (_) {
      // Safe fallback
    }
  }

  /// Invalidates all cached RBAC permissions globally across all instances.
  Future<void> invalidateAll(Session session) async {
    _getSessionCache(session).clear();
    const genKey = '$prefix:generation';
    final newGen = DateTime.now().microsecondsSinceEpoch.toString();

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
