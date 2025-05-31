import 'package:flutter/material.dart';
import '../widgets/responsive_scaffold.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> _loginUser() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter email and password')),
      );
      return;
    }

    setState(() => isLoading = true);

    await Future.delayed(const Duration(seconds: 2));

    setState(() => isLoading = false);

    // For demo, accept any input as success:
    Navigator.pushReplacementNamed(context, '/dashboard');
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      portraitLayout: _buildPortraitLayout(),
      landscapeLayout: _buildLandscapeLayout(),
    );
  }

  Widget _buildPortraitLayout() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/login.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        color: Colors.black.withOpacity(0.5),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.cyanAccent,
                    shadows: [
                      Shadow(
                        blurRadius: 20,
                        color: Colors.cyan,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                _buildTextField(_emailController, 'Username or Email'),
                const SizedBox(height: 20),
                _buildPasswordField(),
                const SizedBox(height: 24),
                const Text(
                  "Don't have an account?",
                  style: TextStyle(color: Colors.white70),
                ),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/signup'),
                  child: const Text(
                    "SignUp?",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLandscapeLayout() {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/login.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            color: Colors.black.withOpacity(0.7),
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.cyanAccent,
                        shadows: [
                          Shadow(
                            blurRadius: 20,
                            color: Colors.cyan,
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    _buildTextField(_emailController, 'Username or Email'),
                    const SizedBox(height: 30),
                    _buildPasswordField(),
                    const SizedBox(height: 30),
                    const Text(
                      "Don't have an account?",
                      style: TextStyle(color: Colors.white70),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/signup'),
                      child: const Text(
                        "SignUp?",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF29B6F6), Color(0xFF0288D1)],
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.cyanAccent.withOpacity(0.5),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white70),
        ),
        keyboardType: hint == 'Username or Email'
            ? TextInputType.emailAddress
            : TextInputType.text,
      ),
    );
  }

  Widget _buildPasswordField() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF42A5F5), Color(0xFF1E88E5)],
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.lightBlueAccent.withOpacity(0.5),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _passwordController,
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter your password',
                  hintStyle: TextStyle(color: Colors.white70),
                ),
              ),
            ),
          ),
          Container(
            height: 50,
            width: 50,
            margin: const EdgeInsets.only(right: 4),
            decoration: const BoxDecoration(
              color: Colors.cyan,
              shape: BoxShape.circle,
            ),
            child: InkWell(
              onTap: isLoading ? null : _loginUser,
              borderRadius: BorderRadius.circular(25),
              child: isLoading
                  ? const Padding(
                      padding: EdgeInsets.all(10),
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.arrow_forward,
                      size: 20, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
