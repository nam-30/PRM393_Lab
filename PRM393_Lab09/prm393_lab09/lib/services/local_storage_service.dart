import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import '../models/student.dart';

class LocalStorageService {
  final String fileName;

  LocalStorageService({this.fileName = 'local_students.json'});

  // Get the local file path from application documents directory
  Future<File> get _localFile async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$fileName');
  }

  // Read students from local JSON file
  // If local file does not exist, initialize it with data from assets
  Future<List<Student>> loadStudents() async {
    try {
      final file = await _localFile;

      if (!await file.exists()) {
        // Load default students from asset file
        final String assetContent =
            await rootBundle.loadString('assets/data/students.json');
        final List<dynamic> jsonList = jsonDecode(assetContent);
        final List<Student> defaultStudents =
            jsonList.map((item) => Student.fromJson(item)).toList();

        // Save default students to local storage file
        await saveStudents(defaultStudents);
        return defaultStudents;
      }

      // Read content from local file
      final String fileContent = await file.readAsString();
      if (fileContent.trim().isEmpty) {
        return [];
      }

      final List<dynamic> jsonList = jsonDecode(fileContent);
      return jsonList.map((item) => Student.fromJson(item)).toList();
    } catch (e) {
      debugPrint('Error loading students from local storage: $e');
      return [];
    }
  }

  // Save list of students to local JSON file
  Future<bool> saveStudents(List<Student> students) async {
    try {
      final file = await _localFile;
      final List<Map<String, dynamic>> jsonList =
          students.map((student) => student.toJson()).toList();
      final String jsonString = const JsonEncoder.withIndent('  ').convert(jsonList);

      await file.writeAsString(jsonString);
      return true;
    } catch (e) {
      debugPrint('Error saving students to local storage: $e');
      return false;
    }
  }

  // Helper method to clear local JSON file (Reset to assets default)
  Future<List<Student>> resetToDefault() async {
    try {
      final file = await _localFile;
      if (await file.exists()) {
        await file.delete();
      }
      return await loadStudents();
    } catch (e) {
      debugPrint('Error resetting local file: $e');
      return [];
    }
  }
}
