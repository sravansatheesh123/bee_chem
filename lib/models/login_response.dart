class LoginResponse {
  final bool status;
  final String? accessToken;
  final String? message;

  LoginResponse({
    required this.status,
    this.accessToken,
    this.message,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      status: json['status'] ?? false,
      accessToken: json['access_token'],
      message: json['message'],
    );
  }
}
