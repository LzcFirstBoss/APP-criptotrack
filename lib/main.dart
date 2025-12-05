  import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';

  import 'src/ui/screen/auth/login/login_screen.dart';
  import 'src/data/services/api/coingecko_api_service.dart';
  import 'src/state/crypto/crypto_provider.dart';
  import 'src/data/services/local/favorite_db.dart';
  import 'src/state/favorites/favorites_provider.dart';
  void main() {
    runApp(const CryptoApp());
  }

  class CryptoApp extends StatelessWidget {
    const CryptoApp({super.key});

    @override
    Widget build(BuildContext context) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => CryptoProvider(
              api: CoinGeckoApiService(),
            ),
          ),
          ChangeNotifierProvider(
            create: (_) => FavoritesProvider(
              db: FavoriteDb.instance,
            ),
          ),
        ],
        child: MaterialApp(
          title: 'CryptoTrack',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.amber,
            scaffoldBackgroundColor: const Color(0xFF0B1020),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: const Color(0xFF1E2436),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          home: const LoginScreen(),
        ),
      );
    }
  }
