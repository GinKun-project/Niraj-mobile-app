import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_clash_frontend/features/auth/presentation/view/signup_view.dart';
import 'package:provider/provider.dart';
import 'package:shadow_clash_frontend/features/auth/presentation/view_model/signup/signup_event.dart';
import 'package:shadow_clash_frontend/features/auth/presentation/view_model/signup/signup_state.dart';
import 'package:shadow_clash_frontend/features/auth/presentation/view_model/signup/signup_view_model.dart';

class MockSignupViewModel extends ChangeNotifier implements SignupViewModel {
  @override
  final usernameController = TextEditingController();

  @override
  final emailController = TextEditingController();

  @override
  final passwordController = TextEditingController();

  @override
  bool isLoading = false;

  @override
  Future<void> signup(BuildContext context) async {}

  @override
  Future<void> handleSignup(SignupEvent signupEvent) {
    // TODO: implement handleSignup
    throw UnimplementedError();
  }

  @override
  // TODO: implement state
  SignupState get state => throw UnimplementedError();
}

void main() {
  testWidgets('Signup form UI renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<SignupViewModel>(
          create: (_) => MockSignupViewModel(),
          child: SignupView(),
        ),
      ),
    );

    expect(find.text('Sign Up'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(3));
    expect(find.byType(ElevatedButton), findsOneWidget);
  });
}
