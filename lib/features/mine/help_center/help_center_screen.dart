import 'package:flutter/material.dart';
import 'package:kline_trainer/theme/app_theme.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar:
          AppBar(title: const Text('帮助中心'), backgroundColor: AppTheme.surface),
      body: ListView(
        children: [
          const SizedBox(height: 12),
          _HelpSection(
            title: '常见问题',
            items: [
              _HelpItem(
                  title: '如何开始训练?', content: '在首页选择一个品种，点击开始训练按钮即可开始模拟交易训练。'),
              _HelpItem(
                  title: '训练数据如何获取?',
                  content: '训练数据来自真实历史行情，系统会随机选择训练周期内的历史数据。'),
              _HelpItem(
                  title: '如何添加自选品种?', content: '在品种列表中长按品种卡片，或在品种详情页点击添加自选按钮。'),
              _HelpItem(
                  title: '训练报告如何生成?',
                  content: '完成训练后系统会自动生成训练报告，包含收益率、胜率等统计数据。'),
            ],
          ),
          _HelpSection(
            title: '联系我们',
            items: [
              _HelpItem(title: '客服邮箱', content: 'support@kline-trainer.com'),
              _HelpItem(title: '工作时间', content: '周一至周五 9:00-18:00'),
            ],
          ),
        ],
      ),
    );
  }
}

class _HelpSection extends StatelessWidget {
  final String title;
  final List<_HelpItem> items;

  const _HelpSection({required this.title, required this.items});

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
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          ),
          ...items,
        ],
      ),
    );
  }
}

class _HelpItem extends StatelessWidget {
  final String title;
  final String content;

  const _HelpItem({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.border, width: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Text(content, style: TextStyle(fontSize: 14, color: AppTheme.muted)),
        ],
      ),
    );
  }
}
