# 🚀 API Architecture - Quick Start Guide

## ✅ What We've Built

A complete API architecture foundation for your Smart Sports Flutter app:

### 1. **NetworkClient** (`lib/core/network/network_client.dart`)
- Base HTTP client with automatic token management
- Handles GET, POST, PUT, DELETE requests
- Automatic error handling and logging
- Timeout management

### 2. **Repositories** (`lib/core/repositories/`)
- `BaseRepository` - Base class with common functionality
- `AuthRepository` - Authentication API calls ✅
- `BookingRepository` - Booking API calls ✅
- More repositories to be added...

### 3. **Exceptions** (`lib/core/exceptions/api_exception.dart`)
- `ApiException` - Custom API errors
- `NetworkException` - Network connectivity issues
- `ValidationException` - Request validation errors

### 4. **Response Models** (`lib/core/models/api_response.dart`)
- `ApiResponse<T>` - Generic response wrapper
- Type-safe responses

### 5. **API Configuration** (`lib/core/config/` & `lib/core/constants/`)
- Centralized endpoint definitions
- Environment configuration
- Easy to add new endpoints

## 📖 How to Use

### Example 1: Using AuthRepository

```dart
import 'package:smart_sports/core/repositories/auth_repository.dart';
import 'package:smart_sports/core/models/api_models.dart';

// In your widget/service
final authRepo = AuthRepository();

try {
  // Sign in
  final response = await authRepo.signIn(
    SignInRequest(
      email: 'user@example.com',
      password: 'password123',
    ),
  );
  
  // Token is automatically saved
  print('Signed in: ${response.user.name}');
  
} on ApiException catch (e) {
  // Handle API error
  if (e.isUnauthorized) {
    print('Invalid credentials');
  } else {
    print('Error: ${e.message}');
  }
} catch (e) {
  print('Unexpected error: $e');
}
```

### Example 2: Using BookingRepository

```dart
import 'package:smart_sports/core/repositories/booking_repository.dart';

final bookingRepo = BookingRepository();

try {
  // Get bookings
  final bookings = await bookingRepo.getBookings(
    filters: {'status': 'confirmed'},
    page: 1,
    limit: 10,
  );
  
  // Use bookings
  for (var booking in bookings) {
    print('Booking: ${booking.bookingId}');
  }
  
} on ApiException catch (e) {
  if (e.isNetworkError) {
    print('No internet connection');
  } else {
    print('Error: ${e.message}');
  }
}
```

### Example 3: Creating a New Repository

```dart
// lib/core/repositories/event_repository.dart
import '../network/network_client.dart';
import '../constants/api_endpoints.dart';
import '../../events/models/event_models.dart';
import 'base_repository.dart';

class EventRepository extends BaseRepository {
  Future<List<EventInfo>> getEvents() async {
    return await handleListResponse<EventInfo>(
      networkClient.get<List<dynamic>>(
        ApiEndpoints.getEventsUrl(),
        fromJson: (data) => data as List<dynamic>,
      ),
      (json) => EventInfo.fromJson(json),
    );
  }
  
  Future<EventInfo> createEvent(Map<String, dynamic> eventData) async {
    return await handleResponse(
      networkClient.post<EventInfo>(
        ApiEndpoints.getCreateEventUrl(),
        body: eventData,
        fromJson: (data) => EventInfo.fromJson(data as Map<String, dynamic>),
      ),
    );
  }
}
```

## 🔄 Migrating Existing Code

### Before (Using Mock Data):
```dart
final bookingService = BookingService();
bookingService.initializeBookings();
final bookings = bookingService.bookings;
```

### After (Using Repository):
```dart
final bookingRepo = BookingRepository();
try {
  final bookings = await bookingRepo.getBookings();
  // Handle bookings
} on ApiException catch (e) {
  // Handle error
}
```

## 📝 Adding New Endpoints

1. **Add endpoint constant** in `lib/core/constants/api_endpoints.dart`:
```dart
static const String myNewEndpoint = '/my-endpoint';
static String getMyNewEndpointUrl() => '${ApiConfig.apiBaseUrl}$myNewEndpoint';
```

2. **Add method in repository**:
```dart
Future<MyModel> getMyData() async {
  return await handleResponse(
    networkClient.get<MyModel>(
      ApiEndpoints.getMyNewEndpointUrl(),
      fromJson: (data) => MyModel.fromJson(data as Map<String, dynamic>),
    ),
  );
}
```

## 🎯 Next Steps

1. **Add fromJson/toJson to models** - See `API_IMPLEMENTATION_ROADMAP.md`
2. **Create remaining repositories** - Event, User, Court, etc.
3. **Replace mock services** - Update all services to use repositories
4. **Add error handling** - Wrap all API calls in try-catch
5. **Add loading states** - Show loading indicators during API calls

## 📚 Documentation

- **Full Architecture Guide**: `API_ARCHITECTURE_GUIDE.md`
- **Implementation Roadmap**: `API_IMPLEMENTATION_ROADMAP.md`
- **Code Examples**: See `lib/core/repositories/` for examples

## ⚠️ Important Notes

1. **Token Management**: Tokens are automatically saved/cleared by `NetworkClient`
2. **Error Handling**: Always use try-catch with `ApiException`
3. **Type Safety**: Use generic types (`ApiResponse<T>`) for type safety
4. **Repository Pattern**: Always use repositories, never call `NetworkClient` directly from UI

## 🐛 Troubleshooting

### Issue: "ApiException: Network error"
- Check internet connection
- Check if API server is running
- Verify API base URL in `api_config.dart`

### Issue: "ApiException: Unauthorized (401)"
- Token may be expired
- Call `authRepo.refreshToken()` or re-login

### Issue: Models not parsing correctly
- Ensure models have `fromJson` factory constructor
- Check JSON structure matches API response
- Verify all required fields are present

## ✅ Checklist for Each Feature

- [ ] Model has `fromJson` factory
- [ ] Model has `toJson` method
- [ ] Repository created
- [ ] Endpoints defined
- [ ] Error handling added
- [ ] Loading states added
- [ ] Tested with real API

