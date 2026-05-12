import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:kline_trainer/features/kline_chart/kline_chart_screen.dart';
import 'package:kline_trainer/features/course/course_list_screen.dart';
import 'package:kline_trainer/features/trading/trading_screen.dart';
import 'package:kline_trainer/features/user/profile_screen.dart';
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
        builder: (context, state) => const KlineChartScreen(),
      ),
      GoRoute(
        path: '/course',
        name: 'course',
        builder: (context, state) => const CourseListScreen(),
      ),
      GoRoute(
        path: '/trading',
        name: 'trading',
        builder: (context, state) => const TradingScreen(),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
    ],
  );
}
