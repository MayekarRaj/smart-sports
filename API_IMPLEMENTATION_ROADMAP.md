# 🚀 API Implementation Roadmap

## 📋 Overview

This document outlines the step-by-step plan to migrate from mock data to real API integration using the new architecture.

## ✅ Phase 1: Foundation (COMPLETED)

- [x] Create `NetworkClient` - Base HTTP client
- [x] Create `BaseRepository` - Base repository class
- [x] Create `ApiException` - Custom exception classes
- [x] Create `ApiResponse<T>` - Generic response wrapper
- [x] Update `ApiEndpoints` - All endpoint definitions
- [x] Create `AuthRepository` - Authentication API calls
- [x] Create `BookingRepository` - Booking API calls

## ⏳ Phase 2: Complete Repository Layer

### 2.1 Create Remaining Repositories

- [ ] `EventRepository` - Event management
- [ ] `UserRepository` - User management
- [ ] `CourtRepository` - Court management
- [ ] `TransactionRepository` - Transaction management
- [ ] `ReferralRepository` - Referral system
- [ ] `SupportRepository` - Customer support
- [ ] `ClubRepository` - Club management
- [ ] `InventoryRepository` - Inventory (for Merchandiser)

### 2.2 Update Models

For each model, add:
- [ ] `fromJson(Map<String, dynamic> json)` factory constructor
- [ ] `toJson()` method
- [ ] Handle nullable fields properly
- [ ] Handle enum conversions

Models to update:
- [ ] `BookingModel` and related classes
- [ ] `EventInfo`, `EventDraft` and related
- [ ] `User` model
- [ ] `Court` model
- [ ] Transaction models
- [ ] Referral models
- [ ] Support ticket models

## ⏳ Phase 3: Migrate Services

### 3.1 Authentication Service

- [ ] Replace `ApiService` with `AuthRepository`
- [ ] Update `sign_in_page.dart` to use repository
- [ ] Update `sign_up_page.dart` to use repository
- [ ] Update `verify_email_page.dart` to use repository
- [ ] Update `forgot_password_page.dart` to use repository
- [ ] Update `reset_password_page.dart` to use repository
- [ ] Add proper error handling
- [ ] Add loading states

### 3.2 Booking Service

- [ ] Replace `BookingService` mock data with `BookingRepository`
- [ ] Update `booking_management_screen.dart`
- [ ] Update `add_booking_screen.dart`
- [ ] Add pagination support
- [ ] Add filtering via API
- [ ] Add error handling
- [ ] Add loading states

### 3.3 Event Service

- [ ] Create `EventRepository`
- [ ] Update event screens to use repository
- [ ] Add error handling
- [ ] Add loading states

### 3.4 User Service

- [ ] Create `UserRepository`
- [ ] Update user management screens
- [ ] Add CRUD operations
- [ ] Add error handling

### 3.5 Other Services

- [ ] Court management
- [ ] Transactions
- [ ] Referrals
- [ ] Customer support
- [ ] Role-specific features

## ⏳ Phase 4: Error Handling & UX

### 4.1 Global Error Handling

- [ ] Create error handler utility
- [ ] Show user-friendly error messages
- [ ] Handle 401 (Unauthorized) - redirect to login
- [ ] Handle 403 (Forbidden) - show access denied
- [ ] Handle 404 (Not Found) - show not found message
- [ ] Handle 500 (Server Error) - show server error
- [ ] Handle network errors - show offline message

### 4.2 Loading States

- [ ] Add loading indicators for all API calls
- [ ] Use `LoadingWidget` consistently
- [ ] Add skeleton loaders for lists
- [ ] Add pull-to-refresh where appropriate

### 4.3 Empty States

- [ ] Add empty state widgets
- [ ] Show appropriate messages for empty data
- [ ] Add action buttons (e.g., "Create First Booking")

## ⏳ Phase 5: Advanced Features

### 5.1 Caching

- [ ] Implement response caching
- [ ] Cache user profile
- [ ] Cache bookings list
- [ ] Cache events list
- [ ] Add cache invalidation

### 5.2 Offline Support

- [ ] Store data locally
- [ ] Queue requests when offline
- [ ] Sync when back online

### 5.3 Token Refresh

- [ ] Implement automatic token refresh
- [ ] Handle token expiration
- [ ] Refresh on 401 errors

### 5.4 Retry Logic

- [ ] Add retry for failed requests
- [ ] Exponential backoff
- [ ] Max retry attempts

## 📝 Implementation Priority

### High Priority (Core Features)
1. ✅ Authentication (COMPLETED)
2. ⏳ Bookings
3. ⏳ Events
4. ⏳ User Management

### Medium Priority (Important Features)
5. ⏳ Courts
6. ⏳ Transactions
7. ⏳ Referrals

### Low Priority (Nice to Have)
8. ⏳ Customer Support
9. ⏳ Advanced caching
10. ⏳ Offline support

## 🎯 Success Criteria

- [ ] All mock services replaced with repositories
- [ ] All API calls handle errors properly
- [ ] All screens show loading states
- [ ] All screens show error messages
- [ ] All screens show empty states
- [ ] All models have fromJson/toJson
- [ ] All endpoints tested
- [ ] Documentation complete

## 📚 Resources

- See `API_ARCHITECTURE_GUIDE.md` for architecture details
- See `lib/core/repositories/` for repository examples
- See `lib/core/network/network_client.dart` for HTTP client usage

## 🔄 Migration Checklist Template

For each feature/service:

```
[ ] Create repository (if not exists)
[ ] Add fromJson/toJson to models
[ ] Update service to use repository
[ ] Update UI to handle loading state
[ ] Update UI to handle error state
[ ] Update UI to handle empty state
[ ] Test API integration
[ ] Test error scenarios
[ ] Test loading states
[ ] Update documentation
```

