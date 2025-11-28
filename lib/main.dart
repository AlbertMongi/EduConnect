import 'package:educonnect_parent_app/home.dart';
import 'package:educonnect_parent_app/ui/onboarding/onboarding_screen.dart';
import 'package:educonnect_parent_app/ui/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
   WidgetsFlutterBinding.ensureInitialized(); // Ensure initialization before accessing SharedPreferences
  
  // Check if it's the first launch
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;

  runApp(MyApp(isFirstLaunch: isFirstLaunch));
}

class MyApp extends StatelessWidget {
 

   final bool isFirstLaunch;

  // Add the isFirstLaunch named parameter here
  const MyApp({super.key, required this.isFirstLaunch});



  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
     home: isFirstLaunch ? OnboardingScreen() : SplashScreen(),
      debugShowCheckedModeBanner: false,
     
      routes: {
        '/home': (context) => const Home(), // create this screen
      },
    );
  }
}
