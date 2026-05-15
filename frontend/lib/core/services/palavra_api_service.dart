import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:quem_e_o_impostor/core/models/categoria.dart';
import 'package:quem_e_o_impostor/core/services/api_config.dart';

class PalavraApiService {
  final http.Client _client;

  PalavraApiService({http.Client? client}) : _client = client ?? http.Client();

  Future<List<Categoria>> buscarCategorias() async {
    final uri = Uri.parse('${ApiConfig.baseUrl}/categorias');
    final response = await _client.get(uri);

    if (response.statusCode != 200) {
      throw Exception(
        'Falha ao carregar categorias (status ${response.statusCode}).',
      );
    }

    final data = jsonDecode(response.body);
    if (data is! List) {
      throw Exception('Resposta da API invalida.');
    }

    return data
        .map<Categoria>(
          (item) => Categoria.fromJson(item as Map<String, dynamic>),
        )
        .toList();
  }

  Future<String> buscarDicaImpostor(String categoria) async {
    final uri = Uri.parse(
      '${ApiConfig.baseUrl}/dica',
    ).replace(queryParameters: {'categoria': categoria});
    final response = await _client.get(uri);

    if (response.statusCode != 200) {
      throw Exception(
        'Falha ao carregar dica para impostor (status ${response.statusCode}).',
      );
    }

    final data = jsonDecode(response.body);
    if (data is! Map<String, dynamic> || data['dica'] is! String) {
      throw Exception('Resposta de dica invalida.');
    }
    return data['dica'] as String;
  }

  void dispose() {
    _client.close();
  }
}
