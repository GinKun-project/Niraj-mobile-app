import 'package:flutter/material.dart';
import 'view/splash_screen.dart';
import 'view/login_page.dart';
import 'view/signup_page.dart';
import 'view/dashboard_page.dart';

class Routes {
  static const String splash = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String dashboard = '/dashboard';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      splash: (context) => SplashScreen(),
      login: (context) => LoginPage(),
      signup: (context) => SignupPage(),
      dashboard: (context) => DashboardPage(),
    };
  }
}
