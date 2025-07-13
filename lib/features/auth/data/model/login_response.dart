class LoginResponse {
  final String token;
  final String username;
  final String email;

  LoginResponse({
    required this.token,
    required this.username,
    required this.email,
  });

  factory LoginResponse.fromJson(Map<String, dynamic>? json) {
    final user = json?['user'] as Map<String, dynamic>?;

    return LoginResponse(
      token: json?['token'] ?? '',
      username: user?['username'] ?? '',
      email: user?['email'] ?? '',
    );
  }

  toJson() {}
}
