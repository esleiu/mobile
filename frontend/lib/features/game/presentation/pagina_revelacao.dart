import 'package:flutter/material.dart';
import 'package:quem_e_o_impostor/core/constants/ativos_pixel.dart';
import 'package:quem_e_o_impostor/core/navigation/rota_pagina_app.dart';
import 'package:quem_e_o_impostor/core/services/servico_api_palavra.dart';
import 'package:quem_e_o_impostor/shared/widgets/botao_app.dart';
import 'package:quem_e_o_impostor/shared/widgets/cartao_app.dart';
import 'package:quem_e_o_impostor/shared/widgets/cartao_revelacao_flip.dart';
import 'package:quem_e_o_impostor/shared/widgets/icone_ativo_pixel.dart';
import 'package:quem_e_o_impostor/shared/widgets/avatar_jogador.dart';

import 'pagina_discussao.dart';

class RevelacaoPage extends StatefulWidget {
  final List<String> jogadores;
  final String categoria;
  final String palavraSecreta;
  final String impostor;

  const RevelacaoPage({
    super.key,
    required this.jogadores,
    required this.categoria,
    required this.palavraSecreta,
    required this.impostor,
  });

  @override
  State<RevelacaoPage> createState() => _RevelacaoPageState();
}

class _RevelacaoPageState extends State<RevelacaoPage> {
  final PalavraApiService _apiService = PalavraApiService();
  static const int _duracaoFlipMs = 380;

  int _indiceAtual = 0;
  bool _revelado = false;
  bool _transicaoEmAndamento = false;
  bool _carregandoDica = false;
  String? _dicaImpostor;

  String get _jogadorAtual => widget.jogadores[_indiceAtual];
  bool get _jogadorAtualEhImpostor => _jogadorAtual == widget.impostor;

  String get _mensagemSecreta {
    if (_jogadorAtualEhImpostor) {
      return 'Voce e o impostor';
    }
    return 'Palavra secreta: ${widget.palavraSecreta}';
  }

  double get _progresso => (_indiceAtual + 1) / widget.jogadores.length;

  void _revelar() {
    setState(() {
      _revelado = true;
      _dicaImpostor = null;
    });
  }

  Future<void> _buscarDicaImpostor() async {
    if (_carregandoDica) return;

    setState(() {
      _carregandoDica = true;
    });

    try {
      final dica = await _apiService.buscarDicaImpostor(widget.categoria);
      if (!mounted) return;
      setState(() {
        _dicaImpostor = dica;
      });
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nao foi possivel carregar a dica agora.'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _carregandoDica = false;
        });
      }
    }
  }

  Future<void> _ocultarEPassar() async {
    if (_transicaoEmAndamento) return;
    setState(() {
      _revelado = false;
      _transicaoEmAndamento = true;
      _dicaImpostor = null;
    });

    await Future<void>.delayed(
      const Duration(milliseconds: _duracaoFlipMs + 40),
    );
    if (!mounted) return;

    if (_indiceAtual == widget.jogadores.length - 1) {
      Navigator.of(context).pushReplacement(
        appPageRoute(
          DiscussaoPage(
            jogadores: widget.jogadores,
            categoria: widget.categoria,
            palavraSecreta: widget.palavraSecreta,
            impostor: widget.impostor,
          ),
        ),
      );
      return;
    }

    setState(() {
      _indiceAtual++;
      _transicaoEmAndamento = false;
    });
  }

  @override
  void dispose() {
    _apiService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Revelacao secreta')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppCard(
                margin: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      constraints: const BoxConstraints(maxWidth: 220),
                      child: _win95InfoBadge(
                        label: 'Categoria',
                        value: widget.categoria,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        PlayerAvatar(playerName: _jogadorAtual, size: 42),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Jogador atual: $_jogadorAtual',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const SizedBox(width: 52),
                        Expanded(
                          child: Text(
                            '${_indiceAtual + 1} de ${widget.jogadores.length} ja viram',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _buildWin95ProgressBar(),
                    if (_jogadorAtualEhImpostor) ...[
                      const SizedBox(height: 8),
                      const Row(
                        children: [
                          PixelAssetIcon(
                            assetPath: PixelAssets.mask,
                            size: 16,
                            color: Color(0xFFE24DAE),
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Jogador com papel de impostor',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              Expanded(
                child: FlipRevealCard(
                  key: ValueKey<String>('flip_${_indiceAtual}_$_jogadorAtual'),
                  isRevealed: _revelado,
                  title: 'Identidade do Jogador',
                  frontIcon: Icons.lock_outline,
                  backIcon: _jogadorAtualEhImpostor
                      ? Icons.warning_amber_rounded
                      : Icons.check_circle_rounded,
                  isImpostor: _jogadorAtualEhImpostor,
                  hiddenText:
                      'Passe o celular para $_jogadorAtual e toque em revelar.',
                  revealedText: _mensagemSecreta,
                ),
              ),
              const SizedBox(height: 16),
              if (_revelado && _jogadorAtualEhImpostor) ...[
                AppButton(
                  text: _carregandoDica
                      ? 'Buscando dica...'
                      : 'Mostrar dica para impostor',
                  pixelAsset: PixelAssets.chat,
                  onPressed: _carregandoDica ? null : _buscarDicaImpostor,
                ),
                if (_dicaImpostor != null) ...[
                  const SizedBox(height: 10),
                  AppCard(
                    margin: const EdgeInsets.only(bottom: 6),
                    child: Text('Dica: $_dicaImpostor'),
                  ),
                ],
                const SizedBox(height: 10),
              ],
              if (!_revelado)
                AppButton(
                  text: 'Revelar palavra',
                  pixelAsset: PixelAssets.mask,
                  onPressed: _transicaoEmAndamento ? null : _revelar,
                )
              else
                AppButton(
                  text: 'Ocultar e passar o celular',
                  pixelAsset: PixelAssets.players,
                  onPressed: _transicaoEmAndamento ? null : _ocultarEPassar,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _win95InfoBadge({required String label, required String value}) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFC0C0C0),
        border: Border(
          top: BorderSide(color: Colors.white, width: 2),
          left: BorderSide(color: Colors.white, width: 2),
          right: BorderSide(color: Colors.black, width: 2),
          bottom: BorderSide(color: Colors.black, width: 2),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.all(3),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Color(0xFF808080), width: 1),
            left: BorderSide(color: Color(0xFF808080), width: 1),
            right: BorderSide(color: Colors.white, width: 1),
            bottom: BorderSide(color: Colors.white, width: 1),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: RichText(
          text: TextSpan(
            style: const TextStyle(color: Colors.black, fontFamily: 'Courier'),
            children: [
              TextSpan(
                text: '$label: ',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              TextSpan(
                text: value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWin95ProgressBar() {
    final totalBlocos = 14;
    final ativos = (_progresso * totalBlocos).round().clamp(1, totalBlocos);

    return Container(
      height: 20,
      decoration: const BoxDecoration(
        color: Color(0xFFC0C0C0),
        border: Border(
          top: BorderSide(color: Color(0xFF808080), width: 2),
          left: BorderSide(color: Color(0xFF808080), width: 2),
          right: BorderSide(color: Colors.white, width: 2),
          bottom: BorderSide(color: Colors.white, width: 2),
        ),
      ),
      padding: const EdgeInsets.all(2),
      child: Row(
        children: List.generate(totalBlocos, (index) {
          final ativo = index < ativos;
          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 1),
              color: ativo ? const Color(0xFF000080) : Colors.transparent,
            ),
          );
        }),
      ),
    );
  }
}
