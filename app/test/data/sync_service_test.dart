import 'package:dio/dio.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_tracker/data/local/app_database.dart';
import 'package:life_tracker/data/providers.dart';
import 'package:life_tracker/data/remote/token_storage.dart';
import 'package:life_tracker/data/repositories/checkin_repository.dart';
import 'package:life_tracker/data/sync/sync_service.dart';

import '../helpers/fake_http.dart';

void main() {
  late AppDatabase db;
  late ProviderContainer container;
  late FakeAdapter adapter;

  /// Real providers and database, fake server.
  SyncService serviceWith(ResponseBody Function(RequestOptions) respond) {
    adapter = FakeAdapter(respond);
    container.read(dioProvider).httpClientAdapter = adapter;
    return container.read(syncServiceProvider);
  }

  CheckinRepository checkins() => container.read(checkinRepositoryProvider);

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        tokenStorageProvider.overrideWithValue(
          InMemoryTokenStorage()..token = 'test-token',
        ),
      ],
    );
  });
  tearDown(() async {
    container.dispose();
    await db.close();
  });

  /// A server with nothing new to pull.
  ResponseBody emptyServer(RequestOptions options) => options.path == '/sync/push'
      ? json({'applied': 1, 'skipped': 0}, 200)
      : json({'checkins': [], 'cursor': null, 'has_more': false}, 200);

  test('pushes pending check-ins and clears the flag', () async {
    final sync = serviceWith(emptyServer);
    await checkins().saveForDate(
      date: '2026-11-20', mood: 7, energy: 5, productivity: 8,
    );

    final ok = await sync.syncNow();

    expect(ok, isTrue);
    expect(await checkins().pendingSync(), isEmpty);
    final push = adapter.requests.firstWhere((r) => r.path == '/sync/push');
    expect((push.data as Map)['checkins'], hasLength(1));
  });

  test('pulls server check-ins and remembers the cursor', () async {
    final sync = serviceWith((options) {
      if (options.path == '/sync/push') return json({'applied': 0, 'skipped': 0}, 200);
      final since = options.queryParameters['since'];
      return json({
        'checkins': since == null
            ? [
                {
                  'id': 'server-id',
                  'date': '2026-11-19',
                  'mood': 6,
                  'energy': 6,
                  'productivity': 6,
                  'note': null,
                  'created_at': '2026-11-19T10:00:00Z',
                  'updated_at': '2026-11-19T10:00:00Z',
                  'deleted_at': null,
                },
              ]
            : [],
        'cursor': 'cursor-1',
        'has_more': false,
      }, 200);
    });

    await sync.syncNow();
    await sync.syncNow();

    final saved = await checkins().getForDate('2026-11-19');
    expect(saved!.mood, 6);
    final pulls = adapter.requests.where((r) => r.path == '/sync/pull').toList();
    expect(pulls.last.queryParameters['since'], 'cursor-1');
  });

  test('offline: returns false and keeps changes pending', () async {
    final sync = serviceWith(
      (options) => throw DioException.connectionError(
        requestOptions: options,
        reason: 'offline',
      ),
    );
    await checkins().saveForDate(
      date: '2026-11-20', mood: 7, energy: 5, productivity: 8,
    );

    final ok = await sync.syncNow();

    expect(ok, isFalse);
    expect(await checkins().pendingSync(), hasLength(1));
  });
}