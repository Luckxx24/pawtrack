import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:pawtrack/pages/grooming_page.dart';
import 'package:pawtrack/pages/vet_page.dart';
import 'package:pawtrack/utils/layouts.dart';
import 'package:pawtrack/utils/styles.dart';
import 'package:pawtrack/widgets/animated_title.dart';
import 'package:pawtrack/widgets/pet_card.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> navItems = [
      {'text': 'Adopt', 'icon': 'assets/nav_icons/dog_icon.svg'},
      {'text': 'Grooming', 'icon': 'assets/nav_icons/cut_icon.svg', 'page': const GroomingPage()},
      {'text': 'Vet', 'icon': 'assets/nav_icons/vet_icon.svg', 'page': const VetPage()},
      {'text': 'Akun', 'icon': 'assets/nav_icons/account-svgrepo-com.svg'},
    ];

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
        children: [
          _buildHeader(),
          const Gap(35),
          const AnimatedTitle(title: 'Apa yang kamu cari?'),
          const Gap(10),
          _buildPetOptions(),
          const Gap(25),
          const AnimatedTitle(title: 'Community'),
          const Gap(10),
          _buildCommunitySection(context),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context, navItems),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(seconds: 500),
          curve: Curves.bounceOut,
          builder: (context, value, _) {
            return AnimatedOpacity(
              duration: const Duration(milliseconds: 100),
              opacity: value,
            );
          },
        ),
        const Gap(7),
      ],
    );
  }

  Widget _buildPetOptions() {
    return Row(
      children: const [
        PetCard(
          petPath: 'assets/svg/cat1.svg',
          petName: 'Adopsi kucing',
          hewan: 'kucing',
        ),
        Gap(28),
        PetCard(
          petPath: 'assets/svg/dog1.svg',
          petName: 'Adopsi hewan',
          height: 68,
          hewan: 'anjing',
        ),
      ],
    );
  }

  Widget _buildCommunitySection(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 500),
      builder: (context, value, _) {
        return Stack(
          children: [
            Container(
              height: 150,
              alignment: Alignment.bottomCenter,
              child: Stack(
                children: [
                  Container(
                    height: 135,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Styles.bgColor,
                      borderRadius: BorderRadius.circular(27),
                    ),
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(
                      right: 12,
                      left: Layouts.getSize(context).width * 0.37,
                      top: 15,
                      bottom: 15,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Join our\ncommunity',
                          style: TextStyle(
                            fontSize: value * 27,
                            fontWeight: FontWeight.bold,
                            color: Styles.blackColor,
                            height: 1,
                          ),
                        ),
                        const Gap(12),
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 1500),
                          opacity: value,
                          child: Text(
                            'Share your pet moments with other pet parents.',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Styles.blackColor,
                              fontSize: 12,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    right: value * 12,
                    top: value * 12,
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: Styles.bgWithOpacityColor,
                      child: SvgPicture.asset(
                        'assets/svg/arrow_right.svg',
                        height: value * 14,
                        width: value * 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 12,
              bottom: 0,
              child: SvgPicture.asset(
                'assets/svg/person.svg',
                height: value * 150,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context, List<Map<String, dynamic>> navItems) {
    return Container(
      height: 85,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        color: Styles.bgColor,
      ),
      padding: const EdgeInsets.fromLTRB(25, 20, 25, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: navItems.map<Widget>((e) {
          return InkWell(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  e['icon'],
                  height: 20,
                  color: navItems.indexOf(e) == 0 ? Styles.highlightColor : null,
                ),
                Text(
                  e['text'],
                  style: TextStyle(
                    fontSize: 12,
                    color: navItems.indexOf(e) == 0 ? Styles.highlightColor : Styles.blackColor,
                    fontWeight: navItems.indexOf(e) == 0 ? FontWeight.bold : null,
                  ),
                )
              ],
            ),
            onTap: () {
              if (navItems.indexOf(e) == 1 || navItems.indexOf(e) == 2) {
                Navigator.push(context, MaterialPageRoute(builder: (_) => e['page']));
              }
            },
          );
        }).toList(),
      ),
    );
  }
}
