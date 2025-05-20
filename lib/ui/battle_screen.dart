import 'dart:async' as dart_async;
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart'; // Important: for mixins
import 'package:flutter/material.dart';

// Extension to clamp Vector2 within bounds.
extension Vector2Clamp on Vector2 {
  Vector2 clampVector(Vector2 min, Vector2 max) =>
      Vector2(x.clamp(min.x, max.x), y.clamp(min.y, max.y));
}

// Main Battle Game class
class BattleGame extends FlameGame
    with HasTappableComponents, HasDraggableComponents, HasJoystickComponents {
  final String character;

  // Animations
  late SpriteAnimation _playerIdleAnim;
  late SpriteAnimation _playerWalkAnim;
  late SpriteAnimation _playerAttackAnim;
  late SpriteAnimation _playerBlockAnim;

  late SpriteAnimation _aiIdleAnim;
  late SpriteAnimation _aiWalkAnim;
  late SpriteAnimation _aiAttackAnim;
  late SpriteAnimation _aiBlockAnim;

  // Components
  late SpriteAnimationComponent _player;
  late SpriteAnimationComponent _ai;

  late JoystickComponent joystick;

  // Positions and constants
  Vector2 playerPos = Vector2(150, 300);
  Vector2 aiPos = Vector2(450, 300);
  static const double speed = 180;

  // Stats
  double playerHealth = 100;
  double playerEnergy = 0;

  double aiHealth = 100;
  double aiEnergy = 0;

  // States
  bool _isPlayerAttacking = false;
  bool _isPlayerBlocking = false;
  bool _isAiAttacking = false;
  bool _isAiBlocking = false;

  // Jumping physics
  bool _playerJumping = false;
  double _jumpVelocity = 0;
  static const double gravity = 900;
  static const double groundY = 300;
  static const double jumpStartVelocity = 450;
  static const double attackRange = 100;

  BattleGame(this.character);

  bool get isPlayerAttacking => _isPlayerAttacking;
  bool get isPlayerBlocking => _isPlayerBlocking;

  @override
  Future<void> onLoad() async {
    // Initialize joystick component
    joystick = JoystickComponent(
      knob: CircleComponent(
        radius: 30,
        paint: Paint()..color = Colors.black.withOpacity(0.7),
      ),
      background: CircleComponent(
        radius: 60,
        paint: Paint()..color = Colors.grey.withOpacity(0.5),
      ),
      margin: const EdgeInsets.only(left: 40, bottom: 40),
    );
    add(joystick);

    // Load sprite sheet and animations
    final spriteSheet = await images.load('images/Fumiko.png');
    final frameSize = Vector2(64, 64);

    _playerIdleAnim = SpriteAnimation.fromFrameData(
      spriteSheet,
      SpriteAnimationData.sequenced(
        amount: 4,
        textureSize: frameSize,
        stepTime: 0.15,
        loop: true,
      ),
    );
    _playerWalkAnim = SpriteAnimation.fromFrameData(
      spriteSheet,
      SpriteAnimationData.sequenced(
        amount: 6,
        textureSize: frameSize,
        stepTime: 0.1,
        loop: true,
      ),
    );
    _playerAttackAnim = SpriteAnimation.fromFrameData(
      spriteSheet,
      SpriteAnimationData.sequenced(
        amount: 5,
        textureSize: frameSize,
        stepTime: 0.1,
        loop: false,
      ),
    );
    _playerBlockAnim = _playerIdleAnim;

    _player = SpriteAnimationComponent(
      animation: _playerIdleAnim,
      position: playerPos.clone(),
      size: Vector2.all(96),
      anchor: Anchor.center,
    );
    add(_player);

    // AI animations reuse player animations for simplicity
    _aiIdleAnim = _playerIdleAnim;
    _aiWalkAnim = _playerWalkAnim;
    _aiAttackAnim = _playerAttackAnim;
    _aiBlockAnim = _playerBlockAnim;

    _ai = SpriteAnimationComponent(
      animation: _aiIdleAnim,
      position: aiPos.clone(),
      size: Vector2.all(96),
      anchor: Anchor.center,
    );
    add(_ai);
  }

  @override
  void update(double dt) {
    super.update(dt);

    _handleJumpPhysics(dt);

    // Joystick controls player movement
    final delta = joystick.relativeDelta;
    if (delta.x < -0.1) {
      moveLeft(dt);
    } else if (delta.x > 0.1) {
      moveRight(dt);
    } else {
      stopMoving();
    }

    if (delta.y < -0.5 && !_playerJumping) {
      jump();
    }

    _player.position = playerPos.clone();
    _ai.position = aiPos.clone();

    playerPos = playerPos.clampVector(
      Vector2(50, groundY),
      Vector2(size.x - 50, groundY),
    );
    aiPos = aiPos.clampVector(
      Vector2(50, groundY),
      Vector2(size.x - 50, groundY),
    );

    if (!_isPlayerAttacking && !_playerJumping && !_isPlayerBlocking) {
      _player.animation = _playerIdleAnim;
    }
    if (!_isAiAttacking && !_isAiBlocking) {
      _ai.animation = _aiIdleAnim;
    }
  }

  void _handleJumpPhysics(double dt) {
    if (!_playerJumping) return;

    _jumpVelocity -= gravity * dt;
    playerPos.y -= _jumpVelocity * dt;

    if (playerPos.y >= groundY) {
      playerPos.y = groundY;
      _playerJumping = false;
      _jumpVelocity = 0;
    }
  }

  void moveLeft(double dt) {
    if (_canMove()) {
      playerPos.x -= speed * dt;
      _player.animation = _playerWalkAnim;
    }
  }

  void moveRight(double dt) {
    if (_canMove()) {
      playerPos.x += speed * dt;
      _player.animation = _playerWalkAnim;
    }
  }

  void stopMoving() {
    if (_canMove()) {
      _player.animation = _playerIdleAnim;
    }
  }

  void jump() {
    if (!_playerJumping) {
      _playerJumping = true;
      _jumpVelocity = jumpStartVelocity;
    }
  }

  void attack() {
    if (_isPlayerAttacking || playerEnergy < 10) return;

    _isPlayerAttacking = true;
    playerEnergy -= 10;
    _player.animation = _playerAttackAnim;

    final durationMs =
        (_playerAttackAnim.frames.length *
                _playerAttackAnim.frames[0].stepTime *
                1000)
            .toInt();

    Future.delayed(Duration(milliseconds: durationMs), () {
      _isPlayerAttacking = false;
      if (!_playerJumping && !_isPlayerBlocking) {
        _player.animation = _playerIdleAnim;
      }
    });

    if ((aiPos - playerPos).length < attackRange && !_isAiBlocking) {
      aiHealth -= 15;
    }
  }

  void block(bool start) {
    _isPlayerBlocking = start;
    _player.animation = start ? _playerBlockAnim : _playerIdleAnim;
  }

  void transform() {
    if (playerEnergy >= 100) {
      playerEnergy = 0;
      playerHealth = (playerHealth + 25).clamp(0, 100);
    }
  }

  void gainEnergy() {
    playerEnergy = (playerEnergy + 15).clamp(0, 100);
  }

  void simulateAIAction() {
    if (_isAiAttacking) return;

    if (aiHealth < 20 && aiEnergy >= 50) {
      aiEnergy -= 50;
      aiHealth = (aiHealth + 30).clamp(0, 100);
      return;
    }

    if (aiEnergy >= 30 && (playerPos - aiPos).length < attackRange) {
      _aiAttack();
    } else if (aiEnergy >= 10 && (playerPos - aiPos).length >= attackRange) {
      _aiMoveTowardPlayer(0.016);
    } else {
      _aiIdle();
    }
  }

  void _aiAttack() {
    _isAiAttacking = true;
    aiEnergy -= 30;
    _ai.animation = _aiAttackAnim;

    final durationMs =
        (_aiAttackAnim.frames.length * _aiAttackAnim.frames[0].stepTime * 1000)
            .toInt();

    Future.delayed(Duration(milliseconds: durationMs), () {
      _isAiAttacking = false;
      _ai.animation = _aiIdleAnim;
    });

    if ((playerPos - aiPos).length < attackRange && !_isPlayerBlocking) {
      playerHealth -= 20;
    }
  }

  void _aiMoveTowardPlayer(double dt) {
    _ai.animation = _aiWalkAnim;
    aiPos.x += playerPos.x < aiPos.x ? -speed * dt : speed * dt;
  }

  void _aiIdle() {
    _ai.animation = _aiIdleAnim;
    aiEnergy = (aiEnergy + 10 * 0.016).clamp(0, 100);
  }

  bool _canMove() =>
      !_isPlayerAttacking && !_playerJumping && !_isPlayerBlocking;
}

