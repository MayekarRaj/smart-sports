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

  // ==================== Freelancer Registration ====================
  static const String freelancerSignup = '/signup-freelancer';

  // ==================== Merchandizer Registration ====================
  static const String merchandizerSignup = '/signup-merchandizer';
  static const String merchandizerBranchSignup = '/signup-merchandizer-branch';

  // ==================== Paid Services ====================
  static const String paidServicesList = '/paid-services-list';

  // ==================== Club and Branch Lists ====================
  static const String getAllClubList = '/signup-getAllClubList';
  static const String getMerchandizerBranchList = '/signup-getMerchandizerBranchList';

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
  static const String courtAvailability = '/courts'; // /courts/{id}/availability

  // ==================== Transactions ====================
  static const String transactions = '/transactions';
  static const String transactionDetails = '/transactions'; // /transactions/{id}

  // ==================== Referrals ====================
  static const String referrals = '/referrals';
  static const String inviteReferral = '/referrals/invite';
  static const String referralStats = '/referrals/stats';

  // ==================== Customer Support ====================
  static const String supportTickets = '/support/tickets';
  static const String createTicket = '/support/tickets';
  static const String ticketDetails = '/support/tickets'; // /support/tickets/{id}

  // ==================== Helper Methods ====================
  
  // Authentication
  static String getSignInUrl() => '${ApiConfig.apiBaseUrl}$signIn';
  static String getSignUpUrl() => '${ApiConfig.apiBaseUrl}$signUp';
  static String getLogoutUrl() => '${ApiConfig.apiBaseUrl}$logout';
  static String getRefreshTokenUrl() => '${ApiConfig.apiBaseUrl}$refreshToken';
  static String getProfileUrl(int userId) => '${ApiConfig.apiBaseUrl}$profile/$userId';
  static String getSendOtpUrl() => '${ApiConfig.apiBaseUrl}$sendOtp';
  static String getVerifyOtpUrl() => '${ApiConfig.apiBaseUrl}$verifyOtp';
  static String getCheckEmailVerificationUrl() => '${ApiConfig.apiBaseUrl}$checkEmailVerification';
  static String getForgotPasswordUrl() => '${ApiConfig.apiBaseUrl}$forgotPassword';
  static String getResetPasswordUrl() => '${ApiConfig.apiBaseUrl}$resetPassword';
  static String getChangePasswordUrl() => '${ApiConfig.apiBaseUrl}$changePassword';

  // Club Registration
  static String getClubSignupStep1Url() => '${ApiConfig.apiBaseUrl}$clubSignupStep1';
  static String getClubSignupStep2Url() => '${ApiConfig.apiBaseUrl}$clubSignupStep2';

  // Corporate Registration
  static String getCorporateSignupUrl() => '${ApiConfig.apiBaseUrl}$corporateSignup';

  // Coach Registration
  static String getCoachSignupUrl() => '${ApiConfig.apiBaseUrl}$coachSignup';

  // Freelancer Registration
  static String getFreelancerSignupUrl() => '${ApiConfig.apiBaseUrl}$freelancerSignup';

  // Merchandizer Registration
  static String getMerchandizerSignupUrl() => '${ApiConfig.apiBaseUrl}$merchandizerSignup';
  static String getMerchandizerBranchSignupUrl() => '${ApiConfig.apiBaseUrl}$merchandizerBranchSignup';

  // Paid Services
  static String getPaidServicesListUrl({String? userRole}) {
    final baseUrl = '${ApiConfig.apiBaseUrl}$paidServicesList';
    if (userRole != null && userRole.isNotEmpty) {
      return '$baseUrl?user_role=$userRole';
    }
    return baseUrl;
  }

  // Club and Branch Lists
  static String getAllClubListUrl() => '${ApiConfig.apiBaseUrl}$getAllClubList';
  static String getMerchandizerBranchListUrl(int merchandizerId) => 
      '${ApiConfig.apiBaseUrl}$getMerchandizerBranchList/$merchandizerId';

  // Bookings
  static String getBookingsUrl() => '${ApiConfig.apiBaseUrl}$bookings';
  static String getBookingDetailsUrl(String id) => '${ApiConfig.apiBaseUrl}$bookingDetails/$id';
  static String getCreateBookingUrl() => '${ApiConfig.apiBaseUrl}$createBooking';
  static String getUpdateBookingUrl(String id) => '${ApiConfig.apiBaseUrl}$updateBooking/$id';
  static String getCancelBookingUrl(String id) => '${ApiConfig.apiBaseUrl}$cancelBooking/$id/cancel';
  static String getBookingHistoryUrl() => '${ApiConfig.apiBaseUrl}$bookingHistory';

  // Events
  static String getEventsUrl() => '${ApiConfig.apiBaseUrl}$events';
  static String getEventDetailsUrl(String id) => '${ApiConfig.apiBaseUrl}$eventDetails/$id';
  static String getCreateEventUrl() => '${ApiConfig.apiBaseUrl}$createEvent';
  static String getUpdateEventUrl(String id) => '${ApiConfig.apiBaseUrl}$updateEvent/$id';
  static String getDeleteEventUrl(String id) => '${ApiConfig.apiBaseUrl}$deleteEvent/$id';
  static String getSubscribeToEventUrl(String id) => '${ApiConfig.apiBaseUrl}$subscribeToEvent/$id/subscribe';

  // Users
  static String getUsersUrl() => '${ApiConfig.apiBaseUrl}$users';
  static String getUserDetailsUrl(String id) => '${ApiConfig.apiBaseUrl}$userDetails/$id';
  static String getCreateUserUrl() => '${ApiConfig.apiBaseUrl}$createUser';
  static String getUpdateUserUrl(String id) => '${ApiConfig.apiBaseUrl}$updateUser/$id';
  static String getDeleteUserUrl(String id) => '${ApiConfig.apiBaseUrl}$deleteUser/$id';
  static String getUserStatusUrl(String id) => '${ApiConfig.apiBaseUrl}$userStatus/$id/status';

  // Courts
  static String getCourtsUrl() => '${ApiConfig.apiBaseUrl}$courts';
  static String getCourtDetailsUrl(String id) => '${ApiConfig.apiBaseUrl}$courtDetails/$id';
  static String getCreateCourtUrl() => '${ApiConfig.apiBaseUrl}$createCourt';
  static String getUpdateCourtUrl(String id) => '${ApiConfig.apiBaseUrl}$updateCourt/$id';
  static String getDeleteCourtUrl(String id) => '${ApiConfig.apiBaseUrl}$deleteCourt/$id';
  static String getCourtAvailabilityUrl(String id) => '${ApiConfig.apiBaseUrl}$courtAvailability/$id/availability';

  // Transactions
  static String getTransactionsUrl() => '${ApiConfig.apiBaseUrl}$transactions';
  static String getTransactionDetailsUrl(String id) => '${ApiConfig.apiBaseUrl}$transactionDetails/$id';

  // Referrals
  static String getReferralsUrl() => '${ApiConfig.apiBaseUrl}$referrals';
  static String getInviteReferralUrl() => '${ApiConfig.apiBaseUrl}$inviteReferral';
  static String getReferralStatsUrl() => '${ApiConfig.apiBaseUrl}$referralStats';

  // Customer Support
  static String getSupportTicketsUrl() => '${ApiConfig.apiBaseUrl}$supportTickets';
  static String getCreateTicketUrl() => '${ApiConfig.apiBaseUrl}$createTicket';
  static String getTicketDetailsUrl(String id) => '${ApiConfig.apiBaseUrl}$ticketDetails/$id';
}
