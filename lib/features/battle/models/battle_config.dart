class BattleConfig {
  static const String marketPrefixSH = 'SH';
  static const String marketPrefixSZ = 'SZ';

  static const String exchangeXSHG = 'XSHG';
  static const String exchangeXSHE = 'XSHE';

  static const int minKlineDataDays = 210;

  static const int defaultTrainingDays = 150;
  static const int defaultHistoryDays = 100;
  static const double defaultInitialBalance = 100000.0;
  static const int defaultVisibleKlineCount = 20;

  static const String defaultPeriod = '日K';
  static const String defaultTopIndicator = '成交量';
  static const String defaultBottomIndicator = 'MACD';

  static const List<String> periods = ['日K', '周K', '月K', '季K', '年K'];

  static const List<String> indicators = [
    '成交量',
    'MACD',
    'KDJ',
    'RSI',
    'BOLL',
    'WR',
    'CCI',
    'OBV',
    'DMI',
    'DMA',
    'BBI',
  ];
}
