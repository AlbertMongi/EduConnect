// import 'package:educonnect_parent_app/constant/app_constant.dart';
// import 'package:educonnect_parent_app/ui/navigation/communication_screen.dart';
// import 'package:educonnect_parent_app/ui/navigation/elearning_screen.dart';
// import 'package:educonnect_parent_app/ui/navigation/fanikisha_screen.dart';
// import 'package:educonnect_parent_app/ui/tabs/account/account_screen.dart';
// import 'package:educonnect_parent_app/ui/tabs/home_page.dart';
// import 'package:flutter/material.dart';

// class Home extends StatefulWidget {
//   const Home({super.key});

//   @override
//   State<Home> createState() => _HomeState();
// }

// class _HomeState extends State<Home> {
//   int _currentIndex = 0;

//   // Pages
//   final List<Widget> _pages = [
//     const HomePage(),
//     const ElearningScreen(),
//     const FanikishaScreen(),
//     const CommunicationScreen(),
//      const AccountScreen(),
//   ];

//   void _onTabTapped(int index) {
//     setState(() {
//       _currentIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: _pages[_currentIndex],

//       bottomNavigationBar: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
//         decoration: const BoxDecoration(
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black26,
//               blurRadius: 30,
//               offset: Offset(0, 20)
//             )
//           ]

//         ),

//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(20),
//           child: BottomNavigationBar(
//             backgroundColor: Colors.white,
//             currentIndex: _currentIndex,
//             selectedItemColor: Colors.blue.shade900,
//             unselectedItemColor: Colors.grey,
//             onTap: _onTabTapped,
//             type: BottomNavigationBarType.fixed,
          
//             selectedLabelStyle: TextStyle(
//               fontFamily: AppConstant.fontName,
//               fontWeight: FontWeight.bold,
//               fontSize: 12,
//             ),
//             unselectedLabelStyle: TextStyle(
//               fontFamily: AppConstant.fontName,
//               fontWeight: FontWeight.normal,
//               fontSize: 12,
//             ),
          
//             items: [
//               // Home
//               BottomNavigationBarItem(
//                 icon: Image.asset(
//                   'assets/icons/home.png',
//                   width: 24,
//                   height: 24,
//                   color: _currentIndex == 0 ? Colors.blue.shade900 : Colors.grey,
//                 ),
//                 label: 'Home',
//               ),
          
//               // Payments
//               BottomNavigationBarItem(
//                 icon: Image.asset(
//                   'assets/icons/education.png',
//                   width: 28,
//                   height: 28,
//                   color: _currentIndex == 1 ? Colors.blue.shade900 : Colors.grey,
//                 ),
//                 label: 'E-Learning',
//               ),
          
//               // Notifications
//               BottomNavigationBarItem(
//                 icon: Image.asset(
//                   'assets/icons/fanikisha2.png',
//                   width: 24,
//                   height: 24,
//                   color: _currentIndex == 2 ? Colors.blue.shade900 : Colors.grey,
//                 ),
//                 label: 'Fanikisha',
//               ),
          
//               // Profile
//               BottomNavigationBarItem(
//                 icon: Image.asset(
//                   'assets/icons/communication2.png',
//                   width: 24,
//                   height: 24,
//                   color: _currentIndex == 3 ? Colors.blue.shade900 : Colors.grey,
//                 ),
//                 label: 'Communication',
//               ),

//                BottomNavigationBarItem(
//                 icon: Image.asset(
//                   'assets/icons/profile.png',
//                   width: 24,
//                   height: 24,
//                   color: _currentIndex == 4 ? Colors.blue.shade900 : Colors.grey,
//                 ),
//                 label: 'Profile',
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }




// home.dart
import 'package:educonnect_parent_app/constant/app_constant.dart';
import 'package:educonnect_parent_app/ui/navigation/communication_screen.dart';
import 'package:educonnect_parent_app/ui/navigation/elearning_screen.dart';
import 'package:educonnect_parent_app/ui/tabs/account/account_screen.dart';
import 'package:educonnect_parent_app/ui/tabs/home_page.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    ElearningScreen(),
    CommunicationScreen(),
    AccountScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Safety: If somehow index is out of range (e.g. from old saved state), reset to 0
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_currentIndex >= _pages.length) {
        setState(() {
          _currentIndex = 0;
        });
      }
    });
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Extra safety — clamp the index
    final safeIndex = _currentIndex.clamp(0, _pages.length - 1);

    return Scaffold(
      backgroundColor: Colors.white,
      body: _pages[safeIndex],
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(color: Colors.black26, blurRadius: 30, offset: Offset(0, 20)),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BottomNavigationBar(
            currentIndex: safeIndex,
            onTap: _onTabTapped,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.blue.shade900,
            unselectedItemColor: Colors.grey,
            selectedLabelStyle: const TextStyle(fontFamily: AppConstant.fontName, fontWeight: FontWeight.bold, fontSize: 12),
            unselectedLabelStyle: const TextStyle(fontFamily: AppConstant.fontName, fontSize: 12),
            items: [
              BottomNavigationBarItem(
                icon: Image.asset('assets/icons/home.png', width: 24, height: 24, color: safeIndex == 0 ? Colors.blue.shade900 : Colors.grey),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Image.asset('assets/icons/education.png', width: 28, height: 28, color: safeIndex == 1 ? Colors.blue.shade900 : Colors.grey),
                label: 'E-Learning',
              ),
              BottomNavigationBarItem(
                icon: Image.asset('assets/icons/communication2.png', width: 24, height: 24, color: safeIndex == 2 ? Colors.blue.shade900 : Colors.grey),
                label: 'Communication',
              ),
              BottomNavigationBarItem(
                icon: Image.asset('assets/icons/profile.png', width: 24, height: 24, color: safeIndex == 3 ? Colors.blue.shade900 : Colors.grey),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}