import 'package:logger/logger.dart';

class TradingResult {
  final double quantity;
  final double cost;
  final double remainingBalance;
  final double newPositionCost;
  final String? error;

  const TradingResult({
    required this.quantity,
    required this.cost,
    required this.remainingBalance,
    required this.newPositionCost,
    this.error,
  });

  bool get success => error == null;
}

class TradingCalculator {
  static final Logger _logger = Logger();

  static TradingResult calculateBuy({
    required double accountBalance,
    required double currentPrice,
    required double positionRatio,
    required double currentPositionQuantity,
    required double currentPositionCost,
  }) {
    try {
      if (currentPrice <= 0) {
        return TradingResult(
          quantity: 0,
          cost: 0,
          remainingBalance: accountBalance,
          newPositionCost: currentPositionCost,
          error: '价格无效',
        );
      }

      if (positionRatio <= 0 || positionRatio > 1) {
        return TradingResult(
          quantity: 0,
          cost: 0,
          remainingBalance: accountBalance,
          newPositionCost: currentPositionCost,
          error: '仓位比例无效',
        );
      }

      final availableAmount = accountBalance * positionRatio;
      if (availableAmount < currentPrice) {
        return TradingResult(
          quantity: 0,
          cost: 0,
          remainingBalance: accountBalance,
          newPositionCost: currentPositionCost,
          error: '可用金额不足',
        );
      }

      final quantity = (availableAmount / currentPrice).floor();
      if (quantity <= 0) {
        return TradingResult(
          quantity: 0,
          cost: 0,
          remainingBalance: accountBalance,
          newPositionCost: currentPositionCost,
          error: '无法购买',
        );
      }

      final cost = quantity * currentPrice;
      final newTotalQuantity = currentPositionQuantity + quantity;
      final newPositionCost = currentPositionQuantity > 0
          ? (currentPositionCost * currentPositionQuantity + cost) / newTotalQuantity
          : currentPrice;

      _logger.d('买入计算: 余额=$accountBalance, 价格=$currentPrice, 比例=$positionRatio');
      _logger.d('买入结果: 数量=$quantity, 成本=$cost, 新持仓成本=$newPositionCost');

      return TradingResult(
        quantity: quantity.toDouble(),
        cost: cost,
        remainingBalance: accountBalance - cost,
        newPositionCost: newPositionCost,
      );
    } catch (e) {
      _logger.e('买入计算失败: $e');
      return TradingResult(
        quantity: 0,
        cost: 0,
        remainingBalance: accountBalance,
        newPositionCost: currentPositionCost,
        error: '计算失败: $e',
      );
    }
  }

  static TradingResult calculateSell({
    required double currentPositionQuantity,
    required double currentPositionCost,
    required double currentPrice,
    required double positionRatio,
    required double accountBalance,
  }) {
    try {
      if (currentPositionQuantity <= 0) {
        return TradingResult(
          quantity: 0,
          cost: 0,
          remainingBalance: accountBalance,
          newPositionCost: currentPositionCost,
          error: '当前无持仓',
        );
      }

      if (currentPrice <= 0) {
        return TradingResult(
          quantity: 0,
          cost: 0,
          remainingBalance: accountBalance,
          newPositionCost: currentPositionCost,
          error: '价格无效',
        );
      }

      if (positionRatio <= 0 || positionRatio > 1) {
        return TradingResult(
          quantity: 0,
          cost: 0,
          remainingBalance: accountBalance,
          newPositionCost: currentPositionCost,
          error: '仓位比例无效',
        );
      }

      final quantity = (currentPositionQuantity * positionRatio).floor();
      if (quantity <= 0) {
        return TradingResult(
          quantity: 0,
          cost: 0,
          remainingBalance: accountBalance,
          newPositionCost: currentPositionCost,
          error: '卖出数量不足',
        );
      }

      final revenue = quantity * currentPrice;
      final newPositionQuantity = currentPositionQuantity - quantity;
      final newPositionCost = newPositionQuantity > 0 ? currentPositionCost : 0.0;

      _logger.d('卖出计算: 持仓=$currentPositionQuantity, 价格=$currentPrice, 比例=$positionRatio');
      _logger.d('卖出结果: 数量=$quantity, 收入=$revenue, 剩余持仓=$newPositionQuantity');

      return TradingResult(
        quantity: quantity.toDouble(),
        cost: revenue,
        remainingBalance: accountBalance + revenue,
        newPositionCost: newPositionCost,
      );
    } catch (e) {
      _logger.e('卖出计算失败: $e');
      return TradingResult(
        quantity: 0,
        cost: 0,
        remainingBalance: accountBalance,
        newPositionCost: currentPositionCost,
        error: '计算失败: $e',
      );
    }
  }

  static double calculateProfit({
    required double positionCost,
    required double positionQuantity,
    required double currentPrice,
  }) {
    if (positionQuantity <= 0) return 0;
    return (currentPrice - positionCost) * positionQuantity;
  }

  static double calculateProfitRate({
    required double positionCost,
    required double currentPrice,
  }) {
    if (positionCost <= 0) return 0;
    return ((currentPrice - positionCost) / positionCost) * 100;
  }

  static double calculateTotalAssets({
    required double accountBalance,
    required double positionQuantity,
    required double currentPrice,
  }) {
    return accountBalance + (positionQuantity * currentPrice);
  }
}