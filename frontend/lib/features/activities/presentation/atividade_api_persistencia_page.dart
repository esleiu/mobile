import 'package:flutter/material.dart';
import 'package:quem_e_o_impostor/core/constants/activity_demo_constants.dart';
import 'package:quem_e_o_impostor/core/constants/pixel_assets.dart';
import 'package:quem_e_o_impostor/core/constants/pixel_png_assets.dart';
import 'package:quem_e_o_impostor/core/models/categoria.dart';
import 'package:quem_e_o_impostor/core/services/palavra_api_service.dart';
import 'package:quem_e_o_impostor/core/services/storage_service.dart';
import 'package:quem_e_o_impostor/shared/widgets/app_button.dart';
import 'package:quem_e_o_impostor/shared/widgets/app_card.dart';
import 'package:quem_e_o_impostor/shared/widgets/arcade_sprite_bubble.dart';

class AtividadeApiPersistenciaPage extends StatefulWidget {
  const AtividadeApiPersistenciaPage({super.key});

  @override
  State<AtividadeApiPersistenciaPage> createState() =>
      _AtividadeApiPersistenciaPageState();
}

class _AtividadeApiPersistenciaPageState
    extends State<AtividadeApiPersistenciaPage> {
  final PalavraApiService _apiService = PalavraApiService();
  final StorageService _storageService = StorageService();
  final TextEditingController _noteController = TextEditingController();

  bool _isLoadingApi = false;
  String? _apiError;
  List<Categoria> _categorias = <Categoria>[];
  DateTime? _lastApiFetchAt;
  String? _savedNote;

  @override
  void initState() {
    super.initState();
    _loadPersistedDemoState();
  }

  Future<void> _loadPersistedDemoState() async {
    final savedNote = await _storageService.carregarDemoLocalNote();
    final lastApiFetchAt = await _storageService.carregarDemoApiLastFetchAt();
    if (!mounted) return;

    setState(() {
      _savedNote = savedNote;
      _lastApiFetchAt = lastApiFetchAt;
      if (savedNote != null) {
        _noteController.text = savedNote;
      }
    });
  }

  Future<void> _fetchCategorias() async {
    setState(() {
      _isLoadingApi = true;
      _apiError = null;
    });

    try {
      final categorias = await _apiService.buscarCategorias();
      final now = DateTime.now();
      await _storageService.salvarDemoApiLastFetchAt(now);
      if (!mounted) return;
      setState(() {
        _categorias = categorias;
        _lastApiFetchAt = now;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _apiError = error.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingApi = false;
        });
      }
    }
  }

  Future<void> _saveNote() async {
    final note = _noteController.text.trim();
    await _storageService.salvarDemoLocalNote(note);
    if (!mounted) return;
    setState(() => _savedNote = note);
    _showSnackBar(ActivityDemoTexts.snackbarSaved);
  }

  Future<void> _loadNote() async {
    final note = await _storageService.carregarDemoLocalNote();
    if (!mounted) return;
    setState(() {
      _savedNote = note;
      _noteController.text = note ?? '';
    });
    _showSnackBar(ActivityDemoTexts.snackbarLoaded);
  }

  Future<void> _clearNote() async {
    await _storageService.limparDemoLocalNote();
    if (!mounted) return;
    setState(() {
      _savedNote = null;
      _noteController.clear();
    });
    _showSnackBar(ActivityDemoTexts.snackbarCleared);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    _noteController.dispose();
    _apiService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(ActivityDemoTexts.pageTitle)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 600;

              if (isMobile) {
                return ListView(
                  children: [
                    _buildScopeHeader(context),
                    const SizedBox(height: 12),
                    _buildApiCard(context),
                    const SizedBox(height: 12),
                    _buildPersistenceCard(context),
                  ],
                );
              }

              return ListView(
                children: [
                  _buildScopeHeader(context),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildApiCard(context)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildPersistenceCard(context)),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildScopeHeader(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ArcadeSpriteBubble(assetPath: PixelPngAssets.consoleC, size: 40),
              ArcadeSpriteBubble(assetPath: PixelPngAssets.bag, size: 40),
              ArcadeSpriteBubble(assetPath: PixelPngAssets.gem, size: 40),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            ActivityDemoTexts.screenHeading,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            ActivityDemoTexts.screenDescription,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildApiCard(BuildContext context) {
    final categoriesWidgets = _categorias
        .map(
          (categoria) => Text(
            '- ${categoria.nome} (${categoria.palavras.length} palavras)',
          ),
        )
        .toList();

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            ActivityDemoTexts.apiCardTitle,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          const Text(ActivityDemoTexts.apiCardDescription),
          const SizedBox(height: 12),
          AppButton(
            text: ActivityDemoTexts.apiFetchButton,
            pixelAsset: PixelAssets.category,
            onPressed: _isLoadingApi ? null : _fetchCategorias,
          ),
          const SizedBox(height: 12),
          if (_isLoadingApi)
            const Text(ActivityDemoTexts.apiLoadingLabel)
          else if (_apiError != null)
            Text(
              '${ActivityDemoTexts.apiErrorPrefix} $_apiError',
              style: const TextStyle(color: Colors.redAccent),
            )
          else if (_categorias.isNotEmpty) ...[
            Text(
              '${ActivityDemoTexts.apiResultCountPrefix} ${_categorias.length}',
            ),
            const SizedBox(height: 8),
            ...categoriesWidgets,
          ],
          if (_lastApiFetchAt != null) ...[
            const SizedBox(height: 12),
            Text(
              '${ActivityDemoTexts.apiLastFetchPrefix} ${_formatDate(_lastApiFetchAt!)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPersistenceCard(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            ActivityDemoTexts.persistenceCardTitle,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          const Text(ActivityDemoTexts.persistenceCardDescription),
          const SizedBox(height: 12),
          TextField(
            controller: _noteController,
            decoration: const InputDecoration(
              labelText: ActivityDemoTexts.noteFieldLabel,
              hintText: ActivityDemoTexts.noteFieldHint,
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          AppButton(
            text: ActivityDemoTexts.saveButton,
            pixelAsset: PixelAssets.settings,
            onPressed: _saveNote,
          ),
          const SizedBox(height: 8),
          AppButton(
            text: ActivityDemoTexts.loadButton,
            pixelAsset: PixelAssets.history,
            onPressed: _loadNote,
          ),
          const SizedBox(height: 8),
          AppButton(
            text: ActivityDemoTexts.clearButton,
            pixelAsset: PixelAssets.chat,
            onPressed: _clearNote,
          ),
          const SizedBox(height: 12),
          Text(
            _savedNote == null || _savedNote!.isEmpty
                ? ActivityDemoTexts.noNoteLoaded
                : '${ActivityDemoTexts.currentNotePrefix} $_savedNote',
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime value) {
    final local = value.toLocal();
    return '${_twoDigits(local.day)}/${_twoDigits(local.month)}/${local.year} '
        '${_twoDigits(local.hour)}:${_twoDigits(local.minute)}';
  }

  String _twoDigits(int value) => value.toString().padLeft(2, '0');
}
