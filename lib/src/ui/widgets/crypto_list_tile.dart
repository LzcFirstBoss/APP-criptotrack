import 'package:flutter/material.dart';
import '../../data/models/crypto_model.dart';

class CryptoListTile extends StatelessWidget {
  final CryptoModel crypto;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;
  final bool isFavorite;

  const CryptoListTile({
    super.key,
    required this.crypto,
    this.onTap,
    this.onFavoriteTap,
    this.isFavorite = false,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = crypto.priceChange24h >= 0;
    final priceChangeColor = isPositive ? Colors.greenAccent : Colors.redAccent;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFF151A2C),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            // Ícone / Avatar da cripto
          CircleAvatar(
            radius: 22,
            backgroundColor: Colors.grey[900],
            backgroundImage:
                crypto.imageUrl.isNotEmpty ? NetworkImage(crypto.imageUrl) : null,
            child: crypto.imageUrl.isEmpty
                ? Text(
                    crypto.symbol.toUpperCase().substring(0, 1),
                    style: const TextStyle(
                      color: Colors.amber,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : null,
          ),
            const SizedBox(width: 12),

            // Nome e símbolo
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    crypto.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    crypto.symbol.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            // Preço e variação
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'R\$ ${crypto.currentPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isPositive
                          ? Icons.arrow_upward_rounded
                          : Icons.arrow_downward_rounded,
                      size: 14,
                      color: priceChangeColor,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '${crypto.priceChangePercentage24h.toStringAsFixed(2)}%',
                      style: TextStyle(
                        color: priceChangeColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(width: 8),

            // Botão de Favorito (sem lógica ainda)
            IconButton(
              icon: Icon(
                isFavorite ? Icons.star_rounded : Icons.star_border_rounded,
                color: isFavorite ? Colors.amber : Colors.white54,
              ),
              onPressed: onFavoriteTap,
            ),
          ],
        ),
      ),
    );
  }
}
