# K线图周期与副图指标规格

## 1. 概述

本文档定义K线训练营中K线图的周期切换规则和副图指标计算规范。

---

## 2. 周期定义

### 2.1 五种周期

| 周期 | 标识 | 数据聚合规则 | 数据范围 |
|------|------|--------------|----------|
| **日线** | DAY | 每日一根K线 | 当日开盘/最高/最低/收盘 |
| **周线** | WEEK | 每周一根K线（周一为起始） | 周一开盘，周内最高/最低，周五收盘 |
| **月线** | MONTH | 每月一根K线 | 月初开盘，月内最高/最低，月末收盘 |
| **季线** | QUARTER | 每季度一根K线 | 季初开盘，季内最高/最低，季末收盘 |
| **年线** | YEAR | 每年一根K线 | 年初开盘，年内最高/最低，年末收盘 |

### 2.2 周期聚合算法

#### 2.2.1 周线聚合

```
周定义: 周一 00:00:00 至 周日 23:59:59

周线数据:
  open = 周一开盘价
  high = 周内最高价
  low = 周内最低价
  close = 周五收盘价（若周五无交易，取最后交易日收盘价）
  volume = 周内成交量总和
  amount = 周内成交额总和
  timestamp = 周五日期
```

**SQL实现思路**:
```sql
-- 从日线数据聚合周线
SELECT 
  instrument_id,
  DATE_TRUNC('week', timestamp) + INTERVAL '4 days' AS week_end, -- 周五
  FIRST_VALUE(open) OVER (PARTITION BY instrument_id, DATE_TRUNC('week', timestamp) ORDER BY timestamp) AS open,
  MAX(high) OVER (PARTITION BY instrument_id, DATE_TRUNC('week', timestamp)) AS high,
  MIN(low) OVER (PARTITION BY instrument_id, DATE_TRUNC('week', timestamp)) AS low,
  LAST_VALUE(close) OVER (PARTITION BY instrument_id, DATE_TRUNC('week', timestamp) ORDER BY timestamp) AS close,
  SUM(volume) OVER (PARTITION BY instrument_id, DATE_TRUNC('week', timestamp)) AS volume,
  SUM(amount) OVER (PARTITION BY instrument_id, DATE_TRUNC('week', timestamp)) AS amount
FROM kline_data
WHERE period = 'DAY'
  AND EXTRACT(DOW FROM timestamp) BETWEEN 1 AND 5; -- 周一到周五
```

**边界条件**:
- 周一为节假日：取本周第一个交易日的开盘价
- 周五为节假日：取本周最后一个交易日的收盘价

---

#### 2.2.2 月线聚合

```
月定义: 每月1日 00:00:00 至 月末 23:59:59

月线数据:
  open = 月初开盘价（1日开盘价）
  high = 月内最高价
  low = 月内最低价
  close = 月末收盘价（最后交易日收盘价）
  volume = 月内成交量总和
  amount = 月内成交额总和
  timestamp = 月末日期
```

**SQL实现思路**:
```sql
-- 从日线数据聚合月线
SELECT 
  instrument_id,
  DATE_TRUNC('month', timestamp) + INTERVAL '1 month - 1 day' AS month_end,
  FIRST_VALUE(open) OVER (PARTITION BY instrument_id, DATE_TRUNC('month', timestamp) ORDER BY timestamp) AS open,
  MAX(high) OVER (PARTITION BY instrument_id, DATE_TRUNC('month', timestamp)) AS high,
  MIN(low) OVER (PARTITION BY instrument_id, DATE_TRUNC('month', timestamp)) AS low,
  LAST_VALUE(close) OVER (PARTITION BY instrument_id, DATE_TRUNC('month', timestamp) ORDER BY timestamp) AS close,
  SUM(volume) OVER (PARTITION BY instrument_id, DATE_TRUNC('month', timestamp)) AS volume,
  SUM(amount) OVER (PARTITION BY instrument_id, DATE_TRUNC('month', timestamp)) AS amount
FROM kline_data
WHERE period = 'DAY';
```

