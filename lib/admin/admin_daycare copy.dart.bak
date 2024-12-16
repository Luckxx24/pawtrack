import 'package:flutter/material.dart';
import 'package:pawtrack/models/users_models.dart';
import '../services/daycare_service.dart';
import '../models/daycare_models.dart';

class AdminCarePage extends StatefulWidget {
  const AdminCarePage({Key? key, required this.currentUser}) : super(key: key);

  final Users currentUser;

  @override
  _AdminCarePageState createState() => _AdminCarePageState();
}

class _AdminCarePageState extends State<AdminCarePage> {
  final FirebaseService _firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Permintaan Penitipan'),
      ),
      body: StreamBuilder<List<Daycare>>(
        stream: _firebaseService.getDaycare(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final requests = snapshot.data
                  ?.where((daycare) => daycare.status == 'menunggu')
                  .toList() ??
              [];

          if (requests.isEmpty) {
            return const Center(
              child: Text('Tidak ada permintaan'),
            );
          }

          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final daycare = requests[index];

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Nama: ${daycare.nama}'),
                      Text('Jenis: ${daycare.jenis}'),
                      Text('Deskripsi: ${daycare.deskripsi}'),
                      Text('Durasi: ${daycare.durasi}'),
                      Text(
                        'Tanggal: ${daycare.jadwal}',
                      ),
                      Text('Harga: Rp ${daycare.harga.toStringAsFixed(0)}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.check, color: Colors.green),
                        onPressed: () => _updateStatus(daycare, 'diterima'),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () => _updateStatus(daycare, 'ditolak'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Method untuk memperbarui status daycare
  void _updateStatus(Daycare daycare, String status) {
    _firebaseService
        .updateDaycare(daycare.nama, {'status': status})
        .then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Status diperbarui menjadi $status untuk ${daycare.nama}'),
        ),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memperbarui status: $error'),
        ),
      );
    });
  }
}