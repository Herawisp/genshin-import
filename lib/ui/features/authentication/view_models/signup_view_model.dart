import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:genshin_import/data/services/auth_api_service.dart';
import 'package:genshin_import/data/services/google_oauth_service.dart';

class SignupViewModel extends ChangeNotifier {
  final AuthApiService _authApiService;
  final GoogleOAuthService _googleOAuthService;

  SignupViewModel({
    AuthApiService? authApiService,
    GoogleOAuthService? googleOAuthService,
  }) : _authApiService = authApiService ?? AuthApiService(),
       _googleOAuthService = googleOAuthService ?? GoogleOAuthService();

  String? _errorMessage;
  bool _isLoading = false;

  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  Future<bool> register({
    required String email,
    required String password,
  }) async {
    final trimmedEmail = email.trim();

    if (trimmedEmail.isEmpty) {
      _setErrorMessage('Email is required');
      return false;
    }

    if (password.isEmpty) {
      _setErrorMessage('Password is required');
      return false;
    }

    _setLoading(true);
    _setErrorMessage(null);

    try {
      await _authApiService.register(
        name: _generateRandomName(),
        email: trimmedEmail,
        password: password,
      );
      return true;
    } on AuthApiException catch (error) {
      _setErrorMessage(error.message);
      return false;
    } catch (_) {
      _setErrorMessage('Unable to connect to server');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> registerWithGoogle() async {
    _setLoading(true);
    _setErrorMessage(null);

    try {
      final googleUser = await _googleOAuthService.signIn();

      await _authApiService.googleOAuth(
        name: googleUser.name,
        email: googleUser.email,
        idToken: googleUser.idToken,
      );
      return true;
    } on AuthApiException catch (error) {
      _setErrorMessage(error.message);
      return false;
    } catch (error) {
      debugPrint('Google signup failed: $error');
      _setErrorMessage('Google signup failed');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  String _generateRandomName() {
    final number = Random().nextInt(90000000) + 10000000;
    return 'user$number';
  }

  void _setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