class BattleScreen extends StatefulWidget {
  final String character;

  const BattleScreen({super.key, required this.character});

  @override
  State<BattleScreen> createState() => _BattleScreenState();
}

class _BattleScreenState extends State<BattleScreen> {
  late BattleGame _game;
  dart_async.Timer? _aiTimer;
  dart_async.Timer? _movementTimer;

  bool _moveLeft = false;
  bool _moveRight = false;

  bool _gameEnded = false;
  String _resultMessage = '';

  @override
  void initState() {
    super.initState();
    _game = BattleGame(widget.character);
    _startAITimer();
    _startMovementTimer();
  }

  void _startAITimer() {
    _aiTimer = dart_async.Timer.periodic(const Duration(milliseconds: 100), (
      _,
    ) {
      if (!_gameEnded) {
        setState(() {
          _game.simulateAIAction();
          _checkGameEnd();
        });
      }
    });
  }

  void _startMovementTimer() {
    _movementTimer = dart_async.Timer.periodic(
      const Duration(milliseconds: 16),
      (_) {
        if (!_gameEnded) {
          setState(() {
            if (_moveLeft) {
              _game.moveLeft(0.016);
            } else if (_moveRight) {
              _game.moveRight(0.016);
            } else {
              _game.stopMoving();
            }
          });
        }
      },
    );
  }

