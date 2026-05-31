import 'package:kline_trainer/data/database/daos/holiday_dao.dart';

class TradingDayCalculator {
  final HolidayDao _holidayDao;

  TradingDayCalculator(this._holidayDao);

  Future<int> tradingDaysToCalendarDays(
      int tradingDays, DateTime endDate) async {
    int calendarDays = 0;
    int tradingDayCount = 0;
    DateTime currentDate = endDate;

    while (tradingDayCount < tradingDays) {
      final isHoliday = await _holidayDao.isHoliday(currentDate);

      if (!isHoliday) {
        tradingDayCount++;
      }

      calendarDays++;
      currentDate = currentDate.subtract(const Duration(days: 1));
    }

    return calendarDays;
  }
}
