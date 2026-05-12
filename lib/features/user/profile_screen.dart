import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kline_trainer/providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoggedIn = ref.watch(authStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('我的'),
      ),
      body: ListView(
        children: [
          _buildUserInfo(context, isLoggedIn),
          const Divider(height: 1),
          _buildMenuList(),
          const Divider(height: 1),
          _buildSettingsSection(),
        ],
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context, bool isLoggedIn) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
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
                Text(
                  isLoggedIn ? 'K线学习者' : '未登录',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isLoggedIn ? 'Lv.5 进阶学习者' : '登录后解锁更多功能',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          if (!isLoggedIn)
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: const Text('登录'),
            ),
        ],
      ),
    );
  }

  Widget _buildMenuList() {
    return Column(
      children: [
        _buildMenuItem(
          icon: Icons.book,
          title: '我的课程',
          subtitle: '已学习 3/12 节课',
          onTap: () {},
        ),
        _buildMenuItem(
          icon: Icons.history,
          title: '学习记录',
          subtitle: '最近学习 3天前',
          onTap: () {},
        ),
        _buildMenuItem(
          icon: Icons.trending_up,
          title: '交易记录',
          subtitle: '模拟交易 12次',
          onTap: () {},
        ),
        _buildMenuItem(
          icon: Icons.star,
          title: '成就徽章',
          subtitle: '已获得 5 枚徽章',
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }

  Widget _buildSettingsSection() {
    return Column(
      children: [
        _buildMenuItem(
          icon: Icons.settings,
          title: '设置',
          subtitle: '账号安全、通知等',
          onTap: () {},
        ),
        _buildMenuItem(
          icon: Icons.help_center,
          title: '帮助与反馈',
          subtitle: '常见问题解答',
          onTap: () {},
        ),
        _buildMenuItem(
          icon: Icons.info,
          title: '关于我们',
          subtitle: '版本 1.0.0',
          onTap: () {},
        ),
      ],
    );
  }
}
