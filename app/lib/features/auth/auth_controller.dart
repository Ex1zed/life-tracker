import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers.dart';

/// Whether the user is signed in. The whole app switches on this value.
final authControllerProvider =
    AsyncNotifierProvider<AuthController, bool>(AuthController.new);

class AuthController extends AsyncNotifier<bool> {
  /// Runs once at startup: signed in if a token is stored.
  @override
  Future<bool> build() => ref.watch(authRepositoryProvider).isSignedIn();

  /// Throws AuthException on failure; the login screen shows the message.
  Future<void> verifyCode(String email, String code) async {
    await ref.read(authRepositoryProvider).verifyCode(email, code);
    state = const AsyncData(true);
  }

  /// Removes the token, wipes local data and reminders,
  /// so the next user starts clean.
  Future<void> signOut() async {
    await ref.read(authRepositoryProvider).signOut();
    await ref.read(reminderSchedulerProvider).cancelAll();
    await ref.read(appDatabaseProvider).clearAllData();
    state = const AsyncData(false);
  }
}