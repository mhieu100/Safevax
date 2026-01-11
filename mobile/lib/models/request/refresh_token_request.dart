class RefreshTokenRequest {
  final String? refreshToken;

  RefreshTokenRequest({
    this.refreshToken,
  });

  Map<String, dynamic> toJson() => {
        'refreshToken': refreshToken,
      };
}
