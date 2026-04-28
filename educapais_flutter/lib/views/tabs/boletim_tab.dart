import 'package:flutter/material.dart';

import '../../models/school_data.dart';
import '../../theme/app_theme.dart';

class BoletimTab extends StatelessWidget {
  const BoletimTab({super.key, required this.filho});

  final Filho filho;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Resumo',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Media geral',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          filho.mediaGeral
                              .toStringAsFixed(1)
                              .replaceAll('.', ','),
                          style: const TextStyle(
                            fontSize: 38,
                            fontWeight: FontWeight.w800,
                            color: AppColors.success,
                            height: 1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          filho.mediaGeral >= 7
                              ? 'Otimo desempenho'
                              : 'Atencao ao rendimento',
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _ProgressRing(
                    label: '${filho.frequenciaGeral}%',
                    progress: filho.frequenciaGeral / 100,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Card(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
              child: Column(
                children: [
                  Row(
                    children: const [
                      Text(
                        'Disciplinas',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  for (var i = 0; i < filho.disciplinas.length; i++) ...[
                    _DisciplinaRow(disciplina: filho.disciplinas[i]),
                    if (i < filho.disciplinas.length - 1)
                      const Divider(height: 10, color: Color(0xFFE7ECF3)),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF8ED),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFD4EFD9)),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Media do periodo',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.success,
                    ),
                  ),
                ),
                Text(
                  filho.mediaGeral.toStringAsFixed(1).replaceAll('.', ','),
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: AppColors.success,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DisciplinaRow extends StatelessWidget {
  const _DisciplinaRow({required this.disciplina});

  final Disciplina disciplina;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const Icon(
            Icons.menu_book_rounded,
            color: AppColors.accentBlue,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              disciplina.nome,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ),
          Text(
            disciplina.media.toStringAsFixed(1).replaceAll('.', ','),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: _notaColor(disciplina.media),
            ),
          ),
        ],
      ),
    );
  }

  Color _notaColor(double value) {
    if (value >= 8) {
      return AppColors.success;
    }
    if (value >= 7) {
      return AppColors.warning;
    }
    return AppColors.danger;
  }
}

class _ProgressRing extends StatelessWidget {
  const _ProgressRing({required this.label, required this.progress});

  final String label;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final clamped = progress.clamp(0.0, 1.0);
    return SizedBox(
      width: 106,
      height: 106,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 88,
            height: 88,
            child: CircularProgressIndicator(
              value: clamped,
              strokeWidth: 8,
              backgroundColor: const Color(0xFFE2EAF5),
              valueColor: const AlwaysStoppedAnimation(AppColors.success),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                ),
              ),
              const Text(
                'Presenca',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
