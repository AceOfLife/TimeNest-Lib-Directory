import 'package:cloud_firestore/cloud_firestore.dart';

/// ===============================================================
/// Announcement Status
/// ===============================================================

abstract final class AnnouncementStatus {
  static const draft = 'Draft';
  static const scheduled = 'Scheduled';
  static const sent = 'Sent';
  static const expired = 'Expired';

  static const values = [
    draft,
    scheduled,
    sent,
    expired,
  ];
}

/// ===============================================================
/// Announcement Priority
/// ===============================================================

abstract final class AnnouncementPriority {
  static const low = 'Low';
  static const normal = 'Normal';
  static const high = 'High';
  static const critical = 'Critical';

  static const values = [
    low,
    normal,
    high,
    critical,
  ];
}

/// ===============================================================
/// Announcement Audience
/// ===============================================================

abstract final class AnnouncementAudience {
  static const everyone = 'Everyone';
  static const helpers = 'Helpers';
  static const requesters = 'Requesters';
  static const verifiedUsers = 'Verified Users';
  static const pendingKyc = 'Pending KYC';
  static const blockedUsers = 'Blocked Users';
  static const admins = 'Admins';

  static const values = [
    everyone,
    helpers,
    requesters,
    verifiedUsers,
    pendingKyc,
    blockedUsers,
    admins,
  ];
}

/// ===============================================================
/// Announcement Model
/// ===============================================================

class AnnouncementModel {
  final String id;

  final String title;

  final String message;

  final String audience;

  final String priority;

  final String status;

  final String createdBy;

  final bool isPinned;

  final bool isArchived;

  final Timestamp? createdAt;

  final Timestamp? scheduledAt;

  final Timestamp? sentAt;

  final Timestamp? expiresAt;

  const AnnouncementModel({
    this.id = '',
    this.title = '',
    this.message = '',
    this.audience = AnnouncementAudience.everyone,
    this.priority = AnnouncementPriority.normal,
    this.status = AnnouncementStatus.draft,
    this.createdBy = '',
    this.isPinned = false,
    this.isArchived = false,
    this.createdAt,
    this.scheduledAt,
    this.sentAt,
    this.expiresAt,
  });

  factory AnnouncementModel.fromDocument(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};

    return AnnouncementModel.fromMap(
      data,
      doc.id,
    );
  }

  factory AnnouncementModel.fromMap(
    Map<String, dynamic> map,
    String id,
  ) {
    return AnnouncementModel(
      id: id,
      title: map['title'] ?? '',
      message: map['message'] ?? '',
      audience: map['audience'] ??
          AnnouncementAudience.everyone,
      priority: map['priority'] ??
          AnnouncementPriority.normal,
      status: map['status'] ??
          AnnouncementStatus.draft,
      createdBy: map['createdBy'] ?? '',
      isPinned: map['isPinned'] ?? false,
      isArchived: map['isArchived'] ?? false,
      createdAt: map['createdAt'] as Timestamp?,
      scheduledAt:
          map['scheduledAt'] as Timestamp?,
      sentAt: map['sentAt'] as Timestamp?,
      expiresAt:
          map['expiresAt'] as Timestamp?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'message': message,
      'audience': audience,
      'priority': priority,
      'status': status,
      'createdBy': createdBy,
      'isPinned': isPinned,
      'isArchived': isArchived,
      'createdAt': createdAt,
      'scheduledAt': scheduledAt,
      'sentAt': sentAt,
      'expiresAt': expiresAt,
    };
  }

  AnnouncementModel copyWith({
    String? id,
    String? title,
    String? message,
    String? audience,
    String? priority,
    String? status,
    String? createdBy,
    bool? isPinned,
    bool? isArchived,
    Timestamp? createdAt,
    Timestamp? scheduledAt,
    Timestamp? sentAt,
    Timestamp? expiresAt,
  }) {
    return AnnouncementModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      audience: audience ?? this.audience,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      createdBy: createdBy ?? this.createdBy,
      isPinned: isPinned ?? this.isPinned,
      isArchived: isArchived ?? this.isArchived,
      createdAt: createdAt ?? this.createdAt,
      scheduledAt:
          scheduledAt ?? this.scheduledAt,
      sentAt: sentAt ?? this.sentAt,
      expiresAt:
          expiresAt ?? this.expiresAt,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AnnouncementModel &&
            other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'AnnouncementModel('
        'id: $id, '
        'title: $title, '
        'status: $status'
        ')';
  }
}