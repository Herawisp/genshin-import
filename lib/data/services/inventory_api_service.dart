import 'dart:convert';

import 'package:genshin_import/data/models/inventory_item.dart';
import 'package:genshin_import/data/services/api_config.dart';
import 'package:genshin_import/data/services/auth_session.dart';
import 'package:http/http.dart' as http;

class InventoryApiException implements Exception {
  final String message;

  const InventoryApiException(this.message);

  @override
  String toString() => message;
}

class InventoryApiService {
  Future<InventoryResult> getInventory() async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/inventory'),
      headers: AuthSession.authHeaders,
    );

    final body = _decodeBody(response);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw InventoryApiException(_extractErrorMessage(body));
    }

    final data = body['data'];

    if (data is Map<String, dynamic>) {
      return InventoryResult.fromJson(data);
    }

    throw const InventoryApiException('Invalid inventory response from server');
  }

  Future<void> deleteInventoryItem({
    required int itemId,
    required int quantity,
  }) async {
    final response = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}/inventory/$itemId'),
      headers: {...AuthSession.authHeaders, 'Content-Type': 'application/json'},
      body: jsonEncode({'quantity': quantity}),
    );

    final body = _decodeBody(response);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw InventoryApiException(_extractErrorMessage(body));
    }
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

    return 'Unable to load inventory';
  }
}
