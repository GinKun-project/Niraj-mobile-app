import 'package:shadow_clash_frontend/features/game/domain/entity/game_state_entity.dart';
import 'package:shadow_clash_frontend/features/game/domain/repository/game_repository.dart';

class PlayerSkillUseCase {
  final GameRepository _gameRepository;

  PlayerSkillUseCase(this._gameRepository);

  Future<GameStateEntity> execute(GameStateEntity currentState) async {
    return await _gameRepository.playerSkill(currentState);
  }
} 