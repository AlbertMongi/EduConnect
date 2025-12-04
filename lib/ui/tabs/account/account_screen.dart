

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:educonnect_parent_app/constant/app_constant.dart';
// import 'package:educonnect_parent_app/ui/widgets/appbar.dart';
// // import 'package:educonnect_parent_app/ui/screens/login_screen.dart';
// import 'package:educonnect_parent_app/ui/auth/login_screen.dart'; // Import LoginScreen

// class AccountScreen extends StatefulWidget {
//   const AccountScreen({super.key});

//   @override
//   State<AccountScreen> createState() => _AccountScreenState();
// }

// class _AccountScreenState extends State<AccountScreen> {
//   String studentName = 'Loading...';
//   String className = 'Loading...';
//   String schoolName = 'Loading...';
//   String admissionId = 'Loading...';
//   String gender = 'Loading...';
//   String parentName = 'Loading...';
//   String parentEmail = 'Loading...';
//   String parentPhone = 'Loading...';
//   String parentJoinDate = 'Loading...';

//   @override
//   void initState() {
//     super.initState();
//     fetchStudentDetails();
//     fetchParentDetails();
//   }

//   Future<void> fetchStudentDetails() async {
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? token = prefs.getString('token');

//       if (token == null) {
//         setState(() {
//           studentName = 'Please log in to view student details';
//           className = 'N/A';
//           schoolName = 'N/A';
//           admissionId = 'N/A';
//           gender = 'N/A';
//         });
//         return;
//       }

//       final response = await http.get(
//         Uri.parse('https://nbc-educonnect.co.tz/api/parents/MyStudent'),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Accept': 'application/json',
//         },
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         if (data['success'] == true && data['student'] != null) {
//           setState(() {
//             studentName = '${data['student']['first_name']} ${data['student']['last_name']}';
//             className = data['student']['class_name'] ?? 'N/A';
//             schoolName = data['student']['school_name'] ?? 'N/A';
//             admissionId = data['student']['admission_id'] ?? 'N/A';
//             gender = data['student']['gender'] ?? 'N/A';
//           });
//         } else {
//           setState(() {
//             studentName = 'Failed to load student details';
//             className = 'N/A';
//             schoolName = 'N/A';
//             admissionId = 'N/A';
//             gender = 'N/A';
//           });
//         }
//       } else {
//         setState(() {
//           studentName = 'Failed to load student details (Status: ${response.statusCode})';
//           className = 'N/A';
//           schoolName = 'N/A';
//           admissionId = 'N/A';
//           gender = 'N/A';
//         });
//       }
//     } catch (e) {
//       setState(() {
//         studentName = 'Error fetching student details';
//         className = 'N/A';
//         schoolName = 'N/A';
//         admissionId = 'N/A';
//         gender = 'N/A';
//       });
//     }
//   }

//   Future<void> fetchParentDetails() async {
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? userDataJson = prefs.getString('user_data');

//       if (userDataJson == null) {
//         setState(() {
//           parentName = 'Please log in to view parent details';
//           parentEmail = 'N/A';
//           parentPhone = 'N/A';
//           parentJoinDate = 'N/A';
//         });
//         return;
//       }

//       final userData = jsonDecode(userDataJson);
//       setState(() {
//         parentName = userData['name'] ?? 'N/A';
//         parentEmail = userData['email'] ?? 'N/A';
//         parentPhone = userData['phone_number'] ?? 'N/A';
//         parentJoinDate = userData['join_date'] ?? 'N/A';
//       });
//     } catch (e) {
//       setState(() {
//         parentName = 'Error fetching parent details';
//         parentEmail = 'N/A';
//         parentPhone = 'N/A';
//         parentJoinDate = 'N/A';
//       });
//     }
//   }

//   Future<void> logout() async {
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();

//       // Only remove the token to end the session, keep user_data for credentials
//       await prefs.remove('token');

//       // Navigate to login screen
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const LoginScreen()),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error logging out: $e')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: customAppBar(context),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Profile images section with the Student on the left and Parent on the right
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   // Student Profile - Left Side
//                   Column(
//                     children: [
//                       CircleAvatar(
//                         radius: 40,
//                         child: Icon(
//                           Icons.person,
//                           size: 40,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       const Text('Student', style: TextStyle(fontWeight: FontWeight.bold)),
//                     ],
//                   ),
//                   // Parent Profile - Right Side
//                   Column(
//                     children: [
//                       CircleAvatar(
//                         radius: 40,
//                         child: Icon(
//                           Icons.person,
//                           size: 40,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       const Text('Parent', style: TextStyle(fontWeight: FontWeight.bold)),
//                     ],
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16),

