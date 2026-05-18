import 'dart:math';
import 'package:kline_trainer/data/database/daos/stock_filter_dao.dart';
import 'package:kline_trainer/shared/utils/logger.dart';

class TimeRangeService {
  final StockFilterDao _stockFilterDao;

  TimeRangeService(this._stockFilterDao);

  Future<DateTime> generateRandomTrainingStartDate({
    int trainingDays = 150,
  }) async {
    appLogger.i('开始生成训练起始日期...');
    final (minDate, maxDate) = await _stockFilterDao.getKlineDateRange();
    appLogger.i('数据库日期范围: min=$minDate, max=$maxDate');

    final earliestStartDate = minDate.add(const Duration(days: 300));
    final latestStartDate = maxDate.subtract(Duration(days: trainingDays));
    appLogger.i('有效日期范围: start=$earliestStartDate, end=$latestStartDate');

    if (earliestStartDate.isAfter(latestStartDate)) {
      appLogger.e('日期范围无效: earliestStartDate > latestStartDate');
      throw Exception('数据库数据不足，无法生成有效的训练起始日期');
    }

    final random = Random();
    final daysBetween = latestStartDate.difference(earliestStartDate).inDays;
    appLogger.i('可选天数范围: $daysBetween天');
    
    final randomDays = random.nextInt(daysBetween + 1);
    final result = earliestStartDate.add(Duration(days: randomDays));
    appLogger.i('生成的训练起始日期: $result');

    return result;
  }
}
