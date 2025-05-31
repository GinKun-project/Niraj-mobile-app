import 'package:flutter/material.dart';
import 'package:shadow_clash/view/dashboard_page.dart';
import 'package:shadow_clash/view/signup_page.dart';
import 'package:shadow_clash/view/login_page.dart';
import 'package:shadow_clash/view/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shadow Clash',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignupPage(),
        '/dashboard': (context) => const DashboardPage(),
      },
    );
  }
}
