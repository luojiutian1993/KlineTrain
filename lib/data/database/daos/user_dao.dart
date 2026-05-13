import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/tables.dart';

part 'user_dao.g.dart';

/// 用户相关数据访问对象
@DriftAccessor(tables: [Users, UserProfiles, UserPreferences])
class UserDao extends DatabaseAccessor<AppDatabase> with _$UserDaoMixin {
  UserDao(super.db);

  /// 获取用户信息
  Future<User?> getUserById(int userId) {
    return (select(users)..where((t) => t.id.equals(userId))).getSingleOrNull();
  }

  /// 通过手机号查找用户
  Future<User?> getUserByPhone(String phone) {
    return (select(users)..where((t) => t.phone.equals(phone))).getSingleOrNull();
  }

  /// 创建用户
  Future<int> createUser(UsersCompanion user) {
    return into(users).insert(user);
  }

  /// 更新用户
  Future<int> updateUser(int userId, UsersCompanion user) {
    return (update(users)..where((t) => t.id.equals(userId))).write(user);
  }

  /// 获取用户详情
  Future<UserProfile?> getUserProfile(int userId) {
    return (select(userProfiles)..where((t) => t.userId.equals(userId)))
        .getSingleOrNull();
  }

  /// 创建或更新用户详情
  Future<void> upsertUserProfile(UserProfilesCompanion profile) {
    return into(userProfiles).insertOnConflictUpdate(profile);
  }

  /// 获取用户偏好设置
  Future<UserPreference?> getUserPreferences(int userId) {
    return (select(userPreferences)..where((t) => t.userId.equals(userId)))
        .getSingleOrNull();
  }

  /// 创建或更新用户偏好设置
  Future<void> upsertUserPreferences(UserPreferencesCompanion preferences) {
    return into(userPreferences).insertOnConflictUpdate(preferences);
  }

  /// 获取活跃用户列表
  Future<List<User>> getActiveUsers({int limit = 100}) {
    return (select(users)
          ..where((t) => t.status.equals('active'))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
          ..limit(limit))
        .get();
  }
}
