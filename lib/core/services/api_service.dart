import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api_endpoints.dart';
import '../models/api_models.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // Initialize auth token from storage
  Future<void> initializeAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token != null) {
      ApiConfig.authToken = token;
    }
  }

  // Save auth token to storage
  Future<void> saveAuthToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    ApiConfig.authToken = token;
  }

  // Clear auth token from storage
  Future<void> clearAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    ApiConfig.authToken = null;
  }

  // Generic HTTP request handler
  Future<ApiResponse<T>> _makeRequest<T>(
    String url,
    String method, {
    Map<String, dynamic>? body,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      http.Response response;

      switch (method.toUpperCase()) {
        case 'GET':
          response = await http.get(Uri.parse(url), headers: ApiConfig.headers);
          break;
        case 'POST':
          response = await http.post(
            Uri.parse(url),
            headers: ApiConfig.headers,
            body: body != null ? json.encode(body) : null,
          );
          break;
        case 'PUT':
          response = await http.put(
            Uri.parse(url),
            headers: ApiConfig.headers,
            body: body != null ? json.encode(body) : null,
          );
          break;
        case 'DELETE':
          response = await http.delete(
            Uri.parse(url),
            headers: ApiConfig.headers,
          );
          break;
        default:
          throw Exception('Unsupported HTTP method: $method');
      }

      final responseData = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return ApiResponse<T>(
          success: true,
          message: responseData['message'] ?? 'Success',
          data: fromJson != null ? fromJson(responseData) : responseData,
          statusCode: response.statusCode,
        );
      } else {
        return ApiResponse<T>(
          success: false,
          message: responseData['message'] ?? 'Request failed',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      return ApiResponse<T>(
        success: false,
        message: 'Network error: ${e.toString()}',
        statusCode: 0,
      );
    }
  }

  // Authentication Methods
  Future<ApiResponse<SignInResponse>> signIn(SignInRequest request) async {
    final response = await _makeRequest<SignInResponse>(
      ApiEndpoints.getSignInUrl(),
      'POST',
      body: request.toJson(),
      fromJson: (data) => SignInResponse.fromJson(data),
    );

    if (response.success && response.data != null) {
      await saveAuthToken(response.data!.token);
    }

    return response;
  }

  Future<ApiResponse<UserProfile>> getProfile(int userId) async {
    return await _makeRequest<UserProfile>(
      ApiEndpoints.getProfileUrl(userId),
      'GET',
      fromJson: (data) => UserProfile.fromJson(data),
    );
  }

  // Club Registration Methods
  Future<ApiResponse<ClubSignupResponse>> clubSignupStep1(
    ClubSignupStep1Request request,
  ) async {
    return await _makeRequest<ClubSignupResponse>(
      ApiEndpoints.getClubSignupStep1Url(),
      'POST',
      body: request.toJson(),
      fromJson: (data) => ClubSignupResponse.fromJson(data),
    );
  }

  Future<ApiResponse<ClubSignupResponse>> clubSignupStep2(
    ClubSignupStep2Request request,
  ) async {
    return await _makeRequest<ClubSignupResponse>(
      ApiEndpoints.getClubSignupStep2Url(),
      'POST',
      body: request.toJson(),
      fromJson: (data) => ClubSignupResponse.fromJson(data),
    );
  }

  // Logout method
  Future<void> logout() async {
    await clearAuthToken();
  }

  // Check if user is authenticated
  bool get isAuthenticated => ApiConfig.authToken != null;
}
