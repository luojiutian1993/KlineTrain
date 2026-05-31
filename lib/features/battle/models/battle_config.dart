import 'package:kline_trainer/shared/constants/app_constants.dart';
import 'package:kline_trainer/shared/constants/api_endpoints.dart';

class BattleConfig {
  static const String marketPrefixSH = 'SH';
  static const String marketPrefixSZ = 'SZ';

  static const String exchangeXSHG = 'XSHG';
  static const String exchangeXSHE = 'XSHE';

  static const int minKlineDataDays = AppConstants.minKlineDataDays;
  static const int defaultTrainingDays = AppConstants.defaultTrainingDays;
  static const int defaultHistoryDays = AppConstants.defaultHistoryDays;
  static const double defaultInitialBalance =
      AppConstants.defaultInitialBalance;
  static const int defaultVisibleKlineCount =
      AppConstants.defaultVisibleKlineCount;

  static const int minVisibleKlineCount = AppConstants.minVisibleKlineCount;
  static const int maxVisibleKlineCount = AppConstants.maxVisibleKlineCount;
  static const int boundaryDebounceSeconds =
      AppConstants.boundaryDebounceSeconds;
  static const int slideStepCount = 5;
  static const double zoomFactor = 1.2;

  static const String defaultPeriod = '日K';
  static const String defaultTopIndicator = '成交量';
  static const String defaultBottomIndicator = 'MACD';

  static List<String> get periods => ApiEndpoints.periods;
  static List<String> get indicators => ApiEndpoints.indicators;
}
