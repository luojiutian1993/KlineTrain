import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kline_trainer/features/training/widgets/kline_chart.dart';

void main() {
  group('KlineChart 参数扩展测试', () {
    testWidgets('KlineChart 支持 openPrice 参数', (WidgetTester tester) async {
      final klineData = [
        KlineData(
          date: DateTime(2024, 1, 1),
          open: 100.0,
          high: 105.0,
          low: 98.0,
          close: 103.0,
          volume: 1000000,
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: KlineChart(
              klineData: klineData,
              volumes: [
                VolumeData(volume: 1000000, isUp: true),
              ],
              macdData: [
                MacdData(macd: 1.0, diff: 0.5, dea: 0.3),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(KlineChart), findsOneWidget);
    });

    testWidgets('KlineChart 支持 positionCost 参数', (WidgetTester tester) async {
      final klineData = [
        KlineData(
          date: DateTime(2024, 1, 1),
          open: 100.0,
          high: 105.0,
          low: 98.0,
          close: 103.0,
          volume: 1000000,
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: KlineChart(
              klineData: klineData,
              volumes: [
                VolumeData(volume: 1000000, isUp: true),
              ],
              macdData: [
                MacdData(macd: 1.0, diff: 0.5, dea: 0.3),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(KlineChart), findsOneWidget);
    });

    testWidgets('参数为 null 时图表仍可正常渲染', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: KlineChart(
              klineData: const [],
              volumes: const [],
              macdData: const [],
            ),
          ),
        ),
      );

      expect(find.byType(KlineChart), findsOneWidget);
      expect(find.text('暂无数据'), findsOneWidget);
    });
  });
}
