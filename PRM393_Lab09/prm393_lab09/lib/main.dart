import 'package:flutter/material.dart';
import 'screens/lab_9_1_screen.dart';
import 'screens/lab_9_2_screen.dart';
import 'screens/lab_9_3_screen.dart';

void main() {
  runApp(const LocalJsonLabApp());
}

class LocalJsonLabApp extends StatelessWidget {
  const LocalJsonLabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 9 - Local JSON Storage',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
      ),
      home: const LabMainDashboard(),
    );
  }
}

class LabMainDashboard extends StatefulWidget {
  const LabMainDashboard({super.key});

  @override
  State<LabMainDashboard> createState() => _LabMainDashboardState();
}

class _LabMainDashboardState extends State<LabMainDashboard> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    Lab91Screen(),
    Lab92Screen(),
    Lab93Screen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.file_open_outlined),
            selectedIcon: Icon(Icons.file_open),
            label: '9.1 Asset JSON',
          ),
          NavigationDestination(
            icon: Icon(Icons.save_outlined),
            selectedIcon: Icon(Icons.save),
            label: '9.2 Local Storage',
          ),
          NavigationDestination(
            icon: Icon(Icons.storage_outlined),
            selectedIcon: Icon(Icons.storage),
            label: '9.3 CRUD Database',
          ),
        ],
      ),
    );
  }
}
