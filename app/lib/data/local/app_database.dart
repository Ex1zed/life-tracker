import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [SleepEntries, DailyCheckins, Settings, SyncState])
class AppDatabase extends _$AppDatabase {
  /// Pass an executor in tests (in-memory DB); the app uses a file on disk.
  AppDatabase([QueryExecutor? executor])
      : super(executor ?? driftDatabase(name: 'life_tracker'));

  /// Bump on every schema change and add a step to [migration].
  /// v1: initial tables. v2: needsSync flag + sync_state table.
  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        // Fresh install: create everything at the latest version.
        onCreate: (m) => m.createAll(),
        // Existing install: bring the old database up step by step.
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(sleepEntries, sleepEntries.needsSync);
            await m.addColumn(dailyCheckins, dailyCheckins.needsSync);
            await m.addColumn(settings, settings.needsSync);
            await m.createTable(syncState);
          }
        },
      );

  /// Deletes every row in every table, e.g. when the user signs out.
  Future<void> clearAllData() => transaction(() async {
        for (final table in allTables) {
          await delete(table).go();
        }
      });
}