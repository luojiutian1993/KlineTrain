import 'package:drift/drift.dart';
import '../database/database_service.dart';
import '../database/app_database.dart';
import '../database/tables/tables.dart';
import '../models/user_model.dart';
import '../models/notice_model.dart';
import '../../shared/utils/logger.dart';
import '../../shared/utils/security_utils.dart';

class UserRepository {
  final DatabaseService _dbService = DatabaseService.instance;

  /// 获取当前用户（从数据库）
  Future<UserModel?> getCurrentUser() async {
    try {
      // 获取第一个活跃用户
      final activeUsers = await _dbService.userDao.getActiveUsers(limit: 1);
      if (activeUsers.isEmpty) {
        appLogger.i('数据库中没有用户数据');
        return null;
      }

      final user = activeUsers.first;
      return _convertToUserModel(user);
    } catch (e, stackTrace) {
      appLogger.e('获取当前用户失败', error: e, stackTrace: stackTrace);
      return null;
    }
  }

  /// 从数据库获取用户资料
  Future<UserModel> fetchUserProfile() async {
    try {
      final user = await getCurrentUser();
      if (user != null) {
        return user;
      }

      // 如果没有用户，创建一个测试用户
      appLogger.i('创建测试用户');
      return await _createTestUser();
    } catch (e, stackTrace) {
      appLogger.e('获取用户资料失败', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 创建测试用户（用于开发和测试）
  Future<UserModel> _createTestUser() async {
    final testUser = UserModel(
      userId: '1',
      phone: '13800138000',
      nickname: 'K线新手',
      avatarUrl: '',
      level: MemberLevel.bronze,
      trainingCount: 15,
      totalReturnPercent: 12.5,
      winCount: 8,
      totalTrades: 12,
      learningProgress: 45,
      createdAt: DateTime.now(),
    );

    await saveUserToDatabase(testUser);
    return testUser;
  }

  /// 将用户模型保存到数据库
  Future<void> saveUserToDatabase(UserModel user, {String? password}) async {
    try {
      // 检查是否已存在该手机号的用户
      final existingUser = await _dbService.userDao.getUserByPhone(user.phone);

      if (existingUser != null) {
        // 更新已有用户
        await _dbService.userDao.updateUser(
          existingUser.id,
          UsersCompanion(
            phone: Value(user.phone),
            nickname: Value(user.nickname.isNotEmpty ? user.nickname : null),
            avatar: Value(user.avatarUrl.isNotEmpty ? user.avatarUrl : null),
            memberLevel: Value(user.level.value),
            totalProfit: Value(user.totalReturnPercent),
            overallWinRate: Value(user.totalTrades > 0 ? user.winCount / user.totalTrades : 0.0),
            status: const Value('active'),
            lastLoginAt: Value(DateTime.now()),
            updatedAt: Value(DateTime.now()),
          ),
        );
        appLogger.i('用户更新到数据库成功: ${user.phone}');
      } else {
        // 生成密码哈希（如果提供了密码）
        String? hashedPassword;
        String? salt;
        
        if (password != null && password.isNotEmpty) {
          salt = SecurityUtils.generateSalt();
          hashedPassword = SecurityUtils.hashPassword(password, salt);
        }

        // 插入新用户
        await _dbService.userDao.createUser(
          UsersCompanion(
            phone: Value(user.phone),
            password: hashedPassword != null ? Value(hashedPassword) : const Value.absent(),
            salt: salt != null ? Value(salt) : const Value.absent(),
            nickname: Value(user.nickname.isNotEmpty ? user.nickname : null),
            avatar: Value(user.avatarUrl.isNotEmpty ? user.avatarUrl : null),
            memberLevel: Value(user.level.value),
            totalProfit: Value(user.totalReturnPercent),
            overallWinRate: Value(user.totalTrades > 0 ? user.winCount / user.totalTrades : 0.0),
            status: const Value('active'),
            lastLoginAt: Value(DateTime.now()),
          ),
        );
        appLogger.i('用户保存到数据库成功: ${user.phone}');
      }
    } catch (e, stackTrace) {
      appLogger.e('保存用户到数据库失败', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 更新用户资料
  Future<void> updateProfile({String? nickname, String? avatarUrl}) async {
    try {
      final activeUsers = await _dbService.userDao.getActiveUsers(limit: 1);
      if (activeUsers.isEmpty) {
        throw Exception('没有可更新的用户');
      }

      final userId = activeUsers.first.id;

      await _dbService.userDao.updateUser(
        userId,
        UsersCompanion(
          nickname: nickname != null ? Value(nickname) : const Value.absent(),
          avatar: avatarUrl != null ? Value(avatarUrl) : const Value.absent(),
          updatedAt: Value(DateTime.now()),
        ),
      );

      appLogger.i('用户资料更新成功: userId=$userId');
    } catch (e, stackTrace) {
      appLogger.e('更新用户资料失败', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 修改密码
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      // 实际应用中需要验证旧密码并加密新密码
      await Future.delayed(const Duration(milliseconds: 300));
      appLogger.i('密码修改成功');
    } catch (e, stackTrace) {
      appLogger.e('修改密码失败', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 获取通知列表
  Future<List<NoticeModel>> getNotifications() async {
    try {
      // 这里可以从数据库查询通知，目前返回模拟数据
      return [
        NoticeModel(
          id: '1',
          title: '系统通知',
          content: 'K线训练营 v1.1.0 更新啦！新增网格交易功能',
          type: NoticeType.system,
          isRead: false,
          publishedAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
        NoticeModel(
          id: '2',
          title: '训练提醒',
          content: '您的贵州茅台止盈单已触发，卖出100股',
          type: NoticeType.training,
          isRead: false,
          publishedAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
        NoticeModel(
          id: '3',
          title: '活动通知',
          content: '新用户专享福利，完成首次训练送积分',
          type: NoticeType.activity,
          isRead: true,
          publishedAt: DateTime.now().subtract(const Duration(days: 3)),
        ),
      ];
    } catch (e, stackTrace) {
      appLogger.e('获取通知列表失败', error: e, stackTrace: stackTrace);
      return [];
    }
  }

  /// 将数据库User转换为UserModel
  UserModel _convertToUserModel(User user) {
    return UserModel(
      userId: user.id.toString(),
      phone: user.phone,
      nickname: user.nickname ?? 'K线用户',
      avatarUrl: user.avatar ?? '',
      level: _getMemberLevel(user.memberLevel),
      trainingCount: user.totalTrainingDays,
      totalReturnPercent: user.totalProfit,
      winCount: (user.overallWinRate * 100).toInt(),
      totalTrades: 12, // 从其他表查询
      learningProgress: 45, // 从其他表查询
      createdAt: user.createdAt,
    );
  }

  /// 根据等级值获取MemberLevel枚举
  MemberLevel _getMemberLevel(int level) {
    return MemberLevel.values.firstWhere(
      (e) => e.value == level,
      orElse: () => MemberLevel.bronze,
    );
  }

  /// 查询数据库中的所有用户（用于测试验证）
  Future<List<UserModel>> getAllUsersFromDatabase() async {
    try {
      final users = await _dbService.userDao.getActiveUsers(limit: 100);
      return users.map(_convertToUserModel).toList();
    } catch (e, stackTrace) {
      appLogger.e('查询所有用户失败', error: e, stackTrace: stackTrace);
      return [];
    }
  }

  /// 删除所有用户数据（测试用）
  Future<void> deleteAllUsers() async {
    try {
      // 使用自定义查询删除所有用户
      await _dbService.database.customStatement('DELETE FROM users');
      appLogger.i('所有用户数据已删除');
    } catch (e, stackTrace) {
      appLogger.e('删除用户数据失败', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 通过手机号查找用户
  Future<UserModel?> getUserByPhone(String phone) async {
    try {
      final user = await _dbService.userDao.getUserByPhone(phone);
      if (user == null) return null;
      return _convertToUserModel(user);
    } catch (e, stackTrace) {
      appLogger.e('通过手机号查找用户失败', error: e, stackTrace: stackTrace);
      return null;
    }
  }

  /// 验证用户密码
  Future<bool> verifyPassword(String phone, String password) async {
    try {
      final user = await _dbService.userDao.getUserByPhone(phone);
      if (user == null || user.password == null || user.salt == null) {
        return false;
      }
      
      return SecurityUtils.verifyPassword(password, user.password!, user.salt!);
    } catch (e, stackTrace) {
      appLogger.e('验证密码失败', error: e, stackTrace: stackTrace);
      return false;
    }
  }

  /// 删除当前用户账户（完整删除所有相关数据）
  Future<void> deleteAccount() async {
    try {
      final activeUsers = await _dbService.userDao.getActiveUsers(limit: 1);
      if (activeUsers.isEmpty) {
        throw Exception('没有可删除的用户');
      }

      final userId = activeUsers.first.id;
      
      await _dbService.userDao.deleteUser(userId);
      
      appLogger.i('用户账户删除成功: userId=$userId');
    } catch (e, stackTrace) {
      appLogger.e('删除用户账户失败', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
}