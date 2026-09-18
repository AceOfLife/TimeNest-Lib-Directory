import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_model.dart';
import 'user_repository_provider.dart';

final userProvider = FutureProvider.family<
    UserModel?,
    String>((ref, uid) async {
  return ref
      .read(userRepositoryProvider)
      .getUser(uid);
});

final liveUserProvider =
    StreamProvider.family<
        UserModel?,
        String>((ref, uid) {
  return ref
      .read(userRepositoryProvider)
      .watchUser(uid);
});