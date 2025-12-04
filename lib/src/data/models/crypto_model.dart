class CryptoModel {
  final String id;
  final String name;
  final String symbol;
  final double currentPrice;
  final double priceChange24h;
  final double priceChangePercentage24h;
  final String imageUrl;

  // Campos extras para a tela de detalhes
  final double? marketCap;
  final double? totalVolume;
  final double? high24h;
  final double? low24h;

  CryptoModel({
    required this.id,
    required this.name,
    required this.symbol,
    required this.currentPrice,
    required this.priceChange24h,
    required this.priceChangePercentage24h,
    required this.imageUrl,
    this.marketCap,
    this.totalVolume,
    this.high24h,
    this.low24h,
  });

  factory CryptoModel.fromJson(Map<String, dynamic> json) {
    double? _toDouble(dynamic v) =>
        v == null ? null : (v as num).toDouble();

    return CryptoModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      symbol: json['symbol'] ?? '',
      currentPrice: (json['current_price'] as num?)?.toDouble() ?? 0.0,
      priceChange24h: (json['price_change_24h'] as num?)?.toDouble() ?? 0.0,
      priceChangePercentage24h:
          (json['price_change_percentage_24h'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['image'] ?? '',
      marketCap: _toDouble(json['market_cap']),
      totalVolume: _toDouble(json['total_volume']),
      high24h: _toDouble(json['high_24h']),
      low24h: _toDouble(json['low_24h']),
    );
  }
}
