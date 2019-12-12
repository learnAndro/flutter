import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firestore_crud/data/model/reg.dart';

class FirestoreService {
  static final FirestoreService _firestoreService =
      FirestoreService._internal();
  Firestore _db = Firestore.instance;

  FirestoreService._internal();

  factory FirestoreService() {
    return _firestoreService;
  }

  Stream<List<Reg>> getNotes() {
    return _db.collection('regis').snapshots().map(
          (snapshot) => snapshot.documents.map(
            (doc) => Reg.fromMap(doc.data, doc.documentID),
          ).toList(),
        );
  }

  Future<void> addNote(Reg reg) {
    return _db.collection('regis').add(reg.toMap());
  }

  Future<void> deleteNote(String id) {
    return _db.collection('regis').document(id).delete();
  }

  Future<void> updateNote(Reg reg) {
    return _db.collection('regis').document(reg.id).updateData(reg.toMap());
  }

}
