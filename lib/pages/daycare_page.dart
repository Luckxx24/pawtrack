import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Untuk formatting tanggal
import 'package:pawtrack/services/daycare_service.dart';
import 'package:pawtrack/utils/styles.dart';
import '../models/daycare_models.dart';


class DaycarePage extends StatefulWidget {
  const DaycarePage({Key? key}) : super(key: key);

  @override
  _DaycarePageState createState() => _DaycarePageState();
}

class _DaycarePageState extends State<DaycarePage> {
  // Controller untuk input teks
  final TextEditingController _namaHewanController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();

  // Variabel untuk menyimpan jadwal terpilih
  DateTime? _selectedDate;
  String? _selectedJadwal;
  String? _selectedHewan;

  // Daftar jadwal yang tersedia
  final List<String> _jadwalOptions = [
    'Harian (1 hari)',
    'Mingguan (7 hari)',
    'Bulanan (30 hari)',
  ];

  // Harga untuk setiap durasi (contoh)
  final Map<String, double> _hargaJadwal = {
    'Harian (1 hari)': 50000,
    'Mingguan (7 hari)': 300000,
    'Bulanan (30 hari)': 1000000,
  };

  // Daftar jadwal yang tersedia
  List<String> _jenisOptions = [
    'Kucing',
    'Anjing',
  ];

  // Layanan Firebase untuk daycare
  final FirebaseService _daycareServices = FirebaseService();

  // Method untuk menampilkan date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Method untuk melakukan booking daycare
  void _bookDaycare() {
    // Validasi input
    if (_namaHewanController.text.isEmpty) {
      _showSnackBar('Nama hewan harus diisi');
      return;
    }

    if (_deskripsiController.text.isEmpty) {
      _showSnackBar('Deskripsi hewan harus diisi');
      return;
    }

    if (_selectedJadwal == null) {
      _showSnackBar('Pilih jadwal penitipan');
      return;
    }

    if (_selectedDate == null) {
      _showSnackBar('Pilih tanggal mulai penitipan');
      return;
    }

    if (_selectedHewan == null) {
      _showSnackBar("Pilih jenis hewan");
      return;
    }

    // Buat objek Daycare
    final daycare = Daycare(
      nama: _namaHewanController.text,
      id: '', // ID akan di-generate otomatis di service
      durasi: _selectedJadwal!, 
      deskripsi: _deskripsiController.text, 
      harga: _hargaJadwal[_selectedJadwal]!,
      jadwal: _selectedDate!,
      status: 'menunggu',
      jenis: _selectedHewan!,
    );

    // Simpan ke Firebase
    _daycareServices.saveDaycare(daycare).then((_) {
      // Tampilkan dialog konfirmasi dengan harga
      _showBookingConfirmation(daycare.harga);
    }).catchError((error) {
      _showSnackBar('Gagal melakukan booking: $error');
    });
  }

  // Method untuk menampilkan dialog konfirmasi
  void _showBookingConfirmation(double harga) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Booking Berhasil'),
        content: Text(
          'Layanan penitipan hewan Anda telah terdaftar.\n\n'
          // 'Total Biaya: Rp ${NumberFormat.currency(locale: 'id_ID', decimalDigits: 0).format(harga)}',
          'Total Biaya: Rp $harga,00',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Tutup dialog
              // Opsional: Navigasi ke halaman lain atau reset form
              _resetForm();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // Method untuk menampilkan snackbar
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // Method untuk mereset form
  void _resetForm() {
    setState(() {
      _namaHewanController.clear();
      _deskripsiController.clear();
      _selectedJadwal = null;
      _selectedDate = null;
      _selectedHewan = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Penitipan Hewan'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Input Nama Hewan
            TextField(
              controller: _namaHewanController,
              decoration: InputDecoration(
                labelText: 'Nama Hewan',
                // prefixIcon: Icon(Icons.email_outlined, color: Styles.highlightColor),
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
            const SizedBox(height: 16),

            // Input Deskripsi Hewan
            TextField(
              controller: _deskripsiController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Deskripsi Keadaan Hewan',
                // prefixIcon: Icon(Icons.email_outlined, color: Styles.highlightColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(width: 10.0)
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
            const SizedBox(height: 16),


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
                });
              },
            ),
            const SizedBox(height: 16,),

            // Dropdown Pilih Jadwal
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Pilih Jadwal Penitipan',
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
              value: _selectedJadwal,
              items: _jadwalOptions.map((jadwal) {
                return DropdownMenuItem(
                  value: jadwal,
                  child: Text(jadwal),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedJadwal = value;
                });
              },
            ),
            const SizedBox(height: 16),

            // Pilih Tanggal
            Row(
              children: [
                Expanded(
                  child: Text(
                    _selectedDate == null 
                      ? 'Pilih Tanggal Mulai' 
                      : 'Tanggal: ${DateFormat('dd/MM/yyyy').format(_selectedDate!)}',
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _selectDate(context),
                  child: const Text('Pilih Tanggal'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Tombol Titip Hewan
            ElevatedButton(
              onPressed: _bookDaycare,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Styles.highlightColor,
              ),
              child: const Text(
                'Titip Hewan', 
                style: TextStyle(
                  fontSize: 16, 
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Pastikan untuk dispose controller
    _namaHewanController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }
}