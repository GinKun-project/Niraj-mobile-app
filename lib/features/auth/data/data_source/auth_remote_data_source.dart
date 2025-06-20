import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthRemoteDataSource {
  final String _baseUrl =
      'http://localhost:5000/api/auth'; // 🔁 Replace with production URL if needed

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return {'success': true, 'user': json['user'], 'token': json['token']};
    } else {
      final json = jsonDecode(response.body);
      return {'success': false, 'error': json['message'] ?? 'Login failed'};
    }
  }

  Future<Map<String, dynamic>> signup(
    String username,
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      final json = jsonDecode(response.body);
      return {'success': true, 'user': json['user'], 'token': json['token']};
    } else {
      final json = jsonDecode(response.body);
      return {'success': false, 'error': json['message'] ?? 'Signup failed'};
    }
  }
}
