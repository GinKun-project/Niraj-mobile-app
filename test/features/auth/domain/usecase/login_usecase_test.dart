import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shadow_clash_frontend/features/auth/domain/usecase/login_usecase.dart';
import 'package:shadow_clash_frontend/features/auth/domain/auth_repository.dart';
import 'package:shadow_clash_frontend/features/auth/domain/entity/user_entity.dart';
import 'package:shadow_clash_frontend/features/auth/data/model/login_response.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  group('LoginUseCase', () {
    late LoginUseCase useCase;
    late MockAuthRepository mockRepository;

    setUp(() {
      mockRepository = MockAuthRepository();
      useCase = LoginUseCase(mockRepository);
      reset(mockRepository);
    });

    group('execute', () {
      test('returns UserEntity when login is successful', () async {
        // Arrange
        const email = 'test@example.com';
        const password = 'password123';

        final mockResponse = LoginResponse(
          token: 'jwt_token',
          username: 'testuser',
          email: 'test@example.com',
        );

        when(
          mockRepository.login(email, password),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final result = await useCase.execute(email: email, password: password);

        // Assert
        expect(result, isA<UserEntity>());
        expect(result?.username, 'testuser');
        expect(result?.email, 'test@example.com');
        expect(result?.token, 'jwt_token');
        verify(mockRepository.login(email, password)).called(1);
      });

      test('returns null when repository returns null', () async {
        // Arrange
        const email = 'test@example.com';
        const password = 'password123';

        when(
          mockRepository.login(email, password),
        ).thenAnswer((_) async => null);

        // Act
        final result = await useCase.execute(email: email, password: password);

        // Assert
        expect(result, isNull);
        verify(mockRepository.login(email, password)).called(1);
      });

      test('returns null when repository returns empty token', () async {
        // Arrange
        const email = 'test@example.com';
        const password = 'password123';

        final mockResponse = LoginResponse(
          token: '',
          username: 'testuser',
          email: 'test@example.com',
        );

        when(
          mockRepository.login(email, password),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final result = await useCase.execute(email: email, password: password);

        // Assert
        expect(result, isNull);
        verify(mockRepository.login(email, password)).called(1);
      });

      test('throws exception when email is empty', () async {
        // Act & Assert
        expect(
          () => useCase.execute(email: '', password: 'password123'),
          throwsException,
        );
      });

      test('throws exception when password is empty', () async {
        // Act & Assert
        expect(
          () => useCase.execute(email: 'test@example.com', password: ''),
          throwsException,
        );
      });

      test('throws exception when email format is invalid', () async {
        // Act & Assert
        expect(
          () =>
              useCase.execute(email: 'invalid-email', password: 'password123'),
          throwsException,
        );
      });

      test('accepts valid email formats', () async {
        // Arrange
        const password = 'password123';

        final validEmails = [
          'test@example.com',
          'user.name@domain.co.uk',
          'user+tag@example.org',
          'user123@test-domain.com',
        ];

        for (final email in validEmails) {
          final mockResponse = LoginResponse(
            token: 'jwt_token',
            username: 'testuser',
            email: email,
          );

          when(
            mockRepository.login(email, password),
          ).thenAnswer((_) async => mockResponse);

          // Act
          final result = await useCase.execute(
            email: email,
            password: password,
          );

          // Assert
          expect(result, isNotNull);
          expect(result?.email, email);
        }
      });

      test('propagates repository exceptions', () async {
        // Arrange
        const email = 'test@example.com';
        const password = 'password123';

        when(
          mockRepository.login(email, password),
        ).thenThrow(Exception('Network error'));

        // Act & Assert
        expect(
          () => useCase.execute(email: email, password: password),
          throwsException,
        );
      });
    });
  });
}
