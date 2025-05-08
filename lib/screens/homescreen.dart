import 'package:flutter/material.dart';
import 'package:pushnotifications/screens/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  
        title: Text('Home',textAlign: TextAlign.center, ),
        actions: [
          IconButton(onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => SettingsScreen())
            );
          }, icon: Icon(Icons.settings))
        ],
      ),
    );
  }
}