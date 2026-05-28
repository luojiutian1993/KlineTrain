import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:kline_trainer/data/models/kline_model.dart';

class BollChart extends StatelessWidget {
  final List<BollData> data;

  const BollChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return const SizedBox.expand();

    final prices = data.map((e) => [e.upper, e.mid, e.lower]).expand((x) => x).toList();
    final minPrice = prices.reduce((a, b) => a < b ? a : b);
    final maxPrice = prices.reduce((a, b) => a > b ? a : b);
    final safeMin = minPrice - (maxPrice - minPrice) * 0.1;
    final safeMax = maxPrice + (maxPrice - minPrice) * 0.1;

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
              FlSpot(e.key.toDouble(), e.value.upper)
            ).toList(),
            isCurved: true,
            color: Colors.orange,
            dotData: const FlDotData(show: false),
            barWidth: 1,
          ),
          LineChartBarData(
            spots: data.asMap().entries.map((e) => 
              FlSpot(e.key.toDouble(), e.value.mid)
            ).toList(),
            isCurved: true,
            color: Colors.purple,
            dotData: const FlDotData(show: false),
            barWidth: 1,
          ),
          LineChartBarData(
            spots: data.asMap().entries.map((e) => 
              FlSpot(e.key.toDouble(), e.value.lower)
            ).toList(),
            isCurved: true,
            color: Colors.green,
            dotData: const FlDotData(show: false),
            barWidth: 1,
          ),
        ],
      ),
    );
  }
}