abstract class AuthRepository {
  Future<bool> login(String email, String password);
  Future<bool> signup(String username, String email, String password);
}
