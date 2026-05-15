import 'package:flutter/material.dart';

import 'package:quem_e_o_impostor/core/constants/pixel_assets.dart';
import 'package:quem_e_o_impostor/core/constants/pixel_png_assets.dart';
import 'package:quem_e_o_impostor/core/navigation/app_page_route.dart';
import 'package:quem_e_o_impostor/features/activities/presentation/atividade_api_persistencia_page.dart';
import 'package:quem_e_o_impostor/features/activities/presentation/atividade_eventos_page.dart';
import 'package:quem_e_o_impostor/features/activities/presentation/atividade_layout_page.dart';
import 'package:quem_e_o_impostor/features/game/presentation/jogadores_page.dart';
import 'package:quem_e_o_impostor/features/history/presentation/historico_page.dart';
import 'package:quem_e_o_impostor/features/settings/presentation/configuracoes_page.dart';
import 'package:quem_e_o_impostor/shared/widgets/app_button.dart';
import 'package:quem_e_o_impostor/shared/widgets/app_card.dart';
import 'package:quem_e_o_impostor/shared/widgets/arcade_banner.dart';
import 'package:quem_e_o_impostor/shared/widgets/arcade_chip.dart';
import 'package:quem_e_o_impostor/shared/widgets/arcade_sprite_bubble.dart';

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
