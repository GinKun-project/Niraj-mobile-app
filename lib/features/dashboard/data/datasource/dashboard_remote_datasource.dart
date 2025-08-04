import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shadow_clash_frontend/features/dashboard/data/model/dashboard_model.dart';

abstract class DashboardRemoteDataSource {
  Future<DashboardModel> getDashboardData();
  Future<void> updatePlayerStats({
    int? level,
    int? xp,
    int? wins,
  });
  Future<void> saveGameResult({
    required String result,
    required int playerHp,
    required int enemyHp,
    required int duration,
  });
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  static const String baseUrl = 'http://localhost:3000/api';
  final String? authToken;

  DashboardRemoteDataSourceImpl({this.authToken});

  @override
  Future<DashboardModel> getDashboardData() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/dashboard/stats'),
        headers: {
          'Content-Type': 'application/json',
          if (authToken != null) 'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return DashboardModel.fromJson(data);
      } else {
        throw Exception('Failed to load dashboard data');
      }
    } catch (e) {
      return const DashboardModel(
        playerName: 'Fighter',
        playerLevel: 85,
        playerXp: 1200,
        playerWins: 42,
        showNotification: false,
      );
    }
  }

  @override
  Future<void> updatePlayerStats({
    int? level,
    int? xp,
    int? wins,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/dashboard/stats'),
        headers: {
          'Content-Type': 'application/json',
          if (authToken != null) 'Authorization': 'Bearer $authToken',
        },
        body: json.encode({
          if (level != null) 'level': level,
          if (xp != null) 'xp': xp,
          if (wins != null) 'wins': wins,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update player stats');
      }
    } catch (e) {
      print('Error updating player stats: $e');
    }
  }

  @override
  Future<void> saveGameResult({
    required String result,
    required int playerHp,
    required int enemyHp,
    required int duration,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/dashboard/game-result'),
        headers: {
          'Content-Type': 'application/json',
          if (authToken != null) 'Authorization': 'Bearer $authToken',
        },
        body: json.encode({
          'result': result,
          'playerHp': playerHp,
          'enemyHp': enemyHp,
          'duration': duration,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to save game result: ${response.statusCode}');
      }
    } catch (e) {
      print('Error saving game result: $e');
    }
  }
}
