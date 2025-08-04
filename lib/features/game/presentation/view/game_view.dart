import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/input.dart';
import 'package:get_it/get_it.dart';
import 'package:shadow_clash_frontend/app/service_locator/service_locator.dart';
import 'package:shadow_clash_frontend/features/game/data/service/audio_service.dart';
import 'package:shadow_clash_frontend/features/game/presentation/provider/game_provider.dart';
import 'package:shadow_clash_frontend/features/game/domain/entity/game_state_entity.dart';

class GameView extends ConsumerWidget {
  const GameView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameNotifier = ref.read(gameProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GameWidget(
            game: BattleGame(gameNotifier: gameNotifier),
          ),
        ),
      ),
    );
  }
}

class BattleGame extends FlameGame with TapCallbacks {
  final GameNotifier gameNotifier;
  late BattleBackgroundComponent background;
  late PlayerComponent player;
  late EnemyComponent enemy;
  late HudComponent hud;
  late ActionButtonsComponent actionButtons;
  late TimerComponent timer;
  late DamageEffectComponent damageEffects;
  BattleEndOverlay? battleEndOverlay;

  BattleGame({required this.gameNotifier});

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    background = BattleBackgroundComponent();
    add(background);

    player = PlayerComponent();
    add(player);

    enemy = EnemyComponent();
    add(enemy);

    hud = HudComponent();
    add(hud);

    actionButtons = ActionButtonsComponent();
    add(actionButtons);

    timer = TimerComponent();
    add(timer);

    damageEffects = DamageEffectComponent();
    add(damageEffects);

    try {
      final audioService = getIt<AudioService>();
      await audioService.initialize();
      await audioService.playBackgroundMusic();
      await audioService.playFightersReady();
    } catch (e) {
      print('Audio initialization error: $e');
    }

    await gameNotifier.startGame();
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Check if game has ended and show overlay
    final gameState = gameNotifier.state;
    if ((gameState.status == GameStatus.victory ||
            gameState.status == GameStatus.defeat ||
            gameState.status == GameStatus.draw) &&
        battleEndOverlay == null) {
      final isVictory = gameState.status == GameStatus.victory;
      battleEndOverlay = BattleEndOverlay(gameStatus: gameState.status);
      add(battleEndOverlay!);
    }
  }
}

class BattleBackgroundComponent extends SpriteComponent
    with HasGameReference<BattleGame> {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    try {
      sprite = await Sprite.load('arena.png');
    } catch (e) {
      print('Failed to load arena background: $e');
    }
    size = game.size;
    position = Vector2.zero();
  }

  @override
  void render(Canvas canvas) {
    if (sprite != null) {
      super.render(canvas);
    } else {
      canvas.drawColor(const Color(0xFF1a1a2e), BlendMode.src);
    }
  }
}

class PlayerComponent extends SpriteComponent
    with HasGameReference<BattleGame> {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    try {
      sprite = await Sprite.load('Player.png');
    } catch (e) {
      print('Failed to load player sprite: $e');
    }

    final isLandscape = game.size.x > game.size.y;
    final spriteSize = isLandscape ? 100.0 : 120.0;

    size = Vector2(spriteSize, spriteSize);
    position = Vector2(isLandscape ? 50 : 80, game.size.y / 2 - spriteSize / 2);
  }

  @override
  void render(Canvas canvas) {
    if (sprite != null) {
      super.render(canvas);
    } else {
      final rect = Rect.fromLTWH(0, 0, size.x, size.y);
      final paint = Paint()..color = Colors.blue;
      canvas.drawRect(rect, paint);
    }
  }
}

class EnemyComponent extends SpriteComponent with HasGameReference<BattleGame> {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    try {
      sprite = await Sprite.load('Enemy.png');
    } catch (e) {
      print('Failed to load enemy sprite: $e');
    }

    final isLandscape = game.size.x > game.size.y;
    final spriteSize = isLandscape ? 100.0 : 120.0;

    size = Vector2(spriteSize, spriteSize);
    position = Vector2(game.size.x - spriteSize - (isLandscape ? 50 : 80),
        game.size.y / 2 - spriteSize / 2);
  }

  @override
  void render(Canvas canvas) {
    if (sprite != null) {
      super.render(canvas);
    } else {
      final rect = Rect.fromLTWH(0, 0, size.x, size.y);
      final paint = Paint()..color = Colors.red;
      canvas.drawRect(rect, paint);
    }
  }
}

