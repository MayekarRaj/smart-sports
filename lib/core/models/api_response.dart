/// Generic API response wrapper
class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final int? statusCode;
  final Map<String, dynamic>? meta;

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.statusCode,
    this.meta,
  });

  /// Check if response has data
  bool get hasData => data != null;

  /// Get data or throw exception if null
  T get dataOrThrow {
    if (data == null) {
      throw Exception('Data is null in successful response');
    }
    return data!;
  }

  /// Create success response
  factory ApiResponse.success({
    required T data,
    String message = 'Success',
    int? statusCode,
    Map<String, dynamic>? meta,
  }) {
    return ApiResponse<T>(
      success: true,
      message: message,
      data: data,
      statusCode: statusCode ?? 200,
      meta: meta,
    );
  }

  /// Create error response
  factory ApiResponse.error({
    required String message,
    int? statusCode,
    T? data,
    Map<String, dynamic>? meta,
  }) {
    return ApiResponse<T>(
      success: false,
      message: message,
      data: data,
      statusCode: statusCode,
      meta: meta,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data,
      'statusCode': statusCode,
      'meta': meta,
    };
  }
}

