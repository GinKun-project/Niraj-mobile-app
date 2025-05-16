import 'package:flutter/material.dart';
import 'package:shadow_clash/ui/login_screen.dart';
import 'package:shadow_clash/ui/game_dashboard.dart';
import 'package:shadow_clash/ui/character_select_screen.dart';
import 'package:shadow_clash/ui/sign_up_screen.dart';
import 'package:shadow_clash/ui/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shadow Clash',
      theme: ThemeData(primarySwatch: Colors.red),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignUpScreen(),
        '/character_select': (context) => CharacterSelectScreen(),
        '/game_dashboard': (context) => const GameDashboardScreen(),
        // Add arcade_mode and local_multiplayer routes when ready
      },
    );
  }
}
