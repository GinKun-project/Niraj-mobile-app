import 'package:flutter/material.dart';
import 'package:shadow_clash_frontend/app/service_locator/service_locator.dart';
import 'package:shadow_clash_frontend/features/dashboard/domain/entity/dashboard_entity.dart';
import 'package:shadow_clash_frontend/features/dashboard/domain/usecase/get_dashboard_data_usecase.dart';
import 'package:shadow_clash_frontend/features/dashboard/domain/usecase/show_game_end_notification_usecase.dart';

enum DashboardStatus { initial, loading, loaded, error }

class DashboardState {
  final DashboardStatus status;
  final DashboardEntity? data;
  final String? error;

  const DashboardState({
    this.status = DashboardStatus.initial,
    this.data,
    this.error,
  });

  DashboardState copyWith({
    DashboardStatus? status,
    DashboardEntity? data,
    String? error,
  }) {
    return DashboardState(
      status: status ?? this.status,
      data: data ?? this.data,
      error: error ?? this.error,
    );
  }
}

class DashboardViewModel extends ChangeNotifier {
  DashboardState _state = const DashboardState();
  bool _isDisposed = false;

  final GetDashboardDataUseCase _getDashboardDataUseCase;
  final ShowGameEndNotificationUseCase _showGameEndNotificationUseCase;

  DashboardState get state => _state;

  DashboardViewModel({
    required GetDashboardDataUseCase getDashboardDataUseCase,
    required ShowGameEndNotificationUseCase showGameEndNotificationUseCase,
  })  : _getDashboardDataUseCase = getDashboardDataUseCase,
        _showGameEndNotificationUseCase = showGameEndNotificationUseCase {
    _loadDashboardData();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  Future<void> _loadDashboardData() async {
    if (_isDisposed) return;

    try {
      final data = await _getDashboardDataUseCase();
      if (!_isDisposed) {
        _state = _state.copyWith(
          status: DashboardStatus.loaded,
          data: data,
        );
        notifyListeners();
      }
    } catch (e) {
      if (!_isDisposed) {
        _state = _state.copyWith(
          status: DashboardStatus.loaded,
          data: const DashboardEntity(
            playerName: 'Fighter',
            playerLevel: 85,
            playerXp: 1200,
            playerWins: 42,
            showNotification: false,
          ),
        );
        notifyListeners();
      }
    }
  }

  Future<void> showGameEndNotification() async {
    if (_isDisposed) return;

    try {
      await _showGameEndNotificationUseCase.call();
    } catch (e) {
      print('Error showing game end notification: $e');
    }
  }

  void logout() {
    if (_isDisposed) return;

    try {
      getIt<NavigationService>().navigateToAndClear('/login');
    } catch (e) {
      print('Error during logout: $e');
    }
  }

  void navigateToGame() {
    if (_isDisposed) return;

    try {
      getIt<NavigationService>().navigateTo('/game');
    } catch (e) {
      print('Error navigating to game: $e');
    }
  }

  void navigateToProfile() {
    if (_isDisposed) return;

    try {
      getIt<NavigationService>().navigateTo('/profile');
    } catch (e) {
      print('Error navigating to profile: $e');
    }
  }

  void navigateToSettings() {
    if (_isDisposed) return;

    try {
      getIt<NavigationService>().navigateTo('/settings');
    } catch (e) {
      print('Error navigating to settings: $e');
    }
  }

  void navigateToAchievements() {
    if (_isDisposed) return;

    try {
      getIt<NavigationService>().navigateTo('/achievements');
    } catch (e) {
      print('Error navigating to achievements: $e');
    }
  }

  Future<void> refreshDashboard() async {
    await _loadDashboardData();
  }
}
