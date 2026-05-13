# K 线图组件说明

## 已实现功能

### 1. K 线图表主图
- ✅ 蜡烛图（红绿区分涨跌）
- ✅ 均线系统（MA5, MA10, MA20, MA30）
- ✅ 价格信息显示
- ✅ 自适应价格范围

### 2. 成交量图表
- ✅ 成交量柱状图
- ✅ 红绿柱区分涨跌
- ✅ 网格线显示

### 3. MACD 指标图表
- ✅ MACD 柱状图
- ✅ 零轴显示
- ✅ 红绿柱区分正负

### 4. UI 组件
- ✅ 顶部统计信息（周期、训练天数、胜率、盈利）
- ✅ K 线头部（股票名称、代码、价格信息）
- ✅ 控制按钮（前复权、设置、缩放、左右导航）
- ✅ 交易按钮（换股、条件单、买入、卖出）
- ✅ 持仓信息展示

## 技术实现

### 使用的库
- **fl_chart**: Flutter 图表库，用于绘制所有图表
- **CustomPainter**: 自定义绘制蜡烛图和均线

### 数据结构

```dart
class KlineData {
  DateTime date;      // 日期
  double open;        // 开盘价
  double high;        // 最高价
  double low;         // 最低价
  double close;       // 收盘价
  double volume;      // 成交量
}

class VolumeData {
  double volume;      // 成交量
  bool isUp;          // 是否上涨
}

class MacdData {
  double macd;        // MACD 值
  double diff;        // DIFF 值
  double dea;         // DEA 值
}
```

## 交互功能（待实现）

### 计划实现的交互
- [ ] 双指缩放
- [ ] 左右拖动查看历史数据
- [ ] 点击显示详细信息
- [ ] 十字光标
- [ ] 指标切换
- [ ] 周期切换（日线、周线、月线等）

## 使用说明

### 在训练页面中使用 K 线图

```dart
import 'package:kline_trainer/features/training/widgets/kline_chart.dart';

// 创建 K 线图组件
KlineChart(
  klineData: yourKlineData,           // K 线数据列表
  ma5: ma5Data,                       // 5 日均线数据（可选）
  ma10: ma10Data,                     // 10 日均线数据（可选）
  ma20: ma20Data,                     // 20 日均线数据（可选）
  ma30: ma30Data,                     // 30 日均线数据（可选）
  volumes: volumeData,                // 成交量数据列表
  macdData: macdData,                 // MACD 数据列表
)
```

### 数据准备

```dart
// 生成 K 线数据
List<KlineData> klineData = [...];

// 计算均线
List<double> calculateMA(List<KlineData> data, int period) {
  final ma = <double>[];
  for (int i = 0; i < data.length; i++) {
    if (i < period - 1) {
      ma.add(0);
    } else {
      double sum = 0;
      for (int j = 0; j < period; j++) {
        sum += data[i - j].close;
      }
      ma.add(sum / period);
    }
  }
  return ma;
}
```

## 颜色配置

- **上涨**: `Colors.red` (红色)
- **下跌**: `Colors.green` (绿色)
- **MA5**: `Colors.yellow` (黄色)
- **MA10**: `Colors.purple` (紫色)
- **MA20**: `Colors.orange` (橙色)
- **MA30**: `Colors.blue` (蓝色)

## 性能优化建议

1. 对于大量数据，建议使用懒加载
2. 可以考虑使用 `RepaintBoundary` 优化绘制性能
3. 对于实时数据更新，建议使用局部刷新
4. 可以考虑添加数据缓存机制
