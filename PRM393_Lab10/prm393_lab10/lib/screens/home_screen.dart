import 'package:flutter/material.dart';
import '../models/user_session.dart';
import '../services/notification_service.dart';
import '../services/session_service.dart';
import 'integrated_login_screen.dart';

class HomeScreen extends StatelessWidget {
  final UserSession session;

  const HomeScreen({super.key, required this.session});

  Future<void> _logout(BuildContext context) async {
    final sessionService = SessionService();
    final notificationService = NotificationService();

    await sessionService.clearSession();

    // Trigger local notification for logout action (LO7)
    await notificationService.showNotification(
      title: 'Logged Out',
      body: 'You have been successfully logged out from ${session.authProvider}.',
    );

    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const IntegratedLoginScreen()),
      (route) => false,
    );
  }

  void _triggerTestNotification() {
    NotificationService().showNotification(
      title: 'Notification Test (LO7)',
      body: 'Hello ${session.fullName}! This local notification confirms system integration.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home - User Dashboard'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_active),
            tooltip: 'Trigger Notification',
            onPressed: _triggerTestNotification,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // User Header Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 44,
                      backgroundColor: Colors.indigo.shade100,
                      backgroundImage: session.image.isNotEmpty
                          ? NetworkImage(session.image)
                          : null,
                      child: session.image.isEmpty
                          ? Text(
                              session.username.isNotEmpty
                                  ? session.username[0].toUpperCase()
                                  : 'U',
                              style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.indigo),
                            )
                          : null,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      session.fullName,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '@${session.username}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.indigo.shade50,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.indigo.shade200),
                      ),
                      child: Text(
                        'Provider: ${session.authProvider}',
                        style: const TextStyle(
                          color: Colors.indigo,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // User Session Details Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.email, color: Colors.indigo),
                    title: const Text('Email Address'),
                    subtitle: Text(session.email),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.badge, color: Colors.indigo),
                    title: const Text('User ID'),
                    subtitle: Text('${session.id}'),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.key, color: Colors.indigo),
                    title: const Text('Session Auth Token'),
                    subtitle: Text(
                      session.token,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Action Buttons
            ElevatedButton.icon(
              onPressed: _triggerTestNotification,
              icon: const Icon(Icons.notifications),
              label: const Text('Send Local Notification (LO7)'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => _logout(context),
              icon: const Icon(Icons.logout, color: Colors.red),
              label: const Text('Logout Session', style: TextStyle(color: Colors.red)),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                side: const BorderSide(color: Colors.red),
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
