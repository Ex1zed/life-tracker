import 'dart:math';

import 'package:dio/dio.dart';

import '../local/app_database.dart';
import '../remote/checkin_dto.dart';
import '../remote/sync_api.dart';
import '../repositories/checkin_repository.dart';

/// Two-way sync of check-ins: push local changes, then pull server changes.
class SyncService {
  // Callers still pass api:, checkins:, db: (without the underscore).
  SyncService({
    required this._api,
    required this._checkins,
    required this._db,
  });

  final SyncApi _api;
  final CheckinRepository _checkins;
  final AppDatabase _db;

  static const _cursorKey = 'checkins_cursor';
  static const _batchSize = 500; // the server accepts at most 500 per push

  Future<bool>? _running;

  /// Returns false if the server couldn't be reached. Nothing is lost:
  /// unsent rows keep needsSync and go out on the next sync.
  Future<bool> syncNow() {
    // One sync at a time: a call during a running sync shares its result.
    return _running ??= _run().whenComplete(() => _running = null);
  }

  Future<bool> _run() async {
    try {
      await _push();
      await _pull();
      return true;
    } on DioException {
      return false; // offline, server down, or rejected: try again later
    }
  }

  Future<void> _push() async {
    final pending = await _checkins.pendingSync();
    for (var start = 0; start < pending.length; start += _batchSize) {
      final batch =
          pending.sublist(start, min(start + _batchSize, pending.length));
      await _api.pushCheckins(batch.map(CheckinDto.fromRow).toList());
      await _checkins.markSynced(batch);
    }
  }

  Future<void> _pull() async {
    var cursor = await _db.readSyncValue(_cursorKey);
    while (true) {
      final page = await _api.pullCheckins(since: cursor);
      await _checkins.applyRemote(page.checkins);
      if (page.cursor != null) {
        cursor = page.cursor;
        await _db.writeSyncValue(_cursorKey, cursor!);
      }
      if (!page.hasMore) break;
    }
  }
}