import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'core/auth_gate.dart';
import 'core/theme.dart';
import 'features/settings/theme_controller.dart';

void main() {
  // ProviderScope stores the state of all Riverpod providers in the app.
  runApp(const ProviderScope(child: LifeTrackerApp()));
}

class LifeTrackerApp extends ConsumerWidget {
  const LifeTrackerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Until the saved choice is read (a few ms), follow the system.
    final themeMode = ref.watch(themeModeProvider).value ?? ThemeMode.system;

    return MaterialApp(
      title: 'Life Tracker',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      home: const AuthGate(),
    );
  }
}