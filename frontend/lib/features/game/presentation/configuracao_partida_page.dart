import 'dart:math';

import 'package:flutter/material.dart';
import 'package:quem_e_o_impostor/core/constants/pixel_assets.dart';
import 'package:quem_e_o_impostor/core/navigation/app_page_route.dart';
import 'package:quem_e_o_impostor/core/models/categoria.dart';
import 'package:quem_e_o_impostor/core/services/palavra_api_service.dart';
import 'package:quem_e_o_impostor/shared/widgets/app_button.dart';
import 'package:quem_e_o_impostor/shared/widgets/app_card.dart';
import 'package:quem_e_o_impostor/shared/widgets/arcade_chip.dart';
import 'package:quem_e_o_impostor/shared/widgets/pixel_asset_icon.dart';

import 'revelacao_page.dart';

class ConfiguracaoPartidaPage extends StatefulWidget {
  final List<String> jogadores;

  const ConfiguracaoPartidaPage({super.key, required this.jogadores});

  @override
  State<ConfiguracaoPartidaPage> createState() =>
      _ConfiguracaoPartidaPageState();
}

class _ConfiguracaoPartidaPageState extends State<ConfiguracaoPartidaPage> {
  final PalavraApiService _apiService = PalavraApiService();
  final Random _random = Random();

  bool _carregando = true;
  String? _erro;
  List<Categoria> _categorias = [];
  Categoria? _categoriaSelecionada;

  @override
  void initState() {
    super.initState();
    _carregarCategorias();
  }

  Future<void> _carregarCategorias() async {
    setState(() {
      _carregando = true;
      _erro = null;
    });

    try {
      final categorias = await _apiService.buscarCategorias();
      if (!mounted) return;
      setState(() {
        _categorias = categorias;
        _categoriaSelecionada = categorias.isNotEmpty ? categorias.first : null;
        _carregando = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _erro = 'Nao foi possivel carregar as categorias da API.';
        _carregando = false;
      });
    }
  }

  void _sortearPartida() {
    final categoria = _categoriaSelecionada;
    if (categoria == null || categoria.palavras.isEmpty) return;

    final palavra =
        categoria.palavras[_random.nextInt(categoria.palavras.length)];
    final impostor = widget.jogadores[_random.nextInt(widget.jogadores.length)];

    Navigator.of(context).push(
      appPageRoute(
        RevelacaoPage(
          jogadores: widget.jogadores,
          categoria: categoria.nome,
          palavraSecreta: palavra,
          impostor: impostor,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _apiService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configurar partida')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: _carregando
              ? const Center(child: CircularProgressIndicator())
              : _erro != null
              ? AppCard(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _erro!,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 12),
                      AppButton(
                        text: 'Tentar novamente',
                        pixelAsset: PixelAssets.settings,
                        onPressed: _carregarCategorias,
                      ),
                    ],
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppCard(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ArcadeChip(
                            text:
                                '${widget.jogadores.length} jogadores prontos',
                            pixelAsset: PixelAssets.players,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Escolha uma categoria para a rodada',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.separated(
                        itemCount: _categorias.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final categoria = _categorias[index];
                          final selecionada =
                              _categoriaSelecionada?.id == categoria.id;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 160),
                            child: AppCard(
                              child: InkWell(
                                borderRadius: BorderRadius.circular(14),
                                onTap: () {
                                  setState(() {
                                    _categoriaSelecionada = categoria;
                                  });
                                },
                                child: Row(
                                  children: [
                                    Container(
                                      width: 42,
                                      height: 42,
                                      decoration: BoxDecoration(
                                        color: selecionada
                                            ? Theme.of(
                                                context,
                                              ).colorScheme.primary
                                            : Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                                  .withValues(alpha: 0.14),
                                        shape: BoxShape.circle,
                                      ),
                                      alignment: Alignment.center,
                                      child: PixelAssetIcon(
                                        assetPath: PixelAssets.category,
                                        color: selecionada
                                            ? Colors.white
                                            : Theme.of(
                                                context,
                                              ).colorScheme.primary,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            categoria.nome,
                                            style: Theme.of(
                                              context,
                                            ).textTheme.titleMedium,
                                          ),
                                          Text(
                                            '${categoria.palavras.length} palavras',
                                          ),
                                        ],
                                      ),
                                    ),
                                    PixelAssetIcon(
                                      assetPath: selecionada
                                          ? PixelAssets.check
                                          : PixelAssets.close,
                                      color: selecionada
                                          ? Theme.of(
                                              context,
                                            ).colorScheme.primary
                                          : Theme.of(
                                              context,
                                            ).colorScheme.outline,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    AppButton(
                      text: 'Sortear partida',
                      pixelAsset: PixelAssets.mask,
                      onPressed: _categoriaSelecionada != null
                          ? _sortearPartida
                          : null,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
