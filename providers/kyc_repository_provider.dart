import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/kyc_repository.dart';

final kycRepositoryProvider =
    Provider<KycRepository>(
  (ref) {
    return KycRepository();
  },
);