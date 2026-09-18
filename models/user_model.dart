// import 'package:timenest/features/admin/models/admin_role.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../features/admin/models/admin_role.dart';



class UserModel {
  final String uid;
  final String fullName;
  final String email;
  final String phoneNumber;
  final int points;
  final String kycStatus;
  final String photoUrl;
  final double averageRating;
  final int strikeCount;
  final bool isBlocked;
  final String role;
  final List<String> permissions;
  final String accountStatus;
  final DateTime? createdAt;
  final DateTime? lastLoginAt;
  final DateTime? lastActiveAt;
  final String? createdBy;

  UserModel({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.points,
    required this.kycStatus,
    required this.photoUrl,
    required this.averageRating,
    required this.strikeCount,
    required this.isBlocked,
    required this.role,
    this.permissions = const [],

    this.accountStatus = 'active',
    this.createdAt,
    this.lastLoginAt,
    this.lastActiveAt,
    this.createdBy,

  });

  AdminRole get adminRole {
  return AdminRole.values.firstWhere(
    (e) => e.name == role,
    orElse: () => AdminRole.support,
  );
}

  factory UserModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return UserModel(
      uid: map['uid'] ?? '',
      fullName: map['fullName'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      points: map['points'] ?? 0,
      kycStatus: map['kycStatus'] ?? 'pending',
      photoUrl: map['photoUrl'] ?? '',
      averageRating:
          (map['averageRating'] ?? 0.0)
              .toDouble(),
      strikeCount:
          map['strikeCount'] ?? 0,
      isBlocked:
          map['isBlocked'] ?? false,
      role:
          map['role'] ?? 'user',
      permissions:
    List<String>.from(
      map['permissions'] ?? [],
    ),

accountStatus:
    map['accountStatus'] ?? 'active',

createdAt: map['createdAt'] is Timestamp
    ? (map['createdAt'] as Timestamp).toDate()
    : map['createdAt'] as DateTime?,

lastLoginAt: map['lastLoginAt'] is Timestamp
    ? (map['lastLoginAt'] as Timestamp).toDate()
    : map['lastLoginAt'] as DateTime?,

lastActiveAt: map['lastActiveAt'] is Timestamp
    ? (map['lastActiveAt'] as Timestamp).toDate()
    : map['lastActiveAt'] as DateTime?,

createdBy:
    map['createdBy'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'points': points,
      'kycStatus': kycStatus,
      'createdAt': createdAt,
      'photoUrl': photoUrl,
      'averageRating': averageRating,
      'strikeCount': strikeCount,
      'isBlocked': isBlocked,
      'role': role,
      'permissions': permissions,
      'accountStatus': accountStatus,
      'lastLoginAt': lastLoginAt,
      'lastActiveAt': lastActiveAt,
      'createdBy': createdBy,
    };
  }
}