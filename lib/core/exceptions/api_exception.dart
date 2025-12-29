/// Custom API exception class
class ApiException implements Exception {
  final String message;
  final int statusCode;
  final dynamic data;
  final Map<String, dynamic>? errors;

  ApiException({
    required this.message,
    required this.statusCode,
    this.data,
    this.errors,
  });
  
  /// Get validation errors as a map
  Map<String, dynamic>? get validationErrors => errors;
  
  /// Check if this is a validation error
  bool get isValidationError => errors != null && errors!.isNotEmpty;

  /// Check if error is due to authentication
  bool get isUnauthorized => statusCode == 401;

  /// Check if error is due to forbidden access
  bool get isForbidden => statusCode == 403;

  /// Check if error is due to not found
  bool get isNotFound => statusCode == 404;

  /// Check if error is due to server error
  bool get isServerError => statusCode >= 500;

  /// Check if error is due to network issue
  bool get isNetworkError => statusCode == 0;

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}

/// Network exception for connectivity issues
class NetworkException implements Exception {
  final String message;

  NetworkException(this.message);

  @override
  String toString() => 'NetworkException: $message';
}

/// Validation exception for request validation errors
class ValidationException implements Exception {
  final String message;
  final Map<String, List<String>>? errors;

  ValidationException(this.message, {this.errors});

  @override
  String toString() => 'ValidationException: $message';
}

