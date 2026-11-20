import 'package:dio/dio.dart';

import 'checkin_dto.dart';

/// One page of changes from GET /sync/pull.
class PulledCheckins {
  const PulledCheckins({
    required this.checkins,
    required this.cursor,
    required this.hasMore,
  });

  final List<CheckinDto> checkins;

  /// Opaque server cursor: we store it and send it back as `since`.
  final String? cursor;
  final bool hasMore;
}

/// HTTP calls of the sync API. Errors are DioException; SyncService handles them.
class SyncApi {
  SyncApi(this._dio);

  final Dio _dio;

  Future<void> pushCheckins(List<CheckinDto> items) => _dio.post(
        '/sync/push',
        data: {
          'checkins': [for (final item in items) item.toJson()],
        },
      );

  Future<PulledCheckins> pullCheckins({String? since}) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/sync/pull',
      // ?since: the key is left out entirely when since is null.
      queryParameters: {'since': ?since},
    );
    final body = response.data!;
    return PulledCheckins(
      checkins: [
        for (final item in body['checkins'] as List)
          CheckinDto.fromJson(item as Map<String, dynamic>),
      ],
      cursor: body['cursor'] as String?,
      hasMore: body['has_more'] as bool,
    );
  }
}