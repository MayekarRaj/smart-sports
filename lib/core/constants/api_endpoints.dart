// API Endpoints and Configuration

class ApiConfig {
  // Base URL for the API
  static const String baseUrl = 'https://stg-sports-admin.sekai-ichi.com';

  // API version
  static const String apiVersion = 'api';

  // Full API base URL
  static String get apiBaseUrl => '$baseUrl/$apiVersion';

  // Authentication token (will be set dynamically)
  static String? authToken;

  // Headers for API requests
  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    if (authToken != null) 'Authorization': 'Bearer $authToken',
  };
}

class ApiEndpoints {
  // Authentication endpoints
  static const String signIn = '/sign-in';
  static const String signUp = '/sign-up';
  static const String profile = '/profile';

  // Club registration endpoints
  static const String clubSignupStep1 = '/signup-club';
  static const String clubSignupStep2 = '/signup-club-branch';

  // Helper methods to get full URLs
  static String getSignInUrl() => '${ApiConfig.apiBaseUrl}$signIn';
  static String getSignUpUrl() => '${ApiConfig.apiBaseUrl}$signUp';
  static String getProfileUrl(int userId) =>
      '${ApiConfig.apiBaseUrl}$profile/$userId';
  static String getClubSignupStep1Url() =>
      '${ApiConfig.apiBaseUrl}$clubSignupStep1';
  static String getClubSignupStep2Url() =>
      '${ApiConfig.apiBaseUrl}$clubSignupStep2';
}
