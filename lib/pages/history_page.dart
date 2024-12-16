import 'package:flutter/material.dart';
import 'package:pawtrack/models/users_models.dart';
import 'package:pawtrack/pages/user_adopt_history.dart';
import 'package:pawtrack/pages/user_grooming_history.dart';
import 'package:pawtrack/pages/user_care_history.dart';
import 'package:gap/gap.dart';

class UserHistoryPage extends StatelessWidget {

  const UserHistoryPage({Key? key, required this.currentUser}) : super(key: key);

  final Users currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildCard(
            context,
            title: 'Riwayat Adopsi',
            subtitle: 'Lihat riwayat adopsi Anda',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => UserAdoptHistory(currentUser: currentUser),
                ),
              );
            },
          ),
          const Gap(10),
          _buildCard(
            context,
            title: 'Riwayat Grooming',
            subtitle: 'Lihat riwayat grooming Anda',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => UserGroomingHistory(currentUser: currentUser),
                ),
              );
            },
          ),
          const Gap(10),
          _buildCard(
            context,
            title: 'Riwayat Penitipan',
            subtitle: 'Lihat riwayat penitipan Anda',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => UserCareHistory(currentUser: currentUser),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, {required String title, required String subtitle, required VoidCallback onTap}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}
