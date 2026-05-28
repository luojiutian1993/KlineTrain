import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:kline_trainer/data/models/kline_model.dart';

class KdjChart extends StatelessWidget {
  final List<KdjData> data;

  const KdjChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return const SizedBox.expand();

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
          LineChartBarData(
            spots: data.asMap().entries.map((e) => 
              FlSpot(e.key.toDouble(), e.value.k)
            ).toList(),
            isCurved: true,
            color: Colors.yellow,
            dotData: const FlDotData(show: false),
            barWidth: 1.5,
          ),
          LineChartBarData(
            spots: data.asMap().entries.map((e) => 
              FlSpot(e.key.toDouble(), e.value.d)
            ).toList(),
            isCurved: true,
            color: Colors.purple,
            dotData: const FlDotData(show: false),
            barWidth: 1.5,
          ),
          LineChartBarData(
            spots: data.asMap().entries.map((e) => 
              FlSpot(e.key.toDouble(), e.value.j)
            ).toList(),
            isCurved: true,
            color: Colors.red,
            dotData: const FlDotData(show: false),
            barWidth: 1.5,
          ),
        ],
      ),
    );
  }
}