import 'dart:async';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kline_trainer/theme/app_theme.dart';
import 'package:kline_trainer/features/training/widgets/kline_chart.dart';
import 'package:kline_trainer/data/repositories/kline_repository.dart';
import 'package:kline_trainer/data/models/kline_model.dart'
    show KlineModel, KdjData, RsiData, BollData, DmiData, DmaData;
import 'package:kline_trainer/data/utils/indicator_calculator.dart';
import 'package:kline_trainer/data/database/database_service.dart';
import 'package:kline_trainer/data/database/app_database.dart';
import 'package:kline_trainer/data/services/kline_data_sync_service.dart';
import 'package:kline_trainer/providers/battle_stock_provider.dart';
import 'package:kline_trainer/core/enums/stock_filter_condition.dart';
import 'package:drift/drift.dart' show Value;
import 'package:logger/logger.dart';

class BattleScreen extends ConsumerStatefulWidget {
  const BattleScreen({super.key});

  @override
  ConsumerState<BattleScreen> createState() => _BattleScreenState();
}

class _BattleScreenState extends ConsumerState<BattleScreen> {
  // 默认配置：深科技（SZ000021）
  static const String _DEFAULT_SYMBOL = 'SZ000021';
  static const String _DEFAULT_STOCK_NAME = '深科技';
  static const String _DEFAULT_MARKET_CODE = 'XSHE';
  static final DateTime _DEFAULT_START_DATE = DateTime(2023, 3, 31);

  int _selectedIndex = 1;
  String _selectedPeriod = '日K';
  String _selectedTopIndicator = '成交量';
  String _selectedBottomIndicator = 'MACD';
  int _currentDayIndex = 0;
  int _trainingDays = 150;
  final int _historyDays = 100; // 从30改为100，确保指标有足够预热期
  DateTime? _trainingStartDate;
  DateTime? _lastEdgeAlertTime;

  final List<String> _periods = ['日K', '周K', '月K', '季K', '年K'];
  final List<String> _indicators = [
    '成交量',
    'MACD',
    'KDJ',
    'RSI',
    'BOLL',
    'WR',
    'CCI',
    'OBV',
    'DMI',
    'DMA',
    'BBI'
  ];

  String _currentSymbol = 'SH600000';
  String _currentSymbolName = '';
  String _currentMarketCode = '';
  List<KlineModel> _allKlineData = [];
  List<TradePoint> _tradePoints = [];

  double _accountBalance = 100000.0;
  double _positionQuantity = 0.0;
  double _positionCost = 0.0;
  double _totalProfitLoss = 0.0;
  double _initialBalance = 100000.0;

