import 'package:flutter/material.dart';
import 'package:shadow_clash/ui/sign_up_screen.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2E1A1A), // Dark red background color
      body: Center(
        child: Container(
          width: 350,
          padding: const EdgeInsets.all(20),
          // decoration: BoxDecoration(
          //   border: Border.all(color: Colors.white),
          //   borderRadius: BorderRadius.circular(10),
          // ),
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
              SizedBox(height: 40),
              // Log In button
              ElevatedButton(
                onPressed: () {
                  // Handle login logic here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFB35D32), // Corrected property
                  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
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
                  // Navigate to the Sign-Up screen
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
    );
  }
}
