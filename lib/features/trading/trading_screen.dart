import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kline_trainer/providers/trading_provider.dart';
import 'package:kline_trainer/data/models/account_model.dart';

class TradingScreen extends ConsumerWidget {
  const TradingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final account = ref.watch(accountProvider);
    final positions = ref.watch(positionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('模拟交易'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildAccountCard(account.valueOrNull),
            const SizedBox(height: 16),
            _buildOrderButtons(),
            const SizedBox(height: 16),
            _buildPositionList(positions.valueOrNull ?? []),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountCard(AccountModel? account) {
    if (account == null) {
      return const Card(
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              '账户总权益',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              '¥${account.balance.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        '可用余额',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '¥${account.availableBalance.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        '已用保证金',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '¥${account.usedMargin.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        '今日盈亏',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '¥${account.todayProfit.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 16,
                          color: account.todayProfit >= 0 ? Colors.red : Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('买入'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('卖出'),
          ),
        ),
      ],
    );
  }

  Widget _buildPositionList(List positions) {
    if (positions.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: const [
              Icon(Icons.inbox, size: 48, color: Colors.grey),
              SizedBox(height: 16),
              Text('暂无持仓'),
            ],
          ),
        ),
      );
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(12),
            child: Text('当前持仓'),
          ),
          const Divider(height: 1),
          ...positions.map((position) => ListTile(
                title: Text(position.symbol),
                subtitle: Text('方向: ${position.direction}'),
                trailing: Text(
                  position.profit >= 0 ? '+¥${position.profit}' : '¥${position.profit}',
                  style: TextStyle(
                    color: position.profit >= 0 ? Colors.red : Colors.green,
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