class HudComponent extends PositionComponent with HasGameReference<BattleGame> {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    size = Vector2(game.size.x, 120);
    position = Vector2(0, 10);
  }

  @override
  void render(Canvas canvas) {
    final gameState = game.gameNotifier.state;
    final playerHpPercent = gameState.player.currentHp / gameState.player.maxHp;
    final enemyHpPercent = gameState.ai.currentHp / gameState.ai.maxHp;

    final playerHpColor = playerHpPercent > 0.5
        ? Colors.green
        : playerHpPercent > 0.25
            ? Colors.orange
            : Colors.red;
    final enemyHpColor = enemyHpPercent > 0.5
        ? Colors.red
        : enemyHpPercent > 0.25
            ? Colors.orange
            : Colors.green;

    final isLandscape = game.size.x > game.size.y;

    // Responsive HP bar dimensions
    final barWidth = isLandscape ? game.size.x * 0.15 : 180.0;
    final barHeight = isLandscape ? 20.0 : 25.0;
    final barSpacing = isLandscape ? game.size.x * 0.05 : 20.0;
    final topMargin = isLandscape ? 10.0 : 20.0;

    // Player HP Bar (Left side)
    final playerBarX = barSpacing;
    final playerBarY = topMargin;

    final playerBarRect =
        Rect.fromLTWH(playerBarX, playerBarY, barWidth, barHeight);
    final playerHpRect = Rect.fromLTWH(
        playerBarX, playerBarY, barWidth * playerHpPercent, barHeight);

    canvas.drawRect(
        playerBarRect, Paint()..color = Colors.grey.withValues(alpha: 0.5));
    canvas.drawRect(playerHpRect, Paint()..color = playerHpColor);
    canvas.drawRect(
        playerBarRect,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2);

    // Enemy HP Bar (Right side)
    final enemyBarX = game.size.x - barWidth - barSpacing;
    final enemyBarY = topMargin;

    final enemyBarRect =
        Rect.fromLTWH(enemyBarX, enemyBarY, barWidth, barHeight);
    final enemyHpRect = Rect.fromLTWH(
        enemyBarX, enemyBarY, barWidth * enemyHpPercent, barHeight);

    canvas.drawRect(
        enemyBarRect, Paint()..color = Colors.grey.withValues(alpha: 0.5));
    canvas.drawRect(enemyHpRect, Paint()..color = enemyHpColor);
    canvas.drawRect(
        enemyBarRect,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2);

    // Player HP Text
    final playerTextPainter = TextPainter(
      text: TextSpan(
        text: 'Player: ${gameState.player.currentHp}/${gameState.player.maxHp}',
        style: TextStyle(
            color: Colors.white,
            fontSize: isLandscape ? 10 : 12,
            fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    );
    playerTextPainter.layout();
    playerTextPainter.paint(
        canvas, Offset(playerBarX, playerBarY + barHeight + 5));

    // Enemy HP Text
    final enemyTextPainter = TextPainter(
      text: TextSpan(
        text: 'Enemy: ${gameState.ai.currentHp}/${gameState.ai.maxHp}',
        style: TextStyle(
            color: Colors.white,
            fontSize: isLandscape ? 10 : 12,
            fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    );
    enemyTextPainter.layout();
    enemyTextPainter.paint(
        canvas, Offset(enemyBarX, enemyBarY + barHeight + 5));

    // Turn indicator
    final turnText = gameState.isPlayerTurn ? 'YOUR TURN' : 'ENEMY TURN';
    final turnColor = gameState.isPlayerTurn ? Colors.green : Colors.red;

    final turnTextPainter = TextPainter(
      text: TextSpan(
        text: turnText,
        style: TextStyle(
          color: turnColor,
          fontSize: isLandscape ? game.size.x * 0.02 : 20,
          fontWeight: FontWeight.bold,
          shadows: const [
            Shadow(
              color: Colors.black,
              blurRadius: 3,
              offset: Offset(1, 1),
            ),
          ],
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    turnTextPainter.layout();
    turnTextPainter.paint(
        canvas,
        Offset(
            (game.size.x - turnTextPainter.width) / 2, isLandscape ? 40 : 70));
  }
}

class ActionButtonsComponent extends PositionComponent
    with HasGameReference<BattleGame> {
  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final isLandscape = game.size.x > game.size.y;

    if (isLandscape) {
      // Landscape: buttons at the bottom with more spacing
      size = Vector2(game.size.x, 100);
      position = Vector2(0, game.size.y - 120);
    } else {
      // Portrait: buttons at the bottom
      size = Vector2(game.size.x, 120);
      position = Vector2(0, game.size.y - 140);
    }

    final buttonSize = Vector2(120, isLandscape ? 50 : 60);
    final spacing = isLandscape ? 60.0 : 40.0;

    final buttons = [
      ('ATTACK', Colors.red, () => _handleAttack()),
      ('SKILL', Colors.purple, () => _handleSkill()),
    ];

    for (int i = 0; i < buttons.length; i++) {
      final button = HudButtonComponent(
        text: buttons[i].$1,
        color: buttons[i].$2,
        size: buttonSize,
        onPressed: buttons[i].$3,
      );
      button.position = Vector2(
        (game.size.x - (buttons.length * (buttonSize.x + spacing) - spacing)) /
                2 +
            i * (buttonSize.x + spacing),
        isLandscape ? 25 : 30,
      );
      add(button);
    }
  }

  void _handleAttack() async {
    try {
      final audioService = getIt<AudioService>();
      await audioService.playMenuSelect();
      await Future.delayed(const Duration(milliseconds: 100));
      await audioService.playSwordSwing();

      final gameState = game.gameNotifier.state;
      const damage = 150;

      await game.gameNotifier.playerAttack();
      await audioService.playImpact();

      // Show damage effect with actual damage from game state
      final currentState = game.gameNotifier.state;
      final actualDamage = gameState.ai.currentHp - currentState.ai.currentHp;

      game.damageEffects.showDamageEffect(
        position: Vector2(game.size.x / 2, game.size.y / 2),
        damage: actualDamage > 0 ? actualDamage : damage,
        isCritical: false,
      );
    } catch (e) {
      print('Attack error: $e');
    }
  }

  void _handleSkill() async {
    try {
      final audioService = getIt<AudioService>();
      await audioService.playMenuSelect();
      await Future.delayed(const Duration(milliseconds: 100));
      await audioService.playSkillSound();

      final gameState = game.gameNotifier.state;
      const damage = 300;

      await game.gameNotifier.playerSkill();
      await audioService.playImpact();

      // Show damage effect with actual damage from game state
      final currentState = game.gameNotifier.state;
      final actualDamage = gameState.ai.currentHp - currentState.ai.currentHp;

      game.damageEffects.showDamageEffect(
        position: Vector2(game.size.x / 2, game.size.y / 2),
        damage: actualDamage > 0 ? actualDamage : damage,
        isCritical: true,
      );
    } catch (e) {
      print('Skill error: $e');
    }
  }
}

class DamageEffectComponent extends PositionComponent
    with HasGameReference<BattleGame> {
  final List<DamagePopup> damagePopups = [];

  void showDamageEffect({
    required Vector2 position,
    required int damage,
    required bool isCritical,
  }) {
    damagePopups.add(DamagePopup(
      position: position,
      damage: damage,
      isCritical: isCritical,
      life: 2.0,
    ));
  }

  @override
  void update(double dt) {
    super.update(dt);

    for (int i = damagePopups.length - 1; i >= 0; i--) {
      final popup = damagePopups[i];
      popup.life -= dt;
      popup.position.y -= 50 * dt;

      if (popup.life <= 0) {
        damagePopups.removeAt(i);
      }
    }
  }

  @override
  void render(Canvas canvas) {
    for (final popup in damagePopups) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: popup.isCritical
              ? 'CRITICAL ${popup.damage}!'
              : '${popup.damage}',
          style: TextStyle(
            color: popup.isCritical ? Colors.yellow : Colors.white,
            fontSize: popup.isCritical ? 24 : 20,
            fontWeight: FontWeight.bold,
            shadows: const [
              Shadow(
                color: Colors.black,
                blurRadius: 3,
                offset: Offset(1, 1),
              ),
            ],
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(popup.position.x - textPainter.width / 2, popup.position.y),
      );
    }
  }
}

class DamagePopup {
  Vector2 position;
  int damage;
  bool isCritical;
  double life;

  DamagePopup({
    required this.position,
    required this.damage,
    required this.isCritical,
    required this.life,
  });
}

class TimerComponent extends PositionComponent
    with HasGameReference<BattleGame> {
  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final isLandscape = game.size.x > game.size.y;

    if (isLandscape) {
      size = Vector2(game.size.x, 40);
      position = Vector2(0, 80);
    } else {
      size = Vector2(game.size.x, 50);
      position = Vector2(0, 140);
    }
  }

  @override
  void render(Canvas canvas) {
    final gameState = game.gameNotifier.state;
    final minutes = gameState.timeRemaining ~/ 60;
    final seconds = gameState.timeRemaining % 60;

    final isLandscape = game.size.x > game.size.y;
    final fontSize = isLandscape ? 20.0 : 24.0;

    final textPainter = TextPainter(
      text: TextSpan(
        text:
            '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
        style: TextStyle(
            color: Colors.white,
            fontSize: fontSize,
            fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
          (size.x - textPainter.width) / 2, (size.y - textPainter.height) / 2),
    );
  }
}

class HudButtonComponent extends PositionComponent with TapCallbacks {
  String text;
  final Color color;
  final VoidCallback onPressed;

  HudButtonComponent({
    required this.text,
    required this.color,
    required Vector2 size,
    required this.onPressed,
  }) : super(size: size);

  @override
  bool onTapDown(TapDownEvent event) {
    onPressed();
    return true;
  }

  @override
  void render(Canvas canvas) {
    final rect = Rect.fromLTWH(0, 0, size.x, size.y);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(15)),
      paint,
    );

    final borderPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(15)),
      borderPaint,
    );

    final isLandscape =
        size.x > size.y * 2; // Check if button is wider than tall
    final fontSize = isLandscape ? 14.0 : 16.0;

    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
            color: Colors.white,
            fontSize: fontSize,
            fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    textPainter.layout(minWidth: size.x);
    textPainter.paint(
      canvas,
      Offset(
          (size.x - textPainter.width) / 2, (size.y - textPainter.height) / 2),
    );
  }
}

