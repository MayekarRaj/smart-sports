import '../config/api_config.dart';

/// Centralized API endpoints configuration
/// All API endpoints should be defined here
class ApiEndpoints {
  // ==================== Authentication ====================
  static const String signIn = '/sign-in';
  static const String signUp = '/sign-up';
  static const String logout = '/logout';
  static const String refreshToken = '/refresh-token';
  static const String profile = '/profile';
  static const String sendOtp = '/send-otp';
  static const String verifyOtp = '/verify-email';
  static const String checkEmailVerification = '/check-verified-email-or-not';
  static const String forgotPassword = '/password/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String changePassword = '/change-password';

  // ==================== Club Registration ====================
  static const String clubSignupStep1 = '/signup-club';
  static const String clubSignupStep2 = '/signup-club-branch';

  // ==================== Corporate Registration ====================
  static const String corporateSignup = '/signup-corporate';

  // ==================== Coach Registration ====================
  static const String coachSignup = '/signup-coach';
  static const String coachExperienceLevelSignup =
      '/signup-coach-experience-levels';

  // ==================== Freelancer Registration ====================
  static const String freelancerSignup = '/signup-freelancer';

  // ==================== Merchandizer Registration ====================
  static const String merchandizerSignup = '/signup-merchandizer';
  static const String merchandizerBranchSignup = '/signup-merchandizer-branch';

  // ==================== Member Registration ====================
  // Ensure these match the backend exactly
  static const String signupMemberRole = '/signup-member-role';
  static const String signupFamilyMember = '/signup-family-member';
  static const String signupChooseMembershipType =
      '/signup-chooseMembershipType';

  // ==================== Paid Services ====================
  static const String paidServicesList = '/paid-services-list';
  static const String saveOptionalPaidServices = '/save-optional-paid-services';

  // ==================== Stripe Payment ====================
  static const String stripeCreateSetupIntent = '/stripe/create-setup-intent';
  static const String stripeCreateSubscription = '/stripe/create-subscription';
  static const String savePaymentInformation = '/signup-savePaymentInformation';

  // ==================== Club and Branch Lists ====================
  static const String getAllClubList = '/signup-getAllClubList';
  static const String getMerchandizerBranchList =
      '/signup-getMerchandizerBranchList';

  // ==================== Sports ====================
  static const String sportsList = '/sports-list';

  // ==================== Coach Experience Levels ====================
  static const String mstCoachExperienceLevel = '/mst-coach-experience-level';

  // ==================== Club Days ====================
  static const String mstClubDays = '/mst-club-days';

  // ==================== Membership Age Groups ====================
  static const String mstMembershipAgeGroup = '/mst-membership-age-group';

  // ==================== City and Location ====================
  static const String getCity = '/get-city';
  static const String getCountryStateByCity = '/get-country-state-by-city';

  // ==================== Phone Codes ====================
  static const String phoneCode = '/phone-code';

  // ==================== Bookings ====================
  static const String bookings = '/bookings';
  static const String bookingDetails = '/bookings'; // /bookings/{id}
  static const String createBooking = '/bookings';
  static const String updateBooking = '/bookings'; // /bookings/{id}
  static const String cancelBooking = '/bookings'; // /bookings/{id}/cancel
  static const String bookingHistory = '/bookings/history';

  // ==================== Events ====================
  static const String events = '/events';
  static const String eventDetails = '/events'; // /events/{id}
  static const String createEvent = '/events';
  static const String updateEvent = '/events'; // /events/{id}
  static const String deleteEvent = '/events'; // /events/{id}
  static const String subscribeToEvent = '/events'; // /events/{id}/subscribe

  // ==================== Users ====================
  static const String users = '/users';
  static const String userDetails = '/users'; // /users/{id}
  static const String createUser = '/users';
  static const String updateUser = '/users'; // /users/{id}
  static const String deleteUser = '/users'; // /users/{id}
  static const String userStatus = '/users'; // /users/{id}/status

  // ==================== Courts ====================
  static const String courts = '/courts';
  static const String courtDetails = '/courts'; // /courts/{id}
  static const String createCourt = '/courts';
  static const String updateCourt = '/courts'; // /courts/{id}
  static const String deleteCourt = '/courts'; // /courts/{id}
  static const String courtAvailability =
      '/courts'; // /courts/{id}/availability