---

#### 2.2.3 季线聚合

```
季度划分（自然季度）:
  Q1: 1月1日 - 3月31日
  Q2: 4月1日 - 6月30日
  Q3: 7月1日 - 9月30日
  Q4: 10月1日 - 12月31日

季线数据:
  open = 季初开盘价（季度第一个交易日开盘价）
  high = 季内最高价
  low = 季内最低价
  close = 季末收盘价（季度最后交易日收盘价）
  volume = 季内成交量总和
  amount = 季内成交额总和
  timestamp = 季末日期
```

**SQL实现思路**:
```sql
-- 从日线数据聚合季线
SELECT 
  instrument_id,
  CASE 
    WHEN EXTRACT(MONTH FROM timestamp) BETWEEN 1 AND 3 THEN DATE_TRUNC('year', timestamp) + INTERVAL '3 months - 1 day'
    WHEN EXTRACT(MONTH FROM timestamp) BETWEEN 4 AND 6 THEN DATE_TRUNC('year', timestamp) + INTERVAL '6 months - 1 day'
    WHEN EXTRACT(MONTH FROM timestamp) BETWEEN 7 AND 9 THEN DATE_TRUNC('year', timestamp) + INTERVAL '9 months - 1 day'
    ELSE DATE_TRUNC('year', timestamp) + INTERVAL '1 year - 1 day'
  END AS quarter_end,
  FIRST_VALUE(open) OVER (PARTITION BY instrument_id, 
    CASE 
      WHEN EXTRACT(MONTH FROM timestamp) BETWEEN 1 AND 3 THEN 1
      WHEN EXTRACT(MONTH FROM timestamp) BETWEEN 4 AND 6 THEN 2
      WHEN EXTRACT(MONTH FROM timestamp) BETWEEN 7 AND 9 THEN 3
      ELSE 4
    END ORDER BY timestamp) AS open,
  MAX(high) OVER (PARTITION BY instrument_id, 
    CASE 
      WHEN EXTRACT(MONTH FROM timestamp) BETWEEN 1 AND 3 THEN 1
      WHEN EXTRACT(MONTH FROM timestamp) BETWEEN 4 AND 6 THEN 2
      WHEN EXTRACT(MONTH FROM timestamp) BETWEEN 7 AND 9 THEN 3
      ELSE 4
    END) AS high,
  MIN(low) OVER (PARTITION BY instrument_id, 
    CASE 
      WHEN EXTRACT(MONTH FROM timestamp) BETWEEN 1 AND 3 THEN 1
      WHEN EXTRACT(MONTH FROM timestamp) BETWEEN 4 AND 6 THEN 2
      WHEN EXTRACT(MONTH FROM timestamp) BETWEEN 7 AND 9 THEN 3
      ELSE 4
    END) AS low,
  LAST_VALUE(close) OVER (PARTITION BY instrument_id, 
    CASE 
      WHEN EXTRACT(MONTH FROM timestamp) BETWEEN 1 AND 3 THEN 1
      WHEN EXTRACT(MONTH FROM timestamp) BETWEEN 4 AND 6 THEN 2
      WHEN EXTRACT(MONTH FROM timestamp) BETWEEN 7 AND 9 THEN 3
      ELSE 4
    END ORDER BY timestamp) AS close,
  SUM(volume) OVER (PARTITION BY instrument_id, 
    CASE 
      WHEN EXTRACT(MONTH FROM timestamp) BETWEEN 1 AND 3 THEN 1
      WHEN EXTRACT(MONTH FROM timestamp) BETWEEN 4 AND 6 THEN 2
      WHEN EXTRACT(MONTH FROM timestamp) BETWEEN 7 AND 9 THEN 3
      ELSE 4
    END) AS volume,
  SUM(amount) OVER (PARTITION BY instrument_id, 
    CASE 
      WHEN EXTRACT(MONTH FROM timestamp) BETWEEN 1 AND 3 THEN 1
      WHEN EXTRACT(MONTH FROM timestamp) BETWEEN 4 AND 6 THEN 2
      WHEN EXTRACT(MONTH FROM timestamp) BETWEEN 7 AND 9 THEN 3
      ELSE 4
    END) AS amount
FROM kline_data
WHERE period = 'DAY';
```

