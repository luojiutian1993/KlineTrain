# K线数据查询技术设计文档

**文档版本**: v1.0  
**创建日期**: 2026-05-25  
**最后更新**: 2026-05-25

---

## 1. 概述

本文档记录K线数据查询功能的技术设计，重点说明 `getKlineDataRange` 方法的实现、问题分析及修复方案。

## 2. 技术架构

### 2.1 数据层架构

```
┌─────────────────────────────────────────────────────────────┐
│                   BattleScreen (UI层)                       │
│         _loadKlineData() -> 数据请求                         │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│               KlineRepository (仓储层)                       │
│    fetchKlineDataFromDbWithDateRange()                       │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                  KlineDao (数据访问层)                        │
│         getKlineDataRange() - 核心查询方法                    │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│              AppDatabase (Drift ORM)                         │
│              SQLite 原生数据库                               │
└─────────────────────────────────────────────────────────────┘
```

### 2.2 相关文件

| 文件路径 | 职责 |
|----------|------|
| `lib/features/battle/battle_screen.dart` | 实战页面，调用K线数据加载 |
| `lib/data/repositories/kline_repository.dart` | K线仓储层，参数校验和转换 |
| `lib/data/database/daos/kline_dao.dart` | K线数据访问对象，核心查询逻辑 |
| `lib/data/database/app_database.dart` | Drift数据库定义 |

## 3. 数据库设计

### 3.1 K线数据表结构

**表名**: `kline_data`

| 字段名 | 类型 | 说明 |
|--------|------|------|
| symbol | TEXT | 标的代码 (如 `000026.XSHE`) |
| market_code | TEXT | 市场代码 (如 `XSHE`) |
| period | TEXT | 时间周期 (`day`/`week`/`month`/`year`) |
| trade_date | TEXT | 交易日期 (存储为 `YYYY-MM-DD` 格式) |
| open | REAL | 开盘价 |
| high | REAL | 最高价 |
| low | REAL | 最低价 |
| close | REAL | 收盘价 |
| volume | REAL | 成交量 |
| amount | REAL | 成交额 |
| created_at | TEXT | 创建时间 |

**联合主键**: `symbol + period + trade_date`

### 3.2 存储格式说明

⚠️ **重要**: `trade_date` 字段虽然定义为 `DateTimeColumn`，但实际存储为 **TEXT** 格式的日期字符串（`YYYY-MM-DD`）。

## 4. 查询方法设计

### 4.1 方法签名

```dart
Future<List<KlineDataData>> getKlineDataRange(
  String symbol,    // 标的代码 (支持: 000026.XSHE 或 000026)
  String period,    // 时间周期
  DateTime startTime, // 起始时间
  DateTime endTime,   // 结束时间
)
```

### 4.2 参数处理

```dart
// 1. Symbol标准化: 000026.XSHE -> 000026
final String normalizedSymbol = _normalizeSymbolForQuery(symbol);

// 2. 日期转字符串: DateTime -> YYYY-MM-DD
final String startDateStr = _dateTimeToString(startTime);
final String endDateStr = _dateTimeToString(endTime);

// 3. 日期时间拼接: 用于SQL比较
// startDateStr + ' 00:00:00' -> '2008-08-25 00:00:00'
// endDateStr + ' 23:59:59'   -> '2009-05-02 23:59:59'
```

### 4.3 SQL查询语句

```sql
SELECT 
  symbol,
  market_code,
  period,
  trade_date,
  open,
  high,
  low,
  close,
  volume,
  amount,
  created_at
FROM kline_data
WHERE (symbol = ? OR symbol = ?)
  AND period = ?
  AND trade_date >= ?
  AND trade_date <= ?
ORDER BY trade_date ASC
```

### 4.4 参数绑定

| 参数位置 | 值 | 说明 |
|----------|-----|------|
| 1 | `000026.XSHE` | 原始symbol |
| 2 | `000026` | 标准化symbol |
| 3 | `day` | 时间周期 |
| 4 | `2008-08-25 00:00:00` | 起始日期时间 |
| 5 | `2009-05-02 23:59:59` | 结束日期时间 |

## 5. 数据映射

### 5.1 为什么不用 `row.readDateTime()`?

Drift ORM 的 `row.readDateTime()` 方法在处理 `customSelect` 查询时存在问题：

```
问题流程:
1. row.readDateTime('trade_date') 被调用
2. 内部获取到字符串值 '2005-01-04'
3. 尝试调用 int.parse('2005-01-04') 解析Unix时间戳
4. int.parse() 遇到 '-' 字符，抛出 FormatException
```

### 5.2 解决方案: 直接访问 row.data

