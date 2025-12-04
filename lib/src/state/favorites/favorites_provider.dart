import 'package:flutter/material.dart';

import '../../data/models/crypto_model.dart';
import '../../data/models/favorite_model.dart';
import '../../data/services/local/favorite_db.dart';

class FavoritesProvider extends ChangeNotifier {
  final FavoriteDb db;

  FavoritesProvider({required this.db});

  int? _currentUserId;
  List<FavoriteModel> _favorites = [];
  bool _isLoading = false;

  List<FavoriteModel> get favorites => _favorites;
  bool get isLoading => _isLoading;

  Future<void> loadFavoritesForUser(int userId) async {
    _currentUserId = userId;
    _isLoading = true;
    notifyListeners();

    _favorites = await db.getFavoritesByUser(userId);

    _isLoading = false;
    notifyListeners();
  }

  bool isFavorite(String cryptoId) {
    return _favorites.any((f) => f.cryptoId == cryptoId);
  }

  Future<void> toggleFavorite(CryptoModel crypto) async {
    if (_currentUserId == null) return;

    final userId = _currentUserId!;

    final alreadyFav = isFavorite(crypto.id);

    if (alreadyFav) {
      await db.removeFavorite(userId, crypto.id);
      _favorites.removeWhere((f) => f.cryptoId == crypto.id);
    } else {
      final fav = FavoriteModel(
        userId: userId,
        cryptoId: crypto.id,
        name: crypto.name,
        symbol: crypto.symbol,
        currentPrice: crypto.currentPrice,
        priceChange24h: crypto.priceChange24h,
        priceChangePercentage24h: crypto.priceChangePercentage24h,
        imageUrl: crypto.imageUrl,
      );
      await db.addFavorite(fav);
      _favorites.add(fav);
    }

    notifyListeners();
  }
}
