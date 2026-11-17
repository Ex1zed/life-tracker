import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'local/app_database.dart';
import 'repositories/checkin_repository.dart';

/// One database instance for the whole app, closed when the app shuts down.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final checkinRepositoryProvider = Provider<CheckinRepository>(
  (ref) => CheckinRepository(ref.watch(appDatabaseProvider)),
);