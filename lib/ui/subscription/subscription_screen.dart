import 'dart:ui';
import 'package:educonnect_parent_app/constant/app_constant.dart';
import 'package:flutter/material.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({Key? key}) : super(key: key);

  @override
  _SubscriptionScreenState createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  int selectedPlan = 0;

  final List<Map<String, dynamic>> plans = [
    {
      "title": "Basic Plan",
      "price": "TSh 10,000",
      "duration": "Monthly",
      "features": ["Attendance", "Exam Results", "Basic Reports"],
      "color": Colors.blue,
    },
    {
      "title": "Standard Plan",
      "price": "TSh 20,000",
      "duration": "Quarterly",
      "features": [
        "Everything in Basic",
        "Full Analytics",
        "Live Corner Access",
      ],
      "color": Colors.purple,
    },
    {
      "title": "Premium Plan",
      "price": "TSh 50,000",
      "duration": "Yearly",
      "features": [
        "All Features Unlocked",
        "Priority Support",
        "Full E-learning Access",
        "FAST Updates",
      ],
      "color": Colors.orange,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Choose Your Plan",
          style: TextStyle(fontWeight: FontWeight.bold, fontFamily: AppConstant.fontName, fontSize: 17),
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: ListView.builder(
          itemCount: plans.length,
          itemBuilder: (context, index) {
            return _buildPlanCard(
              index,
              plans[index]["title"],
              plans[index]["price"],
              plans[index]["duration"],
              List<String>.from(plans[index]["features"]),
              plans[index]["color"],
            );
          },
        ),
      ),

      bottomNavigationBar: _buildContinueButton(),
    );
  }

  // -----------------------------------------
  // PLAN CARD (Glass Effect)
  // -----------------------------------------
  Widget _buildPlanCard(
    int index,
    String title,
    String price,
    String duration,
    List<String> features,
    Color color,
  ) {
    final bool active = selectedPlan == index;

    return GestureDetector(
      onTap: () => setState(() => selectedPlan = index),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 12),

        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: active ? color : Colors.white.withOpacity(.35),
                  width: active ? 2 : 1.2,
                ),
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(.55),
                    Colors.white.withOpacity(.35),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12.withOpacity(.1),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + Selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          fontFamily: AppConstant.fontName,
                          color: color,
                        ),
                      ),
                      _buildSelector(active, color),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Price
                  Text(
                    price,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: color,
                      fontFamily: AppConstant.fontName
                    ),
                  ),

                  Text(
                    duration,
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 14, fontFamily: AppConstant.fontName),
                  ),

                  const SizedBox(height: 14),

                  // Features
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                        features
                            .map(
                              (f) => Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      size: 18,
                                      color: color.withOpacity(.8),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        f,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey.shade800,
                                          fontFamily: AppConstant.fontName
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // -----------------------------------------
  // SELECTOR DOT
  // -----------------------------------------
  Widget _buildSelector(bool active, Color color) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: active ? color : Colors.grey.shade400,
          width: 2,
        ),
      ),
      child:
          active
              ? Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              )
              : null,
    );
  }

  // -----------------------------------------
  // CONTINUE BUTTON
  // -----------------------------------------
  Widget _buildContinueButton() {
    return Container(
      padding: const EdgeInsets.all(18),
      height: 90,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue.shade800,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 5,
        ),
        child: const Text(
          "Continue",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: AppConstant.fontName
          ),
        ),
      ),
    );
  }
}
