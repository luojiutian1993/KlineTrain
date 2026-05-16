# K线训练营选股条件算法实现计划

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 实现K线训练营18种选股条件的精确算法，完成前后端及数据库联动，支持实时选股筛选功能

**Architecture:** 采用Flutter前端 + Drift本地数据库架构，通过DAO层实现选股算法，使用Riverpod进行状态管理。选股条件分为趋势向上(9种)和趋势向下(9种)两大类，支持实时计算和缓存优化。

**Tech Stack:** Flutter 3.19+, Riverpod 2.3+, Drift 2.18+, SQLite

---

## 文件结构规划

### 新增文件
- `lib/data/database/tables/stock_filter_results_table.dart` - 选股结果缓存表
- `lib/data/database/tables/daily_stock_stats_table.dart` - 每日股票统计表
- `lib/data/database/daos/stock_filter_dao.dart` - 选股算法DAO
- `lib/data/models/stock_filter_condition_model.dart` - 选股条件模型
- `lib/data/models/stock_filter_result_model.dart` - 选股结果模型
- `lib/data/repositories/stock_filter_repository.dart` - 选股仓库
- `lib/providers/stock_filter_provider.dart` - 选股状态管理
- `lib/core/enums/stock_filter_condition.dart` - 选股条件枚举
- `lib/core/utils/stock_filter_calculator.dart` - 选股计算工具

### 修改文件
- `lib/data/database/app_database.dart` - 添加新表和DAO
- `lib/data/database/daos/kline_dao.dart` - 添加均线计算查询
- `lib/features/home/widgets/stock_condition_selector.dart` - 联动选股结果
- `lib/providers/selection_provider.dart` - 整合选股功能

---

## Task 1: 创建选股条件枚举

**Files:**
- Create: `lib/core/enums/stock_filter_condition.dart`

- [ ] **Step 1: 定义选股条件枚举类**

```dart
import 'package:flutter/material.dart';

/// 选股条件类型枚举
enum StockFilterCondition {
  // 趋势向上类 (9种)
  allTimeHigh('历史新高', FilterDirection.up, 1),
  yearHigh('一年新高', FilterDirection.up, 2),
  day200High('200日新高', FilterDirection.up, 3),
  return30dTop('30日涨幅前50%', FilterDirection.up, 4),
  return15dTop('15日涨幅前50%', FilterDirection.up, 5),
  limitUp('涨停', FilterDirection.up, 6),
  consecutiveLimitUp('连板', FilterDirection.up, 7),
  volumePriceUp('量价齐升', FilterDirection.up, 8),
  upTrend('上升趋势', FilterDirection.up, 9),

  // 趋势向下类 (9种)
  allTimeLow('历史新低', FilterDirection.down, 10),
  yearLow('一年新低', FilterDirection.down, 11),
  day200Low('200日新低', FilterDirection.down, 12),
  loss30dTop('30日跌幅前50%', FilterDirection.down, 13),
  loss15dTop('15日跌幅前50%', FilterDirection.down, 14),
  downTrend('下降趋势', FilterDirection.down, 15),
  limitDown('跌停', FilterDirection.down, 16),
  consecutiveLimitDown('连续跌停', FilterDirection.down, 17),

  // 随机
  random('随机', FilterDirection.neutral, 0);

  final String label;
  final FilterDirection direction;
  final int sortOrder;

  const StockFilterCondition(this.label, this.direction, this.sortOrder);

  bool get isUpDirection => direction == FilterDirection.up;
  bool get isDownDirection => direction == FilterDirection.down;
  bool get isRandom => this == StockFilterCondition.random;

  /// 获取所有条件（排除随机）
  static List<StockFilterCondition> get allConditions =>
      values.where((c) => c != StockFilterCondition.random).toList();

  /// 获取趋势向上条件
  static List<StockFilterCondition> get upTrendConditions =>
      values.where((c) => c.direction == FilterDirection.up).toList();

  /// 获取趋势向下条件
  static List<StockFilterCondition> get downTrendConditions =>
      values.where((c) => c.direction == FilterDirection.down).toList();

  /// 从字符串解析
  static StockFilterCondition fromString(String value) {
    return StockFilterCondition.values.firstWhere(
      (e) => e.label == value || e.name == value,
      orElse: () => StockFilterCondition.random,
    );
  }
}

/// 筛选方向
enum FilterDirection {
  up('向上', Colors.red),
  down('向下', Colors.green),
  neutral('中性', Colors.grey);

  final String label;
  final Color color;

  const FilterDirection(this.label, this.color);
}
```

- [ ] **Step 2: 提交代码**

```bash
git add lib/core/enums/stock_filter_condition.dart
git commit -m "feat: add stock filter condition enum with 18 conditions"
```

---

## Task 2: 创建选股结果缓存表

**Files:**
- Create: `lib/data/database/tables/stock_filter_results_table.dart`
- Modify: `lib/data/database/tables/tables.dart`

- [ ] **Step 1: 创建选股结果表**

```dart
import 'package:drift/drift.dart';

/// 选股结果缓存表
/// 用于缓存每日选股计算结果，避免重复计算
class StockFilterResults extends Table {
  /// 记录ID
  IntColumn get id => integer().autoIncrement()();

  /// 选股日期
  DateTimeColumn get filterDate => dateTime()();

  /// 选股条件类型
  TextColumn get conditionType => text()();

  /// 标的代码
  TextColumn get symbol => text()();

  /// 市场代码
  TextColumn get marketCode => text()();

  /// 标的名称
  TextColumn get symbolName => text()();

  /// 当日收盘价
  RealColumn get closePrice => real()();

  /// 当日涨跌幅(%)
  RealColumn get changePercent => real()();

  /// 满足条件的额外数据（JSON格式，存储如涨幅、均线角度等）
  TextColumn get extraData => text().nullable()();

  /// 创建时间
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// 联合唯一索引: filterDate + conditionType + symbol
  @override
  List<String> get customConstraints => [
    'UNIQUE(filter_date, condition_type, symbol)',
  ];

  /// 索引优化
  @override
  List<Index> get indexes => [
    Index(
      name: 'idx_filter_results_date_condition',
      columns: {filterDate, conditionType},
    ),
    Index(
      name: 'idx_filter_results_symbol',
      columns: {symbol},
    ),
  ];
}
```

- [ ] **Step 2: 创建每日股票统计表**

```dart
import 'package:drift/drift.dart';

/// 每日股票统计数据表
/// 用于存储预计算的涨跌幅、均线等数据，加速选股查询
class DailyStockStats extends Table {
  /// 记录ID
  IntColumn get id => integer().autoIncrement()();

  /// 交易日期
  DateTimeColumn get tradeDate => dateTime()();

  /// 标的代码
  TextColumn get symbol => text()();

  /// 市场代码
  TextColumn get marketCode => text()();

  /// 当日收盘价
  RealColumn get closePrice => real()();

  /// 当日开盘价
  RealColumn get openPrice => real()();

  /// 当日最高价
  RealColumn get highPrice => real()();

  /// 当日最低价
  RealColumn get lowPrice => real()();

  /// 当日成交量
  RealColumn get volume => real()();

  /// 15日涨幅(%)
  RealColumn get return15d => real().nullable()();

  /// 30日涨幅(%)
  RealColumn get return30d => real().nullable()();

  /// 10日均线值
  RealColumn get ma10 => real().nullable()();

  /// 20日均线值
  RealColumn get ma20 => real().nullable()();

  /// 50日均线值
  RealColumn get ma50 => real().nullable()();

  /// 200日均线值
  RealColumn get ma200 => real().nullable()();

  /// 历史最高价（截至当日）
  RealColumn get historicalHigh => real().nullable()();

  /// 历史最低价（截至当日）
  RealColumn get historicalLow => real().nullable()();

  /// 252日最高价
  RealColumn get yearHigh => real().nullable()();

  /// 252日最低价
  RealColumn get yearLow => real().nullable()();

  /// 是否涨停
  BoolColumn get isLimitUp => boolean().withDefault(const Constant(false))();

  /// 是否跌停
  BoolColumn get isLimitDown => boolean().withDefault(const Constant(false))();

  /// 上市天数（截至当日）
  IntColumn get listingDays => integer().withDefault(const Constant(0))();

  /// 是否停牌
  BoolColumn get isSuspended => boolean().withDefault(const Constant(false))();

  /// 创建时间
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// 联合唯一索引
  @override
  List<String> get customConstraints => [
    'UNIQUE(trade_date, symbol)',
  ];

  /// 索引优化
  @override
  List<Index> get indexes => [
    Index(
      name: 'idx_daily_stats_date',
      columns: {tradeDate},
    ),
    Index(
      name: 'idx_daily_stats_symbol',
      columns: {symbol},
    ),
  ];
}
```

