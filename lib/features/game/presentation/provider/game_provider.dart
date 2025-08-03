import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_clash_frontend/features/game/data/repository/game_repository_impl.dart';
import 'package:shadow_clash_frontend/features/game/domain/entity/game_state_entity.dart';
import 'package:shadow_clash_frontend/features/game/domain/entity/player_entity.dart';
import 'package:shadow_clash_frontend/features/game/domain/usecase/ai_turn_usecase.dart';
import 'package:shadow_clash_frontend/features/game/domain/usecase/initialize_game_usecase.dart';
import 'package:shadow_clash_frontend/features/game/domain/usecase/player_attack_usecase.dart';

final gameProvider = StateNotifierProvider<GameNotifier, GameStateEntity>((
  ref,
) {
  return GameNotifier(
    ref.read(initializeGameUseCaseProvider),
    ref.read(playerAttackUseCaseProvider),
    ref.read(aiTurnUseCaseProvider),
  );
});

final initializeGameUseCaseProvider = Provider<InitializeGameUseCase>((ref) {
  return InitializeGameUseCase(ref.read(gameRepositoryProvider));
});

final playerAttackUseCaseProvider = Provider<PlayerAttackUseCase>((ref) {
  return PlayerAttackUseCase(ref.read(gameRepositoryProvider));
});

final aiTurnUseCaseProvider = Provider<AiTurnUseCase>((ref) {
  return AiTurnUseCase(ref.read(gameRepositoryProvider));
});

final gameRepositoryProvider = Provider((ref) {
  return GameRepositoryImpl();
});

class GameNotifier extends StateNotifier<GameStateEntity> {
  final InitializeGameUseCase _initializeGameUseCase;
  final PlayerAttackUseCase _playerAttackUseCase;
  final AiTurnUseCase _aiTurnUseCase;
  Timer? _timer;
  Timer? _popupTimer;

  GameNotifier(
    this._initializeGameUseCase,
    this._playerAttackUseCase,
    this._aiTurnUseCase,
  ) : super(
        GameStateEntity(
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
        ),
      );

  Future<void> startGame() async {
    final gameState = await _initializeGameUseCase.execute();
    state = gameState;
    _startTimer();
    _startPopupTimer();
  }

  Future<void> playerAttack() async {
    if (state.status != GameStatus.playing || !state.isPlayerTurn) return;

    final newState = await _playerAttackUseCase.execute(state);
    state = newState;

    if (newState.status == GameStatus.playing && !newState.isPlayerTurn) {
      _aiTurn();
    }
  }

  Future<void> _aiTurn() async {
    final newState = await _aiTurnUseCase.execute(state);
    state = newState;
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.timeRemaining <= 0 || state.status != GameStatus.playing) {
        timer.cancel();
        return;
      }
      state = state.copyWith(timeRemaining: state.timeRemaining - 1);

      if (state.timeRemaining <= 0) {
        final playerHp = state.player.currentHp;
        final aiHp = state.ai.currentHp;

        GameStatus status;
        if (playerHp > aiHp) {
          status = GameStatus.victory;
        } else if (aiHp > playerHp) {
          status = GameStatus.defeat;
        } else {
          status = GameStatus.draw;
        }

        state = state.copyWith(status: status);
      }
    });
  }

  void _startPopupTimer() {
    _popupTimer?.cancel();
    _popupTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      final now = DateTime.now();
      final validPopups = state.damagePopups
          .where((popup) => now.difference(popup.timestamp).inSeconds < 2)
          .toList();

      if (validPopups.length != state.damagePopups.length) {
        state = state.copyWith(damagePopups: validPopups);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _popupTimer?.cancel();
    super.dispose();
  }
}
