import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pawtrack/models/users_models.dart';
import 'package:pawtrack/models/vet_models.dart';
import '../utils/styles.dart';
import 'package:pawtrack/services/vet_service.dart';

class AdminVetPage extends StatefulWidget {
  const AdminVetPage({super.key, required Users currentUser});

  @override
  State<AdminVetPage> createState() => _AdminVetPageState();
}

class _AdminVetPageState extends State<AdminVetPage> {
  final FirebaseService _firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vet Services'),
        backgroundColor: Styles.bgColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showFormDialog(context),
          ),
        ],
      ),
      body: StreamBuilder<List<Vet>>(
        stream: _firebaseService.getVet(),
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

  void _showFormDialog(BuildContext context, {Vet? service}) {
    final TextEditingController namaController = TextEditingController(text: service?.nama ?? '');
    final TextEditingController deskripsiController = TextEditingController(text: service?.deskripsi ?? '');
    // final TextEditingController durasiController = TextEditingController(text: service?.durasi ?? '');
    final TextEditingController hargaController = TextEditingController(text: service?.harga.toString() ?? '');
    final TextEditingController jadwalController = TextEditingController(text: service?.jadwal ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(service == null ? 'Add Vet Service' : 'Edit Vet Service'),
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
                // const Gap(8),
                // TextField(
                //   controller: durasiController,
                //   decoration: InputDecoration(
                //     labelText: 'Durasi',
                //     border: OutlineInputBorder(
                //         borderRadius: const BorderRadius.all(Radius.circular(12)),
                //         borderSide: BorderSide(
                //         color: Styles.highlightColor,
                //         )
                //       )
                //     ),
                // ),
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
                final newVet = Vet(
                  id: service?.id ?? DateTime.now().toString(),
                  nama: namaController.text,
                  deskripsi: deskripsiController.text,
                  // durasi: durasiController.text,
                  harga: double.tryParse(hargaController.text) ?? 0.0,
                  jadwal: jadwalController.text,
                );

                _firebaseService.saveVet(newVet).then((_) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(service == null
                          ? 'Layanan Dokter Hewan baru berhasil ditambahkan'
                          : 'Informasi layanan berhasil diperbaharui'),
                    ),
                  );
                });
              },
              child: Text(service == null ? 'Tambah' : 'Simpan'),
            ),
          ],
        );
      },
    );
  }

  void _deleteService(Vet service) {
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
                _firebaseService.deleteVet(service.nama).then((_) {
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
