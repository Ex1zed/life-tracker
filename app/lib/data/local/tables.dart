// drift column checks reference their own getter by design; it never recurses at runtime.
// ignore_for_file: recursive_getters

import 'package:drift/drift.dart';

enum SleepSource { health, manual }

/// Columns shared by all synced tables. Same names as on the server.
mixin SyncColumns on Table {
  /// UUID generated on the phone, the same on every device.
  TextColumn get id => text()();
  DateTimeColumn get createdAt => dateTime()();

  /// Set on every local change; resolves sync conflicts (latest wins).
  DateTimeColumn get updatedAt => dateTime()();

  /// Soft delete: deletions are synced like any other change.
  DateTimeColumn get deletedAt => dateTime().nullable()();
}

class SleepEntries extends Table with SyncColumns {
  DateTimeColumn get sleepStart => dateTime()();
  DateTimeColumn get sleepEnd => dateTime()();

  /// Stored as text "health" / "manual", same values as the server enum.
  TextColumn get source => textEnum<SleepSource>()();

  /// Null until the morning rating.
  IntColumn get quality =>
      integer().nullable().check(quality.isBetweenValues(1, 10))();
  TextColumn get note => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class DailyCheckins extends Table with SyncColumns {
  /// Local calendar date as "YYYY-MM-DD": exact, sortable, matches the API.
  TextColumn get date => text().unique()();
  IntColumn get mood => integer().check(mood.isBetweenValues(1, 10))();
  IntColumn get energy => integer().check(energy.isBetweenValues(1, 10))();
  IntColumn get productivity =>
      integer().check(productivity.isBetweenValues(1, 10))();
  TextColumn get note => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// One row per device. Times of day are minutes since local midnight.
@DataClassName('UserSettings')
class Settings extends Table with SyncColumns {
  TextColumn get timezone => text().withDefault(const Constant('UTC'))();
  IntColumn get sleepGoalMinutes =>
      integer().withDefault(const Constant(480))();
  IntColumn get bedtime => integer().withDefault(const Constant(23 * 60))();
  IntColumn get windDownMinutes =>
      integer().withDefault(const Constant(120))();

  /// Null means the reminder is turned off.
  IntColumn get morningReminder =>
      integer().nullable().withDefault(const Constant(9 * 60))();
  IntColumn get eveningReminder =>
      integer().nullable().withDefault(const Constant(21 * 60))();
  BoolColumn get shareNotesWithAi =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}