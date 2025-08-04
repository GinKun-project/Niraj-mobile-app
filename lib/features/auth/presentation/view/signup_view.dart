import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadow_clash_frontend/features/auth/presentation/view_model/signup/signup_view_model.dart';

class SignupView extends StatelessWidget {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SignupViewModel>(context);
    final size = MediaQuery.of(context).size;
    final isLandscape = size.width > size.height;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const Image(
            image: AssetImage('assets/images/splash.png'),
            fit: BoxFit.cover,
          ),
          Container(color: Colors.black.withValues(alpha: 0.6)),
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(isLandscape ? 16 : 24),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: isLandscape ? 20 : 100),
                      Text(
                        'Create Account',
                        style: TextStyle(
                          fontSize: isLandscape ? size.width * 0.04 : 30,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: isLandscape ? 20 : 30),
                      Container(
                        width: isLandscape ? size.width * 0.4 : double.infinity,
                        constraints: BoxConstraints(
                          maxWidth: isLandscape ? 400 : double.infinity,
                        ),
                        child: TextField(
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
                      ),
                      SizedBox(height: isLandscape ? 15 : 20),
                      Container(
                        width: isLandscape ? size.width * 0.4 : double.infinity,
                        constraints: BoxConstraints(
                          maxWidth: isLandscape ? 400 : double.infinity,
                        ),
                        child: TextField(
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
                      ),
                      SizedBox(height: isLandscape ? 15 : 20),
                      Container(
                        width: isLandscape ? size.width * 0.4 : double.infinity,
                        constraints: BoxConstraints(
                          maxWidth: isLandscape ? 400 : double.infinity,
                        ),
                        child: TextField(
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
                      ),
                      SizedBox(height: isLandscape ? 20 : 30),
                      Container(
                        width: isLandscape ? size.width * 0.4 : double.infinity,
                        constraints: BoxConstraints(
                          maxWidth: isLandscape ? 400 : double.infinity,
                        ),
                        child: viewModel.isLoading
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
                                  padding: EdgeInsets.symmetric(
                                    vertical: isLandscape ? 12 : 16,
                                    horizontal: isLandscape ? 30 : 40,
                                  ),
                                ),
                                child: Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    fontSize: isLandscape ? size.width * 0.025 : 16,
                                  ),
                                ),
                              ),
                      ),
                      SizedBox(height: isLandscape ? 15 : 20),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Already have an account? Login',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: isLandscape ? size.width * 0.02 : 14,
                          ),
                        ),
                      ),
                      SizedBox(height: isLandscape ? 20 : 40),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
