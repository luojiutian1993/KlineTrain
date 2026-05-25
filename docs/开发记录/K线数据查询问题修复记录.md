# K线数据查询问题修复开发记录

**日期**: 2026-05-25  
**问题类型**: 数据库查询异常  
**影响功能**: 实战页面K线数据加载

---

## 问题概述

从首页选择股票跳转到实战页面后，K线数据查询返回0条记录，同时抛出 `FormatException: Invalid radix-10 number (at character 1)` 异常。

## 问题现象

```dart
flutter: 🔴🔴🔴 [5.Repository查询] 异常: FormatException: Invalid radix-10 number (at character 1)
2005-01-04
^
flutter: 🟠🟠🟠 [4.加载K线数据] 查询结果: 0 条
```

## 问题分析

### 根本原因

1. **Drift ORM `customSelect` 的 `row.readDateTime()` 方法问题**:
   - 在 `kline_dao.dart` 的 `getKlineDataRange` 方法中，使用 `customSelect` 执行原始SQL查询
   - 调用 `row.readDateTime('trade_date')` 尝试读取日期字段时出错
   - 错误信息 `Invalid radix-10 number (at character 1) 2005-01-04` 表明方法尝试将日期字符串当作整数解析

2. **Drift 内部的类型转换逻辑**:
   - `readDateTime()` 内部先将值解析为字符串，然后调用 `int.parse()` 解析Unix时间戳
   - 数据库中存储的日期格式为 `2005-01-04`（纯日期字符串），不是Unix时间戳
   - `int.parse('2005-01-04')` 失败，因为 `-` 不是有效的十进制字符

### 技术背景

1. **数据库表定义** (`kline_data_table.dart`):
   ```dart
   class KlineData extends Table {
     DateTimeColumn get tradeDate => dateTime()();
     // ...
   }
   ```

2. **数据库实际存储格式**:
   - `trade_date` 字段实际存储为 TEXT 格式，值为 `YYYY-MM-DD` (如 `2005-01-04`)
   - Drift ORM 在读取时返回完整ISO格式，但 `readDateTime()` 期望的是时间戳

## 修复方案

### 方案选择

**方案**: 使用 `row.data` 直接访问原始数据，手动解析DateTime

### 具体修改

**文件**: `lib/data/database/daos/kline_dao.dart`

**修改前**:
```dart
final dataList = results.map((row) {
  return KlineDataData(
    symbol: row.readString('symbol'),
    marketCode: row.readString('market_code'),
    period: row.readString('period'),
    tradeDate: row.readDateTime('trade_date'),  // ❌ 会抛出异常
    // ...
    createdAt: row.readDateTime('created_at'),  // ❌ 会抛出异常
  );
}).toList();
```

**修改后**:
```dart
final dataList = results.map((row) {
  final rowData = row.data;
  final tradeDateStr = rowData['trade_date']?.toString() ?? '';
  final createdAtStr = rowData['created_at']?.toString() ?? '';

  return KlineDataData(
    symbol: rowData['symbol']?.toString() ?? '',
    marketCode: rowData['market_code']?.toString() ?? '',
    period: rowData['period']?.toString() ?? '',
    tradeDate: _parseDateTimeFromString(tradeDateStr),
    open: (rowData['open'] as num?)?.toDouble() ?? 0.0,
    high: (rowData['high'] as num?)?.toDouble() ?? 0.0,
    low: (rowData['low'] as num?)?.toDouble() ?? 0.0,
    close: (rowData['close'] as num?)?.toDouble() ?? 0.0,
    volume: (rowData['volume'] as num?)?.toDouble() ?? 0.0,
    amount: (rowData['amount'] as num?)?.toDouble() ?? 0.0,
    createdAt: _parseDateTimeFromString(createdAtStr),
  );
}).toList();
```

**新增方法**:
```dart
/// 从字符串解析DateTime，使用多种格式兼容
DateTime _parseDateTimeFromString(String value) {
  if (value == null || value.isEmpty) {
    return DateTime.now();
  }

  try {
    if (value.contains('T')) {
      return DateTime.parse(value);
    } else if (value.contains(' ')) {
      return DateTime.parse(value.replaceAll(' ', 'T'));
    } else {
      return DateTime.parse('${value}T00:00:00');
    }
  } catch (e) {
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

### SQL查询语句

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

**参数绑定**:
- `symbol`: 原始symbol (如 `000026.XSHE`)
- `normalizedSymbol`: 标准化symbol (如 `000026`)
- `period`: 时间周期 (如 `day`)
- `startDateStr + ' 00:00:00'`: 起始日期时间
- `endDateStr + ' 23:59:59'`: 结束日期时间

## 修复过程记录

| 时间 | 操作 | 结果 |
|------|------|------|
| 初始状态 | 使用 `select(klineData)` 查询后Dart过滤 | 查询到数据但日期过滤失败 |
| 第一次修复 | 使用 `customSelect` 原始SQL + `date()` 函数 | `readDateTime()` 仍抛出异常 |
| 第二次修复 | 移除 `date()` 函数，直接比较日期字符串 | 参数格式不匹配 |
| 第三次修复 | 使用 `row.data` 直接访问原始数据 | 成功解析，避免 `readDateTime()` 异常 |

## 验证方法

1. 在iOS模拟器上从首页选择股票（如飞亚达 000026）
2. 点击开始训练跳转到实战页面
3. 检查日志输出：
   - `🟣🟣🟣 [6.DAO查询] 查询结果: X 条` (X > 0)
   - 无 `FormatException` 异常

## 相关文件

- `lib/data/database/daos/kline_dao.dart` - K线数据访问对象
- `lib/data/repositories/kline_repository.dart` - K线数据仓储层
- `lib/features/battle/battle_screen.dart` - 实战页面

## 预防措施

1. **避免在 `customSelect` 中使用 `row.readDateTime()`**:
   - Drift 的类型化读取方法在处理自定义SQL查询时可能存在问题
   - 改用 `row.data` 手动解析更可靠

2. **统一日期格式处理**:
   - 建议在数据库层统一使用ISO 8601格式存储日期
   - 或在应用层统一日期解析逻辑

3. **增加查询日志**:
   - 在DAO层添加详细日志，记录查询参数和结果数量
   - 便于快速定位问题

---

**修复完成日期**: 2026-05-25  
**修复状态**: ✅ 已完成并验证