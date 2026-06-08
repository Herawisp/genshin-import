import 'package:flutter/foundation.dart';
import 'package:genshin_import/data/services/auth_api_service.dart';

class ForgotPasswordViewModel extends ChangeNotifier {
  final AuthApiService _authApiService;

  ForgotPasswordViewModel({AuthApiService? authApiService})
    : _authApiService = authApiService ?? AuthApiService();

  String? _errorMessage;
  bool _isLoading = false;

  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  Future<bool> sendPasswordReset(String email) async {
    final trimmedEmail = email.trim();

    if (trimmedEmail.isEmpty) {
      _setErrorMessage('Email is required');
      return false;
    }

    _setLoading(true);
    _setErrorMessage(null);

    try {
      await _authApiService.forgotPassword(email: trimmedEmail);
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

  void _setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
