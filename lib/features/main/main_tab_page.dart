import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kline_trainer/theme/app_theme.dart';
import 'package:kline_trainer/providers/auth_provider.dart';
import 'package:kline_trainer/routes/app_routes.dart';

import 'package:kline_trainer/features/home/home_screen.dart';
import 'package:kline_trainer/features/battle/battle_screen.dart';
import 'package:kline_trainer/features/records/records_screen.dart';
import 'package:kline_trainer/features/mine/mine_screen.dart';

class MainTabPage extends ConsumerStatefulWidget {
  final int initialIndex;
  final BattleScreenParams? battleParams;

  const MainTabPage({
    super.key,
    this.initialIndex = 0,
    this.battleParams,
  });

  @override
  ConsumerState<MainTabPage> createState() => _MainTabPageState();
}

class _MainTabPageState extends ConsumerState<MainTabPage> {
  late int _currentIndex;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    print(
        '🟡 [MainTabPage] initState, initialIndex=$_currentIndex, battleParams=${widget.battleParams}');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initAuth();
    });
  }

  Future<void> _initAuth() async {
    if (_initialized) return;
    _initialized = true;

    final authState = ref.read(authNotifierProvider);
    if (!authState) {
      final success =
          await ref.read(authNotifierProvider.notifier).silentLogin();
      if (!success && mounted) {
        context.go(AppRoutes.login);
      }
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          const HomeScreen(),
          BattleScreen(
            initialSymbol: widget.battleParams?.symbol,
            initialName: widget.battleParams?.name,
            initialMarketCode: widget.battleParams?.market,
            initialTrainingStartDate: widget.battleParams?.trainingStartDate,
            isReplayMode: widget.battleParams?.isReplayMode ?? false,
            replaySessionId: widget.battleParams?.sessionId,
          ),
          const RecordsScreen(),
          const MineScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '首页',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: '实战',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: '记录',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '我的',
          ),
        ],
        currentIndex: _currentIndex,
        selectedItemColor: AppTheme.accent,
        unselectedItemColor: AppTheme.muted,
        onTap: _onItemTapped,
      ),
    );
  }
}
