import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timenest/providers/announcement_repository_provider.dart';

import '../../../models/announcement_model.dart';
import '../../../repositories/announcement_repository.dart';
import '../state/announcement_form_state.dart';

class AnnouncementFormNotifier
    extends AutoDisposeNotifier<
        AnnouncementFormState> {
  late final AnnouncementRepository _repository;

  AnnouncementModel? _editingAnnouncement;

bool get isEditing =>
    _editingAnnouncement != null;

  @override
  AnnouncementFormState build() {
    _repository = ref.read(
      announcementRepositoryProvider,
    );

    return const AnnouncementFormState();
  }

  //==========================================================
  // Basic Fields
  //==========================================================

  void updateTitle(String value) {
    state = state.copyWith(
      title: value,
    );
  }

  void updateMessage(String value) {
    state = state.copyWith(
      message: value,
    );
  }

  //==========================================================
  // Targeting
  //==========================================================

  void updateAudience(String value) {
    state = state.copyWith(
      audience: value,
    );
  }

  void updatePriority(String value) {
    state = state.copyWith(
      priority: value,
    );
  }

  void updateStatus(String value) {
    state = state.copyWith(
      status: value,
    );
  }

  //==========================================================
  // Switches
  //==========================================================

  void setPinned(bool value) {
    state = state.copyWith(
      isPinned: value,
    );
  }

  void setArchived(bool value) {
    state = state.copyWith(
      isArchived: value,
    );
  }

  //==========================================================
  // Schedule
  //==========================================================

  void setSchedule(
    DateTime? date,
  ) {
    state = state.copyWith(
      scheduledAt: date,
    );
  }

  void setExpiry(
    DateTime? date,
  ) {
    state = state.copyWith(
      expiresAt: date,
    );
  }

  //==========================================================
  // Reset
  //==========================================================

  void reset() {
  _editingAnnouncement = null;

  state =
      const AnnouncementFormState();
}

  //==========================================================
  // Load Existing Announcement
  //==========================================================

  void loadAnnouncement(
  AnnouncementModel model,
) {
  _editingAnnouncement = model;

  state = state.copyWith(
    title: model.title,
    message: model.message,
    audience: model.audience,
    priority: model.priority,
    status: model.status,
    isPinned: model.isPinned,
    isArchived: model.isArchived,
    scheduledAt:
        model.scheduledAt?.toDate(),
    expiresAt:
        model.expiresAt?.toDate(),
  );
}

  //==========================================================
  // Build Model
  //==========================================================

  AnnouncementModel buildModel({
    required String createdBy,
    String id = '',
  }) {
    return AnnouncementModel(
      id: isEditing
    ? _editingAnnouncement!.id
    : id,
      title: state.title,
      message: state.message,
      audience: state.audience,
      priority: state.priority,
      status: state.status,
      createdBy: createdBy,
      isPinned: state.isPinned,
      isArchived: state.isArchived,
      createdAt: isEditing
    ? _editingAnnouncement!.createdAt
    : Timestamp.now(),
      scheduledAt: state.scheduledAt == null
          ? null
          : Timestamp.fromDate(
              state.scheduledAt!,
            ),
      sentAt: null,
      expiresAt: state.expiresAt == null
          ? null
          : Timestamp.fromDate(
              state.expiresAt!,
            ),
    );
  }

  //==========================================================
  // Save Announcement
  //==========================================================

  Future<void> saveAnnouncement({
  required String createdBy,
}) async {
  state = state.copyWith(
    loading: true,
  );

  try {
    final model = buildModel(
      createdBy: createdBy,
    );

    if (isEditing) {
      await _repository.updateAnnouncement(
        announcement: model,
      );
    } else {
      await _repository.createAnnouncement(
        announcement: model,
      );
    }
  } finally {
    state = state.copyWith(
      loading: false,
    );
  }
}

Future<void> publish() async {
  if (!isEditing) return;

  await _repository.updateStatus(
    id: _editingAnnouncement!.id,
    status: 'Published',
  );
}

Future<void> schedule() async {
  if (!isEditing) return;

  await _repository.updateStatus(
    id: _editingAnnouncement!.id,
    status: 'Scheduled',
  );
}

Future<void> expire() async {
  if (!isEditing) return;

  await _repository.updateStatus(
    id: _editingAnnouncement!.id,
    status: 'Expired',
  );
}

Future<void> archive() async {
  if (!isEditing) return;

  await _repository.updateStatus(
    id: _editingAnnouncement!.id,
    status: 'Archived',
  );
}

}