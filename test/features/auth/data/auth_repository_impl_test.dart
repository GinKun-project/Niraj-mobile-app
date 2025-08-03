import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shadow_clash_frontend/features/auth/data/auth_repository_impl.dart';
import 'package:shadow_clash_frontend/features/auth/data/auth_remote_data_source.dart';
import 'package:shadow_clash_frontend/features/auth/data/model/login_response.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

void main() {
  group('AuthRepositoryImpl', () {
    late AuthRepositoryImpl repository;
    late MockAuthRemoteDataSource mockRemoteDataSource;

    setUp(() {
      mockRemoteDataSource = MockAuthRemoteDataSource();
      repository = AuthRepositoryImpl(mockRemoteDataSource);
      reset(mockRemoteDataSource);
    });

    group('signup', () {
      test(
        'returns LoginResponse when remote data source returns success',
        () async {
          // Arrange
          const username = 'testuser';
          const email = 'test@example.com';
          const password = 'password123';

          final mockResponse = LoginResponse(
            token: 'jwt_token',
            username: 'testuser',
            email: 'test@example.com',
          );

          when(
            mockRemoteDataSource.signup(username, email, password),
          ).thenAnswer((_) async => mockResponse);

          // Act
          final result = await repository.signup(username, email, password);

          // Assert
          expect(result, isNotNull);
          expect(result?.token, 'jwt_token');
          expect(result?.username, 'testuser');
          expect(result?.email, 'test@example.com');
          verify(
            mockRemoteDataSource.signup(username, email, password),
          ).called(1);
        },
      );

      test('returns null when remote data source returns null', () async {
        // Arrange
        const username = 'testuser';
        const email = 'test@example.com';
        const password = 'password123';

        when(
          mockRemoteDataSource.signup(username, email, password),
        ).thenAnswer((_) async => null);

        // Act
        final result = await repository.signup(username, email, password);

        // Assert
        expect(result, isNull);
        verify(
          mockRemoteDataSource.signup(username, email, password),
        ).called(1);
      });

      test('propagates exceptions from remote data source', () async {
        // Arrange
        const username = 'testuser';
        const email = 'test@example.com';
        const password = 'password123';

        when(
          mockRemoteDataSource.signup(username, email, password),
        ).thenThrow(Exception('Network error'));

        // Act & Assert
        expect(
          () => repository.signup(username, email, password),
          throwsException,
        );
      });
    });

    group('login', () {
      test(
        'returns LoginResponse when remote data source returns success',
        () async {
          // Arrange
          const email = 'test@example.com';
          const password = 'password123';

          final mockResponse = LoginResponse(
            token: 'jwt_token',
            username: 'testuser',
            email: 'test@example.com',
          );

          when(
            mockRemoteDataSource.login(email, password),
          ).thenAnswer((_) async => mockResponse);

          // Act
          final result = await repository.login(email, password);

          // Assert
          expect(result, isNotNull);
          expect(result?.token, 'jwt_token');
          expect(result?.username, 'testuser');
          expect(result?.email, 'test@example.com');
          verify(mockRemoteDataSource.login(email, password)).called(1);
        },
      );

      test('returns null when remote data source returns null', () async {
        // Arrange
        const email = 'test@example.com';
        const password = 'password123';

        when(
          mockRemoteDataSource.login(email, password),
        ).thenAnswer((_) async => null);

        // Act
        final result = await repository.login(email, password);

        // Assert
        expect(result, isNull);
        verify(mockRemoteDataSource.login(email, password)).called(1);
      });

      test('propagates exceptions from remote data source', () async {
        // Arrange
        const email = 'test@example.com';
        const password = 'password123';

        when(
          mockRemoteDataSource.login(email, password),
        ).thenThrow(Exception('Network error'));

        // Act & Assert
        expect(() => repository.login(email, password), throwsException);
      });
    });
  });
}
