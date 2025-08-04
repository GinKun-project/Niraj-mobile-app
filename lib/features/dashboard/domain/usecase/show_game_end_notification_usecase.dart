import 'package:shadow_clash_frontend/features/dashboard/domain/repository/dashboard_repository.dart';

class ShowGameEndNotificationUseCase {
  final DashboardRepository repository;

  ShowGameEndNotificationUseCase(this.repository);

  Future<void> call() async {
    await repository.showGameEndNotification();
  }
} 