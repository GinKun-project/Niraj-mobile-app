import 'package:shadow_clash_frontend/features/game/domain/entity/game_state_entity.dart';

abstract class GameRepository {
  Future<GameStateEntity> initializeGame();
  Future<GameStateEntity> playerAttack(GameStateEntity currentState);
  Future<GameStateEntity> aiTurn(GameStateEntity currentState);
  Future<GameStateEntity> updateTimer(GameStateEntity currentState);
}
