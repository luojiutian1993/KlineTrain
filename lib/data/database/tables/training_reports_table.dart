import 'package:drift/drift.dart';
import 'training_sessions_table.dart';
import 'users_table.dart';

/// 训练报告表
class TrainingReports extends Table {
  /// 报告ID
  IntColumn get id => integer().autoIncrement()();

  /// 会话ID (唯一)
  IntColumn get sessionId => integer().references(TrainingSessions, #id)();

  /// 用户ID
  IntColumn get userId => integer().references(Users, #id)();

  /// 总盈亏
  RealColumn get totalProfit => real()();

  /// 总收益率
  RealColumn get profitRate => real()();

  /// 交易次数
  IntColumn get tradeCount => integer()();

  /// 盈利次数
  IntColumn get winCount => integer()();

  /// 胜率
  RealColumn get winRate => real()();

  /// 最大单笔盈利
  RealColumn get maxProfit => real()();

  /// 最大单笔亏损
  RealColumn get maxLoss => real()();

  /// 平均盈利
  RealColumn get avgProfit => real()();

  /// 平均亏损
  RealColumn get avgLoss => real()();

  /// 盈亏比
  RealColumn get profitLossRatio => real()();

  /// 最大回撤
  RealColumn get maxDrawdown => real()();

  /// 夏普比率
  RealColumn get sharpeRatio => real().nullable()();

  /// 最长连胜
  IntColumn get longestWinStreak => integer()();

  /// 最长连败
  IntColumn get longestLoseStreak => integer()();

  /// 平均持仓天数
  RealColumn get avgHoldDays => real()();

  /// 条件单数
  IntColumn get conditionOrdersUsed => integer()();

  /// 触发条件单数
  IntColumn get conditionOrdersTriggered => integer()();

  /// AI分析报告 (JSON)
  TextColumn get analysis => text().nullable()();

  /// 改进建议 (JSON)
  TextColumn get suggestions => text().nullable()();

  /// 创建时间
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
