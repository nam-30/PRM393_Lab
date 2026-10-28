import 'package:flutter/material.dart';
import '../models/student.dart';
import '../services/local_storage_service.dart';

class Lab93Screen extends StatefulWidget {
  const Lab93Screen({super.key});

  @override
  State<Lab93Screen> createState() => _Lab93ScreenState();
}

class _Lab93ScreenState extends State<Lab93Screen> {
  final LocalStorageService _storageService =
      LocalStorageService(fileName: 'lab_9_3_database.json');

  List<Student> _allStudents = [];
  List<Student> _filteredStudents = [];
  bool _isLoading = true;
  String _searchQuery = '';

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Load students from device JSON database
  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final list = await _storageService.loadStudents();
    setState(() {
      _allStudents = list;
      _applySearch();
      _isLoading = false;
    });
  }

  // Filter list based on search query
  void _applySearch() {
    if (_searchQuery.trim().isEmpty) {
      _filteredStudents = List.from(_allStudents);
    } else {
      final query = _searchQuery.toLowerCase();
      _filteredStudents = _allStudents.where((student) {
        return student.name.toLowerCase().contains(query) ||
            student.email.toLowerCase().contains(query) ||
            student.major.toLowerCase().contains(query) ||
            student.id.toLowerCase().contains(query);
      }).toList();
    }
  }

  // Auto-save changes to JSON database file
  Future<void> _autoSave() async {
    final success = await _storageService.saveStudents(_allStudents);
    if (!mounted) return;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Database auto-saved to JSON storage!'),
          duration: Duration(seconds: 1),
          backgroundColor: Colors.deepPurple,
        ),
      );
    }
  }

  // Generate unique incremental ID (e.g., STU001, STU002, etc.)
  String _generateNextId() {
    if (_allStudents.isEmpty) return 'STU001';
    int maxNum = 0;
    for (var s in _allStudents) {
      final clean = s.id.replaceAll(RegExp(r'[^0-9]'), '');
      final val = int.tryParse(clean) ?? 0;
      if (val > maxNum) maxNum = val;
    }
    final nextNum = maxNum + 1;
    return 'STU${nextNum.toString().padLeft(3, '0')}';
  }

  // Dialog to Add or Edit Student
  void _showStudentDialog({Student? student}) {
    final isEditing = student != null;
    final nameCtrl = TextEditingController(text: student?.name ?? '');
    final emailCtrl = TextEditingController(text: student?.email ?? '');
    final majorCtrl = TextEditingController(text: student?.major ?? '');
    final gpaCtrl =
        TextEditingController(text: student != null ? student.gpa.toString() : '');
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(isEditing ? 'Edit Student (${student.id})' : 'Add New Student'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Enter name' : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: emailCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Email Address',
                      prefixIcon: Icon(Icons.email),
                    ),
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Enter email' : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: majorCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Major',
                      prefixIcon: Icon(Icons.school),
                    ),
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Enter major' : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: gpaCtrl,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'GPA (0.0 - 4.0)',
                      prefixIcon: Icon(Icons.grade),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Enter GPA';
                      final val = double.tryParse(v.trim());
                      if (val == null || val < 0.0 || val > 4.0) {
                        return 'GPA must be between 0.0 and 4.0';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final String name = nameCtrl.text.trim();
                  final String email = emailCtrl.text.trim();
                  final String major = majorCtrl.text.trim();
                  final double gpa = double.parse(gpaCtrl.text.trim());

                  setState(() {
                    if (isEditing) {
                      // Update existing item
                      final index = _allStudents
                          .indexWhere((item) => item.id == student.id);
                      if (index != -1) {
                        _allStudents[index] = student.copyWith(
                          name: name,
                          email: email,
                          major: major,
                          gpa: gpa,
                        );
                      }
                    } else {
                      // Create new item with auto-generated ID
                      final newStudent = Student(
                        id: _generateNextId(),
                        name: name,
                        email: email,
                        major: major,
                        gpa: gpa,
                      );
                      _allStudents.insert(0, newStudent);
                    }
                    _applySearch();
                  });

                  Navigator.pop(dialogContext);
                  _autoSave();
                }
              },
              child: Text(isEditing ? 'Save Changes' : 'Create Student'),
            ),
          ],
        );
      },
    );
  }

  // Confirm delete dialog before removing item
  void _confirmDelete(Student student) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: Text(
              'Are you sure you want to delete "${student.name}" (${student.id}) from local database?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  _allStudents.removeWhere((item) => item.id == student.id);
                  _applySearch();
                });
                Navigator.pop(dialogContext);
                _autoSave();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab 9.3: JSON CRUD Database'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reload Database',
            onPressed: _loadData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Search Bar Widget
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Search students by name, email, or major...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _searchQuery = '';
                                  _applySearch();
                                });
                              },
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                    ),
                    onChanged: (val) {
                      setState(() {
                        _searchQuery = val;
                        _applySearch();
                      });
                    },
                  ),
                ),
                // Database count badge
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Records: ${_allStudents.length}',
                        style: TextStyle(
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w600),
                      ),
                      if (_searchQuery.isNotEmpty)
                        Text(
                          'Matches: ${_filteredStudents.length}',
                          style: const TextStyle(
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.bold),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                // Main List view
                Expanded(
                  child: _filteredStudents.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _searchQuery.isNotEmpty
                                    ? Icons.search_off
                                    : Icons.storage,
                                size: 64,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                _searchQuery.isNotEmpty
                                    ? 'No students match "$_searchQuery"'
                                    : 'Database is empty. Tap "+" to add a student.',
                                style: TextStyle(
                                    color: Colors.grey.shade600, fontSize: 16),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          itemCount: _filteredStudents.length,
                          itemBuilder: (context, index) {
                            final student = _filteredStudents[index];
                            return Card(
                              elevation: 2,
                              margin: const EdgeInsets.only(bottom: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.deepPurple,
                                  foregroundColor: Colors.white,
                                  child: Text(
                                    student.id.length > 3
                                        ? student.id.substring(student.id.length - 3)
                                        : student.id,
                                    style: const TextStyle(
                                        fontSize: 12, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                title: Text(
                                  student.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4),
                                    Text('Email: ${student.email}'),
                                    Text('Major: ${student.major}'),
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      margin: const EdgeInsets.only(right: 8),
                                      decoration: BoxDecoration(
                                        color: Colors.deepPurple.shade50,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        'GPA: ${student.gpa.toStringAsFixed(1)}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.deepPurple,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.edit,
                                          color: Colors.blue),
                                      tooltip: 'Edit Student',
                                      onPressed: () =>
                                          _showStudentDialog(student: student),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red),
                                      tooltip: 'Delete Student',
                                      onPressed: () => _confirmDelete(student),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showStudentDialog(),
        icon: const Icon(Icons.person_add),
        label: const Text('Add Student'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
    );
  }
}
