import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kline_trainer/theme/app_theme.dart';

class TrainingScreen extends StatelessWidget {
  const TrainingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的训练'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSummaryCard(),
            const SizedBox(height: 20),
            _buildTrainingList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: const [
            _SummaryItem(label: '周期', value: '日线'),
            _SummaryItem(label: '训练', value: '28天'),
            _SummaryItem(label: '胜率', value: '68%', color: Colors.green),
            _SummaryItem(label: '盈利', value: '+12%', color: Colors.red),
          ],
        ),
      ),
    );
  }

  Widget _buildTrainingList() {
    return Column(
      children: const [
        TrainingCard(
          name: '宁德时代',
          code: 'SZ 300750',
          profit: '+¥840',
          profitPercent: '+3.2%',
          period: '日线',
          duration: '30分钟',
          status: '持仓',
          statusColor: Colors.green,
        ),
        TrainingCard(
          name: '比亚迪',
          code: 'SZ 002594',
          profit: '-¥320',
          profitPercent: '-1.1%',
          period: '日线',
          duration: '45分钟',
          status: '止损',
          statusColor: Colors.red,
        ),
        TrainingCard(
          name: '中国平安',
          code: 'SH 601318',
          profit: '+¥1250',
          profitPercent: '+4.5%',
          period: '日线',
          duration: '25分钟',
          status: '已平仓',
          statusColor: AppTheme.muted,
        ),
        TrainingCard(
          name: '贵州茅台',
          code: 'SH 600519',
          profit: '+¥2100',
          profitPercent: '+6.8%',
          period: '日线',
          duration: '40分钟',
          status: '止盈',
          statusColor: AppTheme.accent,
        ),
        TrainingCard(
          name: '招商银行',
          code: 'SH 600036',
          profit: '-¥580',
          profitPercent: '-2.3%',
          period: '日线',
          duration: '35分钟',
          status: '止损',
          statusColor: Colors.red,
        ),
      ],
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;

  const _SummaryItem({
    required this.label,
    required this.value,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 12, color: AppTheme.muted)),
        ],
      ),
    );
  }
}

class TrainingCard extends StatelessWidget {
  final String name;
  final String code;
  final String profit;
  final String profitPercent;
  final String period;
  final String duration;
  final String status;
  final Color statusColor;

  const TrainingCard({
    required this.name,
    required this.code,
    required this.profit,
    required this.profitPercent,
    required this.period,
    required this.duration,
    required this.status,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Text(code, style: TextStyle(fontSize: 12, color: AppTheme.muted)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(status, style: TextStyle(color: statusColor, fontSize: 12)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                TextButton(
                  onPressed: () {},
                  child: const Text('详情'),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('复盘'),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('重训'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(profit, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: profit.startsWith('+') ? Colors.red : Colors.green)),
                      const SizedBox(height: 4),
                      Text(profitPercent, style: TextStyle(color: profit.startsWith('+') ? Colors.red : Colors.green)),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text('训练周期', style: TextStyle(fontSize: 12, color: AppTheme.muted)),
                      const SizedBox(height: 4),
                      Text('$period · $duration', style: const TextStyle(fontSize: 14)),
                    ],
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
