import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/student.dart';

class Lab91Screen extends StatefulWidget {
  const Lab91Screen({super.key});

  @override
  State<Lab91Screen> createState() => _Lab91ScreenState();
}

class _Lab91ScreenState extends State<Lab91Screen> {
  List<Student> _students = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadAssetJson();
  }

  // Load JSON file embedded in assets directory using rootBundle
  Future<void> _loadAssetJson() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Step 3: Load raw JSON string from assets/data/students.json
      final String jsonString =
          await rootBundle.loadString('assets/data/students.json');

      // Step 4: Decode JSON string into a Dart List
      final List<dynamic> rawList = jsonDecode(jsonString);

      // Convert dynamic list to List<Student>
      final List<Student> studentList =
          rawList.map((item) => Student.fromJson(item)).toList();

      setState(() {
        _students = studentList;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load JSON asset: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab 9.1: Read JSON Assets'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reload Asset JSON',
            onPressed: _loadAssetJson,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading JSON data from assets/data/students.json...'),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 60),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _loadAssetJson,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              )
            ],
          ),
        ),
      );
    }

    if (_students.isEmpty) {
      return const Center(
        child: Text('No students found in JSON asset file.'),
      );
    }

    return Column(
      children: [
        // Information Banner
        Container(
          width: double.infinity,
          color: Colors.indigo.shade50,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              const Icon(Icons.info_outline, color: Colors.indigo),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Loaded ${_students.length} students directly from "assets/data/students.json" using rootBundle.loadString().',
                  style: const TextStyle(
                      color: Colors.indigo, fontSize: 13, height: 1.3),
                ),
              ),
            ],
          ),
        ),
        // Step 5: Display Data using ListView.builder
        Expanded(
          child: RefreshIndicator(
            onRefresh: _loadAssetJson,
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _students.length,
              itemBuilder: (context, index) {
                final student = _students[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    leading: CircleAvatar(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      child: Text(
                        student.id,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(
                      student.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.email_outlined,
                                size: 14, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(student.email),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(Icons.school_outlined,
                                size: 14, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(student.major),
                          ],
                        ),
                      ],
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: student.gpa >= 3.5
                            ? Colors.green.shade100
                            : Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'GPA: ${student.gpa.toStringAsFixed(1)}',
                        style: TextStyle(
                          color: student.gpa >= 3.5
                              ? Colors.green.shade900
                              : Colors.orange.shade900,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
