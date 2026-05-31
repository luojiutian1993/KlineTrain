import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kline_trainer/data/database/database_service.dart';

final trainingConfigServiceProvider = Provider<TrainingConfigService>((ref) {
  return TrainingConfigService(DatabaseService.instance);
});

class TrainingConfigService {
  final DatabaseService _dbService;

  TrainingConfigService(this._dbService);

  Future<int> getTrainingDays() async {
    final value = await _dbService.configDao.getConfig('training.days');
    return int.tryParse(value ?? '150') ?? 150;
  }

  Future<int> getPreloadDays() async {
    final value = await _dbService.configDao.getConfig('training.preload_days');
    return int.tryParse(value ?? '100') ?? 100;
  }

  Future<int> getIndicatorPreloadDays() async {
    final value = await _dbService.configDao.getConfig('training.indicator_preload_days');
    return int.tryParse(value ?? '33') ?? 33;
  }

  Future<int> getTotalPreloadDays() async {
    final preloadDays = await getPreloadDays();
    final indicatorPreloadDays = await getIndicatorPreloadDays();
    return preloadDays + indicatorPreloadDays;
  }

  Future<int> getRequiredTradingDays() async {
    final trainingDays = await getTrainingDays();
    final totalPreloadDays = await getTotalPreloadDays();
    return trainingDays + totalPreloadDays;
  }
}
