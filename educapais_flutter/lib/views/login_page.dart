import 'package:flutter/material.dart';

import '../controllers/session_controller.dart';
import '../theme/app_theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.session});

  final SessionController session;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController(text: 'pai@email.com');
  final _passwordController = TextEditingController(text: '123456');
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlue,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 22),
                  const _LogoArea(),
                  const SizedBox(height: 28),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: 'E-mail ou CPF',
                      prefixIcon: Icon(Icons.person_outline_rounded),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      hintText: 'Senha',
                      prefixIcon: const Icon(Icons.lock_outline_rounded),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 48,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.success,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: widget.session.isBusy ? null : _onLoginPressed,
                      child: widget.session.isBusy
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.4,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Entrar',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Esqueci minha senha',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  const SizedBox(height: 48),
                  const Text(
                    'Nao tem conta? Fale com a escola.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onLoginPressed() async {
    final isValid = await widget.session.login(
      email: _emailController.text,
      password: _passwordController.text,
    );
    if (!mounted || isValid) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(widget.session.errorMessage ?? 'Falha no login')),
    );
  }
}

class _LogoArea extends StatelessWidget {
  const _LogoArea();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 104,
          height: 104,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white24),
          ),
          child: const Icon(
            Icons.school_rounded,
            color: Colors.white,
            size: 54,
          ),
        ),
        const SizedBox(height: 14),
        const Text(
          'EducaPais',
          style: TextStyle(
            color: Colors.white,
            fontSize: 40,
            fontWeight: FontWeight.w800,
            height: 1,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Acompanhe. Participe. Inspire.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Bem-vindo(a)!',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Faca login para acessar a vida escolar dos seus filhos.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
      ],
    );
  }
}