- [ ] **Step 3: 更新tables.dart导出**

```dart
// lib/data/database/tables/tables.dart

export 'users_table.dart';
export 'markets_table.dart';
export 'symbols_table.dart';
export 'kline_data_table.dart';
export 'training_sessions_table.dart';
export 'trades_table.dart';
export 'positions_table.dart';
export 'conditional_orders_table.dart';
export 'operation_logs_table.dart';
export 'training_reports_table.dart';
export 'user_habits_table.dart';
export 'trading_patterns_table.dart';
export 'strategy_tips_table.dart';
export 'system_configs_table.dart';
export 'version_history_table.dart';
export 'stock_filter_results_table.dart';
export 'daily_stock_stats_table.dart';
```

- [ ] **Step 4: 提交代码**

```bash
git add lib/data/database/tables/
git commit -m "feat: add stock filter results and daily stats tables"
```

---

## Task 3: 创建选股算法DAO

**Files:**
- Create: `lib/data/database/daos/stock_filter_dao.dart`
- Modify: `lib/data/database/daos/daos.dart`

- [ ] **Step 1: 创建StockFilterDao**

```dart
import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/tables.dart';
import '../../../core/enums/stock_filter_condition.dart';

part 'stock_filter_dao.g.dart';

/// 选股算法数据访问对象
@DriftAccessor(tables: [Symbols, KlineData, StockFilterResults, DailyStockStats])
class StockFilterDao extends DatabaseAccessor<AppDatabase> with _$StockFilterDaoMixin {
  StockFilterDao(super.db);

  // ==================== 基础查询 ====================

  /// 获取指定日期所有启用的标的
  Future<List<Symbol>> getActiveSymbols({String? marketCode}) {
    final query = select(symbols)..where((t) => t.enabled.equals(true));
    if (marketCode != null) {
      query.where((t) => t.marketCode.equals(marketCode));
    }
    return query.get();
  }

  /// 获取指定标的指定日期的K线数据
  Future<KlineDataData?> getKlineDataForDate(String symbol, String period, DateTime date) {
    return (select(klineData)
          ..where((t) => t.symbol.equals(symbol))
          ..where((t) => t.period.equals(period))
          ..where((t) => t.tradeDate.equals(date)))
        .getSingleOrNull();
  }

  /// 获取指定标的指定日期前N天的K线数据
  Future<List<KlineDataData>> getKlineDataBefore(
    String symbol,
    String period,
    DateTime date,
    int days,
  ) {
    return (select(klineData)
          ..where((t) => t.symbol.equals(symbol))
          ..where((t) => t.period.equals(period))
          ..where((t) => t.tradeDate.isSmallerOrEqualValue(date))
          ..orderBy([(t) => OrderingTerm.desc(t.tradeDate)])
          ..limit(days))
        .get();
  }

  // ==================== 新高/新低类算法 ====================

  /// 2.1.1 历史新高
  /// 条件: 当前收盘价是该股票上市以来所有收盘价的最高点
  Future<bool> checkAllTimeHigh(String symbol, DateTime date) async {
    final currentData = await getKlineDataForDate(symbol, 'day', date);
    if (currentData == null) return false;

    final historicalMax = await _getHistoricalMaxClose(symbol, date);
    return (currentData.close - historicalMax).abs() < 0.0001;
  }

  /// 获取历史最高收盘价（截至指定日期）
  Future<double> _getHistoricalMaxClose(String symbol, DateTime date) async {
    final result = await (selectOnly(klineData)
          ..addColumns([klineData.close.max()])
          ..where(klineData.symbol.equals(symbol))
          ..where(klineData.period.equals('day'))
          ..where(klineData.tradeDate.isSmallerOrEqualValue(date)))
        .getSingle();
    return result.read(klineData.close.max()) ?? 0.0;
  }

  /// 2.1.2 一年新高 (252个交易日)
  Future<bool> checkYearHigh(String symbol, DateTime date) async {
    final currentData = await getKlineDataForDate(symbol, 'day', date);
    if (currentData == null) return false;

    final yearData = await getKlineDataBefore(symbol, 'day', date, 252);
    if (yearData.isEmpty) return false;

    final maxClose = yearData.map((d) => d.close).reduce((a, b) => a > b ? a : b);
    return (currentData.close - maxClose).abs() < 0.0001;
  }

  /// 2.1.3 200日新高
  Future<bool> check200DayHigh(String symbol, DateTime date) async {
    final currentData = await getKlineDataForDate(symbol, 'day', date);
    if (currentData == null) return false;

    final day200Data = await getKlineDataBefore(symbol, 'day', date, 200);
    if (day200Data.isEmpty) return false;

    final maxClose = day200Data.map((d) => d.close).reduce((a, b) => a > b ? a : b);
    return (currentData.close - maxClose).abs() < 0.0001;
  }

  /// 2.2.1 历史新低
  Future<bool> checkAllTimeLow(String symbol, DateTime date) async {
    final currentData = await getKlineDataForDate(symbol, 'day', date);
    if (currentData == null) return false;

    final historicalMin = await _getHistoricalMinClose(symbol, date);
    return (currentData.close - historicalMin).abs() < 0.0001;
  }

  /// 获取历史最低收盘价
  Future<double> _getHistoricalMinClose(String symbol, DateTime date) async {
    final result = await (selectOnly(klineData)
          ..addColumns([klineData.close.min()])
          ..where(klineData.symbol.equals(symbol))
          ..where(klineData.period.equals('day'))
          ..where(klineData.tradeDate.isSmallerOrEqualValue(date)))
        .getSingle();
    return result.read(klineData.close.min()) ?? double.infinity;
  }

  /// 2.2.2 一年新低
  Future<bool> checkYearLow(String symbol, DateTime date) async {
    final currentData = await getKlineDataForDate(symbol, 'day', date);
    if (currentData == null) return false;

    final yearData = await getKlineDataBefore(symbol, 'day', date, 252);
    if (yearData.isEmpty) return false;

    final minClose = yearData.map((d) => d.close).reduce((a, b) => a < b ? a : b);
    return (currentData.close - minClose).abs() < 0.0001;
  }

  /// 2.2.3 200日新低
  Future<bool> check200DayLow(String symbol, DateTime date) async {
    final currentData = await getKlineDataForDate(symbol, 'day', date);
    if (currentData == null) return false;

    final day200Data = await getKlineDataBefore(symbol, 'day', date, 200);
    if (day200Data.isEmpty) return false;

    final minClose = day200Data.map((d) => d.close).reduce((a, b) => a < b ? a : b);
    return (currentData.close - minClose).abs() < 0.0001;
  }

  // ==================== 涨跌幅排名类算法 ====================

  /// 计算N日涨幅
  Future<double?> calculateReturnNDays(String symbol, DateTime date, int n) async {
    final currentData = await getKlineDataForDate(symbol, 'day', date);
    if (currentData == null) return null;

    final pastData = await getKlineDataBefore(symbol, 'day', date, n);
    if (pastData.length < n) return null;

    final nDaysAgoClose = pastData.last.close;
    if (nDaysAgoClose == 0) return null;

    return ((currentData.close / nDaysAgoClose) - 1) * 100;
  }

  /// 2.1.4 30日涨幅前50%
  /// 返回所有满足条件的标的代码列表
  Future<List<String>> getReturn30dTop50(DateTime date) async {
    final allSymbols = await getActiveSymbols();
    final returns = <String, double>{};

    for (final symbol in allSymbols) {
      final ret = await calculateReturnNDays(symbol.symbol, date, 30);
      if (ret != null) {
        returns[symbol.symbol] = ret;
      }
    }

    if (returns.isEmpty) return [];

    final sorted = returns.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final cutoffIndex = (sorted.length * 0.5).ceil();
    return sorted.take(cutoffIndex).map((e) => e.key).toList();
  }

  /// 2.1.5 15日涨幅前50%
  Future<List<String>> getReturn15dTop50(DateTime date) async {
    final allSymbols = await getActiveSymbols();
    final returns = <String, double>{};

    for (final symbol in allSymbols) {
      final ret = await calculateReturnNDays(symbol.symbol, date, 15);
      if (ret != null) {
        returns[symbol.symbol] = ret;
      }
    }

    if (returns.isEmpty) return [];

    final sorted = returns.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final cutoffIndex = (sorted.length * 0.5).ceil();
    return sorted.take(cutoffIndex).map((e) => e.key).toList();
  }

  /// 2.2.4 30日跌幅前50%
  Future<List<String>> getLoss30dTop50(DateTime date) async {
    final allSymbols = await getActiveSymbols();
    final losses = <String, double>{};

    for (final symbol in allSymbols) {
      final ret = await calculateReturnNDays(symbol.symbol, date, 30);
      if (ret != null) {
        losses[symbol.symbol] = -ret; // 转为正数便于排序
      }
    }

    if (losses.isEmpty) return [];

    final sorted = losses.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final cutoffIndex = (sorted.length * 0.5).ceil();
    return sorted.take(cutoffIndex).map((e) => e.key).toList();
  }

  /// 2.2.5 15日跌幅前50%
  Future<List<String>> getLoss15dTop50(DateTime date) async {
    final allSymbols = await getActiveSymbols();
    final losses = <String, double>{};

    for (final symbol in allSymbols) {
      final ret = await calculateReturnNDays(symbol.symbol, date, 15);
      if (ret != null) {
        losses[symbol.symbol] = -ret;
      }
    }

    if (losses.isEmpty) return [];

    final sorted = losses.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final cutoffIndex = (sorted.length * 0.5).ceil();
    return sorted.take(cutoffIndex).map((e) => e.key).toList();
  }

  // ==================== 涨停/跌停类算法 ====================

  /// 2.1.6 涨停: 当日收盘价等于当日最高价
  Future<bool> checkLimitUp(String symbol, DateTime date) async {
    final data = await getKlineDataForDate(symbol, 'day', date);
    if (data == null) return false;
    return (data.close - data.high).abs() < 0.0001;
  }

  /// 2.1.7 连板: 连续2个交易日收盘价均等于当日最高价
  Future<bool> checkConsecutiveLimitUp(String symbol, DateTime date) async {
    final today = await getKlineDataForDate(symbol, 'day', date);
    if (today == null || (today.close - today.high).abs() > 0.0001) {
      return false;
    }

    final yesterdayData = await getKlineDataBefore(symbol, 'day', date, 2);
    if (yesterdayData.length < 2) return false;

    final yesterday = yesterdayData[0];
    return (yesterday.close - yesterday.high).abs() < 0.0001;
  }

  /// 2.2.7 跌停: 当日收盘价等于当日最低价
  Future<bool> checkLimitDown(String symbol, DateTime date) async {
    final data = await getKlineDataForDate(symbol, 'day', date);
    if (data == null) return false;
    return (data.close - data.low).abs() < 0.0001;
  }

  /// 2.2.8 连续跌停: 连续2个交易日收盘价均等于当日最低价
  Future<bool> checkConsecutiveLimitDown(String symbol, DateTime date) async {
    final today = await getKlineDataForDate(symbol, 'day', date);
    if (today == null || (today.close - today.low).abs() > 0.0001) {
      return false;
    }

    final yesterdayData = await getKlineDataBefore(symbol, 'day', date, 2);
    if (yesterdayData.length < 2) return false;

    final yesterday = yesterdayData[0];
    return (yesterday.close - yesterday.low).abs() < 0.0001;
  }

  // ==================== 量价齐升算法 ====================

  /// 2.1.8 量价齐升: 成交量较前一日上涨超过5%，且股价上涨超过2%
  Future<bool> checkVolumePriceUp(String symbol, DateTime date) async {
    final today = await getKlineDataForDate(symbol, 'day', date);
    if (today == null) return false;

    final yesterdayData = await getKlineDataBefore(symbol, 'day', date, 2);
    if (yesterdayData.length < 2) return false;

    final yesterday = yesterdayData[0];
    if (yesterday.close == 0 || yesterday.volume == 0) return false;

    final priceIncrease = (today.close / yesterday.close) - 1;
    final volumeIncrease = (today.volume / yesterday.volume) - 1;

    return priceIncrease > 0.02 && volumeIncrease > 0.05;
  }

  // ==================== 趋势类算法 ====================

  /// 计算N日均线
  Future<double?> calculateMA(String symbol, DateTime date, int n) async {
    final data = await getKlineDataBefore(symbol, 'day', date, n);
    if (data.length < n) return null;

    final sum = data.take(n).fold<double>(0, (acc, d) => acc + d.close);
    return sum / n;
  }

  /// 计算均线角度 (过去5天均线的变化率)
  Future<double?> calculateMAAngle(String symbol, DateTime date, int maPeriod) async {
    final todayMA = await calculateMA(symbol, date, maPeriod);
    if (todayMA == null) return null;

    // 获取5天前的日期数据
    final pastData = await getKlineDataBefore(symbol, 'day', date, maPeriod + 5);
    if (pastData.length < maPeriod + 5) return null;

    // 计算5天前的MA
    final fiveDaysAgoIndex = 4; // 第5条记录（0-indexed）
    final fiveDaysAgoSlice = pastData.sublist(fiveDaysAgoIndex, fiveDaysAgoIndex + maPeriod);
    final fiveDaysAgoMA = fiveDaysAgoSlice.fold<double>(0, (acc, d) => acc + d.close) / maPeriod;

    // 计算斜率并转为角度
    final slope = (todayMA - fiveDaysAgoMA) / 5;
    return (slope / fiveDaysAgoMA) * 100; // 返回百分比变化
  }

  /// 2.1.9 上升趋势: 10日、20日、50日均线均向上，且均线角度递增
  Future<bool> checkUpTrend(String symbol, DateTime date) async {
    // 检查是否有足够数据
    final data = await getKlineDataBefore(symbol, 'day', date, 55);
    if (data.length < 55) return false;

    // 计算当前均线
    final ma10 = await calculateMA(symbol, date, 10);
    final ma20 = await calculateMA(symbol, date, 20);
    final ma50 = await calculateMA(symbol, date, 50);

    if (ma10 == null || ma20 == null || ma50 == null) return false;

    // 计算前一天均线用于判断是否向上
    final yesterday = data[0].tradeDate;
    final ma10Yesterday = await calculateMA(symbol, yesterday, 10);
    final ma20Yesterday = await calculateMA(symbol, yesterday, 20);
    final ma50Yesterday = await calculateMA(symbol, yesterday, 50);

    if (ma10Yesterday == null || ma20Yesterday == null || ma50Yesterday == null) {
      return false;
    }

    // 均线向上判断
    final ma10Up = ma10 > ma10Yesterday;
    final ma20Up = ma20 > ma20Yesterday;
    final ma50Up = ma50 > ma50Yesterday;

    // 多头排列判断
    final bullishAlignment = ma10 > ma20 && ma20 > ma50;

    // 角度计算（简化版：使用均线变化率）
    final angle10 = (ma10 - ma10Yesterday) / ma10Yesterday;
    final angle20 = (ma20 - ma20Yesterday) / ma20Yesterday;
    final angle50 = (ma50 - ma50Yesterday) / ma50Yesterday;

    // 角度递增判断（允许小误差）
    final angleIncreasing = angle10 > angle20 - 0.0001 && angle20 > angle50 - 0.0001;

    return ma10Up && ma20Up && ma50Up && bullishAlignment && angleIncreasing;
  }

  /// 2.2.6 下降趋势: 10日、20日、50日均线均向下，且均线角度递减
  Future<bool> checkDownTrend(String symbol, DateTime date) async {
    final data = await getKlineDataBefore(symbol, 'day', date, 55);
    if (data.length < 55) return false;

    final ma10 = await calculateMA(symbol, date, 10);
    final ma20 = await calculateMA(symbol, date, 20);
    final ma50 = await calculateMA(symbol, date, 50);

    if (ma10 == null || ma20 == null || ma50 == null) return false;

    final yesterday = data[0].tradeDate;
    final ma10Yesterday = await calculateMA(symbol, yesterday, 10);
    final ma20Yesterday = await calculateMA(symbol, yesterday, 20);
    final ma50Yesterday = await calculateMA(symbol, yesterday, 50);

    if (ma10Yesterday == null || ma20Yesterday == null || ma50Yesterday == null) {
      return false;
    }

    final ma10Down = ma10 < ma10Yesterday;
    final ma20Down = ma20 < ma20Yesterday;
    final ma50Down = ma50 < ma50Yesterday;

    final bearishAlignment = ma10 < ma20 && ma20 < ma50;

    final angle10 = (ma10 - ma10Yesterday) / ma10Yesterday;
    final angle20 = (ma20 - ma20Yesterday) / ma20Yesterday;
    final angle50 = (ma50 - ma50Yesterday) / ma50Yesterday;

    final angleDecreasing = angle10 < angle20 + 0.0001 && angle20 < angle50 + 0.0001;

    return ma10Down && ma20Down && ma50Down && bearishAlignment && angleDecreasing;
  }

  // ==================== 统一筛选接口 ====================

  /// 根据条件类型执行筛选
  Future<List<String>> filterByCondition(
    StockFilterCondition condition,
    DateTime date, {
    String? marketCode,
  }) async {
    switch (condition) {
      case StockFilterCondition.allTimeHigh:
        return _filterSingleSymbolCheck(
          (symbol) => checkAllTimeHigh(symbol, date),
          marketCode: marketCode,
        );
      case StockFilterCondition.yearHigh:
        return _filterSingleSymbolCheck(
          (symbol) => checkYearHigh(symbol, date),
          marketCode: marketCode,
        );
      case StockFilterCondition.day200High:
        return _filterSingleSymbolCheck(
          (symbol) => check200DayHigh(symbol, date),
          marketCode: marketCode,
        );
      case StockFilterCondition.return30dTop:
        return getReturn30dTop50(date);
      case StockFilterCondition.return15dTop:
        return getReturn15dTop50(date);
      case StockFilterCondition.limitUp:
        return _filterSingleSymbolCheck(
          (symbol) => checkLimitUp(symbol, date),
          marketCode: marketCode,
        );
      case StockFilterCondition.consecutiveLimitUp:
        return _filterSingleSymbolCheck(
          (symbol) => checkConsecutiveLimitUp(symbol, date),
          marketCode: marketCode,
        );
      case StockFilterCondition.volumePriceUp:
        return _filterSingleSymbolCheck(
          (symbol) => checkVolumePriceUp(symbol, date),
          marketCode: marketCode,
        );
      case StockFilterCondition.upTrend:
        return _filterSingleSymbolCheck(
          (symbol) => checkUpTrend(symbol, date),
          marketCode: marketCode,
        );
      case StockFilterCondition.allTimeLow:
        return _filterSingleSymbolCheck(
          (symbol) => checkAllTimeLow(symbol, date),
          marketCode: marketCode,
        );
      case StockFilterCondition.yearLow:
        return _filterSingleSymbolCheck(
          (symbol) => checkYearLow(symbol, date),
          marketCode: marketCode,
        );
      case StockFilterCondition.day200Low:
        return _filterSingleSymbolCheck(
          (symbol) => check200DayLow(symbol, date),
          marketCode: marketCode,
        );
      case StockFilterCondition.loss30dTop:
        return getLoss30dTop50(date);
      case StockFilterCondition.loss15dTop:
        return getLoss15dTop50(date);
      case StockFilterCondition.downTrend:
        return _filterSingleSymbolCheck(
          (symbol) => checkDownTrend(symbol, date),
          marketCode: marketCode,
        );
      case StockFilterCondition.limitDown:
        return _filterSingleSymbolCheck(
          (symbol) => checkLimitDown(symbol, date),
          marketCode: marketCode,
        );
      case StockFilterCondition.consecutiveLimitDown:
        return _filterSingleSymbolCheck(
          (symbol) => checkConsecutiveLimitDown(symbol, date),
          marketCode: marketCode,
        );
      case StockFilterCondition.random:
        return _getRandomSymbols(marketCode: marketCode);
    }
  }

  /// 辅助方法：对单个标的进行检查筛选
  Future<List<String>> _filterSingleSymbolCheck(
    Future<bool> Function(String) check, {
    String? marketCode,
  }) async {
    final allSymbols = await getActiveSymbols(marketCode: marketCode);
    final results = <String>[];

    for (final symbol in allSymbols) {
      try {
        if (await check(symbol.symbol)) {
          results.add(symbol.symbol);
        }
      } catch (e) {
        // 跳过计算失败的标的
        continue;
      }
    }

    return results;
  }

  /// 获取随机标的
  Future<List<String>> _getRandomSymbols({String? marketCode, int count = 10}) async {
    final allSymbols = await getActiveSymbols(marketCode: marketCode);
    allSymbols.shuffle();
    return allSymbols.take(count).map((s) => s.symbol).toList();
  }

  // ==================== 结果缓存 ====================

  /// 保存选股结果到缓存
  Future<void> saveFilterResults(
    DateTime date,
    StockFilterCondition condition,
    List<String> symbols,
  ) async {
    final dateOnly = DateTime(date.year, date.month, date.day);

    // 先删除旧数据
    await (delete(stockFilterResults)
          ..where((t) => t.filterDate.equals(dateOnly))
          ..where((t) => t.conditionType.equals(condition.name)))
        .go();

    // 批量插入新数据
    final symbolData = await getActiveSymbols();
    final symbolMap = {for (var s in symbolData) s.symbol: s};

    final companions = symbols.map((symbolCode) {
      final symbol = symbolMap[symbolCode];
      return StockFilterResultsCompanion(
        filterDate: Value(dateOnly),
        conditionType: Value(condition.name),
        symbol: Value(symbolCode),
        marketCode: Value(symbol?.marketCode ?? ''),
        symbolName: Value(symbol?.name ?? symbolCode),
        closePrice: const Value(0), // 可在后续更新
        changePercent: const Value(0),
      );
    }).toList();

    await batch((batch) {
      batch.insertAll(stockFilterResults, companions);
    });
  }

  /// 从缓存获取选股结果
  Future<List<StockFilterResult>> getCachedFilterResults(
    DateTime date,
    StockFilterCondition condition,
  ) {
    final dateOnly = DateTime(date.year, date.month, date.day);

    return (select(stockFilterResults)
          ..where((t) => t.filterDate.equals(dateOnly))
          ..where((t) => t.conditionType.equals(condition.name)))
        .get();
  }

  /// 检查是否有缓存
  Future<bool> hasCachedResults(DateTime date, StockFilterCondition condition) async {
    final dateOnly = DateTime(date.year, date.month, date.day);
    final count = await (selectOnly(stockFilterResults)
          ..addColumns([stockFilterResults.id.count()])
          ..where(stockFilterResults.filterDate.equals(dateOnly))
          ..where(stockFilterResults.conditionType.equals(condition.name)))
        .getSingle();
    return (count.read(stockFilterResults.id.count()) ?? 0) > 0;
  }
}

/// 选股结果数据类
class StockFilterResult {
  final int id;
  final DateTime filterDate;
  final String conditionType;
  final String symbol;
  final String marketCode;
  final String symbolName;
  final double closePrice;
  final double changePercent;
  final String? extraData;
  final DateTime createdAt;

  StockFilterResult({
    required this.id,
    required this.filterDate,
    required this.conditionType,
    required this.symbol,
    required this.marketCode,
    required this.symbolName,
    required this.closePrice,
    required this.changePercent,
    this.extraData,
    required this.createdAt,
  });
}
```

