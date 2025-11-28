import 'package:educonnect_parent_app/constant/app_constant.dart';
import 'package:educonnect_parent_app/ui/widgets/appbar.dart';
import 'package:flutter/material.dart';

class FanikishaScreen extends StatefulWidget {
  const FanikishaScreen({super.key});

  @override
  State<FanikishaScreen> createState() => _FanikishaScreenState();
}

class _FanikishaScreenState extends State<FanikishaScreen> {
  @override
  Widget build(BuildContext context) {
    // Colors matching the design
    final backgroundColor = Color(0xFFF2F2F2); // Light grey background
    final cardColor = Colors.white; // Card background
    final orangeColor =  Colors.red; // Orange icon/hints
    final primaryTextColor = Colors.black87;
    final secondaryTextColor = Colors.grey[600]!;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: customAppBar(context),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            // Main card with goal and collected amounts
            Container(
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  // Goal Set & Actual Collected
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildGoalColumn("Goal Set", "TZS 2,500,000", primaryTextColor, secondaryTextColor),
                      _buildGoalColumn("Actual Collected", "TZS 1,500,000", primaryTextColor, secondaryTextColor),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Start date, Due date and hide icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildDateColumn("Start date", "02/01/2024", secondaryTextColor),
                      _buildDateColumn("Due date", "30/04/2024", secondaryTextColor),
                      Icon(Icons.visibility_off, color: Colors.grey[400]),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            // Bottom icons with labels
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildIconColumn(Icons.description, "Terms &\n Conditions", orangeColor),
                _buildIconColumn(Icons.account_balance_wallet, "Wallet\n Topup", orangeColor),
                _buildIconColumn(Icons.person_add, "Apply\n Fanikisha", orangeColor),
              ],
            ),
            SizedBox(height: 40),
            // "See more" with right arrow
            GestureDetector(
              onTap: () {
                // Implement see more action here
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "see more",
                    style: TextStyle(color: orangeColor, fontWeight: FontWeight.w600, fontFamily: AppConstant.fontName
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward, color: orangeColor, size: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalColumn(String title, String value, Color textColor, Color subTextColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(color: subTextColor, fontSize: 12,fontFamily: AppConstant.fontName)),
        SizedBox(height: 4),
        Text(value, style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.bold, fontFamily: AppConstant.fontName)),
      ],
    );
  }

  Widget _buildDateColumn(String title, String date, Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(color: Colors.grey[500], fontSize: 11,fontFamily: AppConstant.fontName)),
        SizedBox(height: 4),
        Text(date, style: TextStyle(color: textColor, fontSize: 13,fontFamily: AppConstant.fontName)),
      ],
    );
  }

  Widget _buildIconColumn(IconData icon, String label, Color iconColor) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 228, 224, 224),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor, size: 28),
        ),
        SizedBox(height: 10),
        Text(
          label,
          style: TextStyle(color: Colors.black87, fontSize: 13, fontFamily: AppConstant.fontName, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,

        ),
      ],
    );
  }
}