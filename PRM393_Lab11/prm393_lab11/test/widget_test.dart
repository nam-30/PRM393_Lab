import 'package:flutter_test/flutter_test.dart';
import 'package:prm393_lab11/main.dart';

void main() {
  testWidgets('Taskly App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const TasklyApp());
    expect(find.text('Taskly - My Tasks'), findsOneWidget);
    expect(find.text('No tasks yet. Add one!'), findsOneWidget);
  });
}
