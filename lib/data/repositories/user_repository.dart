import '../models/user_model.dart';
import '../models/notice_model.dart';

class UserRepository {
  Future<UserModel?> getCurrentUser() async {
    return UserModel(
      userId: 'test_user_001',
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
  }

  Future<UserModel> fetchUserProfile() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return UserModel(
      userId: 'test_user_001',
      phone: '13800138000',
      nickname: 'K线新手',
      avatarUrl: '',
      level: MemberLevel.silver,
      trainingCount: 15,
      totalReturnPercent: 12.5,
      winCount: 8,
      totalTrades: 12,
      learningProgress: 45,
      createdAt: DateTime(2024, 1, 15),
    );
  }

  Future<void> updateProfile({String? nickname, String? avatarUrl}) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  Future<List<NoticeModel>> getNotifications() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      NoticeModel(
        id: '1',
        title: '系统通知',
        content: 'K线训练营 v1.1.0 更新啦！新增网格交易功能',
        type: NoticeType.system,
        isRead: false,
        publishedAt: DateTime(2024, 1, 15),
      ),
      NoticeModel(
        id: '2',
        title: '训练提醒',
        content: '您的贵州茅台止盈单已触发，卖出100股',
        type: NoticeType.training,
        isRead: false,
        publishedAt: DateTime(2024, 1, 14),
      ),
      NoticeModel(
        id: '3',
        title: '活动通知',
        content: '新用户专享福利，完成首次训练送积分',
        type: NoticeType.activity,
        isRead: true,
        publishedAt: DateTime(2024, 1, 13),
      ),
    ];
  }
}