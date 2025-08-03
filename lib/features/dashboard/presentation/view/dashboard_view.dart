import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadow_clash_frontend/features/dashboard/presentation/view_model/dashboard_view_model.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isLandscape = screenSize.width > screenSize.height;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF1a1a2e),
              const Color(0xFF16213e),
              const Color(0xFF0f3460),
              const Color(0xFF1a1a2e),
            ],
          ),
        ),
        child: SafeArea(
          child: Consumer<DashboardViewModel>(
            builder: (context, viewModel, child) {
              return Column(
                children: [
                  _buildHeader(screenSize, isLandscape),
                  Expanded(
                    child: isLandscape
                        ? _buildLandscapeLayout(screenSize, viewModel)
                        : _buildPortraitLayout(screenSize, viewModel),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(Size screenSize, bool isLandscape) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenSize.width * 0.05,
        vertical: screenSize.height * 0.02,
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
                  color: Colors.red.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
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
                letterSpacing: 2,
                shadows: [
                  Shadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    blurRadius: 2,
                    offset: const Offset(1, 1),
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: [
              _buildSoundToggle(screenSize, isLandscape),
              SizedBox(width: screenSize.width * 0.02),
              _buildLogoutButton(screenSize, isLandscape),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSoundToggle(Size screenSize, bool isLandscape) {
    return Consumer<DashboardViewModel>(
      builder: (context, viewModel, child) {
        return GestureDetector(
          onTap: viewModel.toggleSound,
          child: Container(
            padding: EdgeInsets.all(screenSize.width * 0.015),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade400, Colors.cyan.shade400],
              ),
              borderRadius: BorderRadius.circular(screenSize.width * 0.02),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              viewModel.state.isSoundEnabled
                  ? Icons.volume_up
                  : Icons.volume_off,
              color: Colors.white,
              size: isLandscape
                  ? screenSize.width * 0.025
                  : screenSize.width * 0.04,
            ),
          ),
        );
      },
    );
  }

  Widget _buildLogoutButton(Size screenSize, bool isLandscape) {
    return Consumer<DashboardViewModel>(
      builder: (context, viewModel, child) {
        return GestureDetector(
          onTap: viewModel.logout,
          child: Container(
            padding: EdgeInsets.all(screenSize.width * 0.015),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.red.shade400, Colors.orange.shade400],
              ),
              borderRadius: BorderRadius.circular(screenSize.width * 0.02),
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.logout,
              color: Colors.white,
              size: isLandscape
                  ? screenSize.width * 0.025
                  : screenSize.width * 0.04,
            ),
          ),
        );
      },
    );
  }

  Widget _buildPortraitLayout(Size screenSize, DashboardViewModel viewModel) {
    return Container(
      padding: EdgeInsets.all(screenSize.width * 0.05),
      child: Column(
        children: [
          _buildPlayerStats(screenSize),
          SizedBox(height: screenSize.height * 0.03),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: screenSize.width * 0.04,
              mainAxisSpacing: screenSize.height * 0.02,
              children: [
                _buildGameButton(
                  screenSize,
                  'START BATTLE',
                  Icons.sports_kabaddi,
                  Colors.red,
                  viewModel.navigateToGame,
                ),
                _buildGameButton(
                  screenSize,
                  'PROFILE',
                  Icons.person,
                  Colors.blue,
                  viewModel.navigateToProfile,
                ),
                _buildGameButton(
                  screenSize,
                  'SETTINGS',
                  Icons.settings,
                  Colors.green,
                  viewModel.navigateToSettings,
                ),
                _buildGameButton(
                  screenSize,
                  'ACHIEVEMENTS',
                  Icons.emoji_events,
                  Colors.orange,
                  viewModel.navigateToAchievements,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLandscapeLayout(Size screenSize, DashboardViewModel viewModel) {
    return Container(
      padding: EdgeInsets.all(screenSize.width * 0.03),
      child: Row(
        children: [
          Expanded(flex: 2, child: _buildPlayerStats(screenSize)),
          SizedBox(width: screenSize.width * 0.03),
          Expanded(
            flex: 3,
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: screenSize.width * 0.02,
              mainAxisSpacing: screenSize.height * 0.015,
              children: [
                _buildGameButton(
                  screenSize,
                  'START BATTLE',
                  Icons.sports_kabaddi,
                  Colors.red,
                  viewModel.navigateToGame,
                ),
                _buildGameButton(
                  screenSize,
                  'PROFILE',
                  Icons.person,
                  Colors.blue,
                  viewModel.navigateToProfile,
                ),
                _buildGameButton(
                  screenSize,
                  'SETTINGS',
                  Icons.settings,
                  Colors.green,
                  viewModel.navigateToSettings,
                ),
                _buildGameButton(
                  screenSize,
                  'ACHIEVEMENTS',
                  Icons.emoji_events,
                  Colors.orange,
                  viewModel.navigateToAchievements,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerStats(Size screenSize) {
    final isLandscape = screenSize.width > screenSize.height;

    return Container(
      padding: EdgeInsets.all(screenSize.width * 0.04),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withValues(alpha: 0.1),
            Colors.white.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(screenSize.width * 0.03),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: isLandscape
                ? screenSize.width * 0.15
                : screenSize.width * 0.25,
            height: isLandscape
                ? screenSize.width * 0.15
                : screenSize.width * 0.25,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade400, Colors.cyan.shade400],
              ),
              borderRadius: BorderRadius.circular(
                isLandscape
                    ? screenSize.width * 0.075
                    : screenSize.width * 0.125,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
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
              shadows: [
                Shadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  blurRadius: 2,
                  offset: const Offset(1, 1),
                ),
              ],
            ),
          ),
          SizedBox(height: screenSize.height * 0.01),
          _buildStatBar(screenSize, 'LEVEL', 85, Colors.green, isLandscape),
          SizedBox(height: screenSize.height * 0.005),
          _buildStatBar(screenSize, 'XP', 1200, Colors.blue, isLandscape),
          SizedBox(height: screenSize.height * 0.005),
          _buildStatBar(screenSize, 'WINS', 42, Colors.orange, isLandscape),
        ],
      ),
    );
  }

  Widget _buildStatBar(
    Size screenSize,
    String label,
    int value,
    Color color,
    bool isLandscape,
  ) {
    return Column(
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
                color: Colors.white.withValues(alpha: 0.8),
                fontWeight: FontWeight.w700,
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
            color: Colors.black.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(
              isLandscape
                  ? screenSize.height * 0.0075
                  : screenSize.height * 0.01,
            ),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: 0.8,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color, color.withValues(alpha: 0.8)],
                ),
                borderRadius: BorderRadius.circular(
                  isLandscape
                      ? screenSize.height * 0.0075
                      : screenSize.height * 0.01,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGameButton(
    Size screenSize,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    final isLandscape = screenSize.width > screenSize.height;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.withValues(alpha: 0.8),
              color.withValues(alpha: 0.6),
              color.withValues(alpha: 0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(screenSize.width * 0.02),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.3),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 3),
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
                shadows: [
                  Shadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    blurRadius: 2,
                    offset: const Offset(1, 1),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
