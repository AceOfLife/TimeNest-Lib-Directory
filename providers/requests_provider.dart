import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/help_request_model.dart';
import 'request_repository_provider.dart';

final requestsProvider =
    StreamProvider<
        List<HelpRequestModel>>(
  (ref) {
    return ref
        .read(requestRepositoryProvider)
        .getHelpRequests();
  },
);