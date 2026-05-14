import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kline_trainer/routes/app_routes.dart';
import 'package:kline_trainer/theme/app_theme.dart';
import 'package:kline_trainer/providers/user_provider.dart';
import 'package:kline_trainer/providers/auth_provider.dart';
import 'package:kline_trainer/data/models/user_model.dart';

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
        context.go(AppRoutes.home);
        break;
      case 1:
        context.go(AppRoutes.battle);
        break;
      case 2:
        context.go(AppRoutes.mine);
        break;
    }
  }

  void _navigateToSettings() => context.push(AppRoutes.settings);
  void _navigateToFavorites() => context.push(AppRoutes.favorites);
  void _navigateToTrainingHistory() => context.push(AppRoutes.trainingHistory);
  void _navigateToLearningProgress() => context.push(AppRoutes.learningProgress);
  void _navigateToNotifications() => context.push(AppRoutes.notifications);
  void _navigateToFeedback() => context.push(AppRoutes.feedback);
  void _navigateToHelpCenter() => context.push(AppRoutes.helpCenter);
  void _navigateToTraining() => context.push(AppRoutes.training);

  void _showAvatarPicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('从相册选择'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('拍照'),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void _showNicknameEditor(UserModel? user) {
    final controller = TextEditingController(text: user?.nickname);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('修改昵称'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: '请输入昵称'),
          maxLength: 20,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(userProvider.notifier).updateProfile(nickname: controller.text);
              Navigator.pop(context);
            },
            child: const Text('保存'),
          ),
        ],
      ),
    );
  }

  void _showAccountInfo(UserModel? user) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('账户信息', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _InfoRow(label: '用户账号', value: _maskPhone(user?.phone ?? '')),
            _InfoRow(label: '用户昵称', value: user?.nickname ?? '-'),
            _InfoRow(label: '会员等级', value: user?.level.label ?? '-'),
            _InfoRow(label: '注册时间', value: user?.createdAt.toString().split(' ')[0] ?? '-'),
          ],
        ),
      ),
    );
  }

  String _maskPhone(String phone) {
    if (phone.length < 11) return phone;
    return '${phone.substring(0, 3)}****${phone.substring(7)}';
  }

  void _showLogoutConfirm() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('退出登录'),
        content: const Text('确定要退出登录吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(authStateProvider.notifier).logout();
              context.go(AppRoutes.login);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.red),
            child: const Text('确定退出'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userProvider);
    final user = userState.user;

    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildUserInfoCard(user),
              const SizedBox(height: 20),
              _buildStatsCard(user),
              const SizedBox(height: 20),
              _buildMenuList(),
              const SizedBox(height: 24),
              _buildLogoutButton(),
              const SizedBox(height: 32),
            ],
          ),
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

  Widget _buildUserInfoCard(UserModel? user) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.settings, color: Colors.white),
                onPressed: _navigateToSettings,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              GestureDetector(
                onTap: _showAvatarPicker,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white.withOpacity(0.2),
                      child: const Icon(Icons.person, size: 40, color: Colors.white),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        child: const Icon(Icons.camera_alt, size: 16, color: Color(0xFF667eea)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => _showNicknameEditor(user),
                      child: Row(
                        children: [
                          Text(
                            user?.nickname.isEmpty != false ? '点击设置昵称' : user!.nickname,
                            style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.edit, color: Colors.white70, size: 16),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(_maskPhone(user?.phone ?? ''), style: TextStyle(color: Colors.white70, fontSize: 14)),
                    const SizedBox(height: 8),
                    if (user != null) _LevelBadge(level: user.level),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard(UserModel? user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _StatItem(icon: Icons.trending_up, label: '训练次数', value: '${user?.trainingCount ?? 0}'),
              const _VerticalDivider(),
              _StatItem(
                icon: Icons.show_chart,
                label: '总收益率',
                value: '${(user?.totalReturnPercent ?? 0) >= 0 ? '+' : ''}${(user?.totalReturnPercent ?? 0).toStringAsFixed(1)}%',
                color: (user?.totalReturnPercent ?? 0) >= 0 ? AppTheme.red : AppTheme.green,
              ),
              const _VerticalDivider(),
              _StatItem(
                icon: Icons.emoji_events,
                label: '交易胜率',
                value: user != null && user.totalTrades > 0
                    ? '${((user.winCount / user.totalTrades) * 100).toStringAsFixed(0)}%'
                    : '0%',
              ),
              const _VerticalDivider(),
              _StatItem(icon: Icons.book, label: '学习进度', value: '${user?.learningProgress ?? 0}%'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 12),
            child: Text('功能区', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            child: Column(
              children: [
                _MenuItem(icon: Icons.star, title: '自选管理', onTap: _navigateToFavorites),
                _MenuItem(icon: Icons.bar_chart, title: '训练记录', onTap: _navigateToTrainingHistory),
                _MenuItem(icon: Icons.book, title: '学习进度', onTap: _navigateToLearningProgress),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            child: Column(
              children: [
                _MenuItem(icon: Icons.notifications, title: '消息通知', badge: '3', onTap: _navigateToNotifications),
                _MenuItem(icon: Icons.feedback, title: '意见反馈', onTap: _navigateToFeedback),
                _MenuItem(icon: Icons.help, title: '帮助中心', onTap: _navigateToHelpCenter),
                _MenuItem(icon: Icons.info, title: '关于我们', onTap: _showAbout),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: _showLogoutConfirm,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppTheme.red,
            side: const BorderSide(color: AppTheme.red),
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          child: const Text('退出登录'),
        ),
      ),
    );
  }

  void _showAbout() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('K线训练营', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('版本 1.0.0'),
            const SizedBox(height: 16),
            const Text('帮助您学习K线分析，提升交易技能'),
          ],
        ),
      ),
    );
  }
}

class _LevelBadge extends StatelessWidget {
  final MemberLevel level;

  const _LevelBadge({required this.level});

  Color get _levelColor {
    switch (level) {
      case MemberLevel.bronze: return const Color(0xFFCD7F32);
      case MemberLevel.silver: return const Color(0xFFC0C0C0);
      case MemberLevel.gold: return const Color(0xFFFFD700);
      case MemberLevel.platinum: return const Color(0xFFE5E4E2);
      case MemberLevel.diamond: return const Color(0xFFB9F2FF);
    }
  }

  IconData get _levelIcon {
    switch (level) {
      case MemberLevel.bronze:
      case MemberLevel.silver:
        return Icons.workspace_premium_outlined;
      case MemberLevel.gold:
        return Icons.workspace_premium;
      case MemberLevel.platinum:
        return Icons.diamond_outlined;
      case MemberLevel.diamond:
        return Icons.diamond;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [_levelColor.withOpacity(0.8), _levelColor]),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_levelIcon, color: Colors.white, size: 16),
          const SizedBox(width: 4),
          Text(level.label, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? color;

  const _StatItem({required this.icon, required this.label, required this.value, this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: const Color(0xFF667eea), size: 20),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color ?? AppTheme.fg)),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(fontSize: 12, color: AppTheme.muted)),
      ],
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  const _VerticalDivider();

  @override
  Widget build(BuildContext context) {
    return Container(height: 40, width: 1, color: AppTheme.border);
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? badge;
  final VoidCallback onTap;

  const _MenuItem({required this.icon, required this.title, this.badge, required this.onTap});

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
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: const Color(0xFFF0F4FF), borderRadius: BorderRadius.circular(8)),
              child: Icon(icon, color: const Color(0xFF667eea), size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(title, style: const TextStyle(fontSize: 16))),
            if (badge != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: AppTheme.red, borderRadius: BorderRadius.circular(10)),
                child: Text(badge!, style: const TextStyle(color: Colors.white, fontSize: 12)),
              ),
            const SizedBox(width: 4),
            const Icon(Icons.arrow_forward_ios, size: 16, color: AppTheme.muted),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: AppTheme.muted)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}