import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/tables.dart';

part 'config_dao.g.dart';

/// 配置相关数据访问对象
@DriftAccessor(tables: [SystemConfigs, VersionHistory, Markets, Symbols])
class ConfigDao extends DatabaseAccessor<AppDatabase> with _$ConfigDaoMixin {
  ConfigDao(super.db);

  /// 获取配置值
  Future<String?> getConfig(String key) {
    return (select(systemConfigs)..where((t) => t.key.equals(key)))
        .map((row) => row.value)
        .getSingleOrNull();
  }

  /// 设置配置值
  Future<void> setConfig(String key, String value, {String? description, String? category}) {
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
    return (select(systemConfigs)..where((t) => t.category.equals(category))).get();
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
    final marketsList = [
      MarketsCompanion(
        code: const Value('A股'),
        name: const Value('A股市场'),
        currency: const Value('CNY'),
        enabled: const Value(true),
        sortOrder: const Value(1),
      ),
      MarketsCompanion(
        code: const Value('港股'),
        name: const Value('港股市场'),
        currency: const Value('HKD'),
        enabled: const Value(true),
        sortOrder: const Value(2),
      ),
      MarketsCompanion(
        code: const Value('美股'),
        name: const Value('美股市场'),
        currency: const Value('USD'),
        enabled: const Value(true),
        sortOrder: const Value(3),
      ),
      MarketsCompanion(
        code: const Value('期货'),
        name: const Value('期货市场'),
        currency: const Value('CNY'),
        enabled: const Value(true),
        sortOrder: const Value(4),
      ),
    ];

    await batch((batch) {
      batch.insertAllOnConflictUpdate(markets, marketsList);
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
}
