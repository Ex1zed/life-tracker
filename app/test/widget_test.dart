import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_tracker/data/local/app_database.dart';
import 'package:life_tracker/data/providers.dart';
import 'package:life_tracker/data/remote/token_storage.dart';
import 'package:life_tracker/features/checkin/checkin_providers.dart';
import 'package:life_tracker/main.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  /// The real app with a memory DB, a memory token store and no network.
  ProviderScope app({String? token}) => ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          tokenStorageProvider.overrideWithValue(
            InMemoryTokenStorage()..token = token,
          ),
          recentCheckinsProvider.overrideWith(
            (ref) => Stream.value(const <DailyCheckin>[]),
          ),
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
}