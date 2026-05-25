import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:kline_trainer/features/home/home_screen.dart';
import 'package:kline_trainer/features/home/trade_detail_screen.dart';
import 'package:kline_trainer/features/battle/battle_screen.dart';
import 'package:kline_trainer/features/mine/mine_screen.dart';
import 'package:kline_trainer/features/training/training_screen.dart';
import 'package:kline_trainer/features/user/login_screen.dart';
import 'package:kline_trainer/features/user/register_screen.dart';
import 'package:kline_trainer/features/mine/settings/settings_screen.dart';
import 'package:kline_trainer/features/mine/favorites/favorites_screen.dart';
import 'package:kline_trainer/features/mine/training_history/training_history_screen.dart';
import 'package:kline_trainer/features/mine/training_history/training_detail_screen.dart';
import 'package:kline_trainer/features/mine/notifications/notifications_screen.dart';
import 'package:kline_trainer/features/mine/feedback/feedback_screen.dart';
import 'package:kline_trainer/features/mine/help_center/help_center_screen.dart';
import 'package:kline_trainer/features/mine/learning_progress/learning_progress_screen.dart';
import 'package:kline_trainer/features/records/records_screen.dart';
import 'package:kline_trainer/features/records/record_detail_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRoutes {
  static const home = '/';
  static const battle = '/battle';
  static const mine = '/mine';
  static const training = '/training';
  static const login = '/login';
  static const register = '/register';
  static const settings = '/mine/settings';
  static const favorites = '/mine/favorites';
  static const trainingHistory = '/mine/training-history';
  static const learningProgress = '/mine/learning-progress';
  static const notifications = '/mine/notifications';
  static const feedback = '/mine/feedback';
  static const helpCenter = '/mine/help-center';
  static const tradeDetail = '/trade-detail';
  static const records = '/records';

  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    routes: [
      GoRoute(
        path: home,
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/trade-detail',
        name: 'trade-detail',
        builder: (context, state) {
          final symbol = state.uri.queryParameters['symbol'] ?? '';
          final symbolName = state.uri.queryParameters['name'] ?? '';
          final marketCode = state.uri.queryParameters['market'] ?? 'SZ';
          return TradeDetailScreen(
            symbol: symbol,
            symbolName: symbolName,
            marketCode: marketCode,
          );
        },
      ),
      GoRoute(
        path: battle,
        name: 'battle',
        builder: (context, state) {
          print('🟢🟢🟢 [2.路由解析] 开始解析battle路由');
          print('🟢🟢🟢 [2.路由解析] state.uri: ${state.uri}');
          print(
              '🟢🟢🟢 [2.路由解析] state.uri.queryParameters: ${state.uri.queryParameters}');

          final symbol = state.uri.queryParameters['symbol'] ?? '';
          final name = state.uri.queryParameters['name'] ?? '';
          final market = state.uri.queryParameters['market'] ?? '';
          final dateStr = state.uri.queryParameters['date'] ?? '';
          final DateTime? trainingStartDate =
              dateStr.isNotEmpty ? DateTime.tryParse(dateStr) : null;

          print('🟢🟢🟢 [2.路由解析] 解析结果:');
          print('🟢🟢🟢   - symbol: $symbol');
          print('🟢🟢🟢   - name: $name');
          print('🟢🟢🟢   - market: $market');
          print('🟢🟢🟢   - dateStr: $dateStr');
          print('🟢🟢🟢   - trainingStartDate: $trainingStartDate');

          return BattleScreen(
            initialSymbol: symbol,
            initialName: name,
            initialMarketCode: market,
            initialTrainingStartDate: trainingStartDate,
          );
        },
      ),
      GoRoute(
        path: records,
        name: 'records',
        builder: (context, state) => const RecordsScreen(),
        routes: [
          GoRoute(
            path: ':id/detail',
            name: 'record-detail',
            builder: (context, state) {
              final id = int.parse(state.pathParameters['id']!);
              return RecordDetailScreen(sessionId: id);
            },
          ),
        ],
      ),
      GoRoute(
        path: mine,
        name: 'mine',
        builder: (context, state) => const MineScreen(),
        routes: [
          GoRoute(
            path: 'settings',
            name: 'settings',
            builder: (context, state) => const SettingsScreen(),
          ),
          GoRoute(
            path: 'favorites',
            name: 'favorites',
            builder: (context, state) => const FavoritesScreen(),
          ),
          GoRoute(
            path: 'training-history',
            name: 'training-history',
            builder: (context, state) => const TrainingHistoryScreen(),
            routes: [
              GoRoute(
                path: ':id',
                name: 'training-detail',
                builder: (context, state) {
                  final id = int.parse(state.pathParameters['id']!);
                  return TrainingDetailScreen(sessionId: id);
                },
              ),
            ],
          ),
          GoRoute(
            path: 'learning-progress',
            name: 'learning-progress',
            builder: (context, state) => const LearningProgressScreen(),
          ),
          GoRoute(
            path: 'notifications',
            name: 'notifications',
            builder: (context, state) => const NotificationsScreen(),
          ),
          GoRoute(
            path: 'feedback',
            name: 'feedback',
            builder: (context, state) => const FeedbackScreen(),
          ),
          GoRoute(
            path: 'help-center',
            name: 'help-center',
            builder: (context, state) => const HelpCenterScreen(),
          ),
        ],
      ),
      GoRoute(
        path: training,
        name: 'training',
        builder: (context, state) => const TrainingScreen(),
      ),
      GoRoute(
        path: login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: register,
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
    ],
  );
}
