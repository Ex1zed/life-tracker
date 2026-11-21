import 'package:flutter_test/flutter_test.dart';
import 'package:life_tracker/core/theme.dart';
import 'package:life_tracker/features/checkin/score_row.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  int? changed;

  setUp(() => changed = null);

  /// ScoreRow needs the app theme: it reads AppColors from it.
  Widget host(int value) => MaterialApp(
        theme: lightTheme,
        home: Scaffold(
          body: ScoreRow(
            label: 'Энергия',
            value: value,
            color: Colors.teal,
            onChanged: (v) => changed = v,
          ),
        ),
      );

  IconButton button(WidgetTester tester, IconData icon) =>
      tester.widget<IconButton>(find.widgetWithIcon(IconButton, icon));

  testWidgets('plus and minus step by one and stop at the ends',
      (tester) async {
    await tester.pumpWidget(host(10));
    expect(button(tester, Icons.add).onPressed, isNull);

    await tester.tap(find.widgetWithIcon(IconButton, Icons.remove));
    expect(changed, 9);

    await tester.pumpWidget(host(1));
    expect(button(tester, Icons.remove).onPressed, isNull);
  });

  testWidgets('tapping the bar picks the segment under the finger',
      (tester) async {
    await tester.pumpWidget(host(5));
    final bar = tester.getRect(find.byType(ScoreBar));

    // 75% of the width is inside segment 8.
    await tester.tapAt(Offset(bar.left + bar.width * 0.75, bar.center.dy));
    expect(changed, 8);
  });

  test('valueAt maps the whole width to 1..10', () {
    expect(ScoreBar.valueAt(0, 300), 1);
    expect(ScoreBar.valueAt(29, 300), 1);
    expect(ScoreBar.valueAt(31, 300), 2);
    expect(ScoreBar.valueAt(300, 300), 10);
    expect(ScoreBar.valueAt(400, 300), 10); // finger slid past the end
  });
}