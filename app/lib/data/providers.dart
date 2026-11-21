import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/config.dart';
import 'local/app_database.dart';
import 'local/app_preferences.dart';
import 'notifications/reminder_scheduler.dart';
import 'remote/sync_api.dart';
import 'remote/token_storage.dart';
import 'repositories/auth_repository.dart';
import 'repositories/checkin_repository.dart';
import 'repositories/settings_repository.dart';
import 'sync/sync_service.dart';

/// One database instance for the whole app, closed when the app shuts down.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

/// Device-only settings (theme); replaced by the in-memory version in tests.
final appPreferencesProvider = Provider<AppPreferences>(
  (ref) => SharedAppPreferences(),
);

final checkinRepositoryProvider = Provider<CheckinRepository>(
  (ref) => CheckinRepository(ref.watch(appDatabaseProvider)),
);

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => SettingsRepository(ref.watch(appDatabaseProvider)),
);

/// Local notifications; replaced by a fake in widget tests.
final reminderSchedulerProvider = Provider<ReminderScheduler>(
  (ref) => LocalReminderScheduler(),
);

final tokenStorageProvider = Provider<TokenStorage>(
  (ref) => SecureTokenStorage(),
);

/// HTTP client for our API. Adds the access token to every request.
final dioProvider = Provider<Dio>((ref) {
  final tokens = ref.watch(tokenStorageProvider);
  final dio = Dio(
    BaseOptions(
      baseUrl: apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await tokens.read();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
    ),
  );
  return dio;
});

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(
    ref.watch(dioProvider),
    ref.watch(tokenStorageProvider),
  ),
);

final syncApiProvider = Provider<SyncApi>(
  (ref) => SyncApi(ref.watch(dioProvider)),
);

/// A single SyncService for the app, so "one sync at a time" works.
final syncServiceProvider = Provider<SyncService>(
  (ref) => SyncService(
    api: ref.watch(syncApiProvider),
    checkins: ref.watch(checkinRepositoryProvider),
    db: ref.watch(appDatabaseProvider),
  ),
);