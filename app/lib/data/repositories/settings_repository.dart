import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../local/app_database.dart';

/// The single settings row of the signed-in user.
/// Created with defaults on first use, so callers never see "no settings".
class SettingsRepository {
  SettingsRepository(this._db, {DateTime Function()? now})
      : _now = now ?? DateTime.now;

  final AppDatabase _db;
  final DateTime Function() _now;

  static const _uuid = Uuid();

  /// Returns the settings row, creating it with table defaults if missing.
  /// Transaction: two first calls at once still create only one row.
  Future<UserSettings> get() => _db.transaction(() async {
        final existing =
            await (_db.select(_db.settings)..limit(1)).getSingleOrNull();
        if (existing != null) return existing;

        final now = _now().toUtc();
        return _db.into(_db.settings).insertReturning(
              SettingsCompanion.insert(
                id: _uuid.v4(),
                createdAt: now,
                updatedAt: now,
              ),
            );
      });

  /// Current settings, emitted again on every change.
  Stream<UserSettings> watch() async* {
    await get(); // make sure the row exists before watching it
    yield* (_db.select(_db.settings)..limit(1))
        .watchSingleOrNull()
        .where((s) => s != null)
        .cast<UserSettings>();
  }

  /// Bedtime as minutes since local midnight (23:00 -> 1380).
  Future<void> setBedtime(int minutes) {
    _checkMinutes(minutes);
    return _update(SettingsCompanion(bedtime: Value(minutes)));
  }

  /// Evening check-in reminder time; null turns the reminder off.
  Future<void> setEveningReminder(int? minutes) {
    if (minutes != null) _checkMinutes(minutes);
    return _update(SettingsCompanion(eveningReminder: Value(minutes)));
  }

  /// Applies [changes] and marks the row for the next sync.
  Future<void> _update(SettingsCompanion changes) async {
    final current = await get();
    await (_db.update(_db.settings)..where((t) => t.id.equals(current.id)))
        .write(
      changes.copyWith(
        updatedAt: Value(_now().toUtc()),
        needsSync: const Value(true),
      ),
    );
  }

  static void _checkMinutes(int minutes) =>
      RangeError.checkValueInInterval(minutes, 0, 24 * 60 - 1, 'minutes');
}