// --- SAME IMPORTS ---
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

  // --- SAME API FUNCTIONS ---

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
    }
  }

  // --- UI HELPERS ---
  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "paid":
        return Colors.green;
      case "partial":
        return Colors.orange;
      case "unpaid":
        return Colors.red;
      default:
        return Colors.blueGrey;
    }
  }

  String formatDate(String? dateString) {
    if (dateString == null) return "N/A";
    final date = DateTime.parse(dateString);
    return DateFormat('dd MMM, yyyy – HH:mm').format(date);
  }

  // ---------- MODERN BOTTOM SHEET ----------
  void showInvoiceDetails(BuildContext context, dynamic invoice) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder:
          (_) => _buildBottomSheet(
            title: "Invoice Details",
            color: Colors.blue.shade900,
            rows: [
              _sheetRow(
                Icons.payment,
                "Status",
                invoice['payment_status'].toUpperCase(),
                color: getStatusColor(invoice['payment_status']),
              ),
              _sheetRow(
                Icons.money,
                "Due Amount",
                "TSh ${formatNumber(invoice['due_amount'])}",
              ),
              _sheetRow(
                Icons.receipt,
                "Control Number",
                invoice['control_number'].toString(),
              ),
              _sheetRow(
                Icons.calendar_today,
                "Issued On",
                formatDate(invoice['created_at']),
              ),
            ],
          ),
    );
  }

  void showPaymentDetails(BuildContext context, dynamic payment) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder:
          (_) => _buildBottomSheet(
            title: "Payment Details",
            color: Colors.green.shade800,
            rows: [
              _sheetRow(
                Icons.monetization_on,
                "Amount Paid",
                "TSh ${formatNumber(payment['amount_paid'])}",
                color: Colors.green,
              ),
              _sheetRow(
                Icons.receipt_long,
                "Bank Ref",
                payment['bank_ref'].toString(),
              ),
              _sheetRow(
                Icons.confirmation_number,
                "Control Number",
                payment['control_number'].toString(),
              ),
              _sheetRow(
                Icons.calendar_today,
                "Paid On",
                formatDate(payment['created_at']),
              ),
            ],
          ),
    );
  }

  Widget _buildBottomSheet({
    required String title,
    required Color color,
    required List<Widget> rows,
  }) {
    return Padding(
      padding: const EdgeInsets.all(22),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 45,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            title,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
              fontFamily: AppConstant.fontName,
            ),
          ),
          const SizedBox(height: 20),
          ...rows,
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _sheetRow(IconData icon, String label, String value, {Color? color}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: (color ?? Colors.blue).withOpacity(.15),
            child: Icon(icon, color: color ?? Colors.blue),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontFamily: AppConstant.fontName,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    fontFamily: AppConstant.fontName,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- MODERN MAIN UI -------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Fees & Payments",
          style: TextStyle(
            color: Colors.blue.shade900,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            fontFamily: AppConstant.fontName,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildBalanceCard(),

                    const SizedBox(height: 25),
                    _sectionHeader("Recent Payments"),
                    _buildPaymentList(),

                    const SizedBox(height: 25),
                    _sectionHeader("Invoices"),
                    _buildInvoiceList(),
                  ],
                ),
              ),
    );
  }

  // -------------------------------------------------------
  // -------------------- UI SECTIONS -----------------------
  // -------------------------------------------------------

  Widget _buildBalanceCard() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          colors: [Colors.indigo.shade700, Colors.indigo.shade400],
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 15,
            color: Colors.indigo.withOpacity(0.3),
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _balanceText("Paid Balance", Colors.white70),
          Text(
            "TSh ${formatNumber(payments.fold(0, (s, p) => s + int.parse(p['amount_paid'].toString())))}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 27,
              fontWeight: FontWeight.bold,
              fontFamily: AppConstant.fontName,
            ),
          ),
          const SizedBox(height: 20),
          _balanceText("Unpaid Balance", Colors.white70),
          Text(
            "TSh ${formatNumber(outstandingBalance.toStringAsFixed(0))}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 27,
              fontWeight: FontWeight.bold,
              fontFamily: AppConstant.fontName,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Make payment via NBC Kiganjani, Wakala, or any NBC branch.",
            style: TextStyle(color: Colors.white70, fontSize: 13, fontFamily: AppConstant.fontName),
          ),
        ],
      ),
    );
  }

  Widget _balanceText(String text, Color color) => Text(
    text,
    style: TextStyle(
      color: color,
      fontSize: 16,
      fontFamily: AppConstant.fontName,
      fontWeight: FontWeight.w400,
    ),
  );

  Widget _sectionHeader(String title) => Align(
    alignment: Alignment.centerLeft,
    child: Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Colors.grey.shade800,
          fontFamily: AppConstant.fontName,
        ),
      ),
    ),
  );

  // ------------------ LIST WIDGETS ---------------------

  Widget _buildPaymentList() {
    return Column(
      children:
          payments.map((payment) {
            return _modernCard(
              color: Colors.green,
              title: "TSh ${formatNumber(payment['amount_paid'])}",
              subtitle: formatDate(payment['created_at']),
              onTap: () => showPaymentDetails(context, payment),
            );
          }).toList(),
    );
  }

  Widget _buildInvoiceList() {
    return Column(
      children:
          invoices.map((inv) {
            return _modernCard(
              color: getStatusColor(inv['payment_status']),
              title: "TSh ${formatNumber(inv['due_amount'])}",
              subtitle: formatDate(inv['created_at']),
              badge: inv['payment_status'].toUpperCase(),
              onTap: () => showInvoiceDetails(context, inv),
            );
          }).toList(),
    );
  }

  Widget _modernCard({
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    String? badge,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              color: Colors.black12.withOpacity(0.06),
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: color.withOpacity(.15),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.receipt_long, color: color),
            ),
            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),

            if (badge != null)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: color.withOpacity(.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  badge,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

String formatNumber(dynamic number) {
  final numericValue = num.tryParse(number.toString().replaceAll(",", "")) ?? 0;
  return NumberFormat('#,##0').format(numericValue);
}
