import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:pawtrack/models/adopt_models.dart';
import 'package:pawtrack/services/adopt_service.dart';
import 'package:pawtrack/utils/styles.dart';

class AdoptDetailPage extends StatelessWidget {

  final Adopt adopt;

  final FirebaseService _firebaseService = FirebaseService();

  AdoptDetailPage({super.key, required this.adopt});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Identitas Hewan'),
        backgroundColor: Styles.bgColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Grooming Image Placeholder
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Styles.bgWithOpacityColor,
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/svg/person2.svg',
                  height: 150,
                ),
              ),
            ),
            const Gap(16),
            Text(
              'Nama : ${adopt.nama}',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(8),
            Text(
              'Usia : ${adopt.usia.toStringAsFixed(0)} tahun',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
            const Gap(16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Deskripsi : ${adopt.deskripsi}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Status : ${adopt.status}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            // const Gap(16),
            // Text(
            //   'Schedule: ${adopt.nama}',
            //   style: TextStyle(
            //     color: Colors.grey[600],
            //     fontSize: 16,
            //   ),
            // ),
            // Removed the Spacer that was causing layout issues.
            // It's better to control the spacing with a Gap instead.
            const Gap(16),  // Add gap before button for spacing
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  // Mengubah status hewan adopsi menjadi diadopsi sehingga ga muncul lagi
                  await _firebaseService.diadopsi(adopt.id, 'diadopsi');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Hewan berhasil diadopsi'),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Styles.bgColor,
                  fixedSize: const Size(200, 50),
                  shape: const StadiumBorder(),
                ),
                child: const Text(
                  'Adopsi',
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
}