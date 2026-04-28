import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  ApiService({http.Client? client}) : _client = client ?? http.Client();

  static const endpoint =
      'https://69effdd0112e1b968e251fe2.mockapi.io/api/educapais';

  final http.Client _client;

  Future<String> fetchPayload() async {
    final uri = Uri.parse(endpoint);
    final response = await _client
        .get(uri, headers: {'accept': 'application/json'})
        .timeout(const Duration(seconds: 12));

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Erro HTTP ${response.statusCode}');
    }

    return utf8.decode(response.bodyBytes);
  }
}
