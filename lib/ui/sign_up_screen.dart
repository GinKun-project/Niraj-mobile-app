import 'package:flutter/material.dart';

class SignUpScreen extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/pixel.webp',
            ), // Ensure your image path is correct
            fit: BoxFit.cover, // Ensures the image covers the screen
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: 350,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(10),
                color: Colors.black.withOpacity(
                  0.5,
                ), // Semi-transparent background for form
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'SHADOW CLASH',
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'RobotoMono', // Pixel style font
                    ),
                  ),
                  const SizedBox(height: 80),

                  // Username input field
                  TextField(
                    controller: usernameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      labelStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.black,
                      focusedBorder:
                          InputBorder.none, // Remove border when focused
                      enabledBorder:
                          InputBorder.none, // Remove border when enabled
                      border: InputBorder.none, // Completely remove border
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Password input field
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.black,
                      focusedBorder:
                          InputBorder.none, // Remove border when focused
                      enabledBorder:
                          InputBorder.none, // Remove border when enabled
                      border: InputBorder.none, // Completely remove border
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Confirm Password input field
                  TextField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Confirm Password',
                      labelStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.black,
                      focusedBorder:
                          InputBorder.none, // Remove border when focused
                      enabledBorder:
                          InputBorder.none, // Remove border when enabled
                      border: InputBorder.none, // Completely remove border
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Sign Up button with validation logic
                  ElevatedButton(
                    onPressed: () {
                      if (usernameController.text.isEmpty ||
                          passwordController.text.isEmpty ||
                          confirmPasswordController.text.isEmpty) {
                        // Show an error SnackBar if fields are empty
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please fill in all fields'),
                          ),
                        );
                      } else if (passwordController.text !=
                          confirmPasswordController.text) {
                        // Show an error SnackBar if passwords don't match
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Passwords do not match'),
                          ),
                        );
                      } else {
                        print("Signing up...");
                        // Navigate back to Login screen after successful signup
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB35D32),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 100,
                        vertical: 15,
                      ),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: const Text('SIGN UP'),
                  ),
                  const SizedBox(height: 20),

                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Navigate back to Login screen
                    },
                    child: const Text(
                      'Already have an account?',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
