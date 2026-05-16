import 'dart:async';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kline_trainer/theme/app_theme.dart';
import 'package:kline_trainer/features/training/widgets/kline_chart.dart';
import 'package:kline_trainer/data/repositories/kline_repository.dart';
import 'package:kline_trainer/data/models/kline_model.dart';

class BattleScreen extends ConsumerStatefulWidget {
  const BattleScreen({super.key});

  @override
  ConsumerState<BattleScreen> createState() => _BattleScreenState();
}

class _BattleScreenState extends ConsumerState<BattleScreen> {
  int _selectedIndex = 1;
  String _selectedPeriod = '日K';
  String _selectedIndicator = '成交量';
  int _currentDayIndex = 0;
  bool _isPlaying = false;
  Timer? _playTimer;
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
    _playTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadKlineData() async {
    final repository = KlineRepository();
    final data = await repository.fetchKlineData(
      symbol: _currentSymbol,
      timeframe: 'day',
      limit: _trainingDays,
    );

    setState(() {
      _allKlineData = data;
      _currentDayIndex = 0;
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

  void _prevDay() {
    if (_currentDayIndex > 0) {
      setState(() {
        _currentDayIndex--;
      });
    }
  }

  void _togglePlay() {
    setState(() {
      _isPlaying = !_isPlaying;
    });

    if (_isPlaying) {
      _playTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
        if (_currentDayIndex < _allKlineData.length - 1) {
          setState(() {
            _currentDayIndex++;
            _checkConditionalOrders();
            _updateAccount();
          });
        } else {
          setState(() {
            _isPlaying = false;
          });
          timer.cancel();
        }
      });
    } else {
      _playTimer?.cancel();
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
    return List.generate(
      endIndex,
      (i) {
        final macd = i > 0
            ? (_allKlineData[i].close - _allKlineData[i - 1].close) / 10
            : 0.0;
        return MacdData(macd: macd, diff: macd * 1.2, dea: macd * 0.8);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildStockInfo(),
            _buildMarketData(),
            _buildTimeStepper(),
            _buildPeriodSelector(),
            _buildKlineChart(),
            _buildIndicatorSelector(),
            _buildIndicatorChart(),
            _buildTradeButtons(),
            _buildNextStepButton(),
            _buildAccountInfo(),
            _buildSummaryCards(),
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

  Widget _buildTimeStepper() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.border, width: 0.5)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.skip_previous),
                onPressed: _currentDayIndex > 0 ? _prevDay : null,
              ),
              IconButton(
                icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                onPressed: _togglePlay,
              ),
              IconButton(
                icon: const Icon(Icons.skip_next),
                onPressed: _currentDayIndex < _allKlineData.length - 1 ? _nextDay : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Slider(
                  value: _currentDayIndex.toDouble(),
                  min: 0,
                  max: (_allKlineData.length - 1).toDouble().clamp(0, double.infinity),
                  onChanged: (value) {
                    setState(() {
                      _currentDayIndex = value.toInt();
                    });
                  },
                ),
              ),
              const SizedBox(width: 16),
              Text(
                _allKlineData.isNotEmpty && _currentDayIndex < _allKlineData.length
                    ? '${_allKlineData[_currentDayIndex].dateTime.month}/${_allKlineData[_currentDayIndex].dateTime.day}'
                    : '--',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('进度: ${_currentDayIndex + 1} / ${_allKlineData.length}'),
              const SizedBox(width: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.accent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text('训练周期: ${_trainingDays}天'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.border, width: 0.5)),
      ),
      child: Row(
        children: _periods.map((period) => Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _selectedPeriod = period;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _selectedPeriod == period
                    ? AppTheme.accent
                    : Colors.transparent,
                foregroundColor: _selectedPeriod == period
                    ? Colors.white
                    : AppTheme.accent,
                side: BorderSide(color: AppTheme.accent),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(vertical: 8),
              ),
              child: Text(period, style: const TextStyle(fontSize: 12)),
            ),
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildKlineChart() {
    final displayData = _displayKlineData;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.border, width: 0.5)),
      ),
      child: Column(
        children: [
          SizedBox(
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                _buildMALegend('MA5', Colors.yellow, displayData, 5),
                const SizedBox(width: 12),
                _buildMALegend('MA10', Colors.purple, displayData, 10),
                const SizedBox(width: 12),
                _buildMALegend('MA20', Colors.orange, displayData, 20),
                const SizedBox(width: 12),
                _buildMALegend('MA30', Colors.blue, displayData, 30),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMALegend(String label, Color color, List<KlineData> data, int period) {
    final ma = _calculateMA(data, period);
    final value = ma.isNotEmpty ? ma.last : 0.0;
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '$label ${value.toStringAsFixed(2)}',
          style: TextStyle(fontSize: 10, color: color),
        ),
      ],
    );
  }

  Widget _buildIndicatorSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.border, width: 0.5)),
      ),
      child: Row(
        children: _indicators.map((indicator) => Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _selectedIndicator = indicator;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _selectedIndicator == indicator
                    ? AppTheme.accent
                    : Colors.transparent,
                foregroundColor: _selectedIndicator == indicator
                    ? Colors.white
                    : AppTheme.muted,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(vertical: 8),
              ),
              child: Text(indicator, style: const TextStyle(fontSize: 12)),
            ),
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildIndicatorChart() {
    return Container(
      height: 120,
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.border, width: 0.5)),
      ),
      child: _selectedIndicator == '成交量'
          ? _buildVolumeChart()
          : _selectedIndicator == 'MACD'
              ? _buildMacdChart()
              : Center(
                  child: Text('[$_selectedIndicator 指标图表]'),
                ),
    );
  }

  Widget _buildVolumeChart() {
    if (_displayVolumes.isEmpty) return const SizedBox();
    final maxVolume = _displayVolumes.map((v) => v.volume).reduce((a, b) => a > b ? a : b);

    return SizedBox(
      height: 100,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxVolume * 1.2,
          barTouchData: BarTouchData(enabled: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: maxVolume / 4,
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
    double maxMacd = _displayMacdData.map((m) => m.macd).reduce((a, b) => a.abs() > b.abs() ? a : b).abs();

    return SizedBox(
      height: 100,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxMacd * 1.2,
          minY: -maxMacd * 1.2,
          barTouchData: BarTouchData(enabled: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: maxMacd / 2,
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