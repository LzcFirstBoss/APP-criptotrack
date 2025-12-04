import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/models/user_model.dart';
import '../../../state/crypto/crypto_provider.dart';
import '../../widgets/crypto_list_tile.dart';
import '../../../state/favorites/favorites_provider.dart';
import '../favorites/favorites_screen.dart';
import '../profile/profile_screen.dart';
import '../coin_detail/coin_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  final UserModel user;

  const HomeScreen({
    super.key,
    required this.user,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      Provider.of<CryptoProvider>(context, listen: false).loadCryptos();

      final favoritesProvider =
          Provider.of<FavoritesProvider>(context, listen: false);

      // user.id veio do SQLite, então deve estar preenchido
      if (widget.user.id != null) {
        favoritesProvider.loadFavoritesForUser(widget.user.id!);
      }

      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {

    final cryptoProvider = context.watch<CryptoProvider>();
    final favoritesProvider = context.watch<FavoritesProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFF0B1020),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1020),
        elevation: 0,
        title: const Text('Mercado de Criptos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProfileScreen(user: widget.user),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.star_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FavoritesScreen(user: widget.user),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Cabeçalho com usuário logado
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 22,
                    backgroundColor: Color(0xFF151A2C),
                    child: Icon(
                      Icons.person_outline,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Olá, ${widget.user.name}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Acompanhe o mercado em tempo quase real',
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const Divider(
              color: Colors.white24,
              height: 1,
            ),

            Expanded(
              child: Builder(
                builder: (context) {
                  if (cryptoProvider.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (cryptoProvider.errorMessage != null) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            cryptoProvider.errorMessage!,
                            style: const TextStyle(
                              color: Colors.white70,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () {
                              cryptoProvider.loadCryptos();
                            },
                            child: const Text('Tentar novamente'),
                          ),
                        ],
                      ),
                    );
                  }

                  final cryptos = cryptoProvider.cryptos;

                  if (cryptos.isEmpty) {
                    return const Center(
                      child: Text(
                        'Nenhuma cripto encontrada.',
                        style: TextStyle(color: Colors.white70),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    itemCount: cryptos.length,
                    itemBuilder: (context, index) {
                      final crypto = cryptos[index];
                      return CryptoListTile(
                        crypto: crypto,
                        isFavorite: favoritesProvider.isFavorite(crypto.id),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CoinDetailScreen(coin: crypto),
                            ),
                          );
                        },
                        onFavoriteTap: () async {
                          await favoritesProvider.toggleFavorite(crypto);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                favoritesProvider.isFavorite(crypto.id)
                                    ? '${crypto.name} adicionada aos favoritos'
                                    : '${crypto.name} removida dos favoritos',
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
