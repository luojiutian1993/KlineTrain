import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// 健康状态
enum HealthStatus {
  healthy,
  degraded,
  unhealthy,
}

/// 健康检查结果
class HealthCheckResult {
  final String component;
  final HealthStatus status;
  final String? message;
  final DateTime timestamp;
  final Duration? responseTime;

  HealthCheckResult({
    required this.component,
    required this.status,
    this.message,
    this.responseTime,
  }) : timestamp = DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'component': component,
      'status': status.name,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'response_time_ms': responseTime?.inMilliseconds,
    };
  }
}

/// 应用健康监控服务
class HealthMonitor {
  static HealthMonitor? _instance;
  final List<HealthCheckResult> _checkHistory = [];
  final int _maxHistorySize = 100;
  Timer? _checkTimer;
  String? _logFilePath;
  final Map<String, Future<HealthCheckResult> Function()> _checks = {};

  HealthMonitor._() {
    _init();
  }

  static HealthMonitor get instance {
    _instance ??= HealthMonitor._();
    return _instance!;
  }

  static void initialize() {
    _instance = HealthMonitor._();
  }

  Future<void> _init() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      _logFilePath = '${dir.path}/health/health.log';
      await Directory('${dir.path}/health').create(recursive: true);
    } catch (e) {
      // 忽略初始化错误
    }
  }

  /// 注册健康检查
  void registerCheck(String name, Future<HealthCheckResult> Function() check) {
    _checks[name] = check;
  }

  /// 执行所有健康检查
  Future<List<HealthCheckResult>> runAllChecks() async {
    final results = <HealthCheckResult>[];

    for (final entry in _checks.entries) {
      try {
        final result = await entry.value();
        results.add(result);
        _recordResult(result);
      } catch (e) {
        final errorResult = HealthCheckResult(
          component: entry.key,
          status: HealthStatus.unhealthy,
          message: 'Check failed with error: $e',
        );
        results.add(errorResult);
        _recordResult(errorResult);
      }
    }

    return results;
  }

  /// 执行单个健康检查
  Future<HealthCheckResult> runCheck(String name) async {
    final check = _checks[name];
    if (check == null) {
      return HealthCheckResult(
        component: name,
        status: HealthStatus.unhealthy,
        message: 'Check not found',
      );
    }

    try {
      final result = await check();
      _recordResult(result);
      return result;
    } catch (e) {
      final errorResult = HealthCheckResult(
        component: name,
        status: HealthStatus.unhealthy,
        message: 'Check failed with error: $e',
      );
      _recordResult(errorResult);
      return errorResult;
    }
  }

  void _recordResult(HealthCheckResult result) {
    _checkHistory.add(result);

    if (_checkHistory.length > _maxHistorySize) {
      _checkHistory.removeRange(0, _checkHistory.length - _maxHistorySize);
    }

    _persistResult(result);
  }

  Future<void> _persistResult(HealthCheckResult result) async {
    if (_logFilePath == null) return;

    try {
      final file = File(_logFilePath!);
      await file.writeAsString('${jsonEncode(result.toJson())}\n',
          mode: FileMode.append);
    } catch (e) {
      // 忽略写入错误
    }
  }

  /// 获取整体健康状态
  HealthStatus getOverallStatus() {
    if (_checkHistory.isEmpty) return HealthStatus.healthy;

    final recentResults = _checkHistory
        .where((r) =>
            r.timestamp.isAfter(DateTime.now().subtract(const Duration(hours: 1))))
        .toList();

    if (recentResults.isEmpty) return HealthStatus.healthy;

    final hasUnhealthy = recentResults.any((r) => r.status == HealthStatus.unhealthy);
    if (hasUnhealthy) return HealthStatus.unhealthy;

    final hasDegraded = recentResults.any((r) => r.status == HealthStatus.degraded);
    if (hasDegraded) return HealthStatus.degraded;

    return HealthStatus.healthy;
  }

  /// 获取健康状态摘要
  Map<String, dynamic> getSummary() {
    return {
      'overall_status': getOverallStatus().name,
      'check_count': _checks.length,
      'history_count': _checkHistory.length,
      'recent_checks': _checkHistory
          .take(10)
          .map((r) => r.toJson())
          .toList(),
    };
  }

  /// 导出健康日志
  Future<String?> exportLogs() async {
    if (_logFilePath == null) return null;

    try {
      final file = File(_logFilePath!);
      return file.readAsString();
    } catch (e) {
      return null;
    }
  }

  /// 启动定时健康检查
  void startPeriodicChecks({Duration interval = const Duration(minutes: 5)}) {
    _checkTimer?.cancel();
    _checkTimer = Timer.periodic(interval, (_) {
      runAllChecks();
    });
  }

  /// 停止定时健康检查
  void stopPeriodicChecks() {
    _checkTimer?.cancel();
  }

  Future<void> close() async {
    _checkTimer?.cancel();
  }
}

/// 便捷的全局健康监控实例
final healthMonitor = HealthMonitor.instance;