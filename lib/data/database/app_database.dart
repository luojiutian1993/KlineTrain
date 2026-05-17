import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'tables/tables.dart';
import 'daos/daos.dart';

part 'app_database.g.dart';

/// 主数据库入口
@DriftDatabase(
  tables: [
    Users,
    UserProfiles,
    UserPreferences,
    Markets,
    Symbols,
    KlineData,
    StockFilterResults,
    DailyStockStats,
    TrainingSessions,
    Trades,
    Positions,
    ConditionalOrders,
    OperationLogs,
    TrainingReports,
    UserHabits,
    TradingPatterns,
    StrategyTips,
    SystemConfigs,
    VersionHistory,
  ],
  daos: [
    UserDao,
    KlineDao,
    MarketDao,
    TrainingDao,
    TradeDao,
    AnalysisDao,
    ConfigDao,
    StockFilterDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) {
          return m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          if (from < 2) {
            await m.createTable(stockFilterResults);
            await m.createTable(dailyStockStats);
          }
          if (from < 3) {
            await _migrateImportData(m);
          }
        },
      );

  Future<void> _migrateImportData(Migrator m) async {
    await customStatement('''
      INSERT OR IGNORE INTO markets (code, name, currency, enabled, sort_order, created_at, updated_at)
      VALUES ('XSHG', '上海证券交易所', 'CNY', 1, 1, datetime('now'), datetime('now'))
    ''');
    await customStatement('''
      INSERT OR IGNORE INTO markets (code, name, currency, enabled, sort_order, created_at, updated_at)
      VALUES ('XSHE', '深圳证券交易所', 'CNY', 1, 2, datetime('now'), datetime('now'))
    ''');
    await customStatement('''
      UPDATE symbols SET market_code = 'A股' 
      WHERE market_code IS NULL OR market_code = ''
    ''');
    await customStatement('''
      INSERT OR IGNORE INTO markets (code, name, currency, enabled, sort_order, created_at, updated_at)
      VALUES ('A股', 'A股市场', 'CNY', 1, 1, datetime('now'), datetime('now'))
    ''');
  }
}

/// 打开数据库连接
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    if (kDebugMode) {
      final externalDbPath = p.join(
        p.dirname(p.current),
        'lib',
        'data',
        'database',
        'kline_trainer.db',
      );

      if (File(externalDbPath).existsSync()) {
        final file = File(externalDbPath);
        return NativeDatabase(
          file,
          setup: (db) {
            db.execute('PRAGMA journal_mode = WAL');
            db.execute('PRAGMA cache_size = -2000');
            db.execute('PRAGMA synchronous = NORMAL');
          },
        );
      }
    }

    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'kline_trainer.db'));
    return NativeDatabase(
      file,
      setup: (db) {
        db.execute('PRAGMA journal_mode = WAL');
        db.execute('PRAGMA cache_size = -2000');
        db.execute('PRAGMA synchronous = NORMAL');
      },
    );
  });
}
