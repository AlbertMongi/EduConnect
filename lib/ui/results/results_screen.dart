import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:educonnect_parent_app/constant/app_constant.dart'; // Assuming this is available or adjust as needed

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({super.key});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  List<dynamic> results = [];
  bool isLoading = true;

  int selectedIndex = 0;

  final List<String> tabs = ['Results', 'Performance'];

  @override
  void initState() {
    super.initState();
    fetchResults();
  }

  Future<void> fetchResults() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('https://nbc-educonnect.co.tz/api/parents/results/index'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        results = data['results'] ?? [];
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
    }
  }

  String getStatus(String scoreStr, String grade) {
    int score = int.tryParse(scoreStr) ?? 0;
    switch (grade.toUpperCase()) {
      case "A+":
        return score == 100 ? "Outstanding" : "Excellent";
      case "A":
        return "Excellent";
      case "B":
      case "B+":
        return "Good";
      case "C":
        return "Average";
      case "D":
        return "Poor";
      default:
        return "N/A";
    }
  }

  String toTitleCase(String text) {
    if (text.isEmpty) return text;
    return text.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.black),
          onPressed: () => Navigator.pop(context),
          
        ),
        centerTitle: true,
        title: Text(
          "Result & Performance",
          style: TextStyle(
            color: Colors.blue.shade900,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Column(
                children: [
                  // Tab buttons with animated highlight
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(
                          0xFFF5F5F5,
                        ),
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
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      isSelected
                                          ? Colors.red.shade900
                                          : Colors.transparent,
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow:
                                      isSelected
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

                  // Content for "Results"
                  if (selectedIndex == 0)
                    Expanded(
                      child: buildResultsContent(),
                    ),

                  if (selectedIndex == 1)
                    const Expanded(
                      child: Center(
                        child: Text("Coming soon..."),
                      ),
                    ),
                ],
              ),
            ),
    );
  }

  Widget buildResultsContent() {
    return Column(
      children: [
        // Sub-tabs
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "Quizzes",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: GestureDetector(
                  onTap: () {},
                  child: const Text(
                    "Test",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: GestureDetector(
                  onTap: () {},
                  child: const Text(
                    "Exams",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Search Bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                SizedBox(width: 12),
                Icon(Icons.search, color: Colors.black54),
                SizedBox(width: 8),
                Text(
                  "Search",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Table Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: const [
              Expanded(
                flex: 3,
                child: Text(
                  "Subject",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  "Score",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  "Grade",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  "Status",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  "Remark",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ],
          ),
        ),

        // Results List
        Expanded(
          child: ListView.separated(
            itemCount: results.length,
            separatorBuilder: (context, index) => Divider(
              color: Colors.grey.shade200,
              height: 1,
              thickness: 1,
            ),
            itemBuilder: (context, index) {
              final result = results[index];
              final scoreStr = result['score']?.toString() ?? "";
              final grade = result['grade'] ?? "";
              final subject = toTitleCase(result['subject']?.toString() ?? "");
              final status = getStatus(scoreStr, grade);
              final remark = result['remark']?.toString() ?? "N/A"; // Fetch remark, default to "N/A" if null

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        subject,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        scoreStr,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        grade,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        status,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        remark,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}