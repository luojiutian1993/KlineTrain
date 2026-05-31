import 'package:drift/drift.dart';

class Holidays extends Table {
  TextColumn get date => text()();

  BoolColumn get isHoliday => boolean()();

  TextColumn get holidayName => text().nullable()();

  @override
  Set<Column> get primaryKey => {date};
}