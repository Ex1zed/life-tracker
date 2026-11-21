import 'package:flutter_test/flutter_test.dart';
import 'package:life_tracker/data/notifications/reminder_scheduler.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() {
  late tz.Location krasnoyarsk;

  setUpAll(() {
    tz.initializeTimeZones();
    krasnoyarsk = tz.getLocation('Asia/Krasnoyarsk');
  });

  tz.TZDateTime at(int month, int day, int hour, int minute) =>
      tz.TZDateTime(krasnoyarsk, 2026, month, day, hour, minute);

  test('later today if the time has not come yet', () {
    expect(nextInstanceOf(21 * 60, at(11, 20, 18, 0)), at(11, 20, 21, 0));
  });

  test('tomorrow if the time has already passed', () {
    expect(nextInstanceOf(21 * 60, at(11, 20, 23, 53)), at(11, 21, 21, 0));
  });

  test('tomorrow if it is exactly that time now', () {
    expect(nextInstanceOf(21 * 60, at(11, 20, 21, 0)), at(11, 21, 21, 0));
  });

  test('rolls over to the next month', () {
    expect(nextInstanceOf(21 * 60, at(11, 30, 22, 0)), at(12, 1, 21, 0));
  });
}