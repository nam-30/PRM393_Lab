import 'package:flutter_test/flutter_test.dart';
import 'package:prm393_lab11/models/task.dart';
import 'package:prm393_lab11/repositories/task_repository.dart';

void main() {
  group('TaskRepository Unit Tests', () {
    late TaskRepository repository;

    setUp(() {
      repository = TaskRepository();
    });

    test('addTask() should add a new task to repository', () {
      // Arrange
      final task = Task(id: '1', title: 'Buy Groceries');

      // Act
      repository.addTask(task);

      // Assert
      expect(repository.tasks.length, 1);
      expect(repository.tasks.first.title, 'Buy Groceries');
    });

    test('deleteTask() should remove a task by id from repository', () {
      // Arrange
      final task1 = Task(id: '1', title: 'Task 1');
      final task2 = Task(id: '2', title: 'Task 2');
      repository.addTask(task1);
      repository.addTask(task2);

      // Act
      final success = repository.deleteTask('1');

      // Assert
      expect(success, true);
      expect(repository.tasks.length, 1);
      expect(repository.tasks.first.id, '2');
    });

    test('updateTask() should update an existing task in repository', () {
      // Arrange
      final task = Task(id: '1', title: 'Original Title');
      repository.addTask(task);

      final updatedTask = task.copyWith(title: 'Updated Title');

      // Act
      final success = repository.updateTask(updatedTask);

      // Assert
      expect(success, true);
      expect(repository.tasks.first.title, 'Updated Title');
    });
  });
}
