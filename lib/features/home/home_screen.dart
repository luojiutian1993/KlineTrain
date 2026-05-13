import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kline_trainer/theme/app_theme.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;
  String _selectedCondition = '随机';
  
  final List<String> _conditions = [
    '随机', '历史新高', '1年新高', '200日新高', '30日涨幅前50', '15日涨幅前50',
    '涨停', '连板', '量升价涨', '上升趋势', '历史新低', '1年新低', '200日新低',
    '30日跌幅前50', '15日跌幅前50', '下降趋势', '跌停', '连续跌停'
  ];

  String _getCurrentDate() {
    DateTime now = DateTime.now();
    List<String> weekdays = ['星期一', '星期二', '星期三', '星期四', '星期五', '星期六', '星期日'];
    return '${weekdays[now.weekday - 1]} · ${now.month}月${now.day}日';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_getCurrentDate(), style: TextStyle(fontSize: 12, color: AppTheme.muted)),
            const Text('训练', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('筛选'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAssetStatsCard(),
            const SizedBox(height: 20),
            _buildProfitCurve(),
            const SizedBox(height: 20),
            _buildBattleStats(),
            const SizedBox(height: 20),
            _buildStockSelection(),
            const SizedBox(height: 20),
            _buildRecentTrades(),
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

  Widget _buildAssetStatsCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: const [
                Expanded(child: _StatItem(label: '初始资产', value: '¥100,000')),
                Expanded(child: _StatItem(label: '现有资产', value: '¥128,450', highlight: true)),
                Expanded(child: _StatItem(label: '总盈亏', value: '+¥28,450', color: Colors.red)),
                Expanded(child: _StatItem(label: '收益率', value: '+28.45%', bgHighlight: true)),
              ],
            ),
            const Divider(height: 16),
            Row(
              children: const [
                Expanded(child: _StatItem(label: '操作次数', value: '156')),
                Expanded(child: _StatItem(label: '操作天数', value: '42')),
                Expanded(child: _StatItem(label: '盈利次数', value: '106', color: Colors.green)),
                Expanded(child: _StatItem(label: '成功率', value: '67.9%', color: Colors.green)),
              ],
            ),
            const Divider(height: 16),
            Row(
              children: const [
                Expanded(child: _StatItem(label: '最大盈利', value: '+¥8,520', color: Colors.green)),
                Expanded(child: _StatItem(label: '最大亏损', value: '-¥3,200', color: Colors.red)),
                Expanded(child: _StatItem(label: '最大回撤', value: '12.5%')),
                Expanded(child: _StatItem(label: '回撤', value: '-8.2%')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfitCurve() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('收益率曲线', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              height: 120,
              child: const Center(child: Text('[收益率曲线图表]')),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBattleStats() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('实战', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: const [
                StatBadge(label: '操盘评级', value: 'B+'),
                StatBadge(label: '总收益率', value: '+28.45%', color: Colors.red),
                StatBadge(label: '交易次数', value: '156'),
              ],
            ),
            const SizedBox(height: 12),
            const Text('年化收益率', style: TextStyle(fontSize: 14, color: AppTheme.muted)),
            const SizedBox(height: 4),
            const Text('45.2%', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _ProgressBar(label: '近30日收益率', progress: 0.68, value: '+18.5%'),
            const SizedBox(height: 8),
            Row(
              children: const [
                Expanded(child: StatBadge(label: '本月收益', value: '+¥12,300', color: Colors.red)),
                Expanded(child: StatBadge(label: '最大回撤', value: '-12.5%', color: Colors.green)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: const [
                Expanded(child: StatBadge(label: '夏普比率', value: '1.85')),
                Expanded(child: StatBadge(label: '盈亏比', value: '2.3:1')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStockSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(child: Text('选股条件', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
            TextButton(onPressed: () {}, child: const Text('编辑')),
          ],
        ),
        const SizedBox(height: 12),
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _conditions.map((condition) => ChoiceChip(
                    label: Text(condition),
                    selected: _selectedCondition == condition,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCondition = condition;
                      });
                    },
                    selectedColor: AppTheme.accent,
                    backgroundColor: AppTheme.bg,
                  )).toList(),
                ),
                const SizedBox(height: 12),
                Container(
                  alignment: Alignment.centerLeft,
                  child: const Text('当前满足条件: 12 支股票', style: TextStyle(color: AppTheme.muted)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentTrades() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(child: Text('最近交易', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
            TextButton(onPressed: () {}, child: const Text('查看全部')),
          ],
        ),
        const SizedBox(height: 12),
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          child: Column(
            children: const [
              TradeItem(
                name: '宁德时代',
                code: 'SZ 300750',
                type: '买入',
                quantity: '100股',
                profit: '+¥840',
                status: '持仓',
                statusColor: Colors.green,
              ),
              TradeItem(
                name: '比亚迪',
                code: 'SZ 002594',
                type: '买入',
                quantity: '200股',
                profit: '-¥320',
                status: '止损',
                statusColor: Colors.red,
              ),
              TradeItem(
                name: '中国平安',
                code: 'SH 601318',
                type: '卖出',
                quantity: '50股',
                profit: '+¥1,250',
                status: '已平仓',
                statusColor: Colors.grey,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;
  final bool bgHighlight;
  final Color? color;

  const _StatItem({
    required this.label,
    required this.value,
    this.highlight = false,
    this.bgHighlight = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: AppTheme.muted)),
        const SizedBox(height: 4),
        Container(
          padding: bgHighlight ? const EdgeInsets.symmetric(horizontal: 8, vertical: 4) : EdgeInsets.zero,
          decoration: bgHighlight ? BoxDecoration(
            color: AppTheme.accentSoft,
            borderRadius: BorderRadius.circular(4),
          ) : null,
          child: Text(
            value,
            style: TextStyle(
              fontSize: highlight ? 16 : 14,
              fontWeight: highlight || bgHighlight ? FontWeight.bold : FontWeight.normal,
              color: color ?? (bgHighlight ? AppTheme.accent : AppTheme.fg),
            ),
          ),
        ),
      ],
    );
  }
}

class StatBadge extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;

  const StatBadge({required this.label, required this.value, this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: AppTheme.muted)),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color ?? AppTheme.fg)),
        ],
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final String label;
  final double progress;
  final String value;

  const _ProgressBar({required this.label, required this.progress, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Text(label, style: TextStyle(color: AppTheme.muted))),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: AppTheme.border,
          color: AppTheme.accent,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }
}

class TradeItem extends StatelessWidget {
  final String name;
  final String code;
  final String type;
  final String quantity;
  final String profit;
  final String status;
  final Color statusColor;

  const TradeItem({
    required this.name,
    required this.code,
    required this.type,
    required this.quantity,
    required this.profit,
    required this.status,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.border, width: 0.5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(code, style: TextStyle(fontSize: 12, color: AppTheme.muted)),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('$type $quantity', style: TextStyle(fontSize: 12, color: AppTheme.muted)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(profit, style: TextStyle(color: profit.startsWith('+') ? Colors.red : Colors.green)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(status, style: TextStyle(fontSize: 12, color: statusColor)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}