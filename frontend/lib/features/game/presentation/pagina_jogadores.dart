import 'package:flutter/material.dart';
import 'package:quem_e_o_impostor/core/constants/tema_terminal.dart';
import 'package:quem_e_o_impostor/core/navigation/rota_pagina_app.dart';
import 'package:quem_e_o_impostor/core/services/servico_armazenamento.dart';
import 'package:quem_e_o_impostor/core/services/servico_som_win95.dart';

import 'pagina_configuracao_partida.dart';

class JogadoresPage extends StatefulWidget {
  const JogadoresPage({super.key});

  @override
  State<JogadoresPage> createState() => _JogadoresPageState();
}

class _JogadoresPageState extends State<JogadoresPage> {
  final StorageService _storageService = StorageService();
  final TextEditingController _nomeController = TextEditingController();
  final List<String> _jogadores = <String>[];

  bool _carregando = true;
  bool _iniciandoPartida = false;
  int _frameCarregamento = 0;
  String _nomeAtual = '';
  TerminalThemePalette _temaTerminal = TerminalThemes.classicGreen;

  TextStyle get _textoTerminal => TextStyle(
    color: _temaTerminal.primaryText,
    fontFamily: 'Courier',
    fontSize: 15,
    fontWeight: FontWeight.bold,
  );

  @override
  void initState() {
    super.initState();
    _carregarDadosIniciais();
  }

  Future<void> _carregarDadosIniciais() async {
    final resultados = await Future.wait<dynamic>([
      _storageService.carregarUltimosJogadores(),
      _storageService.carregarTemaTerminal(),
    ]);

    if (!mounted) return;

    final jogadores = (resultados[0] as List<String>)
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList(growable: false);
    final temaId = resultados[1] as TerminalThemeId;

    setState(() {
      _jogadores
        ..clear()
        ..addAll(jogadores);
      _temaTerminal = TerminalThemes.byId(temaId);
      _carregando = false;
    });
  }

  Future<void> _salvarJogadores() async {
    await _storageService.salvarUltimosJogadores(_jogadores);
  }

  bool get _nomeValido => _nomeAtual.trim().length >= 3;

  Future<void> _adicionarJogador() async {
    if (_iniciandoPartida) return;
    final nome = _nomeAtual.trim();
    if (nome.length < 3) {
      _mostrarMensagem('Nome precisa ter pelo menos 3 caracteres.');
      return;
    }
    if (_jogadores.length >= 12) {
      _mostrarMensagem('Limite de 12 jogadores atingido.');
      return;
    }
    final duplicado = _jogadores.any(
      (jogador) => jogador.toLowerCase() == nome.toLowerCase(),
    );
    if (duplicado) {
      _mostrarMensagem('Este nome ja foi adicionado.');
      return;
    }

    setState(() {
      _jogadores.add(nome);
      _nomeAtual = '';
      _nomeController.clear();
    });
    await _salvarJogadores();
    _mostrarMensagem('Jogador "$nome" adicionado.');
  }

  Future<void> _removerJogador(String nome) async {
    if (_iniciandoPartida) return;
    setState(() {
      _jogadores.remove(nome);
    });
    await _salvarJogadores();
    _mostrarMensagem('Jogador "$nome" removido.');
  }

  Future<void> _limparJogadores() async {
    if (_iniciandoPartida) return;
    if (_jogadores.isEmpty) {
      _mostrarMensagem('A lista ja esta vazia.');
      return;
    }
    setState(() {
      _jogadores.clear();
    });
    await _salvarJogadores();
    _mostrarMensagem('Lista de jogadores limpa.');
  }

  Future<void> _iniciarPartida() async {
    if (_iniciandoPartida) return;
    if (_jogadores.length < 3) {
      _mostrarMensagem('Adicione no minimo 3 jogadores para iniciar.');
      return;
    }
    setState(() {
      _iniciandoPartida = true;
      _frameCarregamento = 0;
    });

    for (var i = 0; i < 10; i++) {
      await Future<void>.delayed(const Duration(milliseconds: 400));
      if (!mounted) return;
      setState(() {
        _frameCarregamento = (_frameCarregamento + 1) % 3;
      });
    }
    if (!mounted) return;
    Navigator.of(context).push(
      appPageRoute(
        ConfiguracaoPartidaPage(jogadores: List<String>.from(_jogadores)),
      ),
    );
    if (!mounted) return;
    setState(() {
      _iniciandoPartida = false;
    });
  }

  void _mostrarMensagem(String texto) {
    if (!mounted) return;
    if (texto.toUpperCase().contains('MINIMO') ||
        texto.toUpperCase().contains('LIMITE') ||
        texto.toUpperCase().contains('JA')) {
      Win95SoundService.instance.playAlert();
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(texto), duration: const Duration(seconds: 2)),
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
    super.dispose();
  }

