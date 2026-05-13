import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kline_trainer/theme/app_theme.dart';
import 'package:kline_trainer/features/training/widgets/kline_chart.dart';

class BattleScreen extends ConsumerStatefulWidget {
  const BattleScreen({super.key});

  @override
  ConsumerState<BattleScreen> createState() => _BattleScreenState();
}

class _BattleScreenState extends ConsumerState<BattleScreen> {
  int _selectedIndex = 1;
  String _selectedPeriod = '日K';
  String _selectedIndicator = '成交量';
  
  final List<String> _periods = ['日K', '周K', '月K', '季K', '年K'];
  final List<String> _indicators = ['成交量', 'MACD', 'KDJ', 'RSI', 'BOLL'];

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

  @override
  Widget build(BuildContext context) {
    final mockKlineData = _generateMockKlineData();
    final mockVolumes = _generateMockVolumes();
    final mockMacdData = _generateMockMacdData();

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildStockInfo(),
            _buildMarketData(),
            _buildPeriodSelector(),
            _buildKlineChart(mockKlineData, mockVolumes, mockMacdData),
            _buildIndicatorSelector(),
            _buildIndicatorChart(mockVolumes, mockMacdData),
            _buildTradeButtons(),
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.border, width: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('宁德时代', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const Text('SZ 300750', style: TextStyle(color: AppTheme.muted)),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text('218.52', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red)),
              const SizedBox(width: 8),
              const Text('+4.28 (+2.00%)', style: TextStyle(color: Colors.red)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text('涨停', style: TextStyle(color: Colors.green, fontSize: 12)),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.bg,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text('融资融券', style: TextStyle(color: AppTheme.muted, fontSize: 12)),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.bg,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text('MSCI', style: TextStyle(color: AppTheme.muted, fontSize: 12)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMarketData() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.border, width: 0.5)),
      ),
      child: Column(
        children: [
          Row(
            children: const [
              _MarketDataItem(label: '今开', value: '214.24'),
              _MarketDataItem(label: '最高', value: '220.00'),
              _MarketDataItem(label: '最低', value: '213.80'),
              _MarketDataItem(label: '成交量', value: '128.5万'),
              _MarketDataItem(label: '成交额', value: '27.9亿'),
              _MarketDataItem(label: '换手率', value: '3.2%'),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: const [
              _MarketDataItem(label: '流通市值', value: '1.2万亿'),
              _MarketDataItem(label: '市盈率', value: '45.8'),
              _MarketDataItem(label: '市净率', value: '8.2'),
              _MarketDataItem(label: '60日高', value: '235.00'),
              _MarketDataItem(label: '60日低', value: '198.50'),
              _MarketDataItem(label: '涨停价', value: '240.37'),
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

  Widget _buildKlineChart(
    List<KlineData> klineData,
    List<VolumeData> volumes,
    List<MacdData> macdData,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.border, width: 0.5)),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 280,
            child: KlineChart(
              klineData: klineData,
              ma5: _calculateMA(klineData, 5),
              ma10: _calculateMA(klineData, 10),
              ma20: _calculateMA(klineData, 20),
              ma30: _calculateMA(klineData, 30),
              volumes: volumes,
              macdData: macdData,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                _buildMALegend('MA5', Colors.yellow, klineData, 5),
                const SizedBox(width: 12),
                _buildMALegend('MA10', Colors.purple, klineData, 10),
                const SizedBox(width: 12),
                _buildMALegend('MA20', Colors.orange, klineData, 20),
                const SizedBox(width: 12),
                _buildMALegend('MA30', Colors.blue, klineData, 30),
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

  Widget _buildIndicatorChart(
    List<VolumeData> volumes,
    List<MacdData> macdData,
  ) {
    return Container(
      height: 120,
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.border, width: 0.5)),
      ),
      child: _selectedIndicator == '成交量'
          ? _buildVolumeChart(volumes)
          : _selectedIndicator == 'MACD'
              ? _buildMacdChart(macdData)
              : Center(
                  child: Text('[$_selectedIndicator 指标图表]'),
                ),
    );
  }

  Widget _buildVolumeChart(List<VolumeData> volumes) {
    return SizedBox(
      height: 100,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: volumes.map((v) => v.volume).reduce((a, b) => a > b ? a : b) * 1.2,
          barTouchData: BarTouchData(enabled: false),
          titlesData: FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: (volumes.map((v) => v.volume).reduce((a, b) => a > b ? a : b)) / 4,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey.withOpacity(0.2),
                strokeWidth: 0.5,
              );
            },
          ),
          barGroups: volumes
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

  Widget _buildMacdChart(List<MacdData> macdData) {
    double maxMacd = macdData.map((m) => m.macd).reduce((a, b) => a.abs() > b.abs() ? a : b).abs();

    return SizedBox(
      height: 100,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxMacd * 1.2,
          minY: -maxMacd * 1.2,
          barTouchData: BarTouchData(enabled: false),
          titlesData: FlTitlesData(show: false),
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
          barGroups: macdData
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
              onPressed: () {},
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
              onPressed: () {},
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
              onPressed: () {},
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
              onPressed: () {},
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

  Widget _buildAccountInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.border, width: 0.5)),
      ),
      child: Column(
        children: const [
          _AccountRow(label: '持仓/可用', value: '1000股 / 0股'),
          _AccountRow(label: '成本/现价', value: '210.00 / 218.52'),
          _AccountRow(label: '市值/盈亏', value: '¥218,520', highlight: '+¥8,520'),
          _AccountRow(label: '总资产/可用', value: '¥328,450 / ¥109,930'),
          _AccountRow(label: '今日盈亏', value: '+¥4,280 (+2.00%)', color: Colors.red),
          _AccountRow(label: '总盈亏', value: '+¥28,450 (+9.48%)', color: Colors.red),
        ],
      ),
    );
  }

  Widget _buildSummaryCards() {
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
        children: const [
          _SummaryCard(title: '持仓市值', value: '¥218,520'),
          _SummaryCard(title: '持仓盈亏', value: '+¥8,520', color: Colors.red),
          _SummaryCard(title: '总资产', value: '¥328,450'),
          _SummaryCard(title: '总盈亏', value: '+¥28,450', color: Colors.red),
        ],
      ),
    );
  }

  List<KlineData> _generateMockKlineData() {
    final data = <KlineData>[];
    final now = DateTime.now();
    double price = 15.0;

    for (int i = 90; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final volatility = 0.02 + (i % 20) * 0.001;
      final change = (DateTime.now().millisecondsSinceEpoch % 100) / 100.0 * volatility - volatility / 2;

      price = price * (1 + change);
      if (price < 5) price = 5;
      if (price > 25) price = 25;

      final open = price * (1 - (DateTime.now().millisecondsSinceEpoch % 50) / 1000.0);
      final close = price * (1 + (DateTime.now().millisecondsSinceEpoch % 50) / 1000.0);
      final high = open > close ? open * 1.02 : close * 1.02;
      final low = open > close ? close * 0.98 : open * 0.98;

      data.add(KlineData(
        date: date,
        open: open,
        high: high,
        low: low,
        close: close,
        volume: 1000000 + (DateTime.now().millisecondsSinceEpoch % 5000000),
      ));
    }

    return data;
  }

  List<VolumeData> _generateMockVolumes() {
    final volumes = <VolumeData>[];
    for (int i = 0; i < 91; i++) {
      volumes.add(VolumeData(
        volume: 1000000 + (DateTime.now().millisecondsSinceEpoch % 5000000),
        isUp: DateTime.now().millisecondsSinceEpoch % 2 == 0,
      ));
    }
    return volumes;
  }

  List<MacdData> _generateMockMacdData() {
    final macdData = <MacdData>[];
    for (int i = 0; i < 91; i++) {
      final macd = (DateTime.now().millisecondsSinceEpoch % 100 - 50) / 100.0;
      macdData.add(MacdData(
        macd: macd,
        diff: macd * 1.2,
        dea: macd * 0.8,
      ));
    }
    return macdData;
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
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(highlight!, style: const TextStyle(color: Colors.red, fontSize: 12)),
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