---

#### 2.2.4 年线聚合

```
年定义: 每年1月1日 00:00:00 至 12月31日 23:59:59

年线数据:
  open = 年初开盘价（1月第一个交易日开盘价）
  high = 年内最高价
  low = 年内最低价
  close = 年末收盘价（12月最后交易日收盘价）
  volume = 年内成交量总和
  amount = 年内成交额总和
  timestamp = 年末日期（12月31日）
```

**SQL实现思路**:
```sql
-- 从日线数据聚合年线
SELECT 
  instrument_id,
  DATE_TRUNC('year', timestamp) + INTERVAL '1 year - 1 day' AS year_end,
  FIRST_VALUE(open) OVER (PARTITION BY instrument_id, DATE_TRUNC('year', timestamp) ORDER BY timestamp) AS open,
  MAX(high) OVER (PARTITION BY instrument_id, DATE_TRUNC('year', timestamp)) AS high,
  MIN(low) OVER (PARTITION BY instrument_id, DATE_TRUNC('year', timestamp)) AS low,
  LAST_VALUE(close) OVER (PARTITION BY instrument_id, DATE_TRUNC('year', timestamp) ORDER BY timestamp) AS close,
  SUM(volume) OVER (PARTITION BY instrument_id, DATE_TRUNC('year', timestamp)) AS volume,
  SUM(amount) OVER (PARTITION BY instrument_id, DATE_TRUNC('year', timestamp)) AS amount
FROM kline_data
WHERE period = 'DAY';
```

---

### 2.3 数据存储策略

#### 2.3.1 方案对比

| 方案 | 描述 | 优点 | 缺点 | 推荐 |
|------|------|------|------|------|
| **方案A: 实时计算** | 查询时从日线实时聚合 | 存储空间小 | 查询慢，计算量大 | 不推荐 |
| **方案B: 预计算存储** | 每日收盘后预计算并存储 | 查询快 | 存储空间增加 | **推荐** |
| **方案C: 混合方案** | 常用周期预存储，非常用周期实时计算 | 平衡 | 实现复杂 | 可选 |

#### 2.3.2 推荐方案: 预计算存储

```sql
-- 周期数据表（扩展原有kline_data表）
-- period字段已支持: DAY, WEEK, MONTH, QUARTER, YEAR

-- 预计算任务（每日收盘后执行）
-- 1. 计算当日周线数据
-- 2. 计算当月月线数据（月末）
-- 3. 计算当季季线数据（季末）
-- 4. 计算当年年线数据（年末）
```

#### 2.3.3 数据量估算

| 周期 | 每年数据量 | 5年数据量 | 备注 |
|------|-----------|-----------|------|
| 日线 | ~250条 | ~1250条 | 交易日 |
| 周线 | ~52条 | ~260条 | 自然周 |
| 月线 | ~12条 | ~60条 | 自然月 |
| 季线 | ~4条 | ~20条 | 自然季度 |
| 年线 | ~1条 | ~5条 | 自然年 |

**单品种5年总数据量**: ~1250 + 260 + 60 + 20 + 5 = **~1595条**

---

## 3. 副图指标定义

### 3.1 指标概览

| 指标 | 标识 | 默认参数 | 参数可配置 | 显示限制 |
|------|------|----------|------------|----------|
| **MACD** | MACD | 12, 26, 9 | 是 | 所有用户 |
| **布林带** | BOLL | 20, 2 | 是 | 所有用户 |
| **KDJ** | KDJ | 9, 3, 3 | 是 | 所有用户 |
| **RSI** | RSI | 14 | 是 | 所有用户 |
| **WR** | WR | 14 | 是 | 所有用户 |
| **成交量** | VOLUME | - | 否 | 默认显示 |

