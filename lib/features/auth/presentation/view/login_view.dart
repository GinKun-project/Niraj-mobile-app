import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadow_clash_frontend/features/auth/presentation/view_model/login/login_view_model.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<LoginViewModel>(context);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const Image(
            image: AssetImage('assets/images/splash.png'),
            fit: BoxFit.cover,
          ),
          Container(color: Colors.black.withValues(alpha: 0.6)),
          SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 100),
                const Text(
                  'LOGIN',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 40),
                TextField(
                  controller: viewModel.emailController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Email',
                    hintStyle: TextStyle(color: Colors.white54),
                    prefixIcon: Icon(Icons.email, color: Colors.white),
                    filled: true,
                    fillColor: Colors.black54,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: viewModel.passwordController,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Password',
                    hintStyle: TextStyle(color: Colors.white54),
                    prefixIcon: Icon(Icons.lock, color: Colors.white),
                    filled: true,
                    fillColor: Colors.black54,
                  ),
                ),
                const SizedBox(height: 30),
                viewModel.isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.deepPurpleAccent,
                      )
                    : ElevatedButton(
                        onPressed: () => viewModel.login(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                            32,
                            141,
                            64,
                            38,
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 40,
                          ),
                        ),
                        child: const Text('LOGIN'),
                      ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/signup');
                  },
                  child: const Text(
                    'Don\'t have an account? Sign up',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
