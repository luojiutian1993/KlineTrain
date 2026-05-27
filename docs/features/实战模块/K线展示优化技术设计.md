# K线展示优化技术设计

> **版本**: v1.0
> **创建日期**: 2026-05-27
> **最后更新**: 2026-05-27
> **状态**: 已发布

---

## 1. 设计概要

**功能描述**：优化 K线图表渲染效果使其更清晰锐利，添加蓝色开盘价虚线、红色成本价虚线，简化买卖点标记为 B/S 标识。

**影响范围**：
- `lib/features/training/widgets/kline_chart.dart` (K线图表组件)
- `lib/features/battle/battle_screen.dart` (实战页面)

**技术难点**：
1. **成本价计算逻辑**：需支持多次买入卖出的加权平均成本计算
2. **水平虚线渲染**：需要在坐标系统中正确定位和渲染横向参考线
3. **买卖点视觉简化**：在保持功能的同时减少视觉元素，增强可读性

**外部依赖**：无（纯前端修改，不涉及后端API或数据库变更）

---

## 2. 架构概览

### 2.1 总体设计思路

本次优化主要在现有 K线图表渲染架构基础上进行功能增强：

```
┌─────────────────────────────────────────────────────────────┐
│                     BattleScreen (UI层)                      │
│  - 管理 _positionCost 持仓成本状态                           │
│  - 传递 currentDayIndex 用于获取当前日开盘价                  │
│  - 传递 tradePoints 买卖点数据                               │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                   KlineChart (图表组件层)                    │
│  - 新增 currentOpenPrice 参数                                │
│  - 新增 positionCost 参数                                    │
│  - 优化渲染质量                                             │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│              CandleStickChartPainter (渲染层)                │
│  - _drawHorizontalDashedLine() 绘制横向虚线                  │
│  - _drawTradePoints() 简化买卖点显示                         │
└─────────────────────────────────────────────────────────────┘
```

### 2.2 关键数据流向

1. **开盘价虚线**：`BattleScreen` 传递 `_currentDayIndex` → `KlineChart` 读取对应 K线数据的 `open` → `CandleStickChartPainter` 绘制蓝色虚线

2. **成本价虚线**：`BattleScreen` 维护 `_positionCost` → `KlineChart` 接收参数 → `CandleStickChartPainter` 条件渲染（仅在持仓 > 0 时显示）

3. **买卖点标记**：`BattleScreen` 传递简化后的 `TradePoint` (只保留 B/S) → `CandleStickChartPainter` 渲染简化标记

---

## 3. 数据库设计

本次优化**不涉及数据库变更**，完全在前端 UI/渲染层实现。

---

## 4. API 设计

本次优化**不涉及 API 变更**，仅修改组件内部实现。

---

## 5. 核心逻辑

### 5.1 成本价计算逻辑 → AC-004, AC-005, AC-010

**触发条件**：用户每次执行买入或卖出操作时

**处理流程**：
1. 买入时计算新成本 = `(旧成本 × 旧数量 + 新价格 × 新数量) / (旧数量 + 新数量)`
2. 卖出时保持成本不变，仅减少持仓数量
3. 持仓数量变为0时重置 `_positionCost` 为0

**实现位置**：`BattleScreen` 中的交易处理逻辑

**伪代码**：
```dart
// 计算持仓成本
double _calculatePositionCost(
  double oldCost,
  double oldQuantity,
  double newPrice,
  double newQuantity,
  bool isBuy
) {
  if (isBuy) {
    final totalOldCost = oldCost * oldQuantity;
    final totalNewCost = newPrice * newQuantity;
    final totalCost = totalOldCost + totalNewCost;
    final totalQuantity = oldQuantity + newQuantity;
    return totalQuantity > 0 ? totalCost / totalQuantity : 0.0;
  } else {
    // 卖出时不改变成本价
    return oldCost;
  }
}
```

### 5.2 K线渲染优化 → AC-001, AC-012

**触发条件**：K线图表重绘时

**处理流程**：
1. 开启 `isAntiAlias` 为 `true`
2. 适当加粗蜡烛图边框
3. 优化线条连接点样式

**实现位置**：`_CandleStickPainter.paint()` 方法

### 5.3 水平虚线绘制 → AC-002, AC-003, AC-006, AC-009, AC-013, AC-014

**触发条件**：图表渲染时

