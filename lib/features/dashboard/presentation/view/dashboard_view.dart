import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:provider/provider.dart';
import 'package:shadow_clash_frontend/features/dashboard/presentation/view_model/dashboard_view_model.dart';

class DashboardGame extends FlameGame with TapCallbacks {
  late DashboardViewModel viewModel;
  late BackgroundComponent background;
  late UserProfileComponent userProfile;
  late ActionButtonsComponent actionButtons;
  late ParticleSystemComponent particles;

  DashboardGame({required this.viewModel});

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    try {
      background = BackgroundComponent();
      add(background);

      particles = ParticleSystemComponent();
      add(particles);

      userProfile = UserProfileComponent();
      add(userProfile);

      actionButtons = ActionButtonsComponent();
      add(actionButtons);
    } catch (e) {
      print('Error loading dashboard components: $e');
    }
  }
}

class BackgroundComponent extends SpriteComponent
    with HasGameReference<DashboardGame> {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    try {
      sprite = await Sprite.load('background.png');
    } catch (e) {
      print('Failed to load background: $e');
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

class ParticleSystemComponent extends Component
    with HasGameReference<DashboardGame> {
  final List<Particle> particles = [];
  final Random random = Random();

  @override
  void onMount() {
    super.onMount();
    for (int i = 0; i < 50; i++) {
      particles.add(Particle(
        position: Vector2(
          random.nextDouble() * game.size.x,
          random.nextDouble() * game.size.y,
        ),
        velocity: Vector2(
          (random.nextDouble() - 0.5) * 50,
          (random.nextDouble() - 0.5) * 50,
        ),
        life: 3.0,
        maxLife: 3.0,
      ));
    }
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;

    for (final particle in particles) {
      canvas.drawCircle(
        Offset(particle.position.x, particle.position.y),
        2,
        paint,
      );
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    for (final particle in particles) {
      particle.position += particle.velocity * dt;
      particle.life -= dt;

      if (particle.life <= 0) {
        particle.position = Vector2(
          random.nextDouble() * game.size.x,
          random.nextDouble() * game.size.y,
        );
        particle.life = particle.maxLife;
      }
    }
  }
}

class Particle {
  Vector2 position;
  Vector2 velocity;
  double life;
  final double maxLife;

  Particle({
    required this.position,
    required this.velocity,
    required this.life,
    required this.maxLife,
  });
}

class UserProfileComponent extends PositionComponent
    with HasGameReference<DashboardGame> {
  late TextComponent title;
  late TextComponent playerName;
  late TextComponent levelText;
  late TextComponent xpText;
  late TextComponent winsText;
  late ProgressBarComponent levelBar;
  late ProgressBarComponent xpBar;
  late ProgressBarComponent winsBar;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final isLandscape = game.size.x > game.size.y;
    
    if (isLandscape) {
      // Landscape layout: smaller profile on the left
      size = Vector2(game.size.x * 0.25, game.size.y * 0.8);
      position = Vector2(
        game.size.x * 0.02,
        game.size.y * 0.1,
      );
    } else {
      // Portrait layout: profile at the top
      size = Vector2(game.size.x * 0.9, game.size.y * 0.3);
      position = Vector2(
        game.size.x * 0.05,
        game.size.y * 0.05,
      );
    }

    final fontSize = isLandscape ? 18.0 : 24.0;
    final titleFontSize = isLandscape ? 16.0 : 20.0;
    final barHeight = isLandscape ? 15.0 : 20.0;

    title = TextComponent(
      text: 'SHADOW CLASH',
      textRenderer: TextPaint(
        style: TextStyle(
          fontSize: titleFontSize,
          fontWeight: FontWeight.w900,
          color: Colors.white,
          shadows: const [
            Shadow(
              color: Colors.black,
              blurRadius: 3,
              offset: Offset(2, 2),
            ),
          ],
        ),
      ),
    );
    title.position = Vector2(size.x * 0.5, isLandscape ? 15 : 20);
    title.anchor = Anchor.center;
    add(title);

    final data = game.viewModel.state.data;
    if (data != null) {
      playerName = TextComponent(
        text: data.playerName,
        textRenderer: TextPaint(
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            shadows: const [
              Shadow(
                color: Colors.black,
                blurRadius: 2,
                offset: Offset(1, 1),
              ),
            ],
          ),
        ),
      );
      playerName.position = Vector2(size.x * 0.5, isLandscape ? 45 : 60);
      playerName.anchor = Anchor.center;
      add(playerName);

      levelText = TextComponent(
        text: 'LEVEL',
        textRenderer: TextPaint(
          style: TextStyle(
            fontSize: fontSize * 0.8,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      );
      levelText.position = Vector2(10, isLandscape ? 80 : 100);
      add(levelText);

      levelBar = ProgressBarComponent(
        value: data.playerLevel / 100,
        color: Colors.green,
        size: Vector2(size.x - 20, barHeight),
      );
      levelBar.position = Vector2(10, isLandscape ? 105 : 130);
      add(levelBar);

      final levelValueText = TextComponent(
        text: data.playerLevel.toString(),
        textRenderer: TextPaint(
          style: TextStyle(
            fontSize: fontSize * 0.7,
            fontWeight: FontWeight.w600,
            color: Colors.green,
          ),
        ),
      );
      levelValueText.position = Vector2(size.x - 10, isLandscape ? 105 : 130);
      levelValueText.anchor = Anchor.centerLeft;
      add(levelValueText);

      xpText = TextComponent(
        text: 'XP',
        textRenderer: TextPaint(
          style: TextStyle(
            fontSize: fontSize * 0.8,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      );
      xpText.position = Vector2(10, isLandscape ? 140 : 170);
      add(xpText);

      xpBar = ProgressBarComponent(
        value: data.playerXp / 2000,
        color: Colors.blue,
        size: Vector2(size.x - 20, barHeight),
      );
      xpBar.position = Vector2(10, isLandscape ? 165 : 200);
      add(xpBar);

      final xpValueText = TextComponent(
        text: data.playerXp.toString(),
        textRenderer: TextPaint(
          style: TextStyle(
            fontSize: fontSize * 0.7,
            fontWeight: FontWeight.w600,
            color: Colors.blue,
          ),
        ),
      );
      xpValueText.position = Vector2(size.x - 10, isLandscape ? 165 : 200);
      xpValueText.anchor = Anchor.centerLeft;
      add(xpValueText);

      winsText = TextComponent(
        text: 'WINS',
        textRenderer: TextPaint(
          style: TextStyle(
            fontSize: fontSize * 0.8,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      );
      winsText.position = Vector2(10, isLandscape ? 200 : 240);
      add(winsText);

      winsBar = ProgressBarComponent(
        value: data.playerWins / 100,
        color: Colors.orange,
        size: Vector2(size.x - 20, barHeight),
      );
      winsBar.position = Vector2(10, isLandscape ? 225 : 270);
      add(winsBar);

      final winsValueText = TextComponent(
        text: data.playerWins.toString(),
        textRenderer: TextPaint(
          style: TextStyle(
            fontSize: fontSize * 0.7,
            fontWeight: FontWeight.w600,
            color: Colors.orange,
          ),
        ),
      );
      winsValueText.position = Vector2(size.x - 10, isLandscape ? 225 : 270);
      winsValueText.anchor = Anchor.centerLeft;
      add(winsValueText);
    }
  }

  @override
  void render(Canvas canvas) {
    final rect = Rect.fromLTWH(0, 0, size.x, size.y);
    final paint = Paint()
      ..color = Colors.black.withValues(alpha: 0.7)
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(15)),
      paint,
    );

    final borderPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(15)),
      borderPaint,
    );
  }
}

class ProgressBarComponent extends PositionComponent {
  final double value;
  final Color color;

  ProgressBarComponent({
    required this.value,
    required this.color,
    required Vector2 size,
  }) : super(size: size);

  @override
  void render(Canvas canvas) {
    final rect = Rect.fromLTWH(0, 0, size.x, size.y);
    final backgroundPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.5)
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(10)),
      backgroundPaint,
    );

    final progressRect = Rect.fromLTWH(0, 0, size.x * value, size.y);
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(progressRect, const Radius.circular(10)),
      progressPaint,
    );
  }
}

