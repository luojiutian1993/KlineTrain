import 'dart:math';
import 'package:kline_trainer/data/models/kline_model.dart';

class MACDResult {
  final List<double> dif;
  final List<double> dea;
  final List<double> macd;

  MACDResult({
    required this.dif,
    required this.dea,
    required this.macd,
  });
}

class BollResult {
  final List<double> mb;
  final List<double> up;
  final List<double> dn;

  BollResult({
    required this.mb,
    required this.up,
    required this.dn,
  });
}

class KDJResult {
  final List<double> k;
  final List<double> d;
  final List<double> j;

  KDJResult({
    required this.k,
    required this.d,
    required this.j,
  });
}

class RSIResult {
  final List<double> values;

  RSIResult({required this.values});
}

class WRResult {
  final List<double> values;

  WRResult({required this.values});
}

class IndicatorCalculator {
  static List<double> calculateEMA(List<double> closes, int period) {
    final k = 2 / (period + 1);
    final ema = <double>[];

    if (closes.length < period) return ema;

    double sum = 0;
    for (int i = 0; i < period; i++) {
      sum += closes[i];
    }
    ema.add(sum / period);

    for (int i = period; i < closes.length; i++) {
      ema.add(closes[i] * k + ema.last * (1 - k));
    }

    return ema;
  }

  static List<double> calculateSMA(List<double> values, int period) {
    final sma = <double>[];

    if (values.length < period) return sma;

    for (int i = period - 1; i < values.length; i++) {
      double sum = 0;
      for (int j = 0; j < period; j++) {
        sum += values[i - j];
      }
      sma.add(sum / period);
    }

    return sma;
  }

  static MACDResult calculateMACD(
    List<KlineModel> data, {
    int fastPeriod = 12,
    int slowPeriod = 26,
    int signalPeriod = 9,
  }) {
    final closes = data.map((d) => d.close).toList();

    final emaFast = calculateEMA(closes, fastPeriod);
    final emaSlow = calculateEMA(closes, slowPeriod);

    final minLength = min(emaFast.length, emaSlow.length);
    final dif = <double>[];
    for (int i = 0; i < minLength; i++) {
      dif.add(emaFast[i] - emaSlow[i]);
    }

    final dea = calculateEMA(dif, signalPeriod);

    final macd = <double>[];
    for (int i = 0; i < dea.length; i++) {
      macd.add(2 * (dif[i] - dea[i]));
    }

    return MACDResult(dif: dif, dea: dea, macd: macd);
  }

  static BollResult calculateBoll(
    List<KlineModel> data, {
    int period = 20,
    double stdDev = 2.0,
  }) {
    final closes = data.map((d) => d.close).toList();
    final mb = <double>[];
    final up = <double>[];
    final dn = <double>[];

    if (closes.length < period) {
      return BollResult(mb: mb, up: up, dn: dn);
    }

    for (int i = period - 1; i < closes.length; i++) {
      double sum = 0;
      for (int j = i - period + 1; j <= i; j++) {
        sum += closes[j];
      }
      final ma = sum / period;
      mb.add(ma);

      double variance = 0;
      for (int j = i - period + 1; j <= i; j++) {
        variance += pow(closes[j] - ma, 2);
      }
      final md = sqrt(variance / period);

      up.add(ma + stdDev * md);
      dn.add(ma - stdDev * md);
    }

    return BollResult(mb: mb, up: up, dn: dn);
  }

  static KDJResult calculateKDJ(
    List<KlineModel> data, {
    int rsvPeriod = 9,
    int kPeriod = 3,
    int dPeriod = 3,
  }) {
    final k = <double>[];
    final d = <double>[];
    final j = <double>[];

    if (data.length < rsvPeriod) {
      return KDJResult(k: k, d: d, j: j);
    }

    double prevK = 50;
    double prevD = 50;

    for (int i = rsvPeriod - 1; i < data.length; i++) {
      double lowestLow = double.infinity;
      double highestHigh = 0;

      for (int j = i - rsvPeriod + 1; j <= i; j++) {
        lowestLow = min(lowestLow, data[j].low);
        highestHigh = max(highestHigh, data[j].high);
      }

      final range = highestHigh - lowestLow;
      final rsv = range == 0 ? 0 : (data[i].close - lowestLow) / range * 100;

      final currentK = 2 / 3 * prevK + 1 / 3 * rsv;
      final currentD = 2 / 3 * prevD + 1 / 3 * currentK;
      final currentJ = 3 * currentK - 2 * currentD;

      k.add(currentK);
      d.add(currentD);
      j.add(currentJ);

      prevK = currentK;
      prevD = currentD;
    }

    return KDJResult(k: k, d: d, j: j);
  }

  static RSIResult calculateRSI(List<KlineModel> data, {int period = 14}) {
    final rsi = <double>[];
    final changes = <double>[];

    for (int i = 1; i < data.length; i++) {
      changes.add(data[i].close - data[i - 1].close);
    }

    if (changes.length < period) {
      return RSIResult(values: rsi);
    }

    for (int i = period; i < changes.length; i++) {
      double gainSum = 0;
      double lossSum = 0;

      for (int j = i - period; j < i; j++) {
        if (changes[j] > 0) {
          gainSum += changes[j];
        } else {
          lossSum += changes[j].abs();
        }
      }

      final avgGain = gainSum / period;
      final avgLoss = lossSum / period;

      if (avgLoss == 0) {
        rsi.add(100);
      } else {
        final rs = avgGain / avgLoss;
        rsi.add(100 - 100 / (1 + rs));
      }
    }

    return RSIResult(values: rsi);
  }

  static WRResult calculateWR(List<KlineModel> data, {int period = 14}) {
    final wr = <double>[];

    if (data.length < period) {
      return WRResult(values: wr);
    }

    for (int i = period - 1; i < data.length; i++) {
      double highestHigh = 0;
      double lowestLow = double.infinity;

      for (int j = i - period + 1; j <= i; j++) {
        highestHigh = max(highestHigh, data[j].high);
        lowestLow = min(lowestLow, data[j].low);
      }

      final range = highestHigh - lowestLow;
      if (range == 0) {
        wr.add(0);
      } else {
        wr.add((highestHigh - data[i].close) / range * 100);
      }
    }

    return WRResult(values: wr);
  }
}