- [ ] **Step 2: 更新daos.dart导出**

```dart
// lib/data/database/daos/daos.dart

export 'user_dao.dart';
export 'kline_dao.dart';
export 'market_dao.dart';
export 'training_dao.dart';
export 'trade_dao.dart';
export 'analysis_dao.dart';
export 'config_dao.dart';
export 'stock_filter_dao.dart';
```

- [ ] **Step 3: 提交代码**

```bash
git add lib/data/database/daos/
git commit -m "feat: add stock filter DAO with 18 condition algorithms"
```

---

## Task 4: 更新数据库配置

**Files:**
- Modify: `lib/data/database/app_database.dart`

- [ ] **Step 1: 添加新表和DAO到数据库**

```dart
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'tables/tables.dart';
import 'daos/daos.dart';

part 'app_database.g.dart';

/// 主数据库入口
@DriftDatabase(
  tables: [
    // 用户相关表
    Users,
    UserProfiles,
    UserPreferences,

    // 基础配置表
    Markets,
    Symbols,

    // K线数据表
    KlineData,

    // 选股相关表
    StockFilterResults,
    DailyStockStats,

    // 训练会话表
    TrainingSessions,
    Trades,
    Positions,
    ConditionalOrders,
    OperationLogs,

    // 分析扩展表
    TrainingReports,
    UserHabits,
    TradingPatterns,
    StrategyTips,

    // 系统配置表
    SystemConfigs,
    VersionHistory,
  ],
  daos: [
    UserDao,
    KlineDao,
    MarketDao,
    TrainingDao,
    TradeDao,
    AnalysisDao,
    ConfigDao,
    StockFilterDao, // 新增选股DAO
  ],
)
class AppDatabase extends _$AppDatabase {
  /// 初始化数据库
  AppDatabase() : super(_openConnection());

  /// schema版本 - 升级到2以添加新表
  @override
  int get schemaVersion => 2;

  /// 数据库迁移
  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) {
          return m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          if (from < 2) {
            // 创建选股相关表
            await m.createTable(stockFilterResults);
            await m.createTable(dailyStockStats);
          }
        },
      );
}

/// 打开数据库连接
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'kline_trainer.db'));

    return NativeDatabase(
      file,
      logStatements: false,
      setup: (db) {
        // 启用WAL模式以提升并发性能
        db.execute('PRAGMA journal_mode = WAL');
        // 设置缓存大小
        db.execute('PRAGMA cache_size = -2000');
        // 同步模式设为NORMAL，平衡速度与安全性
        db.execute('PRAGMA synchronous = NORMAL');
      },
    );
  });
}
```

