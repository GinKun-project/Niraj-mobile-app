import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_clash_frontend/features/game/domain/entity/game_state_entity.dart';
import 'package:shadow_clash_frontend/features/game/domain/entity/player_entity.dart';
import 'package:shadow_clash_frontend/features/game/presentation/provider/game_provider.dart';

class GameView extends ConsumerStatefulWidget {
  const GameView({super.key});

  @override
  ConsumerState<GameView> createState() => _GameViewState();
}

class _GameViewState extends ConsumerState<GameView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(gameProvider.notifier).startGame();
    });
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1a1a2e), Color(0xFF16213e)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildTopSection(gameState),
              Expanded(child: _buildBattlefield(gameState)),
              _buildBottomSection(gameState),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopSection(GameStateEntity gameState) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildTimer(gameState.timeRemaining),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildPlayerInfo(gameState.player)),
              const SizedBox(width: 16),
              Expanded(child: _buildPlayerInfo(gameState.ai)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimer(int timeRemaining) {
    final minutes = timeRemaining ~/ 60;
    final seconds = timeRemaining % 60;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Text(
        '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildPlayerInfo(PlayerEntity player) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Text(
            player.name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          _buildHealthBar(player),
          const SizedBox(height: 4),
          Text(
            '${player.currentHp}/${player.maxHp} HP',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthBar(PlayerEntity player) {
    return Container(
      height: 16,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: player.healthPercentage,
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF4CAF50), Color(0xFF8BC34A)],
            ),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Widget _buildBattlefield(GameStateEntity gameState) {
    return Stack(
      children: [
        _buildGrid(),
        _buildCharacters(gameState),
        _buildDamagePopups(gameState.damagePopups),
      ],
    );
  }

  Widget _buildGrid() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
        ),
        itemCount: 12,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              borderRadius: BorderRadius.circular(4),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCharacters(GameStateEntity gameState) {
    return Positioned.fill(
      child: Container(
        margin: const EdgeInsets.all(20),
        child: Stack(
          children: [
            _buildCharacter(gameState.player, false),
            _buildCharacter(gameState.ai, true),
          ],
        ),
      ),
    );
  }

  Widget _buildCharacter(PlayerEntity player, bool isEnemy) {
    final gridSize = 4;
    final cellWidth = (MediaQuery.of(context).size.width - 40) / gridSize;
    final cellHeight = (MediaQuery.of(context).size.height - 200) / 3;

    return Positioned(
      left: player.positionX * (cellWidth + 4),
      top: player.positionY * (cellHeight + 4),
      child: Container(
        width: cellWidth,
        height: cellHeight,
        child: Image.asset(
          isEnemy ? 'assets/images/Enemy.png' : 'assets/images/Player.png',
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildDamagePopups(List<DamagePopup> popups) {
    return Stack(
      children: popups.map((popup) {
        final age = DateTime.now().difference(popup.timestamp).inMilliseconds;
        final opacity = (2000 - age) / 2000.0;

        return Positioned(
          left: 100 + (popup.hashCode % 200),
          top: 200 + (popup.hashCode % 100),
          child: Opacity(
            opacity: opacity.clamp(0.0, 1.0),
            child: Text(
              popup.text,
              style: TextStyle(
                fontSize: popup.isCritical ? 24 : 20,
                fontWeight: FontWeight.bold,
                color: popup.isCritical
                    ? Colors.red
                    : popup.isHeal
                    ? Colors.green
                    : Colors.orange,
                shadows: [
                  Shadow(
                    color: Colors.black,
                    blurRadius: 4,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBottomSection(GameStateEntity gameState) {
    if (gameState.status != GameStatus.playing) {
      return _buildGameOver(gameState.status);
    }

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildTurnIndicator(gameState.isPlayerTurn),
          const SizedBox(height: 16),
          _buildActionButtons(gameState),
        ],
      ),
    );
  }

  Widget _buildTurnIndicator(bool isPlayerTurn) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isPlayerTurn ? "Player's Turn" : "Enemy's Turn",
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildActionButtons(GameStateEntity gameState) {
    if (!gameState.isPlayerTurn) return const SizedBox.shrink();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActionButton('MOVE', Icons.directions_run, () {}),
        _buildActionButton('ATTACK', Icons.flash_on, () {
          ref.read(gameProvider.notifier).playerAttack();
        }),
        _buildActionButton('SKILL', Icons.auto_awesome, () {}),
        _buildActionButton('ITEM', Icons.inventory, () {}),
      ],
    );
  }

  Widget _buildActionButton(String text, IconData icon, VoidCallback onTap) {
    return Container(
      width: 80,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20, color: Colors.white),
              const SizedBox(height: 2),
              Text(
                text,
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameOver(GameStatus status) {
    String message;
    Color color;

    switch (status) {
      case GameStatus.victory:
        message = 'VICTORY!';
        color = const Color(0xFF4CAF50);
        break;
      case GameStatus.defeat:
        message = 'DEFEAT!';
        color = const Color(0xFFF44336);
        break;
      case GameStatus.draw:
        message = 'DRAW!';
        color = const Color(0xFFFF9800);
        break;
      default:
        message = '';
        color = Colors.white;
    }

    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 32),
          _buildBackButton(),
        ],
      ),
    );
  }

  Widget _buildBackButton() {
    return Container(
      width: 200,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(25),
          onTap: () => Navigator.pop(context),
          child: const Center(
            child: Text(
              'Back to Dashboard',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
