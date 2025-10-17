# Smart Sports API Integration

This document explains how to use the API integration in the Smart Sports Flutter app.

## 🚀 Quick Start

The API integration is now fully implemented and ready to use. Here's what has been added:

### 1. Dependencies Added
- `http: ^1.1.0` - HTTP client for API calls
- `shared_preferences: ^2.2.2` - Local storage for auth tokens

### 2. API Service Structure
```
lib/core/
├── config/
│   └── api_config.dart          # API configuration and endpoints
├── models/
│   └── api_models.dart          # Request/response models
├── services/
│   └── api_service.dart         # Main API service
└── examples/
    └── api_usage_example.dart   # Usage examples
```

## 🔧 Configuration

### API Base URL
The API base URL is configured in `lib/core/config/api_config.dart`:

```dart
static const String environment = 'staging'; // Change to 'production' for live
static const String baseUrl = 'https://stg-sports-admin.sekai-ichi.com';
```

### Authentication Token
The API service automatically handles authentication tokens:
- Tokens are stored securely using SharedPreferences
- Tokens are automatically included in API requests
- Use `ApiService().logout()` to clear tokens

## 📡 Available API Endpoints

### Authentication
- **Sign In**: `POST /api/sign-in`
- **Get Profile**: `GET /api/profile/{userId}`

### Club Registration
- **Step 1**: `POST /api/signup-club`
- **Step 2**: `POST /api/signup-club-branch`

## 💻 Usage Examples

### Sign In
```dart
final apiService = ApiService();
final request = SignInRequest(
  email: 'user@example.com',
  password: 'password123',
);

final response = await apiService.signIn(request);
if (response.success) {
  print('Welcome ${response.data!.user.name}!');
}
```

### Club Registration
```dart
// Step 1: Register main club
final step1Request = ClubSignupStep1Request(
  userId: 20,
  userRole: 'club',
  clubName: 'My Club',
  // ... other fields
);

final step1Response = await apiService.clubSignupStep1(step1Request);

// Step 2: Register branches
final step2Request = ClubSignupStep2Request(
  userId: 20,
  clubId: step1Response.data!.clubId,
  branches: [/* branch data */],
);

final step2Response = await apiService.clubSignupStep2(step2Request);
```

## 🔄 Integration Status

### ✅ Completed
- [x] HTTP client dependency added
- [x] API service with authentication endpoints
- [x] API models for requests and responses
- [x] Sign-in page updated with real API calls
- [x] Club registration page updated with real API calls
- [x] Environment configuration for API base URL
- [x] Loading states and error handling
- [x] Token management and storage

### 🎯 Features Implemented

#### Authentication
- Real API sign-in with email/password
- Automatic token storage and management
- User profile retrieval
- Loading states and error messages

#### Club Registration
- Two-step club registration process
- Dynamic branch management
- Form validation and submission
- Real-time API integration
- Success/error feedback

## 🛠️ API Service Methods

### Authentication
```dart
// Sign in user
Future<ApiResponse<SignInResponse>> signIn(SignInRequest request)

// Get user profile
Future<ApiResponse<UserProfile>> getProfile(int userId)

// Logout user
Future<void> logout()
```

### Club Registration
```dart
// Register club (step 1)
Future<ApiResponse<ClubSignupResponse>> clubSignupStep1(ClubSignupStep1Request request)

// Register branches (step 2)
Future<ApiResponse<ClubSignupResponse>> clubSignupStep2(ClubSignupStep2Request request)
```

## 🔐 Security Features

- Secure token storage using SharedPreferences
- Automatic token inclusion in API requests
- Proper error handling and user feedback
- Input validation and sanitization

## 📱 UI Integration

### Sign In Page
- Real API authentication
- Loading spinner during requests
- Success/error messages
- Automatic navigation on success

### Club Registration Page
- Two-step API submission
- Form validation before submission
- Loading states during API calls
- Success/error feedback
- Automatic navigation to next step

## 🧪 Testing

To test the API integration:

1. **Sign In Test**:
   - Use valid credentials
   - Check for successful authentication
   - Verify token storage

2. **Club Registration Test**:
   - Fill out the club registration form
   - Submit and verify API calls
   - Check for proper error handling

## 🔧 Environment Setup

### Development
```dart
static const String environment = 'development';
static const String baseUrl = 'http://localhost:8000';
```

### Staging
```dart
static const String environment = 'staging';
static const String baseUrl = 'https://stg-sports-admin.sekai-ichi.com';
```

### Production
```dart
static const String environment = 'production';
static const String baseUrl = 'https://sports-admin.sekai-ichi.com';
```

## 📋 API Request Examples

### Sign In Request
```json
{
  "email": "user@example.com",
  "password": "password123"
}
```

### Club Registration Step 1
```json
{
  "user_id": 20,
  "user_role": "club",
  "club_name": "Global Club",
  "no_of_users": 10,
  "is_address_is_same_as_user": 1,
  "address_line1": "123 MG Road",
  "address_line2": "Near Metro Station",
  "city": "Bangalore",
  "state": "Karnataka",
  "zipcode": "560001",
  "country": "India",
  "is_contact_details_is_same_user": 1,
  "office_phone_ext": "001",
  "office_phone": "5551234567",
  "mobile_phone_ext": "91",
  "mobile_phone": "9876543210",
  "company_website": "https://www.globalclub.com",
  "sports_is_same_as_user": 0,
  "sports_names": ["Football", "Basketball", "Tennis"],
  "operational_details": [
    {
      "open_days": "Weekdays",
      "club_start_time": "09:00",
      "club_end_time": "18:00"
    }
  ]
}
```

## 🚨 Error Handling

The API service includes comprehensive error handling:

- Network connectivity issues
- Invalid credentials
- Server errors
- Timeout handling
- User-friendly error messages

## 📈 Next Steps

1. **Add more API endpoints** as needed
2. **Implement offline support** with local caching
3. **Add request/response logging** for debugging
4. **Implement retry logic** for failed requests
5. **Add API response caching** for better performance

## 🤝 Support

For questions or issues with the API integration:

1. Check the `api_usage_example.dart` file for examples
2. Review the API service documentation
3. Test with the provided endpoints
4. Check network connectivity and API availability

---

**Note**: Make sure to update the API base URL and authentication token as needed for your environment.
