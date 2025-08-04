import 'package:shared_preferences/shared_preferences.dart';
import 'package:shadow_clash_frontend/features/dashboard/data/model/dashboard_model.dart';
import 'dart:convert';

abstract class DashboardLocalDataSource {
  Future<DashboardModel> getDashboardData();
  Future<void> saveDashboardData(DashboardModel data);
  Future<void> updatePlayerStats({
    int? level,
    int? xp,
    int? wins,
  });
}

class DashboardLocalDataSourceImpl implements DashboardLocalDataSource {
  static const String _dashboardKey = 'dashboard_data';
  static const String _levelKey = 'player_level';
  static const String _xpKey = 'player_xp';
  static const String _winsKey = 'player_wins';

  @override
  Future<DashboardModel> getDashboardData() async {
    final prefs = await SharedPreferences.getInstance();

    final level = prefs.getInt(_levelKey) ?? 85;
    final xp = prefs.getInt(_xpKey) ?? 1200;
    final wins = prefs.getInt(_winsKey) ?? 42;

    return DashboardModel(
      playerName: 'Fighter',
      playerLevel: level,
      playerXp: xp,
      playerWins: wins,
      showNotification: false,
    );
  }

  @override
  Future<void> saveDashboardData(DashboardModel data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('dashboard_data', jsonEncode(data.toJson()));
  }

  @override
  Future<void> updatePlayerStats({
    int? level,
    int? xp,
    int? wins,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    if (level != null) await prefs.setInt(_levelKey, level);
    if (xp != null) await prefs.setInt(_xpKey, xp);
    if (wins != null) await prefs.setInt(_winsKey, wins);
  }
}
