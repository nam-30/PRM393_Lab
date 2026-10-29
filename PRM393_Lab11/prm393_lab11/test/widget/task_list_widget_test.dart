import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prm393_lab11/main.dart';
import 'package:prm393_lab11/repositories/task_repository.dart';

void main() {
  group('Task List Widget Tests', () {
    testWidgets('Empty State displays "No tasks yet. Add one!"', (WidgetTester tester) async {
      // Arrange
      final repository = TaskRepository();

      // Act
      await tester.pumpWidget(TasklyApp(repository: repository));

      // Assert
      expect(find.text('No tasks yet. Add one!'), findsOneWidget);
    });

    testWidgets('Add Task: enter text -> tap add -> verify UI updates', (WidgetTester tester) async {
      // Arrange
      final repository = TaskRepository();
      await tester.pumpWidget(TasklyApp(repository: repository));

      // Act
      await tester.enterText(find.byType(TextField), 'Buy Milk');
      await tester.tap(find.text('Add'));
      await tester.pump();

      // Assert
      expect(find.text('Buy Milk'), findsOneWidget);
      expect(find.text('No tasks yet. Add one!'), findsNothing);
    });

    testWidgets('Multiple Tasks: add two tasks -> verify both visible', (WidgetTester tester) async {
      // Arrange
      final repository = TaskRepository();
      await tester.pumpWidget(TasklyApp(repository: repository));

      // Act: Add Task 1
      await tester.enterText(find.byType(TextField), 'First Task');
      await tester.tap(find.text('Add'));
      await tester.pump();

      // Act: Add Task 2
      await tester.enterText(find.byType(TextField), 'Second Task');
      await tester.tap(find.text('Add'));
      await tester.pump();

      // Assert
      expect(find.text('First Task'), findsOneWidget);
      expect(find.text('Second Task'), findsOneWidget);
    });
  });
}
