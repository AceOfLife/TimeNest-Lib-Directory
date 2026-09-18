import 'package:cloud_firestore/cloud_firestore.dart';

class HelpRequestModel {
  final String id;
  final String title;
  final String description;
  final String createdBy;
  final String status;
  final int creditsReward;
  final String category;
  final String visibility;
  final String assignedTo;
  final bool rewardPaid;

  // NEW
  final DateTime? taskDate;
  final String taskTime;

  HelpRequestModel({
    required this.id,
    required this.title,
    required this.description,
    required this.createdBy,
    required this.status,
    required this.creditsReward,
    required this.category,
    required this.visibility,
    required this.assignedTo,
    required this.rewardPaid,
    this.taskDate,
    required this.taskTime,
  });

  factory HelpRequestModel.fromMap(
    Map<String, dynamic> map,
    String id,
  ) {
    return HelpRequestModel(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      createdBy: map['createdBy'] ?? '',
      status: map['status'] ?? '',
      creditsReward: map['creditsReward'] ?? 0,
      category: map['category'] ?? '',
      visibility: map['visibility'] ?? '',
      assignedTo: map['assignedTo'] ?? '',
      rewardPaid: map['rewardPaid'] ?? false,

      taskDate: map['taskDate'] != null
          ? (map['taskDate'] as Timestamp).toDate()
          : null,

      taskTime: map['taskTime'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'createdBy': createdBy,
      'status': status,
      'createdAt': DateTime.now(),
      'creditsReward': creditsReward,
      'category': category,
      'visibility': visibility,
      'assignedTo': assignedTo,
      'rewardPaid': rewardPaid,

      'taskDate': taskDate,
      'taskTime': taskTime,
    };
  }
}