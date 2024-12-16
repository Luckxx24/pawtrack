import 'package:flutter/material.dart';
import 'package:pawtrack/models/grooming_models.dart';
import 'package:pawtrack/models/users_models.dart';
import 'package:pawtrack/services/pesan_grooming_service.dart';

class UserGroomingHistory extends StatefulWidget {
  const UserGroomingHistory({Key? key, required Users currentUser}) : super(key: key);

  @override
  _UserGroomingHistoryState createState() => _UserGroomingHistoryState();
}

class _UserGroomingHistoryState extends State<UserGroomingHistory> {
  final FirebaseService _groomingServices = FirebaseService();
  
  // Daftar status untuk filter
  final List<String> _statusOptions = [
    'semua',
    'menunggu',
    'diterima',
    'ditolak'
  ];
  
  // Status yang dipilih saat ini
  String _selectedStatus = 'semua';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Permintaan Booking Grooming'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Dropdown filter status
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Filter Status',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              value: _selectedStatus,
              items: _statusOptions.map((status) {
                return DropdownMenuItem(
                  value: status,
                  child: Text(status),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedStatus = value!;
                });
              },
            ),
          ),

          // Stream builder untuk menampilkan daftar permintaan
          Expanded(
            child: StreamBuilder<List<Grooming>>(
              stream: _groomingServices.getGrooming(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('Tidak ada permintaan grooming'),
                  );
                }

                // Filter berdasarkan status yang dipilih
                final filteredRequests = _selectedStatus == 'semua'
                    ? snapshot.data!
                    : snapshot.data!
                        .where((request) => request.status == _selectedStatus)
                        .toList();

                if (filteredRequests.isEmpty) {
                  return const Center(
                    child: Text('Tidak ada permintaan dengan status ini'),
                  );
                }

                return ListView.builder(
                  itemCount: filteredRequests.length,
                  itemBuilder: (context, index) {
                    final request = filteredRequests[index];
                    return _buildGroomingRequestCard(request);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroomingRequestCard(Grooming request) {
    // Tentukan warna berdasarkan status
    Color statusColor;
    switch (request.status) {
      case 'menunggu':
        statusColor = Colors.orange;
        break;
      case 'diterima':
        statusColor = Colors.green;
        break;
      case 'ditolak':
        statusColor = Colors.red;
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
            Text('Durasi: ${request.durasi}'),
            Text(
              'Jadwal: ${request.jadwal}',
            ),
            Text('Biaya: Rp ${request.harga}'),
            Text('Pemohon: ${request.user}'),
            Text('Status: ${request.status}'),

            
            // Tampilkan tombol hanya untuk status 'menunggu'
            if (request.status == 'menunggu')
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => _batalRequestGrooming(request),
                      icon: const Icon(Icons.delete),
                      color: Colors.red,
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _batalRequestGrooming(Grooming request) {
    // Update status di Firebase
    _groomingServices.deletePesanGrooming(request.nama).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Permintaan dibatalkan'),
          backgroundColor: Colors.red,
        ),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal membatalkan permintaan: $error'),
          backgroundColor: Colors.red,
        ),
      );
    });
  }
}