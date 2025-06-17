enum SignupStatus { initial, loading, success, failure }

class SignupState {
  final SignupStatus status;
  final String? error;

  SignupState({this.status = SignupStatus.initial, this.error});

  SignupState copyWith({SignupStatus? status, String? error}) {
    return SignupState(
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }
}
