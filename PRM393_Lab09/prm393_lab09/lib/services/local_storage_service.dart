import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import '../models/student.dart';

class LocalStorageService {
  final String fileName;
  
  // In-memory fallback cache for web/test environments
  static final Map<String, List<Student>> _inMemoryCache = {};

  LocalStorageService({this.fileName = 'local_students.json'});

  // Get local file safely. Returns null if path_provider fails (e.g., in Web or Test)
  Future<File?> get _localFile async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      return File('${directory.path}/$fileName');
    } catch (e) {
      debugPrint('path_provider not supported in current environment: $e');
      return null;
    }
  }

  // Read students from local JSON file or asset fallback
  Future<List<Student>> loadStudents() async {
    try {
      final file = await _localFile;

      if (file == null) {
        // Fallback for Web/Test environment using in-memory cache or assets
        if (_inMemoryCache.containsKey(fileName)) {
          return List.from(_inMemoryCache[fileName]!);
        }
        return await _loadFromAssets();
      }

      if (!await file.exists()) {
        // First-time initialization from asset JSON
        final defaultStudents = await _loadFromAssets();
        await saveStudents(defaultStudents);
        return defaultStudents;
      }

      final String fileContent = await file.readAsString();
      if (fileContent.trim().isEmpty) {
        return [];
      }

      final List<dynamic> jsonList = jsonDecode(fileContent);
      final list = jsonList.map((item) => Student.fromJson(item)).toList();
      _inMemoryCache[fileName] = List.from(list);
      return list;
    } catch (e) {
      debugPrint('Error loading students from local storage: $e');
      return await _loadFromAssets();
    }
  }

  // Helper to load default asset JSON
  Future<List<Student>> _loadFromAssets() async {
    try {
      final String assetContent =
          await rootBundle.loadString('assets/data/students.json');
      final List<dynamic> jsonList = jsonDecode(assetContent);
      final list = jsonList.map((item) => Student.fromJson(item)).toList();
      _inMemoryCache[fileName] = List.from(list);
      return list;
    } catch (e) {
      debugPrint('Error loading asset JSON: $e');
      return [];
    }
  }

  // Save list of students to local JSON file
  Future<bool> saveStudents(List<Student> students) async {
    _inMemoryCache[fileName] = List.from(students);
    try {
      final file = await _localFile;
      if (file == null) return true; // Saved to in-memory fallback

      final List<Map<String, dynamic>> jsonList =
          students.map((student) => student.toJson()).toList();
      final String jsonString =
          const JsonEncoder.withIndent('  ').convert(jsonList);

      await file.writeAsString(jsonString);
      return true;
    } catch (e) {
      debugPrint('Error saving students to local storage: $e');
      return false;
    }
  }

  // Reset local file back to asset defaults
  Future<List<Student>> resetToDefault() async {
    try {
      final file = await _localFile;
      if (file != null && await file.exists()) {
        await file.delete();
      }
      _inMemoryCache.remove(fileName);
      return await loadStudents();
    } catch (e) {
      debugPrint('Error resetting local file: $e');
      return [];
    }
  }
}
