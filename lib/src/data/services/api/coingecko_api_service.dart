import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../models/crypto_model.dart';

class CoinGeckoApiService {
  static const String _baseUrl = 'https://api.coingecko.com/api/v3';

  Future<List<CryptoModel>> fetchTopCryptos({
    int perPage = 50,
    String vsCurrency = 'brl',
  }) async {
    final uri = Uri.parse(
      '$_baseUrl/coins/markets'
      '?vs_currency=$vsCurrency'
      '&order=market_cap_desc'
      '&per_page=$perPage'
      '&page=1'
      '&sparkline=false'
      '&price_change_percentage=24h',
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Erro ao buscar dados (${response.statusCode})');
    }

    final List<dynamic> data = json.decode(response.body) as List<dynamic>;

    return data
        .map((item) => CryptoModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

    Future<String?> fetchCoinDescription(String id, {String lang = 'en'}) async {
    final uri = Uri.parse(
      '$_baseUrl/coins/$id?localization=$lang&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false',
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      return null;
    }

    final Map<String, dynamic> data =
        json.decode(response.body) as Map<String, dynamic>;

    final descriptionMap = data['description'] as Map<String, dynamic>?;
    if (descriptionMap == null) return null;

    final desc = descriptionMap[lang] as String? ?? '';

    if (desc.isEmpty) return null;

    // tentar pegar só o primeiro parágrafo
    final parts = desc.split(RegExp(r'\r?\n'));
    return parts.first.trim();
  }
}


