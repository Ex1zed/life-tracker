import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../data/providers.dart';

/// Light, dark or follow the system. Stored on this device only.
final themeModeProvider =
    AsyncNotifierProvider<ThemeController, ThemeMode>(ThemeController.new);

class ThemeController extends AsyncNotifier<ThemeMode> {
  static const _key = 'theme_mode';

  /// Reads the saved choice; anything unknown means "follow the system".
  @override
  Future<ThemeMode> build() async {
    final saved = await ref.watch(appPreferencesProvider).read(_key);
    return ThemeMode.values.asNameMap()[saved] ?? ThemeMode.system;
  }

  /// Switches instantly, then saves ("system", "light" or "dark").
  Future<void> setMode(ThemeMode mode) async {
    state = AsyncData(mode);
    await ref.read(appPreferencesProvider).write(_key, mode.name);
  }
}