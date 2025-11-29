/// API Configuration for Smart Sports App
/// This file contains environment-specific configurations

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

  // ==================== Stripe Configuration ====================
  // Stripe Publishable Keys for different environments
  // Get these from: https://dashboard.stripe.com/apikeys
  static const Map<String, String> stripePublishableKeys = {
    'development': 'pk_test_51SSWqnCk1NPTVAi6Sb0FwpjdMcOqYXhv7PpHgVaBpH5QLOy0v2xm1CMmNS2u9by4NxkYGB36b1Niu9jL5MjNoMYE00hh5IBlkn',
    'staging': 'pk_test_51SSWqnCk1NPTVAi6Sb0FwpjdMcOqYXhv7PpHgVaBpH5QLOy0v2xm1CMmNS2u9by4NxkYGB36b1Niu9jL5MjNoMYE00hh5IBlkn',
    'production': 'pk_live_...', // Replace with your live key when ready for production
  };

  // Get current Stripe publishable key
  static String? get stripePublishableKey {
    final key = stripePublishableKeys[environment];
    // Return null if key is placeholder to prevent accidental usage
    if (key == null || key.contains('...')) {
      return null;
    }
    return key;
  }
}
