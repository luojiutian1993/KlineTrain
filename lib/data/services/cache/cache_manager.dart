import 'package:flutter/foundation.dart';
import '../cache/cache.dart';
import './redis_cache_service.dart';

class CacheManager {
  static final CacheManager _instance = CacheManager._internal();
  late CacheService _primaryCache;
  CacheService? _secondaryCache;
  bool _useSecondaryCache = false;

  factory CacheManager() => _instance;

  CacheManager._internal() {
    _primaryCache = MemoryCacheService();
  }

  void initialize({
    bool enableRedis = false,
    CacheConfig? redisConfig,
  }) {
    _useSecondaryCache = enableRedis;
    if (enableRedis) {
      _secondaryCache = RedisCacheService(config: redisConfig);
    }
  }

  Future<void> set(
    String key,
    dynamic value, {
    Duration? ttl,
    bool syncToSecondary = true,
  }) async {
    await _primaryCache.set(key, value, ttl: ttl);

    if (_useSecondaryCache && syncToSecondary && _secondaryCache != null) {
      try {
        await _secondaryCache!.set(key, value, ttl: ttl);
      } catch (e) {
        if (kDebugMode) {
          print('Failed to sync to secondary cache: $e');
        }
      }
    }
  }

  Future<T?> get<T>(String key) async {
    final primaryValue = await _primaryCache.get<T>(key);
    if (primaryValue != null) {
      return primaryValue;
    }

    if (_useSecondaryCache && _secondaryCache != null) {
      try {
        final secondaryValue = await _secondaryCache!.get<T>(key);
        if (secondaryValue != null) {
          await _primaryCache.set(key, secondaryValue);
          return secondaryValue;
        }
      } catch (e) {
        if (kDebugMode) {
          print('Failed to get from secondary cache: $e');
        }
      }
    }

    return null;
  }

  Future<void> remove(String key) async {
    await _primaryCache.remove(key);

    if (_useSecondaryCache && _secondaryCache != null) {
      try {
        await _secondaryCache!.remove(key);
      } catch (e) {
        if (kDebugMode) {
          print('Failed to remove from secondary cache: $e');
        }
      }
    }
  }

  Future<void> clear() async {
    await _primaryCache.clear();

    if (_useSecondaryCache && _secondaryCache != null) {
      try {
        await _secondaryCache!.clear();
      } catch (e) {
        if (kDebugMode) {
          print('Failed to clear secondary cache: $e');
        }
      }
    }
  }

  Future<bool> exists(String key) async {
    final existsInPrimary = await _primaryCache.exists(key);
    if (existsInPrimary) return true;

    if (_useSecondaryCache && _secondaryCache != null) {
      try {
        return await _secondaryCache!.exists(key);
      } catch (e) {
        if (kDebugMode) {
          print('Failed to check existence in secondary cache: $e');
        }
      }
    }

    return false;
  }

  Future<void> setWithNamespace(
    String namespace,
    String key,
    dynamic value, {
    Duration? ttl,
    bool syncToSecondary = true,
  }) async {
    await _primaryCache.setWithNamespace(namespace, key, value, ttl: ttl);

    if (_useSecondaryCache && syncToSecondary && _secondaryCache != null) {
      try {
        await _secondaryCache!.setWithNamespace(namespace, key, value, ttl: ttl);
      } catch (e) {
        if (kDebugMode) {
          print('Failed to sync to secondary cache: $e');
        }
      }
    }
  }

  Future<T?> getWithNamespace<T>(String namespace, String key) async {
    final primaryValue = await _primaryCache.getWithNamespace<T>(namespace, key);
    if (primaryValue != null) {
      return primaryValue;
    }

    if (_useSecondaryCache && _secondaryCache != null) {
      try {
        final secondaryValue = await _secondaryCache!.getWithNamespace<T>(namespace, key);
        if (secondaryValue != null) {
          await _primaryCache.setWithNamespace(namespace, key, secondaryValue);
          return secondaryValue;
        }
      } catch (e) {
        if (kDebugMode) {
          print('Failed to get from secondary cache: $e');
        }
      }
    }

    return null;
  }

  Future<void> removeWithNamespace(String namespace, String key) async {
    await _primaryCache.removeWithNamespace(namespace, key);

    if (_useSecondaryCache && _secondaryCache != null) {
      try {
        await _secondaryCache!.removeWithNamespace(namespace, key);
      } catch (e) {
        if (kDebugMode) {
          print('Failed to remove from secondary cache: $e');
        }
      }
    }
  }

  Future<void> clearNamespace(String namespace) async {
    await _primaryCache.clearNamespace(namespace);

    if (_useSecondaryCache && _secondaryCache != null) {
      try {
        await _secondaryCache!.clearNamespace(namespace);
      } catch (e) {
        if (kDebugMode) {
          print('Failed to clear namespace from secondary cache: $e');
        }
      }
    }
  }

  CacheService get primaryCache => _primaryCache;
  CacheService? get secondaryCache => _secondaryCache;
  bool get useSecondaryCache => _useSecondaryCache;
}

class CacheNamespaces {
  static const String kline = 'kline';
  static const String user = 'user';
  static const String market = 'market';
  static const String filter = 'filter';
  static const String session = 'session';
  static const String config = 'config';
}

class CacheTtl {
  static const Duration short = Duration(minutes: 5);
  static const Duration medium = Duration(minutes: 30);
  static const Duration long = Duration(hours: 2);
  static const Duration veryLong = Duration(hours: 24);
  static const Duration permanent = Duration(days: 30);
}