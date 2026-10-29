import 'package:flutter_test/flutter_test.dart';
import 'package:prm393_lab10/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('Lab 10 App smoke test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    // Build our app and trigger a frame.
    await tester.pumpWidget(const Lab10App());
    
    // Fast-forward fake timer past splash screen
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    // Verify app navigated to Integrated Login screen
    expect(find.text('Welcome Back'), findsOneWidget);
    expect(find.text('Sign In with REST API'), findsOneWidget);
  });
}
