import 'package:flutter/material.dart';
import 'package:quem_e_o_impostor/core/services/servico_som_win95.dart';

import 'core/theme/tema_app.dart';
import 'features/home/presentation/pagina_inicial.dart';
import 'features/splash/presentation/pagina_splash_win95.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Win95SoundService.instance.prime();
  runApp(const ImpostorApp());
}

class ImpostorApp extends StatelessWidget {
  const ImpostorApp({super.key});

  Future<void> _noopThemeChange(bool _) async {}

  @override
  Widget build(BuildContext context) {
    final homePage = HomePage(
      isDarkMode: false,
      onThemeChanged: _noopThemeChange,
    );

    return MaterialApp(
      title: 'Quem e o Impostor?',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.build(Brightness.light),
      home: Win95SplashPage(nextPage: homePage),
    );
  }
}
