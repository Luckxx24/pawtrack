import 'package:flutter/material.dart';
import 'package:pawtrack/utils/styles.dart';
import 'package:pawtrack/models/users_models.dart';
import 'package:gap/gap.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatelessWidget {
  final Users currentUser;

  const ProfilePage({
    Key? key,
    required this.currentUser,
  }) : super(key: key);

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacementNamed('/login'); // Adjust route as needed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Picture
            CircleAvatar(
              radius: 60,
              backgroundImage: currentUser.profile_picture.isNotEmpty
                  ? NetworkImage(currentUser.profile_picture)
                  : null,
              child: currentUser.profile_picture.isEmpty
                  ? Text(
                currentUser.nama[0].toUpperCase(),
                style: const TextStyle(fontSize: 40),
              )
                  : null,
            ),
            const Gap(20),

            // User Name
            Text(
              currentUser.nama,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(5),

            // Role Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Styles.highlightColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                currentUser.role.toUpperCase(),
                style: TextStyle(
                  color: Styles.highlightColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Gap(30),

            // User Information Cards
            _buildInfoCard(
              title: 'Email',
              value: currentUser.email,
              icon: Icons.email,
            ),
            const Gap(15),
            _buildInfoCard(
              title: 'User ID',
              value: currentUser.id,
              icon: Icons.fingerprint,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: Styles.highlightColor),
            const Gap(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const Gap(4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}