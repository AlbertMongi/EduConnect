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
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:educonnect_parent_app/ui/tabs/home_page.dart';
import 'package:educonnect_parent_app/ui/navigation/elearning_screen.dart';
import 'package:educonnect_parent_app/ui/navigation/communication_screen.dart';
import 'package:educonnect_parent_app/ui/tabs/account/account_screen.dart';
import 'package:educonnect_parent_app/constant/app_constant.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _index = 0;

  final pages = const [
    HomePage(),
    ElearningScreen(),
    CommunicationScreen(),
    AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_index],
      backgroundColor: const Color(0xFFF5F6FA),

      // ---------------------------------------------------
      // CUSTOM NAVIGATION BAR (NO INTERNAL COLUMN)
      // ---------------------------------------------------
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(26),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.55),
                borderRadius: BorderRadius.circular(26),
                border: Border.all(
                  color: Colors.white.withOpacity(.25),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12.withOpacity(.10),
                    blurRadius: 10,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _navItem(0, "assets/icons/home.png", "Home"),
                  _navItem(1, "assets/icons/education.png", "E-Learning"),
                  _navItem(2, "assets/icons/communication2.png", "Chat"),
                  _navItem(3, "assets/icons/profile.png", "Profile"),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------
  // CUSTOM NAV ITEM (NO COLUMN INSIDE BOTTOM NAV)
  // ---------------------------------------------------------
  Widget _navItem(int id, String icon, String label) {
    final active = (_index == id);

    return GestureDetector(
      onTap: () => setState(() => _index = id),
      child: SizedBox(
        width: 70,   // FIXED SAFE WIDTH
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // <- SAFE
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: active
                  ? BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.shade200.withOpacity(.4),
                          blurRadius: 8,
                        ),
                      ],
                    )
                  : null,
              child: Image.asset(
                icon,
                width: 22,
                height: 22,
                color:
                    active ? Colors.blue.shade900 : Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: active ? Colors.blue.shade900 : Colors.grey.shade600,
                fontFamily: AppConstant.fontName,
                fontWeight: active ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
