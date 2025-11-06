// DEPRECATED: This file is kept for backward compatibility
// Use NetworkClient and Repositories instead
//
// Migration guide:
// - Old: ApiService().signIn(request)
// - New: AuthRepository().signIn(request) or AuthService().signIn(email, password)
//
// This file will be removed in a future version

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_endpoints.dart';
import '../models/api_models.dart';
import '../models/api_response.dart';
import '../network/network_client.dart';
import '../repositories/auth_repository.dart';
import '../services/storage_service.dart';

/// @deprecated Use AuthRepository or AuthService instead
/// This class is maintained for backward compatibility only
@Deprecated('Use AuthRepository or AuthService instead')
class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final NetworkClient _networkClient = NetworkClient();
  final AuthRepository _authRepository = AuthRepository();

  /// @deprecated Use AuthRepository.signIn() or AuthService.signIn() instead
  @Deprecated('Use AuthRepository.signIn() or AuthService.signIn() instead')
  Future<ApiResponse<SignInResponse>> signIn(SignInRequest request) async {
    try {
      final response = await _authRepository.signIn(request);
      return ApiResponse.success(data: response);
    } on Exception catch (e) {
      return ApiResponse.error(message: e.toString());
    }
  }

  /// @deprecated Use AuthRepository.signUp() or AuthService.signUp() instead
  @Deprecated('Use AuthRepository.signUp() or AuthService.signUp() instead')
  Future<ApiResponse<SignUpResponse>> signUp(SignUpRequest request) async {
    try {
      final response = await _authRepository.signUp(request);
      return ApiResponse.success(data: response);
    } on Exception catch (e) {
      return ApiResponse.error(message: e.toString());
    }
  }

  /// @deprecated Use AuthRepository.getProfile() instead
  @Deprecated('Use AuthRepository.getProfile() instead')
  Future<ApiResponse<UserProfile>> getProfile(int userId) async {
    try {
      final profile = await _authRepository.getProfile(userId);
      return ApiResponse.success(data: profile);
    } on Exception catch (e) {
      return ApiResponse.error(message: e.toString());
    }
  }

  /// @deprecated Use ClubRepository instead
  @Deprecated('Use ClubRepository instead')
  Future<ApiResponse<ClubSignupResponse>> clubSignupStep1(
    ClubSignupStep1Request request,
  ) async {
    return ApiResponse.error(
      message: 'Use ClubRepository instead',
    );
  }

  /// @deprecated Use ClubRepository instead
  @Deprecated('Use ClubRepository instead')
  Future<ApiResponse<ClubSignupResponse>> clubSignupStep2(
    ClubSignupStep2Request request,
  ) async {
    return ApiResponse.error(
      message: 'Use ClubRepository instead',
    );
  }

  /// @deprecated Use AuthRepository.logout() or AuthService.logout() instead
  @Deprecated('Use AuthRepository.logout() or AuthService.logout() instead')
  Future<void> logout() async {
    await _authRepository.logout();
  }

  /// @deprecated Use AuthService.isAuthenticated() instead
  @Deprecated('Use AuthService.isAuthenticated() instead')
  Future<bool> get isAuthenticated async {
    final storageService = StorageService();
    final token = await storageService.getString('auth_token');
    return token != null && token.isNotEmpty;
  }
}
