import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kline_trainer/data/database/database_service.dart';
import 'package:kline_trainer/data/models/recent_trade_model.dart';
import 'package:kline_trainer/theme/app_theme.dart';

class TradeDetailScreen extends ConsumerStatefulWidget {
  final String symbol;
  final String symbolName;
  final String marketCode;

  const TradeDetailScreen({
    super.key,
    required this.symbol,
    required this.symbolName,
    required this.marketCode,
  });

  @override
  ConsumerState<TradeDetailScreen> createState() => _TradeDetailScreenState();
}

class _TradeDetailScreenState extends ConsumerState<TradeDetailScreen> {
  List<RecentTradeModel> _trades = [];
  bool _isLoading = true;
  double _totalProfit = 0;
  double _totalProfitRate = 0;
  int _winCount = 0;

  @override
  void initState() {
    super.initState();
    _loadTrades();
  }

  Future<void> _loadTrades() async {
    setState(() => _isLoading = true);
    try {
      final dbService = DatabaseService.instance;
      final tradesData = await dbService.trainingDao.getRecentTradesWithSymbol(
        1,
        limit: 100,
      );

      final filteredTrades = tradesData.where((t) {
        return t['symbol'] == widget.symbol &&
            t['marketCode'] == widget.marketCode;
      }).toList();

      _totalProfit = 0;
      _totalProfitRate = 0;
      _winCount = 0;

      _trades = filteredTrades.map((data) {
        final profit = (data['profit'] as double?) ?? 0;
        _totalProfit += profit;
        _totalProfitRate += (data['profitRate'] as double?) ?? 0;
        if (profit > 0) _winCount++;
        return RecentTradeModel(
          id: data['id'] as int,
          sessionId: data['sessionId'] as int,
          symbol: data['symbol'] as String,
          symbolName: data['symbolName'] as String,
          marketCode: data['marketCode'] as String,
          type: data['type'] as String,
          price: data['price'] as double,
          quantity: data['quantity'] as int,
          amount: data['amount'] as double,
          profit: profit,
          profitRate: (data['profitRate'] as double?) ?? 0,
          tradeDate: data['tradeDate'] as String,
          createdAt: data['createdAt'] as DateTime,
        );
      }).toList();

      _trades.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } catch (e) {
      debugPrint('Failed to load trades: $e');
    }
    setState(() => _isLoading = false);
  }

  String _formatDate(DateTime date) {
    return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.symbolName, style: const TextStyle(fontSize: 16)),
            Text(
              widget.marketCode == 'SH'
                  ? 'SH ${widget.symbol}'
                  : 'SZ ${widget.symbol}',
              style: TextStyle(fontSize: 12, color: AppTheme.muted),
            ),
          ],
        ),
        backgroundColor: AppTheme.surface,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildContent(),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        _buildSummaryCard(),
        Expanded(child: _buildTradesList()),
      ],
    );
  }

  Widget _buildSummaryCard() {
    final profitColor = _totalProfit >= 0 ? AppTheme.red : AppTheme.green;
    final profitRate =
        _trades.isNotEmpty ? _totalProfitRate / _trades.length : 0.0;
    final winRate =
        _trades.isNotEmpty ? (_winCount / _trades.length) * 100 : 0.0;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text('总盈亏',
                        style: TextStyle(fontSize: 12, color: AppTheme.muted)),
                    const SizedBox(height: 4),
                    Text(
                      _totalProfit >= 0
                          ? '+¥${_totalProfit.toStringAsFixed(2)}'
                          : '-¥${_totalProfit.abs().toStringAsFixed(2)}',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: profitColor),
                    ),
                  ],
                ),
              ),
              Container(width: 1, height: 40, color: AppTheme.border),
              Expanded(
                child: Column(
                  children: [
                    Text('平均收益率',
                        style: TextStyle(fontSize: 12, color: AppTheme.muted)),
                    const SizedBox(height: 4),
                    Text(
                      profitRate >= 0
                          ? '+${profitRate.toStringAsFixed(2)}%'
                          : '${profitRate.toStringAsFixed(2)}%',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color:
                              profitRate >= 0 ? AppTheme.red : AppTheme.green),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _StatItem(label: '交易笔数', value: '${_trades.length}笔'),
              _StatItem(label: '盈利笔数', value: '$_winCount笔'),
              _StatItem(label: '胜率', value: '${winRate.toStringAsFixed(1)}%'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTradesList() {
    if (_trades.isEmpty) {
      return const Center(child: Text('暂无交易记录'));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _trades.length,
      itemBuilder: (context, index) {
        final trade = _trades[index];
        return _TradeItem(trade: trade, formatDate: _formatDate);
      },
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(fontSize: 12, color: AppTheme.muted)),
      ],
    );
  }
}

class _TradeItem extends StatelessWidget {
  final RecentTradeModel trade;
  final String Function(DateTime) formatDate;

  const _TradeItem({required this.trade, required this.formatDate});

  @override
  Widget build(BuildContext context) {
    final isWin = trade.profit > 0;
    final profitColor = isWin ? AppTheme.red : AppTheme.green;
    final typeColor = trade.isBuy ? Colors.blue : Colors.orange;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: typeColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      trade.displayType,
                      style: TextStyle(
                          fontSize: 12,
                          color: typeColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    formatDate(trade.createdAt),
                    style: TextStyle(fontSize: 12, color: AppTheme.muted),
                  ),
                ],
              ),
              Text(
                trade.displayProfit,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: profitColor),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  '成交价: ¥${trade.price.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 12, color: AppTheme.muted),
                ),
              ),
              Expanded(
                child: Text(
                  '数量: ${trade.displayQuantity}',
                  style: TextStyle(fontSize: 12, color: AppTheme.muted),
                ),
              ),
              Expanded(
                child: Text(
                  '金额: ¥${trade.amount.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 12, color: AppTheme.muted),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
