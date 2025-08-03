import 'dart:math';
import 'package:shadow_clash_frontend/features/game/domain/entity/game_state_entity.dart';
import 'package:shadow_clash_frontend/features/game/domain/entity/player_entity.dart';
import 'package:shadow_clash_frontend/features/game/domain/repository/game_repository.dart';

class GameRepositoryImpl implements GameRepository {
  final Random _random = Random();

  @override
  Future<GameStateEntity> initializeGame() async {
    final player = PlayerEntity(
      name: 'Player',
      maxHp: 1200,
      currentHp: 1200,
      attack: 140,
      defense: 90,
      criticalChance: 0.18,
      dodgeChance: 0.12,
      positionX: 0,
      positionY: 2,
    );

    final ai = PlayerEntity(
      name: 'ENEMY',
      maxHp: 1200,
      currentHp: 1200,
      attack: 160,
      defense: 100,
      criticalChance: 0.22,
      dodgeChance: 0.15,
      positionX: 3,
      positionY: 2,
    );

    return GameStateEntity(
      player: player,
      ai: ai,
      timeRemaining: 180,
      status: GameStatus.playing,
      isPlayerTurn: true,
    );
  }

  @override
  Future<GameStateEntity> playerAttack(GameStateEntity currentState) async {
    if (!currentState.player.isAlive || !currentState.ai.isAlive) {
      return currentState;
    }

    final ai = currentState.ai;
    if (_random.nextDouble() < ai.dodgeChance) {
      return currentState.copyWith(
        lastAction: 'Enemy dodged!',
        isPlayerTurn: false,
        damagePopups: [
          ...currentState.damagePopups,
          DamagePopup(text: 'DODGE!', timestamp: DateTime.now()),
        ],
      );
    }

    final isCritical =
        _random.nextDouble() < currentState.player.criticalChance;
    final damage = isCritical
        ? (currentState.player.attack * 2.0 - ai.defense * 0.4).round()
        : (currentState.player.attack - ai.defense * 0.3).round();

    final finalDamage = damage.clamp(1, damage);
    final newAiHp = (ai.currentHp - finalDamage).clamp(0, ai.maxHp);
    final newAi = ai.copyWith(currentHp: newAiHp);

    final action = isCritical ? '-${finalDamage} CRIT!' : '-$finalDamage';
    final status = newAiHp <= 0 ? GameStatus.victory : GameStatus.playing;

    return currentState.copyWith(
      ai: newAi,
      lastAction: action,
      status: status,
      isPlayerTurn: false,
      damagePopups: [
        ...currentState.damagePopups,
        DamagePopup(
          text: action,
          isCritical: isCritical,
          timestamp: DateTime.now(),
        ),
      ],
    );
  }

  @override
  Future<GameStateEntity> aiTurn(GameStateEntity currentState) async {
    if (!currentState.player.isAlive || !currentState.ai.isAlive) {
      return currentState;
    }

    await Future.delayed(const Duration(milliseconds: 1000));

    final player = currentState.player;
    if (_random.nextDouble() < player.dodgeChance) {
      return currentState.copyWith(
        lastAction: 'Player dodged!',
        isPlayerTurn: true,
        damagePopups: [
          ...currentState.damagePopups,
          DamagePopup(text: 'DODGE!', timestamp: DateTime.now()),
        ],
      );
    }

    final isCritical = _random.nextDouble() < currentState.ai.criticalChance;
    final damage = isCritical
        ? (currentState.ai.attack * 2.0 - player.defense * 0.4).round()
        : (currentState.ai.attack - player.defense * 0.3).round();

    final finalDamage = damage.clamp(1, damage);
    final newPlayerHp = (player.currentHp - finalDamage).clamp(0, player.maxHp);
    final newPlayer = player.copyWith(currentHp: newPlayerHp);

    final action = isCritical ? '-${finalDamage} CRIT!' : '-$finalDamage';
    final status = newPlayerHp <= 0 ? GameStatus.defeat : GameStatus.playing;

    return currentState.copyWith(
      player: newPlayer,
      lastAction: action,
      status: status,
      isPlayerTurn: true,
      damagePopups: [
        ...currentState.damagePopups,
        DamagePopup(
          text: action,
          isCritical: isCritical,
          timestamp: DateTime.now(),
        ),
      ],
    );
  }

  @override
  Future<GameStateEntity> updateTimer(GameStateEntity currentState) async {
    if (currentState.timeRemaining <= 0) {
      final playerHp = currentState.player.currentHp;
      final aiHp = currentState.ai.currentHp;

      GameStatus status;
      if (playerHp > aiHp) {
        status = GameStatus.victory;
      } else if (aiHp > playerHp) {
        status = GameStatus.defeat;
      } else {
        status = GameStatus.draw;
      }

      return currentState.copyWith(timeRemaining: 0, status: status);
    }

    return currentState.copyWith(timeRemaining: currentState.timeRemaining - 1);
  }
}
