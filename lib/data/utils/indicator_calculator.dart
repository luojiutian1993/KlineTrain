import 'dart:math';
import 'package:kline_trainer/data/models/kline_model.dart';
import 'package:kline_trainer/features/training/widgets/kline_chart.dart';

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

class CCIResult {
  final List<double> values;

  CCIResult({required this.values});
}

class OBVResult {
  final List<double> values;

  OBVResult({required this.values});
}

class DMIResult {
  final List<double> plusDI;
  final List<double> minusDI;
  final List<double> adx;

  DMIResult({
    required this.plusDI,
    required this.minusDI,
    required this.adx,
  });
}

class DMAResult {
  final List<double> dma;
  final List<double> ama;

  DMAResult({required this.dma, required this.ama});
}

class BBIResult {
  final List<double> values;

  BBIResult({required this.values});
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

  static CCIResult calculateCCI(List<KlineModel> data, {int period = 14}) {
    final cci = <double>[];

    if (data.length < period) {
      return CCIResult(values: cci);
    }

    for (int i = period - 1; i < data.length; i++) {
      double tpSum = 0;
      for (int j = i - period + 1; j <= i; j++) {
        final tp = (data[j].high + data[j].low + data[j].close) / 3;
        tpSum += tp;
      }
      final smaTp = tpSum / period;

      double meanDevSum = 0;
      for (int j = i - period + 1; j <= i; j++) {
        final tp = (data[j].high + data[j].low + data[j].close) / 3;
        meanDevSum += (tp - smaTp).abs();
      }
      final meanDev = meanDevSum / period;

      final tp = (data[i].high + data[i].low + data[i].close) / 3;
      if (meanDev == 0) {
        cci.add(0);
      } else {
        cci.add((tp - smaTp) / (0.015 * meanDev));
      }
    }

    return CCIResult(values: cci);
  }

  static OBVResult calculateOBV(List<KlineModel> data) {
    final obv = <double>[];

    if (data.isEmpty) {
      return OBVResult(values: obv);
    }

    obv.add(data[0].volume);
    for (int i = 1; i < data.length; i++) {
      if (data[i].close > data[i - 1].close) {
        obv.add(obv.last + data[i].volume);
      } else if (data[i].close < data[i - 1].close) {
        obv.add(obv.last - data[i].volume);
      } else {
        obv.add(obv.last);
      }
    }

    return OBVResult(values: obv);
  }

