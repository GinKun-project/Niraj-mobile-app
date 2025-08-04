import 'package:shadow_clash_frontend/features/dashboard/domain/repository/dashboard_repository.dart';

class UpdatePlayerStatsUseCase {
  final DashboardRepository repository;

  UpdatePlayerStatsUseCase(this.repository);

  Future<void> call({
    int? level,
    int? xp,
    int? wins,
  }) async {
    await repository.updatePlayerStats(
      level: level,
      xp: xp,
      wins: wins,
    );
  }
} 