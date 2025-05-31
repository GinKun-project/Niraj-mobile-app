import 'package:flutter/material.dart';
import 'routes.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: Routes.splash,
      routes: Routes.getRoutes(),
    );
  }
}
