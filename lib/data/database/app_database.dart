import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'tables/tables.dart';
import 'daos/daos.dart';

part 'app_database.g.dart';

/// 主数据库入口
@DriftDatabase(
  tables: [
    // 用户相关表
    Users,
    UserProfiles,
    UserPreferences,

    // 基础配置表
    Markets,
    Symbols,

    // K线数据表
    KlineData,

    // 选股相关表
    StockFilterResults,
    DailyStockStats,

    // 训练会话表
    TrainingSessions,
    Trades,
    Positions,
    ConditionalOrders,
    OperationLogs,

    // 分析扩展表
    TrainingReports,
    UserHabits,
    TradingPatterns,
    StrategyTips,

    // 系统配置表
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
  /// 初始化数据库
  AppDatabase() : super(_openConnection());

  /// schema版本 - 升级到2以添加选股相关表
  @override
  int get schemaVersion => 2;

  /// 数据库迁移
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
        },
      );
}

/// 打开数据库连接
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'kline_trainer.db'));

    return NativeDatabase(
      file,
      logStatements: false,
      setup: (db) {
        // 启用WAL模式以提升并发性能
        db.execute('PRAGMA journal_mode = WAL');
        // 设置缓存大小
        db.execute('PRAGMA cache_size = -2000');
        // 同步模式设为NORMAL，平衡速度与安全性
        db.execute('PRAGMA synchronous = NORMAL');
      },
    );
  });
}
