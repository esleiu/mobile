import 'package:flutter/material.dart';

import '../controllers/session_controller.dart';
import '../theme/app_theme.dart';

class ChildSelectionPage extends StatelessWidget {
  const ChildSelectionPage({super.key, required this.session});

  final SessionController session;

  @override
  Widget build(BuildContext context) {
    final filhos = session.filhos;
    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(20, 22, 20, 18),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Selecione o filho',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Voce pode trocar de filho depois, a qualquer momento, no topo das telas.',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.separated(
                  itemCount: filhos.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final filho = filhos[index];
                    final isSelected = session.selectedChildIndex == index;
                    return InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => session.selectChild(index),
                      child: Ink(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primaryBlue
                                : const Color(0xFFE4E9F1),
                            width: isSelected ? 1.6 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: const Color(0xFFDDE8FA),
                              child: Text(
                                filho.nome.trim().isEmpty
                                    ? '?'
                                    : filho.nome.trim()[0].toUpperCase(),
                                style: const TextStyle(
                                  color: AppColors.primaryBlue,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    filho.nome,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    filho.turma,
                                    style: const TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              isSelected
                                  ? Icons.check_circle_rounded
                                  : Icons.circle_outlined,
                              color: isSelected
                                  ? AppColors.primaryBlue
                                  : AppColors.textSecondary,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.success,
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: session.filhos.isEmpty
                    ? null
                    : () => session.confirmChildSelection(),
                child: const Text(
                  'Continuar',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
