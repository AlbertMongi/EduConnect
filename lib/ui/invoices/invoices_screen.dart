import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:educonnect_parent_app/constant/app_constant.dart';
import 'package:intl/intl.dart';

class InvoicesScreen extends StatefulWidget {
  const InvoicesScreen({super.key});

  @override
  State<InvoicesScreen> createState() => _InvoicesScreenState();
}

class _InvoicesScreenState extends State<InvoicesScreen> {
  List<dynamic> invoices = [];
  bool isLoading = true;
  double outstandingBalance = 0.0;
  List<dynamic> payments = [];

  @override
  void initState() {
    super.initState();
    fetchInvoices();
    fetchPayments();
  }

  Future<void> fetchPayments() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('https://nbc-educonnect.co.tz/api/parents/payments'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        outstandingBalance = data['outstanding_balance']?.toDouble() ?? 0.0;
        payments = data['payments'] ?? [];
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
      print('Failed to load payments');
    }
  }

  Future<void> fetchInvoices() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('https://nbc-educonnect.co.tz/api/parents/invoices/list'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        invoices = data['invoices'] ?? [];
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
      print('Failed to load invoices');
    }
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "paid":
        return Colors.green.shade400;
      case "partial":
        return Colors.orange.shade400;
      case "unpaid":
        return Colors.red.shade400;
      default:
        return Colors.blue.shade400;
    }
  }

  String formatDate(String? dateString) {
    if (dateString == null) return "N/A";
    final date = DateTime.parse(dateString);
    return "${DateFormat('dd/MM/yyyy HH:mm').format(date)}";
  }

  void showInvoiceDetails(BuildContext context, dynamic invoice) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Invoice Details',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade900,
                      fontFamily: AppConstant.fontName,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close_rounded, color: Colors.grey.shade600),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildDetailRow(
                Icons.payment_rounded,
                'Status',
                invoice['payment_status'].toUpperCase(),
                color: getStatusColor(invoice['payment_status']),
              ),
              Divider(height: 24, color: Colors.grey[200]),
              _buildDetailRow(
                Icons.attach_money_rounded,
                'Due Amount',
                'TZS ${formatNumber(invoice['due_amount'])}',
              ),
              Divider(height: 24, color: Colors.grey[200]),
              _buildDetailRow(
                Icons.money_off_rounded,
                'Paid Amount',
                'TSh ${formatNumber(invoice['paid_amount'])}',
              ),
              Divider(height: 24, color: Colors.grey[200]),
              _buildDetailRow(
                Icons.confirmation_number_rounded,
                'Control Number',
                '${invoice['control_number']}',
              ),
              Divider(height: 24, color: Colors.grey[200]),
              _buildDetailRow(
                Icons.calendar_today_rounded,
                'Issue Date',
                formatDate(invoice['created_at']),
              ),
            ],
          ),
        );
      },
    );
  }

  void showPaymentDetails(BuildContext context, dynamic payment) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Payment Details',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade900,
                      fontFamily: AppConstant.fontName,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close_rounded, color: Colors.grey.shade600),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildDetailRow(
                Icons.monetization_on_rounded,
                'Amount Paid',
                'TSh ${formatNumber(payment['amount_paid'])}',
                color: Colors.green.shade400,
              ),
              Divider(height: 24, color: Colors.grey[200]),
              _buildDetailRow(
                Icons.receipt_rounded,
                'Bank Reference',
                '${payment['bank_ref']}',
              ),
              Divider(height: 24, color: Colors.grey[200]),
              _buildDetailRow(
                Icons.confirmation_number_rounded,
                'Control Number',
                '${payment['control_number']}',
              ),
              Divider(height: 24, color: Colors.grey[200]),
              _buildDetailRow(
                Icons.calendar_today_rounded,
                'Payment Date',
                formatDate(payment['created_at']),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value, {Color? color}) {
    return Row(
      children: [
        Icon(icon, color: color ?? Colors.blue.shade400, size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  fontFamily: AppConstant.fontName,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: color ?? Colors.black87,
                  fontFamily: AppConstant.fontName,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          'Fees & Payments',
          style: TextStyle(
            color: Colors.blue.shade900,
            fontSize: 20,
            fontFamily: AppConstant.fontName,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.blue))
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Filter and Search
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.filter_list_rounded, size: 20, color: Colors.black87),
                          label: const Text("Filter"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[100],
                            foregroundColor: Colors.black87,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 2,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: "Search transactions...",
                              hintStyle: TextStyle(color: Colors.grey[500], fontFamily: AppConstant.fontName),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              prefixIcon: Icon(Icons.search_rounded, color: Colors.blue.shade400),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(color: Colors.grey[300]!),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Balance Container
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.red.shade700, Colors.red.shade400],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.shade200.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Paid Balance',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 16,
                                        fontFamily: AppConstant.fontName,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'TSh ${formatNumber(payments.fold<num>(0, (sum, p) => sum + num.tryParse(p['amount_paid'].toString())!))}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: AppConstant.fontName,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                            Icons.money,
                                color: Colors.white70,
                                size: 40,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          CustomPaint(
                            size: Size(double.infinity, 1),
                            painter: DashedLinePainter(),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Unpaid Balance',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 16,
                                        fontFamily: AppConstant.fontName,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'TSh ${formatNumber(outstandingBalance.toStringAsFixed(0))}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: AppConstant.fontName,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Pay via NBC Kiganjani App, Wakala, or NBC Branch',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                        fontFamily: AppConstant.fontName,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.account_balance_wallet_rounded,
                                color: Colors.white70,
                                size: 40,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Simplified Payments List
                  ListView.builder(
                    itemCount: payments.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemBuilder: (context, index) {
                      final payment = payments[index];
                      return GestureDetector(
                        onTap: () => showPaymentDetails(context, payment),
                        child: Card(
                          elevation: 3,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            leading: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.green.shade400,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.monetization_on_rounded,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            title: Text(
                              'TSh ${formatNumber(payment['amount_paid'])}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.green.shade900,
                                fontFamily: AppConstant.fontName,
                              ),
                            ),
                            subtitle: Text(
                              formatDate(payment['created_at']),
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 14,
                                fontFamily: AppConstant.fontName,
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.visibility_rounded,
                                  color: Colors.green.shade400,
                                  size: 18,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'View',
                                  style: TextStyle(
                                    color: Colors.green.shade400,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: AppConstant.fontName,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // Simplified Invoices List
                  ListView.builder(
                    itemCount: invoices.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemBuilder: (context, index) {
                      final invoice = invoices[index];
                      return GestureDetector(
                        onTap: () => showInvoiceDetails(context, invoice),
                        child: Card(
                          elevation: 3,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            leading: Container(
                              width: 60,
                              height: 50,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    getStatusColor(invoice['payment_status']),
                                    getStatusColor(invoice['payment_status']).withOpacity(0.7),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                invoice['payment_status'].toUpperCase(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  fontFamily: AppConstant.fontName,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            title: Text(
                              'TZS ${formatNumber(invoice['due_amount'])}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.blue.shade900,
                                fontFamily: AppConstant.fontName,
                              ),
                            ),
                            subtitle: Text(
                              formatDate(invoice['created_at']),
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 14,
                                fontFamily: AppConstant.fontName,
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.visibility_rounded,
                                  color: Colors.blue.shade400,
                                  size: 18,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'View',
                                  style: TextStyle(
                                    color: Colors.blue.shade400,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: AppConstant.fontName,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  // Bottom Loader
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.blue,
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white70
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const dashWidth = 5;
    const dashSpace = 5;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

String formatNumber(dynamic number) {
  final numericValue = num.tryParse(number.toString()) ?? 0;
  final formatter = NumberFormat('#,##0');
  return formatter.format(numericValue);
}