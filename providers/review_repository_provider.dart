import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/review_repository.dart';

final reviewRepositoryProvider =
    Provider<ReviewRepository>(
  (ref) {
    return ReviewRepository();
  },
);