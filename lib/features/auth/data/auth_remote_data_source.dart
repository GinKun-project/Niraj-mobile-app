import 'package:shadow_clash_frontend/features/auth/domain/auth_repository.dart';

class AuthRemoteDataSource implements AuthRepository {
  @override
  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    return email == "player@shadowclash.com" && password == "clash123";
  }

  @override
  Future<bool> signup(String username, String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    return username.isNotEmpty && email.isNotEmpty && password.length >= 6;
  }
}
