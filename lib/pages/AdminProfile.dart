import 'package:flutter/material.dart';
import 'package:pawtrack/utils/styles.dart';
import 'package:pawtrack/models/users_models.dart';
import 'package:pawtrack/services/users_service.dart';
import 'package:gap/gap.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pawtrack/pages/login_page.dart';

class AdminProfilePage extends StatelessWidget {
  final Users currentUser;
  final FirebaseService _firebaseService = FirebaseService();

  AdminProfilePage({
    Key? key,
    required this.currentUser,
  }) : super(key: key);

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    // Ganti pushReplacementNamed dengan ini:
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginPage()),
            (route) => false
    );
  }

  void _showEditDialog(BuildContext context, Users user) {
    final nameController = TextEditingController(text: user.nama);
    final emailController = TextEditingController(text: user.email);
    final roleController = TextEditingController(text: user.role);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit User'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: roleController,
                decoration: InputDecoration(labelText: 'Role'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await _firebaseService.updateUsers(user.nama, {
                'nama': nameController.text,
                'email': emailController.text,
                'role': roleController.text,
              });
              Navigator.pop(context);
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, String nama) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete User'),
        content: Text('Are you sure you want to delete this user?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await _firebaseService.deleteUsers(nama);
              Navigator.pop(context);
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Admin Profile Section
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: currentUser.profile_picture.isNotEmpty
                      ? NetworkImage(currentUser.profile_picture)
                      : null,
                  child: currentUser.profile_picture.isEmpty
                      ? Text(
                    currentUser.nama[0].toUpperCase(),
                    style: const TextStyle(fontSize: 35),
                  )
                      : null,
                ),
                const Gap(15),
                Text(
                  currentUser.nama,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Gap(5),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'ADMIN',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Users List Section
          Expanded(
            child: StreamBuilder<List<Users>>(
              stream: _firebaseService.getUsers(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final users = snapshot.data!;

                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return Card(
                      margin:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: user.profile_picture.isNotEmpty
                              ? NetworkImage(user.profile_picture)
                              : null,
                          child: user.profile_picture.isEmpty
                              ? Text(user.nama[0].toUpperCase())
                              : null,
                        ),
                        title: Text(user.nama),
                        subtitle: Text('${user.email} • ${user.role}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () => _showEditDialog(context, user),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () =>
                                  _showDeleteConfirmation(context, user.nama),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new user logic
          // You can implement a similar dialog as edit but for creating new users
        },
        child: Icon(Icons.add),
      ),
    );
  }
}