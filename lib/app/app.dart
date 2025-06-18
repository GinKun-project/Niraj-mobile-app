import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadow_clash_frontend/app/theme/app_theme.dart';
import 'package:shadow_clash_frontend/features/auth/presentation/view/login_view.dart';
import 'package:shadow_clash_frontend/features/auth/presentation/view/signup_view.dart';
import 'package:shadow_clash_frontend/features/splash/presentation/view/splash_view.dart';
import 'package:shadow_clash_frontend/features/auth/presentation/view_model/login/login_view_model.dart';
import 'package:shadow_clash_frontend/features/auth/presentation/view_model/signup/signup_view_model.dart';
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
        '/splash': (context) => SplashView(),
        '/login': (context) => ChangeNotifierProvider(
          create: (_) => getIt<LoginViewModel>(),
          child: const LoginView(),
        ),
        '/signup': (context) => ChangeNotifierProvider(
          create: (_) => getIt<SignupViewModel>(),
          child: const SignupView(),
        ),
      },
    );
  }
}
