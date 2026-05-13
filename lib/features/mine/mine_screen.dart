import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kline_trainer/theme/app_theme.dart';

class MineScreen extends ConsumerStatefulWidget {
  const MineScreen({super.key});

  @override
  ConsumerState<MineScreen> createState() => _MineScreenState();
}

class _MineScreenState extends ConsumerState<MineScreen> {
  int _selectedIndex = 2;

  String _getCurrentDate() {
    DateTime now = DateTime.now();
    List<String> weekdays = ['星期一', '星期二', '星期三', '星期四', '星期五', '星期六', '星期日'];
    return '${weekdays[now.weekday - 1]} · ${now.month}月${now.day}日';
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/battle');
        break;
      case 2:
        context.go('/mine');
        break;
    }
  }

  void _navigateToTraining() {
    context.push('/training');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_getCurrentDate(), style: TextStyle(fontSize: 12, color: AppTheme.muted)),
            const Text('我的', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('设置'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildUserInfoCard(),
            const SizedBox(height: 20),
            _buildMenuList(),
            const SizedBox(height: 20),
            _buildTrainingStats(),
          ],
        ),
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
            icon: Icon(Icons.person),
            label: '我的',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppTheme.accent,
        unselectedItemColor: AppTheme.muted,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildUserInfoCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.accent,
                borderRadius: BorderRadius.circular(40),
              ),
              child: const Icon(
                Icons.person,
                size: 40,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('林交易员', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Text('ID: KX-2024-0831', style: TextStyle(fontSize: 14, color: AppTheme.muted)),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(38, 255, 165, 0),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text('Lv.3', style: TextStyle(color: Colors.orange, fontSize: 12)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuList() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Column(
        children: [
          _MenuItem(
            icon: Icons.email,
            title: '邮箱',
            subtitle: 'trader@example.com',
            showArrow: true,
          ),
          _MenuItem(
            icon: Icons.shopping_bag,
            title: '商店',
            subtitle: '新课程 · 高级策略包',
            showArrow: true,
          ),
          _MenuItem(
            icon: Icons.lock,
            title: '兑换码',
            subtitle: '激活课程或会员',
            showArrow: true,
          ),
          _MenuItem(
            icon: Icons.trending_up,
            title: '我的训练',
            subtitle: '已完成 12 个训练模块',
            showArrow: true,
            onTap: _navigateToTraining,
          ),
          _MenuItem(
            icon: Icons.settings,
            title: '设置',
            subtitle: '通知 · 隐私 · 账户',
            showArrow: true,
          ),
        ],
      ),
    );
  }

  Widget _buildTrainingStats() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('训练数据', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              children: const [
                Expanded(
                  child: _TrainingStatItem(
                    value: '42天',
                    label: '训练天数',
                  ),
                ),
                Expanded(
                  child: _TrainingStatItem(
                    value: '68%',
                    label: '胜率',
                    color: Colors.green,
                  ),
                ),
                Expanded(
                  child: _TrainingStatItem(
                    value: '+23.5%',
                    label: '累计收益',
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool showArrow;
  final VoidCallback? onTap;

  const _MenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.showArrow = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.border, width: 0.5)),
      ),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Icon(icon, color: AppTheme.muted),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(subtitle, style: TextStyle(fontSize: 12, color: AppTheme.muted)),
                ],
              ),
            ),
            if (showArrow)
              const Icon(Icons.arrow_forward_ios, size: 16, color: AppTheme.muted),
          ],
        ),
      ),
    );
  }
}

class _TrainingStatItem extends StatelessWidget {
  final String value;
  final String label;
  final Color? color;

  const _TrainingStatItem({
    required this.value,
    required this.label,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12, color: AppTheme.muted)),
      ],
    );
  }
}