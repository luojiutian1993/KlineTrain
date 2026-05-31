import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kline_trainer/theme/app_theme.dart';
import 'package:kline_trainer/providers/user_provider.dart';
import 'package:kline_trainer/data/models/notice_model.dart';
import 'package:kline_trainer/shared/constants/app_colors.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(notificationsProvider.notifier).loadNotifications();
  }

  @override
  Widget build(BuildContext context) {
    final notificationsState = ref.watch(notificationsProvider);
    final notices = notificationsState.notices;

    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(
        title: const Text('消息通知'),
        backgroundColor: AppTheme.surface,
        actions: [
          TextButton(
            onPressed: () =>
                ref.read(notificationsProvider.notifier).markAllAsRead(),
            child: const Text('全部已读'),
          ),
        ],
      ),
      body: ListView(
        children: [
          const SizedBox(height: 12),
          ...notices.map((notice) => _NotificationItem(
                notice: notice,
                onTap: () => ref
                    .read(notificationsProvider.notifier)
                    .markAsRead(notice.id),
              )),
        ],
      ),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final NoticeModel notice;
  final VoidCallback onTap;

  const _NotificationItem({required this.notice, required this.onTap});

  IconData get _icon {
    switch (notice.type) {
      case NoticeType.system:
        return Icons.notifications;
      case NoticeType.activity:
        return Icons.event;
      case NoticeType.training:
        return Icons.trending_up;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: notice.isRead
            ? null
            : Border(left: BorderSide(color: AppTheme.accent, width: 4)),
      ),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: AppColors.notificationBg,
                  borderRadius: BorderRadius.circular(8)),
              child: Icon(_icon, color: AppTheme.accent, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(notice.title,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500)),
                      Text(
                        _formatDate(notice.publishedAt),
                        style: TextStyle(color: AppTheme.muted, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(notice.content,
                      style: TextStyle(color: AppTheme.muted, fontSize: 14)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    if (difference.inDays == 0) {
      return '今天';
    } else if (difference.inDays == 1) {
      return '昨天';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}天前';
    } else {
      return '${date.month}/${date.day}';
    }
  }
}
