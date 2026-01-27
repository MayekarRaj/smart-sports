import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../config/api_config.dart';
import '../constants/api_endpoints.dart';
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
    bool isMultipart = false,
  }) async {
    final headers = <String, String>{
      if (!isMultipart) 'Content-Type': 'application/json',
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
      final responseData = response.body.isEmpty
          ? {}
          : json.decode(response.body);

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
          if (responseData.containsKey('email') &&
              responseData['email'] is List) {
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

  /// Auth status stream to notify app about force logout
  // Using broadcast stream so multiple listeners can subscribe (e.g. main app, view models)
  // Emits false when user should be logged out
  final _authStatusController = StreamController<bool>.broadcast();
  Stream<bool> get authStatusStream => _authStatusController.stream;

  // Refresh token lock
  bool _isRefreshing = false;

  /// Internal method to execute HTTP requests with automatic token refresh
  Future<ApiResponse<T>> _performRequest<T>(
    Future<http.Response> Function() requestBuilder,
    T Function(dynamic)? fromJson,
  ) async {
    try {
      final response = await requestBuilder();

      // Check for 401 Unauthorized
      if (response.statusCode == 401) {
        // If we are already refreshing, we can't retry immediately without complex queuing.
        // For simplicity and safety, if a 401 happens while refreshing, we assume failure.
        // OR better: if we are not refreshing, try to refresh.

        if (!_isRefreshing) {
          _isRefreshing = true;
          try {
            final refreshed = await _refreshToken();
            _isRefreshing = false;

            if (refreshed) {
              // Retry original request
              final retryResponse = await requestBuilder();
              // If it fails again with 401, we give up and let _handleResponse throw
              return _handleResponse<T>(retryResponse, fromJson);
            }
          } catch (e) {
            _isRefreshing = false;
            // Refresh failed - Force Logout
            await clearAuthToken();
            _authStatusController.add(false);
          }
        }

        // If we couldn't refresh or refresh failed, the original 401 response will be handled,
        // likely resulting in an error.
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

  /// Try to refresh the token
  Future<bool> _refreshToken() async {
    try {
      // Direct call to refresh endpoint to avoid circular dependencies with AuthRepository
      // and to avoid using _performRequest (recursion)

      // We essentially manually reconstruct a simplistic POST request
      final uri = Uri.parse(ApiEndpoints.getRefreshTokenUrl());

      if (ApiConfig.enableRequestLogging) {
        print('🔄 Refreshing Token...');
      }

      // Refresh usually doesn't need the expired bearer token if it's a public endpoint,
      // OR it needs the expired token.
      // Based on AuthRepository.refreshToken calling with requiresAuth: false,
      // it seems to be public or cookie-based?
      // Wait, if it handles "current user", it typically needs a token.
      // If the API endpoint is unprotected, it can't identify the user unless
      // there is a separate "refresh_token" string sent in body.
      // But the current impl sends empty body {}.
      // Let's assume it MIGHT expect the expired token, so we'll try sending it if available.
      // If requiresAuth: false in Repo meant "don't fail if no token", then we are fine.

      final currentToken = await _getAuthToken();
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (currentToken != null) 'Authorization': 'Bearer $currentToken',
      };

      final response = await _client
          .post(uri, headers: headers, body: '{}')
          .timeout(ApiConfig.connectTimeout);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseData = json.decode(response.body);
        if (responseData['success'] == true && responseData['data'] != null) {
          final newToken = responseData['data']['token'];
          if (newToken != null && newToken.isNotEmpty) {
            await saveAuthToken(newToken);
            if (ApiConfig.enableRequestLogging) {
              print('✅ Token Refreshed Successfully');
            }
            return true;
          }
        }
      }

      if (ApiConfig.enableRequestLogging) {
        print('❌ Token Refresh Failed: ${response.statusCode}');
      }
      return false;
    } catch (e) {
      if (ApiConfig.enableRequestLogging) {
        print('❌ Token Refresh Error: $e');
      }
      return false;
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
    return _performRequest(() async {
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

      return response;
    }, fromJson);
  }

  /// Generic POST request
  Future<ApiResponse<T>> post<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    T Function(dynamic)? fromJson,
    bool requiresAuth = true,
    Map<String, String>? headers,
  }) async {
    return _performRequest(() async {
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

      return response;
    }, fromJson);
  }

  /// POST request with multipart/form-data support for file uploads
  ///
  /// [fields] - Map of form fields (String keys and values)
  /// [files] - Map of file fields where key is the field name and value is File object
  /// [fileFieldName] - Optional field name for single file upload (if files map is not used)
  /// [file] - Optional single File object (if fileFieldName is provided)
  Future<ApiResponse<T>> postMultipart<T>(
    String endpoint, {
    Map<String, String>? fields,
    Map<String, File>? files,
    String? fileFieldName,
    File? file,
    T Function(dynamic)? fromJson,
    bool requiresAuth = true,
    Map<String, String>? additionalHeaders,
  }) async {
    return _performRequest(() async {
      final uri = Uri.parse(endpoint);
      final request = http.MultipartRequest('POST', uri);

      // Build headers (without Content-Type, as multipart sets it automatically)
      final headers = await _buildHeaders(
        additionalHeaders: additionalHeaders,
        requiresAuth: requiresAuth,
        isMultipart: true,
      );
      request.headers.addAll(headers);

      // Add form fields
      if (fields != null) {
        request.fields.addAll(fields);
      }

      // Add files
      if (files != null) {
        for (final entry in files.entries) {
          final fileField = entry.key;
          final fileToUpload = entry.value;

          if (await fileToUpload.exists()) {
            final fileStream = http.ByteStream(fileToUpload.openRead());
            final fileLength = await fileToUpload.length();
            final fileName = fileToUpload.path.split('/').last;
            final contentType = _getContentType(fileName);

            final multipartFile = http.MultipartFile(
              fileField,
              fileStream,
              fileLength,
              filename: fileName,
              contentType: contentType,
            );
            request.files.add(multipartFile);
          }
        }
      }

      // Handle single file upload (legacy support)
      if (fileFieldName != null && file != null) {
        if (await file.exists()) {
          final fileStream = http.ByteStream(file.openRead());
          final fileLength = await file.length();
          final fileName = file.path.split('/').last;
          final contentType = _getContentType(fileName);

          final multipartFile = http.MultipartFile(
            fileFieldName,
            fileStream,
            fileLength,
            filename: fileName,
            contentType: contentType,
          );
          request.files.add(multipartFile);
        }
      }

      if (ApiConfig.enableRequestLogging) {
        print('🚀 POST (Multipart) $uri');
        print('📤 Headers: ${request.headers}');
        print('📤 Fields: ${request.fields}');
        print('📤 Files: ${request.files.map((f) => f.filename).join(", ")}');
      }

      final streamedResponse = await _client
          .send(request)
          .timeout(ApiConfig.connectTimeout);

      final response = await http.Response.fromStream(streamedResponse);

      if (ApiConfig.enableRequestLogging) {
        print('📥 Status: ${response.statusCode}');
        print('📥 Body: ${response.body}');
      }

      return response;
    }, fromJson);
  }

  /// Get content type based on file extension
  MediaType _getContentType(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return MediaType('image', 'jpeg');
      case 'png':
        return MediaType('image', 'png');
      case 'gif':
        return MediaType('image', 'gif');
      case 'pdf':
        return MediaType('application', 'pdf');
      case 'webp':
        return MediaType('image', 'webp');
      default:
        return MediaType('application', 'octet-stream');
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
    return _performRequest(() async {
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

      return response;
    }, fromJson);
  }

  /// Generic DELETE request
  Future<ApiResponse<T>> delete<T>(
    String endpoint, {
    T Function(dynamic)? fromJson,
    bool requiresAuth = true,
    Map<String, String>? headers,
  }) async {
    return _performRequest(() async {
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

      return response;
    }, fromJson);
  }

  /// Dispose resources
  void dispose() {
    _client.close();
    _authStatusController.close();
  }
}
