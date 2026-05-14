import 'package:flutter_test/flutter_test.dart';
import 'package:kline_trainer/data/database/database_service.dart';
import 'package:kline_trainer/data/models/user_model.dart';
import 'package:kline_trainer/data/repositories/user_repository.dart';

void main() {
  late UserRepository userRepository;

  setUpAll(() async {
    // 初始化 Flutter binding
    TestWidgetsFlutterBinding.ensureInitialized();
    
    // 初始化数据库
    await DatabaseService.instance.initialize();
    userRepository = UserRepository();
  });

  tearDownAll(() async {
    await DatabaseService.instance.close();
  });

  group('UserRepository 数据库测试', () {
    test('测试1: 初始状态下数据库应该没有用户', () async {
      // 清理数据
      await userRepository.deleteAllUsers();
      
      final user = await userRepository.getCurrentUser();
      expect(user, isNull);
      print('✅ 测试1通过: 初始数据库为空');
    });

    test('测试2: 创建测试用户并保存到数据库', () async {
      final testUser = UserModel(
        userId: 'test_001',
        phone: '13800138001',
        nickname: '测试用户1',
        avatarUrl: 'https://example.com/avatar1.png',
        level: MemberLevel.silver,
        trainingCount: 10,
        totalReturnPercent: 15.5,
        winCount: 7,
        totalTrades: 10,
        learningProgress: 60,
        createdAt: DateTime.now(),
      );

      await userRepository.saveUserToDatabase(testUser);
      
      // 验证保存成功
      final savedUser = await userRepository.getCurrentUser();
      expect(savedUser, isNotNull);
      expect(savedUser!.phone, equals('13800138001'));
      expect(savedUser.nickname, equals('测试用户1'));
      expect(savedUser.level, equals(MemberLevel.silver));
      print('✅ 测试2通过: 用户创建并保存成功');
      print('   用户手机号: ${savedUser.phone}');
      print('   用户昵称: ${savedUser.nickname}');
      print('   会员等级: ${savedUser.level.label}');
    });

    test('测试3: 更新用户资料', () async {
      // 先确保有用户
      var user = await userRepository.getCurrentUser();
      if (user == null) {
        await userRepository.fetchUserProfile();
        user = await userRepository.getCurrentUser();
      }

      // 更新昵称和头像
      await userRepository.updateProfile(
        nickname: '更新后的昵称',
        avatarUrl: 'https://example.com/new_avatar.png',
      );

      // 重新获取验证更新
      final updatedUser = await userRepository.getCurrentUser();
      expect(updatedUser, isNotNull);
      expect(updatedUser!.nickname, equals('更新后的昵称'));
      expect(updatedUser.avatarUrl, equals('https://example.com/new_avatar.png'));
      print('✅ 测试3通过: 用户资料更新成功');
      print('   新昵称: ${updatedUser.nickname}');
      print('   新头像: ${updatedUser.avatarUrl}');
    });

    test('测试4: 查询所有用户', () async {
      // 创建第二个用户
      final testUser2 = UserModel(
        userId: 'test_002',
        phone: '13800138002',
        nickname: '测试用户2',
        avatarUrl: '',
        level: MemberLevel.gold,
        trainingCount: 20,
        totalReturnPercent: 25.0,
        winCount: 15,
        totalTrades: 20,
        learningProgress: 80,
        createdAt: DateTime.now(),
      );
      await userRepository.saveUserToDatabase(testUser2);

      // 查询所有用户
      final allUsers = await userRepository.getAllUsersFromDatabase();
      expect(allUsers.length, greaterThanOrEqualTo(2));
      print('✅ 测试4通过: 查询到 ${allUsers.length} 个用户');
      
      for (var i = 0; i < allUsers.length; i++) {
        final u = allUsers[i];
        print('   用户${i + 1}: ${u.nickname} (${u.phone}) - ${u.level.label}');
      }
    });

    test('测试5: fetchUserProfile 自动创建用户', () async {
      // 清理所有用户
      await userRepository.deleteAllUsers();
      
      // 调用 fetchUserProfile 应该自动创建测试用户
      final user = await userRepository.fetchUserProfile();
      expect(user, isNotNull);
      expect(user.phone, isNotEmpty);
      print('✅ 测试5通过: fetchUserProfile 自动创建用户');
      print('   自动创建的用户: ${user.nickname} (${user.phone})');
    });

    test('测试6: 验证数据库中的用户数据', () async {
      final allUsers = await userRepository.getAllUsersFromDatabase();
      
      print('\n📊 数据库用户数据汇总:');
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      print('总用户数: ${allUsers.length}');
      print('');
      
      for (final user in allUsers) {
        print('用户ID: ${user.userId}');
        print('  手机号: ${user.phone}');
        print('  昵称: ${user.nickname}');
        print('  头像: ${user.avatarUrl.isEmpty ? "未设置" : user.avatarUrl}');
        print('  等级: ${user.level.label} (${user.level.value})');
        print('  训练次数: ${user.trainingCount}');
        print('  总收益率: ${user.totalReturnPercent}%');
        print('  胜率: ${user.totalTrades > 0 ? (user.winCount / user.totalTrades * 100).toStringAsFixed(1) : 0}%');
        print('  学习进度: ${user.learningProgress}%');
        print('  创建时间: ${user.createdAt}');
        print('');
      }
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      
      expect(allUsers.isNotEmpty, isTrue);
      print('✅ 测试6通过: 数据库数据验证完成');
    });
  });
}