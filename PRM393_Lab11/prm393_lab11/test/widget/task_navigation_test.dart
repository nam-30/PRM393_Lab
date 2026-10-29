import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prm393_lab11/main.dart';
import 'package:prm393_lab11/models/task.dart';
import 'package:prm393_lab11/repositories/task_repository.dart';

void main() {
  group('Task Navigation Tests', () {
    testWidgets('Tap seeded task navigates to TaskDetailScreen with detailTitleField', (WidgetTester tester) async {
      // Arrange: Seed repository with one task
      final seededTask = Task(id: '101', title: 'Seeded Navigation Task');
      final repository = TaskRepository(initialTasks: [seededTask]);

      // Act 1: Pump TaskListScreen
      await tester.pumpWidget(TasklyApp(repository: repository));

      // Assert 1: Seeded task is on screen
      expect(find.text('Seeded Navigation Task'), findsOneWidget);

      // Act 2: Tap seeded task to navigate
      await tester.tap(find.text('Seeded Navigation Task'));
      await tester.pumpAndSettle();

      // Assert 2: Verify AppBar title and detailTitleField key exist
      expect(find.text('Task Detail'), findsOneWidget);
      expect(find.byKey(const Key('detailTitleField')), findsOneWidget);
    });
  });
}
