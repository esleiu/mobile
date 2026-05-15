import 'package:flutter/material.dart';
import 'package:quem_e_o_impostor/core/constants/pixel_assets.dart';
import 'package:quem_e_o_impostor/core/models/partida.dart';
import 'package:quem_e_o_impostor/core/services/storage_service.dart';
import 'package:quem_e_o_impostor/shared/widgets/app_card.dart';
import 'package:quem_e_o_impostor/shared/widgets/arcade_chip.dart';
import 'package:quem_e_o_impostor/shared/widgets/pixel_asset_icon.dart';

class HistoricoPage extends StatefulWidget {
  const HistoricoPage({super.key});

  @override
  State<HistoricoPage> createState() => _HistoricoPageState();
}

class _HistoricoPageState extends State<HistoricoPage> {
  final StorageService _storageService = StorageService();
  List<Partida> _partidas = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarHistorico();
  }

  Future<void> _carregarHistorico() async {
    final partidas = await _storageService.carregarHistorico();
    if (!mounted) return;
    setState(() {
      _partidas = partidas;
      _carregando = false;
    });
  }

  Future<void> _limparHistorico() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Limpar historico'),
        content: const Text('Deseja remover todas as partidas salvas?'),
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

    if (confirmar != true) return;

    await _storageService.limparHistorico();
    if (!mounted) return;
    setState(() {
      _partidas.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Historico limpo com sucesso.')),
    );
  }

  String _formatarData(DateTime data) {
    final dia = data.day.toString().padLeft(2, '0');
    final mes = data.month.toString().padLeft(2, '0');
    final ano = data.year.toString();
    final hora = data.hour.toString().padLeft(2, '0');
    final minuto = data.minute.toString().padLeft(2, '0');
    return '$dia/$mes/$ano $hora:$minuto';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Historico de partidas')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: _carregando
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppCard(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: const BoxDecoration(
                              color: Color(0xFFC0C0C0),
                              border: Border(
                                top: BorderSide(color: Colors.white, width: 2),
                                left: BorderSide(color: Colors.white, width: 2),
                                bottom: BorderSide(
                                  color: Colors.black,
                                  width: 2,
                                ),
                                right: BorderSide(
                                  color: Colors.black,
                                  width: 2,
                                ),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: const PixelAssetIcon(
                              assetPath: PixelAssets.history,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              '${_partidas.length} rodada(s) salva(s)',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          if (_partidas.isNotEmpty)
                            TextButton(
                              onPressed: _limparHistorico,
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  PixelAssetIcon(
                                    assetPath: PixelAssets.delete,
                                    size: 16,
                                  ),
                                  SizedBox(width: 6),
                                  Text('Limpar'),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: _partidas.isEmpty
                          ? AppCard(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const PixelAssetIcon(
                                    assetPath: PixelAssets.history,
                                    size: 48,
                                  ),
                                  const SizedBox(height: 8),
                                  const Text('Nenhuma partida salva ainda.'),
                                ],
                              ),
                            )
                          : ListView.separated(
                              itemCount: _partidas.length,
                              separatorBuilder: (_, _) =>
                                  const SizedBox(height: 10),
                              itemBuilder: (context, index) {
                                final partida = _partidas[index];
                                return AppCard(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _formatarData(partida.data),
                                        style: Theme.of(
                                          context,
                                        ).textTheme.labelLarge,
                                      ),
                                      const SizedBox(height: 8),
                                      Wrap(
                                        spacing: 8,
                                        runSpacing: 8,
                                        children: [
                                          _Chip(
                                            assetPath: PixelAssets.category,
                                            text: partida.categoria,
                                          ),
                                          _Chip(
                                            assetPath: PixelAssets.eye,
                                            text: partida.palavra,
                                          ),
                                          _Chip(
                                            assetPath: PixelAssets.alert,
                                            text: partida.impostor,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Jogadores: ${partida.jogadores.join(', ')}',
                                      ),
                                    ],
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

class _Chip extends StatelessWidget {
  final String assetPath;
  final String text;

  const _Chip({required this.assetPath, required this.text});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 170),
      child: ArcadeChip(pixelAsset: assetPath, text: text),
    );
  }
}
