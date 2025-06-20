import 'package:flutter/material.dart';
import 'package:shadow_clash_frontend/features/auth/domain/auth_repository.dart';
import 'package:shadow_clash_frontend/features/auth/data/data_source/local_user_data_source.dart';
import 'package:shadow_clash_frontend/features/auth/data/model/user_hive_model.dart';
import 'signup_event.dart';
import 'signup_state.dart';

class SignupViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;
  final LocalUserDataSource _localDataSource = LocalUserDataSource();

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  SignupState _state = SignupState();
  SignupState get state => _state;

  bool isLoading = false;

  SignupViewModel(this._authRepository);

  Future<void> signup(BuildContext context) async {
    final username = usernameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    isLoading = true;
    notifyListeners();

    await handleSignup(
      SignupEvent(username: username, email: email, password: password),
    );

    isLoading = false;
    notifyListeners();

    if (_state.status == SignupStatus.success) {
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else if (_state.error != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_state.error!)));
    }
  }

  Future<void> handleSignup(SignupEvent event) async {
    _state = _state.copyWith(status: SignupStatus.loading);
    notifyListeners();

    final success = await _authRepository.signup(
      event.username,
      event.email,
      event.password,
    );

    if (success != null) {
      final user = UserHiveModel(username: event.username, email: event.email);
      await _localDataSource.saveUser(user);

      _state = _state.copyWith(status: SignupStatus.success);
    } else {
      _state = _state.copyWith(
        status: SignupStatus.failure,
        error: 'Signup failed',
      );
    }

    notifyListeners();
  }
}
