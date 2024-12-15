import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/grooming_models.dart';

class FirebaseService {
  final CollectionReference _collection =
  FirebaseFirestore.instance.collection('pesangrooming');

  // Create or update data
  Future<void> pesanGrooming(Grooming grooming) async {
    await _collection.doc( grooming.nama).set(grooming.toMap());
  }

  // Delete data
  Future<void> deletePesanGrooming(String nama) async {
    await _collection.doc(nama).delete();
  }

  Future<void> updatePesanGrooming(String nama, Map<String, dynamic> updates) async {
    await _collection.doc(nama).update(updates);
  }

  // Stream data
  Stream<List<Grooming>> getGrooming() {
    return _collection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return  Grooming.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }
}