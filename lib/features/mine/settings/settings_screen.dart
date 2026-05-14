import 'package:flutter/material.dart';
import 'package:kline_trainer/theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(title: const Text('设置'), backgroundColor: AppTheme.surface),
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
      decoration: BoxDecoration(color: AppTheme.surface, borderRadius: BorderRadius.circular(18)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(title, style: TextStyle(fontSize: 14, color: AppTheme.muted)),
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

  const _SwitchTile({required this.title, required this.value, required this.onChanged});

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

  const _ListTile({required this.title, this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontSize: 16)),
      subtitle: subtitle != null ? Text(subtitle!, style: TextStyle(color: AppTheme.muted)) : null,
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppTheme.muted),
      onTap: onTap,
    );
  }
}