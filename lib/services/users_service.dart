import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/users_models.dart';

class FirebaseService {
  final CollectionReference _collection =
  FirebaseFirestore.instance.collection('adopt');

  // Create or update data
  Future<void> saveUsers(Users users) async {
    await _collection.doc(users.nama).set(users.toMap());
  }

  // Delete data
  Future<void> deleteUsers(String nama) async {
    await _collection.doc(nama).delete();
  }

  Future<void> updateUsers(String nama, Map<String, dynamic> updates) async {
    await _collection.doc(nama).update(updates);
  }

  // Stream data
  Stream<List<Users>> getUsers() {
    return _collection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Users.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }
}