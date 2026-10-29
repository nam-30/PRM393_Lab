import 'package:flutter_test/flutter_test.dart';
import 'package:prm393_lab11/models/task.dart';

void main() {
  group('Task Model Unit Tests', () {
    test('Default isCompleted value should be false', () {
      // Arrange & Act
      final task = Task(id: '1', title: 'Test Task');

      // Assert
      expect(task.isCompleted, false);
    });

    test('toggle() should switch isCompleted true <-> false', () {
      // Arrange
      final task = Task(id: '1', title: 'Test Task', isCompleted: false);

      // Act 1: First toggle
      task.toggle();

      // Assert 1
      expect(task.isCompleted, true);

      // Act 2: Second toggle
      task.toggle();

      // Assert 2
      expect(task.isCompleted, false);
    });
  });
}
