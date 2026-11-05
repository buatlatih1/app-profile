import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import '../localization/locale_provider.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final Map<String, dynamic>? errors;

  ApiException(this.message, {this.statusCode, this.errors});

  @override
  String toString() => message;
}

class ApiClient {
  final LocaleProvider localeProvider;
  final http.Client _httpClient;

  ApiClient({
    required this.localeProvider,
    http.Client? httpClient,
  }) : _httpClient = httpClient ?? http.Client();

  Map<String, String> get _headers {
    final lang = localeProvider.languageCode;
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Accept-Language': lang,
    };
  }

  Uri _buildUri(String endpoint, [Map<String, dynamic>? queryParameters]) {
    final base = ApiConstants.baseUrl;
    final cleanEndpoint = endpoint.startsWith('/') ? endpoint : '/$endpoint';
    final fullUrl = '$base$cleanEndpoint';

    final params = Map<String, dynamic>.from(queryParameters ?? {});
    // Always attach lang parameter as well for query-based locale resolution
    params['lang'] = localeProvider.languageCode;

    // Convert values to string for Uri
    final stringParams = params.map((key, value) => MapEntry(key, value.toString()));

    final baseUri = Uri.parse(fullUrl);
    return baseUri.replace(
      queryParameters: {
        ...baseUri.queryParameters,
        ...stringParams,
      },
    );
  }

  /// Sends a GET request
  Future<dynamic> get(String endpoint, {Map<String, dynamic>? queryParameters}) async {
    try {
      final uri = _buildUri(endpoint, queryParameters);
      final response = await _httpClient.get(uri, headers: _headers);

      return _processResponse(response);
    } on http.ClientException {
      throw ApiException(
        localeProvider.languageCode == 'en'
            ? 'Cannot connect to backend server. Please verify the API is running at ${ApiConstants.baseUrl}'
            : 'Tidak dapat terhubung ke server. Pastikan API backend aktif di ${ApiConstants.baseUrl}',
      );
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(e.toString());
    }
  }

  /// Sends a POST request
  Future<dynamic> post(String endpoint, {Map<String, dynamic>? body}) async {
    try {
      final uri = _buildUri(endpoint);
      final response = await _httpClient.post(
        uri,
        headers: _headers,
        body: body != null ? jsonEncode(body) : null,
      );

      return _processResponse(response);
    } on http.ClientException {
      throw ApiException(
        localeProvider.languageCode == 'en'
            ? 'Cannot connect to server. Please check your network connection.'
            : 'Gagal terhubung ke server backend.',
      );
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(e.toString());
    }
  }

  dynamic _processResponse(http.Response response) {
    dynamic decoded;
    try {
      decoded = jsonDecode(utf8.decode(response.bodyBytes));
    } catch (_) {
      decoded = null;
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return decoded;
    }

    String message = 'Request failed (${response.statusCode})';
    Map<String, dynamic>? errors;

    if (decoded is Map<String, dynamic>) {
      if (decoded['message'] != null) {
        message = decoded['message'].toString();
      }
      if (decoded['errors'] is Map<String, dynamic>) {
        errors = decoded['errors'] as Map<String, dynamic>;
        // If message is generic validation error, extract first detail
        final firstError = errors.values.firstOrNull;
        if (firstError is List && firstError.isNotEmpty) {
          message = firstError.first.toString();
        }
      }
    }

    throw ApiException(
      message,
      statusCode: response.statusCode,
      errors: errors,
    );
  }

  /// Utility to resolve image URLs returned by Laravel with guaranteed CORS support
  static String? resolveImageUrl(String? rawUrl) {
    if (rawUrl == null || rawUrl.trim().isEmpty) return null;
    final trimmed = rawUrl.trim();

    // If points to local storage (either absolute http://.../storage/... or relative storage/...)
    // route it through the API storage proxy endpoint so CORS headers are always attached
    if (trimmed.contains('/storage/')) {
      final path = trimmed.split('/storage/').last;
      return '${ApiConstants.baseUrl}/storage/$path';
    }

    if (trimmed.startsWith('storage/')) {
      final path = trimmed.substring(8);
      return '${ApiConstants.baseUrl}/storage/$path';
    }

    // External image URLs
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return trimmed;
    }

    final clean = trimmed.startsWith('/') ? trimmed.substring(1) : trimmed;
    return '${ApiConstants.baseUrl}/storage/$clean';
  }
}
