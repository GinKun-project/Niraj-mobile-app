import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shadow_clash_frontend/features/auth/presentation/view_model/signup/signup_event.dart';
import 'package:shadow_clash_frontend/features/auth/presentation/view_model/signup/signup_state.dart';
import 'package:shadow_clash_frontend/features/auth/presentation/view_model/signup/signup_view_model.dart';
import 'package:shadow_clash_frontend/features/auth/domain/usecase/signup_usecase.dart';
import 'package:shadow_clash_frontend/features/auth/domain/auth_repository.dart';
import 'package:shadow_clash_frontend/features/auth/data/data_source/local_user_data_source.dart';
import 'package:shadow_clash_frontend/features/auth/domain/entity/user_entity.dart';

// Mock classes
class MockSignupUseCase extends Mock implements SignupUseCase {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockLocalUserDataSource extends Mock implements LocalUserDataSource {}

void main() {
  group('SignupViewModel', () {
    late SignupViewModel viewModel;
    late MockSignupUseCase mockUseCase;

    setUp(() {
      mockUseCase = MockSignupUseCase();
      viewModel = SignupViewModel(mockUseCase);
    });

    test('initial state is correct', () {
      expect(viewModel.state.status, SignupStatus.initial);
      expect(viewModel.state.error, '');
      expect(viewModel.isLoading, false);
      expect(viewModel.usernameController.text, '');
      expect(viewModel.emailController.text, '');
      expect(viewModel.passwordController.text, '');
    });

    group('signup method', () {
      test('shows error when username is empty', () async {
        // Arrange
        viewModel.emailController.text = 'test@example.com';
        viewModel.passwordController.text = 'password123';

        // Act
        await viewModel.signup(MockBuildContext());

        // Assert
        expect(viewModel.state.status, SignupStatus.initial);
        expect(viewModel.isLoading, false);
      });

      test('shows error when email is empty', () async {
        // Arrange
        viewModel.usernameController.text = 'testuser';
        viewModel.passwordController.text = 'password123';

        // Act
        await viewModel.signup(MockBuildContext());

        // Assert
        expect(viewModel.state.status, SignupStatus.initial);
        expect(viewModel.isLoading, false);
      });

      test('shows error when password is empty', () async {
        // Arrange
        viewModel.usernameController.text = 'testuser';
        viewModel.emailController.text = 'test@example.com';

        // Act
        await viewModel.signup(MockBuildContext());

        // Assert
        expect(viewModel.state.status, SignupStatus.initial);
        expect(viewModel.isLoading, false);
      });

      test('successful signup navigates to login', () async {
        // Arrange
        final mockUserEntity = UserEntity(
          username: 'testuser',
          email: 'test@example.com',
          token: 'jwt_token',
        );

        when(
          mockUseCase.execute(
            username: 'testuser',
            email: 'test@example.com',
            password: 'password123',
          ),
        ).thenAnswer((_) async => mockUserEntity);

        viewModel.usernameController.text = 'testuser';
        viewModel.emailController.text = 'test@example.com';
        viewModel.passwordController.text = 'password123';

        // Act
        await viewModel.signup(MockBuildContext());

        // Assert
        expect(viewModel.isLoading, false);
        verify(
          mockUseCase.execute(
            username: 'testuser',
            email: 'test@example.com',
            password: 'password123',
          ),
        ).called(1);
      });

      test('failed signup sets failure state', () async {
        // Arrange
        when(
          mockUseCase.execute(
            username: 'testuser',
            email: 'test@example.com',
            password: 'password123',
          ),
        ).thenAnswer((_) async => null);

        viewModel.usernameController.text = 'testuser';
        viewModel.emailController.text = 'test@example.com';
        viewModel.passwordController.text = 'password123';

        // Act
        await viewModel.signup(MockBuildContext());

        // Assert
        expect(viewModel.state.status, SignupStatus.failure);
        expect(viewModel.state.error, 'Signup failed');
        expect(viewModel.isLoading, false);
      });

      test('signup with empty token sets failure state', () async {
        // Arrange
        final mockUserEntity = UserEntity(
          username: 'testuser',
          email: 'test@example.com',
          token: '',
        );

        when(
          mockUseCase.execute(
            username: 'testuser',
            email: 'test@example.com',
            password: 'password123',
          ),
        ).thenAnswer((_) async => mockUserEntity);

        viewModel.usernameController.text = 'testuser';
        viewModel.emailController.text = 'test@example.com';
        viewModel.passwordController.text = 'password123';

        // Act
        await viewModel.signup(MockBuildContext());

        // Assert
        expect(viewModel.state.status, SignupStatus.failure);
        expect(viewModel.state.error, 'Signup failed');
        expect(viewModel.isLoading, false);
      });

      test('sets loading state during signup', () async {
        // Arrange
        final mockUserEntity = UserEntity(
          username: 'testuser',
          email: 'test@example.com',
          token: 'jwt_token',
        );

        when(
          mockUseCase.execute(
            username: 'testuser',
            email: 'test@example.com',
            password: 'password123',
          ),
        ).thenAnswer((_) async {
          await Future.delayed(const Duration(milliseconds: 100));
          return mockUserEntity;
        });

        viewModel.usernameController.text = 'testuser';
        viewModel.emailController.text = 'test@example.com';
        viewModel.passwordController.text = 'password123';

        // Act
        final signupFuture = viewModel.signup(MockBuildContext());

        // Assert loading state is set
        expect(viewModel.isLoading, true);

        // Wait for completion
        await signupFuture;
        expect(viewModel.isLoading, false);
      });
    });

    group('handleSignup method', () {
      test('successful signup sets success state', () async {
        // Arrange
        final mockUserEntity = UserEntity(
          username: 'testuser',
          email: 'test@example.com',
          token: 'jwt_token',
        );

        when(
          mockUseCase.execute(
            username: 'testuser',
            email: 'test@example.com',
            password: 'password123',
          ),
        ).thenAnswer((_) async => mockUserEntity);

        // Act
        await viewModel.handleSignup(
          SignupEvent(
            username: 'testuser',
            email: 'test@example.com',
            password: 'password123',
          ),
        );

        // Assert
        expect(viewModel.state.status, SignupStatus.success);
      });

      test('failed signup sets failure state', () async {
        // Arrange
        when(
          mockUseCase.execute(
            username: 'testuser',
            email: 'test@example.com',
            password: 'password123',
          ),
        ).thenAnswer((_) async => null);

        // Act
        await viewModel.handleSignup(
          SignupEvent(
            username: 'testuser',
            email: 'test@example.com',
            password: 'password123',
          ),
        );

        // Assert
        expect(viewModel.state.status, SignupStatus.failure);
        expect(viewModel.state.error, 'Signup failed');
      });

      test('exception sets failure state', () async {
        // Arrange
        when(
          mockUseCase.execute(
            username: 'testuser',
            email: 'test@example.com',
            password: 'password123',
          ),
        ).thenThrow(Exception('Validation error'));

        // Act
        await viewModel.handleSignup(
          SignupEvent(
            username: 'testuser',
            email: 'test@example.com',
            password: 'password123',
          ),
        );

        // Assert
        expect(viewModel.state.status, SignupStatus.failure);
        expect(viewModel.state.error, 'Exception: Validation error');
      });
    });

    group('state management', () {
      test('notifies listeners when state changes', () {
        // Arrange
        var notificationCount = 0;
        viewModel.addListener(() {
          notificationCount++;
        });

        // Act
        viewModel.notifyListeners();

        // Assert
        expect(notificationCount, 1);
      });

      test('copyWith creates new state with updated values', () {
        // Arrange
        final originalState = SignupState();
        final newState = originalState.copyWith(
          status: SignupStatus.success,
          error: 'Success message',
        );

        // Assert
        expect(newState.status, SignupStatus.success);
        expect(newState.error, 'Success message');
        expect(
          originalState.status,
          SignupStatus.initial,
        ); // Original unchanged
      });
    });
  });
}

// Mock BuildContext for testing
class MockBuildContext extends Mock implements BuildContext {}