### 3.2 显示规则

| 用户类型 | 最少显示 | 最多显示 | 默认显示 |
|----------|----------|----------|----------|
| 一般用户 | 1个 | 2个 | MACD + 成交量 |
| 会员用户 | 1个 | 5个 | MACD + 成交量 + 布林带 + KDJ + RSI |

### 3.3 指标计算算法

#### 3.3.1 MACD (Moving Average Convergence Divergence)

**默认参数**: 快线=12, 慢线=26, 信号线=9

**计算公式**:
```
EMA12 = EMA(close, 12)  -- 12日指数移动平均线
EMA26 = EMA(close, 26)  -- 26日指数移动平均线

DIF = EMA12 - EMA26     -- 快线（差离值）
DEA = EMA(DIF, 9)       -- 慢线（信号线）
MACD = 2 * (DIF - DEA)  -- MACD柱状图

其中 EMA计算公式:
EMA[t] = close[t] * k + EMA[t-1] * (1-k)
k = 2 / (N + 1)  -- N为周期
```

**Flutter实现**:
```dart
class MACDIndicator {
  final int fastPeriod;    // 默认12
  final int slowPeriod;    // 默认26
  final int signalPeriod;  // 默认9
  
  List<double> calculateEMA(List<double> closes, int period) {
    final k = 2 / (period + 1);
    final ema = <double>[];
    
    // 第一个EMA取简单平均
    double sum = 0;
    for (int i = 0; i < period && i < closes.length; i++) {
      sum += closes[i];
    }
    ema.add(sum / period);
    
    // 后续EMA按公式计算
    for (int i = period; i < closes.length; i++) {
      ema.add(closes[i] * k + ema.last * (1 - k));
    }
    
    return ema;
  }
  
  MACDResult calculate(List<KlineData> data) {
    final closes = data.map((d) => d.close).toList();
    
    final emaFast = calculateEMA(closes, fastPeriod);
    final emaSlow = calculateEMA(closes, slowPeriod);
    
    // 计算DIF
    final dif = <double>[];
    for (int i = 0; i < emaFast.length; i++) {
      dif.add(emaFast[i] - emaSlow[i]);
    }
    
    // 计算DEA
    final dea = calculateEMA(dif, signalPeriod);
    
    // 计算MACD柱状图
    final macd = <double>[];
    for (int i = 0; i < dea.length; i++) {
      macd.add(2 * (dif[i] - dea[i]));
    }
    
    return MACDResult(dif: dif, dea: dea, macd: macd);
  }
}
```

---

#### 3.3.2 布林带 (Bollinger Bands)

**默认参数**: 周期=20, 标准差倍数=2

**计算公式**:
```
中轨线 (MB) = MA(close, 20)  -- 20日简单移动平均线

标准差 (MD) = SQRT(SUM((close - MB)^2, 20) / 20)

上轨线 (UP) = MB + 2 * MD
下轨线 (DN) = MB - 2 * MD
```

**Flutter实现**:
```dart
class BollIndicator {
  final int period;      // 默认20
  final double stdDev;   // 默认2.0
  
  BollResult calculate(List<KlineData> data) {
    final closes = data.map((d) => d.close).toList();
    final mb = <double>[];  // 中轨
    final up = <double>[];  // 上轨
    final dn = <double>[];  // 下轨
    
    for (int i = period - 1; i < closes.length; i++) {
      // 计算MA
      double sum = 0;
      for (int j = i - period + 1; j <= i; j++) {
        sum += closes[j];
      }
      final ma = sum / period;
      mb.add(ma);
      
      // 计算标准差
      double variance = 0;
      for (int j = i - period + 1; j <= i; j++) {
        variance += pow(closes[j] - ma, 2);
      }
      final md = sqrt(variance / period);
      
      up.add(ma + stdDev * md);
      dn.add(ma - stdDev * md);
    }
    
    return BollResult(mb: mb, up: up, dn: dn);
  }
}
```

