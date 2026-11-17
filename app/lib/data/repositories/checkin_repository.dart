import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../local/app_database.dart';

/// All reads and writes of daily check-ins go through here, never from the UI.
class CheckinRepository {
  CheckinRepository(this._db, {DateTime Function()? now})
      : _now = now ?? DateTime.now;

  final AppDatabase _db;

  /// Injected clock, so tests can control time.
  final DateTime Function() _now;

  static const _uuid = Uuid();

  /// Latest check-ins, newest first. The stream emits again on every change.
  Stream<List<DailyCheckin>> watchRecent({int limit = 7}) {
    final query = _db.select(_db.dailyCheckins)
      ..where((t) => t.deletedAt.isNull())
      ..orderBy([(t) => OrderingTerm.desc(t.date)])
      ..limit(limit);
    return query.watch();
  }

  /// Check-in for a given date ("YYYY-MM-DD"), or null if there is none.
  Future<DailyCheckin?> getForDate(String date) {
    final query = _db.select(_db.dailyCheckins)
      ..where((t) => t.date.equals(date) & t.deletedAt.isNull());
    return query.getSingleOrNull();
  }

  /// Creates the check-in for [date], or updates it if one already exists.
  Future<void> saveForDate({
    required String date,
    required int mood,
    required int energy,
    required int productivity,
    String? note,
  }) async {
    final now = _now().toUtc();
    final trimmed = note?.trim();
    final cleanNote = (trimmed == null || trimmed.isEmpty) ? null : trimmed;

    // Transaction: the read and the write happen as one atomic step.
    await _db.transaction(() async {
      // Also finds a soft-deleted row: date is unique, so we revive it.
      final existing = await (_db.select(_db.dailyCheckins)
            ..where((t) => t.date.equals(date)))
          .getSingleOrNull();

      if (existing == null) {
        await _db.into(_db.dailyCheckins).insert(
              DailyCheckinsCompanion.insert(
                id: _uuid.v4(),
                date: date,
                mood: mood,
                energy: energy,
                productivity: productivity,
                note: Value(cleanNote),
                createdAt: now,
                updatedAt: now,
              ),
            );
      } else {
        await (_db.update(_db.dailyCheckins)
              ..where((t) => t.id.equals(existing.id)))
            .write(
          DailyCheckinsCompanion(
            mood: Value(mood),
            energy: Value(energy),
            productivity: Value(productivity),
            note: Value(cleanNote),
            updatedAt: Value(now),
            deletedAt: const Value(null),
          ),
        );
      }
    });
  }
}