import 'package:flutter/material.dart';
import 'package:pawtrack/models/users_models.dart';
import 'package:pawtrack/services/adopt_service.dart';
import 'package:pawtrack/models/adopt_models.dart';


class UserAdoptHistory extends StatefulWidget {
  const UserAdoptHistory({Key? key, required this.currentUser}) : super(key: key);

  final Users currentUser;

  @override
  _UserAdoptHistoryState createState() => _UserAdoptHistoryState();
}

class _UserAdoptHistoryState extends State<UserAdoptHistory> {
  final FirebaseService _adoptServices = FirebaseService();
  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Adopsi'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Dropdown filter status

          // Stream builder untuk menampilkan daftar permintaan
          Expanded(
            child: StreamBuilder<List<Adopt>>(
              stream: _adoptServices.getAdopt(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('Belum ada adopsi'),
                  );
                }

                // Filter berdasarkan status yang dipilih
                final filteredRequests = snapshot.data! .where((request) => request.user == widget.currentUser.nama) .toList();

                if (filteredRequests.isEmpty) {
                  return const Center(
                    child: Text('Tidak ada adopsi dengan status ini'),
                  );
                }

                return ListView.builder(
                  itemCount: filteredRequests.length,
                  itemBuilder: (context, index) {
                    final request = filteredRequests[index];
                    return _buildAdoptRiwayatCard(request);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdoptRiwayatCard(Adopt request) {
    // Tentukan warna berdasarkan status
    Color statusColor;
    switch (request.status) {
      case 'tersedia':
        statusColor = Colors.orange;
        break;
      case 'diadopsi':
        statusColor = Colors.green;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tambahkan status dengan warna
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                request.status.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Nama Hewan: ${request.nama}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text('Deskripsi: ${request.deskripsi}'),
            Text('Hewan: ${request.jenis}'),
            Text(
              'usia: ${request.usia} tahun',
            ),
            Text('Pemilik: ${request.user}'),
            Text('Status: ${request.status}'),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}