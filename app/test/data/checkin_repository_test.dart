import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_tracker/data/local/app_database.dart';
import 'package:life_tracker/data/repositories/checkin_repository.dart';

void main() {
  late AppDatabase db;
  late CheckinRepository repo;
  late DateTime clock;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    clock = DateTime.utc(2026, 11, 6, 10);
    repo = CheckinRepository(db, now: () => clock);
  });
  tearDown(() => db.close());

  test('creates a check-in for a new date', () async {
    await repo.saveForDate(
      date: '2026-11-06', mood: 7, energy: 5, productivity: 8,
    );

    final saved = await repo.getForDate('2026-11-06');
    expect(saved, isNotNull);
    expect(saved!.mood, 7);
    expect(saved.createdAt, clock);
  });

  test('second save on the same date updates the same row', () async {
    await repo.saveForDate(
      date: '2026-11-06', mood: 7, energy: 5, productivity: 8,
    );
    final first = await repo.getForDate('2026-11-06');

    clock = clock.add(const Duration(hours: 2));
    await repo.saveForDate(
      date: '2026-11-06', mood: 4, energy: 3, productivity: 6, note: 'tired',
    );

    final rows = await db.select(db.dailyCheckins).get();
    expect(rows, hasLength(1));
    expect(rows.single.id, first!.id);
    expect(rows.single.mood, 4);
    expect(rows.single.note, 'tired');
    expect(rows.single.createdAt, first.createdAt);
    expect(rows.single.updatedAt, clock);
  });

  test('blank note is stored as null', () async {
    await repo.saveForDate(
      date: '2026-11-06', mood: 7, energy: 5, productivity: 8, note: '   ',
    );

    final saved = await repo.getForDate('2026-11-06');
    expect(saved!.note, isNull);
  });

  test('watchRecent returns newest first, at most the limit', () async {
    for (var day = 1; day <= 9; day++) {
      final date = '2026-11-${day.toString().padLeft(2, '0')}';
      await repo.saveForDate(date: date, mood: 5, energy: 5, productivity: 5);
    }

    final recent = await repo.watchRecent().first;
    expect(recent, hasLength(7));
    expect(recent.first.date, '2026-11-09');
    expect(recent.last.date, '2026-11-03');
  });
}