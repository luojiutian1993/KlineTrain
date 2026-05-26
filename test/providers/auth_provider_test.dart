import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kline_trainer/providers/auth_provider.dart';
import 'package:kline_trainer/data/models/user_model.dart';

void main() {
  group('CurrentUserNotifier Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('初始状态为 null', () {
      final currentUser = container.read(currentUserNotifierProvider);
      expect(currentUser, isNull);
    });

    test('setUser 后状态为指定用户', () {
      final testUser = UserModel(
        userId: '1',
        phone: '13071103531',
        nickname: '测试用户',
        avatarUrl: '',
        level: MemberLevel.bronze,
        trainingCount: 10,
        totalReturnPercent: 15.5,
        winCount: 5,
        totalTrades: 8,
        learningProgress: 50,
        createdAt: DateTime.now(),
      );

      container.read(currentUserNotifierProvider.notifier).setUser(testUser);
      final currentUser = container.read(currentUserNotifierProvider);

      expect(currentUser, isNotNull);
      expect(currentUser!.userId, equals('1'));
      expect(currentUser.phone, equals('13071103531'));
      expect(currentUser.nickname, equals('测试用户'));
    });

    test('clearUser 后状态为 null', () {
      final testUser = UserModel(
        userId: '1',
        phone: '13071103531',
        nickname: '测试用户',
        avatarUrl: '',
        level: MemberLevel.bronze,
        trainingCount: 0,
        totalReturnPercent: 0.0,
        winCount: 0,
        totalTrades: 0,
        learningProgress: 0,
        createdAt: DateTime.now(),
      );

      container.read(currentUserNotifierProvider.notifier).setUser(testUser);
      container.read(currentUserNotifierProvider.notifier).clearUser();
      final currentUser = container.read(currentUserNotifierProvider);

      expect(currentUser, isNull);
    });
  });
}