class BattleEndOverlay extends PositionComponent
    with HasGameReference<BattleGame> {
  final GameStatus gameStatus;

  BattleEndOverlay({required this.gameStatus});

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    size = game.size;
    position = Vector2.zero();
  }

  @override
  void render(Canvas canvas) {
    // Semi-transparent background
    canvas.drawColor(Colors.black.withValues(alpha: 0.8), BlendMode.src);

    final isLandscape = size.x > size.y;
    final titleFontSize = isLandscape ? size.x * 0.06 : 48.0;
    final buttonWidth = isLandscape ? size.x * 0.25 : 200.0;
    final buttonHeight = isLandscape ? 50.0 : 60.0;

    // Victory/Defeat/Draw text
    String text;
    Color color;

    switch (gameStatus) {
      case GameStatus.victory:
        text = 'YOU WIN!';
        color = Colors.green;
        break;
      case GameStatus.defeat:
        text = 'YOU LOSE!';
        color = Colors.red;
        break;
      case GameStatus.draw:
        text = 'DRAW!';
        color = Colors.yellow;
        break;
      default:
        text = 'GAME OVER';
        color = Colors.white;
    }

    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: titleFontSize,
          fontWeight: FontWeight.bold,
          shadows: const [
            Shadow(
              color: Colors.black,
              blurRadius: 5,
              offset: Offset(2, 2),
            ),
          ],
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset((size.x - textPainter.width) / 2, size.y * 0.3),
    );

    // Back to Dashboard button
    final buttonRect = Rect.fromLTWH(
      (size.x - buttonWidth) / 2,
      size.y * 0.5,
      buttonWidth,
      buttonHeight,
    );

    final buttonPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(buttonRect, const Radius.circular(15)),
      buttonPaint,
    );

    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawRRect(
      RRect.fromRectAndRadius(buttonRect, const Radius.circular(15)),
      borderPaint,
    );

    final buttonTextFontSize = isLandscape ? size.x * 0.02 : 16.0;
    final buttonTextPainter = TextPainter(
      text: TextSpan(
        text: 'GO BACK TO DASHBOARD',
        style: TextStyle(
          color: Colors.white,
          fontSize: buttonTextFontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    buttonTextPainter.layout();
    buttonTextPainter.paint(
      canvas,
      Offset(
        buttonRect.left + (buttonRect.width - buttonTextPainter.width) / 2,
        buttonRect.top + (buttonRect.height - buttonTextPainter.height) / 2,
      ),
    );
  }

  @override
  bool onTapDown(TapDownEvent event) {
    final isLandscape = size.x > size.y;
    final buttonWidth = isLandscape ? size.x * 0.25 : 200.0;
    final buttonHeight = isLandscape ? 50.0 : 60.0;

    final buttonRect = Rect.fromLTWH(
      (size.x - buttonWidth) / 2,
      size.y * 0.5,
      buttonWidth,
      buttonHeight,
    );

    if (buttonRect.contains(event.localPosition.toOffset())) {
      try {
        final audioService = getIt<AudioService>();
        audioService.stopBackgroundMusic();

        final navigationService = getIt<NavigationService>();
        if (navigationService.navigatorKey.currentState != null) {
          navigationService.navigateToAndClear('/dashboard');
        } else {
          print('Navigation service not ready, using fallback');
          WidgetsBinding.instance.addPostFrameCallback((_) {
            navigationService.navigatorKey.currentState
                ?.pushNamedAndRemoveUntil('/dashboard', (route) => false);
          });
        }
      } catch (e) {
        print('Navigation error: $e');
        WidgetsBinding.instance.addPostFrameCallback((_) {
          getIt<NavigationService>()
              .navigatorKey
              .currentState
              ?.pushNamedAndRemoveUntil('/dashboard', (route) => false);
        });
      }
      return true;
    }
    return false;
  }
}
