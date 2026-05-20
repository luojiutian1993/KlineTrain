import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

/// 日志级别枚举
enum LogLevel {
  verbose,
  debug,
  info,
  warning,
  error,
  wtf,
}

/// 日志分类
enum LogCategory {
  app,
  database,
  network,
  performance,
  security,
  business,
  ui,
}

/// 日志配置
class LogConfig {
  final LogLevel minLevel;
  final bool enableConsole;
  final bool enableFile;
  final int maxFileSizeMb;
  final int maxFilesCount;
  final List<LogCategory> enabledCategories;

  const LogConfig({
    this.minLevel = LogLevel.debug,
    this.enableConsole = true,
    this.enableFile = true,
    this.maxFileSizeMb = 10,
    this.maxFilesCount = 5,
    this.enabledCategories = const [
      LogCategory.app,
      LogCategory.database,
      LogCategory.network,
      LogCategory.performance,
      LogCategory.security,
      LogCategory.business,
      LogCategory.ui,
    ],
  });
}

/// 日志记录器
class AppLogger {
  static AppLogger? _instance;
  final Logger _logger;
  final LogConfig _config;
  final Map<LogCategory, bool> _categoryEnabled = {};
  String? _logFilePath;
  Timer? _fileFlushTimer;
  final List<String> _buffer = [];
  final int _bufferSize = 100;

  AppLogger._(this._config)
      : _logger = Logger(
          printer: _AppLogPrinter(),
          level: _config.minLevel.toLogLevel(),
        ) {
    _initCategories();
    _initLogFile();
  }

  static AppLogger get instance {
    _instance ??= AppLogger._(const LogConfig());
    return _instance!;
  }

  static void initialize([LogConfig? config]) {
    _instance = AppLogger._(config ?? const LogConfig());
  }

  void _initCategories() {
    for (var category in LogCategory.values) {
      _categoryEnabled[category] = _config.enabledCategories.contains(category);
    }
  }

  Future<void> _initLogFile() async {
    if (!_config.enableFile) return;

    try {
      final dir = await getApplicationDocumentsDirectory();
      _logFilePath = '${dir.path}/app_logs/app.log';
      await Directory('${dir.path}/app_logs').create(recursive: true);
      _startFileFlushTimer();
    } catch (e) {
      _logger.e('Failed to init log file: $e');
    }
  }

  void _startFileFlushTimer() {
    _fileFlushTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      _flushBuffer();
    });
  }

  void _flushBuffer() {
    if (_buffer.isEmpty || _logFilePath == null) return;

    final lines = List<String>.from(_buffer);
    _buffer.clear();

    final sink = File(_logFilePath!).openWrite(mode: FileMode.append);
    sink.writeAll(lines);
    sink.close().catchError((e) {
      print('Failed to write log file: $e');
    });
  }

  void _writeToFile(String message) {
    if (!_config.enableFile || _logFilePath == null) return;

    _buffer.add('$message\n');
    if (_buffer.length >= _bufferSize) {
      _flushBuffer();
    }
  }

  void v(String message,
      {LogCategory category = LogCategory.app, Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.verbose, message, category, error, stackTrace);
  }

  void d(String message,
      {LogCategory category = LogCategory.app, Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.debug, message, category, error, stackTrace);
  }

  void i(String message,
      {LogCategory category = LogCategory.app, Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.info, message, category, error, stackTrace);
  }

  void w(String message,
      {LogCategory category = LogCategory.app, Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.warning, message, category, error, stackTrace);
  }

  void e(String message,
      {LogCategory category = LogCategory.app, Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.error, message, category, error, stackTrace);
  }

  void wtf(String message,
      {LogCategory category = LogCategory.app, Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.wtf, message, category, error, stackTrace);
  }

  void _log(LogLevel level, String message, LogCategory category,
      Object? error, StackTrace? stackTrace) {
    if (!_categoryEnabled[category]!) return;
    if (level.index < _config.minLevel.index) return;

    final categoryTag = _categoryTag(category);
    final fullMessage = '[${_timestamp()}] [$categoryTag] $message';

    if (_config.enableConsole) {
      switch (level) {
        case LogLevel.verbose:
          _logger.v(fullMessage);
          break;
        case LogLevel.debug:
          _logger.d(fullMessage);
          break;
        case LogLevel.info:
          _logger.i(fullMessage);
          break;
        case LogLevel.warning:
          _logger.w(fullMessage);
          break;
        case LogLevel.error:
          _logger.e(fullMessage, error: error, stackTrace: stackTrace);
          break;
        case LogLevel.wtf:
          _logger.wtf(fullMessage, error: error, stackTrace: stackTrace);
          break;
      }
    }

    _writeToFile(fullMessage);
    if (error != null) {
      _writeToFile('Error: ${error.toString()}');
    }
    if (stackTrace != null) {
      _writeToFile('Stack trace:\n$stackTrace');
    }
  }

  String _categoryTag(LogCategory category) {
    switch (category) {
      case LogCategory.app:
        return 'APP';
      case LogCategory.database:
        return 'DB';
      case LogCategory.network:
        return 'NET';
      case LogCategory.performance:
        return 'PERF';
      case LogCategory.security:
        return 'SEC';
      case LogCategory.business:
        return 'BUS';
      case LogCategory.ui:
        return 'UI';
    }
  }

  String _timestamp() {
    final now = DateTime.now();
    return '${now.year}-${_pad(now.month)}-${_pad(now.day)} ${_pad(now.hour)}:${_pad(now.minute)}:${_pad(now.second)}.${_pad(now.millisecond, 3)}';
  }

  String _pad(int value, [int length = 2]) {
    return value.toString().padLeft(length, '0');
  }

  Future<void> close() async {
    _fileFlushTimer?.cancel();
    _flushBuffer();
  }

  Future<String?> getLogFilePath() async {
    if (_logFilePath != null) {
      return _logFilePath;
    }
    try {
      final dir = await getApplicationDocumentsDirectory();
      return '${dir.path}/app_logs/app.log';
    } catch (_) {
      return null;
    }
  }
}

/// 自定义日志打印机
class _AppLogPrinter extends PrettyPrinter {
  _AppLogPrinter()
      : super(
          methodCount: 2,
          errorMethodCount: 8,
          lineLength: 120,
          colors: true,
          printEmojis: true,
        );

  @override
  List<String> log(LogEvent event) {
    final message = super.log(event);
    return message.where((s) => s.isNotEmpty).cast<String>().toList();
  }
}

extension on LogLevel {
  Level toLogLevel() {
    switch (this) {
      case LogLevel.verbose:
        return Level.verbose;
      case LogLevel.debug:
        return Level.debug;
      case LogLevel.info:
        return Level.info;
      case LogLevel.warning:
        return Level.warning;
      case LogLevel.error:
        return Level.error;
      case LogLevel.wtf:
        return Level.wtf;
    }
  }
}

/// 便捷的全局日志实例
final appLogger = AppLogger.instance;