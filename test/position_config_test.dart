import 'package:flutter_test/flutter_test.dart';
import 'package:kline_trainer/features/battle/models/position_config.dart';

void main() {
  group('PositionConfig Tests', () {
    setUp(() {
      PositionConfig.resetToDefault();
    });

    test('Default buy positions should be correctly initialized', () {
      expect(PositionConfig.buyPositions.length, 5);
      expect(PositionConfig.buyPositions[0].label, '全仓');
      expect(PositionConfig.buyPositions[0].ratio, 1.0);
      expect(PositionConfig.buyPositions[1].label, '1/2仓');
      expect(PositionConfig.buyPositions[1].ratio, 0.5);
      expect(PositionConfig.buyPositions[2].label, '1/3仓');
      expect(PositionConfig.buyPositions[2].ratio, closeTo(1/3, 0.001));
    });

    test('Default sell positions should be correctly initialized', () {
      expect(PositionConfig.sellPositions.length, 5);
      expect(PositionConfig.sellPositions[0].label, '全仓');
      expect(PositionConfig.sellPositions[0].ratio, 1.0);
    });

    test('Save and retrieve buy positions should work correctly', () {
      final newPositions = [
        PositionItem(id: 'custom1', label: '1/4仓', ratio: 0.25),
        PositionItem(id: 'custom2', label: '3/4仓', ratio: 0.75),
      ];
      PositionConfig.saveBuyPositions(newPositions);
      
      expect(PositionConfig.buyPositions.length, 2);
      expect(PositionConfig.buyPositions[0].label, '1/4仓');
    });

    test('Save and retrieve sell positions should work correctly', () {
      final newPositions = [
        PositionItem(id: 'custom1', label: '半仓', ratio: 0.5),
      ];
      PositionConfig.saveSellPositions(newPositions);
      
      expect(PositionConfig.sellPositions.length, 1);
      expect(PositionConfig.sellPositions[0].label, '半仓');
    });

    test('Reset to default should restore original positions', () {
      final newPositions = [
        PositionItem(id: 'custom1', label: 'Test', ratio: 0.5),
      ];
      PositionConfig.saveBuyPositions(newPositions);
      PositionConfig.saveSellPositions(newPositions);
      PositionConfig.skipBuyConfirm = true;
      
      PositionConfig.resetToDefault();
      
      expect(PositionConfig.buyPositions.length, 5);
      expect(PositionConfig.sellPositions.length, 5);
      expect(PositionConfig.skipBuyConfirm, false);
    });

    test('Skip buy confirm should default to false', () {
      expect(PositionConfig.skipBuyConfirm, false);
    });

    test('Skip buy confirm can be set and saved', () {
      PositionConfig.skipBuyConfirm = true;
      expect(PositionConfig.skipBuyConfirm, true);
    });
  });

  group('PositionCalculator Tests', () {
    test('Calculate quantity with valid inputs should work correctly', () {
      expect(PositionCalculator.calculateQuantity(1000, 1.0), 1000.0);
      expect(PositionCalculator.calculateQuantity(1000, 0.5), 500.0);
      expect(PositionCalculator.calculateQuantity(1000, 0.25), 200.0);
    });

    test('Calculate quantity should floor to nearest 100', () {
      expect(PositionCalculator.calculateQuantity(1250, 1.0), 1200.0);
      expect(PositionCalculator.calculateQuantity(1290, 1.0), 1200.0);
      expect(PositionCalculator.calculateQuantity(1300, 1.0), 1300.0);
    });

    test('Calculate quantity with ratio 0 should return 0', () {
      expect(PositionCalculator.calculateQuantity(1000, 0.0), 0.0);
    });

    test('Calculate quantity with max quantity 0 should return 0', () {
      expect(PositionCalculator.calculateQuantity(0.0, 0.5), 0.0);
    });

    test('Calculate max buy quantity should work correctly', () {
      expect(PositionCalculator.calculateMaxBuyQuantity(10000, 10), 1000.0);
      expect(PositionCalculator.calculateMaxBuyQuantity(10000, 12.34), 800.0);
    });

    test('Calculate max buy quantity with zero price should return 0', () {
      expect(PositionCalculator.calculateMaxBuyQuantity(10000, 0), 0.0);
    });

    test('Calculate max buy quantity with negative price should return 0', () {
      expect(PositionCalculator.calculateMaxBuyQuantity(10000, -10), 0.0);
    });

    test('Calculate max buy quantity should round to nearest 100', () {
      expect(PositionCalculator.calculateMaxBuyQuantity(12345, 10), 1200.0);
    });
  });

  group('PositionItem Tests', () {
    test('PositionItem should be correctly created', () {
      const position = PositionItem(
        id: 'test1',
        label: '测试仓位',
        ratio: 0.75,
      );
      
      expect(position.id, 'test1');
      expect(position.label, '测试仓位');
      expect(position.ratio, 0.75);
    });

    test('PositionItem copyWith should create new instance with updated values', () {
      const original = PositionItem(
        id: 'test1',
        label: '测试仓位',
        ratio: 0.75,
      );
      
      final updated = original.copyWith(label: '新仓位', ratio: 0.5);
      
      expect(updated.id, 'test1');
      expect(updated.label, '新仓位');
      expect(updated.ratio, 0.5);
    });

    test('PositionItem copyWith should preserve old values if not specified', () {
      const original = PositionItem(
        id: 'test1',
        label: '测试仓位',
        ratio: 0.75,
      );
      
      final updated = original.copyWith(ratio: 0.5);
      
      expect(updated.id, 'test1');
      expect(updated.label, '测试仓位');
      expect(updated.ratio, 0.5);
    });

    test('PositionItem equality should work correctly', () {
      const position1 = PositionItem(
        id: 'test1',
        label: '测试仓位',
        ratio: 0.75,
      );
      
      const position2 = PositionItem(
        id: 'test1',
        label: '测试仓位',
        ratio: 0.75,
      );
      
      const position3 = PositionItem(
        id: 'test2',
        label: '另一个仓位',
        ratio: 0.5,
      );
      
      expect(position1 == position2, true);
      expect(position1 == position3, false);
    });

    test('PositionItem hashCode should be consistent', () {
      const position1 = PositionItem(
        id: 'test1',
        label: '测试仓位',
        ratio: 0.75,
      );
      
      const position2 = PositionItem(
        id: 'test1',
        label: '测试仓位',
        ratio: 0.75,
      );
      
      expect(position1.hashCode, position2.hashCode);
    });
  });

  group('Default Positions Tests', () {
    test('Default buy positions should have correct ratio values', () {
      expect(defaultBuyPositions.length, 5);
      expect(defaultBuyPositions[0].ratio, 1.0);
      expect(defaultBuyPositions[1].ratio, 0.5);
      expect(defaultBuyPositions[2].ratio, closeTo(1/3, 0.001));
      expect(defaultBuyPositions[3].ratio, 0.25);
      expect(defaultBuyPositions[4].ratio, closeTo(2/3, 0.001));
    });

    test('Default sell positions should have correct ratio values', () {
      expect(defaultSellPositions.length, 5);
      expect(defaultSellPositions[0].ratio, 1.0);
      expect(defaultSellPositions[1].ratio, 0.5);
      expect(defaultSellPositions[2].ratio, closeTo(1/3, 0.001));
      expect(defaultSellPositions[3].ratio, 0.25);
      expect(defaultSellPositions[4].ratio, closeTo(2/3, 0.001));
    });

    test('Default buy and sell positions should have same initial configuration', () {
      expect(defaultBuyPositions.length, defaultSellPositions.length);
      for (int i = 0; i < defaultBuyPositions.length; i++) {
        expect(defaultBuyPositions[i].label, defaultSellPositions[i].label);
        expect(defaultBuyPositions[i].ratio, closeTo(defaultSellPositions[i].ratio, 0.001));
      }
    });
  });
}
