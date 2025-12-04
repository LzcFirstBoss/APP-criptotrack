import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/models/crypto_model.dart';
import '../../../data/models/user_model.dart';
import '../../../state/favorites/favorites_provider.dart';
import '../../widgets/crypto_list_tile.dart';

class FavoritesScreen extends StatefulWidget {
  final UserModel user;

  const FavoritesScreen({
    super.key,
    required this.user,
  });

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final favoritesProvider =
          Provider.of<FavoritesProvider>(context, listen: false);
      if (widget.user.id != null) {
        favoritesProvider.loadFavoritesForUser(widget.user.id!);
      }
      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = context.watch<FavoritesProvider>();
    final favorites = favoritesProvider.favorites;

    return Scaffold(
      backgroundColor: const Color(0xFF0B1020),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1020),
        elevation: 0,
        title: const Text('Favoritos'),
      ),
      body: SafeArea(
        child: favoritesProvider.isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : favorites.isEmpty
                ? const Center(
                    child: Text(
                      'Você ainda não tem criptos favoritas.',
                      style: TextStyle(color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    itemCount: favorites.length,
                    itemBuilder: (context, index) {
                      final fav = favorites[index];

                      // Converter FavoriteModel em CryptoModel
                      final crypto = CryptoModel(
                        id: fav.cryptoId,
                        name: fav.name,
                        symbol: fav.symbol,
                        currentPrice: fav.currentPrice,
                        priceChange24h: fav.priceChange24h,
                        priceChangePercentage24h: fav.priceChangePercentage24h,
                        imageUrl: fav.imageUrl,
                        marketCap: null,
                        totalVolume: null,
                        high24h: null,
                        low24h: null,
                      );
                      return CryptoListTile(
                        crypto: crypto,
                        isFavorite: true,
                        onFavoriteTap: () async {
                          await favoritesProvider.toggleFavorite(crypto);
                        },
                      );
                    },
                  ),
      ),
    );
  }
}
