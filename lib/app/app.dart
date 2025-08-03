import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as provider;
import 'package:shadow_clash_frontend/app/theme/app_theme.dart';
import 'package:shadow_clash_frontend/features/auth/presentation/view/login_view.dart';
import 'package:shadow_clash_frontend/features/auth/presentation/view/signup_view.dart';
import 'package:shadow_clash_frontend/features/dashboard/presentation/view/dashboard_view.dart';
import 'package:shadow_clash_frontend/features/game/presentation/view/game_view.dart';
import 'package:shadow_clash_frontend/features/splash/presentation/view/splash_view.dart';
import 'package:shadow_clash_frontend/features/auth/presentation/view_model/login/login_view_model.dart';
import 'package:shadow_clash_frontend/features/auth/presentation/view_model/signup/signup_view_model.dart';
import 'package:shadow_clash_frontend/features/splash/presentation/view_model/splash_view_model.dart';
import 'package:shadow_clash_frontend/features/dashboard/presentation/view_model/dashboard_view_model.dart';
import 'package:shadow_clash_frontend/app/service_locator/service_locator.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shadow Clash',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialRoute: '/splash',
      routes: {
        '/splash': (context) {
          return provider.ChangeNotifierProvider(
            create: (_) => getIt<SplashViewModel>(),
            builder: (context, child) => const SplashView(),
          );
        },

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
        '/game': (context) => const ProviderScope(child: GameView()),
      },
    );
  }
}
