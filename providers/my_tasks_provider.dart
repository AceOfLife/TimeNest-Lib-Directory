import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'request_repository_provider.dart';

final myTasksProvider =
    StreamProvider((ref) {
  return ref
      .read(requestRepositoryProvider)
      .getMyTasks();
});