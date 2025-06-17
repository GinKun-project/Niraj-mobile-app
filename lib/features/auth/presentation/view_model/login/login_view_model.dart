import 'package:flutter/material.dart';
import 'package:shadow_clash_frontend/features/auth/domain/auth_repository.dart';
import 'package:shadow_clash_frontend/features/auth/data/data_source/local_user_data_source.dart';
import 'package:shadow_clash_frontend/features/auth/data/model/user_hive_model.dart';
import 'login_state.dart';
import 'login_event.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;
  final LocalUserDataSource _localDataSource = LocalUserDataSource(); // ✅ Hive

  LoginState _state = LoginState();
  LoginState get state => _state;

  LoginViewModel(this._authRepository);

  Future<void> handleLogin(LoginEvent event) async {
    _state = _state.copyWith(status: LoginStatus.loading);
    notifyListeners();

    final success = await _authRepository.login(event.email, event.password);
    if (success) {
      final user = UserHiveModel(username: "Player", email: event.email);
      await _localDataSource.saveUser(user);

      _state = _state.copyWith(status: LoginStatus.success);
    } else {
      _state = _state.copyWith(
        status: LoginStatus.failure,
        error: 'Invalid credentials',
      );
    }

    notifyListeners();
  }
}
