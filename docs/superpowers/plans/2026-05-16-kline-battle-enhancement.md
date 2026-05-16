# K线实战页面增强功能实现计划

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 增强实战页面的K线展示，实现更顺滑的走势、买卖点位标记、下一步按钮控制K线每日变化，并从数据库读取真实数据。

**Architecture:** 
1. 使用数据库K线数据替代模拟数据
2. 实现时间步进机制，支持按天推进
3. 优化K线渲染算法，使用Path绘制更平滑的均线
4. 添加买卖点位标记功能
5. 在换股、条件单、买入、卖出模块添加"下一步"按钮

**Tech Stack:** Flutter, Riverpod, Drift (SQLite), FlChart

---

## 文件结构

| 文件路径 | 职责 |
|---------|------|
| `lib/features/battle/battle_screen.dart` | 实战页面主组件 |
| `lib/features/training/widgets/kline_chart.dart` | K线图表组件 |
| `lib/data/repositories/kline_repository.dart` | K线数据仓库 |
| `lib/data/database/daos/kline_dao.dart` | K线数据库访问 |
| `lib/providers/kline_provider.dart` | K线状态管理 |

---

### Task 1: 增强K线组件 - 添加平滑均线和买卖点位标记

**Files:**
- Modify: `lib/features/training/widgets/kline_chart.dart`

- [ ] **Step 1: 添加买卖点位数据结构**

```dart
class TradePoint {
  final int index;
  final double price;
  final bool isBuy;
  final String label;

  TradePoint({
    required this.index,
    required this.price,
    required this.isBuy,
    required this.label,
  });
}
```

- [ ] **Step 2: 修改KlineChart组件支持买卖点位**

```dart
class KlineChart extends StatelessWidget {
  final List<KlineData> klineData;
  final List<double>? ma5;
  final List<double>? ma10;
  final List<double>? ma20;
  final List<double>? ma30;
  final List<VolumeData> volumes;
  final List<MacdData> macdData;
  final List<TradePoint>? tradePoints;  // 新增

  const KlineChart({
    super.key,
    required this.klineData,
    this.ma5,
    this.ma10,
    this.ma20,
    this.ma30,
    required this.volumes,
    required this.macdData,
    this.tradePoints,  // 新增
  });
  // ...
}
```

- [ ] **Step 3: 修改CandleStickPainter支持平滑均线和买卖点位**

```dart
void _drawLine(Canvas canvas, Size size, List<double> values, Color color) {
  final double candleWidth = size.width / klineData.length;
  final double priceRange = maxY - minY;
  final linePaint = Paint()
    ..color = color
    ..strokeWidth = 1.5
    ..style = PaintingStyle.stroke
    ..isAntiAlias = true;

  final path = Path();
  bool started = false;

  for (int i = 0; i < values.length && i < klineData.length; i++) {
    if (values[i] == 0) continue;
    final x = i * candleWidth + candleWidth / 2;
    final y = size.height - ((values[i] - minY) / priceRange) * size.height;

    if (!started) {
      path.moveTo(x, y);
      started = true;
    } else {
      // 使用二阶贝塞尔曲线实现平滑
      final prevX = (i - 1) * candleWidth + candleWidth / 2;
      final prevY = size.height - ((values[i - 1] - minY) / priceRange) * size.height;
      final cpX = (prevX + x) / 2;
      path.quadraticBezierTo(prevX, prevY, cpX, (prevY + y) / 2);
    }
  }

  canvas.drawPath(path, linePaint);
}

void _drawTradePoints(Canvas canvas, Size size) {
  if (tradePoints == null || tradePoints!.isEmpty) return;
  
  final double candleWidth = size.width / klineData.length;
  final double priceRange = maxY - minY;

  for (var point in tradePoints!) {
    if (point.index >= klineData.length) continue;
    
    final x = point.index * candleWidth + candleWidth / 2;
    final y = size.height - ((point.price - minY) / priceRange) * size.height;
    
    final paint = Paint()
      ..color = point.isBuy ? Colors.red : Colors.green
      ..style = PaintingStyle.fill;
    
    // 绘制三角形标记
    final path = Path();
    if (point.isBuy) {
      path.moveTo(x, y - 10);
      path.lineTo(x - 6, y);
      path.lineTo(x + 6, y);
    } else {
      path.moveTo(x, y + 10);
      path.lineTo(x - 6, y);
      path.lineTo(x + 6, y);
    }
    path.close();
    canvas.drawPath(path, paint);
    
    // 绘制标签
    final textPainter = TextPainter(
      text: TextSpan(
        text: point.label,
        style: TextStyle(
          color: point.isBuy ? Colors.red : Colors.green,
          fontSize: 10,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(x - textPainter.width / 2, point.isBuy ? y - 25 : y + 12));
  }
}
```

---

### Task 2: 修改K线Repository从数据库读取真实数据

**Files:**
- Modify: `lib/data/repositories/kline_repository.dart`
- Read: `lib/data/database/daos/kline_dao.dart`

