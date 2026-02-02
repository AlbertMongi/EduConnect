import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:educonnect_parent_app/ui/widgets/attendance_summary.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:educonnect_parent_app/constant/app_constant.dart';
import 'package:educonnect_parent_app/ui/invoices/invoices_screen.dart';
import 'package:educonnect_parent_app/ui/results/results_screen.dart';
import 'package:educonnect_parent_app/ui/widgets/appbar.dart';
import 'package:educonnect_parent_app/ui/widgets/comming_soon.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // slider images
  final List<String> imgList = [
    'assets/images/image5.png',
    'assets/images/image6.png',
    'assets/images/image7.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: customAppBar(context),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ----------------------------------
            // MODERN CAROUSEL
            // ----------------------------------
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: CarouselSlider.builder(
                  itemCount: imgList.length,
                  itemBuilder: (_, index, __) {
                    return Image.asset(
                      imgList[index],
                      fit: BoxFit.cover,
                      width: double.infinity,
                    );
                  },
                  options: CarouselOptions(
                    autoPlay: true,
                    height: 180,
                    viewportFraction: 1,
                    autoPlayCurve: Curves.easeInOut,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ----------------------------------
            // ATTENDANCE SUMMARY CARD
            // ----------------------------------
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12.withOpacity(.05),
                      blurRadius: 6,
                      offset: const Offset(0, 3)),
                ],
              ),
              child: AttendanceWidget(),
            ),

            const SizedBox(height: 20),

            // ----------------------------------
            // FEATURE GRID 1
            // ----------------------------------
            _sectionHeader("Student Tools"),
            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildFeatureCard(
                  iconPath: 'assets/svg/curriculum.png',
                  label: 'Curriculum',
                  onTap: _openComingSoon,
                ),
                _buildFeatureCard(
                  iconPath: 'assets/svg/attendance.png',
                  label: 'Attendance',
                  onTap: _openComingSoon,
                ),
                _buildFeatureCard(
                  iconPath: 'assets/svg/timetable.png',
                  label: 'Timetable',
                  onTap: _openComingSoon,
                ),
              ],
            ),

            const SizedBox(height: 25),

            // ----------------------------------
            // FEATURE GRID 2
            // ----------------------------------
            _sectionHeader("Parent Services"),
            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildFeatureCard(
                  iconPath: 'assets/svg/payments.png',
                  label: 'Fees & Payments',
                  onTap: () => Get.to(() => const InvoicesScreen()),
                ),
                _buildFeatureCard(
                  iconPath: 'assets/svg/livecorner.png',
                  label: 'Live Corner',
                  onTap: _openComingSoon,
                ),
                _buildFeatureCard(
                  iconPath: 'assets/svg/result2.png',
                  label: 'Exam Results',
                  onTap: () => Get.to(() => const ResultsScreen()),
                ),
              ],
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // ----------------------------------
  // SECTION HEADER
  // ----------------------------------
  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Colors.blue.shade900,
          fontFamily: AppConstant.fontName,
        ),
      ),
    );
  }

  // ----------------------------------
  // FEATURE CARD
  // ----------------------------------
  Widget _buildFeatureCard({
    required String iconPath,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 90,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withOpacity(.06),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(14),
              ),
              padding: const EdgeInsets.all(10),
              child: Image.asset(
                iconPath,
                color: Colors.blue.shade900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                fontFamily: AppConstant.fontName,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openComingSoon() {
    showModalBottomSheet(
      context: context,
      builder: (_) => ComingSoonBottomSheet(),
    );
  }
}
