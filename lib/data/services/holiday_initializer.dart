import 'package:kline_trainer/data/database/daos/holiday_dao.dart';

class HolidayInitializer {
  final HolidayDao _holidayDao;

  HolidayInitializer(this._holidayDao);

  Future<void> initializeHolidays() async {
    final currentYear = DateTime.now().year;
    final years = [currentYear - 1, currentYear, currentYear + 1];

    for (final year in years) {
      await _initializeYearHolidays(year);
    }

    print('✅ [HolidayInitializer] 节假日数据初始化完成');
  }

  Future<void> _initializeYearHolidays(int year) async {
    await _generateNationalDayHoliday(year);
    await _generateNewYearHoliday(year);
    await _generateQingmingHoliday(year);
    await _generateLaborDayHoliday(year);
  }

  Future<void> _generateNationalDayHoliday(int year) async {
    for (int day = 1; day <= 7; day++) {
      await _holidayDao.insertHoliday(
        DateTime(year, 10, day),
        true,
        '国庆节',
      );
    }
  }

  Future<void> _generateNewYearHoliday(int year) async {
    await _holidayDao.insertHoliday(
      DateTime(year, 1, 1),
      true,
      '元旦',
    );
  }

  Future<void> _generateQingmingHoliday(int year) async {
    for (int day = 4; day <= 6; day++) {
      await _holidayDao.insertHoliday(
        DateTime(year, 4, day),
        true,
        '清明节',
      );
    }
  }

  Future<void> _generateLaborDayHoliday(int year) async {
    for (int day = 1; day <= 3; day++) {
      await _holidayDao.insertHoliday(
        DateTime(year, 5, day),
        true,
        '劳动节',
      );
    }
  }
}