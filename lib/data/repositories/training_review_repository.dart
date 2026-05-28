import '../database/database_service.dart';
import '../database/app_database.dart';
import '../models/kline_model.dart';
import '../models/trade_point_model.dart';
import '../models/training_review_data.dart';
import '../services/kline_data_sync_service.dart';
import 'package:logger/logger.dart';

class TrainingReviewRepository {
  static final TrainingReviewRepository instance = TrainingReviewRepository._();
  
  final DatabaseService _dbService = DatabaseService.instance;
  final Logger _logger = Logger();
  
  final Map<int, TrainingReviewData> _cache = {};

  TrainingReviewRepository._();

  Future<TrainingReviewData> getReviewData(int sessionId, {bool forceRefresh = false}) async {
    _logger.d('获取复盘数据: sessionId=$sessionId, forceRefresh=$forceRefresh, 缓存存在=${_cache.containsKey(sessionId)}');
    if (!forceRefresh && _cache.containsKey(sessionId)) {
      _logger.d('✅ 使用缓存数据: sessionId=$sessionId');
      return _cache[sessionId]!;
    }
    _logger.d('🔄 从数据库加载数据: sessionId=$sessionId');
    final session = await _dbService.trainingDao.getSession(sessionId);
    if (session == null) {
      throw Exception('训练会话不存在');
    }

    _logger.d('获取训练复盘数据: sessionId=$sessionId, symbol=${session.symbol}');

    var klineData = await _getSessionKlineData(session);

    if (klineData.isEmpty) {
      _logger.w('训练会话 $sessionId 未找到K线数据，尝试扩大查询范围');
      final extendedKlineData = await _getExtendedKlineData(session);
      if (extendedKlineData.isNotEmpty) {
        klineData = extendedKlineData;
        _logger.d('扩大查询范围成功，获取到 ${klineData.length} 条K线数据');
      }
    }

    if (klineData.isEmpty) {
      _logger.w('训练会话 $sessionId 扩大查询范围后仍未找到K线数据，尝试从API同步');
      try {
        final klineSyncService = KlineDataSyncService();
        final syncSuccess =
            await klineSyncService.syncSessionKlineData(session);
        if (syncSuccess) {
          _logger.d('K线数据同步成功，重新查询...');
          klineData = await _getSessionKlineData(session);
          _logger.d('同步后获取到 ${klineData.length} 条K线数据');
        }
      } catch (e) {
        _logger.e('K线数据同步失败: $e');
      }
    }

    final trades = await _dbService.trainingDao.getSessionTrades(sessionId);
    final tradePoints = _convertTradesToPoints(trades, klineData);

    _logger.d(
        '训练复盘数据获取完成: klineCount=${klineData.length}, tradeCount=${trades.length}, tradePointCount=${tradePoints.length}');

    final result = TrainingReviewData(
      session: session,
      klineData: klineData,
      tradePoints: tradePoints,
      trades: trades,
    );
    
    _cache[sessionId] = result;
    return result;
  }

  Future<List<KlineModel>> _getSessionKlineData(TrainingSession session) async {
    // 统一使用带前缀的symbol查询
    String symbol = session.symbol;
    String period = session.period.isNotEmpty ? session.period : 'day';

    _logger.d('查询K线数据: symbol=$symbol, period=$period, '
        'start=${session.startDate}, end=${session.endDate}');

    final klineDataList = await _dbService.klineDao.getKlineDataRange(
      symbol,
      period,
      session.startDate,
      session.endDate,
    );

    _logger.d('查询结果: ${klineDataList.length} 条数据');

    if (klineDataList.isEmpty) {
      // 如果没找到，尝试使用不带前缀的symbol查询（兼容旧数据）
      final normalizedSymbol = _normalizeSymbol(session.symbol);
      final fallbackKlineDataList = await _dbService.klineDao.getKlineDataRange(
        normalizedSymbol,
        period,
        session.startDate,
        session.endDate,
      );
      if (fallbackKlineDataList.isNotEmpty) {
        _logger.d(
            '使用不带前缀的symbol查询成功: $normalizedSymbol, count=${fallbackKlineDataList.length}');
        return fallbackKlineDataList
            .map((k) => _convertToKlineModel(k))
            .toList();
      }
    }

    return klineDataList.map((k) => _convertToKlineModel(k)).toList();
  }

