import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_clash_frontend/features/auth/presentation/view_model/signup/signup_state.dart';

void main() {
  group('SignupState', () {
    test('creates initial state with default values', () {
      final state = SignupState();

      expect(state.status, SignupStatus.initial);
      expect(state.error, '');
    });

    test('creates state with custom values', () {
      final state = SignupState(
        status: SignupStatus.success,
        error: 'Success message',
      );

      expect(state.status, SignupStatus.success);
      expect(state.error, 'Success message');
    });

    test('copyWith creates new state with updated status', () {
      final originalState = SignupState();
      final newState = originalState.copyWith(status: SignupStatus.loading);

      expect(newState.status, SignupStatus.loading);
      expect(newState.error, '');
      expect(originalState.status, SignupStatus.initial); // Original unchanged
    });

    test('copyWith creates new state with updated error', () {
      final originalState = SignupState();
      final newState = originalState.copyWith(error: 'Error message');

      expect(newState.status, SignupStatus.initial);
      expect(newState.error, 'Error message');
      expect(originalState.error, ''); // Original unchanged
    });

    test('copyWith creates new state with both updated values', () {
      final originalState = SignupState();
      final newState = originalState.copyWith(
        status: SignupStatus.failure,
        error: 'Failure message',
      );

      expect(newState.status, SignupStatus.failure);
      expect(newState.error, 'Failure message');
      expect(originalState.status, SignupStatus.initial); // Original unchanged
      expect(originalState.error, ''); // Original unchanged
    });

    test('copyWith returns same state when no parameters provided', () {
      final originalState = SignupState(
        status: SignupStatus.success,
        error: 'Success message',
      );
      final newState = originalState.copyWith();

      expect(newState.status, SignupStatus.success);
      expect(newState.error, 'Success message');
    });

    test('copyWith with null values keeps original values', () {
      final originalState = SignupState(
        status: SignupStatus.failure,
        error: 'Error message',
      );
      final newState = originalState.copyWith(
        status: null,
        error: null,
      );

      expect(newState.status, SignupStatus.failure);
      expect(newState.error, 'Error message');
    });
  });

  group('SignupStatus enum', () {
    test('has all expected values', () {
      expect(SignupStatus.values, containsAll([
        SignupStatus.initial,
        SignupStatus.loading,
        SignupStatus.success,
        SignupStatus.failure,
      ]));
    });

    test('initial is the first value', () {
      expect(SignupStatus.values.first, SignupStatus.initial);
    });

    test('failure is the last value', () {
      expect(SignupStatus.values.last, SignupStatus.failure);
    });
  });
} 