import 'package:flutter/material.dart';
import 'package:shadow_clash/ui/login_screen.dart';
import 'package:shadow_clash/ui/game_dashboard.dart';
import 'package:shadow_clash/ui/character_select_screen.dart';
import 'package:shadow_clash/ui/sign_up_screen.dart';
import 'package:shadow_clash/ui/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter bindings are initialized early
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shadow Clash',
      debugShowCheckedModeBanner: false, // Remove debug banner for cleaner UI
      theme: ThemeData(
        primarySwatch: Colors.red,
        scaffoldBackgroundColor:
            Colors.black, // Consistent dark background app-wide
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.red, // Consistent app bar color
          centerTitle: true,
          elevation: 0,
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/character_select': (context) => const CharacterSelectScreen(),
        '/game_dashboard': (context) => const GameDashboardScreen(),
        // Add arcade_mode and local_multiplayer routes here when implemented
      },
    );
  }
}
