import 'package:shadow_clash_frontend/features/dashboard/domain/entity/dashboard_entity.dart';
import 'package:shadow_clash_frontend/features/dashboard/domain/repository/dashboard_repository.dart';

class GetDashboardDataUseCase {
  final DashboardRepository repository;

  GetDashboardDataUseCase(this.repository);

  Future<DashboardEntity> call() async {
    return await repository.getDashboardData();
  }
} 