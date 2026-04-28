import 'dart:convert';

class EducaPaisData {
  EducaPaisData({required this.responsavel, required this.filhos});

  final Responsavel responsavel;
  final List<Filho> filhos;

  factory EducaPaisData.fromRawJson(String rawJson) {
    final decoded = jsonDecode(rawJson);
    return EducaPaisData.fromJson(_extractRoot(decoded));
  }

  factory EducaPaisData.fromJson(Map<String, dynamic> json) {
    final filhosJson = json['filhos'] as List<dynamic>? ?? const [];
    return EducaPaisData(
      responsavel: Responsavel.fromJson(
        Map<String, dynamic>.from(json['responsavel'] as Map? ?? const {}),
      ),
      filhos: filhosJson
          .map(
            (item) => Filho.fromJson(
              Map<String, dynamic>.from(item as Map? ?? const {}),
            ),
          )
          .toList(),
    );
  }

  static Map<String, dynamic> _extractRoot(dynamic decoded) {
    if (decoded is List) {
      for (final item in decoded) {
        if (item is Map &&
            item['responsavel'] != null &&
            item['filhos'] is List) {
          return Map<String, dynamic>.from(item);
        }
      }
    }

    if (decoded is Map) {
      final map = Map<String, dynamic>.from(decoded);
      if (map['responsavel'] != null && map['filhos'] is List) {
        return map;
      }
      if (map['value'] is List) {
        return _extractRoot(map['value']);
      }
      if (map['data'] is List) {
        return _extractRoot(map['data']);
      }
    }

    throw const FormatException(
      'Nao foi possivel encontrar dados validos do responsavel e filhos.',
    );
  }
}

class Responsavel {
  Responsavel({
    required this.id,
    required this.nome,
    required this.email,
    required this.senha,
  });

  final String id;
  final String nome;
  final String email;
  final String senha;

  String get primeiroNome => nome.trim().split(' ').first;

  factory Responsavel.fromJson(Map<String, dynamic> json) {
    return Responsavel(
      id: _asString(json['id']),
      nome: _asString(json['nome']),
      email: _asString(json['email']),
      senha: _asString(json['senha']),
    );
  }
}

class Filho {
  Filho({
    required this.id,
    required this.nome,
    required this.turma,
    required this.mediaGeral,
    required this.frequenciaGeral,
    required this.faltas,
    required this.chamadasRespondidas,
    required this.totalChamadas,
    required this.disciplinas,
    required this.comunicados,
  });

  final String id;
  final String nome;
  final String turma;
  final double mediaGeral;
  final int frequenciaGeral;
  final int faltas;
  final int chamadasRespondidas;
  final int totalChamadas;
  final List<Disciplina> disciplinas;
  final List<Comunicado> comunicados;

  factory Filho.fromJson(Map<String, dynamic> json) {
    final disciplinasJson = json['disciplinas'] as List<dynamic>? ?? const [];
    final comunicadosJson = json['comunicados'] as List<dynamic>? ?? const [];
    return Filho(
      id: _asString(json['id']),
      nome: _asString(json['nome']),
      turma: _asString(json['turma']),
      mediaGeral: _asDouble(json['mediaGeral']),
      frequenciaGeral: _asInt(json['frequenciaGeral']),
      faltas: _asInt(json['faltas']),
      chamadasRespondidas: _asInt(json['chamadasRespondidas']),
      totalChamadas: _asInt(json['totalChamadas']),
      disciplinas: disciplinasJson
          .map(
            (item) => Disciplina.fromJson(
              Map<String, dynamic>.from(item as Map? ?? const {}),
            ),
          )
          .toList(),
      comunicados: comunicadosJson
          .map(
            (item) => Comunicado.fromJson(
              Map<String, dynamic>.from(item as Map? ?? const {}),
            ),
          )
          .toList(),
    );
  }
}

class Disciplina {
  Disciplina({
    required this.nome,
    required this.nota1,
    required this.nota2,
    required this.media,
    required this.frequencia,
    required this.faltas,
  });

  final String nome;
  final double nota1;
  final double nota2;
  final double media;
  final int frequencia;
  final int faltas;

  factory Disciplina.fromJson(Map<String, dynamic> json) {
    return Disciplina(
      nome: _asString(json['nome']),
      nota1: _asDouble(json['nota1']),
      nota2: _asDouble(json['nota2']),
      media: _asDouble(json['media']),
      frequencia: _asInt(json['frequencia']),
      faltas: _asInt(json['faltas']),
    );
  }
}

class Comunicado {
  Comunicado({
    required this.tipo,
    required this.titulo,
    required this.mensagem,
    required this.data,
  });

  final String tipo;
  final String titulo;
  final String mensagem;
  final DateTime? data;

  factory Comunicado.fromJson(Map<String, dynamic> json) {
    return Comunicado(
      tipo: _asString(json['tipo']),
      titulo: _asString(json['titulo']),
      mensagem: _asString(json['mensagem']),
      data: _tryParseDate(json['data']),
    );
  }
}

String _asString(dynamic value) {
  if (value == null) {
    return '';
  }
  return value.toString();
}

double _asDouble(dynamic value) {
  if (value is num) {
    return value.toDouble();
  }
  if (value is String) {
    return double.tryParse(value.replaceAll(',', '.')) ?? 0;
  }
  return 0;
}

int _asInt(dynamic value) {
  if (value is int) {
    return value;
  }
  if (value is num) {
    return value.toInt();
  }
  if (value is String) {
    return int.tryParse(value) ?? 0;
  }
  return 0;
}

DateTime? _tryParseDate(dynamic value) {
  if (value is String && value.trim().isNotEmpty) {
    return DateTime.tryParse(value);
  }
  return null;
}
