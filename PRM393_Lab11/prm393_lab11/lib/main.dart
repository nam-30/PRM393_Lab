import 'package:flutter/material.dart';
import 'repositories/task_repository.dart';
import 'screens/task_list_screen.dart';

void main() {
  runApp(const TasklyApp());
}

class TasklyApp extends StatelessWidget {
  final TaskRepository? repository;

  const TasklyApp({super.key, this.repository});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taskly App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      home: TaskListScreen(
        repository: repository ?? TaskRepository(),
      ),
    );
  }
}
