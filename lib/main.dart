import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app.dart';
import 'data/database/database_service.dart';
import 'shared/utils/logger.dart';
import 'shared/utils/performance_monitor.dart';
import 'shared/utils/health_monitor.dart';
import 'shared/widgets/error_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load();
    appLogger.i('环境配置加载完成', category: LogCategory.app);

    AppLogger.initialize(const LogConfig(
      minLevel: LogLevel.debug,
      enableConsole: true,
      enableFile: true,
    ));
    appLogger.i('日志系统初始化完成', category: LogCategory.app);

    PerformanceMonitor.initialize(enabled: true);
    appLogger.i('性能监控系统初始化完成', category: LogCategory.performance);

    HealthMonitor.initialize();
    _registerHealthChecks();
    appLogger.i('健康监控系统初始化完成', category: LogCategory.app);

    await DatabaseService.instance.initialize();
    appLogger.i('数据库初始化完成', category: LogCategory.database);

    healthMonitor.startPeriodicChecks();
    appLogger.i('定时健康检查已启动', category: LogCategory.app);

    runApp(
      const ProviderScope(
        child: MyApp(),
      ),
    );
  } catch (e, stackTrace) {
    appLogger.e('应用初始化失败', error: e, stackTrace: stackTrace, category: LogCategory.app);

    runApp(
      ErrorPage(
        errorMessage: '应用初始化失败\n${e.toString()}',
        onRetry: () {
          main();
        },
      ),
    );
  }
}

void _registerHealthChecks() {
  healthMonitor.registerCheck('database', () async {
    final stopwatch = Stopwatch()..start();
    try {
      final db = DatabaseService.instance;
      if (db.database != null) {
        stopwatch.stop();
        return HealthCheckResult(
          component: 'database',
          status: HealthStatus.healthy,
          message: '数据库连接正常',
          responseTime: stopwatch.elapsed,
        );
      } else {
        stopwatch.stop();
        return HealthCheckResult(
          component: 'database',
          status: HealthStatus.unhealthy,
          message: '数据库实例为空',
          responseTime: stopwatch.elapsed,
        );
      }
    } catch (e) {
      stopwatch.stop();
      return HealthCheckResult(
        component: 'database',
        status: HealthStatus.unhealthy,
        message: '数据库连接失败: $e',
        responseTime: stopwatch.elapsed,
      );
    }
  });

  healthMonitor.registerCheck('app_initialization', () async {
    return HealthCheckResult(
      component: 'app_initialization',
      status: HealthStatus.healthy,
      message: '应用初始化完成',
    );
  });
}