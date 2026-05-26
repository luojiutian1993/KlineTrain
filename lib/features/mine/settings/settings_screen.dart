import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kline_trainer/theme/app_theme.dart';
import 'package:kline_trainer/data/repositories/user_repository.dart';
import 'package:kline_trainer/routes/app_routes.dart';
import 'package:kline_trainer/providers/auth_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _isDeleting = false;

  void _showDeleteAccountConfirm() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除账户'),
        content: const Text(
          '删除账户后，您的所有数据将被永久清除，此操作无法撤销。\n\n请确认是否继续？',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: _handleDeleteAccount,
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.red),
            child: _isDeleting
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text('确认删除'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleDeleteAccount() async {
    setState(() => _isDeleting = true);

    try {
      final userRepository = UserRepository();
      await userRepository.deleteAccount();

      if (mounted) {
        Navigator.pop(context);
        ref.read(authNotifierProvider.notifier).logout();
        context.go(AppRoutes.login);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('账户已成功删除')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('删除失败: $e')),
        );
      }
    } finally {
      setState(() => _isDeleting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar:
          AppBar(title: const Text('设置'), backgroundColor: AppTheme.surface),
      body: ListView(
        children: [
          const SizedBox(height: 12),
          _SettingsSection(
            title: '显示设置',
            children: [
              _SwitchTile(title: '深色模式', value: false, onChanged: (value) {}),
              _SwitchTile(title: '通知提醒', value: true, onChanged: (value) {}),
            ],
          ),
          _SettingsSection(
            title: '交易设置',
            children: [
              _ListTile(title: 'K线颜色', subtitle: '红涨绿跌', onTap: () {}),
              _ListTile(title: '默认周期', subtitle: '日K', onTap: () {}),
            ],
          ),
          _SettingsSection(
            title: '其他',
            children: [
              _ListTile(title: '清除缓存', onTap: () {}),
              _ListTile(title: '检查更新', onTap: () {}),
            ],
          ),
          const SizedBox(height: 12),
          _SettingsSection(
            title: '账户安全',
            children: [
              _ListTile(
                title: '删除账户',
                subtitle: '永久删除所有数据',
                onTap: _showDeleteAccountConfirm,
                isDestructive: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
          color: AppTheme.surface, borderRadius: BorderRadius.circular(18)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(title,
                style: TextStyle(fontSize: 14, color: AppTheme.muted)),
          ),
          ...children,
        ],
      ),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchTile(
      {required this.title, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(title, style: const TextStyle(fontSize: 16)),
      value: value,
      onChanged: onChanged,
      activeColor: AppTheme.accent,
    );
  }
}

class _ListTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final bool isDestructive;

  const _ListTile({
    required this.title,
    this.subtitle,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title,
          style: TextStyle(
              fontSize: 16, color: isDestructive ? AppTheme.red : null)),
      subtitle: subtitle != null
          ? Text(subtitle!, style: TextStyle(color: AppTheme.muted))
          : null,
      trailing:
          const Icon(Icons.arrow_forward_ios, size: 16, color: AppTheme.muted),
      onTap: onTap,
    );
  }
}
