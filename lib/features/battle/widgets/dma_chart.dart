import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DmaChart extends StatelessWidget {
  final List<double> dma;
  final List<double> ama;

  const DmaChart({
    super.key,
    required this.dma,
    required this.ama,
  });

  @override
  Widget build(BuildContext context) {
    if (dma.isEmpty && ama.isEmpty) {
      return const SizedBox.expand();
    }

    final allValues = [...dma, ...ama];
    final maxValue = allValues.map((v) => v.abs()).reduce((a, b) => a > b ? a : b);
    final safeMax = maxValue > 0 ? maxValue : 1;

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
          if (dma.isNotEmpty)
            LineChartBarData(
              spots: dma.asMap().entries.map((e) => 
                FlSpot(e.key.toDouble(), e.value)
              ).toList(),
              isCurved: true,
              color: Colors.red,
              dotData: const FlDotData(show: false),
              barWidth: 1.5,
            ),
          if (ama.isNotEmpty)
            LineChartBarData(
              spots: ama.asMap().entries.map((e) => 
                FlSpot(e.key.toDouble(), e.value)
              ).toList(),
              isCurved: true,
              color: Colors.green,
              dotData: const FlDotData(show: false),
              barWidth: 1.5,
            ),
        ],
      ),
    );
  }
}