import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/admin_log_repository.dart';

final adminLogRepositoryProvider =
    Provider<AdminLogRepository>(
  (ref) {
    return AdminLogRepository();
  },
);