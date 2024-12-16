import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pawtrack/models/users_models.dart';
import '../models/adopt_models.dart';
import '../services/adopt_service.dart';
import '../utils/styles.dart';

class AdminAdoptPage extends StatefulWidget {
  const AdminAdoptPage({super.key, required Users currentUser});

  @override
  State<AdminAdoptPage> createState() => _AdminAdoptPageState();
}

class _AdminAdoptPageState extends State<AdminAdoptPage> {
  final FirebaseService _firebaseService = FirebaseService();

  String? _selectedHewan;

  // Daftar jadwal yang tersedia
  List<String> _jenisOptions = [
    'Kucing',
    'Anjing',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Koleksi Hewan PawTrack'),
        backgroundColor: Styles.bgColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showFormDialog(context),
          ),
        ],
      ),
      body: StreamBuilder<List<Adopt>>(
        stream: _firebaseService.getAdopt(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final hewans = snapshot.data ?? [];

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: hewans.length,
            itemBuilder: (context, index) {
              final hewan = hewans[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: Text(hewan.nama, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(hewan.deskripsi),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _showFormDialog(context, hewan: hewan),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteService(hewan),
                      ),
                    ],
                  ),
                  onTap: () => _showFormDialog(context, hewan: hewan),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showFormDialog(BuildContext context, {Adopt? hewan}) {
    final TextEditingController namaController = TextEditingController(text: hewan?.nama ?? '');
    final TextEditingController deskripsiController = TextEditingController(text: hewan?.deskripsi ?? '');
    final TextEditingController jenisController = TextEditingController(text: hewan?.jenis ?? '');
    final TextEditingController usiaController = TextEditingController(text: hewan?.usia.toString() ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(hewan == null ? 'Tambah Koleksi Hewan' : 'Edit identitas Hewan'),
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
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Pilih Jenis Hewan',
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
                  value: _selectedHewan,
                  items: _jenisOptions.map((jenis) {
                    return DropdownMenuItem(
                      value: jenis,
                      child: Text(jenis),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedHewan = value;
                      jenisController.text = _selectedHewan ?? '';
                    });
                  },
                ),
                const Gap(8),
                TextField(
                  controller: usiaController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Usia',
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
                String jenisHewan = '${jenisController.text}';
                final newHewan = Adopt(
                  id: hewan?.id ?? DateTime.now().toString(),
                  nama: namaController.text,
                  deskripsi: deskripsiController.text,
                  jenis: jenisHewan,
                  usia: double.tryParse(usiaController.text) ?? 0.0,
                  status: 'tersedia',
                  user: 'admin',
                );

                _firebaseService.saveAdopt(newHewan).then((_) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(hewan == null
                          ? 'Layanan Grooming baru berhasil ditambahkan'
                          : 'Informasi layanan berhasil diperbaharui'),
                    ),
                  );
                });
              },
              child: Text(hewan == null ? 'Tambah' : 'Simpan'),
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

  void _deleteService(Adopt hewan) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hapus Hewan'),
          content: Text('Apakah anda yakin ingin menghapus ${hewan.nama}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _firebaseService.deleteAdopt(hewan.nama).then((_) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Hewan Berhasil Dihapus')),
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
