import 'package:shadow_clash_frontend/features/game/domain/entity/player_entity.dart';

enum GameStatus { playing, victory, defeat, draw }

class DamagePopup {
  final String text;
  final bool isCritical;
  final bool isHeal;
  final bool isForPlayer;
  final DateTime timestamp;

  const DamagePopup({
    required this.text,
    this.isCritical = false,
    this.isHeal = false,
    this.isForPlayer = false,
    required this.timestamp,
  });
}

class GameStateEntity {
  final PlayerEntity player;
  final PlayerEntity ai;
  final int timeRemaining;
  final GameStatus status;
  final String? lastAction;
  final bool isPlayerTurn;
  final List<DamagePopup> damagePopups;
  final bool showSensorAlert;

  const GameStateEntity({
    required this.player,
    required this.ai,
    required this.timeRemaining,
    required this.status,
    this.lastAction,
    required this.isPlayerTurn,
    this.damagePopups = const [],
    this.showSensorAlert = false,
  });

  GameStateEntity copyWith({
    PlayerEntity? player,
    PlayerEntity? ai,
    int? timeRemaining,
    GameStatus? status,
    String? lastAction,
    bool? isPlayerTurn,
    List<DamagePopup>? damagePopups,
    bool? showSensorAlert,
  }) {
    return GameStateEntity(
      player: player ?? this.player,
      ai: ai ?? this.ai,
      timeRemaining: timeRemaining ?? this.timeRemaining,
      status: status ?? this.status,
      lastAction: lastAction ?? this.lastAction,
      isPlayerTurn: isPlayerTurn ?? this.isPlayerTurn,
      damagePopups: damagePopups ?? this.damagePopups,
      showSensorAlert: showSensorAlert ?? this.showSensorAlert,
    );
  }
}
