import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:kline_trainer/data/api/kline_api.dart';
import 'package:kline_trainer/data/models/kline_model.dart';

part 'kline_repository.g.dart';

@riverpod
KlineRepository klineRepository(KlineRepositoryRef ref) {
  return KlineRepository();
}

class KlineRepository {
  final KlineApi _api = KlineApi();

  Future<List<KlineModel>> fetchKlineData({
    String symbol = 'SH600000',
    String timeframe = 'day',
    int limit = 100,
  }) async {
    try {
      return await _api.fetchKlineData(
        symbol: symbol,
        timeframe: timeframe,
        limit: limit,
      );
    } catch (e) {
      return _generateMockData(symbol, limit);
    }
  }

  Future<List<KlineModel>> fetchRealtimeKline(String symbol) async {
    try {
      return await _api.fetchRealtimeKline(symbol);
    } catch (e) {
      return _generateMockData(symbol, 1);
    }
  }

  List<KlineModel> _generateMockData(String symbol, int count) {
    final data = <KlineModel>[];
    final now = DateTime.now();
    double basePrice = 10.0;

    for (int i = count - 1; i >= 0; i--) {
      final timestamp = now.subtract(Duration(days: i)).millisecondsSinceEpoch;
      final open = basePrice + (i % 10 - 5) * 0.1;
      final close = open + (i % 7 - 3) * 0.15;
      final high = close > open ? close + 0.2 : open + 0.2;
      final low = close < open ? close - 0.2 : open - 0.2;

      data.add(
        KlineModel(
          symbol: symbol,
          timestamp: timestamp,
          open: double.parse(open.toStringAsFixed(2)),
          high: double.parse(high.toStringAsFixed(2)),
          low: double.parse(low.toStringAsFixed(2)),
          close: double.parse(close.toStringAsFixed(2)),
          volume: (100000 + i * 1000).toDouble(),
          turnover: (1000000 + i * 10000).toDouble(),
        ),
      );

      basePrice = close;
    }

    return data;
  }
}
