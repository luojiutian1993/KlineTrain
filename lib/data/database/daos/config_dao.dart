import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/tables.dart';

part 'config_dao.g.dart';

/// 配置相关数据访问对象
@DriftAccessor(
    tables: [SystemConfigs, VersionHistory, Markets, Symbols, KlineData])
class ConfigDao extends DatabaseAccessor<AppDatabase> with _$ConfigDaoMixin {
  ConfigDao(super.db);

  /// 获取配置值
  Future<String?> getConfig(String key) {
    return (select(systemConfigs)..where((t) => t.key.equals(key)))
        .map((row) => row.value)
        .getSingleOrNull();
  }

  /// 设置配置值
  Future<void> setConfig(String key, String value,
      {String? description, String? category}) {
    return into(systemConfigs).insertOnConflictUpdate(
      SystemConfigsCompanion(
        key: Value(key),
        value: Value(value),
        description: Value(description),
        category: Value(category ?? 'general'),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// 获取所有公开配置
  Future<List<SystemConfig>> getPublicConfigs() {
    return (select(systemConfigs)..where((t) => t.isPublic.equals(true))).get();
  }

  /// 获取分类配置
  Future<List<SystemConfig>> getConfigsByCategory(String category) {
    return (select(systemConfigs)..where((t) => t.category.equals(category)))
        .get();
  }

  /// 删除配置
  Future<int> deleteConfig(String key) {
    return (delete(systemConfigs)..where((t) => t.key.equals(key))).go();
  }

  /// 获取版本历史
  Future<List<VersionHistoryData>> getVersionHistory({int limit = 20}) {
    return (select(versionHistory)
          ..orderBy([(t) => OrderingTerm.desc(t.releaseDate)])
          ..limit(limit))
        .get();
  }

  /// 添加版本记录
  Future<int> addVersionHistory(VersionHistoryCompanion history) {
    return into(versionHistory).insert(history);
  }

  /// 获取最新版本
  Future<VersionHistoryData?> getLatestVersion() {
    return (select(versionHistory)
          ..orderBy([(t) => OrderingTerm.desc(t.releaseDate)])
          ..limit(1))
        .getSingleOrNull();
  }

  /// 初始化市场数据
  Future<void> initMarketData() async {
    final marketsData = [
      {
        'code': 'A股',
        'name': 'A股市场',
        'currency': 'CNY',
        'enabled': 1,
        'sortOrder': 1
      },
      {
        'code': '港股',
        'name': '港股市场',
        'currency': 'HKD',
        'enabled': 1,
        'sortOrder': 2
      },
      {
        'code': '美股',
        'name': '美股市场',
        'currency': 'USD',
        'enabled': 1,
        'sortOrder': 3
      },
      {
        'code': '期货',
        'name': '期货市场',
        'currency': 'CNY',
        'enabled': 1,
        'sortOrder': 4
      },
    ];

    await batch((batch) {
      for (final market in marketsData) {
        batch.customStatement(
          '''INSERT INTO markets (code, name, currency, enabled, sort_order)
             VALUES (?, ?, ?, ?, ?)
             ON CONFLICT(code) DO UPDATE SET
               name = excluded.name,
               currency = excluded.currency,
               enabled = excluded.enabled,
               sort_order = excluded.sort_order''',
          [
            market['code'],
            market['name'],
            market['currency'],
            market['enabled'],
            market['sortOrder']
          ],
        );
      }
    });
  }

  /// 初始化系统配置
  Future<void> initSystemConfigs() async {
    final configsList = [
      SystemConfigsCompanion(
        key: const Value('app.version'),
        value: const Value('1.0.0'),
        description: const Value('应用版本号'),
      ),
      SystemConfigsCompanion(
        key: const Value('data.refresh_interval'),
        value: const Value('30'),
        description: const Value('数据刷新间隔(秒)'),
      ),
      SystemConfigsCompanion(
        key: const Value('chart.default_period'),
        value: const Value('day'),
        description: const Value('默认K线周期'),
      ),
      SystemConfigsCompanion(
        key: const Value('training.initial_capital'),
        value: const Value('100000'),
        description: const Value('训练初始资金'),
      ),
      SystemConfigsCompanion(
        key: const Value('notification.enabled'),
        value: const Value('true'),
        description: const Value('是否启用通知'),
      ),
    ];

    await batch((batch) {
      batch.insertAllOnConflictUpdate(systemConfigs, configsList);
    });
  }

  /// 初始化示例股票数据（仅在数据库为空时执行）
  Future<void> initSampleStockData() async {
    final existingCount = await (selectOnly(symbols)
          ..addColumns([symbols.id.count()]))
        .getSingle();

    final count = existingCount.read(symbols.id.count()) ?? 0;

    if (count > 0) {
      return;
    }

    final sampleStocks = [
      {
        'symbol': '300750',
        'name': '宁德时代',
        'marketCode': 'SZ',
        'lastPrice': 185.50
      },
      {
        'symbol': '002594',
        'name': '比亚迪',
        'marketCode': 'SZ',
        'lastPrice': 265.30
      },
      {
        'symbol': '601318',
        'name': '中国平安',
        'marketCode': 'SH',
        'lastPrice': 45.80
      },
      {
        'symbol': '000001',
        'name': '平安银行',
        'marketCode': 'SZ',
        'lastPrice': 12.30
      },
      {
        'symbol': '600519',
        'name': '贵州茅台',
        'marketCode': 'SH',
        'lastPrice': 1650.00
      },
      {
        'symbol': '600036',
        'name': '招商银行',
        'marketCode': 'SH',
        'lastPrice': 32.50
      },
    ];

    await batch((batch) {
      for (final stock in sampleStocks) {
        batch.customStatement(
          '''INSERT INTO symbols (symbol, name, market_code, enabled, last_price, change)
             VALUES (?, ?, ?, 1, ?, 0)
             ON CONFLICT(symbol) DO UPDATE SET
               name = excluded.name,
               last_price = excluded.last_price''',
          [
            stock['symbol'],
            stock['name'],
            stock['marketCode'],
            stock['lastPrice']
          ],
        );
      }
    });
  }

  /// 初始化示例K线数据
  Future<void> initSampleKlineData() async {
    final symbols = await getActiveSymbols();
    if (symbols.isEmpty) return;

    final now = DateTime.now();
    final baseDate = DateTime(now.year - 5, now.month, now.day);
    final List<KlineDataCompanion> allKlineData = [];

    for (final symbol in symbols) {
      final klineDataList = _generateSampleKlineData(
          symbol.symbol, symbol.marketCode, baseDate, 1825); // 5年数据
      allKlineData.addAll(klineDataList);
    }

    if (allKlineData.isNotEmpty) {
      await batch((batch) {
        batch.insertAllOnConflictUpdate(klineData, allKlineData);
      });
    }
  }

  List<KlineDataCompanion> _generateSampleKlineData(
      String symbol, String marketCode, DateTime startDate, int days) {
    final result = <KlineDataCompanion>[];
    double basePrice = 100.0;
    final now = DateTime.now();

    for (int i = 0; i < days; i++) {
      final currentDate = startDate.add(Duration(days: i));
      if (currentDate.isAfter(now)) break;

      final randomFactor = 1 + (0.1 * (i % 30 - 15) / 100);
      final open = basePrice * randomFactor;
      final high = open * 1.03;
      final low = open * 0.97;
      final close = open * (1 + (DateTime.now().microsecond % 100 - 50) / 1000);
      final volume =
          (10000000 + (DateTime.now().microsecond % 5000000)).toDouble();
      final amount = close * volume;

      result.add(KlineDataCompanion(
        symbol: Value(symbol),
        marketCode: Value(marketCode),
        period: const Value('day'),
        tradeDate: Value(currentDate),
        open: Value(open),
        high: Value(high),
        low: Value(low),
        close: Value(close),
        volume: Value(volume),
        amount: Value(amount),
      ));

      basePrice = close;
    }

    return result;
  }

  Future<List<Symbol>> getActiveSymbols() {
    return (select(symbols)..where((t) => t.enabled.equals(true))).get();
  }
}
