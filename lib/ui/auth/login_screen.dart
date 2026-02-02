// import 'dart:convert';
// import 'package:educonnect_parent_app/constant/app_constant.dart';
// import 'package:educonnect_parent_app/services/auth_service.dart';
// import 'package:flutter/material.dart';
// import 'package:vibration/vibration.dart';
// import 'package:sleek_circular_slider/sleek_circular_slider.dart';
// import 'package:local_auth/local_auth.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
//   final TextEditingController idController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();

//   final LocalAuthentication auth = LocalAuthentication();

//   Color idBorderColor = Colors.black;
//   Color passwordBorderColor = Colors.black;

//   late AnimationController _idControllerShake;
//   late AnimationController _passwordControllerShake;

//   bool _obscurePassword = true;

//   @override
//   void initState() {
//     super.initState();
//     _idControllerShake =
//         AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
//     _passwordControllerShake =
//         AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
//     _loadSavedCredentials(); // Load saved credentials on initialization
//   }

//   @override
//   void dispose() {
//     _idControllerShake.dispose();
//     _passwordControllerShake.dispose();
//     idController.dispose();
//     passwordController.dispose();
//     super.dispose();
//   }

//   // Load saved email and password from SharedPreferences
//   Future<void> _loadSavedCredentials() async {
//     final prefs = await SharedPreferences.getInstance();
//     final String? savedEmail = prefs.getString('email');
//     final String? savedPassword = prefs.getString('password');

//     if (mounted) {
//       setState(() {
//         if (savedEmail != null && savedEmail.isNotEmpty) {
//           idController.text = savedEmail;
//         }
//         if (savedPassword != null && savedPassword.isNotEmpty) {
//           passwordController.text = savedPassword;
//         }
//       });
//     }
//   }

//   // Save email and password to SharedPreferences
//   Future<void> _saveCredentials(String email, String password) async {
//     final prefs = await SharedPreferences.getInstance();
//     // WARNING: Storing passwords in SharedPreferences is insecure.
//     // For production, use flutter_secure_storage instead.
//     await prefs.setString('email', email);
//     await prefs.setString('password', password);
//     // Update user_data for compatibility with AccountScreen
//     final userData = {
//       'email': email,
//       'password': password,
//       // Preserve other fields if they exist
//       ...?jsonDecode(prefs.getString('user_data') ?? '{}'),
//     };
//     await prefs.setString('user_data', jsonEncode(userData));
//   }

//   void _showLoadingDialog() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => AlertDialog(
//         content: SleekCircularSlider(
//           appearance: CircularSliderAppearance(spinnerMode: true, size: 80),
//         ),
//       ),
//     );
//   }

//   void _hideLoadingDialog() {
//     Navigator.of(context, rootNavigator: true).pop();
//   }

//   /// Authenticate using fingerprint or face
//   Future<void> _authenticateWithBiometrics() async {
//     try {
//       bool canCheckBiometrics = await auth.canCheckBiometrics;
//       bool isDeviceSupported = await auth.isDeviceSupported();

//       if (!canCheckBiometrics || !isDeviceSupported) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text("Biometric authentication not available on this device"),
//             backgroundColor: Colors.red,
//           ),
//         );
//         return;
//       }

//       // Get saved credentials
//       final prefs = await SharedPreferences.getInstance();
//       final String? savedEmail = prefs.getString('email');
//       final String? savedPassword = prefs.getString('password');

//       if (savedEmail == null || savedPassword == null || savedEmail.isEmpty || savedPassword.isEmpty) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text("No saved credentials found. Please log in with email and password first."),
//             backgroundColor: Colors.red,
//           ),
//         );
//         return;
//       }

//       bool authenticated = await auth.authenticate(
//         localizedReason: 'Use your fingerprint to log in',
//         options: const AuthenticationOptions(
//           biometricOnly: true,
//           stickyAuth: true,
//         ),
//       );

//       if (authenticated && mounted) {
//         _showLoadingDialog();
//         // Use saved credentials to authenticate with AuthService
//         final success = await AuthService.login(savedEmail, savedPassword);
//         _hideLoadingDialog();

