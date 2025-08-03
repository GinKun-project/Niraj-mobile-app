import 'package:shadow_clash_frontend/features/game/domain/entity/game_state_entity.dart';
import 'package:shadow_clash_frontend/features/game/domain/repository/game_repository.dart';

class PlayerAttackUseCase {
  final GameRepository repository;

  PlayerAttackUseCase(this.repository);

  Future<GameStateEntity> execute(GameStateEntity currentState) async {
    return await repository.playerAttack(currentState);
  }
}
