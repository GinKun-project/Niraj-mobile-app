import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_clash_frontend/features/auth/presentation/view/login_view.dart';
import 'package:provider/provider.dart';
import 'package:shadow_clash_frontend/features/auth/presentation/view_model/login/login_event.dart';
import 'package:shadow_clash_frontend/features/auth/presentation/view_model/login/login_state.dart';
import 'package:shadow_clash_frontend/features/auth/presentation/view_model/login/login_view_model.dart';

class MockLoginViewModel extends ChangeNotifier implements LoginViewModel {
  @override
  final emailController = TextEditingController();

  @override
  final passwordController = TextEditingController();

  @override
  bool isLoading = false;

  @override
  Future<void> login(BuildContext context) async {}

  @override
  Future<void> handleLogin(LoginEvent event) {
    // TODO: implement handleLogin
    throw UnimplementedError();
  }

  @override
  // TODO: implement state
  LoginState get state => throw UnimplementedError();
}

void main() {
  testWidgets('Login form UI renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<LoginViewModel>(
          create: (_) => MockLoginViewModel(),
          child: LoginView(),
        ),
      ),
    );

    expect(find.text('Login'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.byType(ElevatedButton), findsOneWidget);
  });
}
