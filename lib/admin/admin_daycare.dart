import 'package:flutter/material.dart';
import 'package:pawtrack/models/users_models.dart';
import '../models/daycare_models.dart';
import '../services/daycare_service.dart';

class AdminCarePage extends StatefulWidget {
  const AdminCarePage({Key? key, required Users currentUser}) : super(key: key);

  @override
  _AdminCarePageState createState() => _AdminCarePageState();
}

class _AdminCarePageState extends State<AdminCarePage> {
  final FirebaseService _daycareServices = FirebaseService();
  
  // Daftar status untuk filter
  final List<String> _statusOptions = [
    'menunggu',
    'diterima',
    'ditolak'
  ];
  
  // Status yang dipilih saat ini
  String _selectedStatus = 'menunggu';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Permintaan Penitipan Hewan'),
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
            child: StreamBuilder<List<Daycare>>(
              stream: _daycareServices.getDaycare(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('Tidak ada permintaan penitipan'),
                  );
                }

                // Filter berdasarkan status yang dipilih
                final filteredRequests = _selectedStatus == 'menunggu'
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
                    return _buildDaycareRequestCard(request);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDaycareRequestCard(Daycare request) {
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
            Text('Jenis Hewan: ${request.jenis}'),
            Text('Durasi: ${request.durasi}'),
            Text('Deskripsi: ${request.deskripsi}'),
            Text(
              'Jadwal: ${request.jadwal}',
            ),
            Text('Biaya: Rp ${request.harga}'),
            Text('Pemohon: ${request.user}'),
            
            // Tampilkan tombol hanya untuk status 'menunggu'
            if (request.status == 'menunggu')
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () => _updateRequestStatus(request, 'ditolak'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: const Text('Tolak'),
                    ),
                    ElevatedButton(
                      onPressed: () => _updateRequestStatus(request, 'diterima'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      child: const Text('Terima'),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _updateRequestStatus(Daycare request, String status) {
    // Update status di Firebase
    _daycareServices.updateDaycare(request.nama, {'status': status}).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Permintaan ${status == 'diterima' ? 'diterima' : 'ditolak'}'),
          backgroundColor: status == 'diterima' ? Colors.green : Colors.red,
        ),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memperbarui status: $error'),
          backgroundColor: Colors.red,
        ),
      );
    });
  }
}