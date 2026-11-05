import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_tracker/data/local/app_database.dart';

void main() {
  late AppDatabase db;

  // A fresh in-memory database for every test.
  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  DailyCheckinsCompanion checkin({required int mood}) {
    final now = DateTime.now().toUtc();
    return DailyCheckinsCompanion.insert(
      id: 'test-id',
      date: '2026-11-05',
      mood: mood,
      energy: 5,
      productivity: 8,
      createdAt: now,
      updatedAt: now,
    );
  }

  test('saves and reads a check-in', () async {
    await db.into(db.dailyCheckins).insert(checkin(mood: 7));

    final rows = await db.select(db.dailyCheckins).get();
    expect(rows.single.mood, 7);
  });

  test('rejects mood outside 1..10', () async {
    await expectLater(
      db.into(db.dailyCheckins).insert(checkin(mood: 11)),
      throwsA(isA<Exception>()),
    );
  });
}