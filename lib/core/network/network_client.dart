import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../exceptions/api_exception.dart';
import '../models/api_response.dart';
import '../services/storage_service.dart';

/// Base network client with error handling, interceptors, and token management
/// Single source of truth for all HTTP requests
class NetworkClient {
  static final NetworkClient _instance = NetworkClient._internal();
  factory NetworkClient() => _instance;
  NetworkClient._internal();

  final http.Client _client = http.Client();
  final StorageService _storageService = StorageService();
  
  /// Get authentication token from storage
  Future<String?> _getAuthToken() async {
    final token = await _storageService.getString('auth_token');
    return token ?? ApiConfig.authToken;
  }

  /// Save authentication token to storage
  Future<void> saveAuthToken(String token) async {
    await _storageService.saveString('auth_token', token);
    ApiConfig.authToken = token;
  }

  /// Clear authentication token
  Future<void> clearAuthToken() async {
    await _storageService.remove('auth_token');
    ApiConfig.authToken = null;
  }

  /// Build headers with authentication token
  Future<Map<String, String>> _buildHeaders({
    Map<String, String>? additionalHeaders,
    bool requiresAuth = true,
  }) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      ...?additionalHeaders,
    };

    if (requiresAuth) {
      final token = await _getAuthToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  /// Handle HTTP response and convert to ApiResponse
  ApiResponse<T> _handleResponse<T>(
    http.Response response,
    T Function(dynamic)? fromJson,
  ) {
    try {
      final responseData = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return ApiResponse<T>(
          success: true,
          message: responseData['message'] ?? 'Success',
          data: fromJson != null && responseData['data'] != null
              ? fromJson(responseData['data'])
              : fromJson != null
                  ? fromJson(responseData)
                  : responseData as T,
          statusCode: response.statusCode,
        );
      } else {
        // Handle validation errors (e.g., email already taken)
        String errorMessage = 'Request failed';
        Map<String, dynamic>? errors;
        
        if (responseData is Map<String, dynamic>) {
          // Check for validation errors (e.g., {"email": ["The email has already been taken."]})
          if (responseData.containsKey('email') && responseData['email'] is List) {
            final emailErrors = responseData['email'] as List;
            if (emailErrors.isNotEmpty) {
              errorMessage = emailErrors.first.toString();
            }
            errors = responseData;
          } else if (responseData.containsKey('message')) {
            errorMessage = responseData['message'] as String;
          } else if (responseData.containsKey('error')) {
            errorMessage = responseData['error'] as String;
          }
        }
        
        throw ApiException(
          message: errorMessage,
          statusCode: response.statusCode,
          errors: errors,
        );
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        message: 'Failed to parse response: ${e.toString()}',
        statusCode: response.statusCode,
      );
    }
  }

  /// Generic GET request
  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, String>? queryParameters,
    T Function(dynamic)? fromJson,
    bool requiresAuth = true,
    Map<String, String>? headers,
  }) async {
    try {
      var uri = Uri.parse(endpoint);
      if (queryParameters != null && queryParameters.isNotEmpty) {
        uri = uri.replace(queryParameters: queryParameters);
      }

      final requestHeaders = await _buildHeaders(
        additionalHeaders: headers,
        requiresAuth: requiresAuth,
      );

      if (ApiConfig.enableRequestLogging) {
        print('🚀 GET $uri');
        print('📤 Headers: $requestHeaders');
      }

      final response = await _client
          .get(uri, headers: requestHeaders)
          .timeout(ApiConfig.connectTimeout);

      if (ApiConfig.enableRequestLogging) {
        print('📥 Status: ${response.statusCode}');
        print('📥 Body: ${response.body}');
      }

      return _handleResponse<T>(response, fromJson);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Network error: ${e.toString()}',
        statusCode: 0,
      );
    }
  }

  /// Generic POST request
  Future<ApiResponse<T>> post<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    T Function(dynamic)? fromJson,
    bool requiresAuth = true,
    Map<String, String>? headers,
  }) async {
    try {
      final uri = Uri.parse(endpoint);
      final requestHeaders = await _buildHeaders(
        additionalHeaders: headers,
        requiresAuth: requiresAuth,
      );

      if (ApiConfig.enableRequestLogging) {
        print('🚀 POST $uri');
        print('📤 Headers: $requestHeaders');
        if (body != null) {
          print('📤 Body: ${json.encode(body)}');
        }
      }

      final response = await _client
          .post(
            uri,
            headers: requestHeaders,
            body: body != null ? json.encode(body) : null,
          )
          .timeout(ApiConfig.connectTimeout);

      if (ApiConfig.enableRequestLogging) {
        print('📥 Status: ${response.statusCode}');
        print('📥 Body: ${response.body}');
      }

      return _handleResponse<T>(response, fromJson);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Network error: ${e.toString()}',
        statusCode: 0,
      );
    }
  }

  /// Generic PUT request
  Future<ApiResponse<T>> put<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    T Function(dynamic)? fromJson,
    bool requiresAuth = true,
    Map<String, String>? headers,
  }) async {
    try {
      final uri = Uri.parse(endpoint);
      final requestHeaders = await _buildHeaders(
        additionalHeaders: headers,
        requiresAuth: requiresAuth,
      );

      if (ApiConfig.enableRequestLogging) {
        print('🚀 PUT $uri');
        print('📤 Headers: $requestHeaders');
        if (body != null) {
          print('📤 Body: ${json.encode(body)}');
        }
      }

      final response = await _client
          .put(
            uri,
            headers: requestHeaders,
            body: body != null ? json.encode(body) : null,
          )
          .timeout(ApiConfig.connectTimeout);

      if (ApiConfig.enableRequestLogging) {
        print('📥 Status: ${response.statusCode}');
        print('📥 Body: ${response.body}');
      }

      return _handleResponse<T>(response, fromJson);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Network error: ${e.toString()}',
        statusCode: 0,
      );
    }
  }

  /// Generic DELETE request
  Future<ApiResponse<T>> delete<T>(
    String endpoint, {
    T Function(dynamic)? fromJson,
    bool requiresAuth = true,
    Map<String, String>? headers,
  }) async {
    try {
      final uri = Uri.parse(endpoint);
      final requestHeaders = await _buildHeaders(
        additionalHeaders: headers,
        requiresAuth: requiresAuth,
      );

      if (ApiConfig.enableRequestLogging) {
        print('🚀 DELETE $uri');
        print('📤 Headers: $requestHeaders');
      }

      final response = await _client
          .delete(uri, headers: requestHeaders)
          .timeout(ApiConfig.connectTimeout);

      if (ApiConfig.enableRequestLogging) {
        print('📥 Status: ${response.statusCode}');
        print('📥 Body: ${response.body}');
      }

      return _handleResponse<T>(response, fromJson);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Network error: ${e.toString()}',
        statusCode: 0,
      );
    }
  }

  /// Dispose resources
  void dispose() {
    _client.close();
  }
}

