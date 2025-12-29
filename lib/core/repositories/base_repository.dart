import '../network/network_client.dart';
import '../exceptions/api_exception.dart';
import '../models/api_response.dart';

/// Base repository class that all feature repositories should extend
/// Provides common functionality and error handling
/// 
/// Architecture: Repository Pattern
/// - Repositories handle data access logic
/// - Extend BaseRepository for common functionality
/// - Use NetworkClient for HTTP operations
/// - Return domain models, not raw data
abstract class BaseRepository {
  // Use singleton NetworkClient - shared across all repositories
  final NetworkClient _networkClient = NetworkClient();

  /// Get network client instance
  NetworkClient get networkClient => _networkClient;

  /// Handle API response with error checking
  Future<T> handleResponse<T>(Future<ApiResponse<T>> apiCall) async {
    try {
      final response = await apiCall;
      if (response.success && response.hasData) {
        return response.dataOrThrow;
      } else {
        throw ApiException(
          message: response.message,
          statusCode: response.statusCode ?? 0,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: e.toString(),
        statusCode: 0,
      );
    }
  }

  /// Handle API response that can return null (for optional data)
  Future<T?> handleOptionalResponse<T>(Future<ApiResponse<T>> apiCall) async {
    try {
      final response = await apiCall;
      if (response.success) {
        return response.data;
      } else {
        throw ApiException(
          message: response.message,
          statusCode: response.statusCode ?? 0,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: e.toString(),
        statusCode: 0,
      );
    }
  }

  /// Handle list response
  Future<List<T>> handleListResponse<T>(
    Future<ApiResponse<List<dynamic>>> apiCall,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    try {
      final response = await apiCall;
      if (response.success && response.hasData) {
        final data = response.dataOrThrow;
        if (data is List) {
          return data
              .map((item) => fromJson(item as Map<String, dynamic>))
              .toList();
        }
        return [];
      } else {
        throw ApiException(
          message: response.message,
          statusCode: response.statusCode ?? 0,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: e.toString(),
        statusCode: 0,
      );
    }
  }
}

