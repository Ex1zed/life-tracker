import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_tracker/data/providers.dart';
import 'package:life_tracker/data/remote/token_storage.dart';
import 'package:life_tracker/data/repositories/auth_repository.dart';

import '../helpers/fake_http.dart';

void main() {
  late InMemoryTokenStorage tokens;
  late ProviderContainer container;

  /// Real providers (including the token interceptor), fake network.
  AuthRepository repoWith(FakeAdapter adapter) {
    container.read(dioProvider).httpClientAdapter = adapter;
    return container.read(authRepositoryProvider);
  }

  setUp(() {
    tokens = InMemoryTokenStorage();
    container = ProviderContainer(
      overrides: [tokenStorageProvider.overrideWithValue(tokens)],
    );
  });
  tearDown(() => container.dispose());

  test('verifyCode stores the access token', () async {
    final repo = repoWith(
      FakeAdapter((_) => json({'access_token': 'abc', 'token_type': 'bearer'}, 200)),
    );

    await repo.verifyCode('egor@gmail.com', '123456');

    expect(tokens.token, 'abc');
    expect(await repo.isSignedIn(), isTrue);
  });

  test('wrong code throws invalidCode and stores nothing', () async {
    final repo = repoWith(
      FakeAdapter((_) => json({'detail': 'Invalid or expired code'}, 400)),
    );

    await expectLater(
      repo.verifyCode('egor@gmail.com', '000000'),
      throwsA(isA<AuthException>()
          .having((e) => e.error, 'error', AuthError.invalidCode)),
    );
    expect(tokens.token, isNull);
  });

  test('requestCode maps 429 to tooManyRequests', () async {
    final repo = repoWith(
      FakeAdapter((_) => json({'detail': 'Wait a minute'}, 429)),
    );

    await expectLater(
      repo.requestCode('egor@gmail.com'),
      throwsA(isA<AuthException>()
          .having((e) => e.error, 'error', AuthError.tooManyRequests)),
    );
  });

  test('stored token is sent as Bearer header', () async {
    tokens.token = 'abc';
    final adapter =
        FakeAdapter((_) => json({'id': '1', 'email': 'egor@gmail.com'}, 200));
    final repo = repoWith(adapter);

    final email = await repo.fetchMyEmail();

    expect(email, 'egor@gmail.com');
    expect(adapter.requests.single.headers['Authorization'], 'Bearer abc');
  });

  test('signOut removes the token', () async {
    tokens.token = 'abc';
    final repo = repoWith(FakeAdapter((_) => json({}, 200)));

    await repo.signOut();

    expect(await repo.isSignedIn(), isFalse);
  });
}