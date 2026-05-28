import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DmiChart extends StatelessWidget {
  final List<double> plusDI;
  final List<double> minusDI;
  final List<double> adx;

  const DmiChart({
    super.key,
    required this.plusDI,
    required this.minusDI,
    required this.adx,
  });

  @override
  Widget build(BuildContext context) {
    if (plusDI.isEmpty && minusDI.isEmpty && adx.isEmpty) {
      return const SizedBox.expand();
    }

    return LineChart(
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
          if (plusDI.isNotEmpty)
            LineChartBarData(
              spots: plusDI.asMap().entries.map((e) => 
                FlSpot(e.key.toDouble(), e.value)
              ).toList(),
              isCurved: true,
              color: Colors.green,
              dotData: const FlDotData(show: false),
              barWidth: 1.5,
            ),
          if (minusDI.isNotEmpty)
            LineChartBarData(
              spots: minusDI.asMap().entries.map((e) => 
                FlSpot(e.key.toDouble(), e.value)
              ).toList(),
              isCurved: true,
              color: Colors.red,
              dotData: const FlDotData(show: false),
              barWidth: 1.5,
            ),
          if (adx.isNotEmpty)
            LineChartBarData(
              spots: adx.asMap().entries.map((e) => 
                FlSpot(e.key.toDouble(), e.value)
              ).toList(),
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