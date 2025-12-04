import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/models/user_model.dart';
import '../../../state/favorites/favorites_provider.dart';

class ProfileScreen extends StatelessWidget {
  final UserModel user;

  const ProfileScreen({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = context.watch<FavoritesProvider>();
    final favoritesCount = favoritesProvider.favorites.length;

    return Scaffold(
      backgroundColor: const Color(0xFF0B1020),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1020),
        elevation: 0,
        title: const Text('Perfil'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 32,
                    backgroundColor: Color(0xFF151A2C),
                    child: Icon(
                      Icons.person_outline,
                      size: 32,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user.email,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Divider(color: Colors.white24),

              const SizedBox(height: 16),
              const Text(
                'Resumo da conta',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),

              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFF151A2C),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: Colors.amber,
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Criptos favoritas',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      favoritesCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              const Text(
                'Opções',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),

              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.info_outline, color: Colors.white70),
                title: const Text(
                  'Sobre o aplicativo',
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: const Text(
                  'App de exemplo para trabalho da faculdade',
                  style: TextStyle(color: Colors.white54, fontSize: 13),
                ),
                onTap: () {
                  showAboutDialog(
                    context: context,
                    applicationName: 'CryptoTrack',
                    applicationVersion: '1.0.0',
                    applicationIcon: const Icon(
                      Icons.currency_bitcoin,
                      color: Colors.amber,
                    ),
                    children: const [
                      Text(
                        'Aplicativo desenvolvido como trabalho acadêmico, '
                        'integrando login local, API externa (CoinGecko) e sistema de favoritos.',
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
