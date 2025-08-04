import 'package:shadow_clash_frontend/features/dashboard/domain/entity/dashboard_entity.dart';

abstract class DashboardRepository {
  Future<DashboardEntity> getDashboardData();
  Future<void> updatePlayerStats({
    int? level,
    int? xp,
    int? wins,
  });
  Future<void> showGameEndNotification();
}
