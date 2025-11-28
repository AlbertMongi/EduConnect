import 'dart:convert';
import 'package:educonnect_parent_app/constant/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';


class PaymentsScreen extends StatefulWidget {
  const PaymentsScreen({super.key});

  @override
  State<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  double outstandingBalance = 0.0;
  List<dynamic> payments = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPayments();
  }

  Future<void> fetchPayments() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('https://nbc-educonnect.co.tz/api/parents/payments'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        outstandingBalance = data['outstanding_balance']?.toDouble() ?? 0.0;
        payments = data['payments'] ?? [];
        isLoading = false;
      });
    } else {
      // Handle error
      setState(() => isLoading = false);
      print('Failed to load payments');
    }
  }

  String formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    return "${date.day}/${date.month}/${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue.shade900,
        title: Text('Payments', 
        style: TextStyle(
          color: Colors.white, 
          fontFamily: AppConstant.fontName, 
          fontSize: 18),),
      ),
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  // Balance Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.red.shade900,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Unpaid Balance',
                          style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                              fontFamily: AppConstant.fontName),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'TSh ${formatNumber(outstandingBalance.toStringAsFixed(0))}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            fontFamily: AppConstant.fontName,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'You can pay via NBC Kiganjani App, Wakala or NBC Branch',
                          style: TextStyle(
                              color: Colors.white54,
                              fontFamily: AppConstant.fontName),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Payments Label
                  Text(
                    'Total Amount Paid | TSh ${formatNumber(payments.fold(0, (sum, p) => sum + int.parse(p['amount_paid'])))}',
                    style: TextStyle(
                        color: Colors.blue.shade900,
                        fontSize: 16,
                        fontFamily: AppConstant.fontName),
                  ),
                  const SizedBox(height: 10),

                  ...payments.map((payment) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.green.shade900),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.money,
                              color: Colors.green, size: 32),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'TSh ${formatNumber(payment['amount_paid'])} | ${payment['bank_ref']}',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontFamily: AppConstant.fontName),
                              ),
                              const SizedBox(height: 4),

                              Text('Control #: ${payment['control_number']}', style: TextStyle(color: Colors.grey, fontFamily: AppConstant.fontName),),
                              const SizedBox(height: 4),


                              Text(
                               'Payment Date: ${formatDate(payment['created_at'])}',
                                style: const TextStyle(
                                    color: Colors.white54,
                                    fontFamily: AppConstant.fontName),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
    );
  }


 
}

  String formatNumber(dynamic number) {
    final numericValue = num.tryParse(number.toString()) ?? 0;
    final formatter = NumberFormat('#,##0');
    return formatter.format(numericValue);
  }
