import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/daycare_models.dart';

class FirebaseService {
  final CollectionReference _collection =
  FirebaseFirestore.instance.collection('daycare_services');

  // Create or update data
  Future<void> saveDaycare(Daycare daycare) async {
    await _collection.doc(daycare.nama).set(daycare.toMap());
  }

  // Delete data
  Future<void> deleteDaycare(String nama) async {
    await _collection.doc(nama).delete();
  }

  Future<void> updateDaycare(String nama, Map<String, dynamic> updates) async {
    await _collection.doc(nama).update(updates);
  }

  // Stream data
  Stream<List<Daycare>> getDaycare() {
    return _collection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Daycare.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }
}