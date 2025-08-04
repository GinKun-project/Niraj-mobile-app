import 'package:shadow_clash_frontend/features/dashboard/data/datasource/dashboard_local_datasource.dart';
import 'package:shadow_clash_frontend/features/dashboard/data/datasource/dashboard_remote_datasource.dart';
import 'package:shadow_clash_frontend/features/dashboard/data/model/dashboard_model.dart';
import 'package:shadow_clash_frontend/features/dashboard/domain/entity/dashboard_entity.dart';
import 'package:shadow_clash_frontend/features/dashboard/domain/repository/dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardLocalDataSource _localDataSource;
  final DashboardRemoteDataSource _remoteDataSource;

  DashboardRepositoryImpl({
    required DashboardLocalDataSource localDataSource,
    required DashboardRemoteDataSource remoteDataSource,
  })  : _localDataSource = localDataSource,
        _remoteDataSource = remoteDataSource;

  @override
  Future<DashboardEntity> getDashboardData() async {
    try {
      final remoteData = await _remoteDataSource.getDashboardData();
      await _localDataSource.saveDashboardData(remoteData);
      return remoteData;
    } catch (e) {
      return await _localDataSource.getDashboardData();
    }
  }

  @override
  Future<void> updatePlayerStats({
    int? level,
    int? xp,
    int? wins,
  }) async {
    try {
      await _remoteDataSource.updatePlayerStats(
        level: level,
        xp: xp,
        wins: wins,
      );
    } catch (e) {
      print('Remote update failed, using local only: $e');
    }

    final currentData = await _localDataSource.getDashboardData();
    final updatedData = DashboardModel(
      playerName: currentData.playerName,
      playerLevel: level ?? currentData.playerLevel,
      playerXp: xp ?? currentData.playerXp,
      playerWins: wins ?? currentData.playerWins,
      showNotification: currentData.showNotification,
    );

    await _localDataSource.saveDashboardData(updatedData);
  }

  @override
  Future<void> showGameEndNotification() async {
    try {
      await _remoteDataSource.saveGameResult(
        result: 'victory',
        playerHp: 1200,
        enemyHp: 0,
        duration: 180,
      );
    } catch (e) {
      print('Error saving game result: $e');
    }
  }
}
