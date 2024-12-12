Grooming page
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
Grooming detail

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import '../models/grooming_models.dart';
import '../utils/styles.dart';

class GroomingDetailPage extends StatelessWidget {
  final Grooming grooming;

  const GroomingDetailPage({super.key, required this.grooming});

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
            // Removed the Spacer that was causing layout issues.
            // It's better to control the spacing with a Gap instead.
            const Gap(16),  // Add gap before button for spacing
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Add booking functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Service booked successfully!'),
                    ),
                  );
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
vet page (masih error)
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../services/vet_service.dart';
import '../models/vet_models.dart';
import '../utils/styles.dart';
import '../widgets/back_button.dart';

class VetPage extends StatefulWidget {
  const VetPage({super.key});

  @override
  State<VetPage> createState() => _VetPageState();
}

class _VetPageState extends State<VetPage> {
  late ScrollController _controller;
  double headerHeight = 140;
  final FirebaseService _firebaseService = FirebaseService();

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(() {
      if (_controller.offset > 0) {
        setState(() {
          headerHeight = 0;
        });
      } else {
        setState(() {
          headerHeight = 140;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                const Gap(100),
                AnimatedContainer(
                  margin: EdgeInsets.only(bottom: headerHeight == 0 ? 0 : 16),
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInExpo,
                  width: double.infinity,
                  height: headerHeight,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage('assets/png/vet.png'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: Styles.bgColor, width: 3),
                  ),
                ),
                Expanded(
                  child: MediaQuery.removeViewPadding(
                    context: context,
                    removeTop: true,
                    child: StreamBuilder<List<Vet>>(
                      stream: _firebaseService.getVet(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        }

                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        final vets = snapshot.data ?? [];

                        return ListView.separated(
                          controller: _controller,
                          itemCount: vets.length,
                          separatorBuilder: (c, i) => const Gap(12),
                          itemBuilder: (context, index) {
                            final vet = vets[index];
                            return Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      vet.nama,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Gap(8),
                                    Text(
                                      vet.deskripsi,
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    const Gap(12),
                                    Text(
                                      'Available Schedule:',
                                      style: TextStyle(
                                        color: Styles.blackColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const Gap(8),
                                    ...vet.jadwal.entries.map((entry) => Padding(
                                      padding: const EdgeInsets.only(bottom: 4),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 80,
                                            child: Text(
                                              entry.key,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              entry.value.join(', '),
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                                    const Gap(12),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Rp ${vet.harga.toStringAsFixed(0)}',
                                          style: TextStyle(
                                            color: Styles.highlightColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {},
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Styles.bgColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                          ),
                                          child: const Text('Book Now'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 50,
            left: 15,
            right: 15,
            child: Row(
              children: [
                const PetBackButton(),
                const Gap(20),
                Text(
                  'Pet Veterinary',
                  style: TextStyle(
                    color: Styles.blackColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}