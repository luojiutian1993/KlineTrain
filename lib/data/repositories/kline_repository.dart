import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:kline_trainer/data/api/kline_api.dart';
import 'package:kline_trainer/data/models/kline_model.dart';
import 'package:kline_trainer/data/database/database_service.dart';
import 'package:kline_trainer/data/database/app_database.dart';

part 'kline_repository.g.dart';

@riverpod
KlineRepository klineRepository(KlineRepositoryRef ref) {
  return KlineRepository();
}

class KlineRepository {
  final KlineApi _api = KlineApi();
  DatabaseService? _dbService;

  Future<DatabaseService> _getDbService() async {
    if (_dbService == null) {
      _dbService = DatabaseService.instance;
    }
    return _dbService!;
  }

  Future<List<KlineModel>> fetchKlineDataFromDb({
    String symbol = 'SH600000',
    String period = 'day',
    int limit = 100,
  }) async {
    try {
      final dbService = await _getDbService();
      final dbData = await dbService.klineDao.getKlineData(
        symbol,
        period,
        limit: limit,
      );

      if (dbData.isEmpty) {
        return [];
      }

      return dbData.map((item) => KlineModel(
        symbol: item.symbol,
        timestamp: item.tradeDate.millisecondsSinceEpoch,
        open: item.open,
        high: item.high,
        low: item.low,
        close: item.close,
        volume: item.volume,
        turnover: item.amount,
      )).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<KlineModel>> fetchKlineData({
    String symbol = 'SH600000',
    String timeframe = 'day',
    int limit = 100,
  }) async {
    try {
      final dbData = await fetchKlineDataFromDb(
        symbol: symbol,
        period: timeframe,
        limit: limit,
      );

      if (dbData.isNotEmpty) {
        return dbData;
      }

      final apiData = await _api.fetchKlineData(
        symbol: symbol,
        timeframe: timeframe,
        limit: limit,
      );

      if (apiData.isNotEmpty) {
        await _saveToDatabase(apiData, timeframe);
        return apiData;
      }

      return _generateMockData(symbol, limit);
    } catch (e) {
      return _generateMockData(symbol, limit);
    }
  }

  Future<void> _saveToDatabase(List<KlineModel> data, String period) async {
    try {
      final dbService = await _getDbService();
      final companions = data.map((item) {
        return KlineDataCompanion.insert(
          symbol: item.symbol,
          marketCode: '',
          period: period,
          tradeDate: DateTime.fromMillisecondsSinceEpoch(item.timestamp),
          open: item.open,
          high: item.high,
          low: item.low,
          close: item.close,
          volume: item.volume,
          amount: item.turnover,
        );
      }).toList();

      await dbService.klineDao.batchInsertKline(companions);
    } catch (e) {
    }
  }

  Future<List<KlineModel>> fetchRealtimeKline(String symbol) async {
    try {
      return await _api.fetchRealtimeKline(symbol);
    } catch (e) {
      return _generateMockData(symbol, 1);
    }
  }

  Future<bool> hasKlineDataInDb(String symbol, String period) async {
    try {
      final dbService = await _getDbService();
      final count = await dbService.klineDao.countKlineData(symbol, period);
      return count > 0;
    } catch (e) {
      return false;
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