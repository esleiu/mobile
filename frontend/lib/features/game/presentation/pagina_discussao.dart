import 'package:flutter/material.dart';
import 'package:quem_e_o_impostor/core/constants/ativos_pixel.dart';
import 'package:quem_e_o_impostor/core/navigation/rota_pagina_app.dart';
import 'package:quem_e_o_impostor/shared/widgets/botao_app.dart';
import 'package:quem_e_o_impostor/shared/widgets/cartao_app.dart';
import 'package:quem_e_o_impostor/shared/widgets/etiqueta_arcade.dart';
import 'package:quem_e_o_impostor/shared/widgets/icone_ativo_pixel.dart';

import 'pagina_resultado.dart';

class DiscussaoPage extends StatelessWidget {
  final List<String> jogadores;
  final String categoria;
  final String palavraSecreta;
  final String impostor;

  const DiscussaoPage({
    super.key,
    required this.jogadores,
    required this.categoria,
    required this.palavraSecreta,
    required this.impostor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Discussao')),
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
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF6E3BFF),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: const PixelAssetIcon(
                          assetPath: PixelAssets.chat,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Hora da discussao',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Todos ja receberam suas informacoes. Agora discutam para descobrir quem e o impostor.',
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ArcadeChip(
                          text: '${jogadores.length} jogadores',
                          pixelAsset: PixelAssets.players,
                        ),
                        ArcadeChip(
                          text: categoria,
                          pixelAsset: PixelAssets.category,
                        ),
                        const ArcadeChip(
                          text: 'Sem mostrar palavra',
                          pixelAsset: PixelAssets.shield,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              AppButton(
                text: 'Finalizar rodada',
                pixelAsset: PixelAssets.trophy,
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    appPageRoute(
                      ResultadoPage(
                        jogadores: jogadores,
                        categoria: categoria,
                        palavraSecreta: palavraSecreta,
                        impostor: impostor,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
