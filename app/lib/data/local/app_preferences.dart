import 'package:shared_preferences/shared_preferences.dart';

/// Small device-only settings, e.g. the theme. Unlike the database,
/// they are not synced and survive sign-out.
/// Interface, so tests use the in-memory version (like TokenStorage).
abstract interface class AppPreferences {
  Future<String?> read(String key);
  Future<void> write(String key, String value);
}

class SharedAppPreferences implements AppPreferences {
  final _prefs = SharedPreferencesAsync();

  @override
  Future<String?> read(String key) => _prefs.getString(key);

  @override
  Future<void> write(String key, String value) => _prefs.setString(key, value);
}

class InMemoryAppPreferences implements AppPreferences {
  final values = <String, String>{};

  @override
  Future<String?> read(String key) async => values[key];

  @override
  Future<void> write(String key, String value) async {
    values[key] = value;
  }
}