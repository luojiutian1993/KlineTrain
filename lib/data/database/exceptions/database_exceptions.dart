/// 数据库初始化异常
class DatabaseInitializationException implements Exception {
  final String message;
  final Object? cause;

  DatabaseInitializationException(this.message, {this.cause});

  @override
  String toString() {
    if (cause != null) {
      return 'DatabaseInitializationException: $message\nCause: $cause';
    }
    return 'DatabaseInitializationException: $message';
  }
}

/// 数据库连接异常
class DatabaseConnectionException implements Exception {
  final String message;
  final Object? cause;

  DatabaseConnectionException(this.message, {this.cause});

  @override
  String toString() {
    if (cause != null) {
      return 'DatabaseConnectionException: $message\nCause: $cause';
    }
    return 'DatabaseConnectionException: $message';
  }
}

/// 数据库操作异常
class DatabaseOperationException implements Exception {
  final String message;
  final String? operation;
  final Object? cause;

  DatabaseOperationException({
    required this.message,
    this.operation,
    this.cause,
  });

  @override
  String toString() {
    final buffer = StringBuffer('DatabaseOperationException');
    if (operation != null) {
      buffer.write(' [$operation]');
    }
    buffer.write(': $message');
    if (cause != null) {
      buffer.write('\nCause: $cause');
    }
    return buffer.toString();
  }
}

/// 数据验证异常
class DataValidationException implements Exception {
  final String message;
  final Map<String, String>? errors;

  DataValidationException(this.message, {this.errors});

  @override
  String toString() {
    final buffer = StringBuffer('DataValidationException: $message');
    if (errors != null && errors!.isNotEmpty) {
      buffer.write('\nErrors:');
      errors!.forEach((key, value) {
        buffer.write('\n  - $key: $value');
      });
    }
    return buffer.toString();
  }
}