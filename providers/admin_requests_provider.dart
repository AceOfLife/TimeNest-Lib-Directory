import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/help_request_model.dart';
import 'admin_repository_provider.dart';

final adminRequestsProvider =
    StreamProvider<List<HelpRequestModel>>(
  (ref) {
    return ref
        .read(adminRepositoryProvider)
        .getAllRequests();
  },
);