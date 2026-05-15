import 'dart:math';

import 'package:flutter/material.dart';
import 'package:quem_e_o_impostor/core/constants/pixel_assets.dart';
import 'package:quem_e_o_impostor/shared/widgets/app_button.dart';
import 'package:quem_e_o_impostor/shared/widgets/app_card.dart';

class AtividadeEventosPage extends StatefulWidget {
  const AtividadeEventosPage({super.key});

  @override
  State<AtividadeEventosPage> createState() => _AtividadeEventosPageState();
}

class _AtividadeEventosPageState extends State<AtividadeEventosPage> {
  final Random _random = Random();
  final TextEditingController _nomeController = TextEditingController();
  final List<String> _jogadores = [];
  String _nomeAtual = '';
  String? _erro;

  bool get _nomeValido => _nomeAtual.trim().length >= 3;

  void _onNomeChanged(String valor) {
    debugPrint('Texto digitado: $valor');
    setState(() {
      _nomeAtual = valor;
      _erro = valor.trim().length < 3 ? 'Digite ao menos 3 caracteres.' : null;
    });
  }

  Future<void> _adicionarJogador() async {
    if (!_nomeValido) return;
    final nome = _nomeAtual.trim();

    setState(() {
      _jogadores.add(nome);
      _nomeAtual = '';
      _erro = null;
    });
    _nomeController.clear();

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Jogador "$nome" adicionado.')));

    if (_jogadores.length == 3) {
      await showDialog<void>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Minimo atingido'),
          content: const Text(
            'Numero minimo de jogadores atingido. Voce ja pode iniciar uma partida.',
          ),
          actions: [
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Entendi'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _limparLista() async {
    if (_jogadores.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('A lista ja esta vazia.')));
      return;
    }

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Limpar lista'),
        content: const Text('Deseja remover todos os jogadores desta tela?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Limpar'),
          ),
        ],
      ),
    );

    if (!mounted || confirmar != true) return;
    setState(() => _jogadores.clear());
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Lista de jogadores limpa.')));
  }

  void _onTapCard() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Dica: use nomes curtos para agilizar a rodada.'),
      ),
    );
  }

  Future<void> _onLongPressCard() async {
    await showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Regras rapidas'),
        content: const Text(
          'Todos recebem a palavra secreta, exceto o impostor. '
          'Depois, o grupo discute para tentar descobrir quem esta blefando.',
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  void _mostrarDicaSimulada() {
    const dicas = [
      'Dica simulada: pense em algo comum da categoria, sem falar a palavra.',
      'Dica simulada: faca pergunta generica para ganhar tempo na discussao.',
      'Dica simulada: observe o que os outros descrevem e adapte sua fala.',
    ];
    final dica = dicas[_random.nextInt(dicas.length)];
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(dica)));
  }

  @override
  void dispose() {
    _nomeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tela de Eventos')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppCard(
                margin: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Cadastro rapido de jogador e teste de interacao',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Esta pagina e apenas para demonstrar eventos de interface.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _nomeController,
                      onChanged: _onNomeChanged,
                      decoration: InputDecoration(
                        labelText: 'Nome do jogador',
                        errorText: _erro,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    AppButton(
                      text: 'Adicionar jogador',
                      pixelAsset: PixelAssets.players,
                      onPressed: _nomeValido ? _adicionarJogador : null,
                    ),
                    const SizedBox(height: 8),
                    AppButton(
                      text: 'Limpar lista',
                      pixelAsset: PixelAssets.settings,
                      onPressed: _limparLista,
                    ),
                    const SizedBox(height: 8),
                    AppButton(
                      text: 'Simular dica para impostor',
                      pixelAsset: PixelAssets.chat,
                      onPressed: _mostrarDicaSimulada,
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: _onTapCard,
                onLongPress: _onLongPressCard,
                borderRadius: BorderRadius.circular(12),
                child: AppCard(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: const Text(
                    'Card interativo: toque para ver uma dica, pressione e segure para ver regras.',
                  ),
                ),
              ),
              Expanded(
                child: _jogadores.isEmpty
                    ? const Center(
                        child: Text('Nenhum jogador adicionado nesta tela.'),
                      )
                    : ListView.separated(
                        itemCount: _jogadores.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          return AppCard(
                            child: Text(
                              _jogadores[index],
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
