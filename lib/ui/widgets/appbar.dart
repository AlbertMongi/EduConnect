import 'package:educonnect_parent_app/constant/app_constant.dart';
import 'package:educonnect_parent_app/ui/tabs/notifications/notification_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

AppBar customAppBar(BuildContext context) {
  return AppBar(
    backgroundColor: Colors.white,
    elevation: 0,
    leading: FutureBuilder<Map<String, dynamic>>(
      future: _fetchParentStudents(),
      builder: (context, snapshot) {
        String fullName = 'U';

        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          final data = snapshot.data!;
          fullName = data['active']['full_name'] ?? 'U';
        }

        // Extract two initials
        List<String> parts = fullName.trim().split(" ");
        String initials = "";

        if (parts.isNotEmpty) {
          initials += parts[0].isNotEmpty ? parts[0][0].toUpperCase() : "";
        }
        if (parts.length > 1) {
          initials += parts[1].isNotEmpty ? parts[1][0].toUpperCase() : "";
        }

        if (initials.isEmpty) initials = "U";

        return Padding(
          padding: const EdgeInsets.only(left: 12),
          child: CircleAvatar(
            radius: 18,
            backgroundColor: Colors.blue.shade100,
            child: Text(
              initials,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),
        );
      },
    ),

    title: FutureBuilder<Map<String, dynamic>>(
      future: _fetchParentStudents(),
      builder: (context, snapshot) {
        String studentFullName = 'Loading...';
        String studentClass = '';
        List<dynamic> students = [];

        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          final data = snapshot.data!;
          studentFullName = data['active']['full_name'] ?? 'No Name';
          studentClass = data['active']['class_name'] ?? '';
          students = data['all_students'] ?? [];
        }

        return GestureDetector(
          onTap:
              () => _showStudentSwitcherBottomSheet(
                context,
                students,
                studentFullName,
              ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    studentFullName,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      fontFamily: AppConstant.fontName,
                    ),
                  ),
                  const Icon(
                    Icons.arrow_drop_down,
                    color: Colors.black,
                  ), // Always visible
                ],
              ),
              Text(
                studentClass,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontFamily: AppConstant.fontName,
                ),
              ),
            ],
          ),
        );
      },
    ),
    actions: [
      Stack(
        clipBehavior: Clip.none,
        children: [
          IconButton(
            icon: Image.asset('assets/icons/bell.png', width: 24, height: 24),
            onPressed: () {
              Get.to(NotificationScreen());
            },
          ),

          // BADGE THAT DOESN'T BLOCK CLICKS
          Positioned(
            right: 8,
            top: 8,
            child: IgnorePointer(
              ignoring: true,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                child: const Center(
                  child: Text(
                    "0",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ],
  );
}

// Fixed: Correctly fetch all students + active one
Future<Map<String, dynamic>> _fetchParentStudents() async {
  const String apiUrl = 'https://nbc-educonnect.co.tz/api/parents/MyStudent';
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('token');
  String? activeStudentId = prefs.getString('active_student_id');

  List<dynamic> allStudents = [];
  Map<String, String> activeStudent = {
    'full_name': 'Loading...',
    'class_name': '',
  };

  try {
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      // Support both single student and list of students
      if (data['students'] != null && data['students'] is List) {
        allStudents = data['students'];
      } else if (data['student'] != null) {
        allStudents = [data['student']];
      }

      if (allStudents.isNotEmpty) {
        // Find active student by saved ID, fallback to first
        final selected = allStudents.firstWhere(
          (s) => s['id'].toString() == activeStudentId,
          orElse: () => allStudents[0],
        );

        activeStudent = {
          'full_name':
              '${selected['first_name'] ?? ''} ${selected['last_name'] ?? ''}'
                  .trim(),
          'class_name': selected['class_name'] ?? 'No Class',
        };

        // Save active student ID
        await prefs.setString('active_student_id', selected['id'].toString());
      }
    }
  } catch (e) {
    debugPrint('Error fetching students: $e');
  }

  return {'active': activeStudent, 'all_students': allStudents};
}

// Fixed: Clean bottom sheet with no errors
void _showStudentSwitcherBottomSheet(
  BuildContext context,
  List<dynamic> students,
  String currentName,
) {
  if (students.isEmpty) return;

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder:
        (context) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Container(
                margin: const EdgeInsets.only(top: 10),
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Select Student',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppConstant.fontName,
                  ),
                ),
              ),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: students.length,
                  itemBuilder: (context, index) {
                    final student = students[index];
                    final name =
                        '${student['first_name'] ?? ''} ${student['last_name'] ?? ''}'
                            .trim();
                    final className = student['class_name'] ?? 'No Class';
                    final isActive = name == currentName;

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor:
                            isActive ? Colors.blue : Colors.grey.shade200,
                        child: Text(
                          name.isNotEmpty ? name[0].toUpperCase() : '?',
                          style: TextStyle(
                            color: isActive ? Colors.white : Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        name,
                        style: TextStyle(
                          fontWeight:
                              isActive ? FontWeight.bold : FontWeight.w600,
                          color: isActive ? Colors.blue : Colors.black,
                          fontFamily: AppConstant.fontName,
                        ),
                      ),
                      subtitle: Text(
                        className,
                        style: const TextStyle(
                          fontFamily: AppConstant.fontName,
                        ),
                      ),
                      trailing:
                          isActive
                              ? const Icon(Icons.check, color: Colors.blue)
                              : const Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: Colors.grey,
                              ),
                      onTap: () async {
                        if (isActive) {
                          Navigator.pop(context);
                          return;
                        }

                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        await prefs.setString(
                          'active_student_id',
                          student['id'].toString(),
                        );

                        Navigator.pop(context);

                        // Refresh current screen (simple & reliable)
                        if (context.mounted) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      ScaffoldMessenger.of(
                                        context,
                                      ).widget.child ??
                                      const SizedBox(),
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
  );
}
