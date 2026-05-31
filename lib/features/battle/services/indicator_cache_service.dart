import 'dart:collection';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kline_trainer/data/models/kline_model.dart';

final indicatorCacheServiceProvider =
    Provider<IndicatorCacheService>((ref) => IndicatorCacheService());

class IndicatorCache {
  final String cacheKey;
  final int dataLength;
  final DateTime startDate;
  final DateTime endDate;
  final List<KlineModel> klineData;
  final Map<String, dynamic> indicators;
  final DateTime createdAt;
  DateTime lastAccessedAt;

  IndicatorCache({
    required this.cacheKey,
    required this.dataLength,
    required this.startDate,
    required this.endDate,
    required this.klineData,
    required this.indicators,
    required this.createdAt,
  }) : lastAccessedAt = createdAt;

  void touch() {
    lastAccessedAt = DateTime.now();
  }
}

class IndicatorCacheService {
  static const int maxCacheSize = 50;
  final Map<String, IndicatorCache> _cache = LinkedHashMap();

  void put(IndicatorCache cache) {
    _cache.remove(cache.cacheKey);
    _cache[cache.cacheKey] = cache;
    _evictIfNeeded();
  }

  IndicatorCache? get(String cacheKey) {
    final cached = _cache[cacheKey];
    if (cached != null) {
      cached.touch();
      _cache.remove(cacheKey);
      _cache[cacheKey] = cached;
    }
    return cached;
  }

  IndicatorCache? findMatch(String symbol, int visibleKlineCount) {
    final key = _generateCacheKey(symbol, visibleKlineCount);
    return get(key);
  }

  void clearBySymbol(String symbol) {
    _cache.removeWhere((key, _) => key.startsWith(symbol));
  }

  void clearAll() {
    _cache.clear();
  }

  Map<String, dynamic> getStats() {
    return {
      'currentSize': _cache.length,
      'maxSize': maxCacheSize,
      'symbols': _cache.keys.map((k) => k.split('_').first).toSet().toList(),
    };
  }

  String _generateCacheKey(String symbol, int visibleKlineCount) {
    return '${symbol}_$visibleKlineCount';
  }

  void _evictIfNeeded() {
    while (_cache.length > maxCacheSize) {
      final oldestKey = _cache.keys.first;
      _cache.remove(oldestKey);
    }
  }
}
