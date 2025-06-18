import 'package:flutter/material.dart';
import 'package:shadow_clash_frontend/app/app.dart';
import 'package:shadow_clash_frontend/app/service_locator/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupServiceLocator(); // Handles Hive + DI
  runApp(const App());
}
