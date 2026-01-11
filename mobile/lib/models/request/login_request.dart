class LoginRequest {
  final String username;
  final String password;
  final int? expiresInMins;

  LoginRequest({
    required this.username,
    required this.password,
    this.expiresInMins,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'username': username,
      'password': password,
    };
    if (expiresInMins != null) {
      data["expiresInMins"] = expiresInMins;
    }
    return data;
  }
}
