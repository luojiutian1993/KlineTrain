enum MarketType {
  aShare,
  hkStock,
  usStock,
  futures,
  crypto,
}

extension MarketTypeExtension on MarketType {
  String get label {
    switch (this) {
      case MarketType.aShare:
        return 'A股';
      case MarketType.hkStock:
        return '港股';
      case MarketType.usStock:
        return '美股';
      case MarketType.futures:
        return '期货';
      case MarketType.crypto:
        return '加密货币';
    }
  }

  String get code {
    switch (this) {
      case MarketType.aShare:
        return 'A';
      case MarketType.hkStock:
        return 'HK';
      case MarketType.usStock:
        return 'US';
      case MarketType.futures:
        return 'FUTURES';
      case MarketType.crypto:
        return 'CRYPTO';
    }
  }
}

class MarketSector {
  final String id;
  final String name;
  final MarketType marketType;
  final String icon;
  final String code;
  final int stockCount;
  final String? description;

  const MarketSector({
    required this.id,
    required this.name,
    required this.marketType,
    required this.icon,
    required this.code,
    this.stockCount = 0,
    this.description,
  });
}

class MarketSectors {
  MarketSectors._();

  static const List<MarketSector> allSectors = [
    MarketSector(
      id: 'a_share_kc',
      name: '科创板',
      marketType: MarketType.aShare,
      icon: '🔬',
      code: 'KC',
      description: '科技创新企业',
      stockCount: 573,
    ),
    MarketSector(
      id: 'a_share_sh',
      name: '上证',
      marketType: MarketType.aShare,
      icon: '📈',
      code: 'SH',
      description: '上海证券交易所主板',
      stockCount: 2180,
    ),
    MarketSector(
      id: 'a_share_sz',
      name: '深证',
      marketType: MarketType.aShare,
      icon: '📊',
      code: 'SZ',
      description: '深圳证券交易所主板',
      stockCount: 2840,
    ),
    MarketSector(
      id: 'a_share_cy',
      name: '创业板',
      marketType: MarketType.aShare,
      icon: '🚀',
      code: 'CY',
      description: '创业板企业',
      stockCount: 1330,
    ),
    MarketSector(
      id: 'a_share_bj',
      name: '北交所',
      marketType: MarketType.aShare,
      icon: '🏢',
      code: 'BJ',
      description: '北京证券交易所',
      stockCount: 242,
    ),
    MarketSector(
      id: 'hk_main',
      name: '港股主板',
      marketType: MarketType.hkStock,
      icon: '🇭🇰',
      code: 'HK',
      description: '香港交易所主板',
      stockCount: 2300,
    ),
    MarketSector(
      id: 'hk_gem',
      name: '港股创业板',
      marketType: MarketType.hkStock,
      icon: '💎',
      code: 'HKGEM',
      description: '香港创业板',
      stockCount: 340,
    ),
    MarketSector(
      id: 'us_nyse',
      name: '纽交所',
      marketType: MarketType.usStock,
      icon: '🗽',
      code: 'NYSE',
      description: '纽约证券交易所',
      stockCount: 2400,
    ),
    MarketSector(
      id: 'us_nasdaq',
      name: '纳斯达克',
      marketType: MarketType.usStock,
      icon: '🌐',
      code: 'NASDAQ',
      description: '纳斯达克交易所',
      stockCount: 3700,
    ),
    MarketSector(
      id: 'futures_cn',
      name: '国内期货',
      marketType: MarketType.futures,
      icon: '🌾',
      code: 'FUTURES',
      description: '上期所/大商所/郑商所/中金所',
      stockCount: 89,
    ),
    MarketSector(
      id: 'crypto_main',
      name: '主流币种',
      marketType: MarketType.crypto,
      icon: '₿',
      code: 'CRYPTO',
      description: 'BTC/ETH等主流加密货币',
      stockCount: 50,
    ),
  ];

  static Map<MarketType, List<MarketSector>> get groupedByMarket {
    final grouped = <MarketType, List<MarketSector>>{};
    for (final sector in allSectors) {
      grouped.putIfAbsent(sector.marketType, () => []).add(sector);
    }
    return grouped;
  }

  static MarketSector get defaultSector => allSectors.first;

  static MarketSector? findById(String id) {
    try {
      return allSectors.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  static MarketSector? findByCode(String code) {
    try {
      return allSectors.firstWhere((s) => s.code == code);
    } catch (_) {
      return null;
    }
  }
}
