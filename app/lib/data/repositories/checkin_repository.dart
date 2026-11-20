import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../local/app_database.dart';
import '../remote/checkin_dto.dart';

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
                needsSync: const Value(true),
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
            needsSync: const Value(true),
          ),
        );
      }
    });
  }

  /// Rows with local changes the server doesn't have yet (deleted ones too).
  Future<List<DailyCheckin>> pendingSync() =>
      (_db.select(_db.dailyCheckins)..where((t) => t.needsSync)).get();

  /// Clears the flag on rows the server accepted. A row edited again while
  /// the push was in flight has a newer updatedAt and stays pending.
  Future<void> markSynced(List<DailyCheckin> pushed) => _db.transaction(() async {
        for (final row in pushed) {
          await (_db.update(_db.dailyCheckins)
                ..where(
                  (t) => t.id.equals(row.id) & t.updatedAt.equals(row.updatedAt),
                ))
              .write(const DailyCheckinsCompanion(needsSync: Value(false)));
        }
      });

  /// Saves check-ins downloaded from the server.
  /// Matched by date: the server's row wins unless a newer local edit is waiting.
  Future<void> applyRemote(List<CheckinDto> items) => _db.transaction(() async {
        for (final remote in items) {
          final local = await (_db.select(_db.dailyCheckins)
                ..where((t) => t.date.equals(remote.date)))
              .getSingleOrNull();

          if (local != null &&
              local.needsSync &&
              local.updatedAt.isAfter(remote.updatedAt)) {
            continue; // our newer edit will be pushed next time
          }

          final row = DailyCheckinsCompanion(
            id: Value(remote.id), // adopt the server's id for this date
            date: Value(remote.date),
            mood: Value(remote.mood),
            energy: Value(remote.energy),
            productivity: Value(remote.productivity),
            note: Value(remote.note),
            createdAt: Value(remote.createdAt),
            updatedAt: Value(remote.updatedAt),
            deletedAt: Value(remote.deletedAt),
            needsSync: const Value(false),
          );

          if (local == null) {
            await _db.into(_db.dailyCheckins).insert(row);
          } else {
            await (_db.update(_db.dailyCheckins)
                  ..where((t) => t.date.equals(remote.date)))
                .write(row);
          }
        }
      });
}