import 'package:drift/drift.dart';
import 'package:intl/intl.dart';
import '../app_database.dart';
import '../tables/tables.dart';

part 'holiday_dao.g.dart';

@DriftAccessor(tables: [Holidays])
class HolidayDao extends DatabaseAccessor<AppDatabase> with _$HolidayDaoMixin {
  HolidayDao(super.db);

  Future<bool> isHoliday(DateTime date) async {
    final dateStr = DateFormat('yyyy-MM-dd').format(date);
    final result = await (select(holidays)
          ..where((t) => t.date.equals(dateStr)))
        .getSingleOrNull();

    if (result == null) {
      return date.weekday == DateTime.saturday ||
          date.weekday == DateTime.sunday;
    }

    return result.isHoliday;
  }

  Future<void> insertHoliday(
      DateTime date, bool isHoliday, String? name) async {
    final dateStr = DateFormat('yyyy-MM-dd').format(date);
    await into(holidays).insertOnConflictUpdate(
      HolidaysCompanion(
        date: Value(dateStr),
        isHoliday: Value(isHoliday),
        holidayName: Value(name),
      ),
    );
  }

  Future<int> countTradingDays(DateTime startDate, DateTime endDate) async {
    int count = 0;
    DateTime current = startDate;

    while (!current.isAfter(endDate)) {
      if (!await isHoliday(current)) {
        count++;
      }
      current = current.add(const Duration(days: 1));
    }

    return count;
  }
}
