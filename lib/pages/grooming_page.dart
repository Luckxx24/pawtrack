//Grooming page
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import '../services/grooming_service.dart';
import '../models/grooming_models.dart';
import '../utils/layouts.dart';
import '../utils/styles.dart';
import '../widgets/back_button.dart';
import '../pages/grooming_detail.dart';

class GroomingPage extends StatefulWidget {
  const GroomingPage({super.key});

  @override
  State<GroomingPage> createState() => _GroomingPageState();
}

class _GroomingPageState extends State<GroomingPage> {
  final FirebaseService _firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    final size = Layouts.getSize(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            Stack(
              children: [
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 500),
                  builder: (context, value, _) {
                    return Stack(
                      children: [
                        Container(
                          width: value * size.width,
                          height: value * size.width,
                          decoration: BoxDecoration(
                            color: Styles.bgColor,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(value * size.width / 2),
                              bottomRight: Radius.circular(value * size.width / 2),
                            ),
                          ),
                          child: Column(
                            children: [
                              Gap(value * 50),
                              AnimatedSize(
                                curve: Curves.bounceInOut,
                                duration: const Duration(seconds: 1),
                                child: SvgPicture.asset(
                                  'assets/svg/person2.svg',
                                  height: value * 200,
                                ),
                              ),
                              Gap(value * 20),
                              const Spacer()
                            ],
                          ),
                        ),
                        const Positioned(
                          left: 15,
                          top: 50,
                          child: PetBackButton(),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
            const Gap(5),

            // Title Section
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              curve: Curves.easeInExpo,
              duration: const Duration(milliseconds: 500),
              builder: (context, value, _) {
                return Text(
                  'Grooming Services',
                  style: TextStyle(
                    color: Styles.blackColor,
                    fontSize: value * 25,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                );
              },
            ),
            const Gap(5),

            // Services List Section
            StreamBuilder<List<Grooming>>(
              stream: _firebaseService.getGrooming(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  final services = snapshot.data!;
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: services.length,
                    itemBuilder: (context, index) {
                      final service = services[index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GroomingDetailPage(grooming: service),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 2,
                          margin: const EdgeInsets.only(bottom: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  service.nama,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Gap(8),
                                Text(
                                  service.deskripsi,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }

                // If no services available
                return const Text('No services available');
              },
            ),
            const Gap(20),

            // Footer Section with Button
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                elevation: 0,
                fixedSize: const Size(215, 44),
                backgroundColor: Styles.bgColor,
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Gap(0),
                  Text(
                    'Book a Service',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Styles.highlightColor,
                      fontSize: 15,
                    ),
                  ),
                  CircleAvatar(
                    radius: 15,
                    backgroundColor: Styles.bgWithOpacityColor,
                    child: SvgPicture.asset(
                      'assets/svg/arrow_down2.svg',
                      height: 7,
                    ),
                  ),
                ],
              ),
            ),
            const Gap(20),
          ],
        ),
      ),
    );
  }
}