import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../features/auth/auth_controller.dart';
import '../features/auth/login_screen.dart';
import 'app_shell.dart';

/// Shows the app only to a signed-in user; otherwise the login screen.
class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authControllerProvider);
    return auth.when(
      data: (signedIn) => signedIn ? const AppShell() : const LoginScreen(),
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      // Can't read the token storage: safest is to ask to sign in again.
      error: (_, _) => const LoginScreen(),
    );
  }
}