```dart
final dataList = results.map((row) {
  final rowData = row.data;
  
  return KlineDataData(
    symbol: rowData['symbol']?.toString() ?? '',
    marketCode: rowData['market_code']?.toString() ?? '',
    period: rowData['period']?.toString() ?? '',
    tradeDate: _parseDateTimeFromString(rowData['trade_date']?.toString() ?? ''),
    open: (rowData['open'] as num?)?.toDouble() ?? 0.0,
    // ... 其他字段
    createdAt: _parseDateTimeFromString(rowData['created_at']?.toString() ?? ''),
  );
}).toList();
```

### 5.3 DateTime解析方法

```dart
DateTime _parseDateTimeFromString(String value) {
  if (value == null || value.isEmpty) {
    return DateTime.now();
  }

  try {
    // 尝试标准ISO格式解析
    if (value.contains('T')) {
      return DateTime.parse(value);
    } 
    // 尝试带空格的格式
    else if (value.contains(' ')) {
      return DateTime.parse(value.replaceAll(' ', 'T'));
    } 
    // 尝试纯日期格式
    else {
      return DateTime.parse('${value}T00:00:00');
    }
  } catch (e) {
    // 回退: 手动分割日期字符串
    final parts = value.split(RegExp(r'[-/]'));
    if (parts.length >= 3) {
      final year = int.tryParse(parts[0].trim());
      final month = int.tryParse(parts[1].trim());
      final day = int.tryParse(parts[2].trim());
      if (year != null && month != null && day != null) {
        return DateTime(year, month, day);
      }
    }
  }
  return DateTime.now();
}
```

## 6. Symbol标准化

### 6.1 需求

数据库中可能存储不同格式的symbol：
- 完整格式: `000026.XSHE`
- 简化格式: `000026`

### 6.2 标准化逻辑

```dart
String _normalizeSymbolForQuery(String symbol) {
  String normalized = symbol;

  // 移除市场前缀 (SH, SZ)
  if (normalized.startsWith('SH') && normalized.length > 2) {
    normalized = normalized.substring(2);
  } else if (normalized.startsWith('SZ') && normalized.length > 2) {
    normalized = normalized.substring(2);
  } 
  // 移除市场后缀 (.XSHE, .XSHG)
  else if (normalized.contains('.')) {
    normalized = normalized.split('.')[0];
  }

  return normalized;
}
```

### 6.3 转换示例

| 输入 | 输出 |
|------|------|
| `000026.XSHE` | `000026` |
| `000026.XSHG` | `000026` |
| `SH000026` | `000026` |
| `SZ000026` | `000026` |

## 7. 日志输出

### 7.1 日志级别

| 前缀 | 含义 |
|------|------|
| 🟠🟠🟠 | 业务层日志 |
| 🔴🔴🔴 | Repository层日志 |
| 🟣🟣🟣 | DAO层日志 |

### 7.2 日志示例

```
🟣🟣🟣 [6.DAO查询] getKlineDataRange 开始
🟣🟣🟣 [6.DAO查询] 参数详情:
🟣🟣🟣   - 原始symbol: 000026.XSHE
🟣🟣🟣   - 标准化symbol: 000026
🟣🟣🟣   - period: day
🟣🟣🟣   - startDate: 2008-08-25
🟣🟣🟣   - endDate: 2009-05-02
🟣🟣🟣 [6.DAO查询] 执行SQL查询...
🟣🟣🟣 [6.DAO查询] 查询结果: 180 条
```

## 8. 性能考虑

### 8.1 查询优化

1. **SQL层面过滤**: 日期范围比较在SQL中完成，减少数据传输
2. **索引利用**: 依赖 `trade_date` 的索引（如果存在）
3. **联合查询**: 使用 `OR` 条件匹配两种symbol格式

### 8.2 潜在优化点

| 优化点 | 说明 |
|--------|------|
| 添加索引 | 考虑在 `(symbol, period, trade_date)` 上添加复合索引 |
| 批量查询 | 如果需要多只股票数据，考虑批量查询接口 |
| 缓存 | 热数据可以考虑内存缓存 |

## 9. 异常处理

### 9.1 异常类型

| 异常类型 | 触发条件 | 处理方式 |
|----------|----------|----------|
| `FormatException` | DateTime解析失败 | 返回当前时间，记录日志 |
| `MissingFFIType` | 类型映射失败 | 检查SQL字段名 |

### 9.2 防御性编程

```dart
// 所有数值字段使用空值合并
open: (rowData['open'] as num?)?.toDouble() ?? 0.0,

// 所有字符串字段使用空值合并
symbol: rowData['symbol']?.toString() ?? '',
```

## 10. 相关文档

- [K线数据查询问题修复记录](../开发记录/K线数据查询问题修复记录.md) - 问题修复详细过程
- [测试说明文档](../test/测试说明文档.md) - 测试用例说明

---

**文档作者**: AI Assistant  
**文档状态**: ✅ 已完成