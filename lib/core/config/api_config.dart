// API Configuration for Smart Sports App
// This file contains environment-specific configurations

class ApiConfig {
  // Environment Configuration
  static const String environment =
      'staging'; // 'development', 'staging', 'production'

  // Base URLs for different environments
  static const Map<String, String> baseUrls = {
    'development': 'http://localhost:8000',
    'staging': 'https://stg-sports-admin.sekai-ichi.com',
    'production': 'https://sports-admin.sekai-ichi.com',
  };

  // Get current base URL
  static String get baseUrl => baseUrls[environment]!;

  // API version
  static const String apiVersion = 'api';

  // Full API base URL
  static String get apiBaseUrl => '$baseUrl/$apiVersion';

  // Authentication token (will be set dynamically)
  static String? authToken;

  // Default headers for API requests
  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    if (authToken != null) 'Authorization': 'Bearer $authToken',
  };

  // API Timeout settings
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Debug settings
  static const bool enableLogging = true;
  static const bool enableRequestLogging = true;
}

// API Endpoints
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
  static String getProfileUrl(int userId) =>
      '${ApiConfig.apiBaseUrl}$profile/$userId';
  static String getClubSignupStep1Url() =>
      '${ApiConfig.apiBaseUrl}$clubSignupStep1';
  static String getClubSignupStep2Url() =>
      '${ApiConfig.apiBaseUrl}$clubSignupStep2';
}
