import 'dart:convert';
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
        print('❌ Login failed: ${response.body}');
        return null;
      }
    } catch (e) {
      print('❌ Login error: $e');
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
        print('❌ Signup failed: ${response.body}');
        return null;
      }
    } catch (e) {
      print('❌ Signup error: $e');
      return null;
    }
  }
}
