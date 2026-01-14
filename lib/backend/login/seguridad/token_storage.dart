class TokenStorage {
  String? _accessToken;
  String? _refreshToken;

  // Access token
  void saveAccessToken(String token) {
    _accessToken = token;
  }

  String? get accessToken => _accessToken;

  // Refresh token
  void saveRefreshToken(String token) {
    _refreshToken = token;
  }

  String? get refreshToken => _refreshToken;

  void clear() {
    _accessToken = null;
    _refreshToken = null;
  }
}

final TokenStorage tokenStorage = TokenStorage();
