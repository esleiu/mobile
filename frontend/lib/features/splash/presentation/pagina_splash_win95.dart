import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quem_e_o_impostor/core/constants/ativos_win95.dart';
import 'package:quem_e_o_impostor/core/navigation/rota_pagina_app.dart';
import 'package:quem_e_o_impostor/core/services/servico_som_win95.dart';

class Win95SplashPage extends StatefulWidget {
  final Widget nextPage;

  const Win95SplashPage({super.key, required this.nextPage});

  @override
  State<Win95SplashPage> createState() => _Win95SplashPageState();
}

class _Win95SplashPageState extends State<Win95SplashPage> {
  static const int _maxSteps = 24;
  int _step = 0;
  Timer? _timer;
  bool _navegou = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Win95SoundService.instance.playStartup();
    });
    _timer = Timer.periodic(const Duration(milliseconds: 115), (timer) {
      if (!mounted) return;
      setState(() {
        _step = (_step + 1).clamp(0, _maxSteps);
      });
      if (_step >= _maxSteps) {
        timer.cancel();
        _abrirHome();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _abrirHome() {
    if (_navegou || !mounted) return;
    _navegou = true;
    Navigator.of(context).pushReplacement(appPageRoute(widget.nextPage));
  }

  @override
  Widget build(BuildContext context) {
    final progresso = _step / _maxSteps;
    return Scaffold(
      backgroundColor: const Color(0xFF008080),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFC0C0C0),
                  border: Border(
                    top: BorderSide(color: Colors.white, width: 2),
                    left: BorderSide(color: Colors.white, width: 2),
                    bottom: BorderSide(color: Colors.black, width: 2),
                    right: BorderSide(color: Colors.black, width: 2),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      color: const Color(0xFF000080),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 5,
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            Win95Assets.computer,
                            width: 16,
                            height: 16,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Text(
                              'Inicializando IMPOSTOR_OS 95',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            width: 18,
                            height: 18,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              color: Color(0xFFC0C0C0),
                              border: Border(
                                top: BorderSide(color: Colors.white, width: 1),
                                left: BorderSide(color: Colors.white, width: 1),
                                bottom: BorderSide(
                                  color: Colors.black,
                                  width: 1,
                                ),
                                right: BorderSide(
                                  color: Colors.black,
                                  width: 1,
                                ),
                              ),
                            ),
                            child: const Text(
                              'x',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                Win95Assets.hourglass,
                                width: 34,
                                height: 34,
                              ),
                              const SizedBox(width: 10),
                              const Expanded(
                                child: Text(
                                  'Carregando modulos do jogo...',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Container(
                            height: 24,
                            padding: const EdgeInsets.all(3),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              border: Border(
                                top: BorderSide(
                                  color: Color(0xFF808080),
                                  width: 2,
                                ),
                                left: BorderSide(
                                  color: Color(0xFF808080),
                                  width: 2,
                                ),
                                bottom: BorderSide(
                                  color: Colors.white,
                                  width: 2,
                                ),
                                right: BorderSide(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                            ),
                            child: Row(
                              children: List.generate(16, (index) {
                                final ativo = index < (progresso * 16).ceil();
                                return Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 1,
                                    ),
                                    color: ativo
                                        ? const Color(0xFF000080)
                                        : Colors.transparent,
                                  ),
                                );
                              }),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '${(progresso * 100).round()}% concluido',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