//               // Student Details Header
//               const Text(
//                 'STUDENT DETAILS',
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//               ),
//               const SizedBox(height: 8),
//               // Student Details
//               _buildDetailRow('Student Name', studentName),
//               _buildDetailRow('Registration Number', admissionId),
//               _buildDetailRow('Class', className),
//               _buildDetailRow('School', schoolName),
//               _buildDetailRow('Gender', gender),
//               _buildDetailRow('Academic Year', '2023'),
//               const SizedBox(height: 16),

//               // Parent/Guardian Details Header
//               const Text(
//                 'PARENT/GUARDIAN DETAILS',
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//               ),
//               const SizedBox(height: 8),
//               // Parent Details
//               _buildDetailRow('Parent Name', parentName),
//               _buildDetailRow('Mobile Number', parentPhone),
//               _buildDetailRow('Email Address', parentEmail),
//               _buildDetailRow('Join Date', parentJoinDate),
//               const SizedBox(height: 16),

//               // Update Details Button
//               Center(
//                 child: ElevatedButton(
//                   onPressed: () {
//                     // Implement update logic here
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.red.shade900,
//                     foregroundColor: Colors.white,
//                     minimumSize: const Size(double.infinity, 50),
//                   ),
//                   child: const Text('Update Details'),
//                 ),
//               ),
//               const SizedBox(height: 8),
//               // Logout Button
//               Center(
//                 child: ElevatedButton(
//                   onPressed: logout,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.grey.shade600,
//                     foregroundColor: Colors.white,
//                     minimumSize: const Size(double.infinity, 50),
//                   ),
//                   child: const Text('Logout'),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // Helper method to create a row with label and value
//   Widget _buildDetailRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//             flex: 2,
//             child: Text(
//               label,
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ),
//           ),
//           Expanded(
//             flex: 3,
//             child: Text(value),
//           ),
//         ],
//       ),
//     );
//   }
// }

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

      if (token == null) {
        setState(() {
          studentName = 'Please log in to view student details';
          className = schoolName = admissionId = gender = 'N/A';
        });
        return;
      }

      final response = await http.get(
        Uri.parse('https://nbc-educonnect.co.tz/api/parents/MyStudent'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['student'] != null) {
          setState(() {
            studentName =
                '${data['student']['first_name']} ${data['student']['last_name']}';
            className = data['student']['class_name'] ?? 'N/A';
            schoolName = data['student']['school_name'] ?? 'N/A';
            admissionId = data['student']['admission_id'] ?? 'N/A';
            gender = data['student']['gender'] ?? 'N/A';
          });
        } else {
          _setStudentError('No student data found');
        }
      } else {
        _setStudentError('Failed to load (Status: ${response.statusCode})');
      }
    } catch (e) {
      _setStudentError('Network error');
    }
  }

  void _setStudentError(String message) {
    setState(() {
      studentName = message;
      className = schoolName = admissionId = gender = 'N/A';
    });
  }

  Future<void> fetchParentDetails() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userDataJson = prefs.getString('user_data');

      if (userDataJson == null) {
        setState(() {
          parentName = 'Please log in to view parent details';
          parentEmail = parentPhone = parentJoinDate = 'N/A';
        });
        return;
      }

      final userData = jsonDecode(userDataJson);
      setState(() {
        parentName = userData['name'] ?? 'N/A';
        parentEmail = userData['email'] ?? 'N/A';
        parentPhone = userData['phone_number'] ?? 'N/A';
        parentJoinDate = userData['join_date'] ?? 'N/A';
      });
    } catch (e) {
      setState(() {
        parentName = 'Error loading parent details';
        parentEmail = parentPhone = parentJoinDate = 'N/A';
      });
    }
  }

  Future<void> logout() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logout failed. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Pure white background
      appBar: customAppBar(context),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // EXACT SAME POSITION & SPACING AS YOUR ORIGINAL DESIGN
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Student Avatar
                    Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.grey.shade100,
                          child: Icon(Icons.person, size: 48, color: Colors.grey.shade700),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Student',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),

                    // Parent Avatar
                    Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.grey.shade100,
                          child: Icon(Icons.person, size: 48, color: Colors.grey.shade700),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Parent',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Student Details
                const Text(
                  'STUDENT DETAILS',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 12),
                _buildRow('Student Name', studentName),
                _buildRow('Registration Number', admissionId),
                _buildRow('Class', className),
                _buildRow('School', schoolName),
                _buildRow('Gender', gender),
                _buildRow('Academic Year', '2023'),
                const SizedBox(height: 24),

                // Parent Details
                const Text(
                  'PARENT/GUARDIAN DETAILS',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 12),
                _buildRow('Parent Name', parentName),
                _buildRow('Mobile Number', parentPhone),
                _buildRow('Email Address', parentEmail),
                _buildRow('Join Date', parentJoinDate),
                const SizedBox(height: 40),

                // Logout Button
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: logout,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade700,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 5,
                      ),
                      child: const Text(
                        'Logout',
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15.5),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(fontSize: 15.5),
            ),
          ),
        ],
      ),
    );
  }
}