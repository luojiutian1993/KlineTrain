import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:kline_trainer/data/models/kline_model.dart';

class MacdChart extends StatelessWidget {
  final List<MacdData> data;

  const MacdChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return const SizedBox.expand();

    final values = data.expand((m) => [m.macd, m.diff, m.dea]).toList();
    double maxValue =
        values.map((v) => v.abs()).reduce((a, b) => a > b ? a : b);
    final safeMax = maxValue > 0 ? maxValue : 1.0;

    return Stack(
      children: [
        _buildMacdBars(safeMax),
        _buildMacdLines(safeMax),
      ],
    );
  }

  Widget _buildMacdBars(double safeMax) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: safeMax * 1.2,
        minY: -safeMax * 1.2,
        barTouchData: BarTouchData(enabled: false),
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
        barGroups: data.asMap().entries.map((entry) {
          return BarChartGroupData(
            x: entry.key,
            barRods: [
              BarChartRodData(
                toY: entry.value.macd,
                color: entry.value.macd > 0 ? Colors.red : Colors.green,
                width: 2,
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMacdLines(double safeMax) {
    return LineChart(
      LineChartData(
        minY: -safeMax * 1.2,
        maxY: safeMax * 1.2,
        lineTouchData: LineTouchData(enabled: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        gridData: const FlGridData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: data
                .asMap()
                .entries
                .map((e) => FlSpot(e.key.toDouble(), e.value.diff))
                .toList(),
            isCurved: true,
            color: Colors.blue,
            dotData: const FlDotData(show: false),
            barWidth: 1,
          ),
          LineChartBarData(
            spots: data
                .asMap()
                .entries
                .map((e) => FlSpot(e.key.toDouble(), e.value.dea))
                .toList(),
            isCurved: true,
            color: Colors.orange,
            dotData: const FlDotData(show: false),
            barWidth: 1,
          ),
        ],
      ),
    );
  }
}
