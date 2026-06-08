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
      '315455377221-0et6hdd2nrd1ug6v0ao1n472isi259rc.apps.googleusercontent.com';

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

    await signIn.signOut();
    final account = await signIn.authenticate();
    final authentication = account.authentication;

    return GoogleOAuthResult(
      name: account.displayName ?? account.email.split('@').first,
      email: account.email,
      idToken: authentication.idToken,
    );
  }
}
