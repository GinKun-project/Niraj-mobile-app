import 'package:flutter/material.dart';
import 'package:shadow_clash_frontend/features/auth/domain/auth_repository.dart';
import 'package:shadow_clash_frontend/features/auth/data/data_source/local_user_data_source.dart';
import 'package:shadow_clash_frontend/features/auth/data/model/user_hive_model.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;
  final LocalUserDataSource _localDataSource = LocalUserDataSource();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  LoginState _state = LoginState();
  LoginState get state => _state;

  bool isLoading = false;

  LoginViewModel(this._authRepository);

  Future<void> login(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both email and password')),
      );
      return;
    }

    isLoading = true;
    notifyListeners();

    await handleLogin(LoginEvent(email: email, password: password));

    isLoading = false;
    notifyListeners();

    if (_state.status == LoginStatus.success) {
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else if (_state.error != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_state.error!)));
    }
  }

  Future<void> handleLogin(LoginEvent event) async {
    _state = _state.copyWith(status: LoginStatus.loading);
    notifyListeners();

    final result = await _authRepository.login(event.email, event.password);

    if (result != null) {
      final user = UserHiveModel(
        username: "Player",
        email: event.email,
        token: result.token, //Store JWT token
      );
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
