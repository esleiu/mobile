import 'package:flutter/material.dart';

import 'package:quem_e_o_impostor/core/constants/ativos_pixel.dart';
import 'package:quem_e_o_impostor/core/constants/ativos_png_pixel.dart';
import 'package:quem_e_o_impostor/core/navigation/rota_pagina_app.dart';
import 'package:quem_e_o_impostor/features/activities/presentation/pagina_atividade_api_persistencia.dart';
import 'package:quem_e_o_impostor/features/activities/presentation/pagina_atividade_eventos.dart';
import 'package:quem_e_o_impostor/features/activities/presentation/pagina_atividade_layout.dart';
import 'package:quem_e_o_impostor/features/game/presentation/pagina_jogadores.dart';
import 'package:quem_e_o_impostor/features/history/presentation/pagina_historico.dart';
import 'package:quem_e_o_impostor/features/settings/presentation/pagina_configuracoes.dart';
import 'package:quem_e_o_impostor/shared/widgets/botao_app.dart';
import 'package:quem_e_o_impostor/shared/widgets/cartao_app.dart';
import 'package:quem_e_o_impostor/shared/widgets/faixa_arcade.dart';
import 'package:quem_e_o_impostor/shared/widgets/etiqueta_arcade.dart';
import 'package:quem_e_o_impostor/shared/widgets/bolha_sprite_arcade.dart';

class HomePage extends StatelessWidget {
  final bool isDarkMode;
  final Future<void> Function(bool) onThemeChanged;

  const HomePage({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  void _abrirPagina(BuildContext context, Widget page) {
    Navigator.of(context).push(appPageRoute(page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quem e o Impostor?')),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxWidth = constraints.maxWidth < 680
                ? constraints.maxWidth
                : 680.0;

            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AppCard(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Column(
                          children: [
                            const ArcadeBanner(
                              title: 'Quem e o Impostor?',
                              iconAsset: PixelAssets.mask,
                              pngAsset: PixelPngAssets.consoleA,
                              secondaryPngAsset: PixelPngAssets.gem,
                              badgePixelAsset: PixelAssets.mask,
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Passe o celular entre jogadores e descubra quem esta blefando.',
                            ),
                            const SizedBox(height: 10),
                            const Row(
                              children: [
                                Expanded(
                                  child: ArcadeChip(
                                    pixelAsset: PixelAssets.players,
                                    text: '3+ jogadores',
                                  ),
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: ArcadeChip(
                                    pixelAsset: PixelAssets.trophy,
                                    text: 'Rodada rapida',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              alignment: WrapAlignment.center,
                              children: PixelPngAssets.showcase
                                  .map(
                                    (asset) => ArcadeSpriteBubble(
                                      assetPath: asset,
                                      size: 42,
                                    ),
                                  )
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                      AppButton(
                        text: 'Nova partida',
                        pixelAsset: PixelAssets.gamepad,
                        pngAsset: PixelPngAssets.joystick,
                        badgePixelAsset: PixelAssets.crown,
                        onPressed: () =>
                            _abrirPagina(context, const JogadoresPage()),
                      ),
                      const SizedBox(height: 10),
                      AppButton(
                        text: 'Historico',
                        pixelAsset: PixelAssets.history,
                        pngAsset: PixelPngAssets.consoleB,
                        badgePixelAsset: PixelAssets.book,
                        onPressed: () =>
                            _abrirPagina(context, const HistoricoPage()),
                      ),
                      const SizedBox(height: 10),
                      AppButton(
                        text: 'Configuracoes',
                        pixelAsset: PixelAssets.settings,
                        pngAsset: PixelPngAssets.glasses,
                        badgePixelAsset: PixelAssets.sliders,
                        onPressed: () => _abrirPagina(
                          context,
                          ConfiguracoesPage(
                            isDarkMode: isDarkMode,
                            onThemeChanged: onThemeChanged,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Exemplos da Atividade',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Demonstracoes didaticas de layout responsivo, eventos e uso de API com persistencia local.',
                            ),
                            const SizedBox(height: 10),
                            const _AtividadeInfoItem(
                              titulo: 'Layout Responsivo',
                              descricao:
                                  'Tela unica com 3 secoes, usando LayoutBuilder, Column/Row, Expanded/Flexible e espacamentos.',
                              arquivo:
                                  'lib/features/activities/presentation/pagina_atividade_layout.dart',
                            ),
                            const SizedBox(height: 8),
                            const _AtividadeInfoItem(
                              titulo: 'Tratamento de Eventos',
                              descricao:
                                  'TextField com onChanged, botoes com comportamentos diferentes, gestos e encadeamento com feedback.',
                              arquivo:
                                  'lib/features/activities/presentation/pagina_atividade_eventos.dart',
                            ),
                            const SizedBox(height: 8),
                            const _AtividadeInfoItem(
                              titulo: 'API + Persistencia Local',
                              descricao:
                                  'Consumo da API de categorias e salvamento local com SharedPreferences (salvar, carregar e limpar).',
                              arquivo:
                                  'lib/features/activities/presentation/pagina_atividade_api_persistencia.dart',
                            ),
                            const SizedBox(height: 12),
                            AppButton(
                              text: 'Tela de Layout',
                              pixelAsset: PixelAssets.category,
                              pngAsset: PixelPngAssets.island,
                              badgePixelAsset: PixelAssets.search,
                              onPressed: () => _abrirPagina(
                                context,
                                const AtividadeLayoutPage(),
                              ),
                            ),
                            const SizedBox(height: 8),
                            AppButton(
                              text: 'Tela de Eventos',
                              pixelAsset: PixelAssets.chat,
                              pngAsset: PixelPngAssets.flamingo,
                              badgePixelAsset: PixelAssets.alert,
                              onPressed: () => _abrirPagina(
                                context,
                                const AtividadeEventosPage(),
                              ),
                            ),
                            const SizedBox(height: 8),
                            AppButton(
                              text: 'Exemplo API + Persistencia',
                              pixelAsset: PixelAssets.sync,
                              pngAsset: PixelPngAssets.gem,
                              badgePixelAsset: PixelAssets.save,
                              onPressed: () => _abrirPagina(
                                context,
                                const AtividadeApiPersistenciaPage(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _AtividadeInfoItem extends StatelessWidget {
  final String titulo;
  final String descricao;
  final String arquivo;

  const _AtividadeInfoItem({
    required this.titulo,
    required this.descricao,
    required this.arquivo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: Color(0xFFE6E6E6),
        border: Border(
          top: BorderSide(color: Colors.white, width: 1),
          left: BorderSide(color: Colors.white, width: 1),
          right: BorderSide(color: Colors.black, width: 1),
          bottom: BorderSide(color: Colors.black, width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 13,
              fontFamily: 'Courier',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            descricao,
            style: const TextStyle(fontSize: 12, fontFamily: 'Courier'),
          ),
          const SizedBox(height: 4),
          Text(
            'Arquivo: $arquivo',
            style: const TextStyle(
              fontSize: 11,
              fontFamily: 'Courier',
              color: Color(0xFF333333),
            ),
          ),
        ],
      ),
    );
  }
}
