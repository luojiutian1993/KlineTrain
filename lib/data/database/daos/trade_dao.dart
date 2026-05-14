import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/tables.dart';

part 'trade_dao.g.dart';

/// 交易相关数据访问对象
@DriftAccessor(tables: [Trades, Positions, ConditionalOrders])
class TradeDao extends DatabaseAccessor<AppDatabase> with _$TradeDaoMixin {
  TradeDao(super.db);

  /// 获取用户交易历史
  Future<List<Trade>> getUserTrades(int userId, {int limit = 100}) {
    return (select(trades)
          ..where((t) => t.userId.equals(userId))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
          ..limit(limit))
        .get();
  }

  /// 获取用户盈利交易
  Future<List<Trade>> getWinningTrades(int userId, {int limit = 50}) {
    return (select(trades)
          ..where((t) => t.userId.equals(userId))
          ..where((t) => t.profit.isBiggerThanValue(0))
          ..orderBy([(t) => OrderingTerm.desc(t.profit)])
          ..limit(limit))
        .get();
  }

  /// 获取用户持仓历史
  Future<List<Position>> getUserPositions(int userId, {int limit = 50}) {
    return (select(positions)
          ..where((t) => t.userId.equals(userId))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
          ..limit(limit))
        .get();
  }

  /// 获取未平仓持仓
  Future<List<Position>> getOpenPositions(int userId) {
    return (select(positions)
          ..where((t) => t.userId.equals(userId))
          ..where((t) => t.status.equals('open')))
        .get();
  }

  /// 获取用户条件单
  Future<List<ConditionalOrder>> getUserOrders(
    int userId, {
    String? status,
    int limit = 50,
  }) {
    final query = select(conditionalOrders)
      ..where((t) => t.userId.equals(userId))
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
      ..limit(limit);

    if (status != null) {
      query.where((t) => t.status.equals(status));
    }

    return query.get();
  }

  /// 取消条件单
  Future<int> cancelOrder(int orderId) {
    return (update(conditionalOrders)..where((t) => t.id.equals(orderId)))
        .write(ConditionalOrdersCompanion(
      status: const Value('cancelled'),
      updatedAt: Value(DateTime.now()),
    ));
  }

  /// 批量取消条件单
  Future<int> cancelAllSessionOrders(int sessionId) {
    return (update(conditionalOrders)..where((t) => t.sessionId.equals(sessionId)))
        .write(ConditionalOrdersCompanion(
      status: const Value('cancelled'),
      updatedAt: Value(DateTime.now()),
    ));
  }

  /// 统计用户总交易次数
  Future<int> countUserTrades(int userId) async {
    final countQuery = trades.id.count();
    final query = selectOnly(trades)
      ..addColumns([countQuery])
      ..where(trades.userId.equals(userId));
    final result = await query.getSingle();
    return result.read(countQuery) ?? 0;
  }
}
