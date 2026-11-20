import 'package:dio/dio.dart';

import '../remote/token_storage.dart';

enum AuthError { invalidCode, tooManyRequests, network, unknown }

/// Thrown by AuthRepository; the UI turns [error] into a message for the user.
class AuthException implements Exception {
  const AuthException(this.error);
  final AuthError error;

  @override
  String toString() => 'AuthException($error)';
}

/// Email sign-in against the backend and token storage.
class AuthRepository {
  AuthRepository(this._dio, this._tokens);

  final Dio _dio;
  final TokenStorage _tokens;

  Future<bool> isSignedIn() async => await _tokens.read() != null;

  /// Asks the server to send a 6-digit code to [email].
  Future<void> requestCode(String email) =>
      _guard(() => _dio.post('/auth/email/request', data: {'email': email}));

  /// Exchanges the code for an access token and stores it.
  Future<void> verifyCode(String email, String code) async {
    final response = await _guard(
      () => _dio.post<Map<String, dynamic>>(
        '/auth/email/verify',
        data: {'email': email, 'code': code},
      ),
    );
    await _tokens.write(response.data!['access_token'] as String);
  }

  /// Email of the signed-in user, from GET /me.
  Future<String?> fetchMyEmail() async {
    final response =
        await _guard(() => _dio.get<Map<String, dynamic>>('/me'));
    return response.data!['email'] as String?;
  }

  Future<void> signOut() => _tokens.delete();

  /// Converts Dio errors into AuthException, so the UI doesn't know about HTTP.
  Future<T> _guard<T>(Future<T> Function() request) async {
    try {
      return await request();
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      if (status == 400) throw const AuthException(AuthError.invalidCode);
      if (status == 429) throw const AuthException(AuthError.tooManyRequests);
      if (e.response == null) throw const AuthException(AuthError.network);
      throw const AuthException(AuthError.unknown);
    }
  }
}