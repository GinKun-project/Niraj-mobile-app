import 'package:shadow_clash_frontend/features/auth/domain/auth_repository.dart';
import 'package:shadow_clash_frontend/features/auth/domain/entity/user_entity.dart';

class LoginUseCase {
  final AuthRepository _authRepository;

  LoginUseCase(this._authRepository);

  Future<UserEntity?> execute({
    required String email,
    required String password,
  }) async {
    // Business logic validation
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Email and password are required');
    }

    if (!_isValidEmail(email)) {
      throw Exception('Invalid email format');
    }

    // Call repository
    final response = await _authRepository.login(email, password);

    if (response != null && response.token.isNotEmpty) {
      // Convert to domain entity
      return UserEntity(
        username: response.username,
        email: response.email,
        token: response.token,
      );
    }

    return null;
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
