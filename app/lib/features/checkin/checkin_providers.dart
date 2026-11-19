import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/local/app_database.dart';
import '../../data/providers.dart';

/// Last 7 check-ins; the UI rebuilds automatically when the table changes.
final recentCheckinsProvider = StreamProvider<List<DailyCheckin>>(
  (ref) => ref.watch(checkinRepositoryProvider).watchRecent(),
);