import '../network/network_client.dart';
import '../constants/api_endpoints.dart';
import '../models/api_models.dart';
import '../exceptions/api_exception.dart';
import 'base_repository.dart';

/// Authentication repository for handling all auth-related API calls
class AuthRepository extends BaseRepository {
  /// Sign in user
  /// Returns SignInResponse with access_token and user profile
  Future<SignInResponse> signIn(SignInRequest request) async {
    final response = await networkClient.post<SignInResponse>(
      ApiEndpoints.getSignInUrl(),
      body: request.toJson(),
      requiresAuth: false,
      fromJson: (data) => SignInResponse.fromJson(data as Map<String, dynamic>),
    );

    if (response.success && response.hasData) {
      // Save token automatically via NetworkClient (using access_token)
      await networkClient.saveAuthToken(response.dataOrThrow.accessToken);
      return response.dataOrThrow;
    }

    throw ApiException(
      message: response.message,
      statusCode: response.statusCode ?? 0,
    );
  }

  /// Sign up user
  /// Returns SignUpResponse with access_token and user profile
  Future<SignUpResponse> signUp(SignUpRequest request) async {
    final response = await networkClient.post<SignUpResponse>(
      ApiEndpoints.getSignUpUrl(),
      body: request.toJson(),
      requiresAuth: false,
      fromJson: (data) => SignUpResponse.fromJson(data as Map<String, dynamic>),
    );

    if (response.success && response.hasData) {
      // Save token automatically via NetworkClient (using access_token)
      await networkClient.saveAuthToken(response.dataOrThrow.accessToken);
      return response.dataOrThrow;
    }

    throw ApiException(
      message: response.message,
      statusCode: response.statusCode ?? 0,
    );
  }

  /// Send OTP to email
  Future<void> sendOtp(String email) async {
    final response = await networkClient.post<Map<String, dynamic>>(
      ApiEndpoints.getSendOtpUrl(),
      body: {'email': email},
      requiresAuth: false,
    );

    if (!response.success) {
      throw ApiException(
        message: response.message,
        statusCode: response.statusCode ?? 0,
      );
    }
  }

  /// Verify OTP
  Future<void> verifyOtp(String email, String otp) async {
    final response = await networkClient.post<Map<String, dynamic>>(
      ApiEndpoints.getVerifyOtpUrl(),
      body: {'email': email, 'otp': otp},
      requiresAuth: false,
    );

    if (!response.success) {
      throw ApiException(
        message: response.message,
        statusCode: response.statusCode ?? 0,
      );
    }
  }

  /// Forgot password - send reset link
  Future<void> forgotPassword(String email) async {
    final response = await networkClient.post<Map<String, dynamic>>(
      ApiEndpoints.getForgotPasswordUrl(),
      body: {'email': email},
      requiresAuth: false,
    );

    if (!response.success) {
      throw ApiException(
        message: response.message,
        statusCode: response.statusCode ?? 0,
      );
    }
  }

  /// Reset password with token
  Future<void> resetPassword({
    required String token,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final response = await networkClient.post<Map<String, dynamic>>(
      ApiEndpoints.getResetPasswordUrl(),
      body: {
        'token': token,
        'password': newPassword,
        'password_confirmation': confirmPassword,
      },
      requiresAuth: false,
    );

    if (!response.success) {
      throw ApiException(
        message: response.message,
        statusCode: response.statusCode ?? 0,
      );
    }
  }

  /// Change password (requires authentication)
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final response = await networkClient.post<Map<String, dynamic>>(
      ApiEndpoints.getChangePasswordUrl(),
      body: {
        'current_password': currentPassword,
        'password': newPassword,
        'password_confirmation': confirmPassword,
      },
      requiresAuth: true,
    );

    if (!response.success) {
      throw ApiException(
        message: response.message,
        statusCode: response.statusCode ?? 0,
      );
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
      await networkClient.post<Map<String, dynamic>>(
        ApiEndpoints.getLogoutUrl(),
        requiresAuth: true,
      );
    } finally {
      // Always clear token even if API call fails
      await networkClient.clearAuthToken();
    }
  }

  /// Get user profile
  Future<UserProfile> getProfile(int userId) async {
    return await handleResponse(
      networkClient.get<UserProfile>(
        ApiEndpoints.getProfileUrl(userId),
        fromJson: (data) =>
            UserProfile.fromJson(data as Map<String, dynamic>),
      ),
    );
  }

  /// Refresh authentication token
  Future<void> refreshToken() async {
    final response = await networkClient.post<Map<String, dynamic>>(
      ApiEndpoints.getRefreshTokenUrl(),
      body: {},
      requiresAuth: false,
    );

    if (response.success && response.data != null) {
      final token = response.data!['token'] as String?;
      if (token != null && token.isNotEmpty) {
        await networkClient.saveAuthToken(token);
      } else {
        throw ApiException(
          message: 'Token not found in refresh response',
          statusCode: response.statusCode ?? 0,
        );
      }
    } else {
      throw ApiException(
        message: response.message,
        statusCode: response.statusCode ?? 0,
      );
    }
  }

  /// Corporate signup
  /// Returns CorporateSignupResponse with corporate record
  Future<CorporateSignupResponse> corporateSignup(CorporateSignupRequest request) async {
    // API returns response with data array, so we handle it specially
    // NetworkClient will extract responseData['data'] and pass it to fromJson
    final response = await networkClient.post<List<dynamic>>(
      ApiEndpoints.getCorporateSignupUrl(),
      body: request.toJson(),
      requiresAuth: true,
      fromJson: (data) => data as List<dynamic>,
    );

    if (response.success && response.hasData) {
      // response.data is already the List from responseData['data']
      final dataList = response.dataOrThrow;
      if (dataList.isNotEmpty) {
        return CorporateSignupResponse.fromJson(dataList.first as Map<String, dynamic>);
      } else {
        throw ApiException(
          message: 'No data returned from corporate signup',
          statusCode: response.statusCode ?? 0,
        );
      }
    }

    throw ApiException(
      message: response.message,
      statusCode: response.statusCode ?? 0,
    );
  }

  /// Coach signup
  /// Returns success response
  Future<Map<String, dynamic>> coachSignup(CoachSignupRequest request) async {
    final response = await networkClient.post<Map<String, dynamic>>(
      ApiEndpoints.getCoachSignupUrl(),
      body: request.toJson(),
      requiresAuth: true,
      fromJson: (data) => data as Map<String, dynamic>,
    );

    if (response.success) {
      return response.dataOrThrow;
    }

    throw ApiException(
      message: response.message,
      statusCode: response.statusCode ?? 0,
    );
  }

  /// Freelancer signup
  /// Returns FreelancerSignupResponse with freelancer_id
  Future<FreelancerSignupResponse> freelancerSignup(FreelancerSignupRequest request) async {
    final response = await networkClient.post<FreelancerSignupResponse>(
      ApiEndpoints.getFreelancerSignupUrl(),
      body: request.toJson(),
      requiresAuth: true,
      fromJson: (data) => FreelancerSignupResponse.fromJson(data as Map<String, dynamic>),
    );

    if (response.success && response.hasData) {
      return response.dataOrThrow;
    }

    throw ApiException(
      message: response.message,
      statusCode: response.statusCode ?? 0,
    );
  }
}