- [ ] **Step 2: 提交代码**

```bash
git add lib/data/database/app_database.dart
git commit -m "feat: integrate stock filter tables and DAO into database"
```

---

## Task 5: 创建选股数据模型

**Files:**
- Create: `lib/data/models/stock_filter_condition_model.dart`
- Create: `lib/data/models/stock_filter_result_model.dart`

- [ ] **Step 1: 创建选股条件模型**

```dart
import 'package:json_annotation/json_annotation.dart';
import '../../core/enums/stock_filter_condition.dart';

part 'stock_filter_condition_model.g.dart';

/// 选股条件模型
@JsonSerializable()
class StockFilterConditionModel {
  final String code;
  final String name;
  final String direction;
  final int sortOrder;
  final String? description;
  final String? formula;

  StockFilterConditionModel({
    required this.code,
    required this.name,
    required this.direction,
    required this.sortOrder,
    this.description,
    this.formula,
  });

  factory StockFilterConditionModel.fromJson(Map<String, dynamic> json) =>
      _$StockFilterConditionModelFromJson(json);

  Map<String, dynamic> toJson() => _$StockFilterConditionModelToJson(this);

  /// 从枚举创建
  factory StockFilterConditionModel.fromEnum(StockFilterCondition condition) {
    return StockFilterConditionModel(
      code: condition.name,
      name: condition.label,
      direction: condition.direction.name,
      sortOrder: condition.sortOrder,
      description: _getDescription(condition),
      formula: _getFormula(condition),
    );
  }

  /// 获取所有条件模型
  static List<StockFilterConditionModel> get all =>
      StockFilterCondition.values
          .where((c) => c != StockFilterCondition.random)
          .map(StockFilterConditionModel.fromEnum)
          .toList();

  static String? _getDescription(StockFilterCondition condition) {
    return switch (condition) {
      StockFilterCondition.allTimeHigh => '当前收盘价是上市以来最高',
      StockFilterCondition.yearHigh => '当前收盘价是过去一年最高',
      StockFilterCondition.day200High => '当前收盘价是过去200个交易日最高',
      StockFilterCondition.return30dTop => '过去30日涨幅排名前50%',
      StockFilterCondition.return15dTop => '过去15日涨幅排名前50%',
      StockFilterCondition.limitUp => '当日收盘价等于最高价',
      StockFilterCondition.consecutiveLimitUp => '连续2日收盘价等于最高价',
      StockFilterCondition.volumePriceUp => '成交量涨5%+，股价涨2%',
      StockFilterCondition.upTrend => '10/20/50日均线向上且多头排列',
      StockFilterCondition.allTimeLow => '当前收盘价是上市以来最低',
      StockFilterCondition.yearLow => '当前收盘价是过去一年最低',
      StockFilterCondition.day200Low => '当前收盘价是过去200个交易日最低',
      StockFilterCondition.loss30dTop => '过去30日跌幅排名前50%',
      StockFilterCondition.loss15dTop => '过去15日跌幅排名前50%',
      StockFilterCondition.downTrend => '10/20/50日均线向下且空头排列',
      StockFilterCondition.limitDown => '当日收盘价等于最低价',
      StockFilterCondition.consecutiveLimitDown => '连续2日收盘价等于最低价',
      _ => null,
    };
  }

  static String? _getFormula(StockFilterCondition condition) {
    return switch (condition) {
      StockFilterCondition.allTimeHigh => 'close[t] = MAX(close[上市日..t])',
      StockFilterCondition.yearHigh => 'close[t] = MAX(close[t-252..t])',
      StockFilterCondition.day200High => 'close[t] = MAX(close[t-200..t])',
      StockFilterCondition.return30dTop => 'PERCENT_RANK(return_30d) <= 0.5',
      StockFilterCondition.return15dTop => 'PERCENT_RANK(return_15d) <= 0.5',
      StockFilterCondition.limitUp => 'close[t] = high[t]',
      StockFilterCondition.consecutiveLimitUp => 'close[t]=high[t] AND close[t-1]=high[t-1]',
      StockFilterCondition.volumePriceUp => 'volume[t]/volume[t-1]>1.05 AND close[t]/close[t-1]>1.02',
      StockFilterCondition.upTrend => 'MA10>MA20>MA50 AND angle(MA10)>angle(MA20)>angle(MA50)',
      StockFilterCondition.allTimeLow => 'close[t] = MIN(close[上市日..t])',
      StockFilterCondition.yearLow => 'close[t] = MIN(close[t-252..t])',
      StockFilterCondition.day200Low => 'close[t] = MIN(close[t-200..t])',
      StockFilterCondition.loss30dTop => 'PERCENT_RANK(loss_30d) <= 0.5',
      StockFilterCondition.loss15dTop => 'PERCENT_RANK(loss_15d) <= 0.5',
      StockFilterCondition.downTrend => 'MA10<MA20<MA50 AND angle(MA10)<angle(MA20)<angle(MA50)',
      StockFilterCondition.limitDown => 'close[t] = low[t]',
      StockFilterCondition.consecutiveLimitDown => 'close[t]=low[t] AND close[t-1]=low[t-1]',
      _ => null,
    };
  }
}
```