  Widget _linhaTerminal(String texto, {Color? cor}) {
    return Text(
      texto,
      style: _textoTerminal.copyWith(color: cor ?? _temaTerminal.primaryText),
    );
  }

  String get _mensagemCarregandoTerminal {
    const dots = ['.', '..', '...'];
    return 'INICIANDO PARTIDA ${dots[_frameCarregamento]}';
  }

  Widget _botaoTerminal({
    required String titulo,
    required VoidCallback? onTap,
    bool destaque = false,
  }) {
    final cor = destaque
        ? _temaTerminal.primaryText
        : _temaTerminal.secondaryText;
    return InkWell(
      onTap: onTap == null
          ? null
          : () {
              Win95SoundService.instance.playClick();
              onTap();
            },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: cor, width: 1),
          color: _temaTerminal.background,
        ),
        child: Text(
          titulo.toUpperCase(),
          textAlign: TextAlign.center,
          style: _textoTerminal.copyWith(
            color: onTap == null ? _temaTerminal.secondaryText : cor,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _temaTerminal.background,
      appBar: AppBar(
        backgroundColor: _temaTerminal.background,
        title: Text(
          'Cadastro de Jogadores',
          style: TextStyle(
            color: _temaTerminal.primaryText,
            fontFamily: 'Courier',
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: _temaTerminal.primaryText),
      ),
      body: SafeArea(
        child: _carregando
            ? Center(
                child: CircularProgressIndicator(
                  color: _temaTerminal.primaryText,
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _linhaTerminal('SISTEMA PRONTO.\n'),
                    _linhaTerminal(
                      'JOGADORES: ${_jogadores.length}/12    PRONTO: ${_jogadores.length >= 3 ? 'SIM' : 'NAO'}',
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _temaTerminal.border,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          _linhaTerminal('> '),
                          Expanded(
                            child: TextField(
                              controller: _nomeController,
                              onChanged: (value) {
                                setState(() {
                                  _nomeAtual = value;
                                });
                              },
                              style: _textoTerminal,
                              cursorColor: _temaTerminal.cursor,
                              textInputAction: TextInputAction.done,
                              onSubmitted: (_) => _adicionarJogador(),
                              decoration: InputDecoration(
                                isDense: true,
                                hintText: 'Digite o nome',
                                hintStyle: TextStyle(
                                  color: _temaTerminal.secondaryText,
                                  fontFamily: 'Courier',
                                ),
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                filled: true,
                                fillColor: _temaTerminal.background,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            width: 92,
                            child: _botaoTerminal(
                              titulo: 'Adicionar',
                              onTap: _nomeValido && !_iniciandoPartida
                                  ? _adicionarJogador
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: _botaoTerminal(
                            titulo: 'Iniciar jogo',
                            destaque: true,
                            onTap: _jogadores.length >= 3 && !_iniciandoPartida
                                ? _iniciarPartida
                                : null,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _botaoTerminal(
                            titulo: 'Limpar lista',
                            onTap: _jogadores.isEmpty || _iniciandoPartida
                                ? null
                                : _limparJogadores,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _linhaTerminal('--- USUARIOS CONECTADOS ---'),
                    const SizedBox(height: 4),
                    Expanded(
                      child: _jogadores.isEmpty
                          ? Align(
                              alignment: Alignment.topLeft,
                              child: _linhaTerminal(
                                'Nenhum jogador cadastrado.',
                                cor: _temaTerminal.secondaryText,
                              ),
                            )
                          : ListView.separated(
                              itemCount: _jogadores.length,
                              separatorBuilder: (_, _) =>
                                  const SizedBox(height: 6),
                              itemBuilder: (context, index) {
                                final jogador = _jogadores[index];
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: _temaTerminal.border,
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: _linhaTerminal(
                                          '[${index + 1}] ${jogador.toUpperCase()}',
                                        ),
                                      ),
                                      _botaoTerminal(
                                        titulo: 'Excluir',
                                        onTap: _iniciandoPartida
                                            ? null
                                            : () => _removerJogador(jogador),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
                    const SizedBox(height: 6),
                    _linhaTerminal(
                      'Toque em EXCLUIR para remover um jogador.',
                      cor: _temaTerminal.secondaryText,
                    ),
                    if (_iniciandoPartida) ...[
                      const SizedBox(height: 6),
                      _linhaTerminal(
                        _mensagemCarregandoTerminal,
                        cor: _temaTerminal.primaryText,
                      ),
                    ],
                  ],
                ),
              ),
      ),
    );
  }
}
