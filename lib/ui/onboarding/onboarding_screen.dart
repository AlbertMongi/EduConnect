import 'package:educonnect_parent_app/constant/app_constant.dart';
import 'package:educonnect_parent_app/ui/auth/login_screen.dart';  
import 'package:flutter/material.dart';  
import 'package:shared_preferences/shared_preferences.dart';  

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  
  @override  
  _OnboardingScreenState createState() => _OnboardingScreenState();  
}  

class _OnboardingScreenState extends State<OnboardingScreen> {  
  final PageController _pageController = PageController();  
  int _currentPage = 0;  

  @override  
  void dispose() {  
    _pageController.dispose();  
    super.dispose();  
  }  

  void _onPageChanged(int page) {  
    setState(() {  
      _currentPage = page;  
    });  
  }  

  void _navigateToLogin() async {  
    SharedPreferences prefs = await SharedPreferences.getInstance();  
    await prefs.setBool('isFirstLaunch', false);  
    Navigator.of(context).pushReplacement(  
      MaterialPageRoute(builder: (context) => LoginScreen()),  
    );  
  }  

  void _completeOnboardingAndNavigate() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isFirstLaunch', false);

  Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (_) => LoginScreen()),
  );
}


  @override  
  Widget build(BuildContext context) {  
    return Scaffold(  
      backgroundColor: Colors.white,  
      body: Column(  
        children: [  
          // Language Selector and Skip Button  
          Padding(  
            padding: const EdgeInsets.all(16.0),  
            child: Row(  
              mainAxisAlignment: MainAxisAlignment.spaceBetween,  
              children: [  
                Row(  
                  children: [  
                    Text('SW', style: TextStyle(color: Colors.grey, fontFamily: AppConstant.fontName)),  
                    SizedBox(width: 8),  
                    Text('EN', style: TextStyle(color: Colors.blue.shade900, fontWeight: FontWeight.bold, fontFamily: AppConstant.fontName)), // Highlight selected language  
                    // SizedBox(width: 8),  
                    // Text('UK', style: TextStyle(color: Colors.grey)),  
                  ],  
                ),  
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(  
                    onPressed: _completeOnboardingAndNavigate,  
                    style: ElevatedButton.styleFrom(  
                      foregroundColor: Colors.black, shape: RoundedRectangleBorder(  
                        borderRadius: BorderRadius.circular(14),  
                        side: BorderSide(color: Colors.grey),  
                      ), backgroundColor: Colors.white, // Text color  
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),  
                    ),  
                    child: Text('Skip', style: TextStyle(color: Colors.black, fontFamily: AppConstant.fontName)),  
                  ),
                ),  
              ],  
            ),  
          ),  
          Expanded(  
            child: PageView(  
              controller: _pageController,  
              onPageChanged: _onPageChanged,  
              children: [  
                OnboardingPage(  
                  image: 'assets/images/img1.png',  
                  text: 'Welcome to EduConnect',
                  description: 'EduConnect is a platform that connects parents and teachers to share information and collaborate on student progress.',  
                ),  
                OnboardingPage(  
                  image: 'assets/images/img2.png',  
                  text: 'Empowering Students for Success',  
                  description: 'Access modernized educational resources, tools, and features designed to enhance your academic excellence',
                ),  
                OnboardingPage(  
                  image: 'assets/images/img3.png',  
                  text: 'Personalized learning',  
                  description: 'Tailor your learning experience to suit your unique needs and interests. Our app offers personalized features that empower you to learn at your own pace and style.'
                ),  
                OnboardingPage(  
                  image: 'assets/images/img4.png',  
                  text: 'Stay connected',  
                  description: 'Foster meaningful connections with teachers, classmates, and parents through seamless communication and collaboration tools.',
                ),  
              ],  
            ),  
          ),  
          // Dotted indicators and Next button  
          Padding(  
            padding: const EdgeInsets.all(16.0),  
            child: Row(  
              mainAxisAlignment: MainAxisAlignment.spaceBetween,  
              children: [  
                // Dotted indicators  
                Row(  
                  children: List.generate(4, (index) {  
                    return Container(  
                      margin: EdgeInsets.symmetric(horizontal: 4.0),  
                      width: _currentPage == index ? 12.0 : 8.0,  
                      height: 8.0,  
                      decoration: BoxDecoration(  
                        color: _currentPage == index ? Colors.red.shade900 : Colors.grey,  
                        borderRadius: BorderRadius.circular(8.0),  
                      ),  
                    );  
                  }),  
                ),  
                // Next button  
                TextButton(  
                  onPressed: () {  
                    if (_currentPage == 3) {  
                      _completeOnboardingAndNavigate();  
                    } else {  
                      _pageController.nextPage(  
                        duration: Duration(milliseconds: 300),  
                        curve: Curves.easeIn,  
                      );  
                    }  
                  },  
                  child: Text(_currentPage == 3 ? 'LOGIN' : 'NEXT', style: TextStyle(fontFamily: AppConstant.fontName, fontWeight: FontWeight.bold, fontSize: 17, color: Colors.blue.shade900),),  
                ),  
              ],  
            ),  
          ),  
        ],  
      ),  
    );  
  }  
}  

class OnboardingPage extends StatelessWidget {  
  final String image;  
  final String text;  
  final String description;

  const OnboardingPage({super.key, required this.image, required this.text, required this.description});  

  @override  
  Widget build(BuildContext context) {  
    return Column(  
      mainAxisAlignment: MainAxisAlignment.center,  
      children: [  
        CircleAvatar(  
          radius: 100,  
          backgroundImage: AssetImage(image),  
        ),  
        SizedBox(height: 20),  
        Text(  
          text,  
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: AppConstant.fontName),  
          textAlign: TextAlign.center,  
        ), 

        SizedBox(height: 10),

         Padding(
           padding: const EdgeInsets.all(16),
           child: Text(  
            description,  
            style: TextStyle(fontSize: 16, fontFamily: AppConstant.fontName),  
            textAlign: TextAlign.center,  
                   ),
         ), 


      ],  
    );  
  }  
}  