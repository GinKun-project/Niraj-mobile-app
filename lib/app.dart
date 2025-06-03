import 'package:flutter/material.dart';
import 'package:shadow_clash/theme/theme.dart'; // Import your theme.dart file
import 'package:shadow_clash/routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shadow Clash', // Set the app title
      theme: getApplicationTheme(), // Apply the custom theme from theme.dart
      initialRoute: Routes.splash, // Set the initial route
      routes: Routes.getRoutes(), // Map the routes using the Routes class
      debugShowCheckedModeBanner: false, // Disable the debug banner
    );
  }
}
