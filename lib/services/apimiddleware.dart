import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiMiddleware {
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
  };

  static Future<dynamic> get(String url, {Map<String, String>? headers}) async {
    final mergedHeaders = {...defaultHeaders, ...?headers};

    try {
      final response = await http.get(Uri.parse(url), headers: mergedHeaders);
      return _handleResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  static dynamic _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    final body = response.body;

    if (statusCode >= 200 && statusCode < 300) {
      return jsonDecode(body);
    } else {
      final errorMsg = _parseError(body);
      throw Exception("Error $statusCode: $errorMsg");
    }
  }

  static String _parseError(String body) {
    try {
      final json = jsonDecode(body);
      return json['message'] ?? json['error'] ?? 'Unknown error';
    } catch (_) {
      return body;
    }
  }
}
