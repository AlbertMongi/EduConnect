
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// class AuthService {
//   static const String baseUrl = 'https://nbc-educonnect.co.tz/api/auth';

//   static Future<bool> login(String email, String password) async {
//     try {
//       final response = await http.post(
//         Uri.parse('$baseUrl/login'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           'email': email,
//           'password': password,
//         }),
//       );

//       if (response.statusCode == 200) {
//         final responseData = jsonDecode(response.body);
//         if (responseData['success'] == true && responseData['data'] != null) {
//           final prefs = await SharedPreferences.getInstance();
//           // Store the entire data object as a JSON string
//           await prefs.setString('user_data', jsonEncode(responseData['data']));
//           // Optionally store token separately for convenience
//           await prefs.setString('token', responseData['data']['token']);
//           return true;
//         } else {
//           print('Login failed: Invalid response format');
//           return false;
//         }
//       } else {
//         print('Login failed: ${response.statusCode} - ${response.body}');
//         return false;
//       }
//     } catch (e) {
//       print('Error during login: $e');
//       return false;
//     }
//   }
// }



import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = 'https://nbc-educonnect.co.tz/api/auth';

  static Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] == true && responseData['data'] != null) {
          final prefs = await SharedPreferences.getInstance();
          // Store the entire data object as a JSON string
          await prefs.setString('user_data', jsonEncode(responseData['data']));
          // Store token separately for convenience
          await prefs.setString('token', responseData['data']['token']);
          // Store email for biometric login
          await prefs.setString('user_email', email);
          return true;
        } else {
          print('Login failed: Invalid response format');
          return false;
        }
      } else {
        print('Login failed: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error during login: $e');
      return false;
    }
  }

  static Future<bool> loginWithBiometrics(String email) async {
    try {
      // Retrieve stored token for authentication
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        print('Biometric login failed: No token found');
        return false;
      }

      // Make API call to verify user with email and token
      final response = await http.post(
        Uri.parse('$baseUrl/biometric-login'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'email': email,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] == true && responseData['data'] != null) {
          // Update user data in SharedPreferences
          await prefs.setString('user_data', jsonEncode(responseData['data']));
          await prefs.setString('token', responseData['data']['token']);
          return true;
        } else {
          print('Biometric login failed: Invalid response format');
          return false;
        }
      } else {
        print('Biometric login failed: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error during biometric login: $e');
      return false;
    }
  }
}