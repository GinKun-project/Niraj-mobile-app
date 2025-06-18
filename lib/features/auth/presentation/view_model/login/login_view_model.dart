import 'package:flutter/material.dart';
import 'package:shadow_clash_frontend/features/auth/domain/auth_repository.dart';
import 'package:shadow_clash_frontend/features/auth/data/data_source/local_user_data_source.dart';
import 'package:shadow_clash_frontend/features/auth/data/model/user_hive_model.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;
  final LocalUserDataSource _localDataSource = LocalUserDataSource();

  LoginState _state = LoginState();
  LoginState get state => _state;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  LoginViewModel(this._authRepository);

  bool get isLoading => _state.status == LoginStatus.loading;

  Future<void> login(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _state = _state.copyWith(
        status: LoginStatus.failure,
        error: 'Please enter email and password',
      );
      notifyListeners();
      return;
    }

    await handleLogin(LoginEvent(email: email, password: password));

    if (_state.status == LoginStatus.success) {
      final user = UserHiveModel(username: "Player", email: email);
      await _localDataSource.saveUser(user);
      Navigator.pushReplacementNamed(context, '/dashboard');
    }
  }

  Future<void> handleLogin(LoginEvent event) async {
    _state = _state.copyWith(status: LoginStatus.loading);
    notifyListeners();

    final success = await _authRepository.login(event.email, event.password);
    if (success) {
      _state = _state.copyWith(status: LoginStatus.success);
    } else {
      _state = _state.copyWith(
        status: LoginStatus.failure,
        error: 'Invalid credentials',
      );
    }
    notifyListeners();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
