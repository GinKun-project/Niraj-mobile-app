import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as provider;
import 'package:shadow_clash_frontend/app/service_locator/service_locator.dart';
import 'package:shadow_clash_frontend/features/auth/presentation/view/login_view.dart';
import 'package:shadow_clash_frontend/features/auth/presentation/view/signup_view.dart';
import 'package:shadow_clash_frontend/features/dashboard/presentation/view/dashboard_view.dart';
import 'package:shadow_clash_frontend/features/game/presentation/view/game_view.dart';
import 'package:shadow_clash_frontend/features/splash/presentation/view/splash_view.dart';
import 'package:shadow_clash_frontend/features/auth/presentation/view_model/login/login_view_model.dart';
import 'package:shadow_clash_frontend/features/auth/presentation/view_model/signup/signup_view_model.dart';
import 'package:shadow_clash_frontend/features/splash/presentation/view_model/splash_view_model.dart';
import 'package:shadow_clash_frontend/features/dashboard/presentation/view_model/dashboard_view_model.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.purple,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Center(
        child: Text(
          'Profile Screen',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.purple,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Center(
        child: Text(
          'Settings Screen',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}

class AchievementsView extends StatelessWidget {
  const AchievementsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title:
            const Text('Achievements', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.purple,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Center(
        child: Text(
          'Achievements Screen',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'Shadow Clash',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          fontFamily: 'OpenSans_Condensed-SemiBoldItalic',
        ),
        navigatorKey: getIt<NavigationService>().navigatorKey,
        initialRoute: '/splash',
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaleFactor: 1.0,
            ),
            child: child!,
          );
        },
        routes: {
          '/splash': (context) => provider.ChangeNotifierProvider(
                create: (_) => getIt<SplashViewModel>(),
                child: const SplashView(),
              ),
          '/login': (context) => provider.ChangeNotifierProvider(
                create: (_) => getIt<LoginViewModel>(),
                child: const LoginView(),
              ),
          '/signup': (context) => provider.ChangeNotifierProvider(
                create: (_) => getIt<SignupViewModel>(),
                child: const SignupView(),
              ),
          '/dashboard': (context) => provider.ChangeNotifierProvider(
                create: (_) => getIt<DashboardViewModel>(),
                child: const DashboardView(),
              ),
          '/game': (context) => const GameView(),
          '/profile': (context) => const ProfileView(),
          '/settings': (context) => const SettingsView(),
          '/achievements': (context) => const AchievementsView(),
        },
      ),
    );
  }
}
