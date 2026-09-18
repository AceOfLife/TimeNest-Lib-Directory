import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/announcement_model.dart';

class AnnouncementRepository {
  AnnouncementRepository({
    FirebaseFirestore? firestore,
  }) : _firestore =
            firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>>
      get _collection =>
          _firestore.collection(
            'announcements',
          );

  // ===========================================================
  // Streams
  // ===========================================================

  Stream<List<AnnouncementModel>>
      getAnnouncements({
    bool includeArchived = false,
    int? limit,
  }) {
    Query<Map<String, dynamic>> query =
        _collection
            .orderBy(
              'isPinned',
              descending: true,
            )
            .orderBy(
              'createdAt',
              descending: true,
            );

    if (!includeArchived) {
      query = query.where(
        'isArchived',
        isEqualTo: false,
      );
    }

    if (limit != null) {
      query = query.limit(limit);
    }

    return query.snapshots().map(
          (snapshot) => snapshot.docs
              .map(
                AnnouncementModel
                    .fromDocument,
              )
              .toList(),
        );
  }

  Stream<List<AnnouncementModel>>
      getAnnouncementsByStatus(
    String status,
  ) {
    return _collection
        .where(
          'status',
          isEqualTo: status,
        )
        .orderBy(
          'createdAt',
          descending: true,
        )
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                AnnouncementModel
                    .fromDocument,
              )
              .toList(),
        );
  }

  Stream<List<AnnouncementModel>>
      getAnnouncementsByAudience(
    String audience,
  ) {
    return _collection
        .where(
          'audience',
          isEqualTo: audience,
        )
        .orderBy(
          'createdAt',
          descending: true,
        )
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                AnnouncementModel
                    .fromDocument,
              )
              .toList(),
        );
  }

  // ===========================================================
  // Reads
  // ===========================================================

  Future<AnnouncementModel?>
      getAnnouncement(
    String id,
  ) async {
    final doc =
        await _collection.doc(id).get();

    if (!doc.exists) {
      return null;
    }

    return AnnouncementModel
        .fromDocument(doc);
  }

  // ===========================================================
  // Create
  // ===========================================================

  Future<DocumentReference>
      createAnnouncement({
    required AnnouncementModel
        announcement,
  }) {
    return _collection.add({
      ...announcement.toMap(),
      'createdAt':
          FieldValue.serverTimestamp(),
    });
  }

  // ===========================================================
  // Update
  // ===========================================================

  Future<void> updateAnnouncement({
  required AnnouncementModel announcement,
}) async {
  await _collection
      .doc(announcement.id)
      .update(
        announcement.toMap(),
      );
}

  // ===========================================================
  // Delete
  // ===========================================================

  Future<void> deleteAnnouncement(
    String id,
  ) {
    return _collection
        .doc(id)
        .delete();
  }

  // ===========================================================
  // Archive
  // ===========================================================

  Future<void> archiveAnnouncement(
    String id,
  ) {
    return _collection
        .doc(id)
        .update({
      'isArchived': true,
    });
  }

  Future<void> unarchiveAnnouncement(
    String id,
  ) {
    return _collection
        .doc(id)
        .update({
      'isArchived': false,
    });
  }

  // ===========================================================
  // Pin
  // ===========================================================

  Future<void> pinAnnouncement(
    String id,
  ) {
    return _collection
        .doc(id)
        .update({
      'isPinned': true,
    });
  }

  Future<void> unpinAnnouncement(
    String id,
  ) {
    return _collection
        .doc(id)
        .update({
      'isPinned': false,
    });
  }

  // ===========================================================
  // Status
  // ===========================================================

  Future<void> markAsSent(
    String id,
  ) {
    return _collection
        .doc(id)
        .update({
      'status':
          AnnouncementStatus.sent,
      'sentAt':
          FieldValue.serverTimestamp(),
    });
  }

  Future<void> markAsExpired(
    String id,
  ) {
    return _collection
        .doc(id)
        .update({
      'status':
          AnnouncementStatus.expired,
    });
  }

  Future<void> markAsScheduled(
    String id,
    Timestamp scheduledAt,
  ) {
    return _collection
        .doc(id)
        .update({
      'status':
          AnnouncementStatus
              .scheduled,
      'scheduledAt':
          scheduledAt,
    });
  }

  Future<void> markAsDraft(
    String id,
  ) {
    return _collection
        .doc(id)
        .update({
      'status':
          AnnouncementStatus.draft,
    });
  }

  // ===========================================================
  // Batch
  // ===========================================================

  Future<void>
      archiveAnnouncements(
    List<String> ids,
  ) async {
    final batch =
        _firestore.batch();

    for (final id in ids) {
      batch.update(
        _collection.doc(id),
        {
          'isArchived': true,
        },
      );
    }

    await batch.commit();
  }

  Future<void>
      deleteAnnouncements(
    List<String> ids,
  ) async {
    final batch =
        _firestore.batch();

    for (final id in ids) {
      batch.delete(
        _collection.doc(id),
      );
    }

    await batch.commit();
  }

  Future<void> updateStatus({
  required String id,
  required String status,
}) async {
  final data = <String, dynamic>{
    'status': status,
  };

  if (status == 'Published') {
    data['sentAt'] =
        FieldValue.serverTimestamp();
  }

  await _collection
      .doc(id)
      .update(data);
}
}