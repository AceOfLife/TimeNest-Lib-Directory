import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/admin_log_model.dart';
import 'admin_log_repository_provider.dart';

final adminLogsProvider =
    StreamProvider<List<AdminLogModel>>(
  (ref) {
    return ref
        .read(
          adminLogRepositoryProvider,
        )
        .getLogs();
  },
);