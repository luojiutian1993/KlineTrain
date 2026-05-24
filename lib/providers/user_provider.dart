import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/user_model.dart';
import '../data/models/notice_model.dart';
import '../data/repositories/user_repository.dart';

final userRepositoryProvider =
    Provider<UserRepository>((ref) => UserRepository());

class UserState {
  final UserModel? user;
  final bool isLoading;
  final String? error;

  const UserState({this.user, this.isLoading = false, this.error});

  UserState copyWith({UserModel? user, bool? isLoading, String? error}) {
    return UserState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class UserNotifier extends StateNotifier<UserState> {
  final UserRepository _repository;

  UserNotifier(this._repository) : super(const UserState()) {
    _loadUser();
  }

  Future<void> _loadUser() async {
    state = state.copyWith(isLoading: true);
    try {
      final user = await _repository.getCurrentUser();
      state = state.copyWith(user: user, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> refreshProfile() async {
    try {
      final user = await _repository.fetchUserProfile();
      state = state.copyWith(user: user);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> updateProfile({String? nickname, String? avatarUrl}) async {
    try {
      await _repository.updateProfile(nickname: nickname, avatarUrl: avatarUrl);
      await refreshProfile();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}

final userProvider = StateNotifierProvider<UserNotifier, UserState>(
  (ref) => UserNotifier(ref.watch(userRepositoryProvider)),
);

class NotificationsState {
  final List<NoticeModel> notices;
  final bool isLoading;
  final String? error;

  const NotificationsState(
      {this.notices = const [], this.isLoading = false, this.error});

  NotificationsState copyWith(
      {List<NoticeModel>? notices, bool? isLoading, String? error}) {
    return NotificationsState(
      notices: notices ?? this.notices,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class NotificationsNotifier extends StateNotifier<NotificationsState> {
  final UserRepository _repository;

  NotificationsNotifier(this._repository) : super(const NotificationsState());

  Future<void> loadNotifications() async {
    state = state.copyWith(isLoading: true);
    try {
      final notices = await _repository.getNotifications();
      state = state.copyWith(notices: notices, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  void markAsRead(String noticeId) {
    state = state.copyWith(
        notices: state.notices
            .map((n) => n.id == noticeId ? n.copyWith(isRead: true) : n)
            .toList());
  }

  void markAllAsRead() {
    state = state.copyWith(
        notices: state.notices.map((n) => n.copyWith(isRead: true)).toList());
  }
}

final notificationsProvider =
    StateNotifierProvider<NotificationsNotifier, NotificationsState>(
  (ref) => NotificationsNotifier(ref.watch(userRepositoryProvider)),
);
