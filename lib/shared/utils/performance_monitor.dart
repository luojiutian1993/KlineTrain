import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// 性能指标类型
enum PerformanceMetric {
  databaseQuery,
  networkRequest,
  functionExecution,
  uiRender,
  memoryUsage,
  cpuUsage,
}

/// 性能监控记录
class PerformanceRecord {
  final PerformanceMetric metric;
  final String operation;
  final Duration duration;
  final DateTime timestamp;
  final Map<String, dynamic>? metadata;

  PerformanceRecord({
    required this.metric,
    required this.operation,
    required this.duration,
    this.metadata,
  }) : timestamp = DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'metric': metric.name,
      'operation': operation,
      'duration_ms': duration.inMilliseconds,
      'timestamp': timestamp.toIso8601String(),
      'metadata': metadata,
    };
  }
}

/// 性能监控服务
class PerformanceMonitor {
  static PerformanceMonitor? _instance;
  final List<PerformanceRecord> _records = [];
  final int _maxRecords = 1000;
  Timer? _persistTimer;
  String? _logFilePath;
  bool _enabled = true;

  PerformanceMonitor._() {
    _init();
  }

  static PerformanceMonitor get instance {
    _instance ??= PerformanceMonitor._();
    return _instance!;
  }

  static void initialize({bool enabled = true}) {
    _instance = PerformanceMonitor._();
    _instance!._enabled = enabled;
  }

  Future<void> _init() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      _logFilePath = '${dir.path}/performance/metrics.log';
      await Directory('${dir.path}/performance').create(recursive: true);
      _startPersistTimer();
    } catch (e) {
      // 忽略初始化错误
    }
  }

  void _startPersistTimer() {
    _persistTimer?.cancel();
    _persistTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      _persistRecords();
    });
  }

  /// 记录性能指标
  void record(PerformanceMetric metric, String operation, Duration duration,
      [Map<String, dynamic>? metadata]) {
    if (!_enabled) return;

    final record = PerformanceRecord(
      metric: metric,
      operation: operation,
      duration: duration,
      metadata: metadata,
    );

    _records.add(record);

    if (_records.length > _maxRecords) {
      _records.removeRange(0, _records.length - _maxRecords);
    }

    // 如果耗时超过阈值，打印警告
    if (duration.inMilliseconds > 1000) {
      print('[PERF WARN] $operation took ${duration.inMilliseconds}ms');
    }
  }

  /// 性能监控装饰器
  T monitor<T>(
    String operation,
    PerformanceMetric metric,
    T Function() fn, [
    Map<String, dynamic> Function()? metadataFn,
  ]) {
    if (!_enabled) return fn();

    final stopwatch = Stopwatch()..start();
    try {
      return fn();
    } finally {
      stopwatch.stop();
      record(metric, operation, stopwatch.elapsed, metadataFn?.call());
    }
  }

  /// 异步性能监控装饰器
  Future<T> monitorAsync<T>(
    String operation,
    PerformanceMetric metric,
    Future<T> Function() fn, [
    Map<String, dynamic> Function()? metadataFn,
  ]) async {
    if (!_enabled) return fn();

    final stopwatch = Stopwatch()..start();
    try {
      return await fn();
    } finally {
      stopwatch.stop();
      record(metric, operation, stopwatch.elapsed, metadataFn?.call());
    }
  }

  /// 性能监控上下文管理器
  PerformanceTracker track(String operation, PerformanceMetric metric) {
    return PerformanceTracker._(this, operation, metric);
  }

  Future<void> _persistRecords() async {
    if (_records.isEmpty || _logFilePath == null) return;

    final recordsToPersist = List<PerformanceRecord>.from(_records);
    _records.clear();

    try {
      final file = File(_logFilePath!);
      final sink = file.openWrite(mode: FileMode.append);

      for (final record in recordsToPersist) {
        sink.writeln(jsonEncode(record.toJson()));
      }

      await sink.close();
    } catch (e) {
      // 忽略写入错误
    }
  }

  /// 获取性能统计摘要
  Map<String, dynamic> getSummary() {
    final summary = <String, dynamic>{
      'total_records': _records.length,
      'metrics': <String, dynamic>{},
    };

    for (final metric in PerformanceMetric.values) {
      final metricRecords = _records.where((r) => r.metric == metric).toList();
      if (metricRecords.isEmpty) continue;

      final durations = metricRecords.map((r) => r.duration.inMilliseconds);
      summary['metrics'][metric.name] = {
        'count': metricRecords.length,
        'avg_ms': durations.reduce((a, b) => a + b) / metricRecords.length,
        'min_ms': durations.reduce((a, b) => a < b ? a : b),
        'max_ms': durations.reduce((a, b) => a > b ? a : b),
      };
    }

    return summary;
  }

  /// 导出性能数据
  Future<String?> exportData() async {
    if (_logFilePath == null) return null;

    try {
      final file = File(_logFilePath!);
      return file.readAsString();
    } catch (e) {
      return null;
    }
  }

  Future<void> close() async {
    _persistTimer?.cancel();
    await _persistRecords();
  }
}

/// 性能跟踪器
class PerformanceTracker {
  final PerformanceMonitor _monitor;
  final String _operation;
  final PerformanceMetric _metric;
  final Stopwatch _stopwatch;
  Map<String, dynamic>? _metadata;

  PerformanceTracker._(this._monitor, this._operation, this._metric)
      : _stopwatch = Stopwatch()..start();

  void setMetadata(Map<String, dynamic> metadata) {
    _metadata = metadata;
  }

  void stop() {
    _stopwatch.stop();
    _monitor.record(_metric, _operation, _stopwatch.elapsed, _metadata);
  }
}

/// 便捷的全局性能监控实例
final performanceMonitor = PerformanceMonitor.instance;