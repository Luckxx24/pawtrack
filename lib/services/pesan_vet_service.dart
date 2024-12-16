import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/vet_models.dart';

class FirebaseService {
  final CollectionReference _collection =
  FirebaseFirestore.instance.collection('pesanvet');

  // Create or update data
  Future<void> pesanVet(Vet vet) async {
    await _collection.doc(vet.nama).set(vet.toMap()); // Changed from Vet.toMap() to vet.toMap()
  }

  // Delete data
  Future<void> deletepesanVet(String nama) async {
    await _collection.doc(nama).delete();
  }

  Future<void> updatepesanVet(String nama, Map<String, dynamic> updates) async {
    await _collection.doc(nama).update(updates);
  }

  // Stream data
  Stream<List<Vet>> getpesanVet() {
    return _collection.snapshots().map((QuerySnapshot snapshot) {
      return snapshot.docs.map((QueryDocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Vet.fromMap(data);
      }).toList();
    });
  }
}