import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../controllers/session_controller.dart';
import '../models/school_data.dart';
import '../theme/app_theme.dart';
import 'tabs/boletim_tab.dart';
import 'tabs/comunicados_tab.dart';
import 'tabs/frequencia_tab.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key, required this.session});

  final SessionController session;

  @override
  Widget build(BuildContext context) {
    final filho = session.selectedFilho;
    if (filho == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final pages = [
      BoletimTab(filho: filho),
      FrequenciaTab(filho: filho),
      ComunicadosTab(filho: filho),
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _TopHeader(
              session: session,
              filho: filho,
              onRefreshPressed: session.isBusy ? null : session.refreshData,
            ),
            if (session.isOfflineData) const _OfflineBanner(),
            Expanded(
              child: IndexedStack(
                index: session.selectedTabIndex,
                children: pages,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: session.selectedTabIndex,
        onDestinationSelected: session.selectTab,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book_rounded),
            label: 'Boletim',
          ),
          NavigationDestination(
            icon: Icon(Icons.access_time_outlined),
            selectedIcon: Icon(Icons.access_time_filled_rounded),
            label: 'Frequencia',
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications_none_rounded),
            selectedIcon: Icon(Icons.notifications_rounded),
            label: 'Comunicados',
          ),
        ],
      ),
    );
  }
}

class _TopHeader extends StatelessWidget {
  const _TopHeader({
    required this.session,
    required this.filho,
    required this.onRefreshPressed,
  });

  final SessionController session;
  final Filho filho;
  final Future<void> Function()? onRefreshPressed;

  @override
  Widget build(BuildContext context) {
    final updatedAt = session.lastUpdatedAt;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
      decoration: const BoxDecoration(
        color: AppColors.primaryBlue,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(26)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ola, ${session.responsavel?.primeiroNome ?? ''}!',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Bem-vindo de volta',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onRefreshPressed == null
                    ? null
                    : () => onRefreshPressed!(),
                icon: session.isBusy
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.refresh_rounded, color: Colors.white),
                tooltip: 'Atualizar',
              ),
              IconButton(
                onPressed: session.logout,
                icon: const Icon(Icons.logout_rounded, color: Colors.white),
                tooltip: 'Sair',
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: const Color(0xFFDCE8FA),
                  child: Text(
                    filho.nome.isEmpty ? '?' : filho.nome[0].toUpperCase(),
                    style: const TextStyle(
                      color: AppColors.primaryBlue,
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
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        filho.turma,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                      if (updatedAt != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Atualizado em ${DateFormat('dd/MM HH:mm').format(updatedAt)}',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(session.filhos.length, (index) {
                final child = session.filhos[index];
                final selected = index == session.selectedChildIndex;
                return Padding(
                  padding: EdgeInsets.only(
                    right: index == session.filhos.length - 1 ? 0 : 8,
                  ),
                  child: ChoiceChip(
                    label: Text(child.nome),
                    selected: selected,
                    showCheckmark: false,
                    onSelected: (_) => session.selectChild(index),
                    selectedColor: const Color(0xFFBFD4FA),
                    backgroundColor: Colors.white.withValues(alpha: 0.18),
                    side: BorderSide(
                      color: selected ? Colors.white : Colors.white54,
                    ),
                    labelStyle: TextStyle(
                      color: selected ? AppColors.primaryBlue : Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _OfflineBanner extends StatelessWidget {
  const _OfflineBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFFCEBCF),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: const Row(
        children: [
          Icon(Icons.wifi_off_rounded, color: AppColors.warning, size: 18),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Modo offline: exibindo dados salvos localmente.',
              style: TextStyle(
                color: Color(0xFF6D5508),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
