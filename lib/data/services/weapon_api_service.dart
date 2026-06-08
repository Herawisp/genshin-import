import 'dart:convert';

import 'package:genshin_import/data/models/weapon.dart';
import 'package:genshin_import/data/services/api_config.dart';
import 'package:genshin_import/data/services/auth_session.dart';
import 'package:http/http.dart' as http;

class WeaponApiException implements Exception {
  final String message;

  const WeaponApiException(this.message);

  @override
  String toString() => message;
}

class WeaponApiService {
  Future<List<Weapon>> getWeapons() async {
    final response = await http.get(Uri.parse('${ApiConfig.baseUrl}/weapons'));

    return _parseWeaponListResponse(response);
  }

  Future<List<Weapon>> getAdminWeapons() async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/weapons/admin'),
      headers: _authHeaders(),
    );

    return _parseWeaponListResponse(response);
  }

  List<Weapon> _parseWeaponListResponse(http.Response response) {
    final body = _decodeBody(response);

    if (!_isSuccess(response)) {
      throw WeaponApiException(_extractErrorMessage(body));
    }

    final data = body['data'];

    if (data is List) {
      return data
          .whereType<Map<String, dynamic>>()
          .map(Weapon.fromJson)
          .toList();
    }

    throw const WeaponApiException('Invalid weapons response from server');
  }

  Future<Weapon> getWeapon(int id) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/weapons/$id'),
    );

    final body = _decodeBody(response);

    if (!_isSuccess(response)) {
      throw WeaponApiException(_extractErrorMessage(body));
    }

    final data = body['data'];

    if (data is Map<String, dynamic>) {
      return Weapon.fromJson(data);
    }

    if (_looksLikeWeapon(body)) {
      return Weapon.fromJson(body);
    }

    throw const WeaponApiException('Invalid weapon response from server');
  }

  Future<void> createWeapon(Weapon weapon) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/weapons'),
      headers: _jsonHeaders(),
      body: jsonEncode(weapon.toRequestJson()),
    );

    _throwIfFailed(response);
  }

  Future<void> updateWeapon(Weapon weapon) async {
    final response = await http.put(
      Uri.parse('${ApiConfig.baseUrl}/weapons/${weapon.id}'),
      headers: _jsonHeaders(),
      body: jsonEncode(weapon.toRequestJson()),
    );

    _throwIfFailed(response);
  }

  Future<void> deleteWeapon(int id) async {
    final response = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}/weapons/$id'),
      headers: _authHeaders(),
    );

    _throwIfFailed(response);
  }

  Future<void> updateWeaponVisibility({
    required int id,
    required bool isHidden,
  }) async {
    final response = await http.patch(
      Uri.parse('${ApiConfig.baseUrl}/weapons/$id/visibility'),
      headers: _jsonHeaders(),
      body: jsonEncode({'isHidden': isHidden}),
    );

    _throwIfFailed(response);
  }

  Future<void> buyWeapon({required int id, required int quantity}) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/weapons/$id/buy'),
      headers: _jsonHeaders(),
      body: jsonEncode({'quantity': quantity}),
    );

    _throwIfFailed(response);
  }

  void _throwIfFailed(http.Response response) {
    final body = _decodeBody(response);

    if (!_isSuccess(response)) {
      throw WeaponApiException(_extractErrorMessage(body));
    }
  }

  Map<String, String> _jsonHeaders() {
    return {'Content-Type': 'application/json', ...AuthSession.authHeaders};
  }

  Map<String, String> _authHeaders() {
    return {...AuthSession.authHeaders};
  }

  Map<String, dynamic> _decodeBody(http.Response response) {
    if (response.body.isEmpty) {
      return {};
    }

    try {
      final decoded = jsonDecode(response.body);

      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
    } catch (_) {
      // Fall through to a generic error below.
    }

    return {'message': 'Invalid response from server'};
  }

  bool _isSuccess(http.Response response) {
    return response.statusCode >= 200 && response.statusCode < 300;
  }

  bool _looksLikeWeapon(Map<String, dynamic> body) {
    return body.containsKey('id') &&
        body.containsKey('name') &&
        body.containsKey('type') &&
        body.containsKey('description');
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

    return 'Request failed';
  }
}
