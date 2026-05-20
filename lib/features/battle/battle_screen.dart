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
import 'package:kline_trainer/providers/battle_stock_provider.dart';
import 'package:kline_trainer/core/enums/stock_filter_condition.dart';
import 'package:drift/drift.dart' show Value;

class BattleScreen extends ConsumerStatefulWidget {
  const BattleScreen({super.key});

  @override
  ConsumerState<BattleScreen> createState() => _BattleScreenState();
}

class _BattleScreenState extends ConsumerState<BattleScreen> {
  int _selectedIndex = 1;
  String _selectedPeriod = '日K';
  String _selectedTopIndicator = '成交量';
  String _selectedBottomIndicator = 'MACD';
  int _currentDayIndex = 0;
  int _trainingDays = 150;
  final int _historyDays = 30;
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
    final totalDays = _trainingDays + _historyDays;

    List<KlineModel> data;

    if (_trainingStartDate != null) {
      final startTime =
          _trainingStartDate!.subtract(Duration(days: _historyDays));
      final endTime = _trainingStartDate!.add(Duration(days: _trainingDays));

      data = await repository.fetchKlineDataFromDbWithDateRange(
        symbol: _currentSymbol,
        period: 'day',
        startTime: startTime,
        endTime: endTime,
      );
    } else {
      data = await repository.fetchKlineDataFromDb(
        symbol: _currentSymbol,
        period: 'day',
        limit: totalDays,
      );
    }

    if (data.isEmpty) {
      data = await repository.fetchKlineData(
        symbol: _currentSymbol,
        timeframe: 'day',
        limit: totalDays,
      );
    }

