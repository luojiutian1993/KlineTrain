import 'package:drift/drift.dart';
import '../database/database_service.dart';
import '../database/app_database.dart';
import '../database/tables/kline_data_table.dart';
import '../models/kline_model.dart';
import '../api/kline_api.dart';
import 'package:logger/logger.dart';

class KlineDataSyncService {
  final DatabaseService _dbService = DatabaseService.instance;
  final KlineApi _klineApi = KlineApi();
  final Logger _logger = Logger();

  /// 直接从内存中保存K线数据到数据库（不从API获取）
  Future<bool> saveKlineDataToDatabase({
    required String symbol,
    required String marketCode,
    required String period,
    required List<KlineModel> klineData,
  }) async {
    try {
      _logger.d('========== 开始保存K线数据 ==========');
      _logger.d('参数: symbol=$symbol, period=$period, count=${klineData.length}');

      if (klineData.isEmpty) {
        _logger.w('⚠️ K线数据为空，跳过保存');
        return false;
      }

      _logger.d('步骤1: 转换数据格式...');
      // 直接使用带前缀的symbol，不进行normalize
      final companions = klineData.map((item) => KlineDataCompanion(
        symbol: Value(symbol),
        marketCode: Value(marketCode),
        period: Value(period),
        tradeDate: Value(item.dateTime),
        open: Value(item.open),
        high: Value(item.high),
        low: Value(item.low),
        close: Value(item.close),
        volume: Value(item.volume),
        amount: Value(item.turnover),
      )).toList();
      _logger.d('步骤1完成: 转换了 ${companions.length} 条数据');

      _logger.d('步骤2: 执行批量插入...');
      await _dbService.klineDao.batchInsertKline(companions);
      _logger.d('✅ 步骤2完成: 批量插入成功');

      _logger.d('步骤3: 验证保存结果 (使用count)...');
      if (klineData.length >= 1) {
        final count = await _dbService.klineDao.countKlineData(symbol, period);
        _logger.d('✅ 步骤3完成: 数据库中该股票共有 $count 条K线数据');
      }

      _logger.d('========== K线数据保存完成 ==========');
      return true;
    } catch (e, stackTrace) {
      _logger.e('========== K线数据保存失败 ==========');
      _logger.e('错误类型: ${e.runtimeType}');
      _logger.e('错误消息: $e');
      _logger.e('堆栈跟踪:', error: e, stackTrace: stackTrace);
      return false;
    }
  }

  Future<bool> syncSessionKlineData(TrainingSession session) async {
    try {
      // 优先使用带前缀的symbol
      String symbol = session.symbol;
      String period = session.period.isNotEmpty ? session.period : 'day';

      _logger.d('同步训练会话K线数据: sessionId=${session.id}, symbol=$symbol, period=$period');

      final existingData = await _dbService.klineDao.getKlineDataRange(
        symbol,
        period,
        session.startDate,
        session.endDate,
      );

      if (existingData.isNotEmpty) {
        _logger.d('K线数据已存在，无需同步');
        return true;
      }

      _logger.d('从API获取K线数据...');
      final apiData = await _klineApi.fetchKlineData(
        symbol: symbol,
        timeframe: period,
      );

      if (apiData.isEmpty) {
        _logger.w('API返回空数据');
        return false;
      }

      _logger.d('API返回 ${apiData.length} 条数据，开始插入数据库...');

      final companions = apiData.map((item) => KlineDataCompanion(
        symbol: Value(symbol),
        marketCode: Value(session.marketCode),
        period: Value(period),
        tradeDate: Value(item.dateTime),
        open: Value(item.open),
        high: Value(item.high),
        low: Value(item.low),
        close: Value(item.close),
        volume: Value(item.volume),
        amount: Value(item.turnover),
      )).toList();

      await _dbService.klineDao.batchInsertKline(companions);
      _logger.d('K线数据同步完成');
      return true;
    } catch (e) {
      _logger.e('K线数据同步失败: $e');
      return false;
    }
  }

  Future<void> preloadPopularStocks() async {
    _logger.d('开始预加载热门股票K线数据...');

    const popularSymbols = [
      {'symbol': '600519', 'marketCode': 'SH', 'name': '贵州茅台'},
      {'symbol': '300750', 'marketCode': 'SZ', 'name': '宁德时代'},
      {'symbol': '002594', 'marketCode': 'SZ', 'name': '比亚迪'},
      {'symbol': '601318', 'marketCode': 'SH', 'name': '中国平安'},
      {'symbol': '600036', 'marketCode': 'SH', 'name': '招商银行'},
      {'symbol': '600000', 'marketCode': 'SH', 'name': '浦发银行'},
      {'symbol': '000858', 'marketCode': 'SZ', 'name': '五粮液'},
      {'symbol': '601398', 'marketCode': 'SH', 'name': '工商银行'},
    ];

    int successCount = 0;
    for (final stock in popularSymbols) {
      final success = await _syncStockData(stock['symbol']!, stock['marketCode']!);
      if (success) {
        successCount++;
      }
    }

    _logger.d('热门股票K线数据预加载完成: 成功 $successCount/${popularSymbols.length}');
  }

  Future<bool> _syncStockData(String symbol, String marketCode) async {
    try {
      _logger.d('同步股票K线数据: symbol=$symbol, marketCode=$marketCode');

      final apiData = await _klineApi.fetchKlineData(
        symbol: symbol,
        timeframe: 'day',
      );

      if (apiData.isEmpty) {
        _logger.w('股票 $symbol 未获取到K线数据');
        return false;
      }

      final companions = apiData.map((item) => KlineDataCompanion(
        symbol: Value(item.symbol),
        marketCode: Value(marketCode),
        period: Value('day'),
        tradeDate: Value(item.dateTime),
        open: Value(item.open),
        high: Value(item.high),
        low: Value(item.low),
        close: Value(item.close),
        volume: Value(item.volume),
        amount: Value(item.turnover),
      )).toList();

      await _dbService.klineDao.batchInsertKline(companions);
      _logger.d('股票 $symbol K线数据同步完成: ${apiData.length} 条');
      return true;
    } catch (e) {
      _logger.e('股票 $symbol K线数据同步失败: $e');
      return false;
    }
  }

  String _normalizeSymbol(String symbol) {
    if (symbol.startsWith('SH') || symbol.startsWith('SZ')) {
      return symbol.substring(2);
    }
    return symbol;
  }

  Future<List<KlineModel>> getKlineDataForSession(TrainingSession session) async {
    String symbol = _normalizeSymbol(session.symbol);
    String period = session.period.isNotEmpty ? session.period : 'day';

    var klineData = await _dbService.klineDao.getKlineDataRange(
      symbol,
      period,
      session.startDate,
      session.endDate,
    );

    if (klineData.isEmpty) {
      _logger.d('数据库中未找到K线数据，尝试同步...');
      await syncSessionKlineData(session);

      klineData = await _dbService.klineDao.getKlineDataRange(
        symbol,
        period,
        session.startDate,
        session.endDate,
      );
    }

    return klineData.map((k) => KlineModel(
      symbol: k.symbol,
      timestamp: k.tradeDate.millisecondsSinceEpoch,
      open: k.open,
      high: k.high,
      low: k.low,
      close: k.close,
      volume: k.volume,
      turnover: k.amount ?? 0,
    )).toList();
  }
}