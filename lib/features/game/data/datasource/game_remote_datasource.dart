import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shadow_clash_frontend/features/game/domain/entity/game_state_entity.dart';
import 'package:shadow_clash_frontend/features/game/domain/entity/player_entity.dart';

abstract class GameRemoteDataSource {
  Future<GameStateEntity> initializeGame();
  Future<GameStateEntity> playerAttack();
  Future<GameStateEntity> playerSkill();
  Future<GameStateEntity> aiTurn();
  Future<GameStateEntity> getGameState();
  Future<void> endGame(String result);
}

class GameRemoteDataSourceImpl implements GameRemoteDataSource {
  static const String baseUrl = 'http://localhost:3000/api';
  final String? authToken;

  GameRemoteDataSourceImpl({this.authToken});

  @override
  Future<GameStateEntity> initializeGame() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/game/initialize'),
        headers: {
          'Content-Type': 'application/json',
          if (authToken != null) 'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return _mapToGameStateEntity(data);
      } else {
        throw Exception('Failed to initialize game');
      }
    } catch (e) {
      return _getDefaultGameState();
    }
  }

  @override
  Future<GameStateEntity> playerAttack() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/game/attack'),
        headers: {
          'Content-Type': 'application/json',
          if (authToken != null) 'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return _mapToGameStateEntity(data);
      } else {
        throw Exception('Failed to process player attack');
      }
    } catch (e) {
      return _getDefaultGameState();
    }
  }

  @override
  Future<GameStateEntity> playerSkill() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/game/skill'),
        headers: {
          'Content-Type': 'application/json',
          if (authToken != null) 'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return _mapToGameStateEntity(data);
      } else {
        throw Exception('Failed to process player skill');
      }
    } catch (e) {
      return _getDefaultGameState();
    }
  }

  @override
  Future<GameStateEntity> aiTurn() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/game/ai-turn'),
        headers: {
          'Content-Type': 'application/json',
          if (authToken != null) 'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return _mapToGameStateEntity(data);
      } else {
        throw Exception('Failed to process AI turn');
      }
    } catch (e) {
      return _getDefaultGameState();
    }
  }

  @override
  Future<GameStateEntity> getGameState() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/game/state'),
        headers: {
          'Content-Type': 'application/json',
          if (authToken != null) 'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return _mapToGameStateEntity(data);
      } else {
        throw Exception('Failed to get game state');
      }
    } catch (e) {
      return _getDefaultGameState();
    }
  }

  @override
  Future<void> endGame(String result) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/game/end-game'),
        headers: {
          'Content-Type': 'application/json',
          if (authToken != null) 'Authorization': 'Bearer $authToken',
        },
        body: json.encode({'result': result}),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to end game');
      }
    } catch (e) {
      print('Error ending game: $e');
    }
  }

  GameStateEntity _mapToGameStateEntity(Map<String, dynamic> data) {
    return GameStateEntity(
      player: PlayerEntity(
        name: data['player']['name'] ?? 'Player',
        maxHp: data['player']['maxHp'] ?? 1200,
        currentHp: data['player']['currentHp'] ?? 1200,
        attack: data['player']['attack'] ?? 140,
        defense: data['player']['defense'] ?? 90,
        criticalChance: data['player']['criticalChance']?.toDouble() ?? 0.18,
        dodgeChance: data['player']['dodgeChance']?.toDouble() ?? 0.12,
      ),
      ai: PlayerEntity(
        name: data['ai']['name'] ?? 'ENEMY',
        maxHp: data['ai']['maxHp'] ?? 1200,
        currentHp: data['ai']['currentHp'] ?? 1200,
        attack: data['ai']['attack'] ?? 160,
        defense: data['ai']['defense'] ?? 100,
        criticalChance: data['ai']['criticalChance']?.toDouble() ?? 0.22,
        dodgeChance: data['ai']['dodgeChance']?.toDouble() ?? 0.15,
      ),
      timeRemaining: data['timeRemaining'] ?? 180,
      status: _mapGameStatus(data['status']),
      isPlayerTurn: data['isPlayerTurn'] ?? true,
      damagePopups: _mapDamagePopups(data['damagePopups'] ?? []),
    );
  }

  GameStatus _mapGameStatus(String status) {
    switch (status) {
      case 'playing':
        return GameStatus.playing;
      case 'victory':
        return GameStatus.victory;
      case 'defeat':
        return GameStatus.defeat;
      case 'draw':
        return GameStatus.draw;
      default:
        return GameStatus.playing;
    }
  }

  List<DamagePopup> _mapDamagePopups(List<dynamic> popups) {
    return popups
        .map((popup) => DamagePopup(
              text: popup['text'] ?? '',
              isCritical: popup['isCritical'] ?? false,
              isHeal: popup['isHeal'] ?? false,
              isForPlayer: popup['isForPlayer'] ?? false,
              timestamp: DateTime.parse(popup['timestamp']),
            ))
        .toList();
  }

  GameStateEntity _getDefaultGameState() {
    return const GameStateEntity(
      player: PlayerEntity(
        name: 'Player',
        maxHp: 1200,
        currentHp: 1200,
        attack: 140,
        defense: 90,
        criticalChance: 0.18,
        dodgeChance: 0.12,
      ),
      ai: PlayerEntity(
        name: 'ENEMY',
        maxHp: 1200,
        currentHp: 1200,
        attack: 160,
        defense: 100,
        criticalChance: 0.22,
        dodgeChance: 0.15,
      ),
      timeRemaining: 180,
      status: GameStatus.playing,
      isPlayerTurn: true,
    );
  }
}
