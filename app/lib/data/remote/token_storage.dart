import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Where the access token lives. An interface, so tests can use memory.
abstract interface class TokenStorage {
  Future<String?> read();
  Future<void> write(String token);
  Future<void> delete();
}

/// iOS Keychain / Android Keystore: the token is never stored as plain text.
class SecureTokenStorage implements TokenStorage {
  static const _key = 'access_token';
  final _storage = const FlutterSecureStorage();

  @override
  Future<String?> read() => _storage.read(key: _key);

  @override
  Future<void> write(String token) => _storage.write(key: _key, value: token);

  @override
  Future<void> delete() => _storage.delete(key: _key);
}

/// For tests only.
class InMemoryTokenStorage implements TokenStorage {
  String? token;

  @override
  Future<String?> read() async => token;

  @override
  Future<void> write(String token) async => this.token = token;

  @override
  Future<void> delete() async => token = null;
}