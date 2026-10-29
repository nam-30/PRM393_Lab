import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prm393_lab09/main.dart';

void main() {
  testWidgets('Lab 9 App smoke & navigation test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const LocalJsonLabApp());
    await tester.pump(const Duration(milliseconds: 500));

    // Verify main navigation bar destinations exist
    expect(find.text('9.1 Asset JSON'), findsOneWidget);
    expect(find.text('9.2 Local Storage'), findsOneWidget);
    expect(find.text('9.3 CRUD Database'), findsOneWidget);

    // Verify initial screen title is Lab 9.1
    expect(find.text('Lab 9.1: Read JSON Assets'), findsOneWidget);

    // Tap on second tab (9.2 Local Storage)
    await tester.tap(find.byIcon(Icons.save_outlined));
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Lab 9.2: Local JSON Storage'), findsOneWidget);

    // Tap on third tab (9.3 CRUD Database)
    await tester.tap(find.byIcon(Icons.storage_outlined));
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Lab 9.3: JSON CRUD Database'), findsOneWidget);
  });
}
