import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pawtrack/models/users_models.dart';
import '../models/grooming_models.dart';
import '../services/grooming_service.dart';
import '../utils/styles.dart';

class AdminGroomingPage extends StatefulWidget {
  const AdminGroomingPage({super.key, required Users currentUser});

  @override
  State<AdminGroomingPage> createState() => _AdminGroomingPageState();
}

class _AdminGroomingPageState extends State<AdminGroomingPage> {
  final FirebaseService _firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grooming Services'),
        backgroundColor: Styles.bgColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showFormDialog(context),
          ),
        ],
      ),
      body: StreamBuilder<List<Grooming>>(
        stream: _firebaseService.getGrooming(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final services = snapshot.data ?? [];

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: services.length,
            itemBuilder: (context, index) {
              final service = services[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: Text(service.nama, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(service.deskripsi),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _showFormDialog(context, service: service),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteService(service),
                      ),
                    ],
                  ),
                  onTap: () => _showFormDialog(context, service: service),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showFormDialog(BuildContext context, {Grooming? service}) {
    final TextEditingController namaController = TextEditingController(text: service?.nama ?? '');
    final TextEditingController deskripsiController = TextEditingController(text: service?.deskripsi ?? '');
    final TextEditingController durasiController = TextEditingController(text: service?.durasi ?? '');
    final TextEditingController hargaController = TextEditingController(text: service?.harga.toString() ?? '');
    final TextEditingController jadwalController = TextEditingController(text: service?.jadwal ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(service == null ? 'Add Grooming Service' : 'Edit Grooming Service'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: namaController,
                  decoration: InputDecoration(
                    labelText: 'Nama',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Styles.bgColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Styles.highlightColor),
                    ),
                    ),
                ),
                const Gap(8),
                TextField(
                  controller: deskripsiController,
                  decoration: InputDecoration(
                      labelText: 'Deskripsi',
                      border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Styles.bgColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Styles.highlightColor),
                    ),
                    ),
                ),
                const Gap(8),
                TextField(
                  controller: durasiController,
                  decoration: InputDecoration(
                    labelText: 'Durasi',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Styles.bgColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Styles.highlightColor),
                    ),
                    ),
                ),
                const Gap(8),
                TextField(
                  controller: hargaController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Harga',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Styles.bgColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Styles.highlightColor),
                    ),
                  ),
                ),
                const Gap(8),
                TextField(
                  controller: jadwalController,
                  decoration: InputDecoration(
                    labelText: 'Jadwal',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Styles.bgColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Styles.highlightColor),
                    ),
                    ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final newGrooming = Grooming(
                  id: service?.id ?? DateTime.now().toString(),
                  nama: namaController.text,
                  deskripsi: deskripsiController.text,
                  durasi: durasiController.text,
                  harga: double.tryParse(hargaController.text) ?? 0.0,
                  jadwal: jadwalController.text,
                  user: "admin",
                  status: 'menunggu',
                );

                _firebaseService.saveGrooming(newGrooming).then((_) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(service == null
                          ? 'Layanan Grooming baru berhasil ditambahkan'
                          : 'Informasi layanan berhasil diperbaharui'),
                    ),
                  );
                });
              },
              child: Text(service == null ? 'Tambah' : 'Simpan'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Styles.highlightColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _deleteService(Grooming service) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hapus Layanan'),
          content: Text('Apakah anda yakin ingin menghapus ${service.nama}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _firebaseService.deleteGrooming(service.nama).then((_) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Layanan Berhasil Dihapus')),
                  );
                });
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
