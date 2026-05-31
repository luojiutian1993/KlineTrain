class ApiEndpoints {
  static const String kline = '/api/kline';
  static const String klineRealtime = '/api/kline/realtime';
  static const String klineHistory = '/api/kline/history';

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