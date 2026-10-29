import 'package:flutter/material.dart';
import '../models/user_session.dart';
import '../services/notification_service.dart';
import '../services/session_service.dart';

class Lab103Screen extends StatefulWidget {
  const Lab103Screen({super.key});

  @override
  State<Lab103Screen> createState() => _Lab103ScreenState();
}

class _Lab103ScreenState extends State<Lab103Screen> {
  final SessionService _sessionService = SessionService();

  UserSession? _session;
  bool _isLoggedIn = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkSessionState();
  }

  Future<void> _checkSessionState() async {
    setState(() => _isLoading = true);
    final bool loggedIn = await _sessionService.isLoggedIn();
    final UserSession? session = await _sessionService.getSession();

    setState(() {
      _isLoggedIn = loggedIn;
      _session = session;
      _isLoading = false;
    });
  }

  Future<void> _clearSession() async {
    await _sessionService.clearSession();
    await NotificationService().showNotification(
      title: 'Session Cleared',
      body: 'User session removed from SharedPreferences.',
    );
    await _checkSessionState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab 10.3: Auto Login & Session'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Session Status',
            onPressed: _checkSessionState,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.phonelink_setup, size: 64, color: Colors.teal),
                  const SizedBox(height: 12),
                  const Text(
                    'Local Session Persistence',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Uses SharedPreferences to store auth token and user profile for auto-login on app launch.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: _isLoggedIn ? Colors.teal.shade50 : Colors.orange.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                _isLoggedIn ? Icons.check_circle : Icons.warning_amber,
                                color: _isLoggedIn ? Colors.teal : Colors.orange,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _isLoggedIn
                                    ? 'Active Session Detected (Auto-Login Ready)'
                                    : 'No Active Session Stored',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: _isLoggedIn ? Colors.teal.shade900 : Colors.orange.shade900,
                                ),
                              ),
                            ],
                          ),
                          if (_session != null) ...[
                            const Divider(height: 20),
                            Text('User: ${_session!.fullName} (@${_session!.username})'),
                            Text('Email: ${_session!.email}'),
                            Text('Auth Provider: ${_session!.authProvider}'),
                            const SizedBox(height: 8),
                            Text(
                              'Token: ${_session!.token}',
                              style: const TextStyle(fontFamily: 'monospace', fontSize: 11),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (_isLoggedIn)
                    ElevatedButton.icon(
                      onPressed: _clearSession,
                      icon: const Icon(Icons.no_accounts),
                      label: const Text('Clear Session (Logout)'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    )
                  else
                    const Center(
                      child: Text(
                        'Log in via Lab 10.1 or 10.2 to create a session token.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}
