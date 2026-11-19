import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_tracker/data/local/app_database.dart';
import 'package:life_tracker/data/providers.dart';
import 'package:life_tracker/features/checkin/checkin_providers.dart';
import 'package:life_tracker/main.dart';

void main() {
  testWidgets('App shows four tabs', (tester) async {
    // Tests must never touch the real database file: use memory instead.
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          recentCheckinsProvider.overrideWith(
            (ref) => Stream.value(const <DailyCheckin>[]),
          ),
        ],
        child: const LifeTrackerApp(),
      ),
    );

    // findsWidgets: "Сегодня" appears both in the app bar and in the nav bar.
    expect(find.text('Сегодня'), findsWidgets);
    expect(find.text('Сон'), findsOneWidget);
    expect(find.text('Дашборд'), findsOneWidget);
    expect(find.text('Инсайты'), findsOneWidget);
  });
}