import 'package:educonnect_parent_app/constant/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

AppBar customAppBar(BuildContext context) {
  return AppBar(
    backgroundColor: Colors.white,
    elevation: 0,
    leading: IconButton(
      icon: Icon(Icons.menu, color: Colors.black),
      onPressed: () {
        Scaffold.of(context).openDrawer();
      },
    ),
    title: FutureBuilder<Map<String, String>>(
      future: _fetchStudentDetails(),
      builder: (context, snapshot) {
        String studentFullName = 'Loading...';
        String studentClass = '';

        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          studentFullName = snapshot.data!['full_name'] ?? 'No Name';
          studentClass = snapshot.data!['class_name'] ?? 'No Class';
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  studentFullName,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    fontFamily: AppConstant.fontName,
                  ),
                ),
                Icon(Icons.arrow_drop_down, color: Colors.black),
              ],
            ),
            Text(
              studentClass,
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontFamily: AppConstant.fontName,
              ),
            ),
          ],
        );
      },
    ),
    actions: [
      IconButton(
        icon: Image.asset('assets/icons/bell.png', width: 24, height: 24,),
        onPressed: () async {
          // SharedPreferences prefs = await SharedPreferences.getInstance();
          // await prefs.clear();
          // Navigator.pushAndRemoveUntil(
          //   context,
          //   MaterialPageRoute(builder: (context) => const SplashScreen()),
          //   (Route<dynamic> route) => false,
          // );
        },
      ),
    ],
  );
}

// Function to fetch student details from the API
Future<Map<String, String>> _fetchStudentDetails() async {
  final String apiUrl = 'https://nbc-educonnect.co.tz/api/parents/MyStudent';
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('token');
  String fullName = '';
  String className = '';

  try {
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      fullName = '${data['student']['first_name']} ${data['student']['last_name']}';
      className = data['student']['class_name'];
    } else {
      throw Exception('Failed to load student info');
    }
  } catch (e) {
    print(e);
  }

  return {
    'full_name': fullName,
    'class_name': className,
  };
}
