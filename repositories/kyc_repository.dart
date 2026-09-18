import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class KycRepository {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  final FirebaseAuth _auth =
      FirebaseAuth.instance;

  final FirebaseStorage _storage =
      FirebaseStorage.instance;

  Future<void> submitKyc({
    required String fullName,
    required String idType,
    required File idImage,
    required File selfieImage,
  }) async {
    final uid =
        _auth.currentUser!.uid;

    final idRef = _storage
        .ref()
        .child(
          'kyc/$uid/id.jpg',
        );

    await idRef.putFile(
      idImage,
    );

    final idUrl =
        await idRef.getDownloadURL();

    final selfieRef =
        _storage.ref().child(
      'kyc/$uid/selfie.jpg',
    );

    await selfieRef.putFile(
      selfieImage,
    );

    final selfieUrl =
        await selfieRef
            .getDownloadURL();

    await _firestore
        .collection(
          'kyc_requests',
        )
        .add({
      'userId': uid,
      'fullName': fullName,
      'idType': idType,
      'idImageUrl': idUrl,
      'selfieUrl': selfieUrl,
      'status': 'pending',
      'submittedAt':
          FieldValue.serverTimestamp(),
    });
  }
  Future<void> approveKyc(
  String requestId,
  String userId,
) async {
  await _firestore
      .collection(
        'kyc_requests',
      )
      .doc(requestId)
      .update({
    'status': 'approved',
  });

  await _firestore
      .collection('users')
      .doc(userId)
      .update({
    'kycStatus': 'verified',
  });
}

Future<void> rejectKyc(
  String requestId,
  String userId,
) async {
  await _firestore
      .collection(
        'kyc_requests',
      )
      .doc(requestId)
      .update({
    'status': 'rejected',
  });

  await _firestore
      .collection('users')
      .doc(userId)
      .update({
    'kycStatus': 'rejected',
  });
}

Stream<QuerySnapshot<Map<String, dynamic>>>
    getPendingKycRequests() {
  return _firestore
      .collection(
        'kyc_requests',
      )
      .where(
        'status',
        isEqualTo: 'pending',
      )
      .snapshots();
}
}