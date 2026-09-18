import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/announcement_repository.dart';

final announcementRepositoryProvider =
    Provider<AnnouncementRepository>(
  (ref) {
    return AnnouncementRepository();
  },
);