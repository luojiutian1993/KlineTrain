import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:kline_trainer/data/models/account_model.dart';
import 'package:kline_trainer/data/models/position_model.dart';

part 'trading_provider.g.dart';

@riverpod
class Account extends _$Account {
  @override
  Future<AccountModel> build() async {
    return _generateMockAccount();
  }

  Future<void> refresh() async {
    state = await AsyncValue.guard(_generateMockAccount);
  }
}

@riverpod
class Positions extends _$Positions {
  @override
  Future<List<PositionModel>> build() async {
    return _generateMockPositions();
  }

  Future<void> refresh() async {
    state = await AsyncValue.guard(_generateMockPositions);
  }
}

Future<AccountModel> _generateMockAccount() async {
  await Future.delayed(const Duration(milliseconds: 500));

  return AccountModel(
    userId: 'user123',
    balance: 100000.00,
    availableBalance: 85000.00,
    usedMargin: 15000.00,
    frozenBalance: 0.00,
    totalProfit: 12500.00,
    todayProfit: 2300.00,
  );
}

Future<List<PositionModel>> _generateMockPositions() async {
  await Future.delayed(const Duration(milliseconds: 500));

  return [
    PositionModel(
      id: 'pos1',
      symbol: 'SH600000',
      direction: '多',
      openPrice: 10.50,
      currentPrice: 11.20,
      quantity: 1000.0,
      margin: 10500.0,
      profit: 700.0,
      profitPercent: 6.67,
      openTime: DateTime.now().subtract(const Duration(hours: 2)).millisecondsSinceEpoch,
      isClosed: false,
    ),
    PositionModel(
      id: 'pos2',
      symbol: 'SZ000001',
      direction: '多',
      openPrice: 8.30,
      currentPrice: 8.15,
      quantity: 500.0,
      margin: 4150.0,
      profit: -75.0,
      profitPercent: -1.81,
      openTime: DateTime.now().subtract(const Duration(hours: 1)).millisecondsSinceEpoch,
      isClosed: false,
    ),
  ];
}
