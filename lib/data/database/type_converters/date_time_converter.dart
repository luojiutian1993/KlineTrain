import 'package:drift/drift.dart';

/// 自定义日期时间转换器，处理数据库中存储为字符串或DateTime的日期
class DateTimeConverter extends TypeConverter<DateTime, DateTime> {
  const DateTimeConverter();

  @override
  DateTime mapToDart(DateTime? fromDb) {
    if (fromDb == null) {
      return DateTime.now();
    }
    return fromDb;
  }

  @override
  DateTime mapToSql(DateTime? value) {
    if (value == null) {
      return DateTime.now();
    }
    return value;
  }
}

/// 字符串日期时间转换器，用于自定义查询
DateTime parseDateTimeFromDb(dynamic value) {
  if (value == null) {
    return DateTime.now();
  }
  
  if (value is DateTime) {
    return value;
  }
  
  if (value is String) {
    try {
      if (value.contains('T')) {
        return DateTime.parse(value);
      } else if (value.contains(' ')) {
        return DateTime.parse(value.replaceAll(' ', 'T'));
      } else {
        return DateTime.parse('${value}T00:00:00');
      }
    } catch (e) {
      final parts = value.split(RegExp(r'[-/]'));
      if (parts.length >= 3) {
        final year = int.tryParse(parts[0].trim());
        final month = int.tryParse(parts[1].trim());
        final day = int.tryParse(parts[2].trim());
        if (year != null && month != null && day != null) {
          return DateTime(year, month, day);
        }
      }
    }
  }
  
  return DateTime.now();
}