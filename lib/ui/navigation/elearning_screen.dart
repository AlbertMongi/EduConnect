import 'package:educonnect_parent_app/constant/app_constant.dart';
import 'package:educonnect_parent_app/ui/widgets/appbar.dart';
import 'package:flutter/material.dart';

class ElearningScreen extends StatefulWidget {
  const ElearningScreen({super.key});

  @override
  State<ElearningScreen> createState() => _ElearningScreenState();
}

class _ElearningScreenState extends State<ElearningScreen> {
  int selectedIndex = 0;

  final List<String> tabs = ['Assignments', 'Library', 'Syllabus'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Tab buttons with animated highlight
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(
                    0xFFF5F5F5,
                  ), // Background color for tab bar
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: List.generate(tabs.length, (index) {
                    bool isSelected = selectedIndex == index;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          margin: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color:
                                isSelected
                                    ? Colors.red.shade900
                                    : Colors.transparent,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow:
                                isSelected
                                    ? [
                                      BoxShadow(
                                        color:  Colors.red.shade900.withOpacity(0.35),
                                        blurRadius: 6,
                                        offset: const Offset(0, 3),
                                      ),
                                    ]
                                    : [],
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            tabs[index],
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black54,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              fontFamily: AppConstant.fontName,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),

            const SizedBox(height: 60),

            // Content for "Assignments"
            if (selectedIndex == 0)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/assignment.png', // Use your asset path here
                        height: 80,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'No assignment for you',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          fontFamily: AppConstant.fontName,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            if (selectedIndex == 1)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/assignment.png', // Use your asset path here
                        height: 80,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'No Library for you',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          fontFamily: AppConstant.fontName,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              if(selectedIndex == 2)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/assignment.png', // Use your asset path here
                        height: 80,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'No Syllabus for you',
                        style: TextStyle(fontSize: 16, color: Colors.black87, fontFamily: AppConstant.fontName),
                      ),
                    ],
                  ),
                ),
              ),

            // Future content areas for Library and Syllabus can go here
          ],
        ),
      ),
    );
  }
}
