import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/models/crypto_model.dart';
import '../../../state/crypto/crypto_provider.dart';
import '../../../state/favorites/favorites_provider.dart';

class CoinDetailScreen extends StatefulWidget {
  final CryptoModel coin;

  const CoinDetailScreen({
    super.key,
    required this.coin,
  });

  @override
  State<CoinDetailScreen> createState() => _CoinDetailScreenState();
}

class _CoinDetailScreenState extends State<CoinDetailScreen> {
  String? _description;
  bool _isLoadingDescription = false;

  @override
  void initState() {
    super.initState();
    _loadDescription();
  }

  Future<void> _loadDescription() async {
    setState(() {
      _isLoadingDescription = true;
    });

    try {
      final cryptoProvider =
          Provider.of<CryptoProvider>(context, listen: false);
      final desc = await cryptoProvider.api.fetchCoinDescription(widget.coin.id);
      setState(() {
        _description = desc;
      });
    } catch (_) {
      // se der erro, simplesmente não mostra descrição
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingDescription = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = context.watch<FavoritesProvider>();
    final isFavorite = favoritesProvider.isFavorite(widget.coin.id);

    final isPositive = widget.coin.priceChange24h >= 0;
    final priceChangeColor =
        isPositive ? Colors.greenAccent : Colors.redAccent;

    return Scaffold(
      backgroundColor: const Color(0xFF0B1020),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1020),
        elevation: 0,
        title: Text(widget.coin.name),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.star_rounded : Icons.star_border_rounded,
              color: isFavorite ? Colors.amber : Colors.white70,
            ),
            onPressed: () async {
              await favoritesProvider.toggleFavorite(widget.coin);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    favoritesProvider.isFavorite(widget.coin.id)
                        ? '${widget.coin.name} adicionada aos favoritos'
                        : '${widget.coin.name} removida dos favoritos',
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cabeçalho da moeda
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey[900],
                    backgroundImage: widget.coin.imageUrl.isNotEmpty
                        ? NetworkImage(widget.coin.imageUrl)
                        : null,
                    child: widget.coin.imageUrl.isEmpty
                        ? Text(
                            widget.coin.symbol.toUpperCase().substring(0, 1),
                            style: const TextStyle(
                              color: Colors.amber,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.coin.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.coin.symbol.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Card de preço
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                decoration: BoxDecoration(
                  color: const Color(0xFF151A2C),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Preço atual',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'R\$ ${widget.coin.currentPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'Variação 24h',
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isPositive
                                  ? Icons.arrow_upward_rounded
                                  : Icons.arrow_downward_rounded,
                              size: 18,
                              color: priceChangeColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${widget.coin.priceChangePercentage24h.toStringAsFixed(2)}%',
                              style: TextStyle(
                                color: priceChangeColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'Descrição',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),

              if (_isLoadingDescription)
                const Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (_description == null || _description!.isEmpty)
                const Text(
                  'Nenhuma descrição disponível para esta moeda.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                )
              else
                Text(
                  _description!,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
