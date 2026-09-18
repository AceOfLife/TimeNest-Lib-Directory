import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/child_model.dart';

class ChildRepository {
  final FirebaseFirestore firestore;

  ChildRepository(this.firestore);

  Stream<List<ChildModel>> getChildren(
    String parentId,
  ) {
    return firestore
        .collection('users')
        .doc(parentId)
        .collection('children')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => ChildModel.fromFirestore(doc),
              )
              .toList(),
        );
  }
}