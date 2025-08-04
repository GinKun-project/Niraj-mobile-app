import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_clash_frontend/features/game/data/repository/game_repository_impl.dart';
import 'package:shadow_clash_frontend/features/game/domain/entity/game_state_entity.dart';
import 'package:shadow_clash_frontend/features/game/domain/entity/player_entity.dart';

void main() {
  group('GameRepositoryImpl Unit Tests', () {
    late GameRepositoryImpl gameRepository;

    setUp(() {
      gameRepository = GameRepositoryImpl();
    });

    test('should initialize game with correct player stats', () async {
      final gameState = await gameRepository.initializeGame();

      expect(gameState.player.name, equals('Player'));
      expect(gameState.player.maxHp, equals(1200));
      expect(gameState.player.currentHp, equals(1200));
      expect(gameState.player.attack, equals(140));
      expect(gameState.player.defense, equals(90));
    });

    test('should initialize game with correct enemy stats', () async {
      final gameState = await gameRepository.initializeGame();

      expect(gameState.ai.name, equals('ENEMY'));
      expect(gameState.ai.maxHp, equals(1200));
      expect(gameState.ai.currentHp, equals(1200));
      expect(gameState.ai.attack, equals(160));
      expect(gameState.ai.defense, equals(100));
    });

    test('should initialize game with correct game state', () async {
      final gameState = await gameRepository.initializeGame();

      expect(gameState.timeRemaining, equals(180));
      expect(gameState.status, equals(GameStatus.playing));
      expect(gameState.isPlayerTurn, isTrue);
    });

    test('should perform player attack and reduce enemy HP', () async {
      const initialState = GameStateEntity(
        player: PlayerEntity(
          name: 'Player',
          maxHp: 1200,
          currentHp: 1200,
          attack: 140,
          defense: 90,
          criticalChance: 0.18,
          dodgeChance: 0.12,
          positionX: 0,
          positionY: 2,
        ),
        ai: PlayerEntity(
          name: 'ENEMY',
          maxHp: 1200,
          currentHp: 1200,
          attack: 160,
          defense: 100,
          criticalChance: 0.22,
          dodgeChance: 0.15,
          positionX: 3,
          positionY: 2,
        ),
        timeRemaining: 180,
        status: GameStatus.playing,
        isPlayerTurn: true,
      );

      final result = await gameRepository.playerAttack(initialState);

      expect(result.ai.currentHp, lessThan(initialState.ai.currentHp));
      expect(result.isPlayerTurn, isFalse);
      expect(result.lastAction, isNotEmpty);
    });

    test('should perform player skill with higher damage', () async {
      const initialState = GameStateEntity(
        player: PlayerEntity(
          name: 'Player',
          maxHp: 1200,
          currentHp: 1200,
          attack: 140,
          defense: 90,
          criticalChance: 0.18,
          dodgeChance: 0.12,
          positionX: 0,
          positionY: 2,
        ),
        ai: PlayerEntity(
          name: 'ENEMY',
          maxHp: 1200,
          currentHp: 1200,
          attack: 160,
          defense: 100,
          criticalChance: 0.22,
          dodgeChance: 0.15,
          positionX: 3,
          positionY: 2,
        ),
        timeRemaining: 180,
        status: GameStatus.playing,
        isPlayerTurn: true,
      );

      final result = await gameRepository.playerSkill(initialState);

      expect(result.ai.currentHp, lessThan(initialState.ai.currentHp));
      expect(result.isPlayerTurn, isFalse);
      expect(result.lastAction, contains('SKILL'));
    });

    test('should handle enemy dodge during player attack', () async {
      const initialState = GameStateEntity(
        player: PlayerEntity(
          name: 'Player',
          maxHp: 1200,
          currentHp: 1200,
          attack: 140,
          defense: 90,
          criticalChance: 0.18,
          dodgeChance: 0.12,
          positionX: 0,
          positionY: 2,
        ),
        ai: PlayerEntity(
          name: 'ENEMY',
          maxHp: 1200,
          currentHp: 1200,
          attack: 160,
          defense: 100,
          criticalChance: 0.22,
          dodgeChance: 1.0, // 100% dodge chance
          positionX: 3,
          positionY: 2,
        ),
        timeRemaining: 180,
        status: GameStatus.playing,
        isPlayerTurn: true,
      );

      final result = await gameRepository.playerAttack(initialState);

      expect(result.ai.currentHp, equals(initialState.ai.currentHp));
      expect(result.lastAction, equals('Enemy dodged!'));
    });

    test('should perform AI turn and reduce player HP', () async {
      const initialState = GameStateEntity(
        player: PlayerEntity(
          name: 'Player',
          maxHp: 1200,
          currentHp: 1200,
          attack: 140,
          defense: 90,
          criticalChance: 0.18,
          dodgeChance: 0.12,
          positionX: 0,
          positionY: 2,
        ),
        ai: PlayerEntity(
          name: 'ENEMY',
          maxHp: 1200,
          currentHp: 1200,
          attack: 160,
          defense: 100,
          criticalChance: 0.22,
          dodgeChance: 0.15,
          positionX: 3,
          positionY: 2,
        ),
        timeRemaining: 180,
        status: GameStatus.playing,
        isPlayerTurn: false,
      );

      final result = await gameRepository.aiTurn(initialState);

      expect(result.player.currentHp, lessThan(initialState.player.currentHp));
      expect(result.isPlayerTurn, isTrue);
      expect(result.lastAction, isNotEmpty);
    });

    test('should handle player dodge during AI turn', () async {
      const initialState = GameStateEntity(
        player: PlayerEntity(
          name: 'Player',
          maxHp: 1200,
          currentHp: 1200,
          attack: 140,
          defense: 90,
          criticalChance: 0.18,
          dodgeChance: 1.0, // 100% dodge chance
          positionX: 0,
          positionY: 2,
        ),
        ai: PlayerEntity(
          name: 'ENEMY',
          maxHp: 1200,
          currentHp: 1200,
          attack: 160,
          defense: 100,
          criticalChance: 0.22,
          dodgeChance: 0.15,
          positionX: 3,
          positionY: 2,
        ),
        timeRemaining: 180,
        status: GameStatus.playing,
        isPlayerTurn: false,
      );

      final result = await gameRepository.aiTurn(initialState);

      expect(result.player.currentHp, equals(initialState.player.currentHp));
      expect(result.lastAction, equals('Player dodged!'));
    });

    test('should update timer correctly', () async {
      const initialState = GameStateEntity(
        player: PlayerEntity(
          name: 'Player',
          maxHp: 1200,
          currentHp: 1200,
          attack: 140,
          defense: 90,
          criticalChance: 0.18,
          dodgeChance: 0.12,
          positionX: 0,
          positionY: 2,
        ),
        ai: PlayerEntity(
          name: 'ENEMY',
          maxHp: 1200,
          currentHp: 1200,
          attack: 160,
          defense: 100,
          criticalChance: 0.22,
          dodgeChance: 0.15,
          positionX: 3,
          positionY: 2,
        ),
        timeRemaining: 180,
        status: GameStatus.playing,
        isPlayerTurn: true,
      );

      final result = await gameRepository.updateTimer(initialState);

      expect(result.timeRemaining, equals(179));
    });

    test('should determine game result when timer expires', () async {
      const initialState = GameStateEntity(
        player: PlayerEntity(
          name: 'Player',
          maxHp: 1200,
          currentHp: 800,
          attack: 140,
          defense: 90,
          criticalChance: 0.18,
          dodgeChance: 0.12,
          positionX: 0,
          positionY: 2,
        ),
        ai: PlayerEntity(
          name: 'ENEMY',
          maxHp: 1200,
          currentHp: 600,
          attack: 160,
          defense: 100,
          criticalChance: 0.22,
          dodgeChance: 0.15,
          positionX: 3,
          positionY: 2,
        ),
        timeRemaining: 0,
        status: GameStatus.playing,
        isPlayerTurn: true,
      );

      final result = await gameRepository.updateTimer(initialState);

      expect(result.status, equals(GameStatus.victory));
      expect(result.timeRemaining, equals(0));
    });
  });
}
