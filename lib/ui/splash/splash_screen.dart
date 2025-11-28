import 'package:educonnect_parent_app/constant/app_constant.dart';
import 'package:educonnect_parent_app/home.dart';
import 'package:educonnect_parent_app/ui/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    // Wait 3 seconds then navigate
    Timer(Duration(seconds: 3), () {
      if (token != null && token.isNotEmpty) {
        // User is logged in, go to home screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Home()),
        );
      } else {
        // No token, go to login screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/educonnect.png',
              width: 220,
              height: 110,
            ),
            const Text(
              'Parent Experience',
              style: TextStyle(
                fontFamily: AppConstant.fontName,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            SleekCircularSlider(
              appearance: CircularSliderAppearance(spinnerMode: true, size: 80),
            ),
          ],
        ),
      ),
    );
  }
}
