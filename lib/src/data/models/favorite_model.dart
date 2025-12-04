class FavoriteModel {
  final int? id;
  final int userId;
  final String cryptoId;
  final String name;
  final String symbol;
  final double currentPrice;
  final double priceChange24h;
  final double priceChangePercentage24h;
  final String imageUrl;

  FavoriteModel({
    this.id,
    required this.userId,
    required this.cryptoId,
    required this.name,
    required this.symbol,
    required this.currentPrice,
    required this.priceChange24h,
    required this.priceChangePercentage24h,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'crypto_id': cryptoId,
      'name': name,
      'symbol': symbol,
      'current_price': currentPrice,
      'price_change_24h': priceChange24h,
      'price_change_percentage_24h': priceChangePercentage24h,
      'image_url': imageUrl,
    };
  }

  factory FavoriteModel.fromMap(Map<String, dynamic> map) {
    return FavoriteModel(
      id: map['id'] as int?,
      userId: map['user_id'] as int,
      cryptoId: map['crypto_id'] as String,
      name: map['name'] as String,
      symbol: map['symbol'] as String,
      currentPrice: (map['current_price'] as num).toDouble(),
      priceChange24h: (map['price_change_24h'] as num).toDouble(),
      priceChangePercentage24h:
          (map['price_change_percentage_24h'] as num).toDouble(),
      imageUrl: map['image_url'] as String,
    );
  }
}
