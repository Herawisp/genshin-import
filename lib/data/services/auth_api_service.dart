import 'dart:convert';

import 'package:genshin_import/data/services/api_config.dart';
import 'package:genshin_import/data/services/auth_session.dart';
import 'package:http/http.dart' as http;

class AuthApiException implements Exception {
  final String message;

  const AuthApiException(this.message);

  @override
  String toString() => message;
}

class AuthApiService {
  static const _headers = {
    'Content-Type': 'application/json',
  };

  Future<void> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/auth/login'),
      headers: _headers,
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    _saveSessionOrThrow(response);
  }

  Future<void> googleOAuth({
    required String name,
    required String email,
    String? idToken,
  }) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/auth/oauth/google'),
      headers: _headers,
      body: jsonEncode({
        'name': name,
        'email': email,
        if (idToken != null) 'idToken': idToken,
      }),
    );

    _saveSessionOrThrow(response);
  }

  void _saveSessionOrThrow(http.Response response) {
    final Map<String, dynamic> body = _decodeBody(response);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw AuthApiException(_extractErrorMessage(body));
    }

    final token = body['token'];
    final user = body['user'];

    if (token is! String || user is! Map<String, dynamic>) {
      throw const AuthApiException('Invalid auth response from server');
    }

    AuthSession.save(
      newToken: token,
      newUser: user,
    );
  }

  Map<String, dynamic> _decodeBody(http.Response response) {
    try {
      final decoded = jsonDecode(response.body);

      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
    } catch (_) {
      // Fall through to a generic error below.
    }

    return {
      'message': 'Invalid response from server',
    };
  }

  String _extractErrorMessage(Map<String, dynamic> body) {
    final errors = body['errors'];

    if (errors is Map && errors.isNotEmpty) {
      final firstError = errors.values.first;

      if (firstError is String) {
        return firstError;
      }
    }

    final message = body['message'];

    if (message is String && message.isNotEmpty) {
      return message;
    }

    return 'Authentication failed';
  }
}
