import 'package:flutter/material.dart';
import 'package:shadow_clash/ui/login_screen.dart';
import 'package:shadow_clash/ui/character_select_screen.dart';
import 'package:shadow_clash/ui/sign_up_screen.dart'; // Import Character Select

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shadow Clash',
      theme: ThemeData(primarySwatch: Colors.red),
      home: LoginScreen(), // Start with LoginScreen
      routes: {
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignUpScreen(),
        '/character_select':
            (context) =>
                CharacterSelectScreen(), // Add route for Character Select
      },
    );
  }
}