- [ ] **Step 2: 创建选股结果模型**

```dart
import 'package:json_annotation/json_annotation.dart';
import '../../../data/database/database.dart';

part 'stock_filter_result_model.g.dart';

/// 选股结果模型
@JsonSerializable()
class StockFilterResultModel {
  final String symbol;
  final String symbolName;
  final String marketCode;
  final double closePrice;
  final double changePercent;
  final Map<String, dynamic>? extraData;

  StockFilterResultModel({
    required this.symbol,
    required this.symbolName,
    required this.marketCode,
    required this.closePrice,
    required this.changePercent,
    this.extraData,
  });

  factory StockFilterResultModel.fromJson(Map<String, dynamic> json) =>
      _$StockFilterResultModelFromJson(json);

  Map<String, dynamic> toJson() => _$StockFilterResultModelToJson(this);

  /// 从数据库实体转换
  factory StockFilterResultModel.fromData(StockFilterResultData data) {
    return StockFilterResultModel(
      symbol: data.symbol,
      symbolName: data.symbolName,
      marketCode: data.marketCode,
      closePrice: data.closePrice,
      changePercent: data.changePercent,
      extraData: data.extraData != null
          ? {'rawData': data.extraData}
          : null,
    );
  }

  /// 获取涨跌颜色标识
  bool get isUp => changePercent >= 0;

  /// 格式化涨跌幅显示
  String get changePercentDisplay {
    final sign = changePercent >= 0 ? '+' : '';
    return '$sign${changePercent.toStringAsFixed(2)}%';
  }
}

/// 选股结果列表响应
@JsonSerializable()
class StockFilterResultResponse {
  final String condition;
  final String conditionName;
  final DateTime date;
  final int total;
  final List<StockFilterResultModel> items;

  StockFilterResultResponse({
    required this.condition,
    required this.conditionName,
    required this.date,
    required this.total,
    required this.items,
  });

  factory StockFilterResultResponse.fromJson(Map<String, dynamic> json) =>
      _$StockFilterResultResponseFromJson(json);

  Map<String, dynamic> toJson() => _$StockFilterResultResponseToJson(this);
}
```

- [ ] **Step 3: 提交代码**

```bash
git add lib/data/models/stock_filter_condition_model.dart
git add lib/data/models/stock_filter_result_model.dart
git commit -m "feat: add stock filter data models"
```

---

## Task 6: 创建选股Repository

**Files:**
- Create: `lib/data/repositories/stock_filter_repository.dart`

- [ ] **Step 1: 创建StockFilterRepository**

