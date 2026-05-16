import 'dart:async';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kline_trainer/theme/app_theme.dart';
import 'package:kline_trainer/features/training/widgets/kline_chart.dart';
import 'package:kline_trainer/data/repositories/kline_repository.dart';
import 'package:kline_trainer/data/models/kline_model.dart' show KlineModel, KdjData, RsiData, BollData;
import 'package:kline_trainer/data/utils/indicator_calculator.dart';

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
  int _trainingDays = 60;

  final List<String> _periods = ['日K', '周K', '月K', '季K', '年K'];
  final List<String> _indicators = ['成交量', 'MACD', 'KDJ', 'RSI', 'BOLL'];

  String _currentSymbol = 'SH600000';
  List<KlineModel> _allKlineData = [];
  List<TradePoint> _tradePoints = [];

  double _accountBalance = 100000.0;
  double _positionQuantity = 0.0;
  double _positionCost = 0.0;

  @override
  void initState() {
    super.initState();
    _loadKlineData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadKlineData() async {
    final repository = KlineRepository();
    const historyDays = 30;
    final data = await repository.fetchKlineData(
      symbol: _currentSymbol,
      timeframe: 'day',
      limit: _trainingDays + historyDays,
    );

    setState(() {
      _allKlineData = data;
      _currentDayIndex = historyDays;
      _tradePoints = [];
    });
  }

  void _nextDay() {
    if (_currentDayIndex < _allKlineData.length - 1) {
      setState(() {
        _currentDayIndex++;
        _checkConditionalOrders();
        _updateAccount();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('已到达最后一天')),
      );
    }
  }

  void _checkConditionalOrders() {
  }

  void _updateAccount() {
    if (_positionQuantity > 0 && _allKlineData.isNotEmpty) {
    }
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
    return _allKlineData
        .take(endIndex)
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

  List<VolumeData> get _displayVolumes {
    if (_allKlineData.isEmpty) return [];
    final endIndex = (_currentDayIndex + 1).clamp(0, _allKlineData.length);
    return _allKlineData
        .take(endIndex)
        .map((e) => VolumeData(volume: e.volume, isUp: e.isUp))
        .toList();
  }

  List<MacdData> get _displayMacdData {
    if (_allKlineData.isEmpty) return [];
    final endIndex = (_currentDayIndex + 1).clamp(0, _allKlineData.length);
    final displayData = _allKlineData.take(endIndex).toList();
    
    final macdResult = IndicatorCalculator.calculateMACD(displayData);
    final paddingCount = endIndex - macdResult.macd.length;
    
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
    
    return result;
  }

  List<KdjData> get _displayKdjData {
    if (_allKlineData.isEmpty) return [];
    final endIndex = (_currentDayIndex + 1).clamp(0, _allKlineData.length);
    final displayData = _allKlineData.take(endIndex).toList();
    
    final kdjResult = IndicatorCalculator.calculateKDJ(displayData);
    final paddingCount = endIndex - kdjResult.k.length;
    
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
    
    return result;
  }

  List<RsiData> get _displayRsiData {
    if (_allKlineData.isEmpty) return [];
    final endIndex = (_currentDayIndex + 1).clamp(0, _allKlineData.length);
    final displayData = _allKlineData.take(endIndex).toList();
    
    final rsiResult = IndicatorCalculator.calculateRSI(displayData);
    final paddingCount = endIndex - rsiResult.values.length;
    
    final result = <RsiData>[];
    for (int i = 0; i < paddingCount; i++) {
      result.add(RsiData(rsi: 50));
    }
    for (int i = 0; i < rsiResult.values.length; i++) {
      result.add(RsiData(rsi: rsiResult.values[i]));
    }
    
    return result;
  }

  List<BollData> get _displayBollData {
    if (_allKlineData.isEmpty) return [];
    final endIndex = (_currentDayIndex + 1).clamp(0, _allKlineData.length);
    final displayData = _allKlineData.take(endIndex).toList();
    
    final bollResult = IndicatorCalculator.calculateBoll(displayData);
    final paddingCount = endIndex - bollResult.mb.length;
    
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
    
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildStockInfo(),
              _buildMarketData(),
              _buildPeriodSelector(),
              _buildKlineChart(),
              _buildIndicatorSelector(),
              _buildTradeButtons(),
              _buildNextStepButton(),
              _buildAccountInfo(),
              _buildSummaryCards(),
            ],
          ),
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
    final currentData = _allKlineData.isNotEmpty && _currentDayIndex < _allKlineData.length
        ? _allKlineData[_currentDayIndex]
        : null;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.border, width: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(_getStockName(_currentSymbol),
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              Text(_currentSymbol, style: TextStyle(color: AppTheme.muted)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                currentData != null ? currentData.close.toStringAsFixed(2) : '--',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red),
              ),
              const SizedBox(width: 8),
              if (currentData != null)
                Text(
                  '${currentData.change >= 0 ? '+' : ''}${currentData.change.toStringAsFixed(2)} (${currentData.changePercent.toStringAsFixed(2)}%)',
                  style: const TextStyle(color: Colors.red),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildTag('涨停', Colors.green),
              const SizedBox(width: 8),
              _buildTag('融资融券', AppTheme.bg),
              const SizedBox(width: 8),
              _buildTag('MSCI', AppTheme.bg),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(text, style: const TextStyle(fontSize: 12)),
    );
  }

  Widget _buildMarketData() {
    final currentData = _allKlineData.isNotEmpty && _currentDayIndex < _allKlineData.length
        ? _allKlineData[_currentDayIndex]
        : null;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.border, width: 0.5)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _MarketDataItem(label: '今开', value: currentData?.open.toStringAsFixed(2) ?? '--'),
              _MarketDataItem(label: '最高', value: currentData?.high.toStringAsFixed(2) ?? '--'),
              _MarketDataItem(label: '最低', value: currentData?.low.toStringAsFixed(2) ?? '--'),
              _MarketDataItem(label: '成交量', value: _formatVolume(currentData?.volume ?? 0)),
              _MarketDataItem(label: '成交额', value: _formatAmount(currentData?.turnover ?? 0)),
              _MarketDataItem(label: '换手率', value: '3.2%'),
            ],
          ),
        ],
      ),
    );
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
          child: Text(period, style: const TextStyle(fontSize: 14)),
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
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppTheme.accent,
      ),
      icon: const Icon(Icons.arrow_drop_down, color: AppTheme.accent),
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
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.border, width: 0.5)),
      ),
      child: SizedBox(
        height: 280,
        child: displayData.isNotEmpty
            ? KlineChart(
                klineData: displayData,
                ma5: _calculateMA(displayData, 5),
                ma10: _calculateMA(displayData, 10),
                ma20: _calculateMA(displayData, 20),
                ma30: _calculateMA(displayData, 30),
                volumes: _displayVolumes,
                macdData: _displayMacdData,
                tradePoints: _tradePoints,
              )
            : const Center(child: Text('加载中...')),
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

  Widget _buildIndicatorSection(String selected, Function(String) onChanged) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: AppTheme.border, width: 0.5)),
          ),
          child: Row(
            children: [
              DropdownButton<String>(
                value: selected,
                items: _indicators.map((indicator) {
                  return DropdownMenuItem<String>(
                    value: indicator,
                    child: Text(indicator, style: const TextStyle(fontSize: 14)),
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
                Text('(12,26,9)', style: TextStyle(fontSize: 12, color: AppTheme.muted))
              else if (selected == 'KDJ')
                Text('(9,3,3)', style: TextStyle(fontSize: 12, color: AppTheme.muted))
              else if (selected == 'RSI')
                Text('(14)', style: TextStyle(fontSize: 12, color: AppTheme.muted))
              else if (selected == 'BOLL')
                Text('(20)', style: TextStyle(fontSize: 12, color: AppTheme.muted)),
            ],
          ),
        ),
        _buildSingleIndicatorChart(selected),
      ],
    );
  }

  Widget _buildSingleIndicatorChart(String indicator) {
    return Container(
      height: 100,
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.border, width: 0.5)),
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
                          : Center(
                              child: Text('[$indicator 指标图表]'),
                            ),
    );
  }

  Widget _buildVolumeChart() {
    if (_displayVolumes.isEmpty) return const SizedBox();
    final maxVolume = _displayVolumes.map((v) => v.volume).reduce((a, b) => a > b ? a : b);
    final safeMax = maxVolume > 0 ? maxVolume : 1.0;

    return SizedBox(
      height: 100,
      child: BarChart(
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
                      width: 4,
                    ),
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget _buildMacdChart() {
    if (_displayMacdData.isEmpty) return const SizedBox();
    
    final values = _displayMacdData.expand((m) => [m.macd, m.diff, m.dea]).toList();
    double maxValue = values.map((v) => v.abs()).reduce((a, b) => a > b ? a : b);
    final safeMax = maxValue > 0 ? maxValue : 1.0;

    return SizedBox(
      height: 100,
      child: Stack(
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
                          width: 3,
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
                  spots: _displayMacdData.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.diff)).toList(),
                  isCurved: true,
                  color: Colors.blue,
                  dotData: const FlDotData(show: false),
                  barWidth: 1.5,
                ),
                LineChartBarData(
                  spots: _displayMacdData.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.dea)).toList(),
                  isCurved: true,
                  color: Colors.orange,
                  dotData: const FlDotData(show: false),
                  barWidth: 1.5,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKdjChart() {
    if (_displayKdjData.isEmpty) return const SizedBox();

    return SizedBox(
      height: 100,
      child: LineChart(
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
              spots: _displayKdjData.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.k)).toList(),
              isCurved: true,
              color: Colors.yellow,
              dotData: const FlDotData(show: false),
              barWidth: 2,
            ),
            LineChartBarData(
              spots: _displayKdjData.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.d)).toList(),
              isCurved: true,
              color: Colors.purple,
              dotData: const FlDotData(show: false),
              barWidth: 2,
            ),
            LineChartBarData(
              spots: _displayKdjData.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.j)).toList(),
              isCurved: true,
              color: Colors.red,
              dotData: const FlDotData(show: false),
              barWidth: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRsiChart() {
    if (_displayRsiData.isEmpty) return const SizedBox();

    return SizedBox(
      height: 100,
      child: LineChart(
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
              spots: _displayRsiData.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.rsi)).toList(),
              isCurved: true,
              color: Colors.blue,
              dotData: const FlDotData(show: false),
              barWidth: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBollChart() {
    if (_displayBollData.isEmpty) return const SizedBox();
    final prices = _displayBollData.map((e) => [e.upper, e.mid, e.lower]).expand((x) => x).toList();
    final minPrice = prices.reduce((a, b) => a < b ? a : b);
    final maxPrice = prices.reduce((a, b) => a > b ? a : b);
    final safeMin = minPrice - (maxPrice - minPrice) * 0.1;
    final safeMax = maxPrice + (maxPrice - minPrice) * 0.1;

    return SizedBox(
      height: 100,
      child: LineChart(
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
              spots: _displayBollData.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.upper)).toList(),
              isCurved: true,
              color: Colors.orange,
              dotData: const FlDotData(show: false),
              barWidth: 1,
            ),
            LineChartBarData(
              spots: _displayBollData.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.mid)).toList(),
              isCurved: true,
              color: Colors.purple,
              dotData: const FlDotData(show: false),
              barWidth: 1,
            ),
            LineChartBarData(
              spots: _displayBollData.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.lower)).toList(),
              isCurved: true,
              color: Colors.green,
              dotData: const FlDotData(show: false),
              barWidth: 1,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTradeButtons() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: _showStockSelectionDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.surface,
                foregroundColor: AppTheme.muted,
                side: const BorderSide(color: AppTheme.border),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('换股'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: _showConditionalOrderDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.surface,
                foregroundColor: AppTheme.muted,
                side: const BorderSide(color: AppTheme.border),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('条件单'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: _showBuyDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('买入'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: _showSellDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('卖出'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextStepButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('训练周期: '),
              Text(
                '${_trainingDays}天',
                style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.accent),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _nextDay,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('下一步 (推进到下一天)'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAccountInfo() {
    final currentData = _allKlineData.isNotEmpty && _currentDayIndex < _allKlineData.length
        ? _allKlineData[_currentDayIndex]
        : null;

    final positionValue = _positionQuantity * (currentData?.close ?? 0);
    final profit = _positionQuantity > 0 ? positionValue - (_positionQuantity * _positionCost) : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.border, width: 0.5)),
      ),
      child: Column(
        children: [
          _AccountRow(label: '持仓/可用', value: '${_positionQuantity.toInt()}股 / ¥${_accountBalance.toStringAsFixed(2)}'),
          _AccountRow(label: '成本/现价', value: '¥${_positionCost.toStringAsFixed(2)} / ¥${currentData?.close.toStringAsFixed(2) ?? "--"}'),
          _AccountRow(
            label: '市值/盈亏',
            value: '¥${positionValue.toStringAsFixed(2)}',
            highlight: profit >= 0 ? '+¥${profit.toStringAsFixed(2)}' : '-¥${profit.abs().toStringAsFixed(2)}',
            color: profit >= 0 ? Colors.red : Colors.green,
          ),
          _AccountRow(label: '总资产', value: '¥${(_accountBalance + positionValue).toStringAsFixed(2)}'),
        ],
      ),
    );
  }

  Widget _buildSummaryCards() {
    final currentData = _allKlineData.isNotEmpty && _currentDayIndex < _allKlineData.length
        ? _allKlineData[_currentDayIndex]
        : null;
    final positionValue = _positionQuantity * (currentData?.close ?? 0);
    final profit = _positionQuantity > 0 ? positionValue - (_positionQuantity * _positionCost) : 0.0;

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
          _SummaryCard(title: '持仓市值', value: '¥${positionValue.toStringAsFixed(2)}'),
          _SummaryCard(title: '持仓盈亏', value: profit >= 0 ? '+¥${profit.toStringAsFixed(2)}' : '-¥${profit.abs().toStringAsFixed(2)}', color: profit >= 0 ? Colors.red : Colors.green),
          _SummaryCard(title: '总资产', value: '¥${(_accountBalance + positionValue).toStringAsFixed(2)}'),
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
          SizedBox(width: 100, child: Text(label, style: TextStyle(color: AppTheme.muted))),
          const SizedBox(width: 16),
          Expanded(child: Text(value, style: TextStyle(color: color))),
          if (highlight != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: (color ?? Colors.red).withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(highlight!, style: TextStyle(color: color ?? Colors.red, fontSize: 12)),
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
            Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }
}

class _StockSelectionSheet extends StatelessWidget {
  final Function(String) onSelect;

  const _StockSelectionSheet({required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final stocks = [
      {'code': 'SH600000', 'name': '浦发银行'},
      {'code': 'SH600036', 'name': '招商银行'},
      {'code': 'SH600519', 'name': '贵州茅台'},
      {'code': 'SH601318', 'name': '中国平安'},
      {'code': 'SZ300750', 'name': '宁德时代'},
      {'code': 'SZ002594', 'name': '比亚迪'},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('选择股票', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ...stocks.map((stock) => ListTile(
            title: Text(stock['name']!),
            subtitle: Text(stock['code']!),
            onTap: () => onSelect(stock['code']!),
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
          const Text('条件单设置', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            children: ['止盈止损', '价格条件', '技术指标'].map((type) =>
              ChoiceChip(
                label: Text(type),
                selected: _orderType == type,
                onSelected: (selected) {
                  setState(() {
                    _orderType = type;
                  });
                },
              ),
            ).toList(),
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
      final maxBuy = (widget.accountBalance / widget.currentPrice / 100).floor() * 100;
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
    final quantity = double.tryParse(_quantityController.text) ?? _selectedQuantity;

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
      padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.of(context).viewInsets.bottom + 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(widget.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                onPressed: () => _setPositionRatio(1/3),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: AppTheme.accent,
                  side: const BorderSide(color: AppTheme.accent),
                ),
                child: const Text('1/3仓'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () => _setPositionRatio(1/2),
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
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
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
                      color: total >= (widget.positionCost! * quantity) ? Colors.red : Colors.green,
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
                    backgroundColor: widget.title == '买入' ? Colors.red : Colors.green,
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
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        if (value != null && value! > 0)
          Row(
            children: [
              const SizedBox(width: 4),
              Text(
                '${value!.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 12,
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