- [ ] **Step 1: 导入数据库依赖**

```dart
import 'package:kline_trainer/data/database/database_service.dart';
import 'package:kline_trainer/data/database/tables/kline_data_table.dart';
```

- [ ] **Step 2: 添加从数据库获取K线数据的方法**

```dart
class KlineRepository {
  final KlineApi _api = KlineApi();
  final DatabaseService _dbService = DatabaseService();

  Future<List<KlineModel>> fetchKlineDataFromDb({
    String symbol = 'SH600000',
    String period = 'day',
    int limit = 100,
  }) async {
    final db = await _dbService.database;
    final klineDao = db.klineDao;
    
    final dbData = await klineDao.getKlineData(symbol, period, limit: limit);
    
    return dbData.map((item) => KlineModel(
      symbol: item.symbol,
      timestamp: item.tradeDate.millisecondsSinceEpoch,
      open: item.open,
      high: item.high,
      low: item.low,
      close: item.close,
      volume: item.volume,
      turnover: item.turnover ?? 0,
    )).toList();
  }

  Future<List<KlineModel>> fetchKlineData({
    String symbol = 'SH600000',
    String timeframe = 'day',
    int limit = 100,
  }) async {
    try {
      // 优先从数据库获取
      final dbData = await fetchKlineDataFromDb(
        symbol: symbol,
        period: timeframe,
        limit: limit,
      );
      
      if (dbData.isNotEmpty) {
        return dbData;
      }
      
      // 如果数据库没有，尝试API
      return await _api.fetchKlineData(
        symbol: symbol,
        timeframe: timeframe,
        limit: limit,
      );
    } catch (e) {
      return _generateMockData(symbol, limit);
    }
  }
  // ...
}
```

---

### Task 3: 实现实战页面的时间步进机制

**Files:**
- Modify: `lib/features/battle/battle_screen.dart`

- [ ] **Step 1: 添加时间步进状态管理**

```dart
class _BattleScreenState extends ConsumerState<BattleScreen> {
  int _selectedIndex = 1;
  String _selectedPeriod = '日K';
  String _selectedIndicator = '成交量';
  int _currentDayIndex = 0;  // 当前显示的天数索引
  bool _isPlaying = false;   // 是否自动播放
  Timer? _playTimer;
  
  final List<String> _periods = ['日K', '周K', '月K', '季K', '年K'];
  final List<String> _indicators = ['成交量', 'MACD', 'KDJ', 'RSI', 'BOLL'];
  
  List<KlineData> _klineData = [];
  List<TradePoint> _tradePoints = [];
  // ...
}
```

- [ ] **Step 2: 添加时间步进方法**

```dart
void _nextDay() {
  if (_currentDayIndex < _klineData.length - 1) {
    setState(() {
      _currentDayIndex++;
    });
  }
}

void _prevDay() {
  if (_currentDayIndex > 0) {
    setState(() {
      _currentDayIndex--;
    });
  }
}

void _togglePlay() {
  setState(() {
    _isPlaying = !_isPlaying;
  });
  
  if (_isPlaying) {
    _playTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (_currentDayIndex < _klineData.length - 1) {
        setState(() {
          _currentDayIndex++;
        });
      } else {
        _isPlaying = false;
        timer.cancel();
      }
    });
  } else {
    _playTimer?.cancel();
  }
}

@override
void dispose() {
  _playTimer?.cancel();
  super.dispose();
}
```

- [ ] **Step 3: 修改build方法使用真实数据**

```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    body: SingleChildScrollView(
      child: Column(
        children: [
          _buildStockInfo(),
          _buildMarketData(),
          _buildTimeStepper(),  // 新增时间步进器
          _buildPeriodSelector(),
          _buildKlineChart(),
          _buildIndicatorSelector(),
          _buildIndicatorChart(),
          _buildTradeButtons(),
          _buildNextStepButton(),  // 新增下一步按钮
          _buildAccountInfo(),
          _buildSummaryCards(),
        ],
      ),
    ),
    // ...
  );
}
```

- [ ] **Step 4: 实现时间步进器组件**

```dart
Widget _buildTimeStepper() {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    decoration: const BoxDecoration(
      border: Border(bottom: BorderSide(color: AppTheme.border, width: 0.5)),
    ),
    child: Column(
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.skip_previous),
              onPressed: _prevDay,
              disabledColor: Colors.grey,
            ),
            IconButton(
              icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
              onPressed: _togglePlay,
            ),
            IconButton(
              icon: const Icon(Icons.skip_next),
              onPressed: _nextDay,
              disabledColor: Colors.grey,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Slider(
                value: _currentDayIndex.toDouble(),
                min: 0,
                max: (_klineData.length - 1).toDouble(),
                onChanged: (value) {
                  setState(() {
                    _currentDayIndex = value.toInt();
                  });
                },
              ),
            ),
            const SizedBox(width: 16),
            Text(
              _klineData.isNotEmpty 
                  ? '${_klineData[_currentDayIndex].date.month}/${_klineData[_currentDayIndex].date.day}'
                  : '--',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('进度: ${_currentDayIndex + 1} / ${_klineData.length}'),
          ],
        ),
      ],
    ),
  );
}
```

