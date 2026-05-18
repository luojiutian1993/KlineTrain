import 'dart:math';
import 'package:kline_trainer/data/database/daos/stock_filter_dao.dart';

class TimeRangeService {
  final StockFilterDao _stockFilterDao;

  TimeRangeService(this._stockFilterDao);

  Future<DateTime> generateRandomTrainingStartDate({
    int trainingDays = 150,
  }) async {
    final (minDate, maxDate) = await _stockFilterDao.getKlineDateRange();

    final earliestStartDate = minDate.add(const Duration(days: 300));

    final latestStartDate = maxDate.subtract(Duration(days: trainingDays));

    if (earliestStartDate.isAfter(latestStartDate)) {
      throw Exception('数据库数据不足，无法生成有效的训练起始日期');
    }

    final random = Random();
    final daysBetween = latestStartDate.difference(earliestStartDate).inDays;
    final randomDays = random.nextInt(daysBetween + 1);

    return earliestStartDate.add(Duration(days: randomDays));
  }
}
