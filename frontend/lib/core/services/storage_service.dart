import 'dart:convert';

import 'package:quem_e_o_impostor/core/constants/activity_demo_constants.dart';
import 'package:quem_e_o_impostor/core/constants/terminal_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quem_e_o_impostor/core/models/partida.dart';

class StorageService {
  static const String _ultimosJogadoresKey = 'ultimos_jogadores';
  static const String _historicoPartidasKey = 'historico_partidas';
  static const String _temaEscuroKey = 'tema_escuro';
  static const String _temaTerminalKey = 'tema_terminal';

  Future<void> salvarUltimosJogadores(List<String> jogadores) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_ultimosJogadoresKey, jogadores);
  }

  Future<List<String>> carregarUltimosJogadores() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_ultimosJogadoresKey) ?? <String>[];
  }

  Future<void> salvarHistorico(List<Partida> partidas) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = partidas
        .map((partida) => jsonEncode(partida.toJson()))
        .toList();
    await prefs.setStringList(_historicoPartidasKey, encoded);
  }

  Future<List<Partida>> carregarHistorico() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = prefs.getStringList(_historicoPartidasKey) ?? <String>[];
    return encoded
        .map(
          (item) => Partida.fromJson(jsonDecode(item) as Map<String, dynamic>),
        )
        .toList();
  }

  Future<void> adicionarPartidaHistorico(Partida partida) async {
    final historico = await carregarHistorico();
    historico.insert(0, partida);
    await salvarHistorico(historico);
  }

  Future<void> limparHistorico() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historicoPartidasKey);
  }

  Future<void> salvarTemaEscuro(bool temaEscuro) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_temaEscuroKey, temaEscuro);
  }

  Future<bool> carregarTemaEscuro() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_temaEscuroKey) ?? false;
  }

  Future<void> salvarTemaTerminal(TerminalThemeId id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_temaTerminalKey, TerminalThemes.serialize(id));
  }

  Future<TerminalThemeId> carregarTemaTerminal() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_temaTerminalKey);
    return TerminalThemes.parse(raw);
  }

  Future<void> salvarDemoApiLastFetchAt(DateTime value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      ActivityDemoStorageKeys.apiLastFetchAt,
      value.toIso8601String(),
    );
  }

  Future<DateTime?> carregarDemoApiLastFetchAt() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(ActivityDemoStorageKeys.apiLastFetchAt);
    if (raw == null || raw.isEmpty) {
      return null;
    }
    return DateTime.tryParse(raw);
  }

  Future<void> salvarDemoLocalNote(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(ActivityDemoStorageKeys.localNote, value);
  }

  Future<String?> carregarDemoLocalNote() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(ActivityDemoStorageKeys.localNote);
  }

  Future<void> limparDemoLocalNote() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(ActivityDemoStorageKeys.localNote);
  }
}