  // ==================== Transactions ====================
  static const String transactions = '/transactions';
  static const String transactionDetails =
      '/transactions'; // /transactions/{id}

  // ==================== Referrals ====================
  static const String referrals = '/referrals';
  static const String inviteReferral = '/referrals/invite';
  static const String referralStats = '/referrals/stats';

  // ==================== Customer Support ====================
  static const String supportTickets = '/support/tickets';
  static const String createTicket = '/support/tickets';
  static const String ticketDetails =
      '/support/tickets'; // /support/tickets/{id}

  // ==================== Site Settings ====================
  static const String siteSettings = '/site-setting';

  // ==================== Helper Methods ====================

  // Authentication
  static String getSignInUrl() => '${ApiConfig.apiBaseUrl}$signIn';
  static String getSignUpUrl() => '${ApiConfig.apiBaseUrl}$signUp';
  static String getLogoutUrl() => '${ApiConfig.apiBaseUrl}$logout';
  static String getRefreshTokenUrl() => '${ApiConfig.apiBaseUrl}$refreshToken';
  static String getProfileUrl(int userId) =>
      '${ApiConfig.apiBaseUrl}$profile/$userId';
  static String getSendOtpUrl() => '${ApiConfig.apiBaseUrl}$sendOtp';
  static String getVerifyOtpUrl() => '${ApiConfig.apiBaseUrl}$verifyOtp';
  static String getCheckEmailVerificationUrl() =>
      '${ApiConfig.apiBaseUrl}$checkEmailVerification';
  static String getForgotPasswordUrl() =>
      '${ApiConfig.apiBaseUrl}$forgotPassword';
  static String getResetPasswordUrl() =>
      '${ApiConfig.apiBaseUrl}$resetPassword';
  static String getChangePasswordUrl() =>
      '${ApiConfig.apiBaseUrl}$changePassword';

  // Club Registration
  static String getClubSignupUrl() => '${ApiConfig.apiBaseUrl}$clubSignupStep1';
  static String getClubSignupStep2Url() =>
      '${ApiConfig.apiBaseUrl}$clubSignupStep2';

  // Corporate Registration
  static String getCorporateSignupUrl() =>
      '${ApiConfig.apiBaseUrl}$corporateSignup';

  // Coach Registration
  static String getCoachSignupUrl() => '${ApiConfig.apiBaseUrl}$coachSignup';
  static String getCoachExperienceLevelSignupUrl() =>
      '${ApiConfig.apiBaseUrl}$coachExperienceLevelSignup';

  // Freelancer Registration
  static String getFreelancerSignupUrl() =>
      '${ApiConfig.apiBaseUrl}$freelancerSignup';

  // Merchandizer Registration
  static String getMerchandizerSignupUrl() =>
      '${ApiConfig.apiBaseUrl}$merchandizerSignup';
  static String getMerchandizerBranchSignupUrl() =>
      '${ApiConfig.apiBaseUrl}$merchandizerBranchSignup';

  // Member Registration
  static String getSignupMemberRoleUrl() =>
      '${ApiConfig.apiBaseUrl}$signupMemberRole';
  static String getSignupFamilyMemberUrl() =>
      '${ApiConfig.apiBaseUrl}$signupFamilyMember';
  static String getSignupChooseMembershipTypeUrl() =>
      '${ApiConfig.apiBaseUrl}$signupChooseMembershipType';

  // Paid Services
  static String getPaidServicesListUrl({String? userRole}) {
    final baseUrl = '${ApiConfig.apiBaseUrl}$paidServicesList';
    if (userRole != null && userRole.isNotEmpty) {
      return '$baseUrl?user_role=$userRole';
    }
    return baseUrl;
  }

  static String getSaveOptionalPaidServicesUrl() =>
      '${ApiConfig.apiBaseUrl}$saveOptionalPaidServices';

  // Stripe Payment
  static String getStripeCreateSetupIntentUrl() =>
      '${ApiConfig.apiBaseUrl}$stripeCreateSetupIntent';
  static String getStripeCreateSubscriptionUrl() =>
      '${ApiConfig.apiBaseUrl}$stripeCreateSubscription';
  static String getSavePaymentInformationUrl() =>
      '${ApiConfig.apiBaseUrl}$savePaymentInformation';