//         if (success) {
//           Navigator.pushReplacementNamed(context, '/home');
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text("Biometric login failed. Please check your credentials or try manual login."),
//               backgroundColor: Colors.red,
//             ),
//           );
//         }
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text("Fingerprint not recognized"),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     } catch (e) {
//       _hideLoadingDialog();
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text("Error during biometric login: $e"),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Welcome message
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 40.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       '👋 Welcome Back!',
//                       style: TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.blue.shade900,
//                         fontFamily: AppConstant.fontName,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               // Logo
//               Center(
//                 child: Image.asset(
//                   'assets/images/educonnect.png',
//                   height: 200,
//                   width: 200,
//                 ),
//               ),

//               const SizedBox(height: 10),

//               // Parent/Student ID field
//               const Text(
//                 'Parent Email',
//                 style: TextStyle(fontSize: 16, fontFamily: AppConstant.fontName),
//               ),
//               const SizedBox(height: 8),
//               AnimatedBuilder(
//                 animation: _idControllerShake,
//                 builder: (context, child) {
//                   return Transform.translate(
//                     offset: Offset(_idControllerShake.value * 10, 0),
//                     child: TextField(
//                       controller: idController,
//                       keyboardType: TextInputType.emailAddress,
//                       decoration: InputDecoration(
//                         hintText: 'example@email.com',
//                         prefixIcon: const Icon(Icons.mail_outlined),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: BorderSide(color: idBorderColor, width: 2),
//                         ),
//                         filled: true,
//                         fillColor: Colors.white,
//                       ),
//                     ),
//                   );
//                 },
//               ),
//               const SizedBox(height: 20),

//               // Password field
//               const Text(
//                 'Password',
//                 style: TextStyle(fontSize: 16, fontFamily: AppConstant.fontName),
//               ),
//               const SizedBox(height: 8),
//               AnimatedBuilder(
//                 animation: _passwordControllerShake,
//                 builder: (context, child) {
//                   return Transform.translate(
//                     offset: Offset(_passwordControllerShake.value * 10, 0),
//                     child: TextField(
//                       controller: passwordController,
//                       obscureText: _obscurePassword,
//                       decoration: InputDecoration(
//                         hintText: '*********',
//                         prefixIcon: const Icon(Icons.lock_outline),
//                         suffixIcon: IconButton(
//                           icon: Icon(
//                             _obscurePassword ? Icons.visibility_off : Icons.visibility,
//                             color: Colors.grey,
//                           ),
//                           onPressed: () {
//                             setState(() {
//                               _obscurePassword = !_obscurePassword;
//                             });
//                           },
//                         ),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: BorderSide(color: passwordBorderColor, width: 2),
//                         ),
//                         filled: true,
//                         fillColor: Colors.white,
//                       ),
//                     ),
//                   );
//                 },
//               ),

//               const SizedBox(height: 30),

//               // Fingerprint Login Button
//               Center(
//                 child: InkWell(
//                   onTap: _authenticateWithBiometrics,
//                   child: Column(
//                     children: [
//                       Image.asset(
//                         'assets/icons/biometric_login.png',
//                         width: 70,
//                         height: 70,
//                       ),
//                       const SizedBox(height: 8),
//                       const Text(
//                         "Login with Fingerprint",
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontSize: 16,
//                           fontFamily: AppConstant.fontName,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 30),

//               // Login button
//               SizedBox(
//                 width: double.infinity,
//                 height: 50,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.red.shade900,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   onPressed: () async {
//                     final id = idController.text.trim();
//                     final password = passwordController.text;

//                     if (id.isEmpty) {
//                       Vibration.vibrate();
//                       setState(() => idBorderColor = Colors.red);
//                       _idControllerShake.forward(from: 0.0);
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text("Email is required"),
//                           backgroundColor: Colors.red,
//                           duration: Duration(seconds: 2),
//                         ),
//                       );
//                       return;
//                     } else if (password.isEmpty) {
//                       Vibration.vibrate();
//                       setState(() => passwordBorderColor = Colors.red);
//                       _passwordControllerShake.forward(from: 0.0);
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text("Password is required!"),
//                           backgroundColor: Colors.red,
//                           duration: Duration(seconds: 2),
//                         ),
//                       );
//                       return;
//                     } else if (password.length < 8) {
//                       Vibration.vibrate();
//                       setState(() => passwordBorderColor = Colors.red);
//                       _passwordControllerShake.forward(from: 0.0);
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text("Invalid Password!"),
//                           backgroundColor: Colors.red,
//                           duration: Duration(seconds: 2),
//                         ),
//                       );
//                       return;
//                     }

//                     _showLoadingDialog();
//                     final success = await AuthService.login(id, password);
//                     _hideLoadingDialog();

//                     if (success) {
//                       await _saveCredentials(id, password); // Save credentials on successful login
//                       Navigator.pushReplacementNamed(context, '/home');
//                     } else {
//                       Vibration.vibrate();
//                       setState(() {
//                         idBorderColor = Colors.red;
//                         passwordBorderColor = Colors.red;
//                       });
//                       _idControllerShake.forward(from: 0.0);
//                       _passwordControllerShake.forward(from: 0.0);
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text("Login failed. Please check your credentials."),
//                           backgroundColor: Colors.red,
//                           duration: Duration(seconds: 2),
//                         ),
//                       );
//                     }
//                   },
//                   child: const Text(
//                     'LOGIN',
//                     style: TextStyle(
//                       fontSize: 18,
//                       color: Colors.white,
//                       fontFamily: AppConstant.fontName,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 10),

//               // Forgot password link
//               Center(
//                 child: TextButton(
//                   onPressed: () {},
//                   child: const Text(
//                     'Forgot Password?',
//                     style: TextStyle(
//                       fontFamily: AppConstant.fontName,
//                       fontSize: 15,
//                       color: Colors.black,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'dart:convert';
import 'package:educonnect_parent_app/constant/app_constant.dart';
import 'package:educonnect_parent_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  final TextEditingController idController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final LocalAuthentication auth = LocalAuthentication();

  Color idBorderColor = Colors.black;
  Color passwordBorderColor = Colors.black;

  late AnimationController _idControllerShake;
  late AnimationController _passwordControllerShake;

  bool _obscurePassword = true;

  // New: To track saved credentials and user name
  bool hasSavedCredentials = false;
  String? userFirstName;
  String? userLastName;

  @override
  void initState() {
    super.initState();
    _idControllerShake =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _passwordControllerShake =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _loadSavedCredentials();
  }

  @override
  void dispose() {
    _idControllerShake.dispose();
    _passwordControllerShake.dispose();
    idController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // Load saved credentials and extract name
  Future<void> _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedEmail = prefs.getString('email');
    final String? savedPassword = prefs.getString('password');

    final String userDataJson = prefs.getString('user_data') ?? '{}';
    final Map<String, dynamic> userData = jsonDecode(userDataJson);

    if (mounted) {
      setState(() {
        hasSavedCredentials = savedEmail != null &&
            savedEmail.isNotEmpty &&
            savedPassword != null &&
            savedPassword.isNotEmpty;

        if (hasSavedCredentials) {
          idController.text = savedEmail!;
          passwordController.text = savedPassword!;

          userFirstName = userData['first_name'] ??
              userData['firstname'] ??
              userData['name']?.split(' ').first;

          userLastName = userData['last_name'] ??
              userData['lastname'] ??
              (userData['name'] != null && userData['name'].toString().contains(' ')
                  ? userData['name'].toString().split(' ').last
                  : null);
        }
      });
    }
  }

  // Save credentials
  Future<void> _saveCredentials(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    await prefs.setString('password', password);
    final userData = {
      'email': email,
      'password': password,
      ...?jsonDecode(prefs.getString('user_data') ?? '{}'),
    };
    await prefs.setString('user_data', jsonEncode(userData));
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: SleekCircularSlider(
          appearance: CircularSliderAppearance(spinnerMode: true, size: 80),
        ),
      ),
    );
  }

  void _hideLoadingDialog() {
    Navigator.of(context, rootNavigator: true).pop();
  }

  /// Biometric authentication
  Future<void> _authenticateWithBiometrics() async {
    try {
      bool canCheckBiometrics = await auth.canCheckBiometrics;
      bool isDeviceSupported = await auth.isDeviceSupported();

      if (!canCheckBiometrics || !isDeviceSupported) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Biometric authentication not available on this device"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final prefs = await SharedPreferences.getInstance();
      final String? savedEmail = prefs.getString('email');
      final String? savedPassword = prefs.getString('password');

      if (savedEmail == null || savedPassword == null || savedEmail.isEmpty || savedPassword.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("No saved credentials found. Please log in with email and password first."),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      bool authenticated = await auth.authenticate(
        localizedReason: 'Use your fingerprint to log in',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      if (authenticated && mounted) {
        _showLoadingDialog();
        final success = await AuthService.login(savedEmail, savedPassword);
        _hideLoadingDialog();

        if (success) {
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Biometric login failed. Please check your credentials or try manual login."),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Fingerprint not recognized"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      _hideLoadingDialog();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error during biometric login: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome message with hand emoji + name below in red and larger font
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '👋 Welcome Back!',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade900,
                            fontFamily: AppConstant.fontName,
                          ),
                        ),
                      ],
                    ),
                    if (hasSavedCredentials && userFirstName != null && userLastName != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '$userFirstName $userLastName',
                              style: TextStyle(
                                fontSize: 26, // Increased font size
                                fontWeight: FontWeight.bold,
                                color: Colors.red.shade800, // Red color
                                fontFamily: AppConstant.fontName,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),

              // Logo
              Center(
                child: Image.asset(
                  'assets/images/educonnect.png',
                  height: 200,
                  width: 200,
                ),
              ),

              const SizedBox(height: 10),

              // Parent Email field
              const Text(
                'Parent Email',
                style: TextStyle(fontSize: 16, fontFamily: AppConstant.fontName),
              ),
              const SizedBox(height: 8),
              AnimatedBuilder(
                animation: _idControllerShake,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(_idControllerShake.value * 10, 0),
                    child: TextField(
                      controller: idController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'example@email.com',
                        prefixIcon: const Icon(Icons.mail_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: idBorderColor, width: 2),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),

              // Password field
              const Text(
                'Password',
                style: TextStyle(fontSize: 16, fontFamily: AppConstant.fontName),
              ),
              const SizedBox(height: 8),
              AnimatedBuilder(
                animation: _passwordControllerShake,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(_passwordControllerShake.value * 10, 0),
                    child: TextField(
                      controller: passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        hintText: '*********',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off : Icons.visibility,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: passwordBorderColor, width: 2),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 30),

              // Fingerprint Login Button - only if credentials saved
              if (hasSavedCredentials)
                Center(
                  child: InkWell(
                    onTap: _authenticateWithBiometrics,
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/icons/biometric_login.png',
                          width: 70,
                          height: 70,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Login with Fingerprint",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: AppConstant.fontName,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              if (hasSavedCredentials) const SizedBox(height: 30),

              // Login button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade900,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    final id = idController.text.trim();
                    final password = passwordController.text;

                    if (id.isEmpty) {
                      Vibration.vibrate();
                      setState(() => idBorderColor = Colors.red);
                      _idControllerShake.forward(from: 0.0);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Email is required"),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 2),
                        ),
                      );
                      return;
                    } else if (password.isEmpty) {
                      Vibration.vibrate();
                      setState(() => passwordBorderColor = Colors.red);
                      _passwordControllerShake.forward(from: 0.0);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Password is required!"),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 2),
                        ),
                      );
                      return;
                    } else if (password.length < 8) {
                      Vibration.vibrate();
                      setState(() => passwordBorderColor = Colors.red);
                      _passwordControllerShake.forward(from: 0.0);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Invalid Password!"),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 2),
                        ),
                      );
                      return;
                    }

                    _showLoadingDialog();
                    final success = await AuthService.login(id, password);
                    _hideLoadingDialog();

                    if (success) {
                      await _saveCredentials(id, password);
                      if (mounted) {
                        setState(() {
                          hasSavedCredentials = true;
                        });
                      }
                      Navigator.pushReplacementNamed(context, '/home');
                    } else {
                      Vibration.vibrate();
                      setState(() {
                        idBorderColor = Colors.red;
                        passwordBorderColor = Colors.red;
                      });
                      _idControllerShake.forward(from: 0.0);
                      _passwordControllerShake.forward(from: 0.0);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Login failed. Please check your credentials."),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  child: const Text(
                    'LOGIN',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontFamily: AppConstant.fontName,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Forgot password link
              Center(
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      fontFamily: AppConstant.fontName,
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}