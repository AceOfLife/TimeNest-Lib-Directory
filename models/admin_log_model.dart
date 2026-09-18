import 'package:cloud_firestore/cloud_firestore.dart';

class AdminLogModel {
  final String id;
  final String action;
  final String adminId;
  final String adminName;
  final String targetId;
  final String targetName;
  final String description;
  final Timestamp? createdAt;

  const AdminLogModel({
    required this.id,
    required this.action,
    required this.adminId,
    required this.adminName,
    required this.targetId,
    required this.targetName,
    required this.description,
    required this.createdAt,
  });

  factory AdminLogModel.fromMap(
    Map<String, dynamic> map,
    String id,
  ) {
    return AdminLogModel(
      id: id,
      action: map['action'] ?? '',
      adminId: map['adminId'] ?? '',
      adminName: map['adminName'] ?? '',
      targetId: map['targetId'] ?? '',
      targetName: map['targetName'] ?? '',
      description: map['description'] ?? '',
      createdAt: map['createdAt'] as Timestamp?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'action': action,
      'adminId': adminId,
      'adminName': adminName,
      'targetId': targetId,
      'targetName': targetName,
      'description': description,
      'createdAt': createdAt,
    };
  }
}