class AppConstants {
  static const String appName = 'K线训练营';
  static const String appVersion = '1.0.0';
  static const String appDescription = '帮助用户学习和练习股票K线分析的教育类应用';

  static const int defaultPageSize = 20;
  static const int maxRetryCount = 3;
  static const Duration defaultTimeout = Duration(seconds: 10);

  static const String klineSymbol = 'SH600000';
  static const String defaultTimeFrame = 'day';
}
