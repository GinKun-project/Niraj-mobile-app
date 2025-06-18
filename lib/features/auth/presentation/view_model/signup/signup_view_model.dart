import 'package:flutter/material.dart';
import 'package:shadow_clash_frontend/features/auth/domain/auth_repository.dart';
import 'package:shadow_clash_frontend/features/auth/data/data_source/local_user_data_source.dart';
import 'package:shadow_clash_frontend/features/auth/data/model/user_hive_model.dart';
import 'signup_event.dart';
import 'signup_state.dart';

class SignupViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;
  final LocalUserDataSource _localDataSource = LocalUserDataSource();

  SignupState _state = SignupState();
  SignupState get state => _state;

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  SignupViewModel(this._authRepository);

  bool get isLoading => _state.status == SignupStatus.loading;

  Future<void> signup(BuildContext context) async {
    final username = usernameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      _state = _state.copyWith(
        status: SignupStatus.failure,
        error: 'Please fill all fields',
      );
      notifyListeners();
      return;
    }

    await handleSignup(
      SignupEvent(username: username, email: email, password: password),
    );

    if (_state.status == SignupStatus.success) {
      final user = UserHiveModel(username: username, email: email);
      await _localDataSource.saveUser(user);
      Navigator.pushReplacementNamed(context, '/dashboard');
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

    if (success) {
      _state = _state.copyWith(status: SignupStatus.success);
    } else {
      _state = _state.copyWith(
        status: SignupStatus.failure,
        error: 'Signup failed',
      );
    }
    notifyListeners();
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
