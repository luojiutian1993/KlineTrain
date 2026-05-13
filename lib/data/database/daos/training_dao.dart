import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/tables.dart';

part 'training_dao.g.dart';

/// 训练会话相关数据访问对象
@DriftAccessor(tables: [
  TrainingSessions,
  Trades,
  Positions,
  ConditionalOrders,
  OperationLogs,
])
class TrainingDao extends DatabaseAccessor<AppDatabase> with _$TrainingDaoMixin {
  TrainingDao(super.db);

  /// 创建训练会话
  Future<int> createSession(TrainingSessionsCompanion session) {
    return into(trainingSessions).insert(session);
  }

  /// 更新训练会话
  Future<int> updateSession(int sessionId, TrainingSessionsCompanion session) {
    return (update(trainingSessions)..where((t) => t.id.equals(sessionId)))
        .write(session);
  }

  /// 获取会话信息
  Future<TrainingSession?> getSession(int sessionId) {
    return (select(trainingSessions)..where((t) => t.id.equals(sessionId)))
        .getSingleOrNull();
  }

  /// 获取用户活跃会话
  Future<TrainingSession?> getActiveSession(int userId) {
    return (select(trainingSessions)
          ..where((t) => t.userId.equals(userId))
          ..where((t) => t.status.equals('active'))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
          ..limit(1))
        .getSingleOrNull();
  }

  /// 获取用户历史训练会话
  Future<List<TrainingSession>> getUserSessions(
    int userId, {
    int limit = 50,
  }) {
    return (select(trainingSessions)
          ..where((t) => t.userId.equals(userId))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
          ..limit(limit))
        .get();
  }

  /// 获取会话交易记录
  Future<List<Trade>> getSessionTrades(int sessionId) {
    return (select(trades)
          ..where((t) => t.sessionId.equals(sessionId))
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .get();
  }

  /// 添加交易记录
  Future<int> addTrade(TradesCompanion trade) {
    return into(trades).insert(trade);
  }

  /// 获取会话持仓
  Future<List<Position>> getSessionPositions(int sessionId) {
    return (select(positions)
          ..where((t) => t.sessionId.equals(sessionId))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }

  /// 获取活跃持仓
  Future<List<Position>> getActivePositions(int sessionId) {
    return (select(positions)
          ..where((t) => t.sessionId.equals(sessionId))
          ..where((t) => t.status.equals('open')))
        .get();
  }

  /// 添加持仓
  Future<int> addPosition(PositionsCompanion position) {
    return into(positions).insert(position);
  }

  /// 更新持仓
  Future<int> updatePosition(int positionId, PositionsCompanion position) {
    return (update(positions)..where((t) => t.id.equals(positionId)))
        .write(position);
  }

  /// 获取活跃条件单
  Future<List<ConditionalOrder>> getActiveOrders(int sessionId) {
    return (select(conditionalOrders)
          ..where((t) => t.sessionId.equals(sessionId))
          ..where((t) => t.status.equals('active')))
        .get();
  }

  /// 添加条件单
  Future<int> addConditionOrder(ConditionalOrdersCompanion order) {
    return into(conditionalOrders).insert(order);
  }

  /// 更新条件单
  Future<int> updateConditionOrder(int orderId, ConditionalOrdersCompanion order) {
    return (update(conditionalOrders)..where((t) => t.id.equals(orderId)))
        .write(order);
  }

  /// 添加操作日志
  Future<int> addOperationLog(OperationLogsCompanion log) {
    return into(operationLogs).insert(log);
  }

  /// 获取会话操作日志
  Future<List<OperationLog>> getSessionLogs(int sessionId) {
    return (select(operationLogs)
          ..where((t) => t.sessionId.equals(sessionId))
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .get();
  }
}
