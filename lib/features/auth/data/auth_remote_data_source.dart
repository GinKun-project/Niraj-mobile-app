import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shadow_clash_frontend/features/auth/data/model/login_response.dart';

class AuthRemoteDataSource {
  final String baseUrl = 'http://localhost:5000/api/auth';

  /// Attempts real login; falls back to mock if offline or error
  Future<LoginResponse?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return LoginResponse.fromJson(json);
      } else {
        return null;
      }
    } catch (e) {
      // ✅ fallback when backend is not running
      if (email == 'demo@shadow.com' && password == '123456') {
        return LoginResponse(
          token: 'mock_token_demo',
          username: 'ShadowPlayer',
          email: email,
        );
      }
      return null;
    }
  }

  /// Attempts real signup; falls back to mock if offline or error
  Future<LoginResponse?> signup(
    String username,
    String email,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 201) {
        final json = jsonDecode(response.body);
        return LoginResponse.fromJson(json);
      } else {
        return null;
      }
    } catch (e) {
      // ✅ fallback mock signup
      return LoginResponse(
        token: 'mock_token_signup',
        username: username,
        email: email,
      );
    }
  }
}
