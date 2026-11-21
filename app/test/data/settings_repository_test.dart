// Only Value: drift also has its own isNull(), which clashes with the matcher.
import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_tracker/data/local/app_database.dart';
import 'package:life_tracker/data/repositories/settings_repository.dart';

void main() {
  late AppDatabase db;
  late SettingsRepository repo;
  late DateTime clock;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    clock = DateTime.utc(2026, 11, 20, 12);
    repo = SettingsRepository(db, now: () => clock);
  });
  tearDown(() => db.close());

  test('get creates one row with defaults and reuses it', () async {
    final first = await repo.get();
    expect(first.bedtime, 23 * 60);
    expect(first.windDownMinutes, 120);
    expect(first.eveningReminder, 21 * 60);
    expect(first.needsSync, isTrue);

    final second = await repo.get();
    expect(second.id, first.id);
    expect(await db.select(db.settings).get(), hasLength(1));
  });

  test('two first calls at once still create a single row', () async {
    await Future.wait([repo.get(), repo.get()]);
    expect(await db.select(db.settings).get(), hasLength(1));
  });

  test('setBedtime saves the value and marks the row for sync', () async {
    await repo.get();
    await db
        .update(db.settings)
        .write(const SettingsCompanion(needsSync: Value(false)));

    clock = clock.add(const Duration(minutes: 5));
    await repo.setBedtime(30); // 00:30

    final s = await repo.get();
    expect(s.bedtime, 30);
    expect(s.updatedAt, clock);
    expect(s.needsSync, isTrue);
  });

  test('null evening reminder means off, and it can be turned back on',
      () async {
    await repo.setEveningReminder(null);
    expect((await repo.get()).eveningReminder, isNull);

    await repo.setEveningReminder(20 * 60 + 30);
    expect((await repo.get()).eveningReminder, 20 * 60 + 30);
  });

  test('rejects minutes outside one day', () async {
    expect(() => repo.setBedtime(24 * 60), throwsRangeError);
    expect(() => repo.setEveningReminder(-1), throwsRangeError);
  });

  test('watch emits current settings and then every change', () async {
    expect((await repo.watch().first).bedtime, 23 * 60);

    final later = expectLater(
      repo.watch().map((s) => s.bedtime),
      emitsThrough(22 * 60),
    );
    await repo.setBedtime(22 * 60);
    await later;
  });
}