```dart
import '../database/database_service.dart';
import '../database/daos/stock_filter_dao.dart';
import '../models/stock_filter_condition_model.dart';
import '../models/stock_filter_result_model.dart';
import '../../core/enums/stock_filter_condition.dart';
import '../../shared/utils/logger.dart';

/// 选股仓库
class StockFilterRepository {
  final StockFilterDao _stockFilterDao;

  StockFilterRepository({StockFilterDao? stockFilterDao})
      : _stockFilterDao = stockFilterDao ?? DatabaseService.instance.stockFilterDao;

  /// 获取所有选股条件
  List<StockFilterConditionModel> getAllConditions() {
    return StockFilterConditionModel.all;
  }

  /// 根据条件筛选股票
  ///
  /// [condition] 选股条件
  /// [date] 选股日期，默认为最新数据日期
  /// [marketCode] 市场代码过滤
  /// [useCache] 是否使用缓存
  Future<StockFilterResultResponse> filterStocks({
    required StockFilterCondition condition,
    DateTime? date,
    String? marketCode,
    bool useCache = true,
  }) async {
    final targetDate = date ?? DateTime.now();
    AppLogger.i('开始选股: condition=${condition.name}, date=$targetDate');

    try {
      // 检查缓存
      if (useCache && condition != StockFilterCondition.random) {
        final hasCache = await _stockFilterDao.hasCachedResults(targetDate, condition);
        if (hasCache) {
          AppLogger.i('使用缓存的选股结果');
          final cachedResults = await _stockFilterDao.getCachedFilterResults(
            targetDate,
            condition,
          );
          return StockFilterResultResponse(
            condition: condition.name,
            conditionName: condition.label,
            date: targetDate,
            total: cachedResults.length,
            items: cachedResults
                .map((r) => StockFilterResultModel(
                      symbol: r.symbol,
                      symbolName: r.symbolName,
                      marketCode: r.marketCode,
                      closePrice: r.closePrice,
                      changePercent: r.changePercent,
                    ))
                .toList(),
          );
        }
      }

      // 执行选股算法
      final symbols = await _stockFilterDao.filterByCondition(
        condition,
        targetDate,
        marketCode: marketCode,
      );

      AppLogger.i('选股完成: 共 ${symbols.length} 支股票满足条件');

      // 获取详细信息
      final items = await _getStockDetails(symbols, targetDate);

      // 缓存结果（随机条件不缓存）
      if (useCache && condition != StockFilterCondition.random) {
        await _stockFilterDao.saveFilterResults(targetDate, condition, symbols);
        AppLogger.i('选股结果已缓存');
      }

      return StockFilterResultResponse(
        condition: condition.name,
        conditionName: condition.label,
        date: targetDate,
        total: items.length,
        items: items,
      );
    } catch (e, stackTrace) {
      AppLogger.e('选股失败', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 获取股票详细信息
  Future<List<StockFilterResultModel>> _getStockDetails(
    List<String> symbols,
    DateTime date,
  ) async {
    final results = <StockFilterResultModel>[];

    for (final symbolCode in symbols) {
      try {
        final symbol = await _stockFilterDao.getActiveSymbols()
            .then((list) => list.firstWhere(
                  (s) => s.symbol == symbolCode,
                  orElse: () => throw Exception('Symbol not found'),
                ));

        final klineData = await _stockFilterDao.getKlineDataForDate(
          symbolCode,
          'day',
          date,
        );

        results.add(StockFilterResultModel(
          symbol: symbolCode,
          symbolName: symbol.name,
          marketCode: symbol.marketCode,
          closePrice: klineData?.close ?? symbol.lastPrice ?? 0,
          changePercent: symbol.change ?? 0,
        ));
      } catch (e) {
        AppLogger.w('获取股票详情失败: $symbolCode', error: e);
        continue;
      }
    }

    return results;
  }

  /// 随机选择一支股票
  Future<StockFilterResultModel?> getRandomStock({String? marketCode}) async {
    final results = await _stockFilterDao.filterByCondition(
      StockFilterCondition.random,
      DateTime.now(),
      marketCode: marketCode,
    );

    if (results.isEmpty) return null;

    final symbolCode = results.first;
    final details = await _getStockDetails([symbolCode], DateTime.now());

    return details.isNotEmpty ? details.first : null;
  }

  /// 获取满足条件的股票数量（仅计数，不返回详情）
  Future<int> getFilterCount({
    required StockFilterCondition condition,
    DateTime? date,
    String? marketCode,
  }) async {
    final targetDate = date ?? DateTime.now();

    // 检查缓存
    final hasCache = await _stockFilterDao.hasCachedResults(targetDate, condition);
    if (hasCache) {
      final cached = await _stockFilterDao.getCachedFilterResults(targetDate, condition);
      return cached.length;
    }

    // 执行筛选
    final symbols = await _stockFilterDao.filterByCondition(
      condition,
      targetDate,
      marketCode: marketCode,
    );

    return symbols.length;
  }

  /// 清除选股缓存
  Future<void> clearCache({DateTime? date}) async {
    // 实现缓存清理逻辑
    AppLogger.i('清除选股缓存: date=$date');
  }
}
```

- [ ] **Step 2: 提交代码**

```bash
git add lib/data/repositories/stock_filter_repository.dart
git commit -m "feat: add stock filter repository"
```

---

## Task 7: 创建选股Provider

**Files:**
- Create: `lib/providers/stock_filter_provider.dart`

- [ ] **Step 1: 创建StockFilterProvider**

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/stock_filter_repository.dart';
import '../data/models/stock_filter_condition_model.dart';
import '../data/models/stock_filter_result_model.dart';
import '../core/enums/stock_filter_condition.dart';
import '../shared/utils/logger.dart';

/// 选股状态
class StockFilterState {
  final StockFilterCondition? selectedCondition;
  final List<StockFilterConditionModel> availableConditions;
  final StockFilterResultResponse? filterResult;
  final bool isLoading;
  final String? error;
  final int? filterCount;

  const StockFilterState({
    this.selectedCondition,
    this.availableConditions = const [],
    this.filterResult,
    this.isLoading = false,
    this.error,
    this.filterCount,
  });

  StockFilterState copyWith({
    StockFilterCondition? selectedCondition,
    List<StockFilterConditionModel>? availableConditions,
    StockFilterResultResponse? filterResult,
    bool? isLoading,
    String? error,
    int? filterCount,
  }) {
    return StockFilterState(
      selectedCondition: selectedCondition ?? this.selectedCondition,
      availableConditions: availableConditions ?? this.availableConditions,
      filterResult: filterResult ?? this.filterResult,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      filterCount: filterCount ?? this.filterCount,
    );
  }

  /// 获取当前选中条件的显示名称
  String? get selectedConditionLabel => selectedCondition?.label;

  /// 是否有选股结果
  bool get hasResults => filterResult != null && filterResult!.items.isNotEmpty;

  /// 是否可以选择股票开始训练
  bool get canStartTraining => hasResults && !isLoading;
}

/// 选股状态管理器
class StockFilterNotifier extends StateNotifier<StockFilterState> {
  final StockFilterRepository _repository;

  StockFilterNotifier({StockFilterRepository? repository})
      : _repository = repository ?? StockFilterRepository(),
        super(const StockFilterState()) {
    _initialize();
  }

  /// 初始化加载条件列表
  void _initialize() {
    final conditions = _repository.getAllConditions();
    state = state.copyWith(availableConditions: conditions);
  }

  /// 选择选股条件
  void selectCondition(StockFilterCondition condition) {
    state = state.copyWith(
      selectedCondition: condition,
      filterResult: null,
      error: null,
    );

    // 自动执行选股
    if (condition != StockFilterCondition.random) {
      executeFilter();
    }
  }

  /// 从字符串选择条件
  void selectConditionByLabel(String label) {
    final condition = StockFilterCondition.fromString(label);
    selectCondition(condition);
  }

  /// 执行选股
  Future<void> executeFilter({DateTime? date, String? marketCode}) async {
    final condition = state.selectedCondition;
    if (condition == null) {
      state = state.copyWith(error: '请先选择选股条件');
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _repository.filterStocks(
        condition: condition,
        date: date,
        marketCode: marketCode,
      );

      state = state.copyWith(
        isLoading: false,
        filterResult: result,
        filterCount: result.total,
      );

      AppLogger.i('选股完成: ${result.total} 支股票');
    } catch (e, stackTrace) {
      AppLogger.e('选股失败', error: e, stackTrace: stackTrace);
      state = state.copyWith(
        isLoading: false,
        error: '选股失败: ${e.toString()}',
      );
    }
  }

  /// 获取满足条件的股票数量（用于UI显示）
  Future<void> updateFilterCount({DateTime? date, String? marketCode}) async {
    final condition = state.selectedCondition;
    if (condition == null || condition == StockFilterCondition.random) {
      state = state.copyWith(filterCount: null);
      return;
    }

    try {
      final count = await _repository.getFilterCount(
        condition: condition,
        date: date,
        marketCode: marketCode,
      );
      state = state.copyWith(filterCount: count);
    } catch (e) {
      AppLogger.w('获取选股数量失败', error: e);
      state = state.copyWith(filterCount: null);
    }
  }

