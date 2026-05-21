import 'package:flutter_test/flutter_test.dart';
import 'package:kline_trainer/features/battle/battle_screen.dart';

void main() {
  group('BattleScreen - 指标初始化测试', () {
    test('历史缓冲天数应为 100 天', () {
      // 创建 BattleScreen 的 State 实例来访问私有变量
      final battleScreen = const BattleScreen();
      final state = battleScreen.createState() as dynamic;

      // 验证 _historyDays 值为 100
      // 注意：由于 _historyDays 是私有变量，我们通过反射或修改代码暴露它来进行测试
      // 实际实现中，我们会修改代码使其可测试
      expect(state.historyDays, equals(100));
    });

    test('历史缓冲天数类型应为 int', () {
      final battleScreen = const BattleScreen();
      final state = battleScreen.createState() as dynamic;

      // 验证类型为 int
      expect(state.historyDays, isA<int>());
    });
  });
}
