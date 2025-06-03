// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

ThemeData getApplicationTheme() {
  return ThemeData(
    useMaterial3: false,
    primaryColor: Colors.blue, // You can set this to any color you like
    fontFamily: "OpenSans", // Use the custom font
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.blue, // Customize app bar color
      foregroundColor: Colors.white, // Text color in the app bar
      centerTitle: true,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green, // Button background color
        textStyle:
            TextStyle(fontFamily: 'OpenSans', fontWeight: FontWeight.bold),
      ),
    ),
  );
}
