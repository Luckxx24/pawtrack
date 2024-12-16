import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pawtrack/models/users_models.dart';
import '../models/grooming_models.dart';
import '../services/pesan_grooming_service.dart';
import '../utils/styles.dart';

class GroomingBookingPage extends StatefulWidget {
  final Grooming grooming;

  const GroomingBookingPage({super.key, required this.grooming, required this.currentUser});

  final Users currentUser;

  @override
  _GroomingBookingPageState createState() => _GroomingBookingPageState();
}

class _GroomingBookingPageState extends State<GroomingBookingPage> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseService _service = FirebaseService();

  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _dateController;
  late TextEditingController _timeController;

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _dateController = TextEditingController();
    _timeController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
        _timeController.text = picked.format(context);
      });
    }
  }

  void _submitBooking() async {
    if (_formKey.currentState!.validate()) {
      // Kombinasikan tanggal dan waktu
      String jadwalWaktu = '${_dateController.text} ${_timeController.text}';

      // Buat objek Grooming baru untuk booking
      Grooming bookingGrooming = Grooming(
        deskripsi: widget.grooming.deskripsi,
        durasi: widget.grooming.durasi,
        nama: _nameController.text,
        harga: widget.grooming.harga,
        jadwal: jadwalWaktu,
        id: DateTime.now().millisecondsSinceEpoch.toString(), // Generate unique ID
        user: widget.currentUser.nama, // Gunakan nama dari input
        status: 'menunggu', // Status awal booking
      );

      try {
        await _service.pesanGrooming(bookingGrooming);
        
        // Tampilkan konfirmasi
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Booking berhasil untuk ${widget.grooming.nama}'),
            backgroundColor: Colors.green,
          ),
        );

        // Kembali ke halaman sebelumnya
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal booking: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking ${widget.grooming.nama}'),
        backgroundColor: Styles.bgColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Detail Booking',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Styles.bgColor,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nama Lengkap',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Silakan masukkan nama';
                  }
                  return null;
                },
              ),
              // const SizedBox(height: 16),
              // TextFormField(
              //   controller: _phoneController,
              //   keyboardType: TextInputType.phone,
              //   decoration: InputDecoration(
              //     labelText: 'Nomor Telepon',
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(10),
              //     ),
              //   ),
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return 'Silakan masukkan nomor telepon';
              //     }
              //     return null;
              //   },
              // ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dateController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Tanggal Booking',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Silakan pilih tanggal';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _timeController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Waktu Booking',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.access_time),
                    onPressed: () => _selectTime(context),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Silakan pilih waktu';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitBooking,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Styles.bgColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Konfirmasi Booking',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}