import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CciChart extends StatelessWidget {
  final List<double> data;

  const CciChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return const SizedBox.expand();

    final maxValue = data.map((v) => v.abs()).reduce((a, b) => a > b ? a : b);
    final safeMax = maxValue > 0 ? maxValue : 100;

    return LineChart(
      LineChartData(
        minY: -safeMax * 1.2,
        maxY: safeMax * 1.2,
        lineTouchData: LineTouchData(enabled: false),
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
        lineBarsData: [
          LineChartBarData(
            spots: data
                .asMap()
                .entries
                .map((e) => FlSpot(e.key.toDouble(), e.value))
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
}