  void _checkGameEnd() {
    if (_game.playerHealth <= 0) {
      _gameEnded = true;
      _resultMessage = 'You Lost!';
      _showResultDialog(_resultMessage);
    } else if (_game.aiHealth <= 0) {
      _gameEnded = true;
      _resultMessage = 'You Won!';
      _showResultDialog(_resultMessage);
    }
  }

  void _showResultDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => AlertDialog(
            title: Text(
              message,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context)
                    ..pop()
                    ..pop();
                },
                child: const Text('Back to Menu'),
              ),
            ],
          ),
    );
  }

  @override
  void dispose() {
    _aiTimer?.cancel();
    _movementTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !_gameEnded,
      child: Scaffold(
        backgroundColor: const Color(0xFF2E1A1A),
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              _buildHealthBars(),
              Expanded(child: GameWidget(game: _game)),
              _buildControlPanel(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHealthBars() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: _buildStatusBar('Player', _game.playerHealth, Colors.green),
          ),
          const SizedBox(width: 20),
          Expanded(child: _buildStatusBar('AI', _game.aiHealth, Colors.red)),
        ],
      ),
    );
  }

  Widget _buildStatusBar(String label, double value, Color color) {
    return Column(
      children: [
        Text(
          '$label: ${value.toInt()}%',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          height: 20,
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

  Widget _buildControlPanel() {
    return Container(
      color: Colors.black54,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _ControlButton(
                    icon: Icons.arrow_left,
                    onPressedDown: () {
                      _moveLeft = true;
                    },
                    onPressedUp: () {
                      _moveLeft = false;
                      _game.stopMoving();
                    },
                  ),
                  const SizedBox(width: 10),
                  _ControlButton(
                    icon: Icons.arrow_right,
                    onPressedDown: () {
                      _moveRight = true;
                    },
                    onPressedUp: () {
                      _moveRight = false;
                      _game.stopMoving();
                    },
                  ),
                  const SizedBox(width: 20),
                  _ControlButton(
                    icon: Icons.arrow_upward,
                    onPressedDown: () {
                      _game.jump();
                    },
                    onPressedUp: () {},
                  ),
                ],
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (!_game.isPlayerAttacking) {
                        setState(() {
                          _game.attack();
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB35D32),
                    ),
                    child: const Text('Attack'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _game.block(!_game.isPlayerBlocking);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey,
                    ),
                    child: const Text('Block'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _game.transform();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                    ),
                    child: const Text('Morph'),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressedDown;
  final VoidCallback onPressedUp;

  const _ControlButton({
    required this.icon,
    required this.onPressedDown,
    required this.onPressedUp,
  });

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => onPressedDown(),
      onPointerUp: (_) => onPressedUp(),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[700]!,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Icon(icon, color: Colors.white, size: 32),
      ),
    );
  }
}
