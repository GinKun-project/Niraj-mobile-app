import 'package:flutter/material.dart';

class GameDashboardScreen extends StatelessWidget {
  const GameDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final width = mq.size.width;
    final height = mq.size.height;

    return Scaffold(
      // Remove default appBar; we'll overlay our own
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/dashboard_bg.jpg',
              fit: BoxFit.cover,
            ),
          ),

          // Gradient overlay for better contrast
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.8),
                    Colors.black.withOpacity(0.4),
                    Colors.black.withOpacity(0.9),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          // Custom app bar at the top
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                alignment: Alignment.center,
                child: const Text(
                  'Shadow Clash - Dashboard',
                  style: TextStyle(
                    color: Colors.amberAccent,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    shadows: [Shadow(color: Colors.red, blurRadius: 10)],
                  ),
                ),
              ),
            ),
          ),

          // Main content
          Positioned.fill(
            top: height * 0.12,
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 450),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Choose Your Path',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: width * 0.08,
                          fontWeight: FontWeight.bold,
                          color: Colors.amberAccent,
                          letterSpacing: 2,
                          shadows: const [
                            Shadow(color: Colors.redAccent, blurRadius: 12),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                      _GamerButton(
                        label: 'Character Selection',
                        icon: Icons.person,
                        onTap:
                            () => Navigator.pushNamed(
                              context,
                              '/character_select',
                            ),
                      ),
                      const SizedBox(height: 20),
                      _GamerButton(
                        label: 'Arcade Mode',
                        icon: Icons.sports_martial_arts,
                        onTap:
                            () => Navigator.pushNamed(context, '/arcade_mode'),
                      ),
                      const SizedBox(height: 20),
                      _GamerButton(
                        label: 'Local Multiplayer',
                        icon: Icons.people,
                        onTap:
                            () => Navigator.pushNamed(
                              context,
                              '/local_multiplayer',
                            ),
                      ),
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

class _GamerButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _GamerButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        backgroundColor: Colors.redAccent.shade700,
        foregroundColor: Colors.white,
        elevation: 10,
        minimumSize: const Size.fromHeight(60),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        shadowColor: Colors.deepOrangeAccent,
      ),
      icon: Icon(icon, size: 28),
      label: Text(
        label,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      ),
    );
  }
}
