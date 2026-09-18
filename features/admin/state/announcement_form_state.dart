import 'package:flutter/foundation.dart';

@immutable
class AnnouncementFormState {
  final String title;

  final String message;

  final String audience;

  final String priority;

  final String status;

  final bool isPinned;

  final bool isArchived;

  final DateTime? scheduledAt;

  final DateTime? expiresAt;

  final bool loading;

  const AnnouncementFormState({
    this.title = '',
    this.message = '',
    this.audience = 'Everyone',
    this.priority = 'Normal',
    this.status = 'Draft',
    this.isPinned = false,
    this.isArchived = false,
    this.scheduledAt,
    this.expiresAt,
    this.loading = false,
  });

  AnnouncementFormState copyWith({
    String? title,
    String? message,
    String? audience,
    String? priority,
    String? status,
    bool? isPinned,
    bool? isArchived,
    DateTime? scheduledAt,
    DateTime? expiresAt,
    bool? loading,
  }) {
    return AnnouncementFormState(
      title: title ?? this.title,
      message: message ?? this.message,
      audience: audience ?? this.audience,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      isPinned: isPinned ?? this.isPinned,
      isArchived: isArchived ?? this.isArchived,
      scheduledAt:
          scheduledAt ?? this.scheduledAt,
      expiresAt:
          expiresAt ?? this.expiresAt,
      loading: loading ?? this.loading,
    );
  }
}