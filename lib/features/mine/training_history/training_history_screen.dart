import 'package:flutter/material.dart';
import 'package:kline_trainer/theme/app_theme.dart';

class TrainingHistoryScreen extends StatelessWidget {
  const TrainingHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(title: const Text('训练记录'), backgroundColor: AppTheme.surface),
      body: ListView(
        children: [
          const SizedBox(height: 12),
          _TrainingCard(
            name: '贵州茅台训练',
            period: '2024.01.01 - 2025.12.31',
            returnPercent: 15.32,
            trades: 12,
            winRate: 66.7,
          ),
          _TrainingCard(
            name: '比亚迪训练',
            period: '2023.06.01 - 2024.05.31',
            returnPercent: -3.21,
            trades: 8,
            winRate: 50.0,
          ),
        ],
      ),
    );
  }
}

class _TrainingCard extends StatelessWidget {
  final String name;
  final String period;
  final double returnPercent;
  final int trades;
  final double winRate;

  const _TrainingCard({
    required this.name,
    required this.period,
    required this.returnPercent,
    required this.trades,
    required this.winRate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppTheme.surface, borderRadius: BorderRadius.circular(18)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              const Icon(Icons.chevron_right, color: AppTheme.muted),
            ],
          ),
          const SizedBox(height: 8),
          Text(period, style: TextStyle(color: AppTheme.muted, fontSize: 14)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _StatChip(
                label: '收益率',
                value: '${returnPercent >= 0 ? '+' : ''}${returnPercent.toStringAsFixed(2)}%',
                color: returnPercent >= 0 ? AppTheme.red : AppTheme.green,
              ),
              _StatChip(label: '交易次数', value: '$trades次'),
              _StatChip(label: '胜率', value: '${winRate.toStringAsFixed(1)}%'),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;

  const _StatChip({required this.label, required this.value, this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color ?? AppTheme.fg)),
        Text(label, style: TextStyle(fontSize: 12, color: AppTheme.muted)),
      ],
    );
  }
}