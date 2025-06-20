import 'package:flutter/material.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
            ),
          ),

          // Foreground content
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(height: 20),

                // Title
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 40,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFA64D),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: Colors.brown.shade800,
                        width: 4,
                      ),
                    ),
                    child: const Text(
                      'DASHBOARD',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                // Play Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/game');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFA64D),
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 80,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: const BorderSide(color: Colors.brown, width: 3),
                    ),
                  ),
                  child: const Text(
                    'PLAY',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ),

                // Bottom Navigation
                Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _circleButton(
                        icon: Icons.person,
                        onTap: () {
                          Navigator.pushNamed(context, '/profile');
                        },
                      ),
                      _circleButton(
                        icon: Icons.star,
                        onTap: () {
                          Navigator.pushNamed(context, '/achievements');
                        },
                      ),
                      _circleButton(
                        icon: Icons.settings,
                        onTap: () {
                          Navigator.pushNamed(context, '/settings');
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _circleButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFFFFA64D),
          border: Border.all(color: Colors.brown.shade800, width: 4),
        ),
        child: Icon(icon, size: 28, color: Colors.white),
      ),
    );
  }
}
