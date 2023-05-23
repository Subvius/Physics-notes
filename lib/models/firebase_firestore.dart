import 'package:cloud_firestore/cloud_firestore.dart';

class DBFirestore {
  DBFirestore({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Future<String> addDocument(
      {required String collectionPath,
      required Map<String, dynamic> data}) async {
    DocumentReference<Map<String, dynamic>> ref;
    ref = await _firestore.collection(collectionPath).add(data);

    return ref.id;
  }

  Future<void> setDocument(
      {required String collectionPath,
      required String documentId,
      required Map<String, dynamic> data}) async {
    DocumentReference<Map<String, dynamic>> ref;
    ref = _firestore.collection(collectionPath).doc(documentId);

    await ref.set(data, SetOptions(merge: true));
  }

  Future<Map<String, dynamic>?> getDocument({
    required String collectionPath,
    required String documentId,
  }) async {
    DocumentReference<Map<String, dynamic>> ref;
    ref = _firestore.collection(collectionPath).doc(documentId);

    final snapshot = await ref.get();

    return snapshot.data();
  }
}
