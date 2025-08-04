import 'package:shadow_clash_frontend/features/dashboard/domain/entity/dashboard_entity.dart';

class DashboardModel extends DashboardEntity {
  const DashboardModel({
    required super.playerName,
    required super.playerLevel,
    required super.playerXp,
    required super.playerWins,
    required super.showNotification,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      playerName: json['playerName'] ?? 'Fighter',
      playerLevel: json['playerLevel'] ?? 85,
      playerXp: json['playerXp'] ?? 1200,
      playerWins: json['playerWins'] ?? 42,
      showNotification: json['showNotification'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'playerName': playerName,
      'playerLevel': playerLevel,
      'playerXp': playerXp,
      'playerWins': playerWins,
      'showNotification': showNotification,
    };
  }
}