**处理流程**：
1. 将价格转换为图表坐标系 Y 坐标
2. 绘制水平虚线，长度贯穿整个图表宽度
3. 开盘价使用蓝色 (#3B82F6)，成本价使用红色 (#EF4444)

**实现位置**：新增 `_drawHorizontalDashedLine()` 私有方法

**伪代码**：
```dart
void _drawHorizontalDashedLine(
  Canvas canvas,
  Size size,
  double price,
  Color color,
) {
  final candleWidth = size.width / klineData.length;
  final priceRange = maxY - minY;

  final y = size.height - ((price - minY) / priceRange) * size.height;

  final paint = Paint()
    ..color = color
    ..strokeWidth = 1.5
    ..style = PaintingStyle.stroke;

  // 绘制虚线
  const dashWidth = 5;
  const dashSpace = 3;
  double startX = 0;
  while (startX < size.width) {
    canvas.drawLine(
      Offset(startX, y),
      Offset(startX + dashWidth, y),
      paint,
    );
    startX += dashWidth + dashSpace;
  }
}
```

### 5.4 买卖点简化显示 → AC-007, AC-008, AC-015

**触发条件**：买卖点渲染时

**处理流程**：
1. 移除价格和数量信息的文字绘制
2. 仅保留 "B" (Buy) 或 "S" (Sell) 标识
3. 添加从价格点向上/向下的垂直虚线，颜色固定为蓝色 (#3B82F6)
4. 买入标识红色 (#EF4444)，卖出标识绿色 (#34C759)
5. B/S 标识显示在垂直虚线的尽头（买入在上端，卖出在下端）
6. 垂直虚线长度不超过 K线区域边界

**实现位置**：修改 `_drawTradePoints()` 方法

---

## 6. 现有代码改动

### 6.1 `lib/features/training/widgets/kline_chart.dart`

| 改动内容 | 原因 | 对应 AC |
|---------|------|---------|
| 新增 `currentOpenPrice?` 参数 | 支持传递当日开盘价 | AC-002, AC-003 |
| 新增 `positionCost?` 参数 | 支持传递持仓成本价 | AC-004, AC-006 |
| 修改 `_CandleStickPainter` 构造函数 | 新增虚线绘制所需参数 | AC-002, AC-003, AC-004 |
| 添加 `_drawHorizontalDashedLine()` 方法 | 绘制水平参考线 | AC-013, AC-014 |
| 修改 `_drawTradePoints()` 方法 | 简化买卖点显示 | AC-007, AC-008, AC-015 |
| 优化 K线渲染质量 | 提升清晰度 | AC-001, AC-012 |

### 6.2 `lib/features/battle/battle_screen.dart`

| 改动内容 | 原因 | 对应 AC |
|---------|------|---------|
| 在 `KlineChart` 调用时传递 `currentOpenPrice` | 显示当日开盘价虚线 | AC-002, AC-003 |
| 在 `KlineChart` 调用时传递 `positionCost` | 显示成本价虚线 | AC-004, AC-006, AC-009 |
| 修改 `_executeBuy()` 中的成本计算 | 更新持仓成本 | AC-005, AC-010 |
| 修改 `_executeSell()` 中的成本逻辑 | 部分清仓时保持成本 | AC-011 |

---

## 7. 技术决策

### 7.1 虚线绘制方案选择

| 选项 | 优势 | 劣势 |
|-----|------|-----|
| 使用 Path 绘制虚线 | 一次性绘制，效率高 | Dash 路径需要计算 |
| 使用循环绘制多个短线段 | 代码简单，可控性强 | 循环可能影响性能（对20根K线图可忽略） |
| 使用 fl_chart 内置 FlLine | 复用现有 API | 需要适配到坐标系 |

**决策**：采用循环绘制短线段的方案

**理由**：实现简单，代码可读性好，对于K线图这种数据量不大的场景，性能完全可接受，且便于精确控制 dash 样式。

### 7.2 成本价计算方案选择

| 选项 | 描述 | 评估 |
|-----|------|-----|
| 实时计算（每次交易后更新） | 当前实现的思路，简单直接 | ✅ 采用 |
| 从数据库历史交易记录计算 | 每次读取所有交易记录计算 | ❌ 效率低，不必要 |
| 缓存成本价到数据库 | 需要新增字段，增加复杂度 | ❌ 过度设计 |

**决策**：在前端实时计算持仓成本

**理由**：持仓成本是训练会话内的临时状态，无需持久化；前端实时计算简单高效，符合当前架构。

---

## 8. 安全与性能

本次改动不涉及敏感数据，无安全问题。性能方面：
- K线渲染优化开启抗锯齿，性能影响可忽略（约20根K线）
- 水平虚线绘制循环次数 = 图表宽度 / (dash宽度+间距)，约 50-100次，无性能问题

---

## 9. AC 覆盖总表

| AC 编号 | 验收标准概述 | 实现位置 |
|---------|-------------|---------|
| AC-001 | K线图表清晰锐利 | `kline_chart.dart` - 渲染优化 |
| AC-002 | 开盘价虚线显示 | `kline_chart.dart` - 水平虚线 + `battle_screen.dart` - 传递开盘价 |
| AC-003 | 开盘价虚线动态更新 | `battle_screen.dart` - 随 _currentDayIndex 更新 |
| AC-004 | 成本价虚线显示 | `kline_chart.dart` - 水平虚线 + `battle_screen.dart` - 传递成本 |
| AC-005 | 成本价动态计算 | `battle_screen.dart` - 买卖时重新计算 |
| AC-006 | 成本价虚线隐藏 | `kline_chart.dart` - 条件判断 positionQuantity>0 |
| AC-007 | 买卖点简化显示 | `kline_chart.dart` - _drawTradePoints() 简化 |
| AC-008 | 买卖点虚线延展 | `kline_chart.dart` - 新增垂直虚线绘制 |
| AC-009 | 无持仓时成本线隐藏 | `kline_chart.dart` - 条件判断 |
| AC-010 | 多次买卖后成本计算正确 | `battle_screen.dart` - 成本计算逻辑 |
| AC-011 | 部分清仓后成本线仍显示 | `kline_chart.dart` - 只要>0即显示 |
| AC-012 | K线渲染质量验证 | `kline_chart.dart` - 抗锯齿开启 |
| AC-013 | 开盘价虚线样式验证 | `kline_chart.dart` - 蓝色 #3B82F6 |
| AC-014 | 成本价虚线样式验证 | `kline_chart.dart` - 红色 #EF4444 |
| AC-015 | 买卖点标记样式验证 | `kline_chart.dart` - B/S 标识 |

---

## 附录：变更记录

| 日期 | 变更内容 | 原因 |
|------|---------|------|
| 2026-05-27 | 初始版本，完成技术方案设计 | 根据 K线展示优化需求进行技术设计 |
