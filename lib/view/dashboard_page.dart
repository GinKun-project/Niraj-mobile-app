import 'package:flutter/material.dart';
import '../widgets/responsive_scaffold.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      portraitLayout: _buildPortraitLayout(),
      landscapeLayout: _buildLandscapeLayout(),
    );
  }

  Widget _buildPortraitLayout() {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bg.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(color: Colors.black.withOpacity(0.6)),

          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Shadow Clash',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.cyanAccent,
                      letterSpacing: 2,
                      shadows: [
                        Shadow(
                          blurRadius: 10,
                          color: Colors.cyan,
                          offset: Offset(0, 0),
                        )
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                      children: const [
                        DashboardCard(
                            icon: Icons.sports_esports, label: 'Adventure'),
                        DashboardCard(
                            icon: Icons.flash_on, label: 'Battle Arena'),
                        DashboardCard(icon: Icons.stars, label: 'Achievements'),
                        DashboardCard(
                            icon: Icons.inventory, label: 'Inventory'),
                        DashboardCard(
                            icon: Icons.leaderboard, label: 'Leaderboard'),
                        DashboardCard(icon: Icons.settings, label: 'Settings'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLandscapeLayout() {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bg.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(color: Colors.black.withOpacity(0.6)),

          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Text(
                        'Shadow Clash',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.cyanAccent,
                          letterSpacing: 2,
                          shadows: const [
                            Shadow(
                              blurRadius: 10,
                              color: Colors.cyan,
                              offset: Offset(0, 0),
                            )
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: GridView.count(
                      crossAxisCount: 3,
                      mainAxisSpacing: 24,
                      crossAxisSpacing: 24,
                      children: const [
                        DashboardCard(
                            icon: Icons.sports_esports, label: 'Adventure'),
                        DashboardCard(
                            icon: Icons.flash_on, label: 'Battle Arena'),
                        DashboardCard(icon: Icons.stars, label: 'Achievements'),
                        DashboardCard(
                            icon: Icons.inventory, label: 'Inventory'),
                        DashboardCard(
                            icon: Icons.leaderboard, label: 'Leaderboard'),
                        DashboardCard(icon: Icons.settings, label: 'Settings'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final IconData icon;
  final String label;

  const DashboardCard({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF29B6F6), Color(0xFF0288D1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.cyanAccent.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$label tapped')),
          );
        },
        borderRadius: BorderRadius.circular(20),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 48, color: Colors.white),
              const SizedBox(height: 12),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.black54,
                      blurRadius: 6,
                      offset: Offset(1, 2),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
