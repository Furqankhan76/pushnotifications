import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pushnotifications/widgets/onboarding.dart';
import 'package:pushnotifications/screens/settings_screen.dart';

void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: OnboardingPage(pages: onboardingPages ),
      home: SettingsScreen(),
    );
  }
}

final onboardingPages = [
      OnboardingPageModel(
        title: 'Welcome to MyApp',
        description: 'This is the first step of onboarding.',
        image: 'assets/images/illus.png', // Ensure this image exists
        bgColor: Colors.blue,
        textColor: Colors.white,
      ),
      OnboardingPageModel(
        title: 'Explore Features',
        description: 'Discover all the amazing features we offer.',
        image: 'assets/images/illus.png', // Ensure this image exists
        bgColor: Colors.green,
        textColor: Colors.white,
      ),
      OnboardingPageModel(
        title: 'Get Started',
        description: 'Let’s get started and dive into the app!',
        image: 'assets/images/illus.png', // Ensure this image exists
        bgColor: Colors.orange,
        textColor: Colors.white,
      ),
    ];
