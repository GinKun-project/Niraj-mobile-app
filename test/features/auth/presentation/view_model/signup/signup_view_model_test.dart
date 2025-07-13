import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_clash_frontend/features/auth/data/model/login_response.dart';
import 'package:shadow_clash_frontend/features/auth/presentation/view_model/signup/signup_event.dart';
import 'package:shadow_clash_frontend/features/auth/presentation/view_model/signup/signup_state.dart';
import 'package:shadow_clash_frontend/features/auth/presentation/view_model/signup/signup_view_model.dart';
import 'package:shadow_clash_frontend/features/auth/domain/auth_repository.dart';

import 'package:shadow_clash_frontend/features/auth/data/data_source/local_user_data_source.dart';
import 'package:mockito/mockito.dart';

// Mock classes
class MockAuthRepository extends Mock implements AuthRepository {}

class MockLocalUserDataSource extends Mock implements LocalUserDataSource {}

void main() {
  late SignupViewModel viewModel;
  late MockAuthRepository mockRepo;

  setUp(() {
    mockRepo = MockAuthRepository();
    viewModel = SignupViewModel(mockRepo);
  });

  test('initial state is correct', () {
    expect(viewModel.state.status, SignupStatus.initial);
  });

  test('successful signup sets success state', () async {
    when(mockRepo.signup('niraj', 'niraj@mail.com', '123456')).thenAnswer(
      (_) async => LoginResponse(
        token: 'token',
        username: 'niraj',
        email: 'niraj@mail.com',
      ),
    );

    await viewModel.handleSignup(
      SignupEvent(
        username: 'niraj',
        email: 'niraj@mail.com',
        password: '123456',
      ),
    );

    expect(viewModel.state.status, SignupStatus.success);
  });
}
