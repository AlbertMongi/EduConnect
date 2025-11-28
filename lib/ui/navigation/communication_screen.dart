import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:educonnect_parent_app/constant/app_constant.dart';
import 'package:educonnect_parent_app/ui/widgets/appbar.dart';
import 'package:intl/intl.dart';

class CommunicationScreen extends StatefulWidget {
  const CommunicationScreen({super.key});

  @override
  State<CommunicationScreen> createState() => _CommunicationScreenState();
}

class _CommunicationScreenState extends State<CommunicationScreen> {
  int selectedIndex = 0;
  final List<String> tabs = ['Notice Board', 'Call Centre', 'Chat'];
  List<dynamic> news = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  Future<void> fetchNews() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        setState(() {
          isLoading = false;
          errorMessage = 'No authentication token found. Please log in.';
        });
        return;
      }

      final response = await http.get(
        Uri.parse('https://nbc-educonnect.co.tz/api/parents/notification'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          news = data['news'] ?? [];
          isLoading = false;
          errorMessage = null;
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to load news: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error fetching news: $e';
      });
    }
  }

  String formatDate(String? dateString) {
    if (dateString == null) return "N/A";
    final date = DateTime.parse(dateString);
    return " ${DateFormat('dd/MM/yyyy HH:mm').format(date)}";
  }

  void showNoticeDetails(BuildContext context, Map<String, dynamic> notice) {
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
                    'Notice Details',
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
                Icons.title_rounded,
                'Title',
                notice['title']?.toString() ?? '',
                color: Colors.blue.shade400,
              ),
              Divider(height: 24, color: Colors.grey[200]),
              _buildDetailRow(
                Icons.description_rounded,
                'Description',
                notice['description']?.toString() ?? '',
                color: Colors.blue.shade400,
              ),
              Divider(height: 24, color: Colors.grey[200]),
              _buildDetailRow(
                Icons.person_rounded,
                'From',
                notice['from_user']?.toString() ?? '',
                color: Colors.blue.shade400,
              ),
              Divider(height: 24, color: Colors.grey[200]),
              _buildDetailRow(
                Icons.calendar_today_rounded,
                'Published',
                formatDate(notice['created_at']),
                color: Colors.blue.shade400,
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
                  color: Colors.black, // Changed to black font color
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
      appBar: customAppBar(context),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: List.generate(tabs.length, (index) {
                    bool isSelected = selectedIndex == index;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.red.shade900 : Colors.transparent,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: Colors.red.shade900.withOpacity(0.35),
                                      blurRadius: 6,
                                      offset: const Offset(0, 3),
                                    ),
                                  ]
                                : [],
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            tabs[index],
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black54,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              fontFamily: AppConstant.fontName,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
            if (selectedIndex == 0)
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : errorMessage != null
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  errorMessage!,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.red,
                                    fontFamily: AppConstant.fontName,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: fetchNews,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red.shade900,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: const Text(
                                    'Retry',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: AppConstant.fontName,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : news.isEmpty
                            ? const Center(
                                child: Text(
                                  'No news available',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                    fontFamily: AppConstant.fontName,
                                  ),
                                ),
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.all(8),
                                itemCount: news.length,
                                itemBuilder: (context, index) {
                                  final notice = news[index];
                                  return Card(
                                    color: Colors.white,
                                    margin: const EdgeInsets.only(bottom: 8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    elevation: 2,
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 70,
                                            height: 70,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  notice['title']?.toString() ?? '',
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: AppConstant.fontName,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  'From the ${notice['from_user'] ?? ''}',
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    fontFamily: AppConstant.fontName,
                                                  ),
                                                ),
                                                Text(
                                                  'Published: ${notice['created_at']?.toString().split('T')[0] ?? ''}',
                                                  style: const TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.grey,
                                                    fontFamily: AppConstant.fontName,
                                                  ),
                                                ),
                                                const SizedBox(height: 6),
                                                Text(
                                                  (notice['description']?.toString() ?? '').length > 100
                                                      ? '${notice['description'].substring(0, 100)}...'
                                                      : notice['description']?.toString() ?? '',
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    fontFamily: AppConstant.fontName,
                                                  ),
                                                ),
                                                const SizedBox(height: 12),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    ElevatedButton(
                                                      onPressed: () => showNoticeDetails(context, notice),
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor: Colors.red.shade900,
                                                        foregroundColor: Colors.white,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(16),
                                                        ),
                                                        minimumSize: const Size(80, 32),
                                                      ),
                                                      child: const Text(
                                                        'Read More',
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontFamily: AppConstant.fontName,
                                                        ),
                                                      ),
                                                    ),
                                                    Text('ⓒ ${index + 157}', style: const TextStyle(fontSize: 10)),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
              ),
            if (selectedIndex == 1 || selectedIndex == 2)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/assignment.png',
                        height: 80,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'No Notification!',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          fontFamily: AppConstant.fontName,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}