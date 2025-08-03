import 'package:flutter/material.dart';
import 'package:shadow_clash_frontend/features/auth/domain/usecase/signup_usecase.dart';
import 'package:shadow_clash_frontend/features/auth/data/data_source/local_user_data_source.dart';
import 'package:shadow_clash_frontend/features/auth/data/model/user_hive_model.dart';
import 'package:shadow_clash_frontend/features/auth/presentation/view_model/signup/signup_event.dart';
import 'package:shadow_clash_frontend/app/service_locator/service_locator.dart';
import 'signup_state.dart';

class SignupViewModel extends ChangeNotifier {
  final SignupUseCase _signupUseCase;
  final LocalUserDataSource _localDataSource = LocalUserDataSource();
  final NavigationService _navigationService = getIt<NavigationService>();

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  SignupState _state = SignupState();
  SignupState get state => _state;

  bool isLoading = false;

  SignupViewModel(this._signupUseCase);

  Future<void> signup(BuildContext context) async {
    final username = usernameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill in all fields')),
        );
      }
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      final userEntity = await _signupUseCase.execute(
        username: username,
        email: email,
        password: password,
      );

      isLoading = false;
      notifyListeners();

      if (userEntity != null) {
        final user = UserHiveModel(
          username: userEntity.username,
          email: userEntity.email,
          token: userEntity.token,
        );
        await _localDataSource.saveUser(user);

        _navigationService.navigateToReplacement('/login');
      } else {
        _state = _state.copyWith(
          status: SignupStatus.failure,
          error: 'Signup failed',
        );
        notifyListeners();
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(_state.error)));
        }
      }
    } catch (e) {
      isLoading = false;
      _state = _state.copyWith(
        status: SignupStatus.failure,
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

  Future<void> handleSignup(SignupEvent signupEvent) async {
    _state = _state.copyWith(status: SignupStatus.loading);
    notifyListeners();

    try {
      final userEntity = await _signupUseCase.execute(
        username: signupEvent.username,
        email: signupEvent.email,
        password: signupEvent.password,
      );

      if (userEntity != null) {
        final user = UserHiveModel(
          username: userEntity.username,
          email: userEntity.email,
          token: userEntity.token,
        );
        await _localDataSource.saveUser(user);

        _state = _state.copyWith(status: SignupStatus.success);
      } else {
        _state = _state.copyWith(
          status: SignupStatus.failure,
          error: 'Signup failed',
        );
      }
    } catch (e) {
      _state = _state.copyWith(
        status: SignupStatus.failure,
        error: e.toString(),
      );
    }

    notifyListeners();
  }
}