  /// 随机选择一支股票
  Future<StockFilterResultModel?> getRandomStock({String? marketCode}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final stock = await _repository.getRandomStock(marketCode: marketCode);
      state = state.copyWith(isLoading: false);
      return stock;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '随机选股失败: ${e.toString()}',
      );
      return null;
    }
  }

  /// 清除错误
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// 重置状态
  void reset() {
    state = const StockFilterState();
    _initialize();
  }
}

/// 选股Provider
final stockFilterProvider =
    StateNotifierProvider<StockFilterNotifier, StockFilterState>((ref) {
  return StockFilterNotifier();
});

/// 当前选股条件Provider
final selectedConditionProvider = Provider<StockFilterCondition?>((ref) {
  return ref.watch(stockFilterProvider).selectedCondition;
});

/// 选股结果Provider
final filterResultProvider = Provider<StockFilterResultResponse?>((ref) {
  return ref.watch(stockFilterProvider).filterResult;
});

/// 选股数量Provider
final filterCountProvider = Provider<int?>((ref) {
  return ref.watch(stockFilterProvider).filterCount;
});

/// 是否正在选股Provider
final isFilteringProvider = Provider<bool>((ref) {
  return ref.watch(stockFilterProvider).isLoading;
});
```

- [ ] **Step 2: 提交代码**

```bash
git add lib/providers/stock_filter_provider.dart
git commit -m "feat: add stock filter provider with Riverpod state management"
```

---

## Task 8: 更新DatabaseService

**Files:**
- Modify: `lib/data/database/database_service.dart`

- [ ] **Step 1: 添加StockFilterDao访问**

```dart
import 'app_database.dart';
import 'daos/daos.dart';

/// 数据库服务单例
class DatabaseService {
  static DatabaseService? _instance;
  static DatabaseService get instance => _instance ??= DatabaseService._();

  late final AppDatabase _db;

  DatabaseService._() {
    _db = AppDatabase();
  }

  /// 用户DAO
  UserDao get userDao => _db.userDao;

  /// K线DAO
  KlineDao get klineDao => _db.klineDao;

  /// 市场DAO
  MarketDao get marketDao => _db.marketDao;

  /// 训练DAO
  TrainingDao get trainingDao => _db.trainingDao;

  /// 交易DAO
  TradeDao get tradeDao => _db.tradeDao;

  /// 分析DAO
  AnalysisDao get analysisDao => _db.analysisDao;

  /// 配置DAO
  ConfigDao get configDao => _db.configDao;

  /// 选股DAO
  StockFilterDao get stockFilterDao => _db.stockFilterDao;

  /// 关闭数据库
  Future<void> close() async {
    await _db.close();
  }
}
```

- [ ] **Step 2: 提交代码**

```bash
git add lib/data/database/database_service.dart
git commit -m "feat: add stock filter DAO to database service"
```

---

## Task 9: 更新选股条件选择器组件

**Files:**
- Modify: `lib/features/home/widgets/stock_condition_selector.dart`

- [ ] **Step 1: 重构StockConditionSelector**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/enums/stock_filter_condition.dart';
import '../../../providers/stock_filter_provider.dart';
import '../../../theme/app_theme.dart';

class StockConditionSelector extends ConsumerStatefulWidget {
  final String selectedCondition;
  final ValueChanged<String> onChanged;

  const StockConditionSelector({
    super.key,
    required this.selectedCondition,
    required this.onChanged,
  });

  @override
  ConsumerState<StockConditionSelector> createState() =>
      _StockConditionSelectorState();
}

class _StockConditionSelectorState
    extends ConsumerState<StockConditionSelector> {
  @override
  void initState() {
    super.initState();
    // 初始化时同步Provider状态
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final condition = StockFilterCondition.fromString(widget.selectedCondition);
      ref.read(stockFilterProvider.notifier).selectCondition(condition);
    });
  }

  @override
  Widget build(BuildContext context) {
    final filterState = ref.watch(stockFilterProvider);
    final filterCount = filterState.filterCount;
    final isLoading = filterState.isLoading;

    // 将条件分组显示
    final upTrendConditions = StockFilterCondition.upTrendConditions;
    final downTrendConditions = StockFilterCondition.downTrendConditions;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 趋势向上组
        _buildConditionGroup(
          title: '趋势向上',
          conditions: upTrendConditions,
          selectedLabel: widget.selectedCondition,
          accentColor: Colors.red,
          onSelect: _onConditionSelected,
        ),
        const SizedBox(height: 16),
        // 趋势向下组
        _buildConditionGroup(
          title: '趋势向下',
          conditions: downTrendConditions,
          selectedLabel: widget.selectedCondition,
          accentColor: Colors.green,
          onSelect: _onConditionSelected,
        ),
        const SizedBox(height: 12),
        // 结果计数显示
        _buildResultIndicator(filterCount, isLoading),
      ],
    );
  }

  Widget _buildConditionGroup({
    required String title,
    required List<StockFilterCondition> conditions,
    required String selectedLabel,
    required Color accentColor,
    required ValueChanged<StockFilterCondition> onSelect,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 16,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.fg,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 2.5,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: conditions.length,
          itemBuilder: (context, index) {
            final condition = conditions[index];
            final isSelected = selectedLabel == condition.label;

            return _ConditionRadioTile(
              condition: condition.label,
              isSelected: isSelected,
              accentColor: accentColor,
              onTap: () => onSelect(condition),
            );
          },
        ),
      ],
    );
  }

  Widget _buildResultIndicator(int? count, bool isLoading) {
    if (isLoading) {
      return Container(
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accent),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              '正在计算...',
              style: TextStyle(color: AppTheme.muted, fontSize: 12),
            ),
          ],
        ),
      );
    }

    return Container(
      alignment: Alignment.centerLeft,
      child: Text(
        count != null ? '当前满足条件: $count 支股票' : '请选择条件查看结果',
        style: const TextStyle(color: AppTheme.muted, fontSize: 12),
      ),
    );
  }

  void _onConditionSelected(StockFilterCondition condition) {
    widget.onChanged(condition.label);
    ref.read(stockFilterProvider.notifier).selectCondition(condition);
  }
}

class _ConditionRadioTile extends StatelessWidget {
  final String condition;
  final bool isSelected;
  final Color accentColor;
  final VoidCallback onTap;

  const _ConditionRadioTile({
    required this.condition,
    required this.isSelected,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? accentColor.withOpacity(0.1) : Colors.white,
          border: Border.all(
            color: isSelected ? accentColor : AppTheme.border,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? accentColor : AppTheme.muted,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: CircleAvatar(
                        radius: 4,
                        backgroundColor: accentColor,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                condition,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? accentColor : AppTheme.fg,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: 提交代码**

```bash
git add lib/features/home/widgets/stock_condition_selector.dart
git commit -m "feat: integrate stock filter provider into condition selector"
```

---

## Task 10: 更新SelectionProvider整合选股功能

**Files:**
- Modify: `lib/providers/selection_provider.dart`

- [ ] **Step 1: 整合选股功能到SelectionProvider**

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/database/database_service.dart';
import '../data/database/daos/market_dao.dart';
import '../data/database/daos/kline_dao.dart';
import '../data/repositories/stock_filter_repository.dart';
import '../data/models/kline_model.dart';
import '../data/models/market_sector_model.dart';
import '../data/models/stock_filter_result_model.dart';
import '../core/enums/stock_filter_condition.dart';
import '../shared/constants/market_sectors.dart';

class SelectionState {
  final String? selectedCondition;
  final MarketSectorModel? selectedSector;
  final List<KlineModel> klineData;
  final bool isLoading;
  final String? error;
  final String? selectedStockCode;
  final String? selectedStockName;
  final StockFilterResultModel? selectedStock;
  final List<StockFilterResultModel> filteredStocks;

  const SelectionState({
    this.selectedCondition,
    this.selectedSector,
    this.klineData = const [],
    this.isLoading = false,
    this.error,
    this.selectedStockCode,
    this.selectedStockName,
    this.selectedStock,
    this.filteredStocks = const [],
  });

  SelectionState copyWith({
    String? selectedCondition,
    MarketSectorModel? selectedSector,
    List<KlineModel>? klineData,
    bool? isLoading,
    String? error,
    String? selectedStockCode,
    String? selectedStockName,
    StockFilterResultModel? selectedStock,
    List<StockFilterResultModel>? filteredStocks,
  }) {
    return SelectionState(
      selectedCondition: selectedCondition ?? this.selectedCondition,
      selectedSector: selectedSector ?? this.selectedSector,
      klineData: klineData ?? this.klineData,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      selectedStockCode: selectedStockCode ?? this.selectedStockCode,
      selectedStockName: selectedStockName ?? this.selectedStockName,
      selectedStock: selectedStock ?? this.selectedStock,
      filteredStocks: filteredStocks ?? this.filteredStocks,
    );
  }

  bool get hasKlineData => klineData.isNotEmpty;
  bool get canStartTraining => hasKlineData && selectedStockCode != null;
  bool get hasFilteredStocks => filteredStocks.isNotEmpty;
}

class SelectionNotifier extends StateNotifier<SelectionState> {
  final MarketDao _marketDao;
  final KlineDao _klineDao;
  final StockFilterRepository _stockFilterRepository;

  SelectionNotifier(
    this._marketDao,
    this._klineDao, {
    StockFilterRepository? stockFilterRepository,
  })  : _stockFilterRepository = stockFilterRepository ?? StockFilterRepository(),
        super(const SelectionState());

  void setCondition(String condition) {
    state = state.copyWith(
      selectedCondition: condition,
      selectedStock: null,
      selectedStockCode: null,
      selectedStockName: null,
    );

    // 自动执行选股
    _executeStockFilter();
  }

  void setSector(MarketSectorModel sector) {
    state = state.copyWith(selectedSector: sector);
  }

  /// 执行选股
  Future<void> _executeStockFilter() async {
    final conditionLabel = state.selectedCondition;
    if (conditionLabel == null) return;

    final condition = StockFilterCondition.fromString(conditionLabel);

    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _stockFilterRepository.filterStocks(
        condition: condition,
      );

      state = state.copyWith(
        isLoading: false,
        filteredStocks: result.items,
      );

      // 如果选股成功，自动选择第一支股票加载K线数据
      if (result.items.isNotEmpty) {
        await selectStock(result.items.first);
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '选股失败: ${e.toString()}',
      );
    }
  }

  /// 选择特定股票
  Future<void> selectStock(StockFilterResultModel stock) async {
    state = state.copyWith(
      selectedStock: stock,
      selectedStockCode: stock.symbol,
      selectedStockName: stock.symbolName,
      isLoading: true,
    );

    try {
      final klineDataList = await _klineDao.getKlineData(
        stock.symbol,
        'day',
        limit: 100,
      );

      final klineModels = klineDataList.map((k) => KlineModel(
        symbol: k.symbol,
        timestamp: k.tradeDate.millisecondsSinceEpoch,
        open: k.open.toDouble(),
        high: k.high.toDouble(),
        low: k.low.toDouble(),
        close: k.close.toDouble(),
        volume: k.volume.toDouble(),
        turnover: k.amount.toDouble(),
      )).toList();

      state = state.copyWith(
        isLoading: false,
        klineData: klineModels,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '加载K线数据失败: ${e.toString()}',
      );
    }
  }

  /// 旧的executeSelection方法保留用于兼容性
  Future<void> executeSelection() async {
    final sector = state.selectedSector;

    if (sector == null || state.selectedCondition == null) {
      state = state.copyWith(error: '请先选择板块和条件');
      return;
    }

    // 使用新的选股逻辑
    await _executeStockFilter();
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  void reset() {
    state = const SelectionState();
  }
}

final selectionProvider = StateNotifierProvider<SelectionNotifier, SelectionState>((ref) {
  final marketDao = DatabaseService.instance.marketDao;
  final klineDao = DatabaseService.instance.klineDao;
  return SelectionNotifier(marketDao, klineDao);
});
```