  // Club and Branch Lists
  static String getAllClubListUrl() => '${ApiConfig.apiBaseUrl}$getAllClubList';
  static String getMerchandizerBranchListUrl(int merchandizerId) =>
      '${ApiConfig.apiBaseUrl}$getMerchandizerBranchList/$merchandizerId';

  // Sports
  static String getSportsListUrl({
    String? orderBy,
    String? sportsName,
    int? isActive,
  }) {
    final baseUrl = '${ApiConfig.apiBaseUrl}$sportsList';
    final params = <String, String>{};

    if (orderBy != null) params['orderBy'] = orderBy;
    if (sportsName != null && sportsName.isNotEmpty)
      params['sports_name'] = sportsName;
    if (isActive != null) params['is_active'] = isActive.toString();

    if (params.isEmpty) return baseUrl;

    final queryString = params.entries
        .map(
          (e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
        )
        .join('&');
    return '$baseUrl?$queryString';
  }

  // Coach Experience Levels
  static String getMstCoachExperienceLevelUrl({
    int? perPage,
    String? orderBy,
    String? commonSearch,
    String? name,
    int? isActive,
    int? page,
  }) {
    final baseUrl = '${ApiConfig.apiBaseUrl}$mstCoachExperienceLevel';
    final params = <String, String>{};

    if (perPage != null) params['perPage'] = perPage.toString();
    if (orderBy != null) params['orderBy'] = orderBy;
    if (commonSearch != null && commonSearch.isNotEmpty)
      params['common_search'] = commonSearch;
    if (name != null && name.isNotEmpty) params['name'] = name;
    if (isActive != null) params['is_active'] = isActive.toString();
    if (page != null) params['page'] = page.toString();

    if (params.isEmpty) return baseUrl;

    final queryString = params.entries
        .map(
          (e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
        )
        .join('&');
    return '$baseUrl?$queryString';
  }

  // Club Days
  static String getMstClubDaysUrl({
    int? perPage,
    String? orderBy,
    String? commonSearch,
    String? name,
    int? isActive,
    int? page,
  }) {
    final baseUrl = '${ApiConfig.apiBaseUrl}$mstClubDays';
    final params = <String, String>{};

    if (perPage != null) params['perPage'] = perPage.toString();
    if (orderBy != null) params['orderBy'] = orderBy;
    if (commonSearch != null && commonSearch.isNotEmpty)
      params['common_search'] = commonSearch;
    if (name != null && name.isNotEmpty) params['name'] = name;
    if (isActive != null) params['is_active'] = isActive.toString();
    if (page != null) params['page'] = page.toString();

    if (params.isEmpty) return baseUrl;

    final queryString = params.entries
        .map(
          (e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
        )
        .join('&');
    return '$baseUrl?$queryString';
  }

  // Membership Age Groups
  static String getMstMembershipAgeGroupUrl({
    int? perPage,
    String? orderBy,
    String? commonSearch,
    String? name,
    int? isActive,
    int? page,
  }) {
    final baseUrl = '${ApiConfig.apiBaseUrl}$mstMembershipAgeGroup';
    final params = <String, String>{};

    if (perPage != null) params['perPage'] = perPage.toString();
    if (orderBy != null) params['orderBy'] = orderBy;
    if (commonSearch != null && commonSearch.isNotEmpty)
      params['common_search'] = commonSearch;
    if (name != null && name.isNotEmpty) params['name'] = name;
    if (isActive != null) params['is_active'] = isActive.toString();
    if (page != null) params['page'] = page.toString();

    if (params.isEmpty) return baseUrl;

    final queryString = params.entries
        .map(
          (e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
        )
        .join('&');
    return '$baseUrl?$queryString';
  }

  // City and Location
  static String getCitySearchUrl(String search) =>
      '${ApiConfig.apiBaseUrl}$getCity/$search';
  static String getCountryStateByCityUrl(int cityId) =>
      '${ApiConfig.apiBaseUrl}$getCountryStateByCity/$cityId';

  // Phone Codes
  static String getPhoneCodeUrl() => '${ApiConfig.apiBaseUrl}$phoneCode';

  // Bookings
  static String getBookingsUrl() => '${ApiConfig.apiBaseUrl}$bookings';
  static String getBookingDetailsUrl(String id) =>
      '${ApiConfig.apiBaseUrl}$bookingDetails/$id';
  static String getCreateBookingUrl() =>
      '${ApiConfig.apiBaseUrl}$createBooking';
  static String getUpdateBookingUrl(String id) =>
      '${ApiConfig.apiBaseUrl}$updateBooking/$id';
  static String getCancelBookingUrl(String id) =>
      '${ApiConfig.apiBaseUrl}$cancelBooking/$id/cancel';
  static String getBookingHistoryUrl() =>
      '${ApiConfig.apiBaseUrl}$bookingHistory';

  // Events
  static String getEventsUrl() => '${ApiConfig.apiBaseUrl}$events';
  static String getEventDetailsUrl(String id) =>
      '${ApiConfig.apiBaseUrl}$eventDetails/$id';
  static String getCreateEventUrl() => '${ApiConfig.apiBaseUrl}$createEvent';
  static String getUpdateEventUrl(String id) =>
      '${ApiConfig.apiBaseUrl}$updateEvent/$id';
  static String getDeleteEventUrl(String id) =>
      '${ApiConfig.apiBaseUrl}$deleteEvent/$id';
  static String getSubscribeToEventUrl(String id) =>
      '${ApiConfig.apiBaseUrl}$subscribeToEvent/$id/subscribe';

  // Users
  static String getUsersUrl() => '${ApiConfig.apiBaseUrl}$users';
  static String getUserDetailsUrl(String id) =>
      '${ApiConfig.apiBaseUrl}$userDetails/$id';
  static String getCreateUserUrl() => '${ApiConfig.apiBaseUrl}$createUser';
  static String getUpdateUserUrl(String id) =>
      '${ApiConfig.apiBaseUrl}$updateUser/$id';
  static String getDeleteUserUrl(String id) =>
      '${ApiConfig.apiBaseUrl}$deleteUser/$id';
  static String getUserStatusUrl(String id) =>
      '${ApiConfig.apiBaseUrl}$userStatus/$id/status';

  // Courts
  static String getCourtsUrl() => '${ApiConfig.apiBaseUrl}$courts';
  static String getCourtDetailsUrl(String id) =>
      '${ApiConfig.apiBaseUrl}$courtDetails/$id';
  static String getCreateCourtUrl() => '${ApiConfig.apiBaseUrl}$createCourt';
  static String getUpdateCourtUrl(String id) =>
      '${ApiConfig.apiBaseUrl}$updateCourt/$id';
  static String getDeleteCourtUrl(String id) =>
      '${ApiConfig.apiBaseUrl}$deleteCourt/$id';
  static String getCourtAvailabilityUrl(String id) =>
      '${ApiConfig.apiBaseUrl}$courtAvailability/$id/availability';

  // Transactions
  static String getTransactionsUrl() => '${ApiConfig.apiBaseUrl}$transactions';
  static String getTransactionDetailsUrl(String id) =>
      '${ApiConfig.apiBaseUrl}$transactionDetails/$id';

  // Referrals
  static String getReferralsUrl() => '${ApiConfig.apiBaseUrl}$referrals';
  static String getInviteReferralUrl() =>
      '${ApiConfig.apiBaseUrl}$inviteReferral';
  static String getReferralStatsUrl() =>
      '${ApiConfig.apiBaseUrl}$referralStats';

  // Customer Support
  static String getSupportTicketsUrl() =>
      '${ApiConfig.apiBaseUrl}$supportTickets';
  static String getCreateTicketUrl() => '${ApiConfig.apiBaseUrl}$createTicket';
  static String getTicketDetailsUrl(String id) =>
      '${ApiConfig.apiBaseUrl}$ticketDetails/$id';

  // Site Settings
  static String getSiteSettingsUrl({
    int edit = 0,
    int paypalEdit = 1,
    int stripeEdit = 1,
    int editMail = 0,
  }) {
    return '${ApiConfig.apiBaseUrl}$siteSettings?edit=$edit&paypalEdit=$paypalEdit&stripeEdit=$stripeEdit&editMail=$editMail';
  }
}
