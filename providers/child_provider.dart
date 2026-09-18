import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../repositories/child_repository.dart';
import '../models/child_model.dart';
import 'request_repository_provider.dart';

final childRepositoryProvider =
    Provider<ChildRepository>((ref) {
  return ChildRepository(
    FirebaseFirestore.instance,
  );
});

final childrenProvider =
    StreamProvider<List<ChildModel>>((ref) {
  final uid =
      ref.read(requestRepositoryProvider).currentUserId;

  return ref
      .read(childRepositoryProvider)
      .getChildren(uid!);
});