import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
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
    final dbFolder = await getApplicationDocumentsDirectory();
    final dbPath = p.join(dbFolder.path, 'stock_data.db');
    final file = File(dbPath);

    print('📦 数据库路径: $dbPath');
    print('📦 数据库是否存在: ${file.existsSync()}');

    if (!file.existsSync()) {
      print('数据库文件不存在，从本地路径复制...');

      // 优先使用本地stock_data.db（包含完整的K线数据）
      final possiblePaths = [
        p.join(
            Directory.current.path, 'lib', 'data', 'database', 'stock_data.db'),
        p.join(Directory.current.path, 'lib', 'data', 'database',
            'kline_trainer.db'),
      ];

      bool copied = false;
      for (final path in possiblePaths) {
        final sourceFile = File(path);
        if (sourceFile.existsSync() && sourceFile.lengthSync() > 1000000) {
          print('✅ 从本地路径复制: $path (${sourceFile.lengthSync()} bytes)');
          await sourceFile.copy(file.path);
          copied = true;
          break;
        }
      }

      if (!copied) {
        print('⚠️ 本地数据库无效，尝试从assets复制...');
        try {
          final ByteData data =
              await rootBundle.load('assets/data/stock_data/stock_data.db');
          final List<int> bytes =
              data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
          await file.writeAsBytes(bytes);
          print('✅ 从assets复制成功');
        } catch (e) {
          print('❌ 从assets复制失败: $e');
        }
      }
    } else {
      print('✅ 数据库文件已存在，直接使用');
    }

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
