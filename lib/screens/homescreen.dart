// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:pushnotifications/screens/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// Instance of FirebaseMessaging
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  /// In-memory list of notifications received while app is in foreground
  final List<RemoteNotification> _messages = [];

  @override
  void initState() {
    super.initState();
    _initFCM();
  }

  /// Initialize FCM: request permission, get token, and set up listeners
  Future<void> _initFCM() async {
    // 1. Request permission (especially important on iOS)
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    debugPrint('User granted permission: ${settings.authorizationStatus}');

    
    // 3. Listen for messages when app is in foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        setState(() {
          _messages.insert(0, message.notification!);
        });
      }
    });

    // 4. (Optional) Handle taps when the app is in background & opened via notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      
      // e.g. navigate to a detail page, based on message.data
      debugPrint('Notification caused app to open: ${message.messageId}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_messages.isEmpty) {
      return const Center(
        child: Text(
          'No notifications yet',
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _messages.length,
      itemBuilder: (ctx, idx) {
        final notif = _messages[idx];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListTile(
            leading: const Icon(Icons.notifications),
            title: Text(
              notif.title ?? '<No Title>',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(notif.body ?? '<No Body>'),
          ),
        );
      },
    );
  }
}
