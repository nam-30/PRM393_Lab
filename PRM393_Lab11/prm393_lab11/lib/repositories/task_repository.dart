import '../models/task.dart';

class TaskRepository {
  final List<Task> _tasks = [];

  TaskRepository({List<Task>? initialTasks}) {
    if (initialTasks != null) {
      _tasks.addAll(initialTasks);
    }
  }

  /// Get unmodifiable list of tasks
  List<Task> get tasks => List.unmodifiable(_tasks);

  /// Add a new task
  void addTask(Task task) {
    _tasks.add(task);
  }

  /// Delete a task by ID
  bool deleteTask(String id) {
    final initialLength = _tasks.length;
    _tasks.removeWhere((t) => t.id == id);
    return _tasks.length < initialLength;
  }

  /// Update an existing task
  bool updateTask(Task updatedTask) {
    final index = _tasks.indexWhere((t) => t.id == updatedTask.id);
    if (index != -1) {
      _tasks[index] = updatedTask;
      return true;
    }
    return false;
  }

  /// Toggle task completion status
  bool toggleTaskCompleted(String id) {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      _tasks[index].toggle();
      return true;
    }
    return false;
  }

  /// Clear all tasks
  void clear() {
    _tasks.clear();
  }
}
