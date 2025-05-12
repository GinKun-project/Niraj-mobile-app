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
      backgroundColor: Color(0xFF2E1A1A), // Dark red background
      body: Center(
        child: Container(
          width: 350,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Shadow Clash title
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
                  border: OutlineInputBorder(),
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
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              // Confirm Password input field
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  labelStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.black,
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 40),
              // Sign Up button
              ElevatedButton(
                onPressed: () {
                  // Handle sign-up logic here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFB35D32), // Corrected property
                  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                  textStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: Text('SIGN UP'),
              ),
              SizedBox(height: 20),
              // Already have an account link
              TextButton(
                onPressed: () {
                  // Navigate back to the Login screen
                  Navigator.pop(context);
                },
                child: Text(
                  'Already have an account?',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
