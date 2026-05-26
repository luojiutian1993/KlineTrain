import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/repositories/user_repository.dart';
import '../data/models/user_model.dart';
import '../shared/utils/logger.dart';

part 'auth_provider.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  bool build() {
    appLogger.d('[AuthNotifier] build: initial state = false');
    return false;
  }

  Future<bool> silentLogin() async {
    appLogger.d('[AuthNotifier] silentLogin: 开始静默登录...');
    try {
      final userRepo = UserRepository();
      final user = await userRepo.getUserByPhone('13071103531');

      if (user != null) {
        appLogger.d('[AuthNotifier] silentLogin: 找到默认账号 ${user.phone}');
        state = true;
        ref.read(currentUserNotifierProvider.notifier).setUser(user);
        appLogger.d('[AuthNotifier] silentLogin: 登录成功');
        return true;
      }
      appLogger.d('[AuthNotifier] silentLogin: 未找到默认账号');
      return false;
    } catch (e) {
      appLogger.e('[AuthNotifier] silentLogin: 异常 $e');
      return false;
    }
  }

  Future<void> login(String phone, String password) async {
    appLogger.d('[AuthNotifier] login: 开始登录 phone=$phone');
    
    final userRepository = UserRepository();
    final isValid = await userRepository.verifyPassword(phone, password);
    appLogger.d('[AuthNotifier] login: verifyPassword=$isValid');

    if (!isValid) {
      throw Exception('手机号或密码错误');
    }

    final user = await userRepository.getUserByPhone(phone);
    if (user == null) {
      throw Exception('手机号或密码错误');
    }

    appLogger.d('[AuthNotifier] login: 用户 $phone 登录成功');
    state = true;
    ref.read(currentUserNotifierProvider.notifier).setUser(user);
    appLogger.d('[AuthNotifier] login: currentUserNotifier 已设置');
  }

  Future<void> logout() async {
    appLogger.d('[AuthNotifier] logout');
    state = false;
    ref.read(currentUserNotifierProvider.notifier).clearUser();
  }

  Future<bool> register(String phone, String password, String email) async {
    appLogger.d('[AuthNotifier] register: phone=$phone');
    
    final userRepository = UserRepository();
    
    final existingUser = await userRepository.getUserByPhone(phone);
    if (existingUser != null) {
      throw Exception('该手机号已注册，请直接登录或找回密码');
    }

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

    await userRepository.saveUserToDatabase(newUser, password: password);
    state = true;
    ref.read(currentUserNotifierProvider.notifier).setUser(newUser);
    appLogger.d('[AuthNotifier] register: 注册成功');
    return true;
  }
}

@Riverpod(keepAlive: true)
class CurrentUserNotifier extends _$CurrentUserNotifier {
  @override
  UserModel? build() {
    appLogger.d('[CurrentUserNotifier] build: null');
    return null;
  }

  void setUser(UserModel user) {
    appLogger.d('[CurrentUserNotifier] setUser: ${user.phone}');
    state = user;
  }

  void clearUser() {
    appLogger.d('[CurrentUserNotifier] clearUser');
    state = null;
  }
}