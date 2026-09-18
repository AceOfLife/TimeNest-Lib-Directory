import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import 'request_repository_provider.dart';

final myReviewsProvider = StreamProvider((ref) {
  return ref
      .read(requestRepositoryProvider)
      .getMyReviews();
});

// Provider to fetch a single user by ID
final userByIdProvider = FutureProvider.family<UserModel?, String>((ref, userId) async {
  if (userId.isEmpty) return null;
  
  final firestore = FirebaseFirestore.instance;
  final doc = await firestore.collection('users').doc(userId).get();
  
  if (!doc.exists) return null;
  
  return UserModel.fromMap(doc.data()!);
});