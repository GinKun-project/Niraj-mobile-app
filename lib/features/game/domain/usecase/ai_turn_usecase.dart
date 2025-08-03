import 'package:shadow_clash_frontend/features/game/domain/entity/game_state_entity.dart';
import 'package:shadow_clash_frontend/features/game/domain/repository/game_repository.dart';

class AiTurnUseCase {
  final GameRepository repository;

  AiTurnUseCase(this.repository);

  Future<GameStateEntity> execute(GameStateEntity currentState) async {
    return await repository.aiTurn(currentState);
  }
}
