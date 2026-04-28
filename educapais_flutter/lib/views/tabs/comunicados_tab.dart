import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/school_data.dart';
import '../../theme/app_theme.dart';

class ComunicadosTab extends StatelessWidget {
  const ComunicadosTab({super.key, required this.filho});

  final Filho filho;

  @override
  Widget build(BuildContext context) {
    final itens = [...filho.comunicados]
      ..sort((a, b) {
        final ad = a.data ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bd = b.data ?? DateTime.fromMillisecondsSinceEpoch(0);
        return bd.compareTo(ad);
      });

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Comunicados',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          if (itens.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: const [
                    Icon(
                      Icons.info_outline_rounded,
                      color: AppColors.textSecondary,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Nenhum comunicado para este aluno no momento.',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ...itens.map((item) => _ComunicadoCard(comunicado: item)),
        ],
      ),
    );
  }
}

class _ComunicadoCard extends StatelessWidget {
  const _ComunicadoCard({required this.comunicado});

  final Comunicado comunicado;

  @override
  Widget build(BuildContext context) {
    final dateText = comunicado.data == null
        ? '--/--/----'
        : DateFormat('dd/MM/yyyy').format(comunicado.data!);
    final style = _styleForType(comunicado.tipo);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: style.borderColor),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: style.backgroundColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(style.icon, color: style.iconColor, size: 19),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            comunicado.titulo,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        Text(
                          dateText,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      comunicado.mensagem,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      comunicado.tipo,
                      style: TextStyle(
                        color: style.iconColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
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
  }

  _ComunicadoStyle _styleForType(String type) {
    final normalized = type.toLowerCase();
    if (normalized.contains('prova')) {
      return const _ComunicadoStyle(
        icon: Icons.edit_note_rounded,
        iconColor: AppColors.warning,
        borderColor: Color(0xFFF7E7C1),
        backgroundColor: Color(0xFFFFF6E3),
      );
    }
    if (normalized.contains('reuni')) {
      return const _ComunicadoStyle(
        icon: Icons.groups_rounded,
        iconColor: AppColors.accentBlue,
        borderColor: Color(0xFFDCE8FB),
        backgroundColor: Color(0xFFEDF4FF),
      );
    }
    if (normalized.contains('aviso')) {
      return const _ComunicadoStyle(
        icon: Icons.notifications_active_rounded,
        iconColor: AppColors.danger,
        borderColor: Color(0xFFF4D7D7),
        backgroundColor: Color(0xFFFFEFEF),
      );
    }
    return const _ComunicadoStyle(
      icon: Icons.campaign_rounded,
      iconColor: AppColors.success,
      borderColor: Color(0xFFD9EDD9),
      backgroundColor: Color(0xFFECF8EC),
    );
  }
}

class _ComunicadoStyle {
  const _ComunicadoStyle({
    required this.icon,
    required this.iconColor,
    required this.borderColor,
    required this.backgroundColor,
  });

  final IconData icon;
  final Color iconColor;
  final Color borderColor;
  final Color backgroundColor;
}
