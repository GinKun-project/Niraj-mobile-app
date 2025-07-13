import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_clash_frontend/features/auth/data/model/login_response.dart';

void main() {
  group('LoginResponse', () {
    test('fromJson parses correctly', () {
      final json = {
        "token": "abc123",
        "user": {"username": "niraj", "email": "niraj@example.com"},
      };

      final response = LoginResponse.fromJson(json);

      expect(response.token, 'abc123');
      expect(response.username, 'niraj');
      expect(response.email, 'niraj@example.com');
    });
  });
}
