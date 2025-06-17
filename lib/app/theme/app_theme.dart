import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      primaryColor: Colors.deepPurple,
      scaffoldBackgroundColor: const Color.fromARGB(255, 151, 53, 48),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: Colors.white12,
        border: OutlineInputBorder(),
      ),
      textTheme: ThemeData.dark().textTheme.apply(
        fontFamily: 'OpenSansCondensed',
      ),
    );
  }
}
