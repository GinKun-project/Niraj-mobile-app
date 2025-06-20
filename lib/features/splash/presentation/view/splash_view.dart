import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadow_clash_frontend/features/splash/presentation/view_model/splash_view_model.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  late SplashViewModel _viewModel;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel = Provider.of<SplashViewModel>(context, listen: false);
      _startSplashLogic();
    });
  }

  Future<void> _startSplashLogic() async {
    await Future.delayed(const Duration(seconds: 2)); // Splash delay
    await _viewModel.checkLoginStatus();

    if (!mounted) return;

    if (_viewModel.status == SplashStatus.loggedIn) {
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/splash.png', height: 120),
            const SizedBox(height: 30),
            const CircularProgressIndicator(color: Colors.deepPurpleAccent),
          ],
        ),
      ),
    );
  }
}
