import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_tracker/data/local/app_preferences.dart';
import 'package:life_tracker/data/providers.dart';
import 'package:life_tracker/features/settings/theme_controller.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  late InMemoryAppPreferences prefs;

  setUp(() => prefs = InMemoryAppPreferences());

  /// A fresh container is like a fresh app start with the same storage.
  ProviderContainer startApp() {
    final container = ProviderContainer(
      overrides: [appPreferencesProvider.overrideWithValue(prefs)],
    );
    addTearDown(container.dispose);
    return container;
  }

  test('follows the system by default', () async {
    expect(await startApp().read(themeModeProvider.future), ThemeMode.system);
  });

  test('remembers the chosen mode after a restart', () async {
    final first = startApp();
    await first.read(themeModeProvider.future);
    await first.read(themeModeProvider.notifier).setMode(ThemeMode.dark);
    expect(first.read(themeModeProvider).value, ThemeMode.dark);

    expect(await startApp().read(themeModeProvider.future), ThemeMode.dark);
  });

  test('an unknown saved value falls back to the system', () async {
    prefs.values['theme_mode'] = 'purple';
    expect(await startApp().read(themeModeProvider.future), ThemeMode.system);
  });
}