import '../repositories/auth_repository.dart';
import '../models/api_models.dart';
import 'storage_service.dart';
import '../config/api_config.dart';

/// Authentication service - Business logic layer
/// Provides high-level authentication operations
/// Uses AuthRepository for API calls and StorageService for persistence
class AuthService {
  final AuthRepository _authRepository = AuthRepository();
  final StorageService _storageService = StorageService();

  /// Sign in user
  Future<SignInResponse> signIn({
    required String email,
    required String password,
    bool keepMeLoggedIn = false,
  }) async {
    final request = SignInRequest(
      email: email,
      password: password,
      keepMeLoggedIn: keepMeLoggedIn ? 'true' : 'false',
    );
    final response = await _authRepository.signIn(request);
    
    // Token is automatically saved by AuthRepository via NetworkClient
    // But we also save user info for quick access
    if (response.accessToken.isNotEmpty) {
      await _storageService.saveString('user_email', email);
      await _storageService.saveString('user_id', response.user.id.toString());
    }
    
    return response;
  }

  /// Sign up user
  Future<SignUpResponse> signUp(SignUpRequest request) async {
    final response = await _authRepository.signUp(request);
    
    // Save user info
    if (response.accessToken.isNotEmpty) {
      await _storageService.saveString('user_email', request.email);
      await _storageService.saveString('user_id', response.userId.toString());
    }
    
    return response;
  }

  /// Send OTP to email
  Future<void> sendOtp(String email) async {
    await _authRepository.sendOtp(email);
  }

  /// Verify OTP
  Future<void> verifyOtp(String email, String otp) async {
    await _authRepository.verifyOtp(email, otp);
  }

  /// Forgot password
  Future<void> forgotPassword(String email) async {
    await _authRepository.forgotPassword(email);
  }

  /// Reset password
  Future<void> resetPassword({
    required String token,
    required String newPassword,
    required String confirmPassword,
  }) async {
    await _authRepository.resetPassword(
      token: token,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );
  }

  /// Change password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    await _authRepository.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );
  }

  /// Logout user
  Future<void> logout() async {
    try {
      await _authRepository.logout();
    } finally {
      // Clear local storage
      await _storageService.remove('user_email');
      await _storageService.remove('user_id');
      await _storageService.remove('auth_token');
    }
  }

  /// Get user profile
  Future<UserProfile> getProfile(int userId) async {
    return await _authRepository.getProfile(userId);
  }

  /// Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final token = await _storageService.getString('auth_token');
    return token != null && token.isNotEmpty;
  }

  /// Get stored user email
  Future<String?> getStoredEmail() async {
    return await _storageService.getString('user_email');
  }

  /// Get stored user ID
  Future<int?> getStoredUserId() async {
    final idStr = await _storageService.getString('user_id');
    return idStr != null ? int.tryParse(idStr) : null;
  }
}
