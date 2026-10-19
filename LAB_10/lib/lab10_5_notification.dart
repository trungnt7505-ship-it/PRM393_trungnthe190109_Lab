// ============================================================================
// LAB 10.5 – LOCAL NOTIFICATION (MANDATORY – LO7)
// ============================================================================
// Goal: Integrate local notifications in a Flutter application after key user actions.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Lab 10.5 - Step 2: Setup flutter_local_notifications helper service
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  Future<void> initNotification() async {
    if (_isInitialized) return;

    // Android initialization settings using the default launcher icon
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        debugPrint("Notification tapped: ${response.payload}");
      },
    );

    _isInitialized = true;
  }

  // Lab 10.5 - Step 3: Request notification permission (Android 13+)
  Future<bool> requestPermission() async {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        _notificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      final bool? granted = await androidImplementation.requestNotificationsPermission();
      return granted ?? false;
    }
    return false;
  }

  // Lab 10.5 - Step 4: Trigger notification manually or after user actions
  Future<void> showNotification({
    int id = 0,
    required String title,
    required String body,
    String? payload,
  }) async {
    if (!_isInitialized) {
      await initNotification();
    }

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'lab10_channel_id', // channelId
      'Lab 10 Notifications', // channelName
      channelDescription: 'Notifications for Lab 10 Authentication and Session events',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    // Lab 10.5 - Step 5: Verify notification is displayed by the system
    await _notificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }
}

// Standalone main entry point for running Lab 10.5 independently
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().initNotification();
  runApp(const Lab10_5_NotificationApp());
}

// Lab 10.5 - Step 1: Create project/module Lab10_5_Notification
class Lab10_5_NotificationApp extends StatelessWidget {
  const Lab10_5_NotificationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 10.5 - Local Notification',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
        useMaterial3: true,
      ),
      home: const NotificationDemoScreen(),
    );
  }
}

class NotificationDemoScreen extends StatefulWidget {
  const NotificationDemoScreen({super.key});

  @override
  State<NotificationDemoScreen> createState() => _NotificationDemoScreenState();
}

class _NotificationDemoScreenState extends State<NotificationDemoScreen> {
  final NotificationService _notificationService = NotificationService();
  bool _permissionGranted = false;

  @override
  void initState() {
    super.initState();
    _initNotificationsAndPermissions();
  }

  Future<void> _initNotificationsAndPermissions() async {
    await _notificationService.initNotification();
    // Lab 10.5 - Step 3: Request notification permission
    final granted = await _notificationService.requestPermission();
    setState(() {
      _permissionGranted = granted;
    });
  }

  // Lab 10.5 - Step 4: Trigger notification manually for demonstration
  Future<void> _triggerManualNotification() async {
    await _notificationService.showNotification(
      id: 101,
      title: 'Lab 10 Demonstration',
      body: 'Local notification successfully triggered on your Android device! (LO7)',
      payload: 'lab10_demo_payload',
    );

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Notification sent to system notification shade!'),
        backgroundColor: Colors.purple,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab 10.5 - Local Notification'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.notifications_active, size: 80, color: Colors.purple),
                  const SizedBox(height: 16),
                  Text(
                    'Local Notifications (LO7)',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Integrate local notifications after key user actions (e.g., successful login/logout).',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  Chip(
                    avatar: Icon(
                      _permissionGranted ? Icons.check_circle : Icons.warning,
                      color: _permissionGranted ? Colors.green : Colors.orange,
                    ),
                    label: Text(
                      _permissionGranted ? 'Permission Granted' : 'Requesting Permission...',
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Button to trigger notification manually
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: _triggerManualNotification,
                      icon: const Icon(Icons.send),
                      label: const Text('Trigger Notification Manually'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
