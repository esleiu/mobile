import 'package:flutter/material.dart';
import 'package:quem_e_o_impostor/core/constants/pixel_assets.dart';
import 'package:quem_e_o_impostor/core/constants/terminal_theme.dart';
import 'package:quem_e_o_impostor/core/services/storage_service.dart';
import 'package:quem_e_o_impostor/core/services/win95_sound_service.dart';
import 'package:quem_e_o_impostor/shared/widgets/app_button.dart';
import 'package:quem_e_o_impostor/shared/widgets/app_card.dart';
import 'package:quem_e_o_impostor/shared/widgets/arcade_chip.dart';

class ConfiguracoesPage extends StatefulWidget {
  final bool isDarkMode;
  final Future<void> Function(bool) onThemeChanged;

  const ConfiguracoesPage({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<ConfiguracoesPage> createState() => _ConfiguracoesPageState();
}

class _ConfiguracoesPageState extends State<ConfiguracoesPage> {
  final StorageService _storageService = StorageService();
  bool _carregando = true;
  TerminalThemeId _temaTerminal = TerminalThemeId.classicGreen;

  @override
  void initState() {
    super.initState();
    _carregarConfiguracoes();
  }

  Future<void> _carregarConfiguracoes() async {
    final tema = await _storageService.carregarTemaTerminal();
    if (!mounted) return;
    setState(() {
      _temaTerminal = tema;
      _carregando = false;
    });
  }

  Future<void> _reaplicarTemaClassico(BuildContext context) async {
    await widget.onThemeChanged(false);
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Tema classico reaplicado.')));
  }

  Future<void> _aplicarTemaTerminal(TerminalThemeId id) async {
    if (_temaTerminal == id) return;
    await _storageService.salvarTemaTerminal(id);
    if (!mounted) return;
    setState(() {
      _temaTerminal = id;
    });
    Win95SoundService.instance.playClick();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Tema do terminal salvo. Abra a tela de jogadores para ver.',
        ),
      ),
    );
  }

  Future<void> _testarSons(BuildContext context) async {
    await Win95SoundService.instance.debugTestAll();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Teste de som executado (click/alert/startup).'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_carregando) {
      return Scaffold(
        appBar: AppBar(title: const Text('Configuracoes')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final temaAtual = TerminalThemes.byId(_temaTerminal);

    return Scaffold(
      appBar: AppBar(title: const Text('Configuracoes')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              AppCard(
                margin: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tema Classico do App',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'As telas gerais continuam em estilo Windows 95 fixo.',
                    ),
                    const SizedBox(height: 10),
                    const ArcadeChip(
                      text: 'Visual retro habilitado',
                      pixelAsset: PixelAssets.settings,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.isDarkMode
                          ? 'Preferencia antiga: escuro (ignorada no visual Win95).'
                          : 'Preferencia antiga: claro (ignorada no visual Win95).',
                    ),
                    const SizedBox(height: 10),
                    FilledButton(
                      onPressed: () => _reaplicarTemaClassico(context),
                      child: const Text('Reaplicar tema classico'),
                    ),
                  ],
                ),
              ),
              AppCard(
                margin: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tema do Terminal (so Jogadores)',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Esta escolha afeta somente a tela terminal de cadastro de jogadores.',
                    ),
                    const SizedBox(height: 12),
                    ...TerminalThemes.all.map((tema) {
                      final selecionado = tema.id == _temaTerminal;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFC0C0C0),
                            border: Border(
                              top: BorderSide(
                                color: selecionado
                                    ? Colors.black
                                    : Colors.white,
                                width: 2,
                              ),
                              left: BorderSide(
                                color: selecionado
                                    ? Colors.black
                                    : Colors.white,
                                width: 2,
                              ),
                              right: BorderSide(
                                color: selecionado
                                    ? Colors.white
                                    : Colors.black,
                                width: 2,
                              ),
                              bottom: BorderSide(
                                color: selecionado
                                    ? Colors.white
                                    : Colors.black,
                                width: 2,
                              ),
                            ),
                          ),
                          child: ListTile(
                            onTap: () => _aplicarTemaTerminal(tema.id),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            title: Text(
                              tema.label,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 3),
                                Text(tema.description),
                                const SizedBox(height: 6),
                                Container(
                                  height: 26,
                                  decoration: BoxDecoration(
                                    color: tema.background,
                                    border: Border.all(
                                      color: tema.border,
                                      width: 1,
                                    ),
                                  ),
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  child: Text(
                                    '> IMPOSTOR_OS READY',
                                    style: TextStyle(
                                      color: tema.primaryText,
                                      fontFamily: 'Courier',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            trailing: Icon(
                              selecionado
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_unchecked,
                            ),
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 4),
                    Text(
                      'Tema atual: ${temaAtual.label}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              AppButton(
                text: 'Testar sons do Windows',
                pixelAsset: PixelAssets.sync,
                onPressed: () => _testarSons(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
