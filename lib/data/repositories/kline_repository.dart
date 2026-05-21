import 'dart:math';

import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:kline_trainer/data/api/kline_api.dart';
import 'package:kline_trainer/data/models/kline_model.dart';
import 'package:kline_trainer/data/database/database_service.dart';
import 'package:kline_trainer/data/database/app_database.dart';
import 'package:kline_trainer/data/utils/indicator_calculator.dart';

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

      return dbData
          .map((item) => KlineModel(
                symbol: item.symbol,
                timestamp: item.tradeDate.millisecondsSinceEpoch,
                open: item.open,
                high: item.high,
                low: item.low,
                close: item.close,
                volume: item.volume,
                turnover: item.amount,
              ))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<KlineModel>> fetchKlineDataFromDbWithDateRange({
    required String symbol,
    required String period,
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    try {
      final dbService = await _getDbService();
      final dbData = await dbService.klineDao.getKlineDataRange(
        symbol,
        period,
        startTime,
        endTime,
      );

      if (dbData.isEmpty) {
        return [];
      }

      return dbData
          .map((item) => KlineModel(
                symbol: item.symbol,
                timestamp: item.tradeDate.millisecondsSinceEpoch,
                open: item.open,
                high: item.high,
                low: item.low,
                close: item.close,
                volume: item.volume,
                turnover: item.amount,
              ))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<KlineModel>> _aggregateFromDailyData(
      String symbol, String targetPeriod) async {
    try {
      final dbService = await _getDbService();
      List<KlineDataData> aggregatedData;

      switch (targetPeriod) {
        case 'week':
          aggregatedData =
              await dbService.klineDao.aggregateWeeklyKline(symbol);
          break;
        case 'month':
          aggregatedData =
              await dbService.klineDao.aggregateMonthlyKline(symbol);
          break;
        case 'quarter':
          aggregatedData =
              await dbService.klineDao.aggregateQuarterlyKline(symbol);
          break;
        case 'year':
          aggregatedData =
              await dbService.klineDao.aggregateYearlyKline(symbol);
          break;
        default:
          return [];
      }

      if (aggregatedData.isEmpty) {
        return [];
      }

      final result = aggregatedData
          .map((item) => KlineModel(
                symbol: item.symbol,
                timestamp: item.tradeDate.millisecondsSinceEpoch,
                open: item.open,
                high: item.high,
                low: item.low,
                close: item.close,
                volume: item.volume,
                turnover: item.amount,
              ))
          .toList();

      await _saveToDatabase(result, targetPeriod);
      return result;
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
        // 验证数据质量
        if (_validateKlineData(dbData)) {
          return dbData.take(limit).toList();
        } else {
          // 数据异常，使用模拟数据
          return _generateMockData(symbol, limit);
        }
      }

      if (timeframe != 'day') {
        final aggregatedData = await _aggregateFromDailyData(symbol, timeframe);
        if (aggregatedData.isNotEmpty) {
          if (_validateKlineData(aggregatedData)) {
            return aggregatedData.take(limit).toList();
          } else {
            return _generateMockData(symbol, limit);
          }
        }
      }

      final apiData = await _api.fetchKlineData(
        symbol: symbol,
        timeframe: timeframe,
        limit: limit,
      );

      if (apiData.isNotEmpty) {
        if (_validateKlineData(apiData)) {
          await _saveToDatabase(apiData, timeframe);
          return apiData;
        } else {
          return _generateMockData(symbol, limit);
        }
      }

      return _generateMockData(symbol, limit);
    } catch (e) {
      return _generateMockData(symbol, limit);
    }
  }

  MACDResult calculateMACD(List<KlineModel> data) {
    return IndicatorCalculator.calculateMACD(data);
  }

  BollResult calculateBoll(List<KlineModel> data) {
    return IndicatorCalculator.calculateBoll(data);
  }

  KDJResult calculateKDJ(List<KlineModel> data) {
    return IndicatorCalculator.calculateKDJ(data);
  }

  RSIResult calculateRSI(List<KlineModel> data) {
    return IndicatorCalculator.calculateRSI(data);
  }

  WRResult calculateWR(List<KlineModel> data) {
    return IndicatorCalculator.calculateWR(data);
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
    } catch (e) {}
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
    final random = Random(12345); // 固定种子确保可重现
    double basePrice = 10.0;

    for (int i = count - 1; i >= 0; i--) {
      final timestamp = now.subtract(Duration(days: i)).millisecondsSinceEpoch;
      final open = basePrice + (i % 10 - 5) * 0.1;
      final close = open + (i % 7 - 3) * 0.15;
      final high = close > open ? close + 0.2 : open + 0.2;
      final low = close < open ? close - 0.2 : open - 0.2;

      // 生成有真实波动的成交量
      // 基准成交量: 1000万手
      // 周期性变化 + 随机波动
      final baseVolume = 10000000.0;
      final periodicVariation = sin(i / 10) * 3000000.0; // 周期性波动
      final randomVariation = (random.nextDouble() - 0.5) * 4000000.0; // 随机波动
      final volume = (baseVolume + periodicVariation + randomVariation).clamp(
        3000000.0, // 最小值 300万
        30000000.0, // 最大值 3000万
      );

      data.add(
        KlineModel(
          symbol: symbol,
          timestamp: timestamp,
          open: double.parse(open.toStringAsFixed(2)),
          high: double.parse(high.toStringAsFixed(2)),
          low: double.parse(low.toStringAsFixed(2)),
          close: double.parse(close.toStringAsFixed(2)),
          volume: volume,
          turnover: volume * close, // 成交额 = 成交量 * 收盘价
        ),
      );

      basePrice = close;
    }

    return data;
  }

  bool _validateKlineData(List<KlineModel> data) {
    if (data.isEmpty) return false;

    final volumes = data.map((d) => d.volume).toList();
    final minVolume = volumes.reduce((a, b) => a < b ? a : b);
    final maxVolume = volumes.reduce((a, b) => a > b ? a : b);

    // 如果最大最小成交量相差不到10%，认为数据异常
    if (maxVolume / minVolume < 1.1) {
      return false;
    }

    return true;
  }
}
