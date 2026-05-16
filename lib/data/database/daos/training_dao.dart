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
class TrainingDao extends DatabaseAccessor<AppDatabase>
    with _$TrainingDaoMixin {
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
  Future<int> updateConditionOrder(
      int orderId, ConditionalOrdersCompanion order) {
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

  /// 获取用户资产汇总数据
  Future<Map<String, dynamic>> getUserAssetSummary(int userId) async {
    final sessions = await getUserSessions(userId, limit: 1000);

    if (sessions.isEmpty) {
      return {
        'initialCapital': 100000.0,
        'currentCapital': 100000.0,
        'totalProfit': 0.0,
        'profitRate': 0.0,
        'totalTradeCount': 0,
        'totalTradeDays': 0,
        'winCount': 0,
        'winRate': 0.0,
        'maxProfit': 0.0,
        'maxLoss': 0.0,
        'maxDrawdown': 0.0,
        'avgDrawdown': 0.0,
        'avgProfitRate': 0.0,
      };
    }

    double totalInitialCapital = 0;
    double totalCurrentCapital = 0;
    double totalProfit = 0;
    double totalMaxDrawdown = 0;
    int totalTradeCount = 0;
    int totalWinCount = 0;
    Set<String> tradeDaysSet = {};

    for (final session in sessions) {
      totalInitialCapital += session.initialCapital;
      totalCurrentCapital += session.currentCapital;
      totalProfit += session.totalProfit;
      totalTradeCount += session.tradeCount;
      totalWinCount += session.winCount;
      totalMaxDrawdown = totalMaxDrawdown < session.maxDrawdown
          ? session.maxDrawdown
          : totalMaxDrawdown;

      final start = DateTime(
        session.startDate.year,
        session.startDate.month,
        session.startDate.day,
      );
      final end = DateTime(
        session.endDate.year,
        session.endDate.month,
        session.endDate.day,
      );
      for (var d = start;
          d.isBefore(end.add(const Duration(days: 1)));
          d = d.add(const Duration(days: 1))) {
        tradeDaysSet.add('${d.year}-${d.month}-${d.day}');
      }
    }

    final firstSession = sessions.first;
    final lastSession = sessions.last;
    final daySpan =
        lastSession.endDate.difference(firstSession.startDate).inDays;
    final annualizedReturn = daySpan > 0
        ? (totalProfit / totalInitialCapital) / (daySpan / 365) * 100
        : 0.0;

    final winRate =
        totalTradeCount > 0 ? (totalWinCount / totalTradeCount) * 100 : 0.0;
    final profitRate = totalInitialCapital > 0
        ? (totalProfit / totalInitialCapital) * 100
        : 0.0;

    return {
      'initialCapital': totalInitialCapital,
      'currentCapital': totalCurrentCapital,
      'totalProfit': totalProfit,
      'profitRate': profitRate,
      'totalTradeCount': totalTradeCount,
      'totalTradeDays': tradeDaysSet.length,
      'winCount': totalWinCount,
      'winRate': winRate,
      'maxProfit': totalProfit > 0 ? totalProfit : 0.0,
      'maxLoss': totalProfit < 0 ? totalProfit.abs() : 0.0,
      'maxDrawdown': totalMaxDrawdown,
      'avgDrawdown':
          totalMaxDrawdown / (sessions.length > 0 ? sessions.length : 1),
      'avgProfitRate': profitRate / (sessions.length > 0 ? sessions.length : 1),
      'annualizedReturn': annualizedReturn,
    };
  }

  /// 获取用户最新会话（用于获取当前持仓）
  Future<TrainingSession?> getLatestSession(int userId) {
    return (select(trainingSessions)
          ..where((t) => t.userId.equals(userId))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
          ..limit(1))
        .getSingleOrNull();
  }

  /// 获取用户最近交易记录
  Future<List<Trade>> getRecentTrades(int userId, {int limit = 20}) {
    return (select(trades)
          ..where((t) => t.userId.equals(userId))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
          ..limit(limit))
        .get();
  }

  /// 获取带标的名字的最近交易记录
  Future<List<Map<String, dynamic>>> getRecentTradesWithSymbol(int userId,
      {int limit = 20}) async {
    final tradesList = await getRecentTrades(userId, limit: limit);

    return tradesList.map((trade) {
      return {
        'id': trade.id,
        'sessionId': trade.sessionId,
        'symbol': trade.symbol,
        'symbolName': _getSymbolName(trade.symbol, trade.marketCode),
        'marketCode': trade.marketCode,
        'type': trade.type,
        'price': trade.price,
        'quantity': trade.quantity,
        'amount': trade.amount,
        'profit': trade.profit,
        'profitRate': trade.profitRate,
        'tradeDate': trade.tradeDate,
        'createdAt': trade.createdAt,
      };
    }).toList();
  }

  String _getSymbolName(String symbol, String marketCode) {
    final knownSymbols = {
      'SH600000': '浦发银行',
      'SH600036': '招商银行',
      'SH600519': '贵州茅台',
      'SH601318': '中国平安',
      'SZ300750': '宁德时代',
      'SZ002594': '比亚迪',
      'SZ000001': '平安银行',
      'SZ000002': '万科A',
    };
    final key = '$marketCode$symbol';
    return knownSymbols[key] ?? symbol;
  }
}
