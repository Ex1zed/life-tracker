import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Local reminders planned on the phone; the server is not involved.
/// Interface, so widget tests can swap in a fake (like TokenStorage).
abstract interface class ReminderScheduler {
  /// Fires when the user taps one of our notifications.
  Stream<void> get taps;

  /// Daily "how was your day" reminder at [minutes] since local midnight.
  /// Null turns it off. Calling again replaces the previous schedule.
  Future<void> scheduleEveningCheckin(int? minutes);

  /// Removes all planned reminders (on sign-out).
  Future<void> cancelAll();
}

/// The next moment at [minutes] since midnight that is strictly after [now].
tz.TZDateTime nextInstanceOf(int minutes, tz.TZDateTime now) {
  final hour = minutes ~/ 60;
  final minute = minutes % 60;
  final today =
      tz.TZDateTime(now.location, now.year, now.month, now.day, hour, minute);
  if (today.isAfter(now)) return today;
  // day + 1 instead of add(Duration(days: 1)): stays correct across DST
  // changes, and day 31 + 1 rolls over to the next month by itself.
  return tz.TZDateTime(
      now.location, now.year, now.month, now.day + 1, hour, minute);
}

/// Real implementation on top of flutter_local_notifications.
class LocalReminderScheduler implements ReminderScheduler {
  final _plugin = FlutterLocalNotificationsPlugin();
  final _taps = StreamController<void>.broadcast();
  Future<void>? _ready;

  /// Each kind of reminder has its own fixed id, so rescheduling replaces it.
  static const _eveningCheckinId = 1;

  @override
  Stream<void> get taps => _taps.stream;

  /// Initializes once, on first use; later calls reuse the same Future.
  Future<void> _ensureReady() => _ready ??= _init();

  Future<void> _init() async {
    // The timezone package knows all zones but not which one the phone is in.
    tz.initializeTimeZones();
    try {
      final local = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(local.identifier));
    } catch (_) {
      // Unknown zone name: stay on UTC instead of crashing.
    }

    await _plugin.initialize(
      settings: const InitializationSettings(
        iOS: DarwinInitializationSettings(
          // Don't ask at startup: we ask when a reminder is actually scheduled.
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
      onDidReceiveNotificationResponse: (_) => _taps.add(null),
    );
  }

  @override
  Future<void> scheduleEveningCheckin(int? minutes) async {
    await _ensureReady();
    await _plugin.cancel(id: _eveningCheckinId);
    if (minutes == null) return;

    // iOS shows the system prompt only once; afterwards this just returns.
    await _plugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    await _plugin.zonedSchedule(
      id: _eveningCheckinId,
      title: 'Как прошёл день?',
      body: 'Отметь настроение, энергию и продуктивность — это 15 секунд.',
      scheduledDate: nextInstanceOf(minutes, tz.TZDateTime.now(tz.local)),
      notificationDetails: const NotificationDetails(
        iOS: DarwinNotificationDetails(),
        android: AndroidNotificationDetails('reminders', 'Напоминания'),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      // Repeat every day at the same time of day.
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  @override
  Future<void> cancelAll() async {
    await _ensureReady();
    await _plugin.cancelAll();
  }
}