  Future<List<KlineModel>> _getExtendedKlineData(
      TrainingSession session) async {
    final extendedStartDate =
        session.startDate.subtract(const Duration(days: 60));
    final extendedEndDate = session.endDate.add(const Duration(days: 60));

    _logger.d('扩大查询范围: start=$extendedStartDate, end=$extendedEndDate');

    final periods = ['day', 'd', 'daily', session.period];

    // 首先尝试使用带前缀的symbol（统一格式）
    for (final period in periods) {
      if (period.isEmpty) continue;

      final klineDataList = await _dbService.klineDao.getKlineDataRange(
        session.symbol,
        period,
        extendedStartDate,
        extendedEndDate,
      );

      if (klineDataList.isNotEmpty) {
        _logger.d(
            '扩大查询成功（带前缀symbol）: period=$period, count=${klineDataList.length}');
        return klineDataList.map((k) => _convertToKlineModel(k)).toList();
      }
    }

    // 然后尝试使用不带前缀的symbol（兼容旧数据）
    String normalizedSymbol = _normalizeSymbol(session.symbol);
    for (final period in periods) {
      if (period.isEmpty) continue;

      final klineDataList = await _dbService.klineDao.getKlineDataRange(
        normalizedSymbol,
        period,
        extendedStartDate,
        extendedEndDate,
      );

      if (klineDataList.isNotEmpty) {
        _logger.d(
            '扩大查询成功（不带前缀symbol）: period=$period, count=${klineDataList.length}');
        return klineDataList.map((k) => _convertToKlineModel(k)).toList();
      }
    }

    // 最后尝试查询该股票的所有数据（不限制时间）
    final allKlineData =
        await _getAllKlineDataForSymbol(session.symbol, normalizedSymbol);
    if (allKlineData.isNotEmpty) {
      _logger.d('查询所有数据成功: count=${allKlineData.length}');
      return allKlineData;
    }

    _logger.w('扩大查询范围后仍未找到K线数据');
    return [];
  }

  Future<List<KlineModel>> _getAllKlineDataForSymbol(
      String originalSymbol, String normalizedSymbol) async {
    // 首先尝试使用带前缀的symbol（统一格式）
    final originalData = await _dbService.klineDao.getKlineData(
      originalSymbol,
      'day',
      limit: 500,
    );
    if (originalData.isNotEmpty) {
      _logger.d('查询所有数据（带前缀symbol）成功: count=${originalData.length}');
      return originalData.map((k) => _convertToKlineModel(k)).toList();
    }

    // 然后尝试使用不带前缀的symbol（兼容旧数据）
    final normalizedData = await _dbService.klineDao.getKlineData(
      normalizedSymbol,
      'day',
      limit: 500,
    );
    if (normalizedData.isNotEmpty) {
      _logger.d('查询所有数据（不带前缀symbol）成功: count=${normalizedData.length}');
      return normalizedData.map((k) => _convertToKlineModel(k)).toList();
    }

    return [];
  }

  String _normalizeSymbol(String symbol) {
    if (symbol.startsWith('SH') || symbol.startsWith('SZ')) {
      return symbol.substring(2);
    }
    return symbol;
  }

  KlineModel _convertToKlineModel(KlineDataData k) {
    return KlineModel(
      symbol: k.symbol,
      timestamp: k.tradeDate.millisecondsSinceEpoch,
      open: k.open,
      high: k.high,
      low: k.low,
      close: k.close,
      volume: k.volume,
      turnover: k.amount ?? 0,
    );
  }

  List<TradePoint> _convertTradesToPoints(
    List<Trade> trades,
    List<KlineModel> klineData,
  ) {
    if (klineData.isEmpty) {
      _logger.w('K线数据为空，无法转换交易点');
      return [];
    }

    final points = <TradePoint>[];

    for (final trade in trades) {
      final tradeDate = _getTradeDate(trade);

      final index = klineData.indexWhere((k) =>
          k.dateTime.year == tradeDate.year &&
          k.dateTime.month == tradeDate.month &&
          k.dateTime.day == tradeDate.day);

      if (index != -1) {
        points.add(
          TradePoint(
            index: index,
            price: trade.price ?? 0,
            isBuy: trade.type == 'buy',
            label: trade.type == 'buy' ? 'B' : 'S',
            date: tradeDate,
            tradeId: trade.id,
            quantity: trade.quantity ?? 0,
          ),
        );
      } else {
        _logger.w('交易 ${trade.id} 无法匹配到K线数据: ${tradeDate}');
      }
    }

    return points;
  }

  DateTime _getTradeDate(Trade trade) {
    if (trade.createdAt != null) {
      return trade.createdAt!;
    }
    if (trade.tradeDate != null) {
      try {
        return DateTime.parse(trade.tradeDate!);
      } catch (_) {
        // ignore
      }
    }
    return DateTime.now();
  }
}
