import 'package:kline_trainer/data/database/daos/holiday_dao.dart';
import 'package:kline_trainer/data/models/kline_model.dart';

class DataSufficiencyResult {
  final bool isSufficient;
  final String reason;
  final int availableDays;
  final int requiredDays;
  final int? shortage;

  DataSufficiencyResult({
    required this.isSufficient,
    required this.reason,
    required this.availableDays,
    required this.requiredDays,
    this.shortage,
  });
}

class DataSufficiencyChecker {
  final HolidayDao _holidayDao;

  DataSufficiencyChecker(this._holidayDao);

  Future<DataSufficiencyResult> checkSufficiency({
    required List<KlineModel> data,
    required int requiredTradingDays,
  }) async {
    if (data.isEmpty) {
      print('⚠️ [DataSufficiencyChecker] 无数据');
      return DataSufficiencyResult(
        isSufficient: false,
        reason: '无数据',
        availableDays: 0,
        requiredDays: requiredTradingDays,
      );
    }

    final firstDate = DateTime.fromMillisecondsSinceEpoch(data.first.timestamp);
    final lastDate = DateTime.fromMillisecondsSinceEpoch(data.last.timestamp);

    final actualTradingDays =
        await _holidayDao.countTradingDays(firstDate, lastDate);
    final isSufficient = actualTradingDays >= requiredTradingDays;

    print('🔵 [DataSufficiencyChecker] 检查结果:');
    print('  - 数据范围: $firstDate ~ $lastDate');
    print('  - 实际交易日: $actualTradingDays');
    print('  - 需求交易日: $requiredTradingDays');
    print('  - 是否充足: $isSufficient');

    return DataSufficiencyResult(
      isSufficient: isSufficient,
      reason: isSufficient ? '数据充足' : '数据不足',
      availableDays: actualTradingDays,
      requiredDays: requiredTradingDays,
      shortage: isSufficient ? null : requiredTradingDays - actualTradingDays,
    );
  }
}
