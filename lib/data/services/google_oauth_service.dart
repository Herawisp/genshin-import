import 'package:google_sign_in/google_sign_in.dart';

class GoogleOAuthResult {
  final String name;
  final String email;
  final String? idToken;

  const GoogleOAuthResult({
    required this.name,
    required this.email,
    required this.idToken,
  });
}

class GoogleOAuthService {
  static const String? _clientId = null;
  static const String _serverClientId =
      '145248357277-642g5gh6k7shq9h4ik302brfeeo72r46.apps.googleusercontent.com';

  bool _initialized = false;

  Future<GoogleOAuthResult> signIn() async {
    final signIn = GoogleSignIn.instance;

    if (!_initialized) {
      await signIn.initialize(
        clientId: _clientId,
        serverClientId: _serverClientId,
      );
      _initialized = true;
    }

    if (!signIn.supportsAuthenticate()) {
      throw Exception('Google Sign-In is not supported on this platform');
    }

    final account = await signIn.authenticate();
    final authentication = account.authentication;

    return GoogleOAuthResult(
      name: account.displayName ?? account.email.split('@').first,
      email: account.email,
      idToken: authentication.idToken,
    );
  }
}