  int _visibleStartIndex = 0;
  int _visibleKlineCount = 20;
  double _zoomScale = 1.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleRouteExtra();
    });
    _loadKlineData();
  }

  void _handleRouteExtra() {
    final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;
    if (extra != null) {
      setState(() {
        _currentSymbol = extra['stockCode'] as String? ?? _currentSymbol;
        _currentSymbolName = extra['stockName'] as String? ?? '';
        _currentMarketCode = extra['marketCode'] as String? ?? '';
        _trainingStartDate = extra['trainingStartDate'] as DateTime?;
        _trainingDays = extra['trainingDays'] as int? ?? 150;
      });
      _loadKlineData();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadKlineData() async {
    final repository = KlineRepository();

    String symbolToLoad;
    String nameToLoad;
    String marketCodeToLoad;
    DateTime startDateToLoad;

    // 判断是否有路由参数（从首页选股跳转）
    final bool hasRouteParams = _trainingStartDate != null &&
        _currentSymbol != 'SH600000' &&
        _currentSymbolName.isNotEmpty;

    if (hasRouteParams) {
      // 有路由参数，使用传入的值（从首页选股跳转）
      symbolToLoad = _currentSymbol;
      nameToLoad = _currentSymbolName;
      marketCodeToLoad = _currentMarketCode;
      startDateToLoad = _trainingStartDate!;
    } else {
      // 没有路由参数，使用默认配置（直接进入实战页面）
      // 深科技（SZ000021）+ 2023年3月31日
      symbolToLoad = _DEFAULT_SYMBOL;
      nameToLoad = _DEFAULT_STOCK_NAME;
      marketCodeToLoad = _DEFAULT_MARKET_CODE;
      startDateToLoad = _DEFAULT_START_DATE;
    }

    final totalDays = _trainingDays + _historyDays;

    // 计算数据查询范围
    final startTime = startDateToLoad.subtract(Duration(days: _historyDays));
    final endTime = startDateToLoad.add(Duration(days: _trainingDays));

    // 优先从数据库加载真实数据（日期范围查询）
    List<KlineModel> data = await repository.fetchKlineDataFromDbWithDateRange(
      symbol: symbolToLoad,
      period: 'day',
      startTime: startTime,
      endTime: endTime,
    );

    // 如果数据库没有数据，尝试从数据库查询该股票的所有数据
    if (data.isEmpty) {
      data = await repository.fetchKlineDataFromDb(
        symbol: symbolToLoad,
        period: 'day',
        limit: totalDays + 50,
      );
    }

    // 如果还是没有数据，再使用模拟数据（仅作为后备方案）
    if (data.isEmpty) {
      data = await repository.fetchKlineData(
        symbol: symbolToLoad,
        timeframe: 'day',
        limit: totalDays,
      );
    }

    // 限制数据量，避免内存溢出
    // 只保留：历史数据(_historyDays) + 训练数据(_trainingDays) + 额外10天缓冲
    final maxDataSize = _historyDays + _trainingDays + 10;
    if (data.length > maxDataSize) {
      // 保留最新的数据（训练数据优先）
      data = data.sublist(data.length - maxDataSize);
    }

    // 更新股票信息
    setState(() {
      _currentSymbol = symbolToLoad;
      _currentSymbolName = nameToLoad;
      _currentMarketCode = marketCodeToLoad;
      _trainingStartDate = startDateToLoad;
      _allKlineData = data;

      // 找到训练开始日期对应的索引
      // 数据结构：前_historyDays天是历史数据，之后是训练数据
      // _currentDayIndex 应该指向训练开始的那一天（索引 >= _historyDays）
      final startDayIndex = _findStartDayIndex(data, startDateToLoad);

      // 如果找到了训练开始日期，但位置在历史数据范围内（< _historyDays），需要调整
      // 确保 _currentDayIndex 至少为 _historyDays，这样训练进度才从1开始
      if (startDayIndex >= 0 && startDayIndex < data.length) {
        _currentDayIndex = startDayIndex;
        // 如果找到的日期在历史数据范围内，调整到历史数据结束位置
        if (_currentDayIndex < _historyDays) {
          _currentDayIndex = _historyDays.clamp(0, data.length - 1);
        }
      } else {
        // 如果没找到训练开始日期，默认从 _historyDays 开始（训练第一天）
        _currentDayIndex = _historyDays.clamp(0, data.length - 1);
      }

      _tradePoints = [];
      // 确保 _visibleStartIndex 正确初始化，显示训练开始那天
      _visibleStartIndex = (_currentDayIndex - _visibleKlineCount + 1)
          .clamp(0, _currentDayIndex);
    });
  }

  /// 根据日期找到对应的K线索引
  int _findStartDayIndex(List<KlineModel> data, DateTime targetDate) {
    for (int i = 0; i < data.length; i++) {
      final klineDate = DateTime.fromMillisecondsSinceEpoch(data[i].timestamp);
      // 检查是否是同一天
      if (klineDate.year == targetDate.year &&
          klineDate.month == targetDate.month &&
          klineDate.day == targetDate.day) {
        return i;
      }
    }
    // 如果没找到精确匹配，找最近的日期
    if (data.isNotEmpty) {
      for (int i = 0; i < data.length; i++) {
        final klineDate =
            DateTime.fromMillisecondsSinceEpoch(data[i].timestamp);
        if (klineDate.isAfter(targetDate) ||
            klineDate.isAtSameMomentAs(targetDate)) {
          return i;
        }
      }
      return data.length - 1; // 返回最后一天
    }
    return -1;
  }

  Future<void> _nextDay() async {
    // 确保不超过训练数据范围（历史数据 + 训练天数）
    final maxTrainingIndex = _historyDays + _trainingDays - 1;

    if (_currentDayIndex < maxTrainingIndex &&
        _currentDayIndex < _allKlineData.length - 1) {
      setState(() {
        _currentDayIndex++;
        // 滚动图表，确保当前训练天在可见范围内
        _visibleStartIndex = (_currentDayIndex - _visibleKlineCount + 1)
            .clamp(0, _currentDayIndex);
        _checkConditionalOrders();
        _updateAccount();
      });
    } else {
      await _showTrainingCompleteDialog();
    }
  }

  void _checkConditionalOrders() {}

  void _updateAccount() {
    if (_positionQuantity > 0 && _allKlineData.isNotEmpty) {}
  }

  void _zoomIn() {
    setState(() {
      _zoomScale = (_zoomScale * 1.2).clamp(0.0286, 3.0);
      _updateVisibleRange();
    });
  }

  void _zoomOut() {
    setState(() {
      _zoomScale = (_zoomScale / 1.2).clamp(0.0286, 3.0);
      _updateVisibleRange();
    });
  }

  void _updateVisibleRange() {
    final baseCount = 20;
    _visibleKlineCount = (baseCount / _zoomScale).round().clamp(10, 700);
  }

  void _slideLeft() {
    if (_visibleStartIndex <= 0) {
      _showEdgeAlert('已经到达最左边');
      return;
    }
    setState(() {
      _visibleStartIndex -= 5;
      if (_visibleStartIndex < 0) {
        _visibleStartIndex = 0;
      }
    });
  }

  void _slideRight() {
    final endIndex = (_currentDayIndex + 1).clamp(0, _allKlineData.length);
    final maxStart = (endIndex - _visibleKlineCount).clamp(0, endIndex);
    if (_visibleStartIndex >= maxStart) {
      _showEdgeAlert('已经到达最右边');
      return;
    }
    setState(() {
      _visibleStartIndex += 5;
      if (_visibleStartIndex > maxStart) {
        _visibleStartIndex = maxStart;
      }
      if (_visibleStartIndex < 0) {
        _visibleStartIndex = 0;
      }
    });
  }

  void _showEdgeAlert(String message) {
    final now = DateTime.now();
    if (_lastEdgeAlertTime != null) {
      final diff = now.difference(_lastEdgeAlertTime!);
      if (diff.inMilliseconds < 1500) {
        return;
      }
    }
    _lastEdgeAlertTime = now;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(milliseconds: 1500),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showBuyDialog() {
    if (_allKlineData.isEmpty) return;

    final currentPrice = _allKlineData[_currentDayIndex].close;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _TradeDialog(
        title: '买入',
        currentPrice: currentPrice,
        maxQuantity: (_accountBalance / currentPrice / 100).floor() * 100,
        accountBalance: _accountBalance,
        onConfirm: (price, quantity) {
          Navigator.pop(context);
          _executeBuy(price, quantity);
        },
      ),
    );
  }

  void _executeBuy(double price, double quantity) {
    if (quantity <= 0) return;

    setState(() {
      _positionQuantity = quantity;
      _positionCost = price;
      _accountBalance -= quantity * price;

      _tradePoints.add(TradePoint(
        index: _currentDayIndex,
        price: price,
        isBuy: true,
        label: '买入 ${quantity.toInt()}股',
        date: _allKlineData[_currentDayIndex].dateTime,
      ));
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('以 $price 买入 ${quantity.toInt()} 股')),
    );
  }

  void _showSellDialog() {
    if (_positionQuantity <= 0 || _allKlineData.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('没有持仓')),
      );
      return;
    }

    final currentPrice = _allKlineData[_currentDayIndex].close;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _TradeDialog(
        title: '卖出',
        currentPrice: currentPrice,
        maxQuantity: _positionQuantity,
        accountBalance: _accountBalance,
        positionQuantity: _positionQuantity,
        positionCost: _positionCost,
        onConfirm: (price, quantity) {
          Navigator.pop(context);
          _executeSell(price, quantity);
        },
      ),
    );
  }

  void _executeSell(double price, double quantity) {
    if (quantity <= 0) return;

    setState(() {
      _tradePoints.add(TradePoint(
        index: _currentDayIndex,
        price: price,
        isBuy: false,
        label: '卖出 ${quantity.toInt()}股',
        date: _allKlineData[_currentDayIndex].dateTime,
      ));

      final sellProfit = (price - _positionCost) * quantity;
      _totalProfitLoss += sellProfit;

      _accountBalance += quantity * price;
      _positionQuantity -= quantity;
      if (_positionQuantity <= 0) {
        _positionQuantity = 0;
        _positionCost = 0;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('以 $price 卖出 ${quantity.toInt()} 股')),
    );
  }

  void _showStockSelectionDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) => _StockSelectionSheet(
        onSelect: (symbol) {
          setState(() {
            _currentSymbol = symbol;
          });
          _loadKlineData();
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showConditionalOrderDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) => _ConditionalOrderSheet(
        currentPrice: _allKlineData.isNotEmpty
            ? _allKlineData[_currentDayIndex].close
            : 0,
        onConfirm: (type, params) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('条件单已设置: $type')),
          );
        },
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/battle');
        break;
      case 2:
        context.go('/mine');
        break;
    }
  }

  List<KlineData> get _displayKlineData {
    if (_allKlineData.isEmpty) return [];
    final endIndex = (_currentDayIndex + 1).clamp(0, _allKlineData.length);
    final maxStart = (endIndex - _visibleKlineCount).clamp(0, endIndex);
    final startIndex = _visibleStartIndex.clamp(0, maxStart);
    return _allKlineData
        .skip(startIndex)
        .take(_visibleKlineCount)
        .map((e) => KlineData(
              date: e.dateTime,
              open: e.open,
              high: e.high,
              low: e.low,
              close: e.close,
              volume: e.volume,
            ))
        .toList();
  }

  List<TradePoint> get _visibleTradePoints {
    if (_tradePoints.isEmpty) return [];
    final endIndex = (_currentDayIndex + 1).clamp(0, _allKlineData.length);
    final maxStart = (endIndex - _visibleKlineCount).clamp(0, endIndex);
    final startIndex = _visibleStartIndex.clamp(0, maxStart);

    return _tradePoints
        .where((point) =>
            point.index >= startIndex &&
            point.index < startIndex + _visibleKlineCount)
        .map((point) => TradePoint(
              index: point.index - startIndex,
              price: point.price,
              isBuy: point.isBuy,
              label: point.label,
              date: point.date,
            ))
        .toList();
  }

  List<VolumeData> get _displayVolumes {
    if (_allKlineData.isEmpty) return [];
    final endIndex = (_currentDayIndex + 1).clamp(0, _allKlineData.length);
    final maxStart = (endIndex - _visibleKlineCount).clamp(0, endIndex);
    final startIndex = _visibleStartIndex.clamp(0, maxStart);
    return _allKlineData
        .skip(startIndex)
        .take(_visibleKlineCount)
        .map((e) => VolumeData(volume: e.volume, isUp: e.isUp))
        .toList();
  }

  List<MacdData> get _displayMacdData {
    if (_allKlineData.isEmpty) return [];

    // 计算可视范围
    final endIndex = (_currentDayIndex + 1).clamp(0, _allKlineData.length);
    final maxStart = (endIndex - _visibleKlineCount).clamp(0, endIndex);
    final startIndex = _visibleStartIndex.clamp(0, maxStart);

    // 从历史起点计算完整指标，确保训练期指标有效
    final fullData = _allKlineData.take(endIndex).toList();
    final macdResult = IndicatorCalculator.calculateMACD(fullData);

    // 构建完整结果（包含预热期的padding和真实指标值）
    final macdOffset = fullData.length - macdResult.macd.length;
    final result = <MacdData>[];

    for (int i = 0; i < fullData.length; i++) {
      final macdIndex = i - macdOffset;
      if (macdIndex >= 0 && macdIndex < macdResult.macd.length) {
        result.add(MacdData(
          macd: macdResult.macd[macdIndex],
          diff: macdResult.dif[macdIndex],
          dea: macdResult.dea[macdIndex],
        ));
      } else {
        // 预热期：使用0值（技术指标的固有局限）
        result.add(MacdData(macd: 0, diff: 0, dea: 0));
      }
    }

    // 返回可视范围的指标
    if (result.length > startIndex) {
      final end = startIndex + _visibleKlineCount;
      return result.sublist(startIndex, end.clamp(startIndex, result.length));
    }
    return result;
  }

  List<KdjData> get _displayKdjData {
    if (_allKlineData.isEmpty) return [];

    final endIndex = (_currentDayIndex + 1).clamp(0, _allKlineData.length);
    final maxStart = (endIndex - _visibleKlineCount).clamp(0, endIndex);
    final startIndex = _visibleStartIndex.clamp(0, maxStart);

    // 从历史起点计算完整指标
    final fullData = _allKlineData.take(endIndex).toList();
    final kdjResult = IndicatorCalculator.calculateKDJ(fullData);

    // 构建完整结果
    final kdjOffset = fullData.length - kdjResult.k.length;
    final result = <KdjData>[];

    for (int i = 0; i < fullData.length; i++) {
      final kdjIndex = i - kdjOffset;
      if (kdjIndex >= 0 && kdjIndex < kdjResult.k.length) {
        result.add(KdjData(
          k: kdjResult.k[kdjIndex],
          d: kdjResult.d[kdjIndex],
          j: kdjResult.j[kdjIndex],
        ));
      } else {
        // 预热期：使用默认值50
        result.add(KdjData(k: 50, d: 50, j: 50));
      }
    }

    if (result.length > startIndex) {
      final end = startIndex + _visibleKlineCount;
      return result.sublist(startIndex, end.clamp(startIndex, result.length));
    }
    return result;
  }

  List<RsiData> get _displayRsiData {
    if (_allKlineData.isEmpty) return [];

    final endIndex = (_currentDayIndex + 1).clamp(0, _allKlineData.length);
    final maxStart = (endIndex - _visibleKlineCount).clamp(0, endIndex);
    final startIndex = _visibleStartIndex.clamp(0, maxStart);

    // 从历史起点计算完整指标
    final fullData = _allKlineData.take(endIndex).toList();
    final rsiResult = IndicatorCalculator.calculateRSI(fullData);

    // 构建完整结果
    final rsiOffset = fullData.length - rsiResult.values.length;
    final result = <RsiData>[];

    for (int i = 0; i < fullData.length; i++) {
      final rsiIndex = i - rsiOffset;
      if (rsiIndex >= 0 && rsiIndex < rsiResult.values.length) {
        result.add(RsiData(rsi: rsiResult.values[rsiIndex]));
      } else {
        // 预热期：使用默认值50
        result.add(RsiData(rsi: 50));
      }
    }

    if (result.length > startIndex) {
      final end = startIndex + _visibleKlineCount;
      return result.sublist(startIndex, end.clamp(startIndex, result.length));
    }
    return result;
  }

  List<BollData> get _displayBollData {
    if (_allKlineData.isEmpty) return [];

    final endIndex = (_currentDayIndex + 1).clamp(0, _allKlineData.length);
    final maxStart = (endIndex - _visibleKlineCount).clamp(0, endIndex);
    final startIndex = _visibleStartIndex.clamp(0, maxStart);

    // 从历史起点计算完整指标
    final fullData = _allKlineData.take(endIndex).toList();
    final bollResult = IndicatorCalculator.calculateBoll(fullData);

    // 构建完整结果
    final bollOffset = fullData.length - bollResult.mb.length;
    final result = <BollData>[];

    for (int i = 0; i < fullData.length; i++) {
      final bollIndex = i - bollOffset;
      if (bollIndex >= 0 && bollIndex < bollResult.mb.length) {
        result.add(BollData(
          upper: bollResult.up[bollIndex],
          mid: bollResult.mb[bollIndex],
          lower: bollResult.dn[bollIndex],
        ));
      } else {
        // 预热期：使用收盘价近似值
        final currentData = fullData[i];
        result.add(BollData(
          upper: currentData.close * 1.02,
          mid: currentData.close,
          lower: currentData.close * 0.98,
        ));
      }
    }

    if (result.length > startIndex) {
      final end = startIndex + _visibleKlineCount;
      return result.sublist(startIndex, end.clamp(startIndex, result.length));
    }
    return result;
  }

  List<double> get _displayWrData {
    if (_allKlineData.isEmpty) return [];

    final endIndex = (_currentDayIndex + 1).clamp(0, _allKlineData.length);
    final maxStart = (endIndex - _visibleKlineCount).clamp(0, endIndex);
    final startIndex = _visibleStartIndex.clamp(0, maxStart);

    // 从历史起点计算完整指标
    final fullData = _allKlineData.take(endIndex).toList();
    final wrResult = IndicatorCalculator.calculateWR(fullData);

    // 构建完整结果
    final wrOffset = fullData.length - wrResult.values.length;
    final result = <double>[];

    for (int i = 0; i < fullData.length; i++) {
      final wrIndex = i - wrOffset;
      if (wrIndex >= 0 && wrIndex < wrResult.values.length) {
        result.add(wrResult.values[wrIndex]);
      } else {
        // 预热期：使用默认值50
        result.add(50.0);
      }
    }

    if (result.length > startIndex) {
      final end = startIndex + _visibleKlineCount;
      return result.sublist(startIndex, end.clamp(startIndex, result.length));
    }
    return result;
  }

  List<double> get _displayCciData {
    if (_allKlineData.isEmpty) return [];

    final endIndex = (_currentDayIndex + 1).clamp(0, _allKlineData.length);
    final maxStart = (endIndex - _visibleKlineCount).clamp(0, endIndex);
    final startIndex = _visibleStartIndex.clamp(0, maxStart);

    // 从历史起点计算完整指标
    final fullData = _allKlineData.take(endIndex).toList();
    final cciResult = IndicatorCalculator.calculateCCI(fullData);

    // 构建完整结果
    final cciOffset = fullData.length - cciResult.values.length;
    final result = <double>[];

    for (int i = 0; i < fullData.length; i++) {
      final cciIndex = i - cciOffset;
      if (cciIndex >= 0 && cciIndex < cciResult.values.length) {
        result.add(cciResult.values[cciIndex]);
      } else {
        // 预热期：使用默认值0
        result.add(0.0);
      }
    }

    if (result.length > startIndex) {
      final end = startIndex + _visibleKlineCount;
      return result.sublist(startIndex, end.clamp(startIndex, result.length));
    }
    return result;
  }

  List<double> get _displayObvData {
    if (_allKlineData.isEmpty) return [];

    final endIndex = (_currentDayIndex + 1).clamp(0, _allKlineData.length);
    final maxStart = (endIndex - _visibleKlineCount).clamp(0, endIndex);
    final startIndex = _visibleStartIndex.clamp(0, maxStart);

    // 从历史起点计算完整指标（OBV无预热期，从第一天就有值）
    final fullData = _allKlineData.take(endIndex).toList();
    final obvResult = IndicatorCalculator.calculateOBV(fullData);
    final result = obvResult.values;

    if (result.length > startIndex) {
      final end = startIndex + _visibleKlineCount;
      return result.sublist(startIndex, end.clamp(startIndex, result.length));
    }
    return result;
  }

  List<DmiData> get _displayDmiData {
    if (_allKlineData.isEmpty) return [];

    final endIndex = (_currentDayIndex + 1).clamp(0, _allKlineData.length);
    final maxStart = (endIndex - _visibleKlineCount).clamp(0, endIndex);
    final startIndex = _visibleStartIndex.clamp(0, maxStart);

    // 从历史起点计算完整指标
    final fullData = _allKlineData.take(endIndex).toList();
    final dmiResult = IndicatorCalculator.calculateDMI(fullData);

    // 构建完整结果
    final dmiOffset = fullData.length - dmiResult.plusDI.length;
    final result = <DmiData>[];

    for (int i = 0; i < fullData.length; i++) {
      final dmiIndex = i - dmiOffset;
      if (dmiIndex >= 0 && dmiIndex < dmiResult.plusDI.length) {
        final double adxValue =
            dmiIndex < dmiResult.adx.length ? dmiResult.adx[dmiIndex] : 0.0;
        result.add(DmiData(
          plusDI: dmiResult.plusDI[dmiIndex],
          minusDI: dmiResult.minusDI[dmiIndex],
          adx: adxValue,
        ));
      } else {
        // 预热期：使用默认值0
        result.add(DmiData(plusDI: 0, minusDI: 0, adx: 0));
      }
    }

    if (result.length > startIndex) {
      final end = startIndex + _visibleKlineCount;
      return result.sublist(startIndex, end.clamp(startIndex, result.length));
    }
    return result;
  }

  List<DmaData> get _displayDmaData {
    if (_allKlineData.isEmpty) return [];

    final endIndex = (_currentDayIndex + 1).clamp(0, _allKlineData.length);
    final maxStart = (endIndex - _visibleKlineCount).clamp(0, endIndex);
    final startIndex = _visibleStartIndex.clamp(0, maxStart);

    // 从历史起点计算完整指标
    final fullData = _allKlineData.take(endIndex).toList();
    final dmaResult = IndicatorCalculator.calculateDMA(fullData);

    // 构建完整结果
    final dmaOffset = fullData.length - dmaResult.dma.length;
    final result = <DmaData>[];

    for (int i = 0; i < fullData.length; i++) {
      final dmaIndex = i - dmaOffset;
      if (dmaIndex >= 0 && dmaIndex < dmaResult.dma.length) {
        final double amaValue =
            dmaIndex < dmaResult.ama.length ? dmaResult.ama[dmaIndex] : 0.0;
        result.add(DmaData(dma: dmaResult.dma[dmaIndex], ama: amaValue));
      } else {
        // 预热期：使用默认值0
        result.add(DmaData(dma: 0, ama: 0));
      }
    }

    if (result.length > startIndex) {
      final end = startIndex + _visibleKlineCount;
      return result.sublist(startIndex, end.clamp(startIndex, result.length));
    }
    return result;
  }

  List<double> get _displayBbiData {
    if (_allKlineData.isEmpty) return [];

    final endIndex = (_currentDayIndex + 1).clamp(0, _allKlineData.length);
    final maxStart = (endIndex - _visibleKlineCount).clamp(0, endIndex);
    final startIndex = _visibleStartIndex.clamp(0, maxStart);

    // 从历史起点计算完整指标
    final fullData = _allKlineData.take(endIndex).toList();
    final bbiResult = IndicatorCalculator.calculateBBI(fullData);

    // 构建完整结果
    final bbiOffset = fullData.length - bbiResult.values.length;
    final result = <double>[];

    for (int i = 0; i < fullData.length; i++) {
      final bbiIndex = i - bbiOffset;
      if (bbiIndex >= 0 && bbiIndex < bbiResult.values.length) {
        result.add(bbiResult.values[bbiIndex]);
      } else {
        // 预热期：使用默认值0
        result.add(0.0);
      }
    }

    if (result.length > startIndex) {
      final end = startIndex + _visibleKlineCount;
      return result.sublist(startIndex, end.clamp(startIndex, result.length));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildStockInfo(),
            _buildMarketData(),
            _buildPeriodSelector(),
            Expanded(
              flex: 2,
              child: ClipRect(
                child: _buildKlineChartWithoutControls(),
              ),
            ),
            _buildControlButtons(),
            Expanded(
              flex: 1,
              child: ClipRect(
                child: _buildIndicatorWithSelector(_selectedTopIndicator, true),
              ),
            ),
            Expanded(
              flex: 1,
              child: ClipRect(
                child: _buildIndicatorWithSelector(
                    _selectedBottomIndicator, false),
              ),
            ),
            _buildTradeButtons(),
            _buildAssetInfo(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '首页',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: '实战',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '我的',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppTheme.accent,
        unselectedItemColor: AppTheme.muted,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildStockInfo() {
    final currentData =
        _allKlineData.isNotEmpty && _currentDayIndex < _allKlineData.length
            ? _allKlineData[_currentDayIndex]
            : null;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.border, width: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(_getStockName(_currentSymbol),
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 第一列：收盘价和涨跌
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        currentData != null
                            ? currentData.close.toStringAsFixed(2)
                            : '--',
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '收',
                        style: TextStyle(fontSize: 10, color: AppTheme.muted),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        currentData != null
                            ? '${currentData.change >= 0 ? '+' : ''}${currentData.change.toStringAsFixed(2)}'
                            : '--',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color:
                                currentData != null && currentData.change >= 0
                                    ? Colors.red
                                    : Colors.green),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        currentData != null
                            ? '${currentData.change >= 0 ? '+' : ''}${currentData.changePercent.toStringAsFixed(2)}%'
                            : '--',
                        style: TextStyle(
                            fontSize: 10,
                            color:
                                currentData != null && currentData.change >= 0
                                    ? Colors.red
                                    : Colors.green),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(width: 12),
              // 第二列：高/低
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoItem(
                      '高', currentData?.high.toStringAsFixed(2) ?? '--'),
                  const SizedBox(height: 4),
                  _buildInfoItem(
                      '低', currentData?.low.toStringAsFixed(2) ?? '--'),
                ],
              ),
              const SizedBox(width: 12),
              // 第三列：开/换手
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoItem(
                      '开', currentData?.open.toStringAsFixed(2) ?? '--'),
                  const SizedBox(height: 4),
                  _buildInfoItem('换手', '待更新'),
                ],
              ),
              const SizedBox(width: 12),
              // 第四列：流通/上证
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoItem('流通', '待更新'),
                  const SizedBox(height: 4),
                  _buildInfoItem('上证', '待更新'),
                ],
              ),
              const SizedBox(width: 12),
              // 第五列：量/金额
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoItem(
                      '量',
                      currentData != null
                          ? _formatVolume(currentData.volume)
                          : '--'),
                  const SizedBox(height: 4),
                  _buildInfoItem('金额', '待更新'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 10, color: AppTheme.muted),
        ),
        const SizedBox(width: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 11),
        ),
      ],
    );
  }

  Widget _buildMarketData() {
    return const SizedBox.shrink();
  }

  String _formatVolume(double volume) {
    if (volume >= 100000000) {
      return '${(volume / 100000000).toStringAsFixed(2)}亿';
    } else if (volume >= 10000) {
      return '${(volume / 10000).toStringAsFixed(2)}万';
    }
    return volume.toStringAsFixed(2);
  }

  String _formatAmount(double amount) {
    if (amount >= 100000000) {
      return '${(amount / 100000000).toStringAsFixed(2)}亿';
    } else if (amount >= 10000) {
      return '${(amount / 10000).toStringAsFixed(2)}万';
    }
    return amount.toStringAsFixed(2);
  }

  Widget _buildPeriodSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.border, width: 0.5)),
      ),
      child: Row(
        children: [
          _buildPeriodDropdown(),
          const SizedBox(width: 16),
          _buildMaSelector(),
        ],
      ),
    );
  }

  Widget _buildPeriodDropdown() {
    return DropdownButton<String>(
      value: _selectedPeriod,
      items: _periods.map((period) {
        return DropdownMenuItem<String>(
          value: period,
          child: Text(period, style: const TextStyle(fontSize: 11)),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _selectedPeriod = value;
            _loadKlineDataForPeriod(value);
          });
        }
      },
      underline: const SizedBox(),
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: AppTheme.accent,
      ),
      icon: const Icon(Icons.arrow_drop_down, size: 14, color: AppTheme.accent),
    );
  }

  Widget _buildMaSelector() {
    final maValues = _getCurrentMaValues();

    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _MaDisplay(label: 'MA5', value: maValues[5], color: Colors.yellow),
          const SizedBox(width: 12),
          _MaDisplay(label: 'MA10', value: maValues[10], color: Colors.purple),
          const SizedBox(width: 12),
          _MaDisplay(label: 'MA20', value: maValues[20], color: Colors.orange),
          const SizedBox(width: 12),
          _MaDisplay(label: 'MA30', value: maValues[30], color: Colors.blue),
        ],
      ),
    );
  }

  Map<int, double> _getCurrentMaValues() {
    final displayData = _displayKlineData;
    final values = <int, double>{};

    for (final ma in [5, 10, 20, 30]) {
      final maData = _calculateMA(displayData, ma);
      values[ma] = maData.isNotEmpty ? maData.last : 0.0;
    }

    return values;
  }

  void _loadKlineDataForPeriod(String period) {
    final timeframe = _getPeriodTimeframe(period);
    setState(() {
      _allKlineData = [];
      _currentDayIndex = 0;
    });
    _loadKlineDataWithTimeframe(timeframe);
  }

  String _getPeriodTimeframe(String period) {
    switch (period) {
      case '日K':
        return 'day';
      case '周K':
        return 'week';
      case '月K':
        return 'month';
      case '季K':
        return 'quarter';
      case '年K':
        return 'year';
      default:
        return 'day';
    }
  }

  Future<void> _loadKlineDataWithTimeframe(String timeframe) async {
    final repository = KlineRepository();
    final data = await repository.fetchKlineData(
      symbol: _currentSymbol,
      timeframe: timeframe,
      limit: _trainingDays,
    );

    setState(() {
      _allKlineData = data;
      _currentDayIndex = 0;
    });
  }

  Widget _buildKlineChart() {
    final displayData = _displayKlineData;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.border, width: 0.5)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove, size: 14),
                onPressed: _zoomOut,
                padding: EdgeInsets.zero,
              ),
              IconButton(
                icon: const Icon(Icons.add, size: 14),
                onPressed: _zoomIn,
                padding: EdgeInsets.zero,
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.arrow_back_ios, size: 10),
                onPressed: _slideLeft,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 20),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios, size: 10),
                onPressed: _slideRight,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 20),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Expanded(
            child: ClipRect(
              child: displayData.isNotEmpty
                  ? KlineChart(
                      klineData: displayData,
                      ma5: _calculateMA(displayData, 5),
                      ma10: _calculateMA(displayData, 10),
                      ma20: _calculateMA(displayData, 20),
                      ma30: _calculateMA(displayData, 30),
                      volumes: _displayVolumes,
                      macdData: _displayMacdData,
                      tradePoints: _visibleTradePoints,
                    )
                  : const Center(child: Text('加载中...')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKlineChartWithoutControls() {
    final displayData = _displayKlineData;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.border, width: 0.5)),
      ),
      child: ClipRect(
        child: displayData.isNotEmpty
            ? KlineChart(
                klineData: displayData,
                ma5: _calculateMA(displayData, 5),
                ma10: _calculateMA(displayData, 10),
                ma20: _calculateMA(displayData, 20),
                ma30: _calculateMA(displayData, 30),
                volumes: _displayVolumes,
                macdData: _displayMacdData,
                tradePoints: _visibleTradePoints,
              )
            : const Center(child: Text('加载中...')),
      ),
    );
  }

  Widget _buildControlButtons() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.border, width: 0.5)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.remove, size: 16),
            onPressed: _zoomOut,
            padding: EdgeInsets.zero,
          ),
          IconButton(
            icon: const Icon(Icons.add, size: 16),
            onPressed: _zoomIn,
            padding: EdgeInsets.zero,
          ),
          const SizedBox(width: 12),
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 12),
            onPressed: _slideLeft,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 24),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios, size: 12),
            onPressed: _slideRight,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 24),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildIndicatorWithSelector(String indicator, bool isTop) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: const BoxDecoration(
            border:
                Border(bottom: BorderSide(color: AppTheme.border, width: 0.5)),
          ),
          child: Row(
            children: [
              Expanded(
                child: DropdownButton<String>(
                  value: indicator,
                  items: _indicators.map((ind) {
                    return DropdownMenuItem<String>(
                      value: ind,
                      child: Text(ind,
                          style: const TextStyle(
                              fontSize: 10, color: Colors.black)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        if (isTop) {
                          _selectedTopIndicator = value;
                        } else {
                          _selectedBottomIndicator = value;
                        }
                      });
                    }
                  },
                  underline: const SizedBox(),
                  style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                  iconSize: 12,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(2),
            child: indicator == '成交量'
                ? _buildVolumeChart()
                : indicator == 'MACD'
                    ? _buildMacdChart()
                    : indicator == 'KDJ'
                        ? _buildKdjChart()
                        : indicator == 'RSI'
                            ? _buildRsiChart()
                            : indicator == 'BOLL'
                                ? _buildBollChart()
                                : indicator == 'WR'
                                    ? _buildWrChart()
                                    : indicator == 'CCI'
                                        ? _buildCciChart()
                                        : indicator == 'OBV'
                                            ? _buildObvChart()
                                            : indicator == 'DMI'
                                                ? _buildDmiChart()
                                                : indicator == 'DMA'
                                                    ? _buildDmaChart()
                                                    : indicator == 'BBI'
                                                        ? _buildBbiChart()
                                                        : const Center(
                                                            child: Text('指标')),
          ),
        ),
      ],
    );
  }

  Widget _buildIndicatorSelector() {
    return Column(
      children: [
        _buildIndicatorSection(_selectedTopIndicator, (value) {
          setState(() {
            _selectedTopIndicator = value;
          });
        }),
        _buildIndicatorSection(_selectedBottomIndicator, (value) {
          setState(() {
            _selectedBottomIndicator = value;
          });
        }),
      ],
    );
  }

  Widget _buildIndicatorSelectorForSingleScreen() {
    return SizedBox(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppTheme.border, width: 0.5)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  const Text('副图1:', style: TextStyle(fontSize: 9)),
                  const SizedBox(width: 3),
                  DropdownButton<String>(
                    value: _selectedTopIndicator,
                    items: _indicators.map((indicator) {
                      return DropdownMenuItem<String>(
                        value: indicator,
                        child: Text(indicator,
                            style: const TextStyle(fontSize: 8)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedTopIndicator = value;
                        });
                      }
                    },
                    underline: const SizedBox(),
                    style: const TextStyle(
                        fontSize: 9, fontWeight: FontWeight.bold),
                    iconSize: 10,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Row(
                children: [
                  const Text('副图2:', style: TextStyle(fontSize: 9)),
                  const SizedBox(width: 3),
                  DropdownButton<String>(
                    value: _selectedBottomIndicator,
                    items: _indicators.map((indicator) {
                      return DropdownMenuItem<String>(
                        value: indicator,
                        child: Text(indicator,
                            style: const TextStyle(fontSize: 8)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedBottomIndicator = value;
                        });
                      }
                    },
                    underline: const SizedBox(),
                    style: const TextStyle(
                        fontSize: 9, fontWeight: FontWeight.bold),
                    iconSize: 10,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIndicatorSection(String selected, Function(String) onChanged) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: const BoxDecoration(
            border:
                Border(bottom: BorderSide(color: AppTheme.border, width: 0.5)),
          ),
          child: Row(
            children: [
              DropdownButton<String>(
                value: selected,
                items: _indicators.map((indicator) {
                  return DropdownMenuItem<String>(
                    value: indicator,
                    child:
                        Text(indicator, style: const TextStyle(fontSize: 14)),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    onChanged(value);
                  }
                },
                underline: const SizedBox(),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const Spacer(),
              if (selected == '成交量')
                Text('量', style: TextStyle(fontSize: 12, color: AppTheme.muted))
              else if (selected == 'MACD')
                Text('(12,26,9)',
                    style: TextStyle(fontSize: 12, color: AppTheme.muted))
              else if (selected == 'KDJ')
                Text('(9,3,3)',
                    style: TextStyle(fontSize: 12, color: AppTheme.muted))
              else if (selected == 'RSI')
                Text('(14)',
                    style: TextStyle(fontSize: 12, color: AppTheme.muted))
              else if (selected == 'BOLL')
                Text('(20)',
                    style: TextStyle(fontSize: 12, color: AppTheme.muted))
              else if (selected == 'WR')
                Text('(14)',
                    style: TextStyle(fontSize: 12, color: AppTheme.muted))
              else if (selected == 'CCI')
                Text('(14)',
                    style: TextStyle(fontSize: 12, color: AppTheme.muted))
              else if (selected == 'OBV')
                Text('(14)',
                    style: TextStyle(fontSize: 12, color: AppTheme.muted))
              else if (selected == 'DMI')
                Text('(14)',
                    style: TextStyle(fontSize: 12, color: AppTheme.muted))
              else if (selected == 'DMA')
                Text('(10,50,10)',
                    style: TextStyle(fontSize: 12, color: AppTheme.muted))
              else if (selected == 'BBI')
                Text('(3,6,12,20)',
                    style: TextStyle(fontSize: 12, color: AppTheme.muted)),
            ],
          ),
        ),
        _buildSingleIndicatorChart(selected),
      ],
    );
  }

  Widget _buildSingleIndicatorChart(String indicator) {
    return SizedBox(
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: const BoxDecoration(
          border:
              Border(bottom: BorderSide(color: AppTheme.border, width: 0.5)),
        ),
        child: indicator == '成交量'
            ? _buildVolumeChart()
            : indicator == 'MACD'
                ? _buildMacdChart()
                : indicator == 'KDJ'
                    ? _buildKdjChart()
                    : indicator == 'RSI'
                        ? _buildRsiChart()
                        : indicator == 'BOLL'
                            ? _buildBollChart()
                            : indicator == 'WR'
                                ? _buildWrChart()
                                : indicator == 'CCI'
                                    ? _buildCciChart()
                                    : indicator == 'OBV'
                                        ? _buildObvChart()
                                        : indicator == 'DMI'
                                            ? _buildDmiChart()
                                            : indicator == 'DMA'
                                                ? _buildDmaChart()
                                                : indicator == 'BBI'
                                                    ? _buildBbiChart()
                                                    : const Center(
                                                        child: Text('指标'),
                                                      ),
      ),
    );
  }

  Widget _buildVolumeChart() {
    if (_displayVolumes.isEmpty) return const SizedBox.expand();
    final maxVolume =
        _displayVolumes.map((v) => v.volume).reduce((a, b) => a > b ? a : b);
    final safeMax = maxVolume > 0 ? maxVolume : 1.0;

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: safeMax * 1.2,
        barTouchData: BarTouchData(enabled: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: safeMax / 4,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey.withOpacity(0.2),
              strokeWidth: 0.5,
            );
          },
        ),
        barGroups: _displayVolumes
            .asMap()
            .entries
            .map(
              (entry) => BarChartGroupData(
                x: entry.key,
                barRods: [
                  BarChartRodData(
                    toY: entry.value.volume,
                    color: entry.value.isUp ? Colors.red : Colors.green,
                    width: 3,
                  ),
                ],
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildMacdChart() {
    if (_displayMacdData.isEmpty) return const SizedBox.expand();

    final values =
        _displayMacdData.expand((m) => [m.macd, m.diff, m.dea]).toList();
    double maxValue =
        values.map((v) => v.abs()).reduce((a, b) => a > b ? a : b);
    final safeMax = maxValue > 0 ? maxValue : 1.0;

    return Stack(
      children: [
        BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: safeMax * 1.2,
            minY: -safeMax * 1.2,
            barTouchData: BarTouchData(enabled: false),
            titlesData: const FlTitlesData(show: false),
            borderData: FlBorderData(show: false),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: safeMax / 2,
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: Colors.grey.withOpacity(0.2),
                  strokeWidth: 0.5,
                );
              },
            ),
            barGroups: _displayMacdData
                .asMap()
                .entries
                .map(
                  (entry) => BarChartGroupData(
                    x: entry.key,
                    barRods: [
                      BarChartRodData(
                        toY: entry.value.macd,
                        color: entry.value.macd > 0 ? Colors.red : Colors.green,
                        width: 2,
                      ),
                    ],
                  ),
                )
                .toList(),
          ),
        ),
        LineChart(
          LineChartData(
            minY: -safeMax * 1.2,
            maxY: safeMax * 1.2,
            lineTouchData: LineTouchData(enabled: false),
            titlesData: const FlTitlesData(show: false),
            borderData: FlBorderData(show: false),
            gridData: const FlGridData(show: false),
            lineBarsData: [
              LineChartBarData(
                spots: _displayMacdData
                    .asMap()
                    .entries
                    .map((e) => FlSpot(e.key.toDouble(), e.value.diff))
                    .toList(),
                isCurved: true,
                color: Colors.blue,
                dotData: const FlDotData(show: false),
                barWidth: 1,
              ),
              LineChartBarData(
                spots: _displayMacdData
                    .asMap()
                    .entries
                    .map((e) => FlSpot(e.key.toDouble(), e.value.dea))
                    .toList(),
                isCurved: true,
                color: Colors.orange,
                dotData: const FlDotData(show: false),
                barWidth: 1,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildKdjChart() {
    if (_displayKdjData.isEmpty) return const SizedBox.expand();

    return LineChart(
      LineChartData(
        minY: 0,
        maxY: 100,
        lineTouchData: LineTouchData(enabled: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 25,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey.withOpacity(0.2),
              strokeWidth: 0.5,
            );
          },
        ),
        lineBarsData: [
          LineChartBarData(
            spots: _displayKdjData
                .asMap()
                .entries
                .map((e) => FlSpot(e.key.toDouble(), e.value.k))
                .toList(),
            isCurved: true,
            color: Colors.yellow,
            dotData: const FlDotData(show: false),
            barWidth: 1.5,
          ),
          LineChartBarData(
            spots: _displayKdjData
                .asMap()
                .entries
                .map((e) => FlSpot(e.key.toDouble(), e.value.d))
                .toList(),
            isCurved: true,
            color: Colors.purple,
            dotData: const FlDotData(show: false),
            barWidth: 1.5,
          ),
          LineChartBarData(
            spots: _displayKdjData
                .asMap()
                .entries
                .map((e) => FlSpot(e.key.toDouble(), e.value.j))
                .toList(),
            isCurved: true,
            color: Colors.red,
            dotData: const FlDotData(show: false),
            barWidth: 1.5,
          ),
        ],
      ),
    );
  }

  Widget _buildRsiChart() {
    if (_displayRsiData.isEmpty) return const SizedBox.expand();

    return LineChart(
      LineChartData(
        minY: 0,
        maxY: 100,
        lineTouchData: LineTouchData(enabled: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 25,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey.withOpacity(0.2),
              strokeWidth: 0.5,
            );
          },
        ),
        lineBarsData: [
          LineChartBarData(
            spots: _displayRsiData
                .asMap()
                .entries
                .map((e) => FlSpot(e.key.toDouble(), e.value.rsi))
                .toList(),
            isCurved: true,
            color: Colors.blue,
            dotData: const FlDotData(show: false),
            barWidth: 1.5,
          ),
        ],
      ),
    );
  }

  Widget _buildBollChart() {
    if (_displayBollData.isEmpty) return const SizedBox.expand();
    final prices = _displayBollData
        .map((e) => [e.upper, e.mid, e.lower])
        .expand((x) => x)
        .toList();
    final minPrice = prices.reduce((a, b) => a < b ? a : b);
    final maxPrice = prices.reduce((a, b) => a > b ? a : b);
    final safeMin = minPrice - (maxPrice - minPrice) * 0.1;
    final safeMax = maxPrice + (maxPrice - minPrice) * 0.1;

    return LineChart(
      LineChartData(
        minY: safeMin,
        maxY: safeMax,
        lineTouchData: LineTouchData(enabled: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: (safeMax - safeMin) / 4,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey.withOpacity(0.2),
              strokeWidth: 0.5,
            );
          },
        ),
        lineBarsData: [
          LineChartBarData(
            spots: _displayBollData
                .asMap()
                .entries
                .map((e) => FlSpot(e.key.toDouble(), e.value.upper))
                .toList(),
            isCurved: true,
            color: Colors.orange,
            dotData: const FlDotData(show: false),
            barWidth: 1,
          ),
          LineChartBarData(
            spots: _displayBollData
                .asMap()
                .entries
                .map((e) => FlSpot(e.key.toDouble(), e.value.mid))
                .toList(),
            isCurved: true,
            color: Colors.purple,
            dotData: const FlDotData(show: false),
            barWidth: 1,
          ),
          LineChartBarData(
            spots: _displayBollData
                .asMap()
                .entries
                .map((e) => FlSpot(e.key.toDouble(), e.value.lower))
                .toList(),
            isCurved: true,
            color: Colors.green,
            dotData: const FlDotData(show: false),
            barWidth: 1,
          ),
        ],
      ),
    );
  }

  Widget _buildWrChart() {
    if (_displayWrData.isEmpty) return const SizedBox.expand();
    final wrValues = _displayWrData;
    final maxWr = 0.0;
    final minWr = -100.0;

    return LineChart(
      LineChartData(
        minY: minWr,
        maxY: maxWr,
        lineTouchData: LineTouchData(enabled: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 25,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey.withOpacity(0.2),
              strokeWidth: 0.5,
            );
          },
        ),
        extraLinesData: ExtraLinesData(
          horizontalLines: [
            HorizontalLine(
              y: -20,
              color: Colors.red.withOpacity(0.5),
              strokeWidth: 0.5,
              dashArray: [5, 5],
            ),
            HorizontalLine(
              y: -80,
              color: Colors.green.withOpacity(0.5),
              strokeWidth: 0.5,
              dashArray: [5, 5],
            ),
          ],
        ),
        lineBarsData: [
          LineChartBarData(
            spots: wrValues
                .asMap()
                .entries
                .map((e) => FlSpot(e.key.toDouble(), -e.value))
                .toList(),
            isCurved: true,
            color: Colors.blue,
            dotData: const FlDotData(show: false),
            barWidth: 1.5,
          ),
        ],
      ),
    );
  }

  Widget _buildCciChart() {
    if (_displayCciData.isEmpty) return const SizedBox.expand();
    final cciValues = _displayCciData;
    final maxCci = 200.0;
    final minCci = -200.0;

    return LineChart(
      LineChartData(
        minY: minCci,
        maxY: maxCci,
        lineTouchData: LineTouchData(enabled: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 100,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey.withOpacity(0.2),
              strokeWidth: 0.5,
            );
          },
        ),
        extraLinesData: ExtraLinesData(
          horizontalLines: [
            HorizontalLine(
              y: 100,
              color: Colors.red.withOpacity(0.5),
              strokeWidth: 0.5,
              dashArray: [5, 5],
            ),
            HorizontalLine(
              y: -100,
              color: Colors.green.withOpacity(0.5),
              strokeWidth: 0.5,
              dashArray: [5, 5],
            ),
          ],
        ),
        lineBarsData: [
          LineChartBarData(
            spots: cciValues
                .asMap()
                .entries
                .map((e) => FlSpot(e.key.toDouble(), e.value))
                .toList(),
            isCurved: true,
            color: Colors.purple,
            dotData: const FlDotData(show: false),
            barWidth: 1.5,
          ),
        ],
      ),
    );
  }

  Widget _buildObvChart() {
    if (_displayObvData.isEmpty) return const SizedBox.expand();
    final obvValues = _displayObvData;
    final maxObv = obvValues.length == 1
        ? obvValues[0]
        : obvValues.reduce((a, b) => a > b ? a : b);
    final minObv = obvValues.length == 1
        ? obvValues[0]
        : obvValues.reduce((a, b) => a < b ? a : b);
    final range = maxObv - minObv;
    final hasRange = range.abs() > 0.0001;
    final safeMin = hasRange ? minObv - range * 0.1 : minObv - 1;
    final safeMax = hasRange ? maxObv + range * 0.1 : maxObv + 1;

    return LineChart(
      LineChartData(
        minY: safeMin,
        maxY: safeMax,
        lineTouchData: LineTouchData(enabled: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: (safeMax - safeMin) / 4,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey.withOpacity(0.2),
              strokeWidth: 0.5,
            );
          },
        ),
        lineBarsData: [
          LineChartBarData(
            spots: obvValues
                .asMap()
                .entries
                .map((e) => FlSpot(e.key.toDouble(), e.value))
                .toList(),
            isCurved: true,
            color: Colors.teal,
            dotData: const FlDotData(show: false),
            barWidth: 1.5,
          ),
        ],
      ),
    );
  }

  Widget _buildDmiChart() {
    if (_displayDmiData.isEmpty) return const SizedBox.expand();
    final dmiValues = _displayDmiData;
    final maxDI = 100.0;
    final minDI = 0.0;

    return LineChart(
      LineChartData(
        minY: minDI,
        maxY: maxDI,
        lineTouchData: LineTouchData(enabled: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 25,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey.withOpacity(0.2),
              strokeWidth: 0.5,
            );
          },
        ),
        lineBarsData: [
          LineChartBarData(
            spots: dmiValues
                .asMap()
                .entries
                .map((e) => FlSpot(e.key.toDouble(), e.value.plusDI))
                .toList(),
            isCurved: true,
            color: Colors.blue,
            dotData: const FlDotData(show: false),
            barWidth: 1,
          ),
          LineChartBarData(
            spots: dmiValues
                .asMap()
                .entries
                .map((e) => FlSpot(e.key.toDouble(), e.value.minusDI))
                .toList(),
            isCurved: true,
            color: Colors.red,
            dotData: const FlDotData(show: false),
            barWidth: 1,
          ),
          LineChartBarData(
            spots: dmiValues
                .asMap()
                .entries
                .map((e) => FlSpot(e.key.toDouble(), e.value.adx))
                .toList(),
            isCurved: true,
            color: Colors.orange,
            dotData: const FlDotData(show: false),
            barWidth: 1,
          ),
        ],
      ),
    );
  }

  Widget _buildDmaChart() {
    if (_displayDmaData.isEmpty) return const SizedBox.expand();
    final dmaValues = _displayDmaData;
    final prices =
        dmaValues.map((e) => [e.dma, e.ama]).expand((x) => x).toList();
    if (prices.isEmpty) return const SizedBox.expand();
    final minPrice =
        prices.length == 1 ? prices[0] : prices.reduce((a, b) => a < b ? a : b);
    final maxPrice =
        prices.length == 1 ? prices[0] : prices.reduce((a, b) => a > b ? a : b);
    final range = maxPrice - minPrice;
    final hasRange = range.abs() > 0.0001;
    final safeMin = hasRange ? minPrice - range * 0.1 : minPrice - 1;
    final safeMax = hasRange ? maxPrice + range * 0.1 : maxPrice + 1;

    return LineChart(
      LineChartData(
        minY: safeMin,
        maxY: safeMax,
        lineTouchData: LineTouchData(enabled: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: (safeMax - safeMin) / 4,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey.withOpacity(0.2),
              strokeWidth: 0.5,
            );
          },
        ),
        lineBarsData: [
          LineChartBarData(
            spots: dmaValues
                .asMap()
                .entries
                .map((e) => FlSpot(e.key.toDouble(), e.value.dma))
                .toList(),
            isCurved: true,
            color: Colors.indigo,
            dotData: const FlDotData(show: false),
            barWidth: 1.5,
          ),
          LineChartBarData(
            spots: dmaValues
                .asMap()
                .entries
                .map((e) => FlSpot(e.key.toDouble(), e.value.ama))
                .toList(),
            isCurved: true,
            color: Colors.amber,
            dotData: const FlDotData(show: false),
            barWidth: 1,
          ),
        ],
      ),
    );
  }

  Widget _buildBbiChart() {
    if (_displayBbiData.isEmpty) return const SizedBox.expand();
    final bbiValues = _displayBbiData;
    final prices = bbiValues;
    if (prices.isEmpty) return const SizedBox.expand();
    final minPrice =
        prices.length == 1 ? prices[0] : prices.reduce((a, b) => a < b ? a : b);
    final maxPrice =
        prices.length == 1 ? prices[0] : prices.reduce((a, b) => a > b ? a : b);
    final range = maxPrice - minPrice;
    final hasRange = range.abs() > 0.0001;
    final safeMin = hasRange ? minPrice - range * 0.1 : minPrice - 1;
    final safeMax = hasRange ? maxPrice + range * 0.1 : maxPrice + 1;

    return LineChart(
      LineChartData(
        minY: safeMin,
        maxY: safeMax,
        lineTouchData: LineTouchData(enabled: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: (safeMax - safeMin) / 4,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey.withOpacity(0.2),
              strokeWidth: 0.5,
            );
          },
        ),
        lineBarsData: [
          LineChartBarData(
            spots: bbiValues
                .asMap()
                .entries
                .map((e) => FlSpot(e.key.toDouble(), e.value))
                .toList(),
            isCurved: true,
            color: Colors.deepOrange,
            dotData: const FlDotData(show: false),
            barWidth: 1.5,
          ),
        ],
      ),
    );
  }

  Widget _buildTradeButtons() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppTheme.border, width: 0.5)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _showStockSelectionDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.surface,
                foregroundColor: AppTheme.muted,
                side: const BorderSide(color: AppTheme.border),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                padding: const EdgeInsets.symmetric(vertical: 6),
              ),
              child: const Text('换股', style: TextStyle(fontSize: 10)),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _showConditionalOrderDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.surface,
                foregroundColor: AppTheme.muted,
                side: const BorderSide(color: AppTheme.border),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                padding: const EdgeInsets.symmetric(vertical: 6),
              ),
              child: const Text('条件单', style: TextStyle(fontSize: 10)),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _showBuyDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                padding: const EdgeInsets.symmetric(vertical: 6),
              ),
              child: const Text('买入', style: TextStyle(fontSize: 10)),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _showSellDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                padding: const EdgeInsets.symmetric(vertical: 6),
              ),
              child: const Text('卖出', style: TextStyle(fontSize: 10)),
            ),
          ),
          const SizedBox(width: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.bg,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              // 计算训练进度，确保不会超过训练天数
              () {
                final day = _currentDayIndex - _historyDays + 1;
                if (day < 1) return '1/$_trainingDays';
                if (day > _trainingDays) return '$_trainingDays/$_trainingDays';
                return '$day/$_trainingDays';
              }(),
              style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.accent),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _nextDay,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                padding: const EdgeInsets.symmetric(vertical: 6),
              ),
              child: const Text('下一步', style: TextStyle(fontSize: 10)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssetInfo() {
    final currentData =
        _allKlineData.isNotEmpty && _currentDayIndex < _allKlineData.length
            ? _allKlineData[_currentDayIndex]
            : null;

    final currentPrice = currentData?.close ?? 0;
    final positionValue = _positionQuantity * currentPrice;
    final currentProfit = _positionQuantity > 0
        ? positionValue - (_positionQuantity * _positionCost)
        : 0.0;
    final currentProfitRatio = _positionQuantity > 0 && _positionCost > 0
        ? (currentProfit / (_positionQuantity * _positionCost)) * 100
        : 0.0;

    final totalAssets = _accountBalance + positionValue;
    final availableAssets = _accountBalance;

    final totalProfitLossRatio = _initialBalance > 0
        ? ((totalAssets - _initialBalance) / _initialBalance) * 100
        : 0.0;

    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppTheme.border, width: 0.5)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              Expanded(
                  child: Center(
                      child: Text('市值',
                          style:
                              TextStyle(fontSize: 9, color: AppTheme.muted)))),
              Expanded(
                  child: Center(
                      child: Text('盈亏',
                          style:
                              TextStyle(fontSize: 9, color: AppTheme.muted)))),
              Expanded(
                  child: Center(
                      child: Text('持仓/可用',
                          style:
                              TextStyle(fontSize: 9, color: AppTheme.muted)))),
              Expanded(
                  child: Center(
                      child: Text('成本/现价',
                          style:
                              TextStyle(fontSize: 9, color: AppTheme.muted)))),
              Expanded(
                  child: Center(
                      child: Text('总资产/可用',
                          style:
                              TextStyle(fontSize: 9, color: AppTheme.muted)))),
              Expanded(
                  child: Center(
                      child: Text('总盈亏',
                          style:
                              TextStyle(fontSize: 9, color: AppTheme.muted)))),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                  child: Center(
                      child: Text('${positionValue.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 10)))),
              Expanded(
                  child: Center(
                      child: Text(
                          '${currentProfit >= 0 ? '+' : ''}${currentProfit.toStringAsFixed(2)}',
                          style: TextStyle(
                              fontSize: 10,
                              color: currentProfit >= 0
                                  ? Colors.red
                                  : Colors.green)))),
              Expanded(
                  child: Center(
                      child: Text('${_positionQuantity.toInt()}',
                          style: const TextStyle(fontSize: 10)))),
              Expanded(
                  child: Center(
                      child: Text('${_positionCost.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 10)))),
              Expanded(
                  child: Center(
                      child: Text('${totalAssets.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 10)))),
              Expanded(
                  child: Center(
                      child: Text(
                          '${_totalProfitLoss >= 0 ? '+' : ''}${_totalProfitLoss.toStringAsFixed(2)}',
                          style: TextStyle(
                              fontSize: 10,
                              color: _totalProfitLoss >= 0
                                  ? Colors.red
                                  : Colors.green)))),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                  child: Center(
                      child: Text('', style: const TextStyle(fontSize: 10)))),
              Expanded(
                  child: Center(
                      child: Text(
                          '${currentProfitRatio >= 0 ? '+' : ''}${currentProfitRatio.toStringAsFixed(2)}%',
                          style: TextStyle(
                              fontSize: 10,
                              color: currentProfitRatio >= 0
                                  ? Colors.red
                                  : Colors.green)))),
              Expanded(
                  child: Center(
                      child: Text('', style: const TextStyle(fontSize: 10)))),
              Expanded(
                  child: Center(
                      child: Text('${currentPrice.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 10)))),
              Expanded(
                  child: Center(
                      child: Text('${availableAssets.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 10)))),
              Expanded(
                  child: Center(
                      child: Text(
                          '${totalProfitLossRatio >= 0 ? '+' : ''}${totalProfitLossRatio.toStringAsFixed(2)}%',
                          style: TextStyle(
                              fontSize: 10,
                              color: totalProfitLossRatio >= 0
                                  ? Colors.red
                                  : Colors.green)))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNextStepButton() {
    return const SizedBox.shrink();
  }

  Widget _buildAccountInfo() {
    final currentData =
        _allKlineData.isNotEmpty && _currentDayIndex < _allKlineData.length
            ? _allKlineData[_currentDayIndex]
            : null;

    final positionValue = _positionQuantity * (currentData?.close ?? 0);
    final profit = _positionQuantity > 0
        ? positionValue - (_positionQuantity * _positionCost)
        : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.border, width: 0.5)),
      ),
      child: Column(
        children: [
          _AccountRow(
              label: '持仓/可用',
              value:
                  '${_positionQuantity.toInt()}股 / ¥${_accountBalance.toStringAsFixed(2)}'),
          _AccountRow(
              label: '成本/现价',
              value:
                  '¥${_positionCost.toStringAsFixed(2)} / ¥${currentData?.close.toStringAsFixed(2) ?? "--"}'),
          _AccountRow(
            label: '市值/盈亏',
            value: '¥${positionValue.toStringAsFixed(2)}',
            highlight: profit >= 0
                ? '+¥${profit.toStringAsFixed(2)}'
                : '-¥${profit.abs().toStringAsFixed(2)}',
            color: profit >= 0 ? Colors.red : Colors.green,
          ),
          _AccountRow(
              label: '总资产',
              value:
                  '¥${(_accountBalance + positionValue).toStringAsFixed(2)}'),
        ],
      ),
    );
  }

  Widget _buildSummaryCards() {
    final currentData =
        _allKlineData.isNotEmpty && _currentDayIndex < _allKlineData.length
            ? _allKlineData[_currentDayIndex]
            : null;
    final positionValue = _positionQuantity * (currentData?.close ?? 0);
    final profit = _positionQuantity > 0
        ? positionValue - (_positionQuantity * _positionCost)
        : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      child: GridView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.5,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        children: [
          _SummaryCard(
              title: '持仓市值', value: '¥${positionValue.toStringAsFixed(2)}'),
          _SummaryCard(
              title: '持仓盈亏',
              value: profit >= 0
                  ? '+¥${profit.toStringAsFixed(2)}'
                  : '-¥${profit.abs().toStringAsFixed(2)}',
              color: profit >= 0 ? Colors.red : Colors.green),
          _SummaryCard(
              title: '总资产',
              value:
                  '¥${(_accountBalance + positionValue).toStringAsFixed(2)}'),
          _SummaryCard(title: '交易次数', value: '${_tradePoints.length ~/ 2}'),
        ],
      ),
    );
  }

  List<double> _calculateMA(List<KlineData> data, int period) {
    final ma = <double>[];
    for (int i = 0; i < data.length; i++) {
      if (i < period - 1) {
        ma.add(0);
      } else {
        double sum = 0;
        for (int j = 0; j < period; j++) {
          sum += data[i - j].close;
        }
        ma.add(sum / period);
      }
    }
    return ma;
  }

  Future<void> _showTrainingCompleteDialog() async {
    final initialBalance = 100000.0;
    final currentData =
        _allKlineData.isNotEmpty ? _allKlineData[_currentDayIndex] : null;
    final positionValue = _positionQuantity * (currentData?.close ?? 0);
    final totalAssets = _accountBalance + positionValue;
    final profit = totalAssets - initialBalance;
    final profitRate = (profit / initialBalance) * 100;

    final firstData =
        _allKlineData.isNotEmpty ? _allKlineData[_historyDays] : null;
    final lastData = currentData;
    final stockIncrease = firstData != null && lastData != null
        ? ((lastData.close - firstData.open) / firstData.open * 100)
        : 0.0;

    await _saveTrainingToDatabase(
        initialBalance, totalAssets, profit, profitRate, stockIncrease);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('结束训练',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 16),
                const Text('本股总收益', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      profit >= 0 ? '收益 +' : '亏损 ',
                      style: TextStyle(
                        color: profit >= 0 ? Colors.red : Colors.green,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '${profit.abs().toStringAsFixed(2)}',
                      style: TextStyle(
                        color: profit >= 0 ? Colors.red : Colors.green,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      ' (${profitRate >= 0 ? '+' : ''}${profitRate.toStringAsFixed(2)}%)',
                      style: TextStyle(
                        color: profitRate >= 0 ? Colors.red : Colors.green,
                        fontSize: 16,
                      ),
                    ),
                    TextButton(
                      onPressed: () => _showTradeDetailDialog(),
                      child: const Text('详情',
                          style: TextStyle(color: Colors.blue, fontSize: 14)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${_getStockName(_currentSymbol)} $_currentSymbol'),
                    const SizedBox(width: 16),
                    TextButton(
                      onPressed: () => _restartTraining(),
                      child: const Text('重新训练',
                          style: TextStyle(color: Colors.blue, fontSize: 14)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '区间涨幅 ${stockIncrease >= 0 ? '+' : ''}${stockIncrease.toStringAsFixed(2)}%',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Text(
                  '训练周期: ${_trainingDays}天',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('复盘'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showStockSelectionDialog();
              },
              child: const Text('换股'),
            ),
          ],
        );
      },
    );
  }

  void _showTradeDetailDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('交易详情',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 8),
                const Text('训练周期内交易记录:', style: TextStyle(fontSize: 14)),
                const SizedBox(height: 8),
                _tradePoints.isEmpty
                    ? const Text('暂无交易记录')
                    : Column(
                        children: _tradePoints.map((point) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  point.isBuy ? '买入' : '卖出',
                                  style: TextStyle(
                                    color:
                                        point.isBuy ? Colors.red : Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text('${point.date.month}/${point.date.day}'),
                                Text('¥${point.price.toStringAsFixed(2)}'),
                                Text('${point.label}'),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                const SizedBox(height: 16),
                const Text('股票区间涨幅:', style: TextStyle(fontSize: 14)),
                const SizedBox(height: 8),
                _buildStockIncreaseInfo(),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('关闭'),
            ),
          ],
        );
      },
    );
  }

  void _restartTraining() {
    Navigator.of(context).pop();
    setState(() {
      _currentDayIndex = _historyDays;
      _tradePoints = [];
      _accountBalance = 100000.0;
      _positionQuantity = 0.0;
      _positionCost = 0.0;
    });
    _loadKlineData();
  }

  Widget _buildStockIncreaseInfo() {
    final firstData =
        _allKlineData.isNotEmpty ? _allKlineData[_historyDays] : null;
    final lastData =
        _allKlineData.isNotEmpty ? _allKlineData[_currentDayIndex] : null;
    final stockIncrease = firstData != null && lastData != null
        ? ((lastData.close - firstData.open) / firstData.open * 100)
        : 0.0;
    return Text(
      '${_getStockName(_currentSymbol)} 区间涨幅: ${stockIncrease >= 0 ? '+' : ''}${stockIncrease.toStringAsFixed(2)}%',
      style: const TextStyle(fontSize: 14),
    );
  }

  Future<void> _saveTrainingToDatabase(
    double initialBalance,
    double totalAssets,
    double profit,
    double profitRate,
    double stockIncrease,
  ) async {
    final logger = Logger();
    try {
      logger.d('开始保存训练会话到数据库');
      final dbService = DatabaseService.instance;
      final klineSyncService = KlineDataSyncService();

      final firstData =
          _allKlineData.isNotEmpty ? _allKlineData[_historyDays] : null;
      final lastData =
          _allKlineData.isNotEmpty ? _allKlineData[_currentDayIndex] : null;

      logger.d('准备创建训练会话: symbol=$_currentSymbol, '
          'klineCount=${_allKlineData.length}, tradeCount=${_tradePoints.length}');

      final sessionId =
          await dbService.trainingDao.createSession(TrainingSessionsCompanion(
        userId: const Value(1),
        symbol: Value(_currentSymbol),
        marketCode: Value(_currentSymbol.startsWith('SH') ? 'SH' : 'SZ'),
        period: Value('day'),
        startDate:
            Value(firstData != null ? firstData.dateTime : DateTime.now()),
        endDate: Value(lastData != null ? lastData.dateTime : DateTime.now()),
        initialCapital: Value(initialBalance),
        currentCapital: Value(totalAssets),
        totalProfit: Value(profit),
        profitRate: Value(profitRate),
        tradeCount: Value(_tradePoints.length),
        winCount: Value(_calculateWinCount()),
        winRate: Value(_calculateWinRate()),
        status: const Value('finished'),
        startTime:
            firstData != null ? Value(firstData.dateTime) : Value.absent(),
        endTime: lastData != null ? Value(lastData.dateTime) : Value.absent(),
      ));

      logger.d('训练会话创建成功: sessionId=$sessionId');

      // 直接把内存中的K线数据保存到数据库（不从API获取）
      if (_allKlineData.isNotEmpty) {
        logger.d('开始保存K线数据: count=${_allKlineData.length}');
        final saveSuccess = await klineSyncService.saveKlineDataToDatabase(
          symbol: _currentSymbol,
          marketCode: _currentSymbol.startsWith('SH') ? 'SH' : 'SZ',
          period: 'day',
          klineData: _allKlineData,
        );
        logger.d('K线数据保存结果: success=$saveSuccess');
      } else {
        logger.w('⚠️ _allKlineData 为空，无法保存K线数据！');
      }

      logger.d('开始保存交易记录: count=${_tradePoints.length}');
      for (final point in _tradePoints) {
        await dbService.trainingDao.addTrade(TradesCompanion(
          sessionId: Value(sessionId),
          userId: const Value(1),
          symbol: Value(_currentSymbol),
          marketCode: Value(_currentSymbol.startsWith('SH') ? 'SH' : 'SZ'),
          type: Value(point.isBuy ? 'buy' : 'sell'),
          price: Value(point.price),
          quantity: Value(point.label.contains('股')
              ? int.parse(point.label.replaceAll(RegExp(r'[^0-9]'), ''))
              : 0),
          amount: Value(point.price *
              (point.label.contains('股')
                  ? int.parse(point.label.replaceAll(RegExp(r'[^0-9]'), ''))
                  : 0)),
          tradeDate: Value(point.date.toIso8601String()),
          triggerSource: const Value('manual'),
        ));
      }
      logger.d('交易记录保存完成');
    } catch (e, stackTrace) {
      logger.e('⛔ 保存训练会话失败: $e', error: e, stackTrace: stackTrace);
    }
  }

  int _calculateWinCount() {
    int winCount = 0;
    double cost = 0;
    double position = 0;

    for (final point in _tradePoints) {
      if (point.isBuy) {
        cost = point.price;
        position = double.parse(point.label.replaceAll(RegExp(r'[^0-9.]'), ''));
      } else {
        if (position > 0 && point.price > cost) {
          winCount++;
        }
        position = 0;
      }
    }
    return winCount;
  }

  double _calculateWinRate() {
    if (_tradePoints.isEmpty) return 0.0;
    final sellCount = _tradePoints.where((p) => !p.isBuy).length;
    if (sellCount == 0) return 0.0;
    return (_calculateWinCount() / sellCount) * 100;
  }

  String _getStockName(String symbol) {
    final names = {
      'SH600000': '浦发银行',
      'SH600036': '招商银行',
      'SH600519': '贵州茅台',
      'SH601318': '中国平安',
      'SZ300750': '宁德时代',
      'SZ002594': '比亚迪',
    };
    return names[symbol] ?? symbol;
  }
}

class _MarketDataItem extends StatelessWidget {
  final String label;
  final String value;

  const _MarketDataItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: AppTheme.muted)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }
}

class _AccountRow extends StatelessWidget {
  final String label;
  final String value;
  final String? highlight;
  final Color? color;

  const _AccountRow({
    required this.label,
    required this.value,
    this.highlight,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
              width: 100,
              child: Text(label, style: TextStyle(color: AppTheme.muted))),
          const SizedBox(width: 16),
          Expanded(child: Text(value, style: TextStyle(color: color))),
          if (highlight != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: (color ?? Colors.red).withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(highlight!,
                  style: TextStyle(color: color ?? Colors.red, fontSize: 12)),
            ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final Color? color;

  const _SummaryCard({required this.title, required this.value, this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 12, color: AppTheme.muted)),
            const SizedBox(height: 8),
            Text(value,
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }
}

class _StockSelectionSheet extends ConsumerStatefulWidget {
  final Function(String) onSelect;

  const _StockSelectionSheet({required this.onSelect});

  @override
  ConsumerState<_StockSelectionSheet> createState() =>
      _StockSelectionSheetState();
}

class _StockSelectionSheetState extends ConsumerState<_StockSelectionSheet> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadStocks();
    });
  }

  Future<void> _loadStocks() async {
    final now = DateTime.now();
    final oneYearAgo = DateTime(now.year - 1, now.month, now.day);

    await ref.read(battleStockProvider.notifier).loadStocks(
          condition: StockFilterCondition.random,
          startDate: oneYearAgo,
          endDate: now,
        );
  }

  @override
  Widget build(BuildContext context) {
    final stockState = ref.watch(battleStockProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('选择股票',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          if (stockState.isLoading)
            const Center(child: CircularProgressIndicator())
          else if (stockState.error != null)
            Center(
              child: Column(
                children: [
                  Text(stockState.error!,
                      style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _loadStocks,
                    child: const Text('重试'),
                  ),
                ],
              ),
            )
          else if (stockState.stocks.isEmpty)
            const Center(child: Text('暂无股票数据'))
          else
            ...stockState.stocks.map((stock) => ListTile(
                  title: Text(stock.symbolName),
                  subtitle: Text('${stock.marketCode}${stock.symbol}'),
                  trailing: Text(
                    '¥${stock.closePrice.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    widget.onSelect(stock.symbol);
                    ref.read(battleStockProvider.notifier).selectStock(stock);
                  },
                )),
        ],
      ),
    );
  }
}

class _ConditionalOrderSheet extends StatefulWidget {
  final double currentPrice;
  final Function(String type, Map<String, dynamic> params) onConfirm;

  const _ConditionalOrderSheet({
    required this.currentPrice,
    required this.onConfirm,
  });

  @override
  State<_ConditionalOrderSheet> createState() => _ConditionalOrderSheetState();
}

class _ConditionalOrderSheetState extends State<_ConditionalOrderSheet> {
  String _orderType = '止盈止损';
  final _stopProfitController = TextEditingController();
  final _stopLossController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _stopProfitController.text = (widget.currentPrice * 1.1).toStringAsFixed(2);
    _stopLossController.text = (widget.currentPrice * 0.9).toStringAsFixed(2);
  }

  @override
  void dispose() {
    _stopProfitController.dispose();
    _stopLossController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('条件单设置',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            children: ['止盈止损', '价格条件', '技术指标']
                .map(
                  (type) => ChoiceChip(
                    label: Text(type),
                    selected: _orderType == type,
                    onSelected: (selected) {
                      setState(() {
                        _orderType = type;
                      });
                    },
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 16),
          if (_orderType == '止盈止损') ...[
            TextField(
              controller: _stopProfitController,
              decoration: const InputDecoration(
                labelText: '止盈价格',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _stopLossController,
              decoration: const InputDecoration(
                labelText: '止损价格',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                widget.onConfirm(_orderType, {
                  'stopProfit': double.tryParse(_stopProfitController.text),
                  'stopLoss': double.tryParse(_stopLossController.text),
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accent,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('确认设置'),
            ),
          ),
        ],
      ),
    );
  }
}

class _TradeDialog extends StatefulWidget {
  final String title;
  final double currentPrice;
  final double maxQuantity;
  final double accountBalance;
  final double? positionQuantity;
  final double? positionCost;
  final Function(double price, double quantity) onConfirm;

  const _TradeDialog({
    required this.title,
    required this.currentPrice,
    required this.maxQuantity,
    required this.accountBalance,
    this.positionQuantity,
    this.positionCost,
    required this.onConfirm,
  });

  @override
  State<_TradeDialog> createState() => _TradeDialogState();
}

class _TradeDialogState extends State<_TradeDialog> {
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();
  double _selectedQuantity = 0;

  @override
  void initState() {
    super.initState();
    _priceController.text = widget.currentPrice.toStringAsFixed(2);
    _quantityController.text = widget.maxQuantity.toString();
    _selectedQuantity = widget.maxQuantity;
  }

  @override
  void dispose() {
    _priceController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _setPositionRatio(double ratio) {
    double quantity;
    if (widget.title == '买入') {
      final maxBuy =
          (widget.accountBalance / widget.currentPrice / 100).floor() * 100;
      quantity = (maxBuy * ratio).floorToDouble();
    } else {
      quantity = ((widget.positionQuantity ?? 0) * ratio).floorToDouble();
    }
    quantity = (quantity / 100).floor() * 100;
    setState(() {
      _selectedQuantity = quantity.clamp(0, widget.maxQuantity);
      _quantityController.text = _selectedQuantity.toString();
    });
  }

  void _showPositionSettingDialog() {
    showDialog(
      context: context,
      builder: (context) => _PositionSettingDialog(tradeType: widget.title),
    );
  }

  void _onConfirm() {
    final price = double.tryParse(_priceController.text) ?? widget.currentPrice;
    final quantity =
        double.tryParse(_quantityController.text) ?? _selectedQuantity;

    if (quantity <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入有效的数量')),
      );
      return;
    }

    widget.onConfirm(price, quantity);
  }

  @override
  Widget build(BuildContext context) {
    final price = double.tryParse(_priceController.text) ?? widget.currentPrice;
    final quantity = double.tryParse(_quantityController.text) ?? 0;
    final total = price * quantity;

    return Container(
      padding: EdgeInsets.fromLTRB(
          16, 16, 16, MediaQuery.of(context).viewInsets.bottom + 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(widget.title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _priceController,
            decoration: InputDecoration(
              labelText: '${widget.title}价格',
              border: const OutlineInputBorder(),
              suffixText: '当前价: ${widget.currentPrice.toStringAsFixed(2)}',
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {});
            },
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _quantityController,
            decoration: InputDecoration(
              labelText: '${widget.title}数量',
              border: const OutlineInputBorder(),
              suffixText: '最大: ${widget.maxQuantity.toInt()}股',
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                _selectedQuantity = double.tryParse(value) ?? 0;
              });
            },
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              TextButton(
                onPressed: () => _setPositionRatio(1),
                style: TextButton.styleFrom(
                  foregroundColor: AppTheme.accent,
                  side: const BorderSide(color: AppTheme.accent),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                child: const Text('全仓'),
              ),
              TextButton(
                onPressed: () => _setPositionRatio(1 / 2),
                style: TextButton.styleFrom(
                  foregroundColor: AppTheme.accent,
                  side: const BorderSide(color: AppTheme.accent),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                child: const Text('1/2仓'),
              ),
              TextButton(
                onPressed: () => _setPositionRatio(1 / 3),
                style: TextButton.styleFrom(
                  foregroundColor: AppTheme.accent,
                  side: const BorderSide(color: AppTheme.accent),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                child: const Text('1/3仓'),
              ),
              TextButton(
                onPressed: () => _setPositionRatio(1 / 4),
                style: TextButton.styleFrom(
                  foregroundColor: AppTheme.accent,
                  side: const BorderSide(color: AppTheme.accent),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                child: const Text('1/4仓'),
              ),
              TextButton(
                onPressed: () => _setPositionRatio(2 / 3),
                style: TextButton.styleFrom(
                  foregroundColor: AppTheme.accent,
                  side: const BorderSide(color: AppTheme.accent),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                child: const Text('2/3仓'),
              ),
              TextButton(
                onPressed: () => _showPositionSettingDialog(),
                style: TextButton.styleFrom(
                  foregroundColor: AppTheme.accent,
                  side: const BorderSide(color: AppTheme.accent),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                child: const Text('编辑'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Text('${widget.title}金额:'),
                const SizedBox(width: 16),
                Text(
                  '¥${total.toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ),
              ],
            ),
          ),
          if (widget.title == '卖出' && widget.positionCost != null)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              margin: const EdgeInsets.only(top: 4),
              child: Row(
                children: [
                  const Text('预计盈亏:'),
                  const SizedBox(width: 16),
                  Text(
                    total >= (widget.positionCost! * quantity)
                        ? '+¥${(total - widget.positionCost! * quantity).toStringAsFixed(2)}'
                        : '-¥${((widget.positionCost! * quantity) - total).toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: total >= (widget.positionCost! * quantity)
                          ? Colors.red
                          : Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.surface,
                    foregroundColor: AppTheme.muted,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('取消'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _onConfirm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        widget.title == '买入' ? Colors.red : Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('确认'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PositionItem {
  final String id;
  final String label;
  final double ratio;

  PositionItem({
    required this.id,
    required this.label,
    required this.ratio,
  });

  PositionItem copyWith({
    String? id,
    String? label,
    double? ratio,
  }) {
    return PositionItem(
      id: id ?? this.id,
      label: label ?? this.label,
      ratio: ratio ?? this.ratio,
    );
  }
}

class _PositionSettingDialog extends StatefulWidget {
  final String tradeType;

  const _PositionSettingDialog({required this.tradeType});

  @override
  State<_PositionSettingDialog> createState() => _PositionSettingDialogState();
}

class _PositionSettingDialogState extends State<_PositionSettingDialog> {
  bool _isBuyTab = true;
  List<PositionItem> _buyPositions = [
    PositionItem(id: '1', label: '全仓', ratio: 1.0),
    PositionItem(id: '2', label: '1/2仓', ratio: 1 / 2),
    PositionItem(id: '3', label: '1/3仓', ratio: 1 / 3),
    PositionItem(id: '4', label: '1/4仓', ratio: 1 / 4),
    PositionItem(id: '5', label: '2/3仓', ratio: 2 / 3),
  ];
  List<PositionItem> _sellPositions = [
    PositionItem(id: '1', label: '全仓', ratio: 1.0),
    PositionItem(id: '2', label: '1/2仓', ratio: 1 / 2),
    PositionItem(id: '3', label: '1/3仓', ratio: 1 / 3),
    PositionItem(id: '4', label: '1/4仓', ratio: 1 / 4),
    PositionItem(id: '5', label: '2/3仓', ratio: 2 / 3),
  ];
  bool _skipConfirm = false;
  int _dragIndex = -1;

  List<PositionItem> get _currentPositions =>
      _isBuyTab ? _buyPositions : _sellPositions;

  set _currentPositions(List<PositionItem> value) {
    if (_isBuyTab) {
      _buyPositions = value;
    } else {
      _sellPositions = value;
    }
  }

  void _removePosition(int index) {
    if (_currentPositions.length > 1) {
      setState(() {
        _currentPositions = List.from(_currentPositions)..removeAt(index);
      });
    }
  }

  void _addPosition() {
    if (_currentPositions.length < 12) {
      final newRatio = 1.0 / (_currentPositions.length + 1);
      final newLabel = '1/${_currentPositions.length + 1}仓';
      setState(() {
        _currentPositions = List.from(_currentPositions)
          ..add(PositionItem(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            label: newLabel,
            ratio: newRatio,
          ));
      });
    }
  }

  void _movePosition(int fromIndex, int toIndex) {
    setState(() {
      final List<PositionItem> positions = List.from(_currentPositions);
      final item = positions.removeAt(fromIndex);
      positions.insert(toIndex, item);
      _currentPositions = positions;
    });
  }

  void _resetToDefault() {
    setState(() {
      _buyPositions = [
        PositionItem(id: '1', label: '全仓', ratio: 1.0),
        PositionItem(id: '2', label: '1/2仓', ratio: 1 / 2),
        PositionItem(id: '3', label: '1/3仓', ratio: 1 / 3),
        PositionItem(id: '4', label: '1/4仓', ratio: 1 / 4),
        PositionItem(id: '5', label: '2/3仓', ratio: 2 / 3),
      ];
      _sellPositions = [
        PositionItem(id: '1', label: '全仓', ratio: 1.0),
        PositionItem(id: '2', label: '1/2仓', ratio: 1 / 2),
        PositionItem(id: '3', label: '1/3仓', ratio: 1 / 3),
        PositionItem(id: '4', label: '1/4仓', ratio: 1 / 4),
        PositionItem(id: '5', label: '2/3仓', ratio: 2 / 3),
      ];
      _skipConfirm = false;
    });
  }

  void _savePositions() {
    Navigator.pop(context);
  }

  void _handleDragStart(int index) {
    setState(() {
      _dragIndex = index;
    });
  }

  void _handleDragEnd() {
    setState(() {
      _dragIndex = -1;
    });
  }

  void _handleDragCancel() {
    setState(() {
      _dragIndex = -1;
    });
  }

  void _handleDragUpdate(int oldIndex, int newIndex) {
    if (oldIndex != newIndex) {
      _movePosition(oldIndex, newIndex);
    }
  }

  Widget _buildPositionChip(int index) {
    final item = _currentPositions[index];
    return Draggable<int>(
      data: index,
      feedback: Material(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppTheme.accent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            item.label,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
      childWhenDragging: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.accent),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Text(''),
      ),
      onDragStarted: () => _handleDragStart(index),
      onDragEnd: (_) => _handleDragEnd(),
      onDraggableCanceled: (_, __) => _handleDragCancel(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.accent),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(item.label),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.close, size: 14),
              onPressed: () => _removePosition(index),
              padding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 360,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '仓位设置',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppTheme.border),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _isBuyTab = true),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color:
                              _isBuyTab ? AppTheme.accent : Colors.transparent,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(8),
                            bottomLeft: Radius.circular(8),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '买入仓位',
                          style: TextStyle(
                            color: _isBuyTab ? Colors.white : AppTheme.muted,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _isBuyTab = false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color:
                              !_isBuyTab ? AppTheme.accent : Colors.transparent,
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '卖出仓位',
                          style: TextStyle(
                            color: !_isBuyTab ? Colors.white : AppTheme.muted,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '拖动按钮可以排序，最多可拥有12个仓位，默认按第1个仓位买入',
              style: TextStyle(fontSize: 12, color: AppTheme.muted),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(_currentPositions.length, (index) {
                return DragTarget<int>(
                  onAccept: (data) {
                    if (data != index) {
                      _handleDragUpdate(data, index);
                    }
                  },
                  builder: (context, candidateData, rejectedData) {
                    return _buildPositionChip(index);
                  },
                );
              }),
            ),
            const SizedBox(height: 8),
            if (_currentPositions.length < 12)
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.accent),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addPosition,
                  padding: EdgeInsets.zero,
                ),
              ),
            const SizedBox(height: 20),
            CheckboxListTile(
              title: const Text('买入时不弹确认框'),
              value: _skipConfirm,
              onChanged: (value) => setState(() => _skipConfirm = value!),
              controlAffinity: ListTileControlAffinity.leading,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _resetToDefault,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.surface,
                      foregroundColor: AppTheme.muted,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('默认值'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _savePositions,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.accent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('保存买入仓位'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MaDisplay extends StatelessWidget {
  final String label;
  final double? value;
  final Color color;

  const _MaDisplay({
    required this.label,
    this.value,
    this.color = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        if (value != null && value! > 0)
          Row(
            children: [
              const SizedBox(width: 3),
              Text(
                '${value!.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 9,
                  color: color,
                ),
              ),
            ],
          ),
      ],
    );
  }
}

class KdjData {
  final double k;
  final double d;
  final double j;

  KdjData({required this.k, required this.d, required this.j});
}

class RsiData {
  final double rsi;

  RsiData({required this.rsi});
}

class BollData {
  final double upper;
  final double mid;
  final double lower;

  BollData({required this.upper, required this.mid, required this.lower});
}