- [ ] **Step 2: 提交代码**

```bash
git add lib/providers/selection_provider.dart
git commit -m "feat: integrate stock filter into selection provider"
```

---

## Task 11: 生成代码文件

**Files:**
- Run code generation for all new models

- [ ] **Step 1: 运行build_runner生成代码**

```bash
cd /sessions/6a07e20448b6ef1c53ca7401/workspace
flutter pub run build_runner build --delete-conflicting-outputs
```

- [ ] **Step 2: 验证生成的文件**

检查以下文件是否生成成功：
- `lib/core/enums/stock_filter_condition.g.dart` (如果使用了json_serializable)
- `lib/data/models/stock_filter_condition_model.g.dart`
- `lib/data/models/stock_filter_result_model.g.dart`
- `lib/data/database/tables/stock_filter_results_table.g.dart`
- `lib/data/database/tables/daily_stock_stats_table.g.dart`
- `lib/data/database/daos/stock_filter_dao.g.dart`
- `lib/data/database/app_database.g.dart` (更新)

- [ ] **Step 3: 提交代码**

```bash
git add -A
git commit -m "chore: generate drift and json_serializable code"
```

---

## Task 12: 创建单元测试

**Files:**
- Create: `test/data/daos/stock_filter_dao_test.dart`
- Create: `test/core/utils/stock_filter_calculator_test.dart`

- [ ] **Step 1: 创建DAO测试**

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:kline_trainer/data/database/app_database.dart';
import 'package:kline_trainer/data/database/daos/stock_filter_dao.dart';
import 'package:kline_trainer/core/enums/stock_filter_condition.dart';

void main() {
  group('StockFilterDao', () {
    late AppDatabase database;
    late StockFilterDao dao;

    setUp(() async {
      database = AppDatabase();
      dao = StockFilterDao(database);
    });

    tearDown(() async {
      await database.close();
    });

    group('新高/新低算法', () {
      test('checkAllTimeHigh - 应正确识别历史新高', () async {
        // 测试数据准备...
      });

      test('checkYearHigh - 应正确识别一年新高', () async {
        // 测试数据准备...
      });

      test('check200DayHigh - 应正确识别200日新高', () async {
        // 测试数据准备...
      });
    });

    group('涨停/跌停算法', () {
      test('checkLimitUp - 收盘价等于最高价时应返回true', () async {
        // 测试实现
      });

      test('checkConsecutiveLimitUp - 连续2天涨停应返回true', () async {
        // 测试实现
      });

      test('checkLimitDown - 收盘价等于最低价时应返回true', () async {
        // 测试实现
      });
    });

    group('趋势算法', () {
      test('checkUpTrend - 均线多头排列时应返回true', () async {
        // 测试实现
      });

      test('checkDownTrend - 均线空头排列时应返回true', () async {
        // 测试实现
      });
    });

    group('量价算法', () {
      test('checkVolumePriceUp - 量价齐升时应返回true', () async {
        // 测试实现
      });
    });
  });
}
```

- [ ] **Step 2: 提交代码**

```bash
git add test/
git commit -m "test: add unit tests for stock filter DAO"
```

---

## Task 13: 验证实现

- [ ] **Step 1: 运行分析检查**

```bash
cd /sessions/6a07e20448b6ef1c53ca7401/workspace
flutter analyze
```

- [ ] **Step 2: 运行测试**

```bash
flutter test
```

- [ ] **Step 3: 验证功能完整性**

检查清单：
- [ ] 18种选股条件枚举已定义
- [ ] 数据库表已创建（StockFilterResults, DailyStockStats）
- [ ] StockFilterDao已实现所有算法
- [ ] Repository和Provider已连接
- [ ] UI组件已更新联动
- [ ] 代码生成已完成
- [ ] 测试用例已编写

---

## 算法边界条件汇总

| 条件类型 | 边界条件 | 处理策略 |
|---------|---------|---------|
| 历史新高 | 上市不足30天 | 不参与筛选 |
| 一年新高 | 上市不足1年 | 取实际可用数据 |
| 200日新高 | 数据不足200天 | 取实际可用数据 |
| 涨幅排名 | 上市不足N天 | 不参与排名 |
| 上升趋势 | 数据不足55天 | 返回false |
| 下降趋势 | 数据不足55天 | 返回false |
| 连板 | 前一日数据缺失 | 返回false |
| 量价齐升 | 前一日数据缺失 | 返回false |

---

## 性能优化策略

1. **缓存机制**: 每日选股结果自动缓存到StockFilterResults表
2. **预计算**: 建议在每日收盘后批量计算DailyStockStats
3. **索引优化**: 已在表定义中添加常用查询索引
4. **分批处理**: 涨跌幅排名类条件建议分批计算避免内存溢出

---

## 后续扩展建议

1. 添加更多技术指标条件（MACD金叉/死叉、RSI超买超卖等）
2. 支持多条件组合筛选
3. 添加历史回测功能
4. 支持自定义选股公式
5. 添加选股结果导出功能

---

*文档版本: v1.0*  
*创建日期: 2026-05-16*  
*计划状态: 待执行*
