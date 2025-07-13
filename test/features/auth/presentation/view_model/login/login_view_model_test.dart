import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shadow_clash_frontend/features/auth/domain/auth_repository.dart';
import 'package:shadow_clash_frontend/features/auth/presentation/view_model/login/login_state.dart';
import 'package:shadow_clash_frontend/features/auth/presentation/view_model/login/login_view_model.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  group('LoginViewModel', () {
    late LoginViewModel viewModel;
    late MockAuthRepository mockRepo;

    setUp(() {
      mockRepo = MockAuthRepository();
      viewModel = LoginViewModel(mockRepo);
    });

    test('initial values are correct', () {
      expect(viewModel.state.status, LoginStatus.initial);
      expect(viewModel.emailController.text, '');
      expect(viewModel.passwordController.text, '');
    });

    test('login sets success when repository returns true', () async {
      when(mockRepo.login(any, any)).thenAnswer((_) async => true);

      viewModel.emailController.text = 'test@example.com';
      viewModel.passwordController.text = 'password123';
      await viewModel.login();

      expect(viewModel.state.status, LoginStatus.success);
    });

    test('login sets failure when repository returns false', () async {
      when(mockRepo.login(any, any)).thenAnswer((_) async => false);

      viewModel.emailController.text = 'test@example.com';
      viewModel.passwordController.text = 'wrongpassword';
      await viewModel.login();

      expect(viewModel.state.status, LoginStatus.failure);
    });
  });
}
