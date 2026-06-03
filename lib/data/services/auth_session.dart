class AuthSession {
  static String? token;
  static Map<String, dynamic>? user;

  static bool get isLoggedIn => token != null;

  static Map<String, String> get authHeaders {
    final currentToken = token;

    if (currentToken == null) {
      return {};
    }

    return {
      'Authorization': 'Bearer $currentToken',
    };
  }

  static void save({
    required String newToken,
    required Map<String, dynamic> newUser,
  }) {
    token = newToken;
    user = newUser;
  }

  static void clear() {
    token = null;
    user = null;
  }
}
