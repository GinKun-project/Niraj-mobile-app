import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_clash_frontend/features/auth/presentation/view_model/signup/signup_event.dart';

void main() {
  group('SignupEvent', () {
    test('creates event with required parameters', () {
      const username = 'testuser';
      const email = 'test@example.com';
      const password = 'password123';

      final event = SignupEvent(
        username: username,
        email: email,
        password: password,
      );

      expect(event.username, username);
      expect(event.email, email);
      expect(event.password, password);
    });

    test('creates event with empty strings', () {
      const username = '';
      const email = '';
      const password = '';

      final event = SignupEvent(
        username: username,
        email: email,
        password: password,
      );

      expect(event.username, username);
      expect(event.email, email);
      expect(event.password, password);
    });

    test('creates event with special characters', () {
      const username = 'test_user-123';
      const email = 'test+user@example.co.uk';
      const password = 'P@ssw0rd!';

      final event = SignupEvent(
        username: username,
        email: email,
        password: password,
      );

      expect(event.username, username);
      expect(event.email, email);
      expect(event.password, password);
    });

    test('creates event with long values', () {
      final username = 'a' * 50;
      final email = 'b' * 100 + '@example.com';
      final password = 'c' * 200;

      final event = SignupEvent(
        username: username,
        email: email,
        password: password,
      );

      expect(event.username, username);
      expect(event.email, email);
      expect(event.password, password);
    });
  });
} 