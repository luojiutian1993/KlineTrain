
import '../database/app_database.dart';
import 'kline_model.dart';
import 'trade_point_model.dart';

class TrainingReviewData {
  final TrainingSession session;
  final List<KlineModel> klineData;
  final List<TradePoint> tradePoints;
  final List<Trade> trades;

  TrainingReviewData({
    required this.session,
    required this.klineData,
    required this.tradePoints,
    required this.trades,
  });
}
