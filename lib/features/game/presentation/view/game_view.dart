import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_clash_frontend/features/game/domain/entity/game_state_entity.dart';
import 'package:shadow_clash_frontend/features/game/domain/entity/player_entity.dart';
import 'package:shadow_clash_frontend/features/game/presentation/provider/game_provider.dart';
import 'package:shadow_clash_frontend/app/service_locator/service_locator.dart';
import 'package:shadow_clash_frontend/features/game/data/repository/game_repository_impl.dart';

class GameView extends ConsumerStatefulWidget {
  const GameView({super.key});

  @override
  ConsumerState<GameView> createState() => _GameViewState();
}

class _GameViewState extends ConsumerState<GameView> {
  late final NavigationService _navigationService;

  @override
  void initState() {
    super.initState();
    _navigationService = getIt<NavigationService>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(gameProvider.notifier).startGame();
    });
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameProvider);
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF2C3E50),
              const Color(0xFF34495E),
              const Color(0xFF2C3E50),
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  _buildTopSection(gameState, screenSize),
                  Expanded(child: _buildBattlefield(gameState, screenSize)),
                  _buildBottomSection(gameState, screenSize),
                ],
              ),
              if (gameState.showSensorAlert) _buildSensorAlert(screenSize),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSensorAlert(Size screenSize) {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withValues(alpha: 0.5),
        child: Center(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: screenSize.width * 0.1,
              vertical: screenSize.height * 0.02,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.red.shade400, Colors.orange.shade400],
              ),
              borderRadius: BorderRadius.circular(screenSize.width * 0.04),
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withValues(alpha: 0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Text(
              'SENSOR ALERT!',
              style: TextStyle(
                fontSize: screenSize.width * 0.08,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 3,
                shadows: [
                  Shadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    blurRadius: 3,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopSection(GameStateEntity gameState, Size screenSize) {
    return Container(
      padding: EdgeInsets.all(screenSize.width * 0.04),
      child: Column(
        children: [
          _buildTitle(screenSize),
          SizedBox(height: screenSize.height * 0.02),
          _buildTimer(gameState.timeRemaining, screenSize),
          SizedBox(height: screenSize.height * 0.02),
          _buildTurnIndicator(gameState.isPlayerTurn, screenSize),
        ],
      ),
    );
  }

  Widget _buildTitle(Size screenSize) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenSize.width * 0.06,
        vertical: screenSize.height * 0.01,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.purple.shade400,
            Colors.blue.shade400,
            Colors.purple.shade600,
          ],
        ),
        borderRadius: BorderRadius.circular(screenSize.width * 0.04),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Text(
        'SHADOW CLASH',
        style: TextStyle(
          fontSize: screenSize.width * 0.08,
          fontWeight: FontWeight.w900,
          color: Colors.white,
          letterSpacing: 4,
          shadows: [
            Shadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 3,
              offset: const Offset(2, 2),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimer(int timeRemaining, Size screenSize) {
    final minutes = timeRemaining ~/ 60;
    final seconds = timeRemaining % 60;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenSize.width * 0.08,
        vertical: screenSize.height * 0.015,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withValues(alpha: 0.2),
            Colors.white.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(screenSize.width * 0.06),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Text(
        '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
        style: TextStyle(
          fontSize: screenSize.width * 0.12,
          fontWeight: FontWeight.w900,
          color: Colors.white,
          letterSpacing: 3,
          shadows: [
            Shadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 2,
              offset: const Offset(1, 1),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTurnIndicator(bool isPlayerTurn, Size screenSize) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenSize.width * 0.06,
        vertical: screenSize.height * 0.01,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isPlayerTurn
              ? [Colors.blue.shade400, Colors.cyan.shade400]
              : [Colors.red.shade400, Colors.orange.shade400],
        ),
        borderRadius: BorderRadius.circular(screenSize.width * 0.04),
        boxShadow: [
          BoxShadow(
            color: (isPlayerTurn ? Colors.blue : Colors.red).withValues(
              alpha: 0.3,
            ),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Text(
        isPlayerTurn ? "PLAYER'S TURN" : "ENEMY'S TURN",
        style: TextStyle(
          fontSize: screenSize.width * 0.06,
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
    );
  }

  Widget _buildBattlefield(GameStateEntity gameState, Size screenSize) {
    return Container(
      margin: EdgeInsets.all(screenSize.width * 0.05),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.1),
            Colors.white.withValues(alpha: 0.05),
            Colors.white.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(screenSize.width * 0.04),
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
      child: Stack(
        children: [
          _buildGrid(screenSize),
          _buildCharacters(gameState, screenSize),
          _buildDamagePopups(gameState.damagePopups, screenSize),
        ],
      ),
    );
  }

  Widget _buildGrid(Size screenSize) {
    return Container(
      margin: EdgeInsets.all(screenSize.width * 0.02),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
        ),
        itemCount: 12,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCharacters(GameStateEntity gameState, Size screenSize) {
    return Positioned.fill(
      child: Container(
        margin: EdgeInsets.all(screenSize.width * 0.05),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildCharacter(gameState.player, false, screenSize),
            _buildCharacter(gameState.ai, true, screenSize),
          ],
        ),
      ),
    );
  }

  Widget _buildCharacter(PlayerEntity player, bool isEnemy, Size screenSize) {
    final characterSize = screenSize.width * 0.25;
    final isPlayer = !isEnemy;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: characterSize,
          height: characterSize,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withValues(alpha: 0.2),
                Colors.white.withValues(alpha: 0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(characterSize * 0.1),
            border: Border.all(
              color: isPlayer ? Colors.blue.shade400 : Colors.red.shade400,
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: (isPlayer ? Colors.blue : Colors.red).withValues(
                  alpha: 0.3,
                ),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(characterSize * 0.1),
            child: Image.asset(
              isEnemy ? 'assets/images/Enemy.png' : 'assets/images/Player.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
        SizedBox(height: screenSize.height * 0.02),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: screenSize.width * 0.03,
            vertical: screenSize.height * 0.005,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withValues(alpha: 0.2),
                Colors.white.withValues(alpha: 0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(screenSize.width * 0.02),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Text(
            isPlayer ? 'Player' : 'ENEMY',
            style: TextStyle(
              fontSize: screenSize.width * 0.05,
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
        ),
        SizedBox(height: screenSize.height * 0.01),
        _buildHealthBar(player, screenSize, isPlayer),
        SizedBox(height: screenSize.height * 0.005),
        Text(
          '${player.currentHp}/${player.maxHp} HP',
          style: TextStyle(
            fontSize: screenSize.width * 0.035,
            color: Colors.white.withValues(alpha: 0.9),
            fontWeight: FontWeight.w700,
            shadows: [
              Shadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 1,
                offset: const Offset(1, 1),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHealthBar(PlayerEntity player, Size screenSize, bool isPlayer) {
    final healthPercentage = player.healthPercentage;
    final isLowHealth = healthPercentage <= 0.2;

    Color barColor;
    if (isLowHealth) {
      barColor = Colors.red.shade400;
    } else if (healthPercentage <= 0.5) {
      barColor = Colors.orange.shade400;
    } else {
      barColor = isPlayer ? Colors.blue.shade400 : Colors.red.shade400;
    }

    return Container(
      width: screenSize.width * 0.3,
      height: screenSize.height * 0.025,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(screenSize.height * 0.012),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: healthPercentage.clamp(0.0, 1.0),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [barColor, barColor.withValues(alpha: 0.8)],
            ),
            borderRadius: BorderRadius.circular(screenSize.height * 0.012),
            boxShadow: [
              BoxShadow(
                color: barColor.withValues(alpha: 0.3),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDamagePopups(List<DamagePopup> popups, Size screenSize) {
    return Stack(
      children: popups.map((popup) {
        final age = DateTime.now().difference(popup.timestamp).inMilliseconds;
        final opacity = (2000 - age) / 2000.0;

        final baseX = popup.isForPlayer
            ? screenSize.width * 0.2
            : screenSize.width * 0.7;
        final baseY = screenSize.height * 0.3;

        return Positioned(
          left: baseX + (popup.hashCode % 80),
          top: baseY + (popup.hashCode % 40) - (age / 15),
          child: Opacity(
            opacity: opacity.clamp(0.0, 1.0),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: screenSize.width * 0.02,
                vertical: screenSize.height * 0.005,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.8),
                    Colors.black.withValues(alpha: 0.6),
                  ],
                ),
                borderRadius: BorderRadius.circular(screenSize.width * 0.01),
                border: Border.all(
                  color: popup.isCritical
                      ? Colors.red.shade400
                      : Colors.orange.shade400,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                popup.text,
                style: TextStyle(
                  fontSize: popup.isCritical
                      ? screenSize.width * 0.05
                      : screenSize.width * 0.04,
                  fontWeight: FontWeight.w900,
                  color: popup.isCritical
                      ? Colors.red.shade300
                      : popup.isHeal
                      ? Colors.green.shade300
                      : Colors.orange.shade300,
                  shadows: [
                    Shadow(
                      color: Colors.black,
                      blurRadius: 3,
                      offset: const Offset(1, 1),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBottomSection(GameStateEntity gameState, Size screenSize) {
    if (gameState.status != GameStatus.playing) {
      return _buildGameOver(gameState.status, screenSize);
    }

    return Container(
      padding: EdgeInsets.all(screenSize.width * 0.04),
      child: _buildActionButtons(gameState, screenSize),
    );
  }

  Widget _buildActionButtons(GameStateEntity gameState, Size screenSize) {
    if (!gameState.isPlayerTurn) return const SizedBox.shrink();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActionButton('ATTACK', screenSize, () async {
          final repository = GameRepositoryImpl();
          await repository.playMenuSelect();
          ref.read(gameProvider.notifier).playerAttack();
        }),
        _buildActionButton('SKILL', screenSize, () async {
          final repository = GameRepositoryImpl();
          await repository.playMenuSelect();
          ref.read(gameProvider.notifier).playerSkill();
        }),
      ],
    );
  }

  Widget _buildActionButton(String text, Size screenSize, VoidCallback onTap) {
    return Container(
      width: screenSize.width * 0.35,
      height: screenSize.height * 0.08,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.purple.shade400,
            Colors.blue.shade400,
            Colors.purple.shade600,
          ],
        ),
        borderRadius: BorderRadius.circular(screenSize.width * 0.02),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(screenSize.width * 0.02),
          onTap: onTap,
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: screenSize.width * 0.045,
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
        ),
      ),
    );
  }

  Widget _buildGameOver(GameStatus status, Size screenSize) {
    String message;
    Color color;

    switch (status) {
      case GameStatus.victory:
        message = 'VICTORY!';
        color = Colors.green.shade400;
        break;
      case GameStatus.defeat:
        message = 'DEFEAT!';
        color = Colors.red.shade400;
        break;
      case GameStatus.draw:
        message = 'DRAW!';
        color = Colors.orange.shade400;
        break;
      default:
        message = '';
        color = Colors.blue.shade400;
    }

    return Container(
      padding: EdgeInsets.all(screenSize.width * 0.08),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: screenSize.width * 0.1,
              vertical: screenSize.height * 0.02,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color.withValues(alpha: 0.9),
                  color.withValues(alpha: 0.7),
                ],
              ),
              borderRadius: BorderRadius.circular(screenSize.width * 0.05),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Text(
              message,
              style: TextStyle(
                fontSize: screenSize.width * 0.08,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 3,
                shadows: [
                  Shadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    blurRadius: 3,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: screenSize.height * 0.04),
          _buildBackButton(screenSize),
        ],
      ),
    );
  }

  Widget _buildBackButton(Size screenSize) {
    return Container(
      width: screenSize.width * 0.5,
      height: screenSize.height * 0.06,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withValues(alpha: 0.2),
            Colors.white.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(screenSize.width * 0.05),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(screenSize.width * 0.05),
          onTap: () => _navigationService.goBack(),
          child: Center(
            child: Text(
              'Back to Dashboard',
              style: TextStyle(
                fontSize: screenSize.width * 0.04,
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
          ),
        ),
      ),
    );
  }
}
