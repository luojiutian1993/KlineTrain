import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:kline_trainer/features/training/widgets/kline_chart.dart';

class VolumeChart extends StatelessWidget {
  final List<VolumeData> data;

  const VolumeChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return const SizedBox.expand();

    final maxVolume = data.map((v) => v.volume).reduce((a, b) => a > b ? a : b);
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
        barGroups: data.asMap().entries.map((entry) {
          return BarChartGroupData(
            x: entry.key,
            barRods: [
              BarChartRodData(
                toY: entry.value.volume,
                color: entry.value.isUp ? Colors.red : Colors.green,
                width: 3,
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}