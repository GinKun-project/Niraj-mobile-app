import 'package:flutter/material.dart';
import 'package:shadow_clash/ui/sign_up_screen.dart'; // Importing the sign-up screen

class LoginScreen extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/pixel.webp',
            ), // Ensure the image path is correct
            fit: BoxFit.cover, // Ensures the image covers the screen
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            // Ensures content is scrollable on small screens
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
                mainAxisAlignment:
                    MainAxisAlignment.center, // Centering content
                children: [
                  Text(
                    'SHADOW CLASH',
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'RobotoMono', // Pixel style font
                    ),
                  ),
                  SizedBox(height: 80),

                  // Username input field
                  TextField(
                    controller: usernameController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
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
                  SizedBox(height: 20),

                  // Password input field
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
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
                  SizedBox(height: 40),

                  // Log In button
                  ElevatedButton(
                    onPressed: () {
                      if (usernameController.text.isEmpty ||
                          passwordController.text.isEmpty) {
                        // Basic validation for empty fields
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please fill in both fields')),
                        );
                      } else {
                        // Handle login logic here (e.g., validate against a database)
                        print("Logging in...");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFB35D32),
                      padding: EdgeInsets.symmetric(
                        horizontal: 100,
                        vertical: 15,
                      ),
                      textStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: Text('LOG IN'),
                  ),
                  SizedBox(height: 20),

                  // Create an account link
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpScreen()),
                      );
                    },
                    child: Text(
                      'Create an account',
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
