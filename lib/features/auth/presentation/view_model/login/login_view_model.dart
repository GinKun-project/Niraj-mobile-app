import 'package:flutter/material.dart';
import 'package:shadow_clash_frontend/features/auth/domain/usecase/login_usecase.dart';
import 'package:shadow_clash_frontend/features/auth/data/data_source/local_user_data_source.dart';
import 'package:shadow_clash_frontend/features/auth/data/model/user_hive_model.dart';
import 'package:shadow_clash_frontend/app/service_locator/service_locator.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginViewModel extends ChangeNotifier {
  final LoginUseCase _loginUseCase;
  final LocalUserDataSource _localDataSource = LocalUserDataSource();
  final NavigationService _navigationService = getIt<NavigationService>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  LoginState _state = LoginState();
  LoginState get state => _state;

  bool isLoading = false;

  LoginViewModel(this._loginUseCase);

  Future<void> login(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter both email and password')),
        );
      }
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      await handleLogin(LoginEvent(email: email, password: password));

      isLoading = false;
      notifyListeners();

      if (_state.status == LoginStatus.success) {
        _navigationService.navigateToReplacement('/dashboard');
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(_state.error)));
        }
      }
    } catch (e) {
      isLoading = false;
      _state = _state.copyWith(
        status: LoginStatus.failure,
        error: e.toString(),
      );
      notifyListeners();
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  Future<void> handleLogin(LoginEvent event) async {
    _state = _state.copyWith(status: LoginStatus.loading);
    notifyListeners();

    try {
      final userEntity = await _loginUseCase.execute(
        email: event.email,
        password: event.password,
      );

      if (userEntity != null) {
        final user = UserHiveModel(
          username: userEntity.username,
          email: userEntity.email,
          token: userEntity.token,
        );
        await _localDataSource.saveUser(user);

        _state = _state.copyWith(status: LoginStatus.success);
      } else {
        _state = _state.copyWith(
          status: LoginStatus.failure,
          error: 'Invalid credentials',
        );
      }
    } catch (e) {
      _state = _state.copyWith(
        status: LoginStatus.failure,
        error: e.toString(),
      );
    }

    notifyListeners();
  }
}
