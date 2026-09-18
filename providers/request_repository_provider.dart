import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/request_repository.dart';

final requestRepositoryProvider =
    Provider<RequestRepository>(
  (ref) => RequestRepository(),
);