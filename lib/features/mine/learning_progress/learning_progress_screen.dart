import 'package:flutter/material.dart';
import 'package:kline_trainer/theme/app_theme.dart';

class LearningProgressScreen extends StatelessWidget {
  const LearningProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar:
          AppBar(title: const Text('学习进度'), backgroundColor: AppTheme.surface),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(18)),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('当前进度',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500)),
                      Text('6/20 课程',
                          style:
                              TextStyle(color: AppTheme.accent, fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const LinearProgressIndicator(
                    value: 0.3,
                    backgroundColor: AppTheme.border,
                    color: AppTheme.accent,
                    borderRadius: BorderRadius.all(Radius.circular(999)),
                  ),
                  const SizedBox(height: 8),
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Text('30%', style: TextStyle(color: AppTheme.muted)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  _CourseCard(
                    title: '第1章 K线基础',
                    chapters: [
                      _Chapter(title: '1.1 K线概述', completed: true),
                      _Chapter(title: '1.2 单根K线解读', completed: true),
                      _Chapter(
                          title: '1.3 K线组合', completed: false, current: true),
                      _Chapter(title: '1.4 常见K线形态', completed: false),
                    ],
                  ),
                  _CourseCard(
                    title: '第2章 技术指标',
                    chapters: [
                      _Chapter(title: '2.1 均线基础', completed: false),
                      _Chapter(title: '2.2 MACD指标', completed: false),
                      _Chapter(title: '2.3 KDJ指标', completed: false),
                      _Chapter(title: '2.4 RSI指标', completed: false),
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
}

class _CourseCard extends StatelessWidget {
  final String title;
  final List<_Chapter> chapters;

  const _CourseCard({required this.title, required this.chapters});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
          color: AppTheme.surface, borderRadius: BorderRadius.circular(18)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.book, color: AppTheme.accent),
                const SizedBox(width: 8),
                Text(title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          ...chapters.map((chapter) => _ChapterItem(chapter: chapter)),
        ],
      ),
    );
  }
}

class _Chapter {
  final String title;
  final bool completed;
  final bool current;

  const _Chapter(
      {required this.title, required this.completed, this.current = false});
}

class _ChapterItem extends StatelessWidget {
  final _Chapter chapter;

  const _ChapterItem({required this.chapter});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: chapter.completed
          ? const Icon(Icons.check_circle, color: AppTheme.green)
          : chapter.current
              ? const Icon(Icons.play_circle, color: AppTheme.accent)
              : const Icon(Icons.circle_outlined, color: AppTheme.muted),
      title: Text(chapter.title),
      trailing: chapter.current
          ? const Icon(Icons.arrow_forward_ios, color: AppTheme.accent)
          : null,
      onTap: chapter.current ? () {} : null,
    );
  }
}
