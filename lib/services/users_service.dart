import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/users_models.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _collection = FirebaseFirestore.instance.collection('users');

  // Register User with Firebase Auth and save to Firestore
  Future<User?> registerUser(String email, String password, Users users) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? firebaseUser = result.user;

      if (firebaseUser != null) {
        users = Users(
          nama: users.nama,
          id: firebaseUser.uid,
          profile_picture: users.profile_picture,
          role: users.role,
          email: users.email,
          password: users.password,
        );
        await saveUsers(users);
      }

      return firebaseUser;
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  // Save User to Firestore
  Future<void> saveUsers(Users users) async {
    await _collection.doc(users.id).set(users.toMap());
  }

  // Delete User from Firestore
  Future<void> deleteUsers(String id) async {
    await _collection.doc(id).delete();
  }

  // Update User in Firestore
  Future<void> updateUsers(String id, Map<String, dynamic> updates) async {
    await _collection.doc(id).update(updates);
  }

  // Stream Users from Firestore
  Stream<List<Users>> getUsers() {
    return _collection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Users.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // Login User with Firebase Auth
  Future<User?> loginUser(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return result.user;
    } catch (e) {
      print("Login Error: $e");
      return null;
    }
  }

  // Get User Data from Firestore
  Future<Users?> getUserData(String uid) async {
    try {
      DocumentSnapshot userDoc = await _collection.doc(uid).get();
      return Users.fromMap(userDoc.data() as Map<String, dynamic>);
    } catch (e) {
      print("Error getting user data: $e");
      return null;
    }
  }
}
