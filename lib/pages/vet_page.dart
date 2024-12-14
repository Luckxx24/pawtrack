import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../services/vet_service.dart';
import '../models/vet_models.dart';
import '../utils/styles.dart';
import '../widgets/back_button.dart';
import 'vet_detail.dart';

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
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => VetDetailPage(vet: vet),
                                  ),
                                );
                              },
                              child: Card(
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
