import 'dart:collection';
import 'dart:convert';

abstract class CacheService {
  Future<void> set(String key, dynamic value, {Duration? ttl});
  Future<T?> get<T>(String key);
  Future<void> remove(String key);
  Future<void> clear();
  Future<bool> exists(String key);
  Future<void> setWithNamespace(String namespace, String key, dynamic value, {Duration? ttl});
  Future<T?> getWithNamespace<T>(String namespace, String key);
  Future<void> removeWithNamespace(String namespace, String key);
  Future<void> clearNamespace(String namespace);
}

class MemoryCacheService implements CacheService {
  final Map<String, _CacheEntry> _cache = HashMap();
  final Duration _defaultTtl = const Duration(minutes: 30);

  @override
  Future<void> set(String key, dynamic value, {Duration? ttl}) async {
    _cache[key] = _CacheEntry(
      value: value,
      expiresAt: DateTime.now().add(ttl ?? _defaultTtl),
    );
    _cleanupExpired();
  }

  @override
  Future<T?> get<T>(String key) async {
    _cleanupExpired();
    final entry = _cache[key];
    if (entry == null || entry.isExpired) {
      _cache.remove(key);
      return null;
    }
    return entry.value as T?;
  }

  @override
  Future<void> remove(String key) async {
    _cache.remove(key);
  }

  @override
  Future<void> clear() async {
    _cache.clear();
  }

  @override
  Future<bool> exists(String key) async {
    _cleanupExpired();
    return _cache.containsKey(key) && !_cache[key]!.isExpired;
  }

  @override
  Future<void> setWithNamespace(String namespace, String key, dynamic value, {Duration? ttl}) async {
    final fullKey = '$namespace:$key';
    await set(fullKey, value, ttl: ttl);
  }

  @override
  Future<T?> getWithNamespace<T>(String namespace, String key) async {
    final fullKey = '$namespace:$key';
    return await get<T>(fullKey);
  }

  @override
  Future<void> removeWithNamespace(String namespace, String key) async {
    final fullKey = '$namespace:$key';
    await remove(fullKey);
  }

  @override
  Future<void> clearNamespace(String namespace) async {
    _cache.removeWhere((key, _) => key.startsWith('$namespace:'));
  }

  void _cleanupExpired() {
    final now = DateTime.now();
    _cache.removeWhere((_, entry) => entry.isExpiredAt(now));
  }
}

class _CacheEntry {
  final dynamic value;
  final DateTime expiresAt;

  _CacheEntry({
    required this.value,
    required this.expiresAt,
  });

  bool get isExpired => isExpiredAt(DateTime.now());

  bool isExpiredAt(DateTime now) => now.isAfter(expiresAt);
}

enum CacheType {
  memory,
  redis,
  hive,
}

class CacheConfig {
  final String host;
  final int port;
  final String? password;
  final int database;
  final Duration connectionTimeout;
  final Duration defaultTtl;
  final int maxMemorySize;

  CacheConfig({
    this.host = 'localhost',
    this.port = 6379,
    this.password,
    this.database = 0,
    this.connectionTimeout = const Duration(seconds: 5),
    this.defaultTtl = const Duration(minutes: 30),
    this.maxMemorySize = 1000,
  });
}