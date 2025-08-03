import 'package:flutter/material.dart';
import 'package:shadow_clash_frontend/app/service_locator/service_locator.dart';
import 'package:shadow_clash_frontend/features/game/data/service/audio_service.dart';
import 'package:shadow_clash_frontend/features/game/data/repository/game_repository_impl.dart';

enum DashboardStatus { initial, loading, success, error }

class DashboardState {
  final DashboardStatus status;
  final bool isSoundEnabled;
  final String? errorMessage;

  const DashboardState({
    this.status = DashboardStatus.initial,
    this.isSoundEnabled = true,
    this.errorMessage,
  });

  DashboardState copyWith({
    DashboardStatus? status,
    bool? isSoundEnabled,
    String? errorMessage,
  }) {
    return DashboardState(
      status: status ?? this.status,
      isSoundEnabled: isSoundEnabled ?? this.isSoundEnabled,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class DashboardViewModel extends ChangeNotifier {
  final NavigationService _navigationService = getIt<NavigationService>();
  final AudioService _audioService = AudioService();
  DashboardState _state = const DashboardState();

  DashboardState get state => _state;

  DashboardViewModel() {
    _initializeAudio();
  }

  Future<void> _initializeAudio() async {
    await _audioService.initialize();
    await _audioService.playBackgroundMusic();
  }

  void toggleSound() {
    _state = _state.copyWith(isSoundEnabled: !_state.isSoundEnabled);
    notifyListeners();
  }

  void logout() {
    _navigationService.navigateToAndClear('/login');
  }

  void navigateToGame() async {
    final repository = getIt<GameRepositoryImpl>();
    await repository.playFightersReady();
    _navigationService.navigateTo('/game');
  }

  void navigateToSettings() {
    _navigationService.navigateTo('/settings');
  }

  void navigateToProfile() {
    _navigationService.navigateTo('/profile');
  }

  void navigateToAchievements() {
    _navigationService.navigateTo('/achievements');
  }
}
