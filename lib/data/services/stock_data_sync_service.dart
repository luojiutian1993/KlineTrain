import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import '../database/app_database.dart';

class StockDataSyncService {
  final AppDatabase _appDb;

  StockDataSyncService(this._appDb);

  Future<bool> syncFromExternalDatabase() async {
    try {
      final possiblePaths = [
        p.join(Directory.current.path, 'lib', 'data', 'database',
            'kline_trainer.db'),
        p.join(Directory.current.parent.path, 'lib', 'data', 'database',
            'kline_trainer.db'),
        p.join(Directory.current.path, 'assets', 'data', 'stock_data',
            'stock_data.db'),
        p.join(
            Directory.current.path, 'lib', 'data', 'database', 'stock_data.db'),
        p.join(Directory.current.parent.path, 'assets', 'data', 'stock_data',
            'stock_data.db'),
      ];

      String? externalDbPath;
      for (final path in possiblePaths) {
        final testFile = File(path);
        if (testFile.existsSync()) {
          externalDbPath = path;
          print('找到外部数据库: $externalDbPath');
          break;
        }
      }

      if (externalDbPath == null) {
        print('外部数据库文件不存在，搜索路径: $possiblePaths');
        return false;
      }

      final externalFile = File(externalDbPath);
      final externalDb = NativeDatabase(externalFile);

      final stockList = await _fetchStockList(externalDb);
      if (stockList.isEmpty) {
        print('外部数据库中没有股票数据');
        await externalDb.close();
        return false;
      }

      print('开始同步 ${stockList.length} 支股票数据...');

      int syncedCount = 0;
      for (final stock in stockList) {
        await _syncSingleStock(externalDb, stock);
        syncedCount++;
        if (syncedCount % 100 == 0) {
          print('已同步 $syncedCount/${stockList.length} 支股票');
        }
      }

      await externalDb.close();

      print('股票数据同步完成！共同步 $syncedCount 支股票');
      return true;
    } catch (e) {
      print('数据同步失败: $e');
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> _fetchStockList(dynamic db) async {
    final results = await db.select('stock_list').get();
    return results.map((row) => Map<String, dynamic>.from(row.data)).toList();
  }

  Future<Map<String, dynamic>?> _fetchKlineData(
      dynamic db, String symbol) async {
    try {
      final results = await db.customSelect(
        'SELECT * FROM kline_data WHERE symbol = ? ORDER BY date DESC LIMIT 1',
        variables: [Variable.withString(symbol)],
      ).get();

      if (results.isEmpty) return null;
      return Map<String, dynamic>.from(results.first.data);
    } catch (e) {
      return null;
    }
  }

  Future<void> _syncSingleStock(
      dynamic externalDb, Map<String, dynamic> stockData) async {
    final symbol = stockData['symbol'] as String;
    final name = stockData['name'] as String;
    final market = stockData['market'] as String? ?? 'US';

    final marketCode = _mapMarketCode(market);

    final latestKline = await _fetchKlineData(externalDb, symbol);
    double? lastPrice;
    double? change;

    if (latestKline != null) {
      lastPrice = (latestKline['close'] as num?)?.toDouble();
      change = (latestKline['pct_change'] as num?)?.toDouble();
    }

    await _appDb.batch((batch) {
      batch.customStatement(
        '''INSERT OR REPLACE INTO symbols (symbol, name, market_code, enabled, last_price, change, created_at, updated_at)
           VALUES (?, ?, ?, 1, ?, ?, datetime('now'), datetime('now'))''',
        [symbol, name, marketCode, lastPrice ?? 0.0, change ?? 0.0],
      );
    });
  }

  String _mapMarketCode(String? market) {
    if (market == null) return 'US';

    final upperMarket = market.toUpperCase();

    if (upperMarket.contains('SH') || upperMarket.contains('SHANGHAI')) {
      return 'SH';
    } else if (upperMarket.contains('SZ') || upperMarket.contains('SHENZHEN')) {
      return 'SZ';
    } else if (upperMarket.contains('HK') ||
        upperMarket.contains('HONG KONG')) {
      return 'HK';
    } else if (upperMarket.contains('US') || upperMarket.contains('AMERICA')) {
      return 'US';
    }

    return market.length <= 2 ? market.toUpperCase() : 'US';
  }

  Future<int> getStockCount() async {
    final result = await _appDb
        .customSelect(
          'SELECT COUNT(*) as count FROM symbols WHERE enabled = 1',
        )
        .getSingle();

    return (result.data['count'] as int?) ?? 0;
  }
}
