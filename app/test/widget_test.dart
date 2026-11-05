import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_tracker/main.dart';

void main() {
  testWidgets('App shows four tabs', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: LifeTrackerApp()));

    // findsWidgets: "Сегодня" appears both in the app bar and in the nav bar.
    expect(find.text('Сегодня'), findsWidgets);
    expect(find.text('Сон'), findsOneWidget);
    expect(find.text('Дашборд'), findsOneWidget);
    expect(find.text('Инсайты'), findsOneWidget);
  });
}