- [ ] **Step 5: 实现换股按钮**

```dart
Widget _buildChangeStockButton() {
  return Expanded(
    child: ElevatedButton(
      onPressed: () {
        // 弹出选股页面，根据选股条件筛选股票
        _showStockSelectionDialog();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.surface,
        foregroundColor: AppTheme.muted,
        side: const BorderSide(color: AppTheme.border),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: const Text('换股'),
    ),
  );
}

void _showStockSelectionDialog() {
  // 显示选股页面，用户选择新标的后，加载该标的历史数据
  // 切换后继续从当前进度开始训练
}
```

- [ ] **Step 6: 实现条件单按钮**

```dart
Widget _buildConditionalOrderButton() {
  return Expanded(
    child: ElevatedButton(
      onPressed: () {
        // 弹出条件单设置页面
        _showConditionalOrderDialog();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.surface,
        foregroundColor: AppTheme.muted,
        side: const BorderSide(color: AppTheme.border),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: const Text('条件单'),
    ),
  );
}

void _showConditionalOrderDialog() {
  // 显示条件单设置页面，用户可设置：
  // - 价格条件（高于/低于某价格买入/卖出）
  // - 止盈止损（设置止盈价、止损价）
  // - 条件买卖（MA金叉/死叉时触发）
  // 条件设置后，在用户点击"下一步"时检查是否满足条件，满足则自动执行
}
```

- [ ] **Step 7: 实现下一步按钮**

```dart
Widget _buildNextStepButton() {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    child: Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: _nextDay,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('下一步 (推进到下一天)'),
          ),
        ),
      ],
    ),
  );
}
```

---

### Task 4: 集成数据库初始化和数据加载

**Files:**
- Modify: `lib/data/repositories/kline_repository.dart`
- Read: `assets/data/stock_data/stock_data.db`

- [ ] **Step 1: 添加数据库初始化检查**

```dart
Future<bool> hasKlineDataInDb(String symbol, String period) async {
  final db = await _dbService.database;
  final count = await db.klineDao.countKlineData(symbol, period);
  return count > 0;
}

Future<void> ensureKlineData(String symbol, String period, int limit) async {
  final hasData = await hasKlineDataInDb(symbol, period);
  if (!hasData) {
    // 如果数据库没有数据，从API获取并保存
    try {
      final apiData = await _api.fetchKlineData(
        symbol: symbol,
        timeframe: period,
        limit: limit,
      );
      
      final db = await _dbService.database;
      final companions = apiData.map((item) => KlineDataCompanion(
        symbol: Value(item.symbol),
        period: Value(period),
        tradeDate: Value(DateTime.fromMillisecondsSinceEpoch(item.timestamp)),
        open: Value(item.open),
        high: Value(item.high),
        low: Value(item.low),
        close: Value(item.close),
        volume: Value(item.volume),
        turnover: Value(item.turnover),
      )).toList();
      
      await db.klineDao.batchInsertKline(companions);
    } catch (e) {
      // 如果API失败，使用模拟数据
    }
  }
}
```

---

### Task 5: 更新K线图表使用过滤后的数据

**Files:**
- Modify: `lib/features/battle/battle_screen.dart`

- [ ] **Step 1: 修改K线数据传递逻辑**

```dart
Widget _buildKlineChart() {
  // 只显示到当前天数的数据
  final displayData = _klineData.take(_currentDayIndex + 1).toList();
  final displayVolumes = _volumes.take(_currentDayIndex + 1).toList();
  final displayMacd = _macdData.take(_currentDayIndex + 1).toList();
  
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: const BoxDecoration(
      border: Border(bottom: BorderSide(color: AppTheme.border, width: 0.5)),
    ),
    child: Column(
      children: [
        SizedBox(
          height: 280,
          child: KlineChart(
            klineData: displayData,
            ma5: _calculateMA(displayData, 5),
            ma10: _calculateMA(displayData, 10),
            ma20: _calculateMA(displayData, 20),
            ma30: _calculateMA(displayData, 30),
            volumes: displayVolumes,
            macdData: displayMacd,
            tradePoints: _tradePoints,  // 传递买卖点位
          ),
        ),
        // ...
      ],
    ),
  );
}
```

---

### Task 6: 测试和验证

**Files:**
- Run: `flutter test`

- [ ] **Step 1: 运行单元测试**

```bash
cd /Users/lin/dev/KlineTrain
flutter test
```

- [ ] **Step 2: 运行应用验证功能**

```bash
cd /Users/lin/dev/KlineTrain
flutter run
```

---

## 预期效果

1. K线图表使用平滑的贝塞尔曲线绘制均线
2. 买卖点位在图表上以三角形标记显示
3. "下一步"按钮推进K线显示到下一天
4. 时间步进器支持播放/暂停、前进/后退和滑块控制
5. K线数据从SQLite数据库读取真实数据