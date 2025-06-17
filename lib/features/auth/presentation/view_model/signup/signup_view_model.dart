import 'package:flutter/material.dart';
import 'package:shadow_clash_frontend/features/auth/domain/auth_repository.dart';
import 'signup_event.dart';
import 'signup_state.dart';

class SignupViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;
  SignupState _state = SignupState();

  SignupState get state => _state;

  SignupViewModel(this._authRepository);

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
}
