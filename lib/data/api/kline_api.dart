import 'package:dio/dio.dart';

import 'package:kline_trainer/data/api/dio_client.dart';
import 'package:kline_trainer/data/models/kline_model.dart';
import 'package:kline_trainer/shared/constants/api_endpoints.dart';

class KlineApi {
  final Dio _dio = DioClient.createDio();

  Future<List<KlineModel>> fetchKlineData({
    String symbol = 'SH600000',
    String timeframe = 'day',
    int limit = 100,
  }) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.kline,
        queryParameters: {
          'symbol': symbol,
          'timeframe': timeframe,
          'limit': limit,
        },
      );

      if (response.statusCode == 200) {
        final klineResponse = KlineResponse.fromJson(response.data);
        return klineResponse.data;
      } else {
        throw Exception('Failed to fetch kline data');
      }
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Failed to fetch kline data');
    }
  }

  Future<List<KlineModel>> fetchRealtimeKline(String symbol) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.klineRealtime,
        queryParameters: {
          'symbol': symbol,
        },
      );

      if (response.statusCode == 200) {
        final klineResponse = KlineResponse.fromJson(response.data);
        return klineResponse.data;
      } else {
        throw Exception('Failed to fetch realtime kline data');
      }
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Failed to fetch realtime kline data');
    }
  }
}
