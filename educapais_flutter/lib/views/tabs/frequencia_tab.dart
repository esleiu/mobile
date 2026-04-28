import 'package:flutter/material.dart';

import '../../models/school_data.dart';
import '../../theme/app_theme.dart';

class FrequenciaTab extends StatelessWidget {
  const FrequenciaTab({super.key, required this.filho});

  final Filho filho;

  @override
  Widget build(BuildContext context) {
    final chamadasPercent = filho.totalChamadas == 0
        ? 0.0
        : filho.chamadasRespondidas / filho.totalChamadas;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Frequencia',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Expanded(
                    child: _SummaryStat(
                      label: 'Frequencia geral',
                      value: '${filho.frequenciaGeral}%',
                      color: AppColors.success,
                    ),
                  ),
                  Expanded(
                    child: _SummaryStat(
                      label: 'Faltas',
                      value: '${filho.faltas}',
                      color: filho.faltas >= 10
                          ? AppColors.danger
                          : AppColors.warning,
                    ),
                  ),
                  Expanded(
                    child: _SummaryStat(
                      label: 'Chamadas',
                      value:
                          '${filho.chamadasRespondidas}/${filho.totalChamadas}',
                      color: AppColors.accentBlue,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Chamadas respondidas',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      minHeight: 12,
                      value: chamadasPercent.clamp(0.0, 1.0),
                      backgroundColor: const Color(0xFFE4EAF4),
                      valueColor: const AlwaysStoppedAnimation(
                        AppColors.primaryBlue,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${(chamadasPercent * 100).toStringAsFixed(1).replaceAll('.', ',')}% de retorno das chamadas',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Frequencia por disciplina',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                  const SizedBox(height: 6),
                  for (var i = 0; i < filho.disciplinas.length; i++) ...[
                    _FrequencyRow(disciplina: filho.disciplinas[i]),
                    if (i < filho.disciplinas.length - 1)
                      const Divider(height: 12, color: Color(0xFFE6ECF4)),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryStat extends StatelessWidget {
  const _SummaryStat({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w800,
            fontSize: 24,
            height: 1,
          ),
        ),
      ],
    );
  }
}

class _FrequencyRow extends StatelessWidget {
  const _FrequencyRow({required this.disciplina});

  final Disciplina disciplina;

  @override
  Widget build(BuildContext context) {
    final progress = (disciplina.frequencia / 100).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                disciplina.nome,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            Text(
              '${disciplina.frequencia}%',
              style: TextStyle(
                color: disciplina.frequencia >= 90
                    ? AppColors.success
                    : AppColors.warning,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Faltas: ${disciplina.faltas}',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            minHeight: 8,
            value: progress,
            backgroundColor: const Color(0xFFE4EAF4),
            valueColor: AlwaysStoppedAnimation(
              disciplina.frequencia >= 90
                  ? AppColors.success
                  : AppColors.warning,
            ),
          ),
        ),
      ],
    );
  }
}
