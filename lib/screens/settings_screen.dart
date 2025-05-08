import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _singleToken = false;
  bool _topic = false;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // Function to request notification permission and update the toggle state
  Future<void> _requestNotificationPermission(bool value) async {
    // Requesting notification permission
    PermissionStatus status = await Permission.notification.request();

    if (status.isGranted) {
      setState(() {
        _singleToken = value;
      });
      // Get the FCM token and send it to the backend
      await _sendTokenToServer();
      if (_singleToken) {
        await _sendNotificationToBackend("Test Title", "Test Message");
      }
    } else {
      // If permission is denied, open device settings for the user to grant permission
      openAppSettings();
    }
  }

  // Function to get the FCM token and send it to the backend
  Future<void> _sendTokenToServer() async {
    String? token = await _firebaseMessaging.getToken();

    if (token != null) {
      print('FCM Token: $token');
      
      // Send the token to your backend API
      final response = await http.post(
        Uri.parse('http://localhost:3000/save-token'), // Your backend URL
        body: {'token': token},
      );

      if (response.statusCode == 200) {
        print('Token successfully sent to server');
      } else {
        print('Failed to send token');
      }
    }
  }

  // Function to send notification to backend when toggle is on
  Future<void> _sendNotificationToBackend(String title, String message) async {
    final response = await http.post(
      Uri.parse('http://localhost:3000/send-notification'), // Your backend URL
      body: {'title': title, 'message': message},
    );

    if (response.statusCode == 200) {
      print('Notification sent successfully');
    } else {
      print('Failed to send notification');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: const BackButton(),
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          // Toggle for Token
          SwitchListTile(
            title: const Text('Token'),
            value: _singleToken,
            onChanged: (bool value) async {
              // Request notification permission when toggled
              await _requestNotificationPermission(value);
            },
          ),
          // Toggle for Subscribe
          SwitchListTile(
            title: const Text('Subscribe'),
            value: _topic,
            onChanged: (bool value) {
              setState(() {
                _topic = value;
              });
            },
          ),
        ],
      ),
    );
  }
}
