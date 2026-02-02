import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:educonnect_parent_app/ui/widgets/appbar.dart';
import 'package:educonnect_parent_app/ui/auth/login_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String studentName = 'Loading...';
  String className = 'Loading...';
  String schoolName = 'Loading...';
  String admissionId = 'Loading...';
  String gender = 'Loading...';

  String parentName = 'Loading...';
  String parentEmail = 'Loading...';
  String parentPhone = 'Loading...';
  String parentJoinDate = 'Loading...';

  @override
  void initState() {
    super.initState();
    fetchStudentDetails();
    fetchParentDetails();
  }

  Future<void> fetchStudentDetails() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) return;

      final response = await http.get(
        Uri.parse('https://nbc-educonnect.co.tz/api/parents/MyStudent'),
        headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == true) {
          setState(() {
            studentName = "${data['student']['first_name']} ${data['student']['last_name']}";
            className = data['student']['class_name'];
            schoolName = data['student']['school_name'];
            admissionId = data['student']['admission_id'] ?? 'N/A';
            gender = data['student']['gender'] ?? 'N/A';
          });
        }
      }
    } catch (e) {}
  }

  Future<void> fetchParentDetails() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? json = prefs.getString('user_data');

      if (json == null) return;

      final data = jsonDecode(json);

      setState(() {
        parentName = data['name'] ?? 'N/A';
        parentEmail = data['email'] ?? 'N/A';
        parentPhone = data['phone_number'] ?? 'N/A';
        parentJoinDate = data['join_date'] ?? 'N/A';
      });
    } catch (e) {}
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeBlue = Colors.blue.shade800;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: customAppBar(context),

      // --------------------------
      // STICKY LOGOUT BUTTON HERE
      // --------------------------
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 55,
          child: ElevatedButton.icon(
            onPressed: logout,
            icon: const Icon(Icons.logout, color: Colors.white),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 4,
            ),
            label: const Text(
              "Logout",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            // -------------------------------
            //           HEADER SECTION
            // -------------------------------
            Container(
              padding: const EdgeInsets.only(top: 30, bottom: 40),
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade900, Colors.blue.shade500],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(35),
                  bottomLeft: Radius.circular(35),
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 55, color: themeBlue),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    parentName,
                    style: const TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    parentEmail,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // -------------------------------
            //        STUDENT CARD
            // -------------------------------
            _sectionTitle("Student Details"),

            _glassCard(children: [
              _infoRow(Icons.person, "Student Name", studentName),
              _infoRow(Icons.confirmation_num, "Registration No.", admissionId),
              _infoRow(Icons.class_, "Class", className),
              _infoRow(Icons.school, "School", schoolName),
              _infoRow(Icons.male, "Gender", gender),
            ]),

            const SizedBox(height: 28),

            // -------------------------------
            //        PARENT CARD
            // -------------------------------
            _sectionTitle("Parent / Guardian Details"),

            _glassCard(children: [
              _infoRow(Icons.person_pin, "Parent Name", parentName),
              _infoRow(Icons.phone, "Mobile Number", parentPhone),
              _infoRow(Icons.email, "Email", parentEmail),
              _infoRow(Icons.calendar_today, "Join Date", parentJoinDate),
            ]),

            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  // ---------------------- WIDGETS ----------------------

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w700,
            color: Colors.blue.shade900,
          ),
        ),
      ),
    );
  }

  Widget _glassCard({required List<Widget> children}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.85),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _infoRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.blue.shade50,
            child: Icon(icon, color: Colors.blue.shade700),
          ),
          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style:
                        TextStyle(fontSize: 14, color: Colors.grey.shade700)),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
