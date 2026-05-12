import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

@riverpod
class AuthState extends _$AuthState {
  @override
  bool build() {
    return false;
  }

  Future<void> login(String username, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    state = true;
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
    state = false;
  }

  Future<void> register(String username, String password, String email) async {
    await Future.delayed(const Duration(seconds: 1));
    state = true;
  }
}

@riverpod
String? currentUser(CurrentUserRef ref) {
  final isLoggedIn = ref.watch(authStateProvider);
  if (!isLoggedIn) return null;
  return 'demo_user';
}
