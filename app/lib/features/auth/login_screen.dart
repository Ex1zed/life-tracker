import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/theme.dart';
import '../../data/providers.dart';
import '../../data/repositories/auth_repository.dart';
import 'auth_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  /// Same as RESEND_INTERVAL on the server.
  static const _resendDelay = 60;

  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  bool _codeSent = false;
  bool _busy = false;
  String? _error;

  /// Seconds until "send again" is allowed; 0 = allowed now.
  int _resendIn = 0;
  Timer? _resendTimer;

  String get _email => _emailController.text.trim();

  Future<void> _requestCode() async {
    if (!_email.contains('@')) {
      setState(() => _error = 'Введи почту, например you@example.com');
      return;
    }
    await _run(
      () async {
        await ref.read(authRepositoryProvider).requestCode(_email);
        if (!mounted) return;
        setState(() => _codeSent = true);
        _startResendCountdown();
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

  /// Ticks once a second until the server allows a new code.
  void _startResendCountdown() {
    _resendTimer?.cancel();
    setState(() => _resendIn = _resendDelay);
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() => _resendIn--);
      if (_resendIn <= 0) timer.cancel();
    });
  }

  /// Shared busy/error handling for all actions.
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
    _resendTimer?.cancel();
    _emailController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
          children: [
            const Align(alignment: Alignment.centerLeft, child: BrandMark()),
            const SizedBox(height: 24),
            const Text(
              'Life Tracker',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Сон, настроение и энергия — в одном месте.',
              style: TextStyle(fontSize: 16, color: colors.muted),
            ),
            const SizedBox(height: 40),
            // Fades between the two steps instead of jumping.
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: _codeSent ? _codeStep() : _emailStep(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emailStep() {
    final colors = AppColors.of(context);

    return Column(
      key: const ValueKey('email-step'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _StepTitle('Вход по почте'),
        const SizedBox(height: 6),
        Text(
          'Пришлём код — пароль не нужен.',
          style: TextStyle(fontSize: 15, color: colors.muted),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _emailController,
          enabled: !_busy,
          keyboardType: TextInputType.emailAddress,
          autocorrect: false,
          autofillHints: const [AutofillHints.email],
          textInputAction: TextInputAction.go,
          onSubmitted: (_) => _requestCode(),
          decoration: const InputDecoration(hintText: 'you@example.com'),
        ),
        if (_error != null) _ErrorBox(_error!),
        const SizedBox(height: 16),
        _PrimaryButton(
          label: 'Получить код',
          busy: _busy,
          onPressed: _requestCode,
        ),
      ],
    );
  }

  Widget _codeStep() {
    final colors = AppColors.of(context);
    final ink = Theme.of(context).colorScheme.onSurface;

    return Column(
      key: const ValueKey('code-step'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _StepTitle('Введи код'),
        const SizedBox(height: 6),
        Text.rich(
          TextSpan(
            text: 'Отправили 6 цифр на ',
            children: [
              TextSpan(
                text: _email,
                style: TextStyle(color: ink, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          style: TextStyle(fontSize: 15, color: colors.muted),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _codeController,
          enabled: !_busy,
          autofocus: true,
          keyboardType: TextInputType.number,
          autofillHints: const [AutofillHints.oneTimeCode],
          maxLength: 6,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            letterSpacing: 12,
          ),
          // The sixth digit signs in right away: one less tap.
          onChanged: (value) {
            if (value.length == 6 && !_busy) _verifyCode();
          },
          decoration: const InputDecoration(
            hintText: '••••••',
            counterText: '', // hide the "0/6" counter
          ),
        ),
        if (_error != null) _ErrorBox(_error!),
        const SizedBox(height: 16),
        _PrimaryButton(label: 'Войти', busy: _busy, onPressed: _verifyCode),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: _busy ? null : _changeEmail,
              child: const Text('Изменить почту'),
            ),
            TextButton(
              onPressed: _busy || _resendIn > 0 ? null : _requestCode,
              child: Text(
                _resendIn > 0
                    ? 'Ещё раз через $_resendIn с'
                    : 'Отправить ещё раз',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// App logo: three bars in the colors of the three scores.
class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.size = 64});

  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final unit = size / 64; // proportions are drawn for a 64 px mark

    Widget bar(double height, Color color) => Container(
          width: 8 * unit,
          height: height * unit,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4 * unit),
          ),
        );

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(18 * unit),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          bar(20, colors.mood),
          SizedBox(width: 5 * unit),
          bar(32, colors.energy),
          SizedBox(width: 5 * unit),
          bar(26, colors.productivity),
          // Lifts the bars off the bottom edge.
          SizedBox(height: 46 * unit),
        ],
      ),
    );
  }
}

class _StepTitle extends StatelessWidget {
  const _StepTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
    );
  }
}

/// Full-width main button; shows a spinner while a request is running.
class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({
    required this.label,
    required this.busy,
    required this.onPressed,
  });

  final String label;
  final bool busy;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: busy ? null : onPressed,
      child: busy
          ? const SizedBox.square(
              dimension: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Text(label),
    );
  }
}

/// Error message in a tinted box, easier to notice than red text.
class _ErrorBox extends StatelessWidget {
  const _ErrorBox(this.message);

  final String message;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: scheme.errorContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: scheme.onErrorContainer),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: TextStyle(color: scheme.onErrorContainer),
              ),
            ),
          ],
        ),
      ),
    );
  }
}