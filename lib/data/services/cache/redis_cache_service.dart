import 'dart:convert';
import 'package:redis/redis.dart';
import '../cache/cache.dart';

class RedisCacheService implements CacheService {
  final CacheConfig _config;
  RedisConnection? _connection;
  Command? _command;
  bool _connected = false;

  RedisCacheService({CacheConfig? config})
      : _config = config ?? CacheConfig();

  Future<void> _connect() async {
    if (_connected && _command != null) return;

    try {
      _connection = RedisConnection();
      _command = await _connection!.connect(
        _config.host,
        _config.port,
      );

      if (_config.password != null && _config.password!.isNotEmpty) {
        await _command!.send_object(['AUTH', _config.password]);
      }

      if (_config.database != 0) {
        await _command!.send_object(['SELECT', _config.database]);
      }

      _connected = true;
    } catch (e) {
      _connected = false;
      _command = null;
    }
  }

  @override
  Future<void> set(String key, dynamic value, {Duration? ttl}) async {
    try {
      await _connect();
      if (_command == null) return;

      final encodedValue = _encodeValue(value);
      
      if (ttl != null && ttl.inSeconds > 0) {
        await _command!.send_object(['SET', key, encodedValue, 'EX', ttl.inSeconds]);
      } else {
        await _command!.send_object(['SET', key, encodedValue]);
      }
    } catch (e) {
      _connected = false;
    }
  }

  @override
  Future<T?> get<T>(String key) async {
    try {
      await _connect();
      if (_command == null) return null;

      final result = await _command!.send_object(['GET', key]);
      if (result == null) return null;

      return _decodeValue<T>(result.toString());
    } catch (e) {
      _connected = false;
      return null;
    }
  }

  @override
  Future<void> remove(String key) async {
    try {
      await _connect();
      if (_command == null) return;

      await _command!.send_object(['DEL', key]);
    } catch (e) {
      _connected = false;
    }
  }

  @override
  Future<void> clear() async {
    try {
      await _connect();
      if (_command == null) return;

      await _command!.send_object(['FLUSHDB']);
    } catch (e) {
      _connected = false;
    }
  }

  @override
  Future<bool> exists(String key) async {
    try {
      await _connect();
      if (_command == null) return false;

      final result = await _command!.send_object(['EXISTS', key]);
      return result == 1;
    } catch (e) {
      _connected = false;
      return false;
    }
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
    try {
      await _connect();
      if (_command == null) return;

      final keys = await _command!.send_object(['KEYS', '$namespace:*']);
      if (keys is List && keys.isNotEmpty) {
        await _command!.send_object(['DEL', ...keys]);
      }
    } catch (e) {
      _connected = false;
    }
  }

  String _encodeValue(dynamic value) {
    if (value is String) return value;
    if (value is num || value is bool) return value.toString();
    return json.encode(value);
  }

  T? _decodeValue<T>(String value) {
    if (T == String) return value as T;
    if (T == int) return int.tryParse(value) as T?;
    if (T == double) return double.tryParse(value) as T?;
    if (T == bool) return (value.toLowerCase() == 'true') as T;

    try {
      return json.decode(value) as T?;
    } catch (e) {
      return null;
    }
  }

  Future<void> close() async {
    try {
      if (_connection != null) {
        await _connection!.close();
      }
      _connected = false;
      _command = null;
    } catch (e) {
    }
  }
}