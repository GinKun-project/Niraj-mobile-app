class LoginResponse {
  final String token;
  final String username;
  final String email;

  LoginResponse({
    required this.token,
    required this.username,
    required this.email,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'] ?? '', // fallback if null
      username: json['user']['username'] ?? '',
      email: json['user']['email'] ?? '',
    );
  }
}
