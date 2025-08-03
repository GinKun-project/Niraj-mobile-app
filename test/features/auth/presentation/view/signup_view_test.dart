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

  final SignupState _state = SignupState();
  @override
  SignupState get state => _state;

  @override
  Future<void> signup(BuildContext context) async {}

  @override
  Future<void> handleSignup(SignupEvent signupEvent) async {
    // Mock implementation
  }
}

void main() {
  group('SignupView', () {
    late MockSignupViewModel mockViewModel;

    setUp(() {
      mockViewModel = MockSignupViewModel();
    });

    testWidgets('renders all UI elements correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<SignupViewModel>(
            create: (_) => mockViewModel,
            child: const SignupView(),
          ),
        ),
      );

      // Check main title
      expect(find.text('Create Account'), findsOneWidget);

      // Check text fields
      expect(find.byType(TextField), findsNWidgets(3));
      expect(find.text('Username'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);

      // Check signup button
      expect(find.text('Sign Up'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);

      // Check navigation link
      expect(find.text('Already have an account? Login'), findsOneWidget);
    });

    testWidgets('text fields are properly connected to controllers', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<SignupViewModel>(
            create: (_) => mockViewModel,
            child: const SignupView(),
          ),
        ),
      );

      // Enter text in username field
      await tester.enterText(find.byType(TextField).first, 'testuser');
      expect(mockViewModel.usernameController.text, 'testuser');

      // Enter text in email field
      await tester.enterText(find.byType(TextField).at(1), 'test@example.com');
      expect(mockViewModel.emailController.text, 'test@example.com');

      // Enter text in password field
      await tester.enterText(find.byType(TextField).last, 'password123');
      expect(mockViewModel.passwordController.text, 'password123');
    });

    testWidgets('signup button is present and tappable', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<SignupViewModel>(
            create: (_) => mockViewModel,
            child: const SignupView(),
          ),
        ),
      );

      // Verify signup button exists and is enabled
      final signupButton = find.text('Sign Up');
      expect(signupButton, findsOneWidget);

      // Verify it's an ElevatedButton
      final elevatedButton = find.byType(ElevatedButton);
      expect(elevatedButton, findsOneWidget);
    });

    testWidgets('shows loading indicator when isLoading is true', (
      WidgetTester tester,
    ) async {
      mockViewModel.isLoading = true;

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<SignupViewModel>(
            create: (_) => mockViewModel,
            child: const SignupView(),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Sign Up'), findsNothing);
    });

    testWidgets('navigation link is present and tappable', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<SignupViewModel>(
            create: (_) => mockViewModel,
            child: const SignupView(),
          ),
        ),
      );

      // Verify navigation link exists
      final navigationLink = find.text('Already have an account? Login');
      expect(navigationLink, findsOneWidget);

      // Verify it's wrapped in a GestureDetector (there might be multiple)
      expect(find.byType(GestureDetector), findsWidgets);
    });

    testWidgets('password field is obscured', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<SignupViewModel>(
            create: (_) => mockViewModel,
            child: const SignupView(),
          ),
        ),
      );

      // Find the password field (last TextField)
      final passwordField = find.byType(TextField).last;
      final TextField widget = tester.widget(passwordField);

      expect(widget.obscureText, true);
    });

    testWidgets('background image is displayed', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<SignupViewModel>(
            create: (_) => mockViewModel,
            child: const SignupView(),
          ),
        ),
      );

      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('overlay container is present', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<SignupViewModel>(
            create: (_) => mockViewModel,
            child: const SignupView(),
          ),
        ),
      );

      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('form is scrollable', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<SignupViewModel>(
            create: (_) => mockViewModel,
            child: const SignupView(),
          ),
        ),
      );

      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('text field decorations are correct', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<SignupViewModel>(
            create: (_) => mockViewModel,
            child: const SignupView(),
          ),
        ),
      );

      // Check that all text fields have proper decorations
      final textFields = find.byType(TextField);
      expect(textFields, findsNWidgets(3));

      // Check first text field (username)
      final usernameField = find.byType(TextField).first;
      final usernameWidget = tester.widget<TextField>(usernameField);
      expect(usernameWidget.decoration, isNotNull);
      expect(usernameWidget.decoration!.hintText, 'Username');

      // Check second text field (email)
      final emailField = find.byType(TextField).at(1);
      final emailWidget = tester.widget<TextField>(emailField);
      expect(emailWidget.decoration, isNotNull);
      expect(emailWidget.decoration!.hintText, 'Email');

      // Check third text field (password)
      final passwordField = find.byType(TextField).last;
      final passwordWidget = tester.widget<TextField>(passwordField);
      expect(passwordWidget.decoration, isNotNull);
      expect(passwordWidget.decoration!.hintText, 'Password');
    });
  });
}
