import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_tracker/data/local/app_database.dart';
import 'package:life_tracker/data/local/app_preferences.dart';
import 'package:life_tracker/data/notifications/reminder_scheduler.dart';
import 'package:life_tracker/data/providers.dart';
import 'package:life_tracker/data/remote/token_storage.dart';
import 'package:life_tracker/data/sync/sync_service.dart';
import 'package:life_tracker/features/checkin/checkin_providers.dart';
import 'package:life_tracker/features/settings/settings_providers.dart';
import 'package:life_tracker/main.dart';

/// Sync that does nothing: widget tests have no server.
class _NoSync implements SyncService {
  @override
  Future<bool> syncNow() async => true;
}

/// Reminders that do nothing: widget tests have no notification system.
class _NoReminders implements ReminderScheduler {
  @override
  Stream<void> get taps => const Stream.empty();

  @override
  Future<void> scheduleEveningCheckin(int? minutes) async {}

  @override
  Future<void> cancelAll() async {}
}

void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  /// The real app with a memory DB, a memory token store and no network.
  ProviderScope app({String? token}) => ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          appPreferencesProvider.overrideWithValue(InMemoryAppPreferences()),
          tokenStorageProvider.overrideWithValue(
            InMemoryTokenStorage()..token = token,
          ),
          syncServiceProvider.overrideWithValue(_NoSync()),
          reminderSchedulerProvider.overrideWithValue(_NoReminders()),
          // Drift watch() streams leave timers behind in widget tests,
          // so streams are replaced with simple ones.
          recentCheckinsProvider.overrideWith(
            (ref) => Stream.value(const <DailyCheckin>[]),
          ),
          settingsProvider.overrideWith((ref) => const Stream.empty()),
        ],
        child: const LifeTrackerApp(),
      );

  testWidgets('signed-in user sees the four tabs', (tester) async {
    await tester.pumpWidget(app(token: 'test-token'));
    await tester.pump(); // let the gate read the token

    expect(find.text('Сегодня'), findsWidgets);
    expect(find.text('Сон'), findsOneWidget);
    expect(find.text('Дашборд'), findsOneWidget);
    expect(find.text('Инсайты'), findsOneWidget);
  });

  testWidgets('signed-out user sees the login screen', (tester) async {
    await tester.pumpWidget(app());
    await tester.pump();

    expect(find.text('Вход по почте'), findsOneWidget);
    expect(find.text('Получить код'), findsOneWidget);
    expect(find.text('Сон'), findsNothing);
  });

  testWidgets('login asks for an email before calling the server',
      (tester) async {
    await tester.pumpWidget(app());
    await tester.pump();

    await tester.tap(find.text('Получить код'));
    await tester.pump();

    expect(find.textContaining('Введи почту'), findsOneWidget);
    expect(find.text('Введи код'), findsNothing); // still on the first step
  });
}