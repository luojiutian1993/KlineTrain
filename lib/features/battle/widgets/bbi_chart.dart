import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BbiChart extends StatelessWidget {
  final List<double> data;

  const BbiChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return const SizedBox.expand();

    final maxValue = data.reduce((a, b) => a > b ? a : b);
    final minValue = data.reduce((a, b) => a < b ? a : b);
    final range = maxValue - minValue;
    final safeMin = minValue - range * 0.1;
    final safeMax = maxValue + range * 0.1;

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
            spots: data.asMap().entries.map((e) => 
              FlSpot(e.key.toDouble(), e.value)
            ).toList(),
            isCurved: true,
            color: Colors.purple,
            dotData: const FlDotData(show: false),
            barWidth: 1.5,
          ),
        ],
      ),
    );
  }
}