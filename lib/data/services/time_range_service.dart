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

    try {
      final (minDate, maxDate) = await _stockFilterDao.getKlineDateRange();
      appLogger.i('数据库日期范围: min=$minDate, max=$maxDate');

      final now = DateTime.now();
      
      // 验证日期有效性
      if (minDate.isAfter(maxDate)) {
        appLogger.w('数据库日期范围无效(min > max)，使用默认日期范围');
        return _generateDefaultTrainingDate(trainingDays);
      }

      // 检查数据量是否足够
      final dataRangeDays = maxDate.difference(minDate).inDays;
      if (dataRangeDays < trainingDays + 300) {
        appLogger.w('数据库数据不足，当前数据范围: $dataRangeDays天，需要至少${trainingDays + 300}天');
        
        // 如果数据量非常少，使用默认日期
        if (dataRangeDays < trainingDays) {
          return _generateDefaultTrainingDate(trainingDays);
        }
        
        // 如果有一些数据，尽量使用可用数据
        final adjustedEarliestStartDate = minDate;
        final adjustedLatestStartDate = maxDate.subtract(Duration(days: trainingDays));
        
        if (adjustedEarliestStartDate.isAfter(adjustedLatestStartDate)) {
          return _generateDefaultTrainingDate(trainingDays);
        }
        
        return _generateRandomDate(adjustedEarliestStartDate, adjustedLatestStartDate);
      }

      final earliestStartDate = minDate.add(const Duration(days: 300));
      final latestStartDate = maxDate.subtract(Duration(days: trainingDays));
      appLogger.i('有效日期范围: start=$earliestStartDate, end=$latestStartDate');

      if (earliestStartDate.isAfter(latestStartDate)) {
        appLogger.w('计算后的日期范围无效，使用默认日期');
        return _generateDefaultTrainingDate(trainingDays);
      }

      return _generateRandomDate(earliestStartDate, latestStartDate);
      
    } catch (e, stackTrace) {
      appLogger.e('获取数据库日期范围失败，使用默认日期', error: e, stackTrace: stackTrace);
      return _generateDefaultTrainingDate(trainingDays);
    }
  }

  DateTime _generateRandomDate(DateTime earliest, DateTime latest) {
    final random = Random();
    final daysBetween = latest.difference(earliest).inDays;
    appLogger.i('可选天数范围: $daysBetween天');
    
    final randomDays = random.nextInt(daysBetween + 1);
    final result = earliest.add(Duration(days: randomDays));
    appLogger.i('生成的训练起始日期: $result');
    
    return result;
  }

  DateTime _generateDefaultTrainingDate(int trainingDays) {
    appLogger.i('使用默认日期生成训练起始时间');
    
    final now = DateTime.now();
    final defaultMaxDate = DateTime(now.year - 1, now.month, now.day);
    final defaultMinDate = DateTime(now.year - 5, now.month, now.day);
    
    return _generateRandomDate(defaultMinDate, defaultMaxDate.subtract(Duration(days: trainingDays)));
  }
}
