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
  /// Returns SendOtpResponse with success status and message
  Future<SendOtpResponse> sendOtp(String email) async {
    final request = SendOtpRequest(email: email);
    final response = await networkClient.post<SendOtpResponse>(
      ApiEndpoints.getSendOtpUrl(),
      body: request.toJson(),
      requiresAuth: false,
      fromJson: (data) => SendOtpResponse.fromJson(data as Map<String, dynamic>),
    );

    if (response.success && response.hasData) {
      return response.dataOrThrow;
    }

    throw ApiException(
      message: response.message,
      statusCode: response.statusCode ?? 0,
    );
  }

  /// Verify OTP
  /// Returns VerifyOtpResponse with verification status
  Future<VerifyOtpResponse> verifyOtp(String email, String otp) async {
    final request = VerifyOtpRequest(email: email, otp: otp);
    final response = await networkClient.post<VerifyOtpResponse>(
      ApiEndpoints.getVerifyOtpUrl(),
      body: request.toJson(),
      requiresAuth: false,
      fromJson: (data) => VerifyOtpResponse.fromJson(data as Map<String, dynamic>),
    );

    if (response.success && response.hasData) {
      return response.dataOrThrow;
    }

    throw ApiException(
      message: response.message,
      statusCode: response.statusCode ?? 0,
    );
  }

  /// Check if email is verified
  /// Returns CheckEmailVerificationResponse with verification status
  Future<CheckEmailVerificationResponse> checkEmailVerification(String email) async {
    final request = CheckEmailVerificationRequest(email: email);
    final response = await networkClient.post<CheckEmailVerificationResponse>(
      ApiEndpoints.getCheckEmailVerificationUrl(),
      body: request.toJson(),
      requiresAuth: false,
      fromJson: (data) => CheckEmailVerificationResponse.fromJson(data as Map<String, dynamic>),
    );

    if (response.success && response.hasData) {
      return response.dataOrThrow;
    }

    throw ApiException(
      message: response.message,
      statusCode: response.statusCode ?? 0,
    );
  }

  /// Forgot password - send reset link
  /// Returns ForgotPasswordResponse with success status, message, and token
  Future<ForgotPasswordResponse> forgotPassword(String email) async {
    final request = ForgotPasswordRequest(email: email);
    final response = await networkClient.post<ForgotPasswordResponse>(
      ApiEndpoints.getForgotPasswordUrl(),
      body: request.toJson(),
      requiresAuth: false,
      fromJson: (data) => ForgotPasswordResponse.fromJson(data as Map<String, dynamic>),
    );

    if (response.success && response.hasData) {
      return response.dataOrThrow;
    }

    throw ApiException(
      message: response.message,
      statusCode: response.statusCode ?? 0,
    );
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

  /// Merchandizer signup (Step 1)
  /// Returns MerchandizerSignupResponse with merchandizer_id
  Future<MerchandizerSignupResponse> merchandizerSignup(MerchandizerSignupRequest request) async {
    final response = await networkClient.post<MerchandizerSignupResponse>(
      ApiEndpoints.getMerchandizerSignupUrl(),
      body: request.toJson(),
      requiresAuth: true,
      fromJson: (data) => MerchandizerSignupResponse.fromJson(data as Map<String, dynamic>),
    );

    if (response.success && response.hasData) {
      return response.dataOrThrow;
    }

    throw ApiException(
      message: response.message,
      statusCode: response.statusCode ?? 0,
    );
  }

  /// Merchandizer branch signup (Step 2)
  /// Returns MerchandizerBranchSignupResponse with branch data
  Future<MerchandizerBranchSignupResponse> merchandizerBranchSignup(MerchandizerBranchSignupRequest request) async {
    final response = await networkClient.post<List<dynamic>>(
      ApiEndpoints.getMerchandizerBranchSignupUrl(),
      body: request.toJson(),
      requiresAuth: true,
      fromJson: (data) => data as List<dynamic>,
    );

    if (response.success && response.hasData) {
      // API returns response with data array, so we handle it specially
      final dataList = response.dataOrThrow;
      final branches = dataList.map((item) => MerchandizerBranchData.fromJson(item as Map<String, dynamic>)).toList();
      
      return MerchandizerBranchSignupResponse(
        success: true,
        message: response.message,
        data: branches,
      );
    }

    throw ApiException(
      message: response.message,
      statusCode: response.statusCode ?? 0,
    );
  }

  /// Get paid services list for a user role
  /// Returns PaidServicesResponse with list of paid services
  Future<PaidServicesResponse> getPaidServicesList(String userRole) async {
    final response = await networkClient.get<List<dynamic>>(
      ApiEndpoints.getPaidServicesListUrl(userRole: userRole),
      requiresAuth: true,
      fromJson: (data) => data as List<dynamic>,
    );

    if (response.success && response.hasData) {
      // API returns response with data array, so we handle it specially
      final dataList = response.dataOrThrow;
      final services = dataList
          .map((item) => PaidService.fromJson(item as Map<String, dynamic>))
          .toList();

      return PaidServicesResponse(
        success: true,
        message: response.message,
        data: services,
      );
    }

    throw ApiException(
      message: response.message,
      statusCode: response.statusCode ?? 0,
    );
  }

  /// Get all clubs list
  /// Returns ClubListResponse with list of clubs
  Future<ClubListResponse> getAllClubList() async {
    final response = await networkClient.get<List<dynamic>>(
      ApiEndpoints.getAllClubListUrl(),
      requiresAuth: true,
      fromJson: (data) => data as List<dynamic>,
    );

    if (response.success && response.hasData) {
      final dataList = response.dataOrThrow;
      final clubs = dataList
          .map((item) => Club.fromJson(item as Map<String, dynamic>))
          .toList();

      return ClubListResponse(
        success: true,
        message: response.message,
        data: clubs,
      );
    }

    throw ApiException(
      message: response.message,
      statusCode: response.statusCode ?? 0,
    );
  }

  /// Get merchandizer branch list
  /// Returns MerchandizerBranchListResponse with list of branches
  Future<MerchandizerBranchListResponse> getMerchandizerBranchList(int merchandizerId) async {
    final response = await networkClient.get<List<dynamic>>(
      ApiEndpoints.getMerchandizerBranchListUrl(merchandizerId),
      requiresAuth: true,
      fromJson: (data) => data as List<dynamic>,
    );

    if (response.success && response.hasData) {
      final dataList = response.dataOrThrow;
      final branches = dataList
          .map((item) => MerchandizerBranchListItem.fromJson(item as Map<String, dynamic>))
          .toList();

      return MerchandizerBranchListResponse(
        success: true,
        message: response.message,
        data: branches,
      );
    }

    throw ApiException(
      message: response.message,
      statusCode: response.statusCode ?? 0,
    );
  }

  /// Get sports list
  /// Returns SportsListResponse with paginated sports data
  Future<SportsListResponse> getSportsList({
    int? perPage,
    String? orderBy,
    String? commonSearch,
    String? sportsName,
    int? isActive,
    int? page,
  }) async {
    final response = await networkClient.get<Map<String, dynamic>>(
      ApiEndpoints.getMstSportsUrl(
        perPage: perPage,
        orderBy: orderBy,
        commonSearch: commonSearch,
        sportsName: sportsName,
        isActive: isActive,
        page: page,
      ),
      requiresAuth: true, // API requires authentication token
      fromJson: null, // Get full response to parse manually
    );

    if (response.success && response.hasData) {
      final fullResponse = response.dataOrThrow as Map<String, dynamic>;
      return SportsListResponse.fromJson(fullResponse);
    }

    throw ApiException(
      message: response.message,
      statusCode: response.statusCode ?? 0,
    );
  }

  /// Search cities by name
  /// Returns CitySearchResponse with list of matching cities
  Future<CitySearchResponse> searchCities(String search) async {
    final response = await networkClient.get<Map<String, dynamic>>(
      ApiEndpoints.getCitySearchUrl(search),
      requiresAuth: false,
      fromJson: null, // Get full response to parse manually
    );

    if (response.success && response.hasData) {
      final fullResponse = response.dataOrThrow as Map<String, dynamic>;
      return CitySearchResponse.fromJson(fullResponse);
    }

    throw ApiException(
      message: response.message,
      statusCode: response.statusCode ?? 0,
    );
  }

  /// Get city details (state and country) by city ID
  /// Returns CityDetailsResponse with state and country information
  Future<CityDetailsResponse> getCityDetails(int cityId) async {
    final response = await networkClient.get<Map<String, dynamic>>(
      ApiEndpoints.getCountryStateByCityUrl(cityId),
      requiresAuth: false,
      fromJson: null, // Get full response to parse manually
    );

    if (response.success && response.hasData) {
      final fullResponse = response.dataOrThrow as Map<String, dynamic>;
      return CityDetailsResponse.fromJson(fullResponse);
    }

    throw ApiException(
      message: response.message,
      statusCode: response.statusCode ?? 0,
    );
  }

  /// Get phone codes list
  /// Returns PhoneCodeResponse with list of phone codes
  Future<PhoneCodeResponse> getPhoneCodes() async {
    final response = await networkClient.get<List<dynamic>>(
      ApiEndpoints.getPhoneCodeUrl(),
      requiresAuth: false,
      fromJson: (data) => data as List<dynamic>,
    );

    if (response.success && response.hasData) {
      final dataList = response.dataOrThrow;
      final phoneCodes = dataList
          .map((item) => PhoneCode.fromJson(item as Map<String, dynamic>))
          .toList();

      return PhoneCodeResponse(
        success: true,
        message: response.message,
        data: phoneCodes,
      );
    }

    throw ApiException(
      message: response.message,
      statusCode: response.statusCode ?? 0,
    );
  }

  /// Get coach experience levels list
  /// Returns CoachExperienceLevelListResponse with paginated experience levels data
  Future<CoachExperienceLevelListResponse> getCoachExperienceLevels({
    int? perPage,
    String? orderBy,
    String? commonSearch,
    String? name,
    int? isActive,
    int? page,
  }) async {
    final response = await networkClient.get<Map<String, dynamic>>(
      ApiEndpoints.getMstCoachExperienceLevelUrl(
        perPage: perPage,
        orderBy: orderBy,
        commonSearch: commonSearch,
        name: name,
        isActive: isActive,
        page: page,
      ),
      requiresAuth: true, // Requires bearer token
      fromJson: null, // Get full response to parse manually
    );

    if (response.success && response.hasData) {
      final fullResponse = response.dataOrThrow as Map<String, dynamic>;
      return CoachExperienceLevelListResponse.fromJson(fullResponse);
    }

    throw ApiException(
      message: response.message,
      statusCode: response.statusCode ?? 0,
    );
  }

  /// Get club days list
  /// Returns ClubDaysListResponse with paginated club days data
  Future<ClubDaysListResponse> getClubDays({
    int? perPage,
    String? orderBy,
    String? commonSearch,
    String? name,
    int? isActive,
    int? page,
  }) async {
    final response = await networkClient.get<Map<String, dynamic>>(
      ApiEndpoints.getMstClubDaysUrl(
        perPage: perPage,
        orderBy: orderBy,
        commonSearch: commonSearch,
        name: name,
        isActive: isActive,
        page: page,
      ),
      requiresAuth: true, // Requires bearer token
      fromJson: null, // Get full response to parse manually
    );

    if (response.success && response.hasData) {
      final fullResponse = response.dataOrThrow as Map<String, dynamic>;
      return ClubDaysListResponse.fromJson(fullResponse);
    }

    throw ApiException(
      message: response.message,
      statusCode: response.statusCode ?? 0,
    );
  }

  /// Save optional paid services
  /// Returns SaveOptionalPaidServicesResponse
  Future<SaveOptionalPaidServicesResponse> saveOptionalPaidServices(
    SaveOptionalPaidServicesRequest request,
  ) async {
    final response = await networkClient.post<Map<String, dynamic>>(
      ApiEndpoints.getSaveOptionalPaidServicesUrl(),
      body: request.toJson(),
      requiresAuth: true,
      fromJson: (data) => data as Map<String, dynamic>,
    );

    if (response.success) {
      final responseData = response.dataOrThrow;
      return SaveOptionalPaidServicesResponse.fromJson(responseData);
    }

    throw ApiException(
      message: response.message,
      statusCode: response.statusCode ?? 0,
    );
  }
}

