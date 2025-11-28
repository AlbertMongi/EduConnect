import 'package:educonnect_parent_app/constant/app_constant.dart';
import 'package:flutter/material.dart';

class ComingSoonBottomSheet extends StatelessWidget {
  const ComingSoonBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Set the width to cover full screen width
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/icons/info.png', width: 30,height: 30,),
          SizedBox(height: 10),
          Text(
            'Coming Soon!',
            style: TextStyle(fontSize: 16, fontFamily: AppConstant.fontName),
          ),
          SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close the bottom sheet
              },
              style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade900,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
              child: Text('OKAY', style: TextStyle(
                color: Colors.white, 
                fontWeight: FontWeight.bold, 
                fontFamily: AppConstant.fontName,
                fontSize: 16
                ),),
            ),
          ),
        ],
      ),
    );
  }
}
