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

    test('toJson serializes correctly', () {
      final response = LoginResponse(
        token: 'abc123',
        username: 'niraj',
        email: 'niraj@example.com',
      );

      final json = response.toJson();

      expect(json['token'], 'abc123');
      expect(json['user']['username'], 'niraj');
      expect(json['user']['email'], 'niraj@example.com');
    });

    test('fromJson handles null values gracefully', () {
      final json = {"token": null, "user": null};

      final response = LoginResponse.fromJson(json);

      expect(response.token, '');
      expect(response.username, '');
      expect(response.email, '');
    });
  });
}
