class Partida {
  final List<String> jogadores;
  final String categoria;
  final String palavra;
  final String impostor;
  final DateTime data;

  const Partida({
    required this.jogadores,
    required this.categoria,
    required this.palavra,
    required this.impostor,
    required this.data,
  });

  Map<String, dynamic> toJson() {
    return {
      'jogadores': jogadores,
      'categoria': categoria,
      'palavra': palavra,
      'impostor': impostor,
      'data': data.toIso8601String(),
    };
  }

  factory Partida.fromJson(Map<String, dynamic> json) {
    return Partida(
      jogadores: (json['jogadores'] as List<dynamic>).cast<String>(),
      categoria: json['categoria'] as String,
      palavra: json['palavra'] as String,
      impostor: json['impostor'] as String,
      data: DateTime.parse(json['data'] as String),
    );
  }
}
