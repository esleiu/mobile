import 'package:flutter/material.dart';

import 'controllers/session_controller.dart';
import 'services/api_service.dart';
import 'services/data_repository.dart';
import 'services/storage_service.dart';
import 'theme/app_theme.dart';
import 'views/child_selection_page.dart';
import 'views/dashboard_page.dart';
import 'views/login_page.dart';

void main() {
  runApp(const EducaPaisApp());
}

class EducaPaisApp extends StatefulWidget {
  const EducaPaisApp({super.key});

  @override
  State<EducaPaisApp> createState() => _EducaPaisAppState();
}

class _EducaPaisAppState extends State<EducaPaisApp> {
  late final SessionController _session;

  @override
  void initState() {
    super.initState();
    _session = SessionController(
      repository: DataRepository(
        apiService: ApiService(),
        storageService: StorageService(),
      ),
    );
  }

  @override
  void dispose() {
    _session.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _session,
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'EducaPais',
          theme: buildAppTheme(),
          home: _resolveHome(),
        );
      },
    );
  }

  Widget _resolveHome() {
    if (!_session.isLoggedIn) {
      return LoginPage(session: _session);
    }
    if (_session.needsChildSelection) {
      return ChildSelectionPage(session: _session);
    }
    return DashboardPage(session: _session);
  }
}
