import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'package:shadow_clash_frontend/features/auth/data/model/login_response.dart';

class AuthRemoteDataSource {
  final String baseUrl = 'http://10.0.2.2:5000/api/auth';

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
        developer.log(
          'Login failed: ${response.body}',
          name: 'AuthRemoteDataSource',
        );
        return null;
      }
    } catch (e) {
      developer.log('Login error: $e', name: 'AuthRemoteDataSource');
      return null;
    }
  }

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
        developer.log(
          'Signup failed: ${response.body}',
          name: 'AuthRemoteDataSource',
        );
        return null;
      }
    } catch (e) {
      developer.log('Signup error: $e', name: 'AuthRemoteDataSource');
      return null;
    }
  }
}
