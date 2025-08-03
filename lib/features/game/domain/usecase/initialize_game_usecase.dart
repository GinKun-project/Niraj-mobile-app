import 'package:shadow_clash_frontend/features/game/domain/entity/game_state_entity.dart';
import 'package:shadow_clash_frontend/features/game/domain/repository/game_repository.dart';

class InitializeGameUseCase {
  final GameRepository repository;

  InitializeGameUseCase(this.repository);

  Future<GameStateEntity> execute() async {
    return await repository.initializeGame();
  }
}
