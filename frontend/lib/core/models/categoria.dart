class Categoria {
  final int id;
  final String nome;
  final List<String> palavras;

  const Categoria({
    required this.id,
    required this.nome,
    required this.palavras,
  });

  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
      id: json['id'] as int,
      nome: json['nome'] as String,
      palavras: (json['palavras'] as List<dynamic>).cast<String>(),
    );
  }
}
