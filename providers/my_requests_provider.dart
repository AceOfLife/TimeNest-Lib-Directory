import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'request_repository_provider.dart';

final myRequestsProvider =
    StreamProvider((ref) {
  return ref
      .read(requestRepositoryProvider)
      .getMyRequests();
});