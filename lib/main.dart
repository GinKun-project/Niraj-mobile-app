import 'package:flutter/material.dart';
import 'package:shadow_clash_frontend/app/app.dart';
import 'package:shadow_clash_frontend/app/hive/hive_service.dart';
import 'package:shadow_clash_frontend/app/service_locator/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection
  await HiveService.initializeHive();
  await setupServiceLocator();

  runApp(const App());
}
