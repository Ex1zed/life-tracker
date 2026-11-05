import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [SleepEntries, DailyCheckins, Settings])
class AppDatabase extends _$AppDatabase {
  /// Pass an executor in tests (in-memory DB); the app uses a file on disk.
  AppDatabase([QueryExecutor? executor])
      : super(executor ?? driftDatabase(name: 'life_tracker'));

  /// Bump on every schema change and add a migration step.
  @override
  int get schemaVersion => 1;
}