  static DMIResult calculateDMI(List<KlineModel> data, {int period = 14}) {
    final plusDI = <double>[];
    final minusDI = <double>[];
    final adxList = <double>[];

    if (data.length < period + 1) {
      return DMIResult(plusDI: plusDI, minusDI: minusDI, adx: adxList);
    }

    final List<double> trList = [];
    final List<double> plusDMList = [];
    final List<double> minusDMList = [];

    for (int i = 1; i < data.length; i++) {
      final high = data[i].high;
      final low = data[i].low;
      final prevHigh = data[i - 1].high;
      final prevLow = data[i - 1].low;
      final prevClose = data[i - 1].close;

      final tr = max(
          max(high - low, (high - prevClose).abs()), (low - prevClose).abs());
      trList.add(tr);

      final plusDM =
          high - prevHigh > prevLow - low ? max(high - prevHigh, 0.0) : 0.0;
      plusDMList.add(plusDM);

      final minusDM =
          prevLow - low > high - prevHigh ? max(prevLow - low, 0.0) : 0.0;
      minusDMList.add(minusDM);
    }

    final List<double> smoothedTR = [];
    final List<double> smoothedPlusDM = [];
    final List<double> smoothedMinusDM = [];

    double sumTR = 0, sumPlusDM = 0, sumMinusDM = 0;
    for (int i = 0; i < period; i++) {
      sumTR += trList[i];
      sumPlusDM += plusDMList[i];
      sumMinusDM += minusDMList[i];
    }
    smoothedTR.add(sumTR);
    smoothedPlusDM.add(sumPlusDM);
    smoothedMinusDM.add(sumMinusDM);

    for (int i = period; i < trList.length; i++) {
      smoothedTR.add(smoothedTR.last - smoothedTR.last / period + trList[i]);
      smoothedPlusDM.add(
          smoothedPlusDM.last - smoothedPlusDM.last / period + plusDMList[i]);
      smoothedMinusDM.add(smoothedMinusDM.last -
          smoothedMinusDM.last / period +
          minusDMList[i]);
    }

    for (int i = period - 1; i < smoothedTR.length; i++) {
      if (smoothedTR[i] == 0) {
        plusDI.add(0);
        minusDI.add(0);
      } else {
        plusDI.add(smoothedPlusDM[i] / smoothedTR[i] * 100);
        minusDI.add(smoothedMinusDM[i] / smoothedTR[i] * 100);
      }
    }

    final List<double> dxList = [];
    for (int i = 0; i < plusDI.length; i++) {
      final sum = plusDI[i] + minusDI[i];
      if (sum == 0) {
        dxList.add(0);
      } else {
        dxList.add((plusDI[i] - minusDI[i]).abs() / sum * 100);
      }
    }

    for (int i = period - 1; i < dxList.length; i++) {
      double sumDx = 0;
      for (int j = i - period + 1; j <= i; j++) {
        sumDx += dxList[j];
      }
      adxList.add(sumDx / period);
    }

    return DMIResult(plusDI: plusDI, minusDI: minusDI, adx: adxList);
  }

  static DMAResult calculateDMA(List<KlineModel> data,
      {int shortPeriod = 10, int longPeriod = 50, int signalPeriod = 10}) {
    final closes = data.map((d) => d.close).toList();
    final shortMA = calculateSMA(closes, shortPeriod);
    final longMA = calculateSMA(closes, longPeriod);

    final dma = <double>[];
    final minLength = min(shortMA.length, longMA.length);
    for (int i = 0; i < minLength; i++) {
      dma.add(shortMA[i] - longMA[i]);
    }

    final ama = calculateSMA(dma, signalPeriod);

    return DMAResult(dma: dma, ama: ama);
  }

  static BBIResult calculateBBI(List<KlineModel> data) {
    final closes = data.map((d) => d.close).toList();
    final ma3 = calculateSMA(closes, 3);
    final ma6 = calculateSMA(closes, 6);
    final ma12 = calculateSMA(closes, 12);
    final ma20 = calculateSMA(closes, 20);

    final bbi = <double>[];
    final minLength =
        min(min(ma3.length, ma6.length), min(ma12.length, ma20.length));
    for (int i = 0; i < minLength; i++) {
      bbi.add((ma3[i] + ma6[i] + ma12[i] + ma20[i]) / 4);
    }

    return BBIResult(values: bbi);
  }

  static Map<String, dynamic> calculateAll(List<KlineModel> data) {
    final closes = data.map((d) => d.close).toList();

    final ma5 = calculateSMA(closes, 5);
    final ma10 = calculateSMA(closes, 10);
    final ma20 = calculateSMA(closes, 20);
    final ma30 = calculateSMA(closes, 30);

    final volumes = data
        .map((d) => VolumeData(
              volume: d.volume,
              isUp: d.close >= d.open,
            ))
        .toList();

    final macdResult = calculateMACD(data);
    final macdData = <MacdData>[];
    for (int i = 0; i < macdResult.macd.length; i++) {
      macdData.add(MacdData(
        macd: macdResult.macd[i],
        diff: i < macdResult.dif.length ? macdResult.dif[i] : 0,
        dea: i < macdResult.dea.length ? macdResult.dea[i] : 0,
      ));
    }

    return {
      'ma5': ma5,
      'ma10': ma10,
      'ma20': ma20,
      'ma30': ma30,
      'volumes': volumes,
      'macd': macdData,
    };
  }
}
