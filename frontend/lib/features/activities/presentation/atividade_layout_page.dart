import 'package:flutter/material.dart';
import 'package:quem_e_o_impostor/core/constants/pixel_assets.dart';
import 'package:quem_e_o_impostor/shared/widgets/app_button.dart';
import 'package:quem_e_o_impostor/shared/widgets/app_card.dart';

class AtividadeLayoutPage extends StatelessWidget {
  const AtividadeLayoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tela de Layout')),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 600) {
              return const MobileLayout();
            }
            return const WideLayout();
          },
        ),
      ),
    );
  }
}

class MobileLayout extends StatelessWidget {
  const MobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight - 32),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              HeroSection(),
              SizedBox(height: 12),
              ComoFuncionaSection(),
              SizedBox(height: 12),
              ActionSection(vertical: true),
            ],
          ),
        ),
      ),
    );
  }
}

class WideLayout extends StatelessWidget {
  const WideLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          Expanded(flex: 4, child: HeroSection()),
          SizedBox(width: 16),
          Expanded(
            flex: 6,
            child: Column(
              children: [
                Expanded(flex: 3, child: ComoFuncionaSection()),
                SizedBox(height: 16),
                Flexible(flex: 2, child: ActionSection(vertical: false)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Quem e o Impostor?',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            'Um jogo rapido para amigos no mesmo celular.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class ComoFuncionaSection extends StatelessWidget {
  const ComoFuncionaSection({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Como funciona',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          Text('1. Cadastre os jogadores e escolha uma categoria.'),
          SizedBox(height: 8),
          Text('2. Todos recebem a palavra, menos o impostor.'),
          SizedBox(height: 8),
          Text('3. Discutam e tentem descobrir quem esta blefando.'),
        ],
      ),
    );
  }
}

class ActionSection extends StatelessWidget {
  final bool vertical;

  const ActionSection({super.key, required this.vertical});

  @override
  Widget build(BuildContext context) {
    final children = [
      AppButton(
        text: 'Nova partida',
        pixelAsset: PixelAssets.players,
        expanded: vertical,
        onPressed: () => _mostrarMensagem(context, 'Ir para nova partida'),
      ),
      AppButton(
        text: 'Historico',
        pixelAsset: PixelAssets.history,
        expanded: vertical,
        onPressed: () => _mostrarMensagem(context, 'Ir para historico'),
      ),
      AppButton(
        text: 'Configuracoes',
        pixelAsset: PixelAssets.settings,
        expanded: vertical,
        onPressed: () => _mostrarMensagem(context, 'Ir para configuracoes'),
      ),
    ];

    return AppCard(
      child: vertical
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                children[0],
                const SizedBox(height: 8),
                children[1],
                const SizedBox(height: 8),
                children[2],
              ],
            )
          : Row(
              children: [
                Expanded(child: children[0]),
                const SizedBox(width: 8),
                Expanded(child: children[1]),
                const SizedBox(width: 8),
                Expanded(child: children[2]),
              ],
            ),
    );
  }

  void _mostrarMensagem(BuildContext context, String texto) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(texto)));
  }
}
