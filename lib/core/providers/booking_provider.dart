import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../bookings/models/booking_model.dart';
import '../repositories/booking_repository.dart';

/// Booking repository provider
final bookingRepositoryProvider = Provider<BookingRepository>((ref) {
  return BookingRepository();
});

/// Bookings list provider - Fetches all bookings
final bookingsProvider = FutureProvider.family<List<BookingModel>, Map<String, String>?>(
  (ref, filters) async {
    final repository = ref.watch(bookingRepositoryProvider);
    return await repository.getBookings(filters: filters);
  },
);

/// Booking details provider - Fetches single booking by ID
final bookingDetailsProvider = FutureProvider.family<BookingModel, String>(
  (ref, bookingId) async {
    final repository = ref.watch(bookingRepositoryProvider);
    return await repository.getBookingDetails(bookingId);
  },
);

/// Booking history provider
final bookingHistoryProvider = FutureProvider.family<List<BookingModel>, Map<String, String>?>(
  (ref, filters) async {
    final repository = ref.watch(bookingRepositoryProvider);
    return await repository.getBookingHistory(filters: filters);
  },
);

