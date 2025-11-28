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
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //sliders
  final List<String> imgList = [
    'assets/images/image5.png',
    'assets/images/image6.png',
    'assets/images/image7.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: customAppBar(context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // Centers the slider
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 180,
                  child: CarouselSlider.builder(
                    itemCount: imgList.length,
                    itemBuilder: (
                      BuildContext context,
                      int index,
                      int realIdx,
                    ) {
                      return Container(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.asset(
                            imgList[index],
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                      );
                    },
                    options: CarouselOptions(
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 3),
                      enlargeCenterPage: true,
                      aspectRatio: 16 / 9,
                      viewportFraction: 1.0,
                    ),
                  ),
                ),
              ],
            ),

           
            const SizedBox(height: 10),

            SingleChildScrollView(
              child: Column(
                children:[
                  AttendanceWidget(),
                ]
              ),
            ),

  
            // Icons for curriculum, attendance, and timetable
             const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildIconCard('assets/svg/curriculum.png', 'Curricullum', () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return ComingSoonBottomSheet();
                    },
                  );
                }),
                _buildIconCard('assets/svg/attendance.png', 'Attendance', () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return ComingSoonBottomSheet();
                    },
                  );
                }),
                _buildIconCard('assets/svg/timetable.png', 'Timetable', () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return ComingSoonBottomSheet();
                    },
                  );
                }),
              ],
            ),
            const SizedBox(height: 10),

            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildIconCard('assets/svg/payments.png', 'Fees & Payments', () {
                  Get.to(InvoicesScreen());
                }),
                _buildIconCard('assets/svg/livecorner.png', 'Live Corner', () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return ComingSoonBottomSheet();
                    },
                  );
                }),
                  _buildIconCard('assets/svg/result2.png', 'Exam Results', () {
                  Get.to(ResultsScreen());
                    }),
                // _buildIconCard('assets/svg/result2.png', 'Exam Results', () {
                //   showModalBottomSheet(
                //     context: context,
                //     builder: (BuildContext context) {
                //       return ComingSoonBottomSheet();
                //     },
                //   );
                // }),
              ],
            ),

            //sliders
            SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontFamily: AppConstant.fontName,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontFamily: AppConstant.fontName,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildIconCard(String imagePath, String label, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Container(
            width: 70,
            height: 70,
            color: Colors.blue[100],
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
                color: Colors.blue.shade900,
                width: 40,

              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontFamily: AppConstant.fontName,
          ),
        ),
      ],
    ),
  );
}


}
