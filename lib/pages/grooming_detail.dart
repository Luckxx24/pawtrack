import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import '../models/grooming_models.dart';
import '../utils/styles.dart';
import 'booking_page.dart';
import '../models/users_models.dart';

class GroomingDetailPage extends StatelessWidget {
  final Grooming grooming;
  final Users currentUser;

  const GroomingDetailPage({Key? key, required this.grooming, required this.currentUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grooming Detail'),
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
              grooming.nama,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(8),
            Text(
              grooming.deskripsi,
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
                  'Duration: ${grooming.durasi}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Price: Rp ${grooming.harga.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const Gap(16),
            Text(
              'Schedule: ${grooming.jadwal}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
            const Gap(16),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  // Navigasi ke halaman konfirmasi booking
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingPage(grooming: grooming, currentUser: currentUser),
                    ),
                  );

                  if (result == true) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Service booked successfully!')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Styles.bgColor,
                  fixedSize: const Size(200, 50),
                  shape: const StadiumBorder(),
                ),
                child: const Text(
                  'Book Now',
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