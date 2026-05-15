import 'package:flutter/material.dart';
import 'package:quem_e_o_impostor/core/constants/pixel_assets.dart';
import 'package:quem_e_o_impostor/core/constants/pixel_png_assets.dart';
import 'package:quem_e_o_impostor/core/models/partida.dart';
import 'package:quem_e_o_impostor/core/navigation/app_page_route.dart';
import 'package:quem_e_o_impostor/core/services/storage_service.dart';
import 'package:quem_e_o_impostor/shared/widgets/app_button.dart';
import 'package:quem_e_o_impostor/shared/widgets/app_card.dart';
import 'package:quem_e_o_impostor/shared/widgets/arcade_banner.dart';
import 'package:quem_e_o_impostor/shared/widgets/player_avatar.dart';

import 'configuracao_partida_page.dart';
import 'jogadores_page.dart';

class ResultadoPage extends StatefulWidget {
  final List<String> jogadores;
  final String categoria;
  final String palavraSecreta;
  final String impostor;

  const ResultadoPage({
    super.key,
    required this.jogadores,
    required this.categoria,
    required this.palavraSecreta,
    required this.impostor,
  });

  @override
  State<ResultadoPage> createState() => _ResultadoPageState();
}

class _ResultadoPageState extends State<ResultadoPage> {
  final StorageService _storageService = StorageService();
  bool _salvouNoHistorico = false;

  @override
  void initState() {
    super.initState();
    _salvarPartida();
  }

  Future<void> _salvarPartida() async {
    if (_salvouNoHistorico) return;
    _salvouNoHistorico = true;

    final partida = Partida(
      jogadores: widget.jogadores,
      categoria: widget.categoria,
      palavra: widget.palavraSecreta,
      impostor: widget.impostor,
      data: DateTime.now(),
    );
    await _storageService.adicionarPartidaHistorico(partida);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resultado')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppCard(
                  margin: const EdgeInsets.only(bottom: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: double.infinity,
                        child: ArcadeBanner(
                          title: 'Fim da rodada',
                          iconAsset: PixelAssets.trophy,
                          pngAsset: PixelPngAssets.gem,
                          secondaryPngAsset: PixelPngAssets.consoleA,
                          badgePixelAsset: PixelAssets.crown,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          PlayerAvatar(playerName: widget.impostor, size: 46),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Impostor: ${widget.impostor}',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: _InfoBox(
                              label: 'Categoria',
                              value: widget.categoria,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _InfoBox(
                              label: 'Palavra',
                              value: widget.palavraSecreta,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: widget.jogadores
                            .map(
                              (nome) => Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  PlayerAvatar(playerName: nome, size: 34),
                                  const SizedBox(height: 2),
                                  SizedBox(
                                    width: 56,
                                    child: Text(
                                      nome,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 11),
                                    ),
                                  ),
                                ],
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
                AppButton(
                  text: 'Jogar novamente com os mesmos jogadores',
                  pixelAsset: PixelAssets.category,
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      appPageRoute(
                        ConfiguracaoPartidaPage(jogadores: widget.jogadores),
                      ),
                      (route) => route.isFirst,
                    );
                  },
                ),
                const SizedBox(height: 10),
                AppButton(
                  text: 'Nova partida',
                  pixelAsset: PixelAssets.players,
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      appPageRoute(const JogadoresPage()),
                      (route) => route.isFirst,
                    );
                  },
                ),
                const SizedBox(height: 10),
                AppButton(
                  text: 'Voltar ao inicio',
                  pixelAsset: PixelAssets.mask,
                  onPressed: () =>
                      Navigator.of(context).popUntil((route) => route.isFirst),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  final String label;
  final String value;

  const _InfoBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  fontFamily: 'Courier',
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 14,
                  fontFamily: 'Courier',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