class ActionButtonsComponent extends PositionComponent
    with HasGameReference<DashboardGame> {
  late HudButtonComponent startGameButton;
  late HudButtonComponent profileButton;
  late HudButtonComponent settingsButton;
  late HudButtonComponent achievementsButton;
  late HudButtonComponent notifyButton;
  late HudButtonComponent logoutButton;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final isLandscape = game.size.x > game.size.y;
    
    if (isLandscape) {
      // Landscape layout: 3x2 grid
      size = Vector2(game.size.x * 0.9, game.size.y * 0.6);
      position = Vector2(
        game.size.x * 0.05,
        game.size.y * 0.2,
      );
    } else {
      // Portrait layout: 3x2 grid
      size = Vector2(game.size.x * 0.8, game.size.y * 0.7);
      position = Vector2(
        game.size.x * 0.1,
        game.size.y * 0.15,
      );
    }

    final buttonSize = Vector2(size.x * 0.3, size.y * 0.4);

    startGameButton = HudButtonComponent(
      text: 'START\nBATTLE',
      color: Colors.red,
      size: buttonSize,
      onPressed: () => game.viewModel.navigateToGame(),
    );
    startGameButton.position = Vector2(0, 0);
    add(startGameButton);

    profileButton = HudButtonComponent(
      text: 'PROFILE',
      color: Colors.blue,
      size: buttonSize,
      onPressed: () => game.viewModel.navigateToProfile(),
    );
    profileButton.position = Vector2(size.x * 0.35, 0);
    add(profileButton);

    settingsButton = HudButtonComponent(
      text: 'SETTINGS',
      color: Colors.green,
      size: buttonSize,
      onPressed: () => game.viewModel.navigateToSettings(),
    );
    settingsButton.position = Vector2(size.x * 0.7, 0);
    add(settingsButton);

    notifyButton = HudButtonComponent(
      text: 'NOTIFY',
      color: Colors.orange,
      size: buttonSize,
      onPressed: () => game.viewModel.showGameEndNotification(),
    );
    notifyButton.position = Vector2(0, size.y * 0.5);
    add(notifyButton);

    achievementsButton = HudButtonComponent(
      text: 'ACHIEVEMENTS',
      color: Colors.orange,
      size: buttonSize,
      onPressed: () => game.viewModel.navigateToAchievements(),
    );
    achievementsButton.position = Vector2(size.x * 0.35, size.y * 0.5);
    add(achievementsButton);

    logoutButton = HudButtonComponent(
      text: 'LOGOUT',
      color: Colors.red,
      size: buttonSize,
      onPressed: () => game.viewModel.logout(),
    );
    logoutButton.position = Vector2(size.x * 0.7, size.y * 0.5);
    add(logoutButton);
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
      ..color = Colors.white.withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(15)),
      borderPaint,
    );

    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w900,
          color: Colors.white,
          shadows: [
            Shadow(
              color: Colors.black,
              blurRadius: 3,
              offset: Offset(2, 2),
            ),
          ],
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        (size.x - textPainter.width) / 2,
        (size.y - textPainter.height) / 2,
      ),
    );
  }
}

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Consumer<DashboardViewModel>(
          builder: (context, viewModel, child) {
            return GameWidget(
              game: DashboardGame(viewModel: viewModel),
            );
          },
        ),
      ),
    );
  }
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;

  ParticlePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final paint = Paint()
      ..color = Colors.purple.withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;

    for (final particle in particles) {
      if (particle.position.x >= 0 &&
          particle.position.x <= size.width &&
          particle.position.y >= 0 &&
          particle.position.y <= size.height) {
        canvas.drawCircle(
          Offset(particle.position.x, particle.position.y),
          3.0,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) => true;
}
