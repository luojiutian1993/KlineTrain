# K线训练营 - AI 辅助开发方案

> 本文档为 K 线训练营 App 提供完整的 AI 辅助开发解决方案，包括大模型配置、MCP 集成架构、选股算法优化和智能反馈系统设计。

**文档版本**: v1.0
**创建日期**: 2026-05-20
**适用版本**: K线训练营 v1.7+

---

## 一、SOLO IDE 配置 Minimax 大模型

### 1.1 配置概述

SOLO IDE 支持通过 **OpenAI 兼容接口** 配置自定义大模型。Minimax 提供了符合 OpenAI API 规范的接口，可以直接对接。

### 1.2 Minimax API 配置参数

| 参数 | 值 | 说明 |
|------|-----|------|
| **API Provider** | OpenAI Compatible | 选择 OpenAI 兼容模式 |
| **Base URL** | `https://api.minimax.chat/v1` | Minimax API 地址 |
| **API Key** | 您的 Minimax API Key | 从 Minimax 开放平台获取 |
| **Model ID** | `abab6.5s-chat` | 推荐使用 abab6.5s 模型 |

### 1.3 配置步骤

#### 步骤 1: 获取 Minimax API Key

1. 访问 [Minimax 开放平台](https://platform.minimax.chat/)
2. 注册并登录账号
3. 进入「应用管理」→ 「创建应用」
4. 获取 API Key

#### 步骤 2: SOLO IDE 配置

```
设置 → AI 设置 → 模型配置 → 添加自定义模型

模型名称: minimax-chat
模型类型: OpenAI Compatible
Base URL: https://api.minimax.chat/v1
API Key: eyJhbGciOiJxxx... (您的API Key)
模型ID: abab6.5s-chat
```

### 1.4 支持的 Minimax 模型

| 模型名称 | 上下文长度 | 适用场景 | 推荐场景 |
|---------|-----------|---------|---------|
| `abab6.5s-chat` | 24K | 通用对话 | ✅ **开发辅助首选** |
| `abab6.5-chat` | 245K | 复杂推理 | 长代码分析 |
| `abab6-chat` | 245K | 长文本处理 | 文档生成 |
| `abab5.5-chat` | 180K | 轻量级任务 | 快速问答 |

### 1.5 备选方案: AI Ping 聚合平台

如果直接使用 Minimax 有困难，可以使用 [AI Ping](https://ai.pingzone.io/) 聚合平台：

```
API Provider: OpenAI Compatible
Base URL: https://ai.ping.cn/api/v1
API Key: 您的 AI Ping Key
Model ID: minimax-m2.1
```

**优势**: 统一接口、支持多模型切换

---

## 二、MCP 集成架构设计

### 2.1 MCP 概述

MCP (Model Context Protocol) 是 Anthropic 提出的开放标准协议，用于 AI 应用与外部数据和工具的安全连接。

### 2.2 针对 K 线训练营的 MCP 架构

```
┌─────────────────────────────────────────────────────────────┐
│                      SOLO IDE (AI 助手)                     │
│  ┌─────────────────────────────────────────────────────┐   │
│  │                  MCP Client                          │   │
│  └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                    MCP Servers (本地/云端)                    │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐   │
│  │ 技术指标  │  │ 选股算法  │  │ 智能反馈  │  │ Flutter  │   │
│  │   MCP    │  │   MCP    │  │   MCP    │  │   MCP    │   │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘   │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                      数据层 (Flutter App)                    │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐   │
│  │ 技术指标  │  │ 选股条件  │  │ 实战训练  │  │  K线数据  │   │
│  │ Calculator│  │   DAO    │  │   DAO    │  │  Database│   │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘   │
└─────────────────────────────────────────────────────────────┘
```

### 2.3 MCP Server 功能设计

#### MCP Server 1: 技术指标验证 MCP

```json
{
  "name": "kline-indicator-validator",
  "description": "技术指标计算验证和回测",
  "tools": [
    {
      "name": "validate_indicator",
      "description": "验证技术指标计算结果",
      "input_schema": {
        "type": "object",
        "properties": {
          "symbol": {"type": "string"},
          "indicator": {"type": "string", "enum": ["MACD", "KDJ", "RSI", "BOLL", "WR", "CCI", "OBV", "DMI", "DMA", "BBI"]},
          "params": {"type": "object"},
          "date_range": {"type": "object"}
        }
      }
    },
    {
      "name": "backtest_indicator",
      "description": "指标历史回测",
      "input_schema": {
        "type": "object",
        "properties": {
          "symbol": {"type": "string"},
          "indicator": {"type": "string"},
          "start_date": {"type": "string"},
          "end_date": {"type": "string"}
        }
      }
    }
  ]
}
```

#### MCP Server 2: 选股算法优化 MCP

```json
{
  "name": "stock-selection-optimizer",
  "description": "选股算法优化和建议",
  "tools": [
    {
      "name": "analyze_condition",
      "description": "分析选股条件有效性",
      "input_schema": {
        "type": "object",
        "properties": {
          "condition_id": {"type": "integer"},
          "condition_name": {"type": "string"}
        }
      }
    },
    {
      "name": "suggest_optimization",
      "description": "提供算法优化建议",
      "input_schema": {
        "type": "object",
        "properties": {
          "current_logic": {"type": "string"},
          "target_stocks": {"type": "array"}
        }
      }
    }
  ]
}
```

#### MCP Server 3: K线实战智能反馈 MCP

```json
{
  "name": "kline-training-feedback",
  "description": "K线实战训练智能分析反馈",
  "tools": [
    {
      "name": "analyze_training",
      "description": "分析用户训练结果",
      "input_schema": {
        "type": "object",
        "properties": {
          "training_id": {"type": "integer"},
          "trade_history": {"type": "array"}
        }
      }
    },
    {
      "name": "generate_feedback",
      "description": "生成训练反馈报告",
      "input_schema": {
        "type": "object",
        "properties": {
          "analysis_result": {"type": "object"}
        }
      }
    }
  ]
}
```

### 2.4 MCP 集成配置文件

创建 `.mcp.json` 配置文件：

```json
{
  "mcpServers": {
    "kline-indicator": {
      "command": "uvx",
      "args": ["kline-indicator-mcp"],
      "env": {
        "DATABASE_PATH": "./lib/data/database/kline_trainer.db"
      }
    },
    "stock-optimizer": {
      "command": "uvx",
      "args": ["stock-optimizer-mcp"],
      "env": {}
    },
    "training-feedback": {
      "command": "uvx",
      "args": ["training-feedback-mcp"],
      "env": {
        "LLM_ENDPOINT": "https://api.minimax.chat/v1",
        "LLM_API_KEY": "${MINIMAX_API_KEY}"
      }
    }
  }
}
```

---

## 三、技术指标自动计算验证框架

### 3.1 现有指标计算引擎分析

你的项目已实现 11 种技术指标 (`lib/data/utils/indicator_calculator.dart`)：

| 指标 | 实现状态 | 可优化点 |
|------|---------|---------|
| MACD | ✅ 已实现 | 参数可调 |
| KDJ | ✅ 已实现 | 初始值优化 |
| RSI | ✅ 已实现 | 平滑算法 |
| BOLL | ✅ 已实现 | 标准差计算 |
| WR | ✅ 已实现 | 周期参数 |
| CCI | ✅ 已实现 | TP计算 |
| OBV | ✅ 已实现 | 累积方式 |
| DMI | ✅ 已实现 | 平滑方式 |
| DMA | ✅ 已实现 | 双均线 |
| BBI | ✅ 已实现 | 多周期组合 |
| EMA/SMA | ✅ 已实现 | 基础工具 |

### 3.2 验证框架架构

```
┌─────────────────────────────────────────────────────────────┐
│                    IndicatorValidator                         │
├─────────────────────────────────────────────────────────────┤
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐       │
│  │ 数据获取层   │  │ 计算验证层   │  │ 结果输出层   │       │
│  │              │  │              │  │              │       │
│  │ getKlineData │  │ calculate()  │  │ export()     │       │
│  │ validateData │  │ compare()    │  │ visualize()  │       │
│  └──────────────┘  └──────────────┘  └──────────────┘       │
│                                                              │
│  ┌──────────────────────────────────────────────────────┐   │
│  │                    指标计算器                         │   │
│  │  MACD  KDJ  RSI  BOLL  WR  CCI  OBV  DMI  DMA  BBI  │   │
│  └──────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

### 3.3 验证框架核心代码

```dart
// lib/data/utils/indicator_validator.dart

import 'indicator_calculator.dart';

class IndicatorValidationResult {
  final String indicatorName;
  final bool isValid;
  final List<double> calculatedValues;
  final String? errorMessage;
  final Duration calculationTime;

  IndicatorValidationResult({
    required this.indicatorName,
    required this.isValid,
    required this.calculatedValues,
    this.errorMessage,
    required this.calculationTime,
  });
}

class IndicatorValidator {
  final IndicatorCalculator _calculator = IndicatorCalculator();

  /// 验证单个指标计算
  Future<IndicatorValidationResult> validateIndicator({
    required List<KlineModel> data,
    required String indicatorName,
    Map<String, dynamic>? params,
  }) async {
    final stopwatch = Stopwatch()..start();

    try {
      List<double> values;
      switch (indicatorName.toUpperCase()) {
        case 'MACD':
          values = _validateMACD(data, params);
          break;
        case 'KDJ':
          values = _validateKDJ(data, params);
          break;
        case 'RSI':
          values = _validateRSI(data, params);
          break;
        // ... 其他指标
        default:
          throw UnsupportedError('不支持的指标: $indicatorName');
      }

      stopwatch.stop();

      return IndicatorValidationResult(
        indicatorName: indicatorName,
        isValid: values.isNotEmpty,
        calculatedValues: values,
        calculationTime: stopwatch.elapsed,
      );
    } catch (e) {
      stopwatch.stop();
      return IndicatorValidationResult(
        indicatorName: indicatorName,
        isValid: false,
        calculatedValues: [],
        errorMessage: e.toString(),
        calculationTime: stopwatch.elapsed,
      );
    }
  }

  /// 批量验证所有指标
  Future<List<IndicatorValidationResult>> validateAll({
    required List<KlineModel> data,
  }) async {
    final indicators = ['MACD', 'KDJ', 'RSI', 'BOLL', 'WR', 'CCI', 'OBV', 'DMI', 'DMA', 'BBI'];
    final results = <IndicatorValidationResult>[];

    for (final indicator in indicators) {
      final result = await validateIndicator(
        data: data,
        indicatorName: indicator,
      );
      results.add(result);
    }

    return results;
  }
}
```

### 3.4 AI 辅助验证流程

```
用户: "验证 MACD 指标计算是否正确"

SOLO IDE (MCP) 流程:
┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│ 1. 接收请求 │ → │ 2. 调用 MCP │ → │ 3. 计算验证 │ → │ 4. 返回结果 │
│             │    │  Indicator │    │             │    │             │
│             │    │  Validator │    │             │    │             │
└─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘
```

---

## 四、选股算法 AI 优化方案

### 4.1 现有 18 种选股条件分析

你的项目已实现 18 种选股条件：

**趋势向上（9种）**
1. 历史新高 - 新算法
2. 一年新高 - 新算法
3. 200日新高 - 新算法
4. 30日涨幅前50% - 新算法
5. 15日涨幅前50% - 新算法
6. 涨停 - 已有
7. 连板 - 已有
8. 量价齐升 - 新算法
9. 上升趋势 - 新算法

**趋势向下（9种）**
10. 历史新低 - 已有
11. 一年新低 - 已有
12. 200日新低 - 已有
13. 30日跌幅前50% - 新算法
14. 15日跌幅前50% - 新算法
15. 下降趋势 - 已有
16. 跌停 - 已有
17. 连续跌停 - 已有
18. 随机 - 已有

### 4.2 AI 优化架构

```
┌─────────────────────────────────────────────────────────────┐
│                   StockSelectionOptimizer                     │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌────────────┐    ┌────────────┐    ┌────────────┐         │
│  │ 条件分析器 │ →  │ 优化建议器 │ →  │ 效果验证器 │         │
│  │            │    │            │    │            │         │
│  │ analyze()  │    │ suggest()  │    │ verify()   │         │
│  │            │    │            │    │            │         │
│  └────────────┘    └────────────┘    └────────────┘         │
│                                                              │
│  ┌────────────────────────────────────────────────────┐       │
│  │                  AI 辅助引擎                       │       │
│  │  ┌──────────┐  ┌──────────┐  ┌──────────┐        │       │
│  │  │ 历史表现  │  │ 市场环境  │  │ 参数调优  │        │       │
│  │  │ 分析      │  │ 适应      │  │ 建议      │        │       │
│  │  └──────────┘  └──────────┘  └──────────┘        │       │
│  └────────────────────────────────────────────────────┘       │
└─────────────────────────────────────────────────────────────┘
```

### 4.3 优化建议示例

基于 AI 分析，可以提供以下优化：

#### 优化 1: 量价齐升条件增强

```dart
// 当前实现（简化）
bool isVolumePriceRising(List<KlineModel> data) {
  final priceChange = (data.last.close - data.first.close) / data.first.close;
  final volumeChange = data.last.volume / data.first.volume;
  return priceChange > 0 && volumeChange > 1.5;
}

// AI 优化建议
class VolumePriceOptimization {
  /// 优化后的量价齐升判断
  /// 考虑因素：
  /// 1. 量比（当日成交量/5日均量）
  /// 2. 涨幅阈值动态调整
  /// 3. 缩量回调确认
  /// 4. 市场环境因子
  static bool isOptimalVolumePriceRising({
    required List<KlineModel> data,
    required MarketEnvironment market,
    double minVolumeRatio = 1.5,
    double? dynamicPriceThreshold,
  }) {
    // 1. 计算量比
    final avgVolume5 = calculateMA(data.map((d) => d.volume.toDouble()).toList(), 5);
    final volumeRatio = data.last.volume / avgVolume5.last;

    // 2. 动态涨幅阈值
    final threshold = dynamicPriceThreshold ?? _getDynamicThreshold(market);

    // 3. 价格变化判断
    final priceChange = (data.last.close - data.first.close) / data.first.close;

    // 4. 综合判断
    return volumeRatio >= minVolumeRatio &&
           priceChange >= threshold &&
           _hasHealthyPullback(data);
  }
}
```

#### 优化 2: 上升趋势条件增强

```dart
class TrendOptimization {
  /// 优化后的上升趋势判断
  /// 考虑因素：
  /// 1. 多周期确认（日线、周线）
  /// 2. 均线多头排列
  /// 3. 趋势强度（ADX）
  /// 4. 趋势稳定性
  static bool isOptimalUptrend({
    required List<KlineModel> data,
    required IndicatorCalculator calculator,
    int minTrendDays = 20,
    double adxThreshold = 25,
  }) {
    // 1. 均线多头排列
    final ma5 = calculator.calculateSMA(data.map((d) => d.close).toList(), 5);
    final ma20 = calculator.calculateSMA(data.map((d) => d.close).toList(), 20);
    final ma60 = calculator.calculateSMA(data.map((d) => d.close).toList(), 60);

    if (ma5.last <= ma20.last || ma20.last <= ma60.last) {
      return false;
    }

    // 2. 计算 ADX 趋势强度
    final dmi = calculator.calculateDMI(data);
    if (dmi.adx.isEmpty || dmi.adx.last < adxThreshold) {
      return false;
    }

    // 3. 趋势持续天数
    final trendDays = _countConsecutiveUptrendDays(data);
    return trendDays >= minTrendDays;
  }
}
```

### 4.4 AI 参数优化建议

| 条件名称 | 当前参数 | AI 建议优化 | 优化理由 |
|---------|---------|------------|---------|
| 量价齐升 | 量比 1.5 | 量比 1.2-2.0 动态 | 不同市场环境需要不同阈值 |
| 上升趋势 | 固定周期 | 多周期确认 | 提高趋势判断准确性 |
| 30日涨幅 | 固定阈值 | 分位数自适应 | 适应不同股票特性 |
| KDJ 超买 | 80/20 | 动态阈值 | 结合市场波动率调整 |

---

## 五、K线实战智能反馈系统

### 5.1 系统架构

```
┌─────────────────────────────────────────────────────────────┐
│                KLineTrainingFeedbackSystem                   │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌────────────┐    ┌────────────┐    ┌────────────┐         │
│  │ 训练记录   │ →  │ AI 分析    │ →  │ 反馈生成   │         │
│  │ 采集       │    │ 引擎       │    │ 模块       │         │
│  └────────────┘    └────────────┘    └────────────┘         │
│         │                │                  │                 │
│         ▼                ▼                  ▼                 │
│  ┌────────────┐    ┌────────────┐    ┌────────────┐         │
│  │ 买卖点    │    │ 指标共振   │    │ 改进建议   │         │
│  │ 记录      │    │ 分析       │    │ 生成       │         │
│  └────────────┘    └────────────┘    └────────────┘         │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### 5.2 反馈类型

#### 1. 即时反馈（交易时）

```dart
class TrainingFeedback {
  /// 即时反馈：当用户做出交易决策时
  static TrainingFeedback generateInstant({
    required String action,  // buy/sell/hold
    required KlinModel currentKline,
    required Map<String, dynamic> indicators,
  }) {
    final feedback = <String, dynamic>{
      'action': action,
      'timestamp': DateTime.now(),
      'analysis': <String, dynamic>{},
    };

    // 指标分析
    if (indicators['macd'] != null) {
      final macd = indicators['macd'] as MACDResult;
      feedback['analysis']['macd_signal'] = _analyzeMACD(macd);
    }

    if (indicators['kdj'] != null) {
      final kdj = indicators['kdj'] as KDJResult;
      feedback['analysis']['kdj_signal'] = _analyzeKDJ(kdj);
    }

    // 生成建议
    feedback['suggestion'] = _generateSuggestion(feedback['analysis']);

    return TrainingFeedback.fromMap(feedback);
  }
}
```

#### 2. 复盘反馈（训练后）

```dart
class PostTrainingFeedback {
  /// 训练后复盘分析
  static PostTrainingFeedback generateReview({
    required int trainingId,
    required List<TradeRecord> trades,
    required List<KlineModel> klineData,
  }) {
    return PostTrainingFeedback(
      trainingId: trainingId,
      summary: _generateSummary(trades),
      metrics: _calculateMetrics(trades),
      strengths: _identifyStrengths(trades, klineData),
      weaknesses: _identifyWeaknesses(trades, klineData),
      suggestions: _generateSuggestions(trades, klineData),
      indicatorAccuracy: _calculateIndicatorAccuracy(trades, klineData),
    );
  }

  static Map<String, dynamic> _generateSummary(List<TradeRecord> trades) {
    final totalProfit = trades.fold<double>(
      0,
      (sum, trade) => sum + trade.profit,
    );

    final winRate = trades.where((t) => t.profit > 0).length / trades.length;

    return {
      'total_trades': trades.length,
      'total_profit': totalProfit,
      'win_rate': winRate,
      'avg_profit_per_trade': totalProfit / trades.length,
    };
  }
}
```

### 5.3 智能分析维度

| 分析维度 | 分析内容 | 指标来源 |
|---------|---------|---------|
| **时机判断** | 买卖点是否合适 | MACD、KDJ、RSI |
| **指标共振** | 多指标是否一致 | MACD + KDJ + RSI |
| **趋势把握** | 是否顺势交易 | MA、BOLL、DMI |
| **风险控制** | 止损是否合理 | 波动率、ATR |
| **盈亏比** | 盈亏比是否合理 | 历史统计 |

### 5.4 反馈示例

```
┌─────────────────────────────────────────────────────────────┐
│                    📊 训练复盘报告                           │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  📈 总体表现                                                  │
│  ├─ 总交易次数: 12 次                                        │
│  ├─ 胜率: 58.3% (7胜5负)                                    │
│  ├─ 总盈亏: +¥8,450.00                                       │
│  └─ 盈亏比: 1.85 (平均盈利 ¥1,850 / 平均亏损 ¥1,000)          │
│                                                              │
│  🎯 买卖时机评分                                              │
│  ├─ 买入时机: 75/100 (良好)                                  │
│  │  └─ MACD 金叉配合 KDJ 超卖，准确率较高                     │
│  └─ 卖出时机: 60/100 (一般)                                  │
│     └─ 部分卖点过早，建议关注 RSI > 80 区域                   │
│                                                              │
│  📊 指标有效性                                                │
│  ├─ MACD: ⭐⭐⭐⭐⭐ (非常有效)                               │
│  ├─ KDJ:  ⭐⭐⭐⭐  (有效)                                    │
│  └─ RSI:  ⭐⭐⭐   (一般)                                     │
│                                                              │
│  💡 改进建议                                                  │
│  1. 当 MACD 和 KDJ 同时出现金叉时，买入准确率提升 23%          │
│  2. 建议在 RSI > 80 时考虑减仓，而非 RSI > 70                │
│  3. 趋势向下的股票（MA 空头排列）应减少买入操作               │
│                                                              │
│  📅 本周进步                                                  │
│  └─ 相比上周，止损执行率提升了 15%，继续保持！                │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## 六、实施计划

### 阶段一：基础配置（1-2天）

| 任务 | 负责人 | 工期 | 依赖 |
|------|--------|------|------|
| 1.1 SOLO IDE 配置 Minimax | 开发者 | 0.5天 | - |
| 1.2 MCP 环境搭建 | 开发者 | 0.5天 | 1.1 |
| 1.3 技术指标验证框架搭建 | 开发者 | 1天 | 1.2 |

### 阶段二：算法优化（3-5天）

| 任务 | 负责人 | 工期 | 依赖 |
|------|--------|------|------|
| 2.1 量价齐升条件优化 | AI辅助+开发者 | 1天 | 1.3 |
| 2.2 上升趋势条件优化 | AI辅助+开发者 | 1天 | 1.3 |
| 2.3 其他条件参数调优 | AI辅助+开发者 | 2天 | 2.1, 2.2 |
| 2.4 回测验证 | 开发者 | 1天 | 2.3 |

### 阶段三：智能反馈（5-7天）

| 任务 | 负责人 | 工期 | 依赖 |
|------|--------|------|------|
| 3.1 训练数据采集模块 | 开发者 | 1天 | - |
| 3.2 AI 分析引擎集成 | AI辅助+开发者 | 2天 | 1.1 |
| 3.3 即时反馈 UI | 开发者 | 1天 | 3.1, 3.2 |
| 3.4 复盘报告模块 | AI辅助+开发者 | 2天 | 3.1, 3.2 |
| 3.5 测试与调优 | 开发者 | 1天 | 3.3, 3.4 |

### 总工期：9-14 天

---

## 七、附录

### A. 相关文档

- [技术指标规格大全](../plans/技术指标规格大全.md)
- [选股条件算法实现计划](../docs/features/选股模块/选股条件算法实现计划.md)
- [K线实战增强实现计划](../docs/features/选股模块/K线实战增强实现计划.md)

### B. 技术栈

- **AI 模型**: Minimax (abab6.5s-chat)
- **MCP 协议**: model-context-protocol
- **Flutter**: 3.19+
- **状态管理**: Riverpod 2.3+

### C. 参考资料

- [Minimax 开放平台](https://platform.minimax.chat/)
- [MCP 官方文档](https://modelcontextprotocol.io/)
- [Awesome MCP Servers](https://github.com/awesome-mcp/servers)

---

*文档版本: v1.0*
*创建日期: 2026-05-20*
*最后更新: 2026-05-20*
