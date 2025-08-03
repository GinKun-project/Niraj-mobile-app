import 'package:shadow_clash_frontend/features/auth/domain/auth_repository.dart';
import 'package:shadow_clash_frontend/features/auth/domain/entity/user_entity.dart';

class SignupUseCase {
  final AuthRepository _authRepository;

  SignupUseCase(this._authRepository);

  Future<UserEntity?> execute({
    required String username,
    required String email,
    required String password,
  }) async {
    // Business logic validation
    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      throw Exception('All fields are required');
    }

    if (password.length < 6) {
      throw Exception('Password must be at least 6 characters');
    }

    if (!_isValidEmail(email)) {
      throw Exception('Invalid email format');
    }

    // Call repository
    final response = await _authRepository.signup(username, email, password);

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
