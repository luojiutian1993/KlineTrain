import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kline_trainer/theme/app_theme.dart';
import 'package:kline_trainer/data/database/database_service.dart';
import 'package:kline_trainer/data/database/app_database.dart';

class RecordDetailScreen extends ConsumerStatefulWidget {
  final int sessionId;

  const RecordDetailScreen({super.key, required this.sessionId});

  @override
  ConsumerState<RecordDetailScreen> createState() => _RecordDetailScreenState();
}

class _RecordDetailScreenState extends ConsumerState<RecordDetailScreen> {
  TrainingSession? _session;
  List<Trade> _trades = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final dbService = DatabaseService.instance;
      _session = await dbService.trainingDao.getSession(widget.sessionId);
      _trades = await dbService.trainingDao.getSessionTrades(widget.sessionId);
    } catch (e) {
      debugPrint('Failed to load record detail: $e');
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
      'SZ000021': '深科技',
      'SH600016': '民生银行',
      'SZ000858': '五粮液',
      'SH601398': '工商银行',
      'SH600585': '海螺水泥',
    };
    return names[symbol] ?? symbol;
  }

  String _formatDateRange(DateTime? start, DateTime? end) {
    if (start == null || end == null) return '-';
    return '${start.year}.${start.month.toString().padLeft(2, '0')}.${start.day.toString().padLeft(2, '0')} - ${end.year}.${end.month.toString().padLeft(2, '0')}.${end.day.toString().padLeft(2, '0')}';
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return '-';
    try {
      final date = DateTime.parse(dateStr);
      return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(
        title: const Text('交易详情'),
        backgroundColor: AppTheme.surface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _session == null
              ? const Center(child: Text('记录不存在'))
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildSessionInfo(_session!),
                      _buildTradesList(),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
    );
  }

  Widget _buildSessionInfo(TrainingSession session) {
    return Container(
      margin: const EdgeInsets.all(16),
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
                    Text(_getStockName(session.symbol),
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(session.symbol,
                        style: TextStyle(fontSize: 14, color: AppTheme.muted)),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: (session.profitRate ?? 0) >= 0
                      ? AppTheme.red.withOpacity(0.1)
                      : AppTheme.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${(session.profitRate ?? 0) >= 0 ? '+' : ''}${(session.profitRate ?? 0).toStringAsFixed(2)}%',
                  style: TextStyle(
                    color: (session.profitRate ?? 0) >= 0
                        ? AppTheme.red
                        : AppTheme.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _InfoItem(
                    label: '训练周期',
                    value: _formatDateRange(session.startDate, session.endDate)),
              ),
              Expanded(
                child: _InfoItem(
                    label: '初始资金',
                    value: '¥${(session.initialCapital ?? 0).toStringAsFixed(2)}'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _InfoItem(
                    label: '最终资金',
                    value: '¥${(session.currentCapital ?? 0).toStringAsFixed(2)}'),
              ),
              Expanded(
                child: _InfoItem(
                    label: '总收益',
                    value: '¥${(session.totalProfit ?? 0).toStringAsFixed(2)}'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _InfoItem(
                    label: '交易次数', value: '${session.tradeCount ?? 0}次'),
              ),
              Expanded(
                child: _InfoItem(
                    label: '胜率',
                    value: '${(session.winRate ?? 0).toStringAsFixed(1)}%'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTradesList() {
    if (_trades.isEmpty) {
      return Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
            color: AppTheme.surface, borderRadius: BorderRadius.circular(18)),
        child: const Center(child: Text('暂无交易记录')),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Text('交易记录',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _trades.length,
            itemBuilder: (context, index) {
              final trade = _trades[index];
              return _TradeItem(trade: trade);
            },
          ),
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String label;
  final String value;

  const _InfoItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: AppTheme.muted)),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      ],
    );
  }
}

class _TradeItem extends StatelessWidget {
  final Trade trade;

  const _TradeItem({required this.trade});

  String _formatDate(String? dateStr) {
    if (dateStr == null) return '-';
    try {
      final date = DateTime.parse(dateStr);
      return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isBuy = trade.type == 'buy';
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: AppTheme.surface, borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: isBuy
                      ? AppTheme.red.withOpacity(0.1)
                      : AppTheme.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isBuy ? '买入' : '卖出',
                  style: TextStyle(
                    color: isBuy ? AppTheme.red : AppTheme.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(_formatDate(trade.tradeDate),
                  style: TextStyle(color: AppTheme.muted)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _TradeInfo(
                  label: '价格',
                  value: '¥${trade.price?.toStringAsFixed(2) ?? '0'}'),
              _TradeInfo(label: '数量', value: '${trade.quantity ?? 0}股'),
              _TradeInfo(
                  label: '金额',
                  value: '¥${trade.amount?.toStringAsFixed(2) ?? '0'}'),
            ],
          ),
          if (trade.profit != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '盈亏: ',
                    style: TextStyle(fontSize: 14, color: AppTheme.muted),
                  ),
                  Text(
                    '${trade.profit! >= 0 ? '+' : ''}¥${trade.profit?.toStringAsFixed(2) ?? '0'}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: trade.profit! >= 0 ? AppTheme.red : AppTheme.green,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '(${trade.profitRate! >= 0 ? '+' : ''}${trade.profitRate?.toStringAsFixed(2) ?? '0'}%)',
                    style: TextStyle(
                      fontSize: 14,
                      color: trade.profitRate! >= 0
                          ? AppTheme.red
                          : AppTheme.green,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _TradeInfo extends StatelessWidget {
  final String label;
  final String value;

  const _TradeInfo({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        Text(label, style: TextStyle(fontSize: 12, color: AppTheme.muted)),
      ],
    );
  }
}