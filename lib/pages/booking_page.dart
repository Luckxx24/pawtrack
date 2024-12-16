import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/grooming_models.dart';
import '../models/Booking_Model.dart';
import '../models/users_models.dart';

class BookingPage extends StatelessWidget {
  final Grooming grooming;
  final Users currentUser;

  const BookingPage({super.key, required this.grooming, required this.currentUser});

  void _bookService(BuildContext context) async {
    final bookingId = DateTime.now().millisecondsSinceEpoch.toString();

    // Membuat instance BookNow
    final booking = BookNow(
      id: bookingId,
      serviceName: grooming.nama,
      customerName: currentUser.nama, // Placeholder untuk nama pelanggan
      status: 'Pending',
      bookingDate: DateTime.now(),
    );

    try {
      // Menyimpan booking menggunakan model BookNow
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(bookingId)
          .set(booking.toMap());

      // Navigasi kembali dengan hasil sukses
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Booking failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm Booking'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Service: ${grooming.nama}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Duration: ${grooming.durasi}'),
            Text('Price: Rp ${grooming.harga.toStringAsFixed(0)}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _bookService(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                fixedSize: const Size(200, 50),
                shape: const StadiumBorder(),
              ),
              child: const Text(
                'Confirm Booking',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
