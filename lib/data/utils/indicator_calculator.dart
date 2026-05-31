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
    final ema = List<double>.filled(closes.length, 0.0);

    if (closes.isEmpty) return ema;

    double sum = 0;
    for (int i = 0; i < closes.length; i++) {
      sum += closes[i];
      if (i < period) {
        ema[i] = sum / (i + 1);
      } else {
        ema[i] = closes[i] * k + ema[i - 1] * (1 - k);
      }
    }

    return ema;
  }

  static List<double> calculateSMA(List<double> values, int period) {
    final sma = List<double>.filled(values.length, 0.0);

    if (values.isEmpty) return sma;

    double sum = 0;
    for (int i = 0; i < values.length; i++) {
      sum += values[i];
      if (i < period) {
        sma[i] = sum / (i + 1);
      } else {
        sum -= values[i - period];
        sma[i] = sum / period;
      }
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

    final dif = List<double>.filled(data.length, 0.0);
    for (int i = 0; i < data.length; i++) {
      if (emaFast[i] != 0.0 && emaSlow[i] != 0.0) {
        dif[i] = emaFast[i] - emaSlow[i];
      }
    }

    final dea = List<double>.filled(data.length, 0.0);
    final k = 2 / (signalPeriod + 1);

    // 找到第一个非零dif作为起始点
    int startIndex = 0;
    while (startIndex < dif.length && dif[startIndex] == 0.0) {
      startIndex++;
    }

    if (startIndex + signalPeriod - 1 < dif.length) {
      // 计算初始DEA
      double sum = 0;
      for (int i = startIndex; i < startIndex + signalPeriod; i++) {
        sum += dif[i];
      }
      dea[startIndex + signalPeriod - 1] = sum / signalPeriod;

      // 继续计算后续DEA
      for (int i = startIndex + signalPeriod; i < dif.length; i++) {
        dea[i] = dif[i] * k + dea[i - 1] * (1 - k);
      }
    }

    final macd = List<double>.filled(data.length, 0.0);
    for (int i = 0; i < data.length; i++) {
      if (dea[i] != 0.0) {
        macd[i] = 2 * (dif[i] - dea[i]);
      }
    }

    return MACDResult(dif: dif, dea: dea, macd: macd);
  }

  static BollResult calculateBoll(
    List<KlineModel> data, {
    int period = 20,
    double stdDev = 2.0,
  }) {
    final closes = data.map((d) => d.close).toList();
    final mb = List<double>.filled(data.length, 0.0);
    final up = List<double>.filled(data.length, 0.0);
    final dn = List<double>.filled(data.length, 0.0);

    if (closes.length < period) {
      return BollResult(mb: mb, up: up, dn: dn);
    }

    for (int i = period - 1; i < closes.length; i++) {
      double sum = 0;
      for (int j = i - period + 1; j <= i; j++) {
        sum += closes[j];
      }
      final ma = sum / period;
      mb[i] = ma;

      double variance = 0;
      for (int j = i - period + 1; j <= i; j++) {
        variance += pow(closes[j] - ma, 2);
      }
      final md = sqrt(variance / period);

      up[i] = ma + stdDev * md;
      dn[i] = ma - stdDev * md;
    }

    return BollResult(mb: mb, up: up, dn: dn);
  }

  static KDJResult calculateKDJ(
    List<KlineModel> data, {
    int rsvPeriod = 9,
    int kPeriod = 3,
    int dPeriod = 3,
  }) {
    final k = List<double>.filled(data.length, 50.0);
    final d = List<double>.filled(data.length, 50.0);
    final j = List<double>.filled(data.length, 50.0);

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

      k[i] = currentK;
      d[i] = currentD;
      j[i] = currentJ;

      prevK = currentK;
      prevD = currentD;
    }

    return KDJResult(k: k, d: d, j: j);
  }

  static RSIResult calculateRSI(List<KlineModel> data, {int period = 14}) {
    final rsi = List<double>.filled(data.length, 50.0);
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
        rsi[i + 1] = 100;
      } else {
        final rs = avgGain / avgLoss;
        rsi[i + 1] = 100 - 100 / (1 + rs);
      }
    }

    return RSIResult(values: rsi);
  }

  static WRResult calculateWR(List<KlineModel> data, {int period = 14}) {
    final wr = List<double>.filled(data.length, -50.0);

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
        wr[i] = 0;
      } else {
        wr[i] = (highestHigh - data[i].close) / range * 100;
      }
    }

    return WRResult(values: wr);
  }

  static CCIResult calculateCCI(List<KlineModel> data, {int period = 14}) {
    final cci = List<double>.filled(data.length, 0.0);

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
        cci[i] = 0;
      } else {
        cci[i] = (tp - smaTp) / (0.015 * meanDev);
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
    final plusDI = List<double>.filled(data.length, 0.0);
    final minusDI = List<double>.filled(data.length, 0.0);
    final adxList = List<double>.filled(data.length, 0.0);

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
        plusDI[i + 1] = 0;
        minusDI[i + 1] = 0;
      } else {
        plusDI[i + 1] = smoothedPlusDM[i] / smoothedTR[i] * 100;
        minusDI[i + 1] = smoothedMinusDM[i] / smoothedTR[i] * 100;
      }
    }

    final List<double> dxList = [];
    for (int i = 0; i < data.length; i++) {
      final sum = plusDI[i] + minusDI[i];
      if (sum == 0) {
        dxList.add(0);
      } else {
        dxList.add((plusDI[i] - minusDI[i]).abs() / sum * 100);
      }
    }

    for (int i = period; i < dxList.length; i++) {
      double sumDx = 0;
      for (int j = i - period + 1; j <= i; j++) {
        sumDx += dxList[j];
      }
      adxList[i] = sumDx / period;
    }

    return DMIResult(plusDI: plusDI, minusDI: minusDI, adx: adxList);
  }

  static DMAResult calculateDMA(List<KlineModel> data,
      {int shortPeriod = 10, int longPeriod = 50, int signalPeriod = 10}) {
    final closes = data.map((d) => d.close).toList();
    final shortMA = calculateSMA(closes, shortPeriod);
    final longMA = calculateSMA(closes, longPeriod);

    final dma = List<double>.filled(data.length, 0.0);
    for (int i = 0; i < data.length; i++) {
      if (shortMA[i] != 0.0 && longMA[i] != 0.0) {
        dma[i] = shortMA[i] - longMA[i];
      }
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

    final bbi = List<double>.filled(data.length, 0.0);
    for (int i = 0; i < data.length; i++) {
      if (ma3[i] != 0.0 && ma6[i] != 0.0 && ma12[i] != 0.0 && ma20[i] != 0.0) {
        bbi[i] = (ma3[i] + ma6[i] + ma12[i] + ma20[i]) / 4;
      }
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
