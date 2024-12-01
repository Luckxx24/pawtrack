import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/adopt_models.dart';

class FirebaseService {
  final CollectionReference _collection =
  FirebaseFirestore.instance.collection('adopt');

  // Create or update data
  Future<void> saveAdopt(Adopt adopt) async {
    await _collection.doc(adopt.nama).set(adopt.toMap());
  }

  // Delete data
  Future<void> deleteAdopt(String nama) async {
    await _collection.doc(nama).delete();
  }

  Future<void> updateAdopt(String nama, Map<String, dynamic> updates) async {
    await _collection.doc(nama).update(updates);
  }

  // Stream data
  Stream<List<Adopt>> getAdopt() {
    return _collection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Adopt.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }
}