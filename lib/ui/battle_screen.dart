import 'dart:async'; // ✅ Required for Timer
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class BattleGame extends FlameGame {
  late SpriteAnimation _idleAnimation;
  late SpriteAnimation _walkingAnimation;
  late SpriteAnimation _punchingAnimation;
  late SpriteAnimationComponent _character;

  // Player and AI stats
  double playerHealth = 100.0;
  double playerEnergy = 50.0;
  double aiHealth = 100.0;
  double aiEnergy = 50.0;
  String aiState = "idle";

  double playerX = 200;
  double playerY = 200;

  @override
  Future<void> onLoad() async {
    final spriteSheet = await images.load('character_spritesheet.png');

    _idleAnimation = SpriteAnimation.fromFrameData(
      spriteSheet,
      SpriteAnimationData.sequenced(
        amount: 4,
        textureSize: Vector2(64, 64),
        stepTime: 0.1,
        loop: true,
      ),
    );

    _walkingAnimation = SpriteAnimation.fromFrameData(
      spriteSheet,
      SpriteAnimationData.sequenced(
        amount: 6,
        textureSize: Vector2(64, 64),
        stepTime: 0.1,
        loop: true,
      ),
    );

    _punchingAnimation = SpriteAnimation.fromFrameData(
      spriteSheet,
      SpriteAnimationData.sequenced(
        amount: 5,
        textureSize: Vector2(64, 64),
        stepTime: 0.1,
        loop: false,
      ),
    );

    _character = SpriteAnimationComponent(
      animation: _idleAnimation,
      position: Vector2(playerX, playerY),
      size: Vector2(64, 64),
    );

    add(_character);
  }

  void attack() {
    _character.animation = _punchingAnimation;
    aiHealth -= 10;
    print('Player attacks!');
  }

  void transform() {
    if (playerEnergy >= 100) {
      playerEnergy = 0;
      print('Player transformed!');
    } else {
      print('Not enough energy.');
    }
  }

  void gainEnergy() {
    playerEnergy = (playerEnergy + 10).clamp(0, 100);
  }

  void simulateAIAction() {
    if (aiEnergy >= 30 && aiHealth > 20) {
      aiState = "attack";
      aiAttack();
    } else if (aiEnergy >= 10) {
      aiState = "block";
      aiBlock();
    } else {
      aiState = "dodge";
      aiDodge();
    }
  }

  void aiAttack() {
    aiEnergy -= 10;
    playerHealth -= 15;
    print("AI attacks!");
  }

  void aiBlock() {
    aiEnergy -= 5;
    print("AI blocks!");
  }

  void aiDodge() {
    aiEnergy -= 15;
    print("AI dodges!");
  }
}

class BattleScreen extends StatefulWidget {
  final String character;

  const BattleScreen({super.key, required this.character});

  @override
  State<BattleScreen> createState() => _BattleScreenState();
}

class _BattleScreenState extends State<BattleScreen> {
  late BattleGame _game;
  Timer? _aiTimer; // ✅ Null-safe Timer

  @override
  void initState() {
    super.initState();
    _game = BattleGame();
    _startAITimer();
  }

  void _startAITimer() {
    _aiTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      setState(() {
        _game.simulateAIAction();
      });
    });
  }

  @override
  void dispose() {
    _aiTimer?.cancel(); // ✅ Cancel safely with null check
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E1A1A),
      appBar: AppBar(
        title: Text('${widget.character} Battle'),
        backgroundColor: const Color(0xFFB35D32),
      ),
      body: Column(
        children: [
          Expanded(child: GameWidget(game: _game)),
          const SizedBox(height: 10),
          _buildStatusBar("Health", _game.playerHealth, Colors.green),
          const SizedBox(height: 10),
          _buildStatusBar("Energy", _game.playerEnergy, Colors.blue),
          const SizedBox(height: 20),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildStatusBar(String label, double value, Color color) {
    return Column(
      children: [
        Text(
          '$label: ${value.toInt()}%',
          style: const TextStyle(color: Colors.white),
        ),
        Container(
          width: 300,
          height: 20,
          margin: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(10),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: value / 100,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () => setState(_game.attack),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFB35D32),
          ),
          child: const Text('Attack'),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () => setState(_game.transform),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
          child: const Text('Transform'),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () => setState(_game.gainEnergy),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          child: const Text('Gain Energy'),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
