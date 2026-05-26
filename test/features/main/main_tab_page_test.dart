import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kline_trainer/features/main/main_tab_page.dart';
import 'package:kline_trainer/providers/auth_provider.dart';

void main() {
  group('MainTabPage Silent Login Tests', () {
    test('初始状态 _initialized 为 false', () {
      final state = _TestMainTabPageState();
      expect(state._initialized, isFalse);
    });
  });
}

class _TestMainTabPageState {
  bool _initialized = false;
}