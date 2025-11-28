import 'package:educonnect_parent_app/constant/app_constant.dart';
import 'package:flutter/material.dart';

class AttendanceWidget extends StatelessWidget {
  const AttendanceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row
          Row(
            children: const [
              Text(
                "Today",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  fontFamily: AppConstant.fontName,
                ),
              ),
              SizedBox(width: 4),
              Icon(Icons.chevron_right, size: 25, color: Colors.red),
            ],
          ),
          const SizedBox(height: 12),
          // Main Content
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Box
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    // Date
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Text(
                          "Apr",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            fontFamily: AppConstant.fontName,
                          ),
                        ),
                        Text(
                          "22",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            fontFamily: AppConstant.fontName,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    // Times
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Arrived at: 08:30am",
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: AppConstant.fontName,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Depart at: 03:40 pm",
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: AppConstant.fontName,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Right Section with Expanded to prevent overflow
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Lessons attended: 6/6",
                      style: TextStyle(
                        fontSize: 13,
                        fontFamily: AppConstant.fontName,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 6),
                    Text(
                      "Assignment: 0/0",
                      style: TextStyle(
                        fontSize: 13,
                        fontFamily: AppConstant.fontName,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 6),
                    Text(
                      "Quizzes: 0/0",
                      style: TextStyle(
                        fontSize: 13,
                        fontFamily: AppConstant.fontName,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
