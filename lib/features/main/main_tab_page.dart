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
    if (widget.battleParams != null && _currentIndex != 1) {
      print('🟡 [MainTabPage] battleParams存在但index不是1，强制切换到1');
      _currentIndex = 1;
    }
    print('🟡 [MainTabPage] 最终_currentIndex=$_currentIndex');
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
  void didUpdateWidget(MainTabPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    print('🟡 [MainTabPage] didUpdateWidget');
    print('🟡   - oldWidget.battleParams: ${oldWidget.battleParams?.symbol}');
    print('🟡   - widget.battleParams: ${widget.battleParams?.symbol}');
    if (widget.battleParams != null) {
      final shouldSwitchToBattle =
          widget.battleParams?.symbol != oldWidget.battleParams?.symbol ||
              widget.battleParams?.trainingStartDate !=
                  oldWidget.battleParams?.trainingStartDate;
      if (shouldSwitchToBattle && _currentIndex != 1) {
        print('🟡 [MainTabPage] battleParams变化且当前不是1，强制切换到1');
        setState(() {
          _currentIndex = 1;
        });
      }
    }
  }

  Widget _buildBattlePage() {
    if (widget.battleParams != null) {
      return BattleScreen(
        key: ValueKey(
            'battle_${widget.battleParams!.symbol}_${widget.battleParams!.trainingStartDate?.millisecondsSinceEpoch ?? 0}'),
        initialSymbol: widget.battleParams?.symbol,
        initialName: widget.battleParams?.name,
        initialMarketCode: widget.battleParams?.market,
        initialTrainingStartDate: widget.battleParams?.trainingStartDate,
        isReplayMode: widget.battleParams?.isReplayMode ?? false,
        replaySessionId: widget.battleParams?.sessionId,
      );
    }
    return const BattleScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          const HomeScreen(),
          _buildBattlePage(),
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
