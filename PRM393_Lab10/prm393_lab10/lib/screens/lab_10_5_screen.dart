import 'package:flutter/material.dart';
import '../services/notification_service.dart';

class Lab105Screen extends StatefulWidget {
  const Lab105Screen({super.key});

  @override
  State<Lab105Screen> createState() => _Lab105ScreenState();
}

class _Lab105ScreenState extends State<Lab105Screen> {
  final _titleController =
      TextEditingController(text: 'Lab 10 Notification Test');
  final _bodyController = TextEditingController(
      text: 'Local notification successfully triggered! LO7 Verified.');

  @override
  void initState() {
    super.initState();
    NotificationService().requestPermissions();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _sendNotification() async {
    final title = _titleController.text.trim();
    final body = _bodyController.text.trim();

    if (title.isEmpty || body.isEmpty) return;

    await NotificationService().showNotification(
      title: title,
      body: body,
    );

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Local Notification triggered! Check your system bar.'),
        backgroundColor: Colors.indigo,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab 10.5: Local Notifications (LO7)'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.notifications_active, size: 64, color: Colors.amber),
            const SizedBox(height: 12),
            const Text(
              'Local Notification Tester',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tests flutter_local_notifications package integration to fulfill LO7 requirement.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Notification Title',
                prefixIcon: Icon(Icons.title),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _bodyController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Notification Message / Body',
                prefixIcon: Icon(Icons.message),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _sendNotification,
              icon: const Icon(Icons.send_rounded),
              label: const Text('Trigger Local Notification'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber.shade800,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
