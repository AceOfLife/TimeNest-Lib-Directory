import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_model.dart';
import 'admin_repository_provider.dart';

final pendingKycProvider =
StreamProvider<List<UserModel>>(
(ref) {
return ref
.read(
adminRepositoryProvider,
)
.getPendingKycUsers();
},
);
