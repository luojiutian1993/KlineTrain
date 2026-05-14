import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/tables.dart';

part 'analysis_dao.g.dart';

/// 分析相关数据访问对象
@DriftAccessor(tables: [
  TrainingReports,
  UserHabits,
  TradingPatterns,
  StrategyTips,
])
class AnalysisDao extends DatabaseAccessor<AppDatabase> with _$AnalysisDaoMixin {
  AnalysisDao(super.db);

  /// 创建训练报告
  Future<int> createReport(TrainingReportsCompanion report) {
    return into(trainingReports).insert(report);
  }

  /// 获取会话报告
  Future<TrainingReport?> getReportBySession(int sessionId) {
    return (select(trainingReports)..where((t) => t.sessionId.equals(sessionId)))
        .getSingleOrNull();
  }

  /// 获取用户历史报告
  Future<List<TrainingReport>> getUserReports(int userId, {int limit = 20}) {
    return (select(trainingReports)
          ..where((t) => t.userId.equals(userId))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
          ..limit(limit))
        .get();
  }

  /// 获取用户习惯
  Future<List<UserHabit>> getUserHabits(int userId) {
    return (select(userHabits)..where((t) => t.userId.equals(userId))).get();
  }

  /// 设置用户习惯
  Future<void> upsertUserHabit(UserHabitsCompanion habit) {
    return into(userHabits).insertOnConflictUpdate(habit);
  }

  /// 获取用户交易模式
  Future<List<TradingPattern>> getUserPatterns(int userId) {
    return (select(tradingPatterns)
          ..where((t) => t.userId.equals(userId))
          ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
        .get();
  }

  /// 添加或更新交易模式
  Future<void> upsertPattern(TradingPatternsCompanion pattern) {
    return into(tradingPatterns).insertOnConflictUpdate(pattern);
  }

  /// 获取所有启用的策略技巧
  Future<List<StrategyTip>> getEnabledTips() {
    return (select(strategyTips)
          ..where((t) => t.enabled.equals(true))
          ..orderBy([(t) => OrderingTerm.desc(t.effectiveness)]))
        .get();
  }

  /// 获取指定分类的技巧
  Future<List<StrategyTip>> getTipsByCategory(String category) {
    return (select(strategyTips)
          ..where((t) => t.enabled.equals(true))
          ..where((t) => t.category.equals(category))
          ..orderBy([(t) => OrderingTerm.desc(t.effectiveness)]))
        .get();
  }

  /// 通过代码获取技巧
  Future<StrategyTip?> getTipByCode(String code) {
    return (select(strategyTips)..where((t) => t.code.equals(code)))
        .getSingleOrNull();
  }

  /// 添加或更新策略技巧
  Future<void> upsertTip(StrategyTipsCompanion tip) {
    return into(strategyTips).insertOnConflictUpdate(tip);
  }

  /// 获取用户最佳报告
  Future<TrainingReport?> getUserBestReport(int userId) {
    return (select(trainingReports)
          ..where((t) => t.userId.equals(userId))
          ..orderBy([(t) => OrderingTerm.desc(t.profitRate)])
          ..limit(1))
        .getSingleOrNull();
  }

  /// 获取用户胜率最好的报告
  Future<TrainingReport?> getUserBestWinRate(int userId) {
    return (select(trainingReports)
          ..where((t) => t.userId.equals(userId))
          ..orderBy([(t) => OrderingTerm.desc(t.winRate)])
          ..limit(1))
        .getSingleOrNull();
  }
}