    setState(() {
      _allKlineData = data;
      _currentDayIndex = _historyDays;
      _tradePoints = [];
      final endIndex = _currentDayIndex + 1;
      _visibleStartIndex = (endIndex - _visibleKlineCount).clamp(0, endIndex);
    });
  }

  void _nextDay() {
    if (_currentDayIndex < _allKlineData.length - 1) {
      setState(() {
        _currentDayIndex++;
        final endIndex = _currentDayIndex + 1;
        final maxStart = (endIndex - _visibleKlineCount).clamp(0, endIndex);
        _visibleStartIndex = maxStart;
        _checkConditionalOrders();
        _updateAccount();
      });
    } else {
      _showTrainingCompleteDialog();
    }
  }

  void _checkConditionalOrders() {}

  void _updateAccount() {
    if (_positionQuantity > 0 && _allKlineData.isNotEmpty) {}
  }

  void _zoomIn() {
    setState(() {
      _zoomScale = (_zoomScale * 1.2).clamp(0.5, 3.0);
      _updateVisibleRange();
    });
  }

  void _zoomOut() {
    setState(() {
      _zoomScale = (_zoomScale / 1.2).clamp(0.5, 3.0);
      _updateVisibleRange();
    });
  }

  void _updateVisibleRange() {
    final baseCount = 20;
    _visibleKlineCount = (baseCount / _zoomScale).round().clamp(10, 40);
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
    final endIndex = (_currentDayIndex + 1).clamp(0, _allKlineData.length);
    final maxStart = (endIndex - _visibleKlineCount).clamp(0, endIndex);
    final startIndex = _visibleStartIndex.clamp(0, maxStart);
    final displayData = _allKlineData.take(endIndex).toList();

    final macdResult = IndicatorCalculator.calculateMACD(displayData);
    final paddingCount = displayData.length - macdResult.macd.length;

    final result = <MacdData>[];
    for (int i = 0; i < paddingCount; i++) {
      result.add(MacdData(macd: 0, diff: 0, dea: 0));
    }
    for (int i = 0; i < macdResult.macd.length; i++) {
      result.add(MacdData(
        macd: macdResult.macd[i],
        diff: macdResult.dif[i],
        dea: macdResult.dea[i],
      ));
    }

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
    final displayData = _allKlineData.take(endIndex).toList();

    final kdjResult = IndicatorCalculator.calculateKDJ(displayData);
    final paddingCount = displayData.length - kdjResult.k.length;

    final result = <KdjData>[];
    for (int i = 0; i < paddingCount; i++) {
      result.add(KdjData(k: 50, d: 50, j: 50));
    }
    for (int i = 0; i < kdjResult.k.length; i++) {
      result.add(KdjData(
        k: kdjResult.k[i],
        d: kdjResult.d[i],
        j: kdjResult.j[i],
      ));
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
    final displayData = _allKlineData.take(endIndex).toList();

    final rsiResult = IndicatorCalculator.calculateRSI(displayData);
    final paddingCount = displayData.length - rsiResult.values.length;

    final result = <RsiData>[];
    for (int i = 0; i < paddingCount; i++) {
      result.add(RsiData(rsi: 50));
    }
    for (int i = 0; i < rsiResult.values.length; i++) {
      result.add(RsiData(rsi: rsiResult.values[i]));
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
    final displayData = _allKlineData.take(endIndex).toList();

    final bollResult = IndicatorCalculator.calculateBoll(displayData);
    final paddingCount = displayData.length - bollResult.mb.length;

    final result = <BollData>[];
    for (int i = 0; i < paddingCount; i++) {
      final currentData = displayData[i];
      result.add(BollData(
        upper: currentData.close * 1.02,
        mid: currentData.close,
        lower: currentData.close * 0.98,
      ));
    }
    for (int i = 0; i < bollResult.mb.length; i++) {
      result.add(BollData(
        upper: bollResult.up[i],
        mid: bollResult.mb[i],
        lower: bollResult.dn[i],
      ));
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
    final displayData = _allKlineData.take(endIndex).toList();

    final wrResult = IndicatorCalculator.calculateWR(displayData);
    final paddingCount = displayData.length - wrResult.values.length;

    final result = <double>[];
    for (int i = 0; i < paddingCount; i++) {
      result.add(50.0);
    }
    for (int i = 0; i < wrResult.values.length; i++) {
      result.add(wrResult.values[i]);
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
    final displayData = _allKlineData.take(endIndex).toList();

    final cciResult = IndicatorCalculator.calculateCCI(displayData);
    final paddingCount = displayData.length - cciResult.values.length;

    final result = <double>[];
    for (int i = 0; i < paddingCount; i++) {
      result.add(0.0);
    }
    for (int i = 0; i < cciResult.values.length; i++) {
      result.add(cciResult.values[i]);
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
    final displayData = _allKlineData.take(endIndex).toList();

    final obvResult = IndicatorCalculator.calculateOBV(displayData);
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
    final displayData = _allKlineData.take(endIndex).toList();

    final dmiResult = IndicatorCalculator.calculateDMI(displayData);
    final paddingCount = displayData.length - dmiResult.plusDI.length;

    final result = <DmiData>[];
    for (int i = 0; i < paddingCount; i++) {
      result.add(DmiData(plusDI: 0, minusDI: 0, adx: 0));
    }
    for (int i = 0; i < dmiResult.plusDI.length; i++) {
      final double adxValue = i < dmiResult.adx.length ? dmiResult.adx[i] : 0.0;
      result.add(DmiData(
        plusDI: dmiResult.plusDI[i],
        minusDI: dmiResult.minusDI[i],
        adx: adxValue,
      ));
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
    final displayData = _allKlineData.take(endIndex).toList();

    final dmaResult = IndicatorCalculator.calculateDMA(displayData);
    final paddingCount = displayData.length - dmaResult.dma.length;

    final result = <DmaData>[];
    for (int i = 0; i < paddingCount; i++) {
      result.add(DmaData(dma: 0, ama: 0));
    }
    for (int i = 0; i < dmaResult.dma.length; i++) {
      final double amaValue = i < dmaResult.ama.length ? dmaResult.ama[i] : 0.0;
      result.add(DmaData(dma: dmaResult.dma[i], ama: amaValue));
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
    final displayData = _allKlineData.take(endIndex).toList();

    final bbiResult = IndicatorCalculator.calculateBBI(displayData);
    final paddingCount = displayData.length - bbiResult.values.length;

    final result = <double>[];
    for (int i = 0; i < paddingCount; i++) {
      result.add(0.0);
    }
    for (int i = 0; i < bbiResult.values.length; i++) {
      result.add(bbiResult.values[i]);
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
            Expanded(
              child: Column(
                children: [
                  _buildStockInfo(),
                  _buildMarketData(),
                  _buildPeriodSelector(),
                  Expanded(
                    child: _buildKlineChartWithoutControls(),
                  ),
                  _buildControlButtons(),
                  _buildIndicatorWithSelector(_selectedTopIndicator, true),
                  _buildIndicatorWithSelector(_selectedBottomIndicator, false),
                ],
              ),
            ),
            _buildTradeButtons(),
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
              Text(
                '${(_zoomScale * 100).round()}%',
                style:
                    const TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
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
      height: 32,
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
          Text(
            '${(_zoomScale * 100).round()}%',
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
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
    return SizedBox(
      height: 60,
      child: Column(
        children: [
          Container(
            height: 22,
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: const BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: AppTheme.border, width: 0.5)),
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
                                                              child:
                                                                  Text('指标')),
            ),
          ),
        ],
      ),
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
      height: 28,
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
      height: 50,
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
      height: 36,
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
              '${_currentDayIndex - _historyDays + 1}/$_trainingDays',
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

  void _showTrainingCompleteDialog() {
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

    _saveTrainingToDatabase(
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
    try {
      final dbService = DatabaseService.instance;

      final firstData =
          _allKlineData.isNotEmpty ? _allKlineData[_historyDays] : null;
      final lastData =
          _allKlineData.isNotEmpty ? _allKlineData[_currentDayIndex] : null;

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
    } catch (e) {
      // 保存失败不影响用户体验，只记录日志
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
          Row(
            children: [
              const Text('仓位:'),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () => _setPositionRatio(1 / 3),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: AppTheme.accent,
                  side: const BorderSide(color: AppTheme.accent),
                ),
                child: const Text('1/3仓'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () => _setPositionRatio(1 / 2),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: AppTheme.accent,
                  side: const BorderSide(color: AppTheme.accent),
                ),
                child: const Text('1/2仓'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () => _setPositionRatio(1),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: AppTheme.accent,
                  side: const BorderSide(color: AppTheme.accent),
                ),
                child: const Text('全仓'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.bg,
              borderRadius: BorderRadius.circular(8),
            ),
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
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                color: AppTheme.bg,
                borderRadius: BorderRadius.circular(8),
              ),
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
