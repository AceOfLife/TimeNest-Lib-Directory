import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/announcement_model.dart';
import 'announcement_repository_provider.dart';

final announcementsProvider =
    StreamProvider<
        List<AnnouncementModel>>(
  (ref) {
    return ref
        .read(
          announcementRepositoryProvider,
        )
        .getAnnouncements();
  },
);