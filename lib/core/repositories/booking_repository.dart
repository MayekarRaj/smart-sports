import '../network/network_client.dart';
import '../constants/api_endpoints.dart';
import '../exceptions/api_exception.dart';
import '../../bookings/models/booking_model.dart';
import 'base_repository.dart';

/// Booking repository for handling all booking-related API calls
class BookingRepository extends BaseRepository {
  /// Get all bookings with optional filters
  Future<List<BookingModel>> getBookings({
    Map<String, String>? filters,
    int? page,
    int? limit,
  }) async {
    final queryParams = <String, String>{};
    if (page != null) queryParams['page'] = page.toString();
    if (limit != null) queryParams['limit'] = limit.toString();
    if (filters != null) queryParams.addAll(filters);

    return await handleListResponse<BookingModel>(
      networkClient.get<List<dynamic>>(
        ApiEndpoints.getBookingsUrl(),
        queryParameters: queryParams.isEmpty ? null : queryParams,
        fromJson: (data) => data as List<dynamic>,
      ),
      (json) => BookingModel.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Get booking details by ID
  Future<BookingModel> getBookingDetails(String bookingId) async {
    return await handleResponse(
      networkClient.get<BookingModel>(
        ApiEndpoints.getBookingDetailsUrl(bookingId),
        fromJson: (data) => BookingModel.fromJson(data as Map<String, dynamic>),
      ),
    );
  }

  /// Create new booking
  Future<BookingModel> createBooking(Map<String, dynamic> bookingData) async {
    return await handleResponse(
      networkClient.post<BookingModel>(
        ApiEndpoints.getCreateBookingUrl(),
        body: bookingData,
        fromJson: (data) => BookingModel.fromJson(data as Map<String, dynamic>),
      ),
    );
  }

  /// Update booking
  Future<BookingModel> updateBooking(
    String bookingId,
    Map<String, dynamic> bookingData,
  ) async {
    return await handleResponse(
      networkClient.put<BookingModel>(
        ApiEndpoints.getUpdateBookingUrl(bookingId),
        body: bookingData,
        fromJson: (data) => BookingModel.fromJson(data as Map<String, dynamic>),
      ),
    );
  }

  /// Cancel booking
  Future<void> cancelBooking(String bookingId, {String? reason}) async {
    final response = await networkClient.post<Map<String, dynamic>>(
      ApiEndpoints.getCancelBookingUrl(bookingId),
      body: reason != null ? {'reason': reason} : null,
    );

    if (!response.success) {
      throw ApiException(
        message: response.message,
        statusCode: response.statusCode ?? 0,
      );
    }
  }

  /// Get booking history
  Future<List<BookingModel>> getBookingHistory({
    Map<String, String>? filters,
    int? page,
    int? limit,
  }) async {
    final queryParams = <String, String>{};
    if (page != null) queryParams['page'] = page.toString();
    if (limit != null) queryParams['limit'] = limit.toString();
    if (filters != null) queryParams.addAll(filters);

    return await handleListResponse<BookingModel>(
      networkClient.get<List<dynamic>>(
        ApiEndpoints.getBookingHistoryUrl(),
        queryParameters: queryParams.isEmpty ? null : queryParams,
        fromJson: (data) => data as List<dynamic>,
      ),
      (json) => BookingModel.fromJson(json as Map<String, dynamic>),
    );
  }
}
