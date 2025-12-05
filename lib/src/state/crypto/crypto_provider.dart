import 'package:flutter/material.dart';

import '../../data/models/crypto_model.dart';
import '../../data/services/api/coingecko_api_service.dart';

class CryptoProvider extends ChangeNotifier {
  final CoinGeckoApiService api;

  CryptoProvider({required this.api});

  List<CryptoModel> _cryptos = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<CryptoModel> get cryptos => _cryptos;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadCryptos() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
                                                    
    try {
      _cryptos = await api.fetchTopCryptos(
        perPage: 51,
        vsCurrency: 'brl',
      );
    } catch (e) {
      _errorMessage = 'Erro ao carregar criptos. Tente novamente.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
