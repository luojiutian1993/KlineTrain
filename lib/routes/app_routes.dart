import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:kline_trainer/features/home/home_screen.dart';
import 'package:kline_trainer/features/battle/battle_screen.dart';
import 'package:kline_trainer/features/mine/mine_screen.dart';
import 'package:kline_trainer/features/training/training_screen.dart';
import 'package:kline_trainer/features/user/login_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRoutes {
  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/battle',
        name: 'battle',
        builder: (context, state) => const BattleScreen(),
      ),
      GoRoute(
        path: '/mine',
        name: 'mine',
        builder: (context, state) => const MineScreen(),
      ),
      GoRoute(
        path: '/training',
        name: 'training',
        builder: (context, state) => const TrainingScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
    ],
  );
}
