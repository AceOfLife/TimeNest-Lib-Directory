import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_model.dart';
import 'auth_repository_provider.dart';

final currentUserProvider =
    FutureProvider<UserModel?>(
  (ref) {
    return ref
        .read(authRepositoryProvider)
        .getCurrentUserData();
  },
);