---

#### 3.3.3 KDJ (随机指标)

**默认参数**: RSV周期=9, K平滑=3, D平滑=3

**计算公式**:
```
RSV = (close - LLV(low, 9)) / (HHV(high, 9) - LLV(low, 9)) * 100

K = 2/3 * K[t-1] + 1/3 * RSV
D = 2/3 * D[t-1] + 1/3 * K
J = 3 * K - 2 * D

其中:
LLV(low, 9) = 最近9日最低价
HHV(high, 9) = 最近9日最高价
```

**Flutter实现**:
```dart
class KDJIndicator {
  final int rsvPeriod;  // 默认9
  final int kPeriod;    // 默认3
  final int dPeriod;    // 默认3
  
  KDJResult calculate(List<KlineData> data) {
    final k = <double>[];
    final d = <double>[];
    final j = <double>[];
    
    double prevK = 50;  // 初始值50
    double prevD = 50;  // 初始值50
    
    for (int i = rsvPeriod - 1; i < data.length; i++) {
      // 计算RSV
      double lowestLow = double.infinity;
      double highestHigh = 0;
      
      for (int j = i - rsvPeriod + 1; j <= i; j++) {
        lowestLow = min(lowestLow, data[j].low);
        highestHigh = max(highestHigh, data[j].high);
      }
      
      final range = highestHigh - lowestLow;
      final rsv = range == 0 ? 0 : (data[i].close - lowestLow) / range * 100;
      
      // 计算K, D, J
      final currentK = 2/3 * prevK + 1/3 * rsv;
      final currentD = 2/3 * prevD + 1/3 * currentK;
      final currentJ = 3 * currentK - 2 * currentD;
      
      k.add(currentK);
      d.add(currentD);
      j.add(currentJ);
      
      prevK = currentK;
      prevD = currentD;
    }
    
    return KDJResult(k: k, d: d, j: j);
  }
}
```

---

#### 3.3.4 RSI (相对强弱指标)

**默认参数**: 周期=14

**计算公式**:
```
RSI = 100 - 100 / (1 + RS)

其中:
RS = SMA(max(close - close[t-1], 0), 14) / SMA(abs(close - close[t-1]), 14)

即: 14日平均上涨幅度 / 14日平均下跌幅度
```

**Flutter实现**:
```dart
class RSIIndicator {
  final int period;  // 默认14
  
  RSIResult calculate(List<KlineData> data) {
    final rsi = <double>[];
    final changes = <double>[];
    
    // 计算价格变化
    for (int i = 1; i < data.length; i++) {
      changes.add(data[i].close - data[i-1].close);
    }
    
    for (int i = period; i < changes.length; i++) {
      double gainSum = 0;
      double lossSum = 0;
      
      for (int j = i - period; j < i; j++) {
        if (changes[j] > 0) {
          gainSum += changes[j];
        } else {
          lossSum += changes[j].abs();
        }
      }
      
      final avgGain = gainSum / period;
      final avgLoss = lossSum / period;
      
      if (avgLoss == 0) {
        rsi.add(100);
      } else {
        final rs = avgGain / avgLoss;
        rsi.add(100 - 100 / (1 + rs));
      }
    }
    
    return RSIResult(values: rsi);
  }
}
```

---

#### 3.3.5 WR (威廉指标)

**默认参数**: 周期=14

**计算公式**:
```
WR = (HHV(high, 14) - close) / (HHV(high, 14) - LLV(low, 14)) * 100

其中:
HHV(high, 14) = 最近14日最高价
LLV(low, 14) = 最近14日最低价
```

**Flutter实现**:
```dart
class WRIndicator {
  final int period;  // 默认14
  
  WRResult calculate(List<KlineData> data) {
    final wr = <double>[];
    
    for (int i = period - 1; i < data.length; i++) {
      double highestHigh = 0;
      double lowestLow = double.infinity;
      
      for (int j = i - period + 1; j <= i; j++) {
        highestHigh = max(highestHigh, data[j].high);
        lowestLow = min(lowestLow, data[j].low);
      }
      
      final range = highestHigh - lowestLow;
      if (range == 0) {
        wr.add(0);
      } else {
        wr.add((highestHigh - data[i].close) / range * 100);
      }
    }
    
    return WRResult(values: wr);
  }
}
```

---

#### 3.3.6 成交量 (Volume)

**说明**: 成交量直接显示原始数据，无需计算。

**显示方式**:
```
柱状图，颜色规则:
- 上涨日: 红色（close >= open）
- 下跌日: 绿色（close < open）
```

---

### 3.4 参数配置界面

#### 3.4.1 MACD参数配置

```yaml
参数项:
  - name: "快线周期"
    key: "fastPeriod"
    type: "integer"
    default: 12
    range: [5, 50]
    
  - name: "慢线周期"
    key: "slowPeriod"
    type: "integer"
    default: 26
    range: [10, 100]
    
  - name: "信号线周期"
    key: "signalPeriod"
    type: "integer"
    default: 9
    range: [5, 30]
```

#### 3.4.2 布林带参数配置

```yaml
参数项:
  - name: "计算周期"
    key: "period"
    type: "integer"
    default: 20
    range: [10, 60]
    
  - name: "标准差倍数"
    key: "stdDev"
    type: "float"
    default: 2.0
    range: [1.0, 4.0]
    step: 0.5
```

#### 3.4.3 KDJ参数配置

```yaml
参数项:
  - name: "RSV周期"
    key: "rsvPeriod"
    type: "integer"
    default: 9
    range: [5, 30]
    
  - name: "K平滑系数"
    key: "kPeriod"
    type: "integer"
    default: 3
    range: [2, 10]
    
  - name: "D平滑系数"
    key: "dPeriod"
    type: "integer"
    default: 3
    range: [2, 10]
```

#### 3.4.4 RSI参数配置

```yaml
参数项:
  - name: "计算周期"
    key: "period"
    type: "integer"
    default: 14
    range: [6, 30]
```

#### 3.4.5 WR参数配置

```yaml
参数项:
  - name: "计算周期"
    key: "period"
    type: "integer"
    default: 14
    range: [6, 30]
```

---

## 4. API设计

### 4.1 获取K线数据

```yaml
GET /api/v1/instruments/{id}/kline
Query:
  period: string (required) - DAY/WEEK/MONTH/QUARTER/YEAR
  start_date: string (optional) - YYYY-MM-DD
  end_date: string (optional) - YYYY-MM-DD
  limit: number (optional, default: 500)
  
Response:
  instrument_id: string
  period: string
  indicators:
    macd:
      fast_period: 12
      slow_period: 26
      signal_period: 9
      dif: [number]
      dea: [number]
      macd: [number]
    boll:
      period: 20
      std_dev: 2.0
      mb: [number]
      up: [number]
      dn: [number]
    kdj:
      rsv_period: 9
      k_period: 3
      d_period: 3
      k: [number]
      d: [number]
      j: [number]
    rsi:
      period: 14
      values: [number]
    wr:
      period: 14
      values: [number]
  items:
    - timestamp: timestamp
      open: number
      high: number
      low: number
      close: number
      volume: number
      amount: number
```

### 4.2 更新指标参数

```yaml
PUT /api/v1/user/indicator-settings
Request:
  macd:
    fast_period: number
    slow_period: number
    signal_period: number
  boll:
    period: number
    std_dev: number
  kdj:
    rsv_period: number
    k_period: number
    d_period: number
  rsi:
    period: number
  wr:
    period: number
    
Response:
  success: boolean
```

---

## 5. 界面交互设计

### 5.1 周期切换

```
┌─────────────────────────────────────────────────────────┐
│  [日K] [周K] [月K] [季K] [年K]                          │
│   ●     ○     ○     ○     ○                             │
│  选中: 强调色背景 + 白色文字                             │
│  未选: 透明背景 + 灰色文字 + 灰色边框                     │
└─────────────────────────────────────────────────────────┘
```

### 5.2 副图指标选择

```
┌─────────────────────────────────────────────────────────┐
│  副图指标 [设置⚙️]                                       │
│                                                         │
│  [MACD ▼] [布林带 ▼] [KDJ ▼] [RSI ▼] [WR ▼]            │
│   ●        ○        ○        ○        ○                 │
│                                                         │
│  点击设置图标打开参数配置弹窗                            │
│  点击指标Tab切换显示/隐藏                                │
│                                                         │
│  一般用户: 最多选择2个指标                               │
│  会员用户: 最多选择5个指标                               │
└─────────────────────────────────────────────────────────┘
```

### 5.3 参数配置弹窗

```
┌─────────────────────────────────────┐
│  MACD参数设置              [X]      │
├─────────────────────────────────────┤
│                                     │
│  快线周期    [12    ]  范围: 5-50   │
│  慢线周期    [26    ]  范围: 10-100 │
│  信号线周期  [9     ]  范围: 5-30   │
│                                     │
│  [恢复默认]        [取消] [确认]    │
│                                     │
└─────────────────────────────────────┘
```

---

## 6. 性能优化

### 6.1 指标计算优化

| 优化策略 | 说明 |
|----------|------|
| **增量计算** | 新K线到来时，仅计算最新指标值，而非全量重算 |
| **缓存机制** | 缓存最近计算的指标结果，避免重复计算 |
| **Web Worker** | 复杂指标计算放入后台线程，避免阻塞UI |
| **懒加载** | 未显示的指标暂不计算 |

### 6.2 图表渲染优化

| 优化策略 | 说明 |
|----------|------|
| **数据降采样** | 大量数据时，采用LTTB等算法降采样 |
| **分层渲染** | 主图和副图分层渲染，互不影响 |
| **GPU加速** | 使用Canvas或WebGL加速渲染 |
| **虚拟滚动** | 仅渲染可视区域的K线 |

---

## 7. 测试用例

### 7.1 周期切换测试

| 场景 | 操作 | 预期结果 |
|------|------|----------|
| 日线切周线 | 点击"周K" | 显示周线数据，周K高亮 |
| 周线切月线 | 点击"月K" | 显示月线数据，月K高亮 |
| 数据不足 | 切换到年线 | 提示"数据不足"或显示可用数据 |

### 7.2 副图指标测试

| 场景 | 操作 | 预期结果 |
|------|------|----------|
| 添加指标 | 点击未选中的指标 | 指标显示，计算正确 |
| 移除指标 | 点击已选中的指标 | 指标隐藏 |
| 超出限制 | 一般用户选择第3个指标 | 提示"最多选择2个指标" |
| 修改参数 | 修改MACD参数 | 指标重新计算，显示更新 |

### 7.3 指标计算测试

| 指标 | 输入数据 | 预期结果 |
|------|----------|----------|
| MACD | 已知收盘价序列 | DIF/DEA/MACD值与标准软件一致 |
| 布林带 | 已知收盘价序列 | 上轨/中轨/下轨值正确 |
| KDJ | 已知高低收序列 | K/D/J值在0-100范围内 |
| RSI | 已知收盘价序列 | RSI值在0-100范围内 |
| WR | 已知高低收序列 | WR值在0-100范围内 |

---

*文档版本：v1.0*  
*生成日期：2026-05-13*  
*确认规则：周线起始=周一, 季度=自然季度, 默认副图=MACD+成交量, MACD参数=12,26,9*
