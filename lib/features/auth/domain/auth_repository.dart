import 'package:shadow_clash_frontend/features/auth/data/model/login_response.dart';

abstract class AuthRepository {
  Future<LoginResponse?> login(String email, String password);
  Future<LoginResponse?> signup(String username, String email, String password);
}
