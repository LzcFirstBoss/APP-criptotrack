class CryptoModel {
  final String id;
  final String name;
  final String symbol;
  final double currentPrice;
  final double priceChange24h;
  final double priceChangePercentage24h;
  final String imageUrl;

  CryptoModel({
    required this.id,
    required this.name,
    required this.symbol,
    required this.currentPrice,
    required this.priceChange24h,
    required this.priceChangePercentage24h,
    required this.imageUrl,
  });

  factory CryptoModel.fromJson(Map<String, dynamic> json) {
    return CryptoModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      symbol: json['symbol'] ?? '',
      currentPrice: (json['current_price'] as num?)?.toDouble() ?? 0.0,
      priceChange24h: (json['price_change_24h'] as num?)?.toDouble() ?? 0.0,
      priceChangePercentage24h:
          (json['price_change_percentage_24h'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['image'] ?? '',
    );
  }
}
