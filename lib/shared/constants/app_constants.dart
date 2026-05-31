class AppConstants {
  static const String appName = 'K线训练营';
  static const String appVersion = '1.0.0';
  static const String appDescription = '帮助用户学习和练习股票K线分析的教育类应用';

  static const int defaultPageSize = 20;
  static const int maxRetryCount = 3;
  static const Duration defaultTimeout = Duration(seconds: 10);
  static const String defaultApiUrl = 'https://api.example.com';
  static const String placeholderImageBase = 'https://picsum.photos/seed';

  static const String klineSymbol = 'SH600000';
  static const String defaultTimeFrame = 'day';

  static const int minKlineDataDays = 210;
  static const int defaultTrainingDays = 150;
  static const int defaultHistoryDays = 100;
  static const double defaultInitialBalance = 100000.0;
  static const int defaultVisibleKlineCount = 20;
  static const int minVisibleKlineCount = 10;
  static const int maxVisibleKlineCount = 700;
  static const int boundaryDebounceSeconds = 3;

  static const int macdFastPeriod = 12;
  static const int macdSlowPeriod = 26;
  static const int macdSignalPeriod = 9;
  static const int bollPeriod = 20;
  static const double bollStdDev = 2.0;
  static const int rsiPeriod = 14;
  static const int kdjPeriod = 9;
  static const int wrPeriod = 14;
  static const int cciPeriod = 14;
}
