import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../notifiers/announcement_form_notifier.dart';
import '../state/announcement_form_state.dart';

final announcementFormProvider =
    NotifierProvider.autoDispose<
        AnnouncementFormNotifier,
        AnnouncementFormState>(
  AnnouncementFormNotifier.new,
);