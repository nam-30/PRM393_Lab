import 'package:flutter/material.dart';
import '../models/student.dart';
import '../services/local_storage_service.dart';

class Lab92Screen extends StatefulWidget {
  const Lab92Screen({super.key});

  @override
  State<Lab92Screen> createState() => _Lab92ScreenState();
}

class _Lab92ScreenState extends State<Lab92Screen> {
  final LocalStorageService _storageService =
      LocalStorageService(fileName: 'lab_9_2_students.json');

  List<Student> _students = [];
  bool _isLoading = true;

  // Controllers for Add Item form
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _majorController = TextEditingController();
  final _gpaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadLocalData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _majorController.dispose();
    _gpaController.dispose();
    super.dispose();
  }

  // Load data from local JSON file in application documents directory
  Future<void> _loadLocalData() async {
    setState(() => _isLoading = true);
    final loadedList = await _storageService.loadStudents();
    setState(() {
      _students = loadedList;
      _isLoading = false;
    });
  }

  // Save current student list to local JSON file
  Future<void> _saveLocalData() async {
    final success = await _storageService.saveStudents(_students);
    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('JSON data successfully saved to Local Storage!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to save JSON data to Local Storage.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Add new student item to list and auto-save
  void _addStudent() {
    if (_formKey.currentState!.validate()) {
      final String id = (_students.length + 1).toString();
      final newStudent = Student(
        id: id,
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        major: _majorController.text.trim(),
        gpa: double.tryParse(_gpaController.text.trim()) ?? 0.0,
      );

      setState(() {
        _students.add(newStudent);
      });

      // Clear text fields
      _nameController.clear();
      _emailController.clear();
      _majorController.clear();
      _gpaController.clear();

      // Save changes to device local JSON storage
      _saveLocalData();
    }
  }

  // Reset local file back to default asset data
  Future<void> _resetData() async {
    setState(() => _isLoading = true);
    final defaultList = await _storageService.resetToDefault();
    setState(() {
      _students = defaultList;
      _isLoading = false;
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Reset local storage to initial asset JSON data.'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab 9.2: Local JSON Storage'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'Save to JSON File',
            onPressed: _saveLocalData,
          ),
          IconButton(
            icon: const Icon(Icons.restore),
            tooltip: 'Reset to Initial Assets',
            onPressed: _resetData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Form Card to Add Item
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              'Add New Student to Local JSON',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _nameController,
                                    decoration: const InputDecoration(
                                      labelText: 'Full Name',
                                      prefixIcon: Icon(Icons.person, size: 20),
                                      border: OutlineInputBorder(),
                                      isDense: true,
                                    ),
                                    validator: (val) => val == null || val.isEmpty
                                        ? 'Required'
                                        : null,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TextFormField(
                                    controller: _emailController,
                                    decoration: const InputDecoration(
                                      labelText: 'Email',
                                      prefixIcon: Icon(Icons.email, size: 20),
                                      border: OutlineInputBorder(),
                                      isDense: true,
                                    ),
                                    validator: (val) => val == null || val.isEmpty
                                        ? 'Required'
                                        : null,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: TextFormField(
                                    controller: _majorController,
                                    decoration: const InputDecoration(
                                      labelText: 'Major',
                                      prefixIcon: Icon(Icons.school, size: 20),
                                      border: OutlineInputBorder(),
                                      isDense: true,
                                    ),
                                    validator: (val) => val == null || val.isEmpty
                                        ? 'Required'
                                        : null,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  flex: 1,
                                  child: TextFormField(
                                    controller: _gpaController,
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                            decimal: true),
                                    decoration: const InputDecoration(
                                      labelText: 'GPA',
                                      prefixIcon: Icon(Icons.grade, size: 20),
                                      border: OutlineInputBorder(),
                                      isDense: true,
                                    ),
                                    validator: (val) {
                                      if (val == null || val.isEmpty) return 'Req';
                                      final num? gpa = double.tryParse(val);
                                      if (gpa == null || gpa < 0 || gpa > 4.0) {
                                        return '0-4.0';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton.icon(
                              onPressed: _addStudent,
                              icon: const Icon(Icons.add),
                              label: const Text('Add & Save to Device JSON'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal,
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Stored Students (${_students.length})',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: _saveLocalData,
                        icon: const Icon(Icons.save_outlined, size: 18),
                        label: const Text('Save File'),
                      ),
                    ],
                  ),
                  const Divider(),
                  // List of stored items
                  Expanded(
                    child: _students.isEmpty
                        ? const Center(
                            child: Text('No local JSON records stored yet.'))
                        : ListView.builder(
                            itemCount: _students.length,
                            itemBuilder: (context, index) {
                              final student = _students[index];
                              return Card(
                                margin: const EdgeInsets.only(bottom: 8),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.teal,
                                    foregroundColor: Colors.white,
                                    child: Text(student.id),
                                  ),
                                  title: Text(
                                    student.name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                      '${student.email} • ${student.major}'),
                                  trailing: Text(
                                    'GPA: ${student.gpa.toStringAsFixed(1)}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.teal,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
    );
  }
}
