import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shadow_clash_frontend/features/auth/domain/usecase/login_usecase.dart';
import 'package:shadow_clash_frontend/features/auth/presentation/view_model/login/login_state.dart';
import 'package:shadow_clash_frontend/features/auth/presentation/view_model/login/login_view_model.dart';
import 'package:shadow_clash_frontend/features/auth/presentation/view_model/login/login_event.dart';
import 'package:shadow_clash_frontend/features/auth/domain/entity/user_entity.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}

void main() {
  group('LoginViewModel', () {
    late LoginViewModel viewModel;
    late MockLoginUseCase mockUseCase;

    setUp(() {
      mockUseCase = MockLoginUseCase();
      viewModel = LoginViewModel(mockUseCase);
    });

    test('initial values are correct', () {
      expect(viewModel.state.status, LoginStatus.initial);
      expect(viewModel.emailController.text, '');
      expect(viewModel.passwordController.text, '');
    });

    test('login sets success when use case returns user entity', () async {
      final mockUserEntity = UserEntity(
        username: 'test_user',
        email: 'test@example.com',
        token: 'test_token',
      );
      when(
        mockUseCase.execute(email: 'test@example.com', password: 'password123'),
      ).thenAnswer((_) async => mockUserEntity);

      await viewModel.handleLogin(
        LoginEvent(email: 'test@example.com', password: 'password123'),
      );

      expect(viewModel.state.status, LoginStatus.success);
    });

    test('login sets failure when use case returns null', () async {
      when(
        mockUseCase.execute(
          email: 'test@example.com',
          password: 'wrongpassword',
        ),
      ).thenAnswer((_) async => null);

      await viewModel.handleLogin(
        LoginEvent(email: 'test@example.com', password: 'wrongpassword'),
      );

      expect(viewModel.state.status, LoginStatus.failure);
      expect(viewModel.state.error, 'Invalid credentials');
    });

    test('login sets failure when use case throws exception', () async {
      when(
        mockUseCase.execute(email: 'test@example.com', password: 'password123'),
      ).thenThrow(Exception('Network error'));

      await viewModel.handleLogin(
        LoginEvent(email: 'test@example.com', password: 'password123'),
      );

      expect(viewModel.state.status, LoginStatus.failure);
      expect(viewModel.state.error, 'Exception: Network error');
    });
  });
}
