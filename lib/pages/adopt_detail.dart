import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:pawtrack/models/adopt_models.dart';
import 'package:pawtrack/services/adopt_service.dart';
import 'package:pawtrack/utils/styles.dart';
import 'package:pawtrack/models/users_models.dart';

class AdoptDetailPage extends StatelessWidget {
  final Adopt adopt;
  final Users currentUser;

  final FirebaseService _firebaseService = FirebaseService();

  AdoptDetailPage({super.key, required this.adopt, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Identitas Hewan'),
        backgroundColor: Styles.bgColor,
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Gambar Hewan
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
                  adopt.jenis == 'dog'
                      ? 'assets/svg/dog1.svg'
                      : 'assets/svg/cat1.svg',
                  height: 150,
                ),
              ),
            ),
            const Gap(20),

            // Informasi Hewan di dalam Card
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
                        adopt.nama,
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

                    _buildDetailRow('Usia', '${adopt.usia} tahun'),
                    _buildDetailRow('Jenis', adopt.jenis),
                    _buildDetailRow('Deskripsi', adopt.deskripsi),
                    _buildDetailRow(
                        'Status',
                        adopt.status == 'diadopsi'
                            ? 'Sudah Diadopsi'
                            : 'Tersedia'),
                  ],
                ),
              ),
            ),
            const Gap(30),

            // Tombol Adopsi
            Center(
              child: ElevatedButton(
                onPressed: adopt.status == 'diadopsi'
                    ? null
                    : () async {
                        await _firebaseService.updateAdopt(adopt.nama, {
                          'status': 'diadopsi',
                          'user': currentUser.nama,
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Hewan berhasil diadopsi'),
                          ),
                        );
                        Navigator.pop(context);
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Styles.highlightColor,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey.shade400,
                  fixedSize: const Size(200, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 2,
                ),
                child: Text(
                  adopt.status == 'diadopsi' ? 'Sudah Diadopsi' : 'Adopsi',
                  style: const TextStyle(
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
