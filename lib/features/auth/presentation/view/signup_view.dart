import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadow_clash_frontend/features/auth/presentation/view_model/signup/signup_view_model.dart';

class SignupView extends StatelessWidget {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SignupViewModel>(context);

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
                  'Create Account',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: viewModel.usernameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Username',
                    hintStyle: TextStyle(color: Colors.white54),
                    prefixIcon: Icon(Icons.person_2, color: Colors.white),
                    filled: true,
                    fillColor: Colors.black54,
                  ),
                ),
                const SizedBox(height: 20),
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
                        onPressed: () => viewModel.signup(context),
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
                        child: const Text('Sign Up'),
                      ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Already have an account? Login',
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
