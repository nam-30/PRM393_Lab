import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/notification_service.dart';
import '../services/session_service.dart';
import 'home_screen.dart';

class Lab104Screen extends StatefulWidget {
  const Lab104Screen({super.key});

  @override
  State<Lab104Screen> createState() => _Lab104ScreenState();
}

class _Lab104ScreenState extends State<Lab104Screen> {
  bool _isLoading = false;

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);

    try {
      final session = await AuthService().googleSignIn();
      await SessionService().saveSession(session);

      await NotificationService().showNotification(
        title: 'Google Sign-In Successful',
        body: 'Welcome, ${session.fullName}! Authenticated via Google Firebase.',
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen(session: session)),
      );
    } catch (e) {
      setState(() => _isLoading = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google Sign-In failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab 10.4: Firebase Google Sign-In'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.g_mobiledata, size: 80, color: Colors.red),
            const SizedBox(height: 12),
            const Text(
              'Firebase Social Authentication',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Provides Google Sign-In integration for seamless single sign-on authentication.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 32),
            OutlinedButton.icon(
              onPressed: _isLoading ? null : _handleGoogleSignIn,
              icon: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.account_circle, color: Colors.red),
              label: Text(
                _isLoading ? 'Signing in with Google...' : 'Sign in with Google',
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: Colors.grey),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
