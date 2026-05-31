import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kline_trainer/theme/app_theme.dart';
import 'package:kline_trainer/data/database/database_service.dart';
import 'package:kline_trainer/data/database/app_database.dart';
import 'package:kline_trainer/routes/app_routes.dart';
import 'package:kline_trainer/shared/notifiers/training_notifier.dart';

class TrainingHistoryScreen extends ConsumerStatefulWidget {
  final String? refreshKey;

  const TrainingHistoryScreen({super.key, this.refreshKey});

  @override
  ConsumerState<TrainingHistoryScreen> createState() =>
      _TrainingHistoryScreenState();
}

class _TrainingHistoryScreenState extends ConsumerState<TrainingHistoryScreen>
    with AutomaticKeepAliveClientMixin {
  List<TrainingSession> _sessions = [];
  bool _isLoading = true;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    print(
        '🐛 [TrainingHistoryScreen] initState - refreshKey: ${widget.refreshKey}');
    _loadTrainingSessions();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadTrainingSessions() async {
    print('🐛 [TrainingHistoryScreen] 开始加载训练数据...');
    setState(() => _isLoading = true);
    try {
      final dbService = DatabaseService.instance;
      _sessions = await dbService.trainingDao.getUserSessions(1);
      print('🐛 [TrainingHistoryScreen] 加载到 ${_sessions.length} 条训练记录');
      TrainingNotifier.instance.clearPendingUpdate();
    } catch (e) {
      print('🐛 [TrainingHistoryScreen] 加载失败: $e');
      debugPrint('Failed to load training sessions: $e');
    }
    setState(() => _isLoading = false);
  }

  String _getStockName(String symbol) {
    final names = {
      'SH600000': '浦发银行',
      'SH600036': '招商银行',
      'SH600519': '贵州茅台',
      'SH601318': '中国平安',
      'SZ300750': '宁德时代',
      'SZ002594': '比亚迪',
    };
    return names[symbol] ?? symbol;
  }

  String _formatDateRange(DateTime? start, DateTime? end) {
    if (start == null || end == null) return '-';
    return '${start.year}.${start.month.toString().padLeft(2, '0')}.${start.day.toString().padLeft(2, '0')} - ${end.year}.${end.month.toString().padLeft(2, '0')}.${end.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar:
          AppBar(title: const Text('训练记录'), backgroundColor: AppTheme.surface),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _sessions.isEmpty
              ? const Center(child: Text('暂无训练记录'))
              : ListView.builder(
                  itemCount: _sessions.length,
                  itemBuilder: (context, index) {
                    final session = _sessions[index];
                    return _TrainingCard(
                      session: session,
                      stockName: _getStockName(session.symbol),
                      onTap: () => context
                          .push('${AppRoutes.trainingHistory}/${session.id}'),
                    );
                  },
                ),
    );
  }
}

class _TrainingCard extends StatelessWidget {
  final TrainingSession session;
  final String stockName;
  final VoidCallback onTap;

  const _TrainingCard({
    required this.session,
    required this.stockName,
    required this.onTap,
  });

  String _formatDateRange(DateTime? start, DateTime? end) {
    if (start == null || end == null) return '-';
    return '${start.year}.${start.month.toString().padLeft(2, '0')}.${start.day.toString().padLeft(2, '0')} - ${end.year}.${end.month.toString().padLeft(2, '0')}.${end.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: AppTheme.surface, borderRadius: BorderRadius.circular(18)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(stockName,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 4),
                      Text(session.symbol,
                          style:
                              TextStyle(fontSize: 12, color: AppTheme.muted)),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppTheme.muted),
              ],
            ),
            const SizedBox(height: 8),
            Text(_formatDateRange(session.startDate, session.endDate),
                style: TextStyle(color: AppTheme.muted, fontSize: 14)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _StatChip(
                  label: '收益率',
                  value:
                      '${session.profitRate != null && session.profitRate! >= 0 ? '+' : ''}${session.profitRate?.toStringAsFixed(2) ?? '0'}%',
                  color: (session.profitRate ?? 0) >= 0
                      ? AppTheme.red
                      : AppTheme.green,
                ),
                _StatChip(label: '交易次数', value: '${session.tradeCount ?? 0}次'),
                _StatChip(
                    label: '胜率',
                    value: '${session.winRate?.toStringAsFixed(1) ?? '0'}%'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;

  const _StatChip({required this.label, required this.value, this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color ?? AppTheme.fg)),
        Text(label, style: TextStyle(fontSize: 12, color: AppTheme.muted)),
      ],
    );
  }
}
