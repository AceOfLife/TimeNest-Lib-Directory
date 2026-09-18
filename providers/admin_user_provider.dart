import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/admin_user_repository.dart';

final adminUserRepositoryProvider =
    Provider<AdminUserRepository>(
  (ref) => AdminUserRepository(),
);

final adminUserProvider =
    StreamProvider.family(
  (
    ref,
    String uid,
  ) {
    return ref
        .read(
          adminUserRepositoryProvider,
        )
        .getUser(uid);
  },
);

final adminUserRequestsProvider =
    StreamProvider.family(
  (
    ref,
    String uid,
  ) {
    return ref
        .read(
          adminUserRepositoryProvider,
        )
        .getUserRequests(uid);
  },
);

final adminCompletedTasksProvider =
    StreamProvider.family(
  (
    ref,
    String uid,
  ) {
    return ref
        .read(
          adminUserRepositoryProvider,
        )
        .getCompletedTasks(uid);
  },
);

final adminReviewsProvider =
    StreamProvider.family(
  (
    ref,
    String uid,
  ) {
    return ref
        .read(
          adminUserRepositoryProvider,
        )
        .getReviews(uid);
  },
);

final adminReportsProvider =
    StreamProvider.family(
  (
    ref,
    String uid,
  ) {
    return ref
        .read(
          adminUserRepositoryProvider,
        )
        .getReportsAgainstUser(uid);
  },
);