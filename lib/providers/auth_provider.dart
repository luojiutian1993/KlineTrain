import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/repositories/user_repository.dart';
import '../data/models/user_model.dart';

part 'auth_provider.g.dart';

@riverpod
class AuthState extends _$AuthState {
  @override
  bool build() {
    return false;
  }

  Future<void> login(String phone, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    
    final userRepository = UserRepository();
    
    // 验证密码
    final isValid = await userRepository.verifyPassword(phone, password);
    
    if (isValid) {
      state = true;
    } else {
      throw Exception('手机号或密码错误');
    }
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
    state = false;
  }

  Future<bool> register(String phone, String password, String email) async {
    await Future.delayed(const Duration(seconds: 1));
    
    try {
      final userRepository = UserRepository();
      
      // 创建新用户模型
      final newUser = UserModel(
        userId: DateTime.now().millisecondsSinceEpoch.toString(),
        phone: phone,
        nickname: 'K线新手',
        avatarUrl: '',
        level: MemberLevel.bronze,
        trainingCount: 0,
        totalReturnPercent: 0.0,
        winCount: 0,
        totalTrades: 0,
        learningProgress: 0,
        createdAt: DateTime.now(),
      );
      
      // 保存到数据库（带密码哈希）
      await userRepository.saveUserToDatabase(newUser, password: password);
      state = true;
      return true;
    } catch (e) {
      return false;
    }
  }
}

@riverpod
String? currentUser(CurrentUserRef ref) {
  final isLoggedIn = ref.watch(authStateProvider);
  if (!isLoggedIn) return null;
  return 'demo_user';
}
