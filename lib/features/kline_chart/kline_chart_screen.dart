import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';

import 'package:kline_trainer/providers/kline_provider.dart';
import 'package:kline_trainer/data/models/kline_model.dart';

class KlineChartScreen extends ConsumerStatefulWidget {
  const KlineChartScreen({super.key});

  @override
  ConsumerState<KlineChartScreen> createState() => _KlineChartScreenState();
}

class _KlineChartScreenState extends ConsumerState<KlineChartScreen> {
  final List<String> _timeFrames = ['1分', '5分', '15分', '1小时', '日', '周', '月'];
  int _selectedTimeFrame = 4;
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/course');
        break;
      case 2:
        context.go('/trading');
        break;
      case 3:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final klineData = ref.watch(klineDataProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('K线训练营'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.refresh(klineDataProvider);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildTimeFrameSelector(),
          Expanded(
            child: klineData.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Text('加载失败: $error'),
              ),
              data: (data) => _buildKlineChart(data),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'K线',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: '课程',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            label: '交易',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '我的',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildTimeFrameSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _timeFrames
              .asMap()
              .entries
              .map((entry) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedTimeFrame = entry.key;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _selectedTimeFrame == entry.key
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).cardColor,
                        foregroundColor: _selectedTimeFrame == entry.key
                            ? Colors.white
                            : Theme.of(context).textTheme.bodyLarge?.color,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(entry.value),
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildKlineChart(List<KlineModel> data) {
    if (data.isEmpty) {
      return const Center(child: Text('暂无数据'));
    }

    double minPrice = double.maxFinite;
    double maxPrice = double.minPositive;
    
    for (var item in data) {
      minPrice = min(minPrice, item.low);
      maxPrice = max(maxPrice, item.high);
    }
    
    double priceRange = maxPrice - minPrice;
    double padding = priceRange * 0.1;
    minPrice -= padding;
    maxPrice += padding;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            drawHorizontalLine: true,
            verticalInterval: 1,
            horizontalInterval: (maxPrice - minPrice) / 5,
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  int index = value.toInt();
                  if (index >= 0 && index < data.length) {
                    return Text(
                      '${data[index].dateTime.month}-${data[index].dateTime.day}',
                      style: const TextStyle(fontSize: 10),
                    );
                  }
                  return const Text('');
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toStringAsFixed(2),
                    style: const TextStyle(fontSize: 10),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: Colors.grey),
          ),
          minX: 0,
          maxX: data.length - 1,
          minY: minPrice,
          maxY: maxPrice,
          lineBarsData: [
            LineChartBarData(
              spots: data.asMap().entries.map((entry) {
                return FlSpot(entry.key.toDouble(), entry.value.close);
              }).toList(),
              isCurved: false,
              barWidth: 2,
              color: Colors.blue,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(show: false),
            ),
          ],
        ),
      ),
    );
  }
}
