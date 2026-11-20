import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../data/providers.dart';
import '../../data/repositories/auth_repository.dart';
import 'auth_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  bool _codeSent = false;
  bool _busy = false;
  String? _error;

  String get _email => _emailController.text.trim();

  Future<void> _requestCode() async {
    if (!_email.contains('@')) {
      setState(() => _error = 'Введи почту');
      return;
    }
    await _run(
      () async {
        await ref.read(authRepositoryProvider).requestCode(_email);
        if (mounted) setState(() => _codeSent = true);
      },
      tooManyMessage: 'Подожди минуту перед новым запросом кода',
    );
  }

  Future<void> _verifyCode() async {
    final code = _codeController.text.trim();
    if (code.length != 6) {
      setState(() => _error = 'Код состоит из 6 цифр');
      return;
    }
    // On success the auth gate replaces this screen with the app.
    await _run(
      () => ref.read(authControllerProvider.notifier).verifyCode(_email, code),
      tooManyMessage: 'Слишком много попыток — запроси новый код',
    );
  }

  /// Shared busy/error handling for both buttons.
  Future<void> _run(
    Future<void> Function() action, {
    required String tooManyMessage,
  }) async {
    FocusScope.of(context).unfocus();
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await action();
    } on AuthException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = switch (e.error) {
          AuthError.invalidCode => 'Неверный или просроченный код',
          AuthError.tooManyRequests => tooManyMessage,
          AuthError.network => 'Нет связи с сервером. Проверь интернет',
          AuthError.unknown => 'Что-то пошло не так. Попробуй ещё раз',
        };
      });
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _changeEmail() {
    setState(() {
      _codeSent = false;
      _error = null;
      _codeController.clear();
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(height: 48),
            Text('Life Tracker', style: theme.textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text('Вход по почте', style: theme.textTheme.bodyLarge),
            const SizedBox(height: 32),
            TextField(
              controller: _emailController,
              enabled: !_codeSent && !_busy,
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              decoration: const InputDecoration(
                labelText: 'Почта',
                border: OutlineInputBorder(),
              ),
            ),
            if (_codeSent) ...[
              const SizedBox(height: 16),
              Text('Код отправлен на $_email'),
              const SizedBox(height: 8),
              TextField(
                controller: _codeController,
                enabled: !_busy,
                autofocus: true,
                keyboardType: TextInputType.number,
                maxLength: 6,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Код из письма',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(_error!, style: TextStyle(color: theme.colorScheme.error)),
            ],
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _busy ? null : (_codeSent ? _verifyCode : _requestCode),
              child: _busy
                  ? const SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(_codeSent ? 'Войти' : 'Получить код'),
            ),
            if (_codeSent) ...[
              TextButton(
                onPressed: _busy ? null : _requestCode,
                child: const Text('Отправить код ещё раз'),
              ),
              TextButton(
                onPressed: _busy ? null : _changeEmail,
                child: const Text('Изменить почту'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}