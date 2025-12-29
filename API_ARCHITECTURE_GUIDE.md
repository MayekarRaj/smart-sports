# 🏗️ API Architecture Guide - Smart Sports

## 📋 Overview

This document describes the API architecture implementation for the Smart Sports Flutter application. The architecture follows a **Repository Pattern** with clean separation of concerns.

## 🎯 Architecture Goals

1. **Separation of Concerns**: Clear separation between UI, business logic, and data layers
2. **Reusability**: Shared network client and base repository
3. **Error Handling**: Centralized error handling with custom exceptions
4. **Type Safety**: Strongly typed API responses
5. **Testability**: Easy to mock and test
6. **Maintainability**: Easy to add new endpoints and features

## 📁 Directory Structure

```
lib/
├── core/
│   ├── network/
│   │   └── network_client.dart          # Base HTTP client
│   ├── repositories/
│   │   ├── base_repository.dart        # Base repository class
│   │   ├── auth_repository.dart        # Authentication API calls
│   │   ├── booking_repository.dart     # Booking API calls
│   │   ├── event_repository.dart       # Event API calls
│   │   ├── user_repository.dart        # User management API calls
│   │   └── ...                         # Other feature repositories
│   ├── exceptions/
│   │   └── api_exception.dart          # Custom exceptions
│   ├── models/
│   │   └── api_response.dart           # Generic API response wrapper
│   ├── config/
│   │   └── api_config.dart             # API configuration
│   └── constants/
│       └── api_endpoints.dart          # All API endpoints
```

## 🏛️ Architecture Layers

### 1. Network Layer (`core/network/`)

**NetworkClient** - Base HTTP client that handles:
- HTTP requests (GET, POST, PUT, DELETE)
- Authentication token management
- Request/response logging
- Error handling
- Timeout management

### 2. Repository Layer (`core/repositories/`)

**BaseRepository** - Abstract base class providing:
- Common response handling
- Error transformation
- Type-safe response parsing

**Feature Repositories** - Extend `BaseRepository`:
- `AuthRepository` - Authentication endpoints
- `BookingRepository` - Booking endpoints
- `EventRepository` - Event endpoints
- `UserRepository` - User management endpoints
- etc.

### 3. Exception Layer (`core/exceptions/`)

Custom exceptions:
- `ApiException` - General API errors
- `NetworkException` - Network connectivity issues
- `ValidationException` - Request validation errors

### 4. Model Layer (`core/models/`)

- `ApiResponse<T>` - Generic response wrapper
- Feature-specific models (in respective feature folders)

## 📝 Usage Examples

### Example 1: Authentication

```dart
// In your widget/service
final authRepo = AuthRepository();

try {
  final response = await authRepo.signIn(
    SignInRequest(email: 'user@example.com', password: 'password'),
  );
  // Handle success
} on ApiException catch (e) {
  // Handle API error
  print('Error: ${e.message}');
} catch (e) {
  // Handle other errors
}
```

### Example 2: Bookings

```dart
// In your widget/service
final bookingRepo = BookingRepository();

try {
  final bookings = await bookingRepo.getBookings(
    filters: {'status': 'confirmed'},
    page: 1,
    limit: 10,
  );
  // Use bookings
} on ApiException catch (e) {
  // Handle error
}
```

### Example 3: Creating a New Repository

```dart
import '../network/network_client.dart';
import '../constants/api_endpoints.dart';
import 'base_repository.dart';

class EventRepository extends BaseRepository {
  Future<List<EventModel>> getEvents() async {
    return await handleListResponse<EventModel>(
      networkClient.get<List<dynamic>>(
        ApiEndpoints.getEventsUrl(),
        fromJson: (data) => data as List<dynamic>,
      ),
      (json) => EventModel.fromJson(json),
    );
  }

  Future<EventModel> createEvent(Map<String, dynamic> eventData) async {
    return await handleResponse(
      networkClient.post<EventModel>(
        ApiEndpoints.getCreateEventUrl(),
        body: eventData,
        fromJson: (data) => EventModel.fromJson(data as Map<String, dynamic>),
      ),
    );
  }
}
```

## 🔄 Migration Strategy

### Step 1: Replace Mock Services

1. Identify all services using mock data
2. Create corresponding repository
3. Replace service calls with repository calls
4. Update UI to handle loading/error states

### Step 2: Update Models

1. Add `fromJson` factory constructors to models
2. Add `toJson` methods for request models
3. Ensure models match API response structure

### Step 3: Error Handling

1. Wrap repository calls in try-catch
2. Show user-friendly error messages
3. Handle specific error cases (401, 403, 404, etc.)

## 🔐 Authentication Flow

1. User signs in → `AuthRepository.signIn()`
2. Token saved automatically → `NetworkClient.saveAuthToken()`
3. All subsequent requests include token → Automatic via `NetworkClient`
4. Token refresh → `AuthRepository.refreshToken()`
5. Logout → `AuthRepository.logout()` → Clears token

## 🎨 Best Practices

1. **Always use repositories** - Don't call `NetworkClient` directly from UI
2. **Handle errors properly** - Use try-catch with specific exception types
3. **Type safety** - Use generic types for API responses
4. **Loading states** - Show loading indicators during API calls
5. **Error messages** - Display user-friendly error messages
6. **Pagination** - Use page and limit parameters for list endpoints
7. **Filtering** - Pass filters as query parameters

## 📊 API Response Structure

All API responses follow this structure:

```json
{
  "success": true,
  "message": "Success message",
  "data": { ... },
  "statusCode": 200,
  "meta": { ... } // Optional metadata
}
```

## 🚀 Next Steps

1. ✅ Create base architecture (DONE)
2. ⏳ Create all feature repositories
3. ⏳ Update models with fromJson/toJson
4. ⏳ Replace mock services with repositories
5. ⏳ Add error handling in UI
6. ⏳ Add loading states
7. ⏳ Test all endpoints
8. ⏳ Add retry logic for failed requests
9. ⏳ Add caching for offline support

## 🧪 Testing

Each repository should be testable:
- Mock `NetworkClient` for unit tests
- Test error scenarios
- Test success scenarios
- Test edge cases

## 📚 Additional Resources

- [Repository Pattern](https://martinfowler.com/eaaCatalog/repository.html)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Flutter HTTP Best Practices](https://docs.flutter.dev/cookbook/networking)

