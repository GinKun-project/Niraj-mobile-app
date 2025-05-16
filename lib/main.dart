import 'package:flutter/material.dart';
import 'package:shadow_clash/ui/login_screen.dart';
import 'package:shadow_clash/ui/character_select_screen.dart';
import 'package:shadow_clash/ui/sign_up_screen.dart';
import 'package:shadow_clash/ui/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // Removed const constructor here to keep consistent
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shadow Clash',
      theme: ThemeData(primarySwatch: Colors.red),
      initialRoute: '/splash', // Start with splash screen
      routes: {
        '/splash': (context) => SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignUpScreen(),
        '/character_select': (context) => CharacterSelectScreen(),
      },
    );
  }
}
