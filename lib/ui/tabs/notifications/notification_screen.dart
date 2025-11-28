import 'package:educonnect_parent_app/constant/app_constant.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue.shade900,
        title: Text('Notifications', 
        style: TextStyle(
          color: Colors.white, 
          fontFamily: AppConstant.fontName, 
          fontSize: 18),),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/icons/notification_bell.png', width: 80, height: 80,),
            const SizedBox(height: 10,),
            Text('No Notification', style: TextStyle(fontFamily: AppConstant.fontName),)
          ],
        ),
      ),
     
    );
  }
}