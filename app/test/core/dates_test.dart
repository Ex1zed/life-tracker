import 'package:flutter_test/flutter_test.dart';
import 'package:life_tracker/core/dates.dart';

void main() {
  test('toDateKey pads month and day', () {
    expect(toDateKey(DateTime(2026, 3, 7)), '2026-03-07');
  });

  test('formatLongDate uses Russian names in the right case', () {
    expect(formatLongDate(DateTime(2026, 11, 21)), 'Суббота, 21 ноября');
    expect(formatLongDate(DateTime(2026, 11, 22)), 'Воскресенье, 22 ноября');
  });

  test('shortWeekday goes from Пн to Вс', () {
    expect(shortWeekday(DateTime(2026, 11, 16)), 'Пн');
    expect(shortWeekday(DateTime(2026, 11, 22)), 'Вс');
  });

  test('startOfWeek returns Monday, also across a month boundary', () {
    expect(startOfWeek(DateTime(2026, 11, 21, 23, 50)), DateTime(2026, 11, 16));
    expect(startOfWeek(DateTime(2026, 11, 16)), DateTime(2026, 11, 16));
    expect(startOfWeek(DateTime(2026, 12, 1)), DateTime(2026, 11, 30));
  });
}