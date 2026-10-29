import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prm393_lab11/main.dart';
import 'package:prm393_lab11/repositories/task_repository.dart';

void main() {
  group('Taskly Integration Tests (Full Flow)', () {
    testWidgets('Full flow: Add "Original title" -> Open detail -> Edit to "Updated title" -> Save -> Verify in list', (WidgetTester tester) async {
      // Arrange
      final repository = TaskRepository();
      await tester.pumpWidget(TasklyApp(repository: repository));
      await tester.pumpAndSettle();

      // Step 1: Add "Original title"
      await tester.enterText(find.byType(TextField), 'Original title');
      await tester.tap(find.text('Add'));
      await tester.pumpAndSettle();

      expect(find.text('Original title'), findsOneWidget);

      // Step 2: Tap task -> open detail
      await tester.tap(find.text('Original title'));
      await tester.pumpAndSettle();

      expect(find.text('Task Detail'), findsOneWidget);

      // Step 3: Edit -> "Updated title"
      final titleField = find.byKey(const Key('detailTitleField'));
      await tester.enterText(titleField, 'Updated title');

      // Step 4: Save
      await tester.tap(find.text('Save Changes'));
      await tester.pumpAndSettle();

      // Step 5: Verify updated title appears in list
      expect(find.text('Updated title'), findsOneWidget);
      expect(find.text('Original title'), findsNothing);
    });
  });
}
