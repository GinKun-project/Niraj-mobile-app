import 'package:flutter/material.dart';
import 'package:shadow_clash_frontend/features/auth/data/data_source/local_user_data_source.dart';
import 'package:shadow_clash_frontend/features/auth/data/model/user_hive_model.dart';

/// Represents login status for splash decisions
enum SplashStatus { checking, loggedIn, loggedOut }

class SplashViewModel extends ChangeNotifier {
  final LocalUserDataSource _localUserDataSource = LocalUserDataSource();

  SplashStatus _status = SplashStatus.checking;
  SplashStatus get status => _status;

  UserHiveModel? _user;
  UserHiveModel? get user => _user;

  /// Call this in SplashView to check if token/session exists
  Future<void> checkLoginStatus() async {
    _status = SplashStatus.checking;
    notifyListeners();

    try {
      final storedUser = await _localUserDataSource.getUser();

      if (storedUser != null && storedUser.token != null) {
        _user = storedUser;
        _status = SplashStatus.loggedIn;
      } else {
        _status = SplashStatus.loggedOut;
      }
    } catch (e) {
      _status = SplashStatus.loggedOut;
    }

    notifyListeners();
  }
}
