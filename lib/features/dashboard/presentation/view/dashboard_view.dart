import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadow_clash_frontend/features/dashboard/presentation/view_model/dashboard_view_model.dart';
import 'dart:math';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          _buildParticles(),
          _buildUI(context),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Positioned.fill(
      child: Image.asset(
        'assets/images/background.png',
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildParticles() {
    return Positioned.fill(
      child: CustomPaint(
        painter: ParticlePainter(),
        size: Size.infinite,
      ),
    );
  }

  Widget _buildUI(BuildContext context) {
    return Consumer<DashboardViewModel>(
      builder: (context, viewModel, child) {
        return SafeArea(
          child: Stack(
            children: [
              _buildHeader(context, viewModel),
              _buildMainContent(context, viewModel),
              _buildNotificationOverlay(context, viewModel),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, DashboardViewModel viewModel) {
    final screenSize = MediaQuery.of(context).size;
    final isLandscape = screenSize.width > screenSize.height;

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: screenSize.width * 0.05,
          vertical: screenSize.height * 0.02,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withValues(alpha: 0.8),
              Colors.black.withValues(alpha: 0.4),
              Colors.transparent,
            ],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: screenSize.width * 0.04,
                vertical: screenSize.height * 0.01,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.red.shade400,
                    Colors.orange.shade400,
                    Colors.red.shade600,
                  ],
                ),
                borderRadius: BorderRadius.circular(screenSize.width * 0.02),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withValues(alpha: 0.5),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Text(
                'SHADOW CLASH',
                style: TextStyle(
                  fontSize: isLandscape
                      ? screenSize.width * 0.03
                      : screenSize.width * 0.06,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 3,
                  fontFamily: 'Orbitron',
                  shadows: [
                    Shadow(
                      color: Colors.black.withValues(alpha: 0.8),
                      blurRadius: 3,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                _buildSoundToggle(context, viewModel, isLandscape),
                SizedBox(width: screenSize.width * 0.02),
                _buildLogoutButton(context, viewModel, isLandscape),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSoundToggle(
      BuildContext context, DashboardViewModel viewModel, bool isLandscape) {
    final screenSize = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: viewModel.toggleSound,
      child: Container(
        padding: EdgeInsets.all(screenSize.width * 0.015),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue.shade400,
              Colors.cyan.shade400,
            ],
          ),
          borderRadius: BorderRadius.circular(screenSize.width * 0.02),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withValues(alpha: 0.4),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(
          viewModel.state.isSoundEnabled ? Icons.volume_up : Icons.volume_off,
          color: Colors.white,
          size:
              isLandscape ? screenSize.width * 0.025 : screenSize.width * 0.04,
        ),
      ),
    );
  }

  Widget _buildLogoutButton(
      BuildContext context, DashboardViewModel viewModel, bool isLandscape) {
    final screenSize = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: viewModel.logout,
      child: Container(
        padding: EdgeInsets.all(screenSize.width * 0.015),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.red.shade400,
              Colors.orange.shade400,
            ],
          ),
          borderRadius: BorderRadius.circular(screenSize.width * 0.02),
          boxShadow: [
            BoxShadow(
              color: Colors.red.withValues(alpha: 0.4),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(
          Icons.logout,
          color: Colors.white,
          size:
              isLandscape ? screenSize.width * 0.025 : screenSize.width * 0.04,
        ),
      ),
    );
  }

  Widget _buildMainContent(BuildContext context, DashboardViewModel viewModel) {
    final screenSize = MediaQuery.of(context).size;
    final isLandscape = screenSize.width > screenSize.height;

    return Positioned.fill(
      child: isLandscape
          ? Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _buildPlayerStats(context),
                ),
                SizedBox(width: screenSize.width * 0.03),
                Expanded(
                  flex: 3,
                  child: _buildActionGrid(context, viewModel),
                ),
              ],
            )
          : Column(
              children: [
                Expanded(
                  flex: 2,
                  child: _buildPlayerStats(context),
                ),
                Expanded(
                  flex: 3,
                  child: _buildActionGrid(context, viewModel),
                ),
              ],
            ),
    );
  }

  Widget _buildPlayerStats(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isLandscape = screenSize.width > screenSize.height;

    return Container(
      margin: EdgeInsets.all(screenSize.width * 0.05),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.15),
            Colors.white.withValues(alpha: 0.05),
            Colors.white.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(screenSize.width * 0.04),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width:
                isLandscape ? screenSize.width * 0.15 : screenSize.width * 0.25,
            height:
                isLandscape ? screenSize.width * 0.15 : screenSize.width * 0.25,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue.shade400,
                  Colors.cyan.shade400,
                ],
              ),
              borderRadius: BorderRadius.circular(isLandscape
                  ? screenSize.width * 0.075
                  : screenSize.width * 0.125),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withValues(alpha: 0.4),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Icon(
              Icons.person,
              color: Colors.white,
              size: isLandscape
                  ? screenSize.width * 0.08
                  : screenSize.width * 0.12,
            ),
          ),
          SizedBox(height: screenSize.height * 0.02),
          Text(
            'FIGHTER',
            style: TextStyle(
              fontSize: isLandscape
                  ? screenSize.width * 0.025
                  : screenSize.width * 0.05,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 2,
              fontFamily: 'Orbitron',
              shadows: [
                Shadow(
                  color: Colors.black.withValues(alpha: 0.8),
                  blurRadius: 3,
                  offset: const Offset(2, 2),
                ),
              ],
            ),
          ),
          SizedBox(height: screenSize.height * 0.02),
          _buildStatBar(context, 'LEVEL', 85, Colors.green, isLandscape),
          SizedBox(height: screenSize.height * 0.01),
          _buildStatBar(context, 'XP', 1200, Colors.blue, isLandscape),
          SizedBox(height: screenSize.height * 0.01),
          _buildStatBar(context, 'WINS', 42, Colors.orange, isLandscape),
        ],
      ),
    );
  }

  Widget _buildStatBar(BuildContext context, String label, int value,
      Color color, bool isLandscape) {
    final screenSize = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: screenSize.width * 0.03),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: isLandscape
                      ? screenSize.width * 0.015
                      : screenSize.width * 0.03,
                  color: Colors.white.withValues(alpha: 0.9),
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Orbitron',
                  shadows: [
                    Shadow(
                      color: Colors.black.withValues(alpha: 0.8),
                      blurRadius: 2,
                      offset: const Offset(1, 1),
                    ),
                  ],
                ),
              ),
              Text(
                value.toString(),
                style: TextStyle(
                  fontSize: isLandscape
                      ? screenSize.width * 0.015
                      : screenSize.width * 0.03,
                  color: color,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Orbitron',
                  shadows: [
                    Shadow(
                      color: Colors.black.withValues(alpha: 0.8),
                      blurRadius: 2,
                      offset: const Offset(1, 1),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: screenSize.height * 0.005),
          Container(
            height: isLandscape
                ? screenSize.height * 0.015
                : screenSize.height * 0.02,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(isLandscape
                  ? screenSize.height * 0.0075
                  : screenSize.height * 0.01),
              border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: 0.8,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color, color.withValues(alpha: 0.8)],
                  ),
                  borderRadius: BorderRadius.circular(isLandscape
                      ? screenSize.height * 0.0075
                      : screenSize.height * 0.01),
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.4),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionGrid(BuildContext context, DashboardViewModel viewModel) {
    final screenSize = MediaQuery.of(context).size;
    final isLandscape = screenSize.width > screenSize.height;

    return Container(
      margin: EdgeInsets.all(screenSize.width * 0.05),
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: screenSize.width * 0.04,
        mainAxisSpacing: screenSize.height * 0.02,
        children: [
          _buildGameButton(context, 'START BATTLE', Icons.sports_kabaddi,
              Colors.red, viewModel.navigateToGame, isLandscape),
          _buildGameButton(context, 'PROFILE', Icons.person, Colors.blue,
              viewModel.navigateToProfile, isLandscape),
          _buildGameButton(context, 'SETTINGS', Icons.settings, Colors.green,
              viewModel.navigateToSettings, isLandscape),
          _buildGameButton(context, 'ACHIEVEMENTS', Icons.emoji_events,
              Colors.orange, viewModel.navigateToAchievements, isLandscape),
        ],
      ),
    );
  }

  Widget _buildGameButton(BuildContext context, String title, IconData icon,
      Color color, VoidCallback onTap, bool isLandscape) {
    final screenSize = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withValues(alpha: 0.9),
              color.withValues(alpha: 0.7),
              color.withValues(alpha: 0.9),
            ],
          ),
          borderRadius: BorderRadius.circular(screenSize.width * 0.03),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.4),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.4),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: isLandscape
                  ? screenSize.width * 0.04
                  : screenSize.width * 0.08,
              shadows: [
                Shadow(
                  color: Colors.black.withValues(alpha: 0.8),
                  blurRadius: 3,
                  offset: const Offset(2, 2),
                ),
              ],
            ),
            SizedBox(height: screenSize.height * 0.01),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isLandscape
                    ? screenSize.width * 0.015
                    : screenSize.width * 0.035,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 1,
                fontFamily: 'Orbitron',
                shadows: [
                  Shadow(
                    color: Colors.black.withValues(alpha: 0.8),
                    blurRadius: 3,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationOverlay(
      BuildContext context, DashboardViewModel viewModel) {
    return Consumer<DashboardViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.state.showNotification) {
          return Positioned(
            top: MediaQuery.of(context).size.height * 0.1,
            left: MediaQuery.of(context).size.width * 0.1,
            right: MediaQuery.of(context).size.width * 0.1,
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.orange.shade400,
                    Colors.red.shade400,
                  ],
                ),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withValues(alpha: 0.5),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.white,
                    size: 40,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Game Session Ended',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Orbitron',
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Your battle has concluded. Return to dashboard.',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 14,
                      fontFamily: 'Orbitron',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class ParticlePainter extends CustomPainter {
  final Random random = Random();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 30; i++) {
      final x = (i * 37) % size.width.toInt();
      final y = (i * 73) % size.height.toInt();
      final radius = random.nextDouble() * 3 + 1;

      canvas.drawCircle(
        Offset(x.toDouble(), y.toDouble()),
        radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
