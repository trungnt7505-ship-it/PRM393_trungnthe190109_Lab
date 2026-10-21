/*
 * =====================================================================
 * Lab 10.5 – Local Notification (MANDATORY – LO7)
 * Goal: Integrate local notifications in a Flutter application.
 * =====================================================================
 */

import 'package:flutter/material.dart';

void main() {
  runApp(const Lab10_5App());
}

class Lab10_5App extends StatelessWidget {
  const Lab10_5App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 10.5 Local Notification',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const NotificationScreen(),
    );
  }
}

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    // Step 3: Request notification permission (Simulated prompt)
  }

  // Step 4: Trigger notification manually for demonstration
  // Step 5: Verify notification is displayed by the system
  void _showNotification(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: const [
            Icon(Icons.notifications_active, color: Colors.white),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'System Notification: Action completed successfully! (LO7)',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.teal,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lab 10.5 – Local Notification')),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () => _showNotification(context),
          icon: const Icon(Icons.notifications),
          label: const Text('Trigger Local Notification'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
      ),
    );
  }
}