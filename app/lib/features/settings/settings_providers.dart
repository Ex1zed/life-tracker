import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/local/app_database.dart';
import '../../data/providers.dart';

/// Current settings; the screen rebuilds on every change.
final settingsProvider = StreamProvider.autoDispose<UserSettings>(
  (ref) => ref.watch(settingsRepositoryProvider).watch(),
);

/// Email from GET /me. autoDispose: after sign-out the next user
/// never sees a cached email of the previous one.
final myEmailProvider = FutureProvider.autoDispose<String?>(
  (ref) => ref.watch(authRepositoryProvider).fetchMyEmail(),
);