import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:pawtrack/models/users_models.dart';
import 'package:pawtrack/pages/pesan_grooming_page.dart';
import '../models/grooming_models.dart';
import '../utils/styles.dart';

class GroomingDetailPage extends StatelessWidget {
  final Grooming grooming;

  const GroomingDetailPage({super.key, required this.grooming, required this.currentUser});

  final Users currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Grooming'),
        backgroundColor: Styles.bgColor,
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Gambar Grooming
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Styles.bgWithOpacityColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/svg/person2.svg',
                  height: 150,
                ),
              ),
            ),
            const Gap(20),

            // Informasi Grooming dalam Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        grooming.nama,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const Gap(8),
                    Divider(color: Colors.grey.shade300),
                    const Gap(8),

                    Text(
                      grooming.deskripsi,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    const Gap(20),

                    // Detail Grooming: Duration, Price, Schedule
                    _buildDetailRow('Durasi', '${grooming.durasi}'),
                    _buildDetailRow('Harga', 'Rp ${grooming.harga.toStringAsFixed(0)}'),
                    _buildDetailRow('Jadwal', grooming.jadwal),
                  ],
                ),
              ),
            ),
            const Gap(30),

            // Tombol Pemesanan
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GroomingBookingPage(
                        grooming: grooming,
                        currentUser: currentUser,
                      ),
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Service berhasil dipesan!'),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Styles.highlightColor,
                  foregroundColor: Colors.white,
                  fixedSize: const Size(200, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  'Pesan Sekarang',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fungsi untuk membuat baris detail
  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
