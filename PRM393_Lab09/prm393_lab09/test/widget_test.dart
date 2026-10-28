import 'package:flutter_test/flutter_test.dart';
import 'package:prm393_lab09/main.dart';

void main() {
  testWidgets('Lab 9 App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const LocalJsonLabApp());

    // Verify main navigation bar items exist
    expect(find.text('9.1 Asset JSON'), findsOneWidget);
    expect(find.text('9.2 Local Storage'), findsOneWidget);
    expect(find.text('9.3 CRUD Database'), findsOneWidget);
  });
}
