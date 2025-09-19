# Smart Sports - Role-Based Folder Structure

## 🎯 Better Approach: Role-First Organization

### Current Problem:
- Feature-based folders (bookings/, complaints/, courts/)
- But we have 6 different roles with different features
- Same feature looks different for different roles
- Hard to manage role-specific logic

### Better Solution:
Organize by **ROLES** first, then **FEATURES** within each role.

## 📁 Recommended Role-Based Structure

```
lib/
├── main.dart
├── app.dart
│
├── core/                             # Core utilities (same for all)
│   ├── constants/
│   ├── services/
│   ├── utils/
│   └── widgets/
│
├── models/                           # Shared data models
│   ├── user.dart
│   ├── booking.dart
│   ├── court.dart
│   └── event.dart
│
├── services/                         # Shared business services
│   ├── api_service.dart
│   ├── auth_service.dart
│   └── storage_service.dart
│
├── providers/                        # Shared state management
│   ├── auth_provider.dart
│   └── user_provider.dart
│
├── roles/                           # ROLE-BASED ORGANIZATION
│   ├── corporate/                   # Corporate role features
│   │   ├── screens/
│   │   │   ├── dashboard/
│   │   │   ├── users/              # Employee management
│   │   │   ├── billing/            # Invoice management
│   │   │   ├── my_clubs/
│   │   │   ├── my_bookings/
│   │   │   ├── events/
│   │   │   ├── sponsorships/
│   │   │   ├── referrals/
│   │   │   ├── complaints/
│   │   │   └── settings/
│   │   ├── widgets/                # Role-specific widgets
│   │   └── providers/              # Role-specific state
│   │
│   ├── club/                       # Club role features
│   │   ├── screens/
│   │   │   ├── dashboard/
│   │   │   ├── courts/             # Court management
│   │   │   ├── bookings/           # Booking calendar
│   │   │   ├── events/
│   │   │   ├── orders/             # Equipment orders
│   │   │   ├── sponsorships/
│   │   │   ├── users/              # Club members
│   │   │   ├── referrals/
│   │   │   ├── complaints/
│   │   │   └── settings/
│   │   ├── widgets/
│   │   └── providers/
│   │
│   ├── coach/                      # Coach role features
│   │   ├── screens/
│   │   │   ├── dashboard/
│   │   │   ├── my_clubs/           # Nearby clubs
│   │   │   ├── my_bookings/        # Coach bookings
│   │   │   ├── events/
│   │   │   ├── sponsorships/
│   │   │   ├── referrals/
│   │   │   ├── complaints/
│   │   │   └── settings/
│   │   ├── widgets/
│   │   └── providers/
│   │
│   ├── merchandiser/               # Merchandiser role features
│   │   ├── screens/
│   │   │   ├── dashboard/
│   │   │   ├── events/
│   │   │   ├── sponsorships/       # View only
│   │   │   ├── orders/             # Fulfillment
│   │   │   ├── referrals/
│   │   │   ├── complaints/
│   │   │   └── settings/
│   │   ├── widgets/
│   │   └── providers/
│   │
│   ├── freelancer/                 # Freelancer role features
│   │   ├── screens/
│   │   │   ├── dashboard/
│   │   │   ├── orders/             # Service requests
│   │   │   ├── events/
│   │   │   ├── sponsorships/
│   │   │   ├── referrals/
│   │   │   ├── complaints/
│   │   │   └── settings/
│   │   ├── widgets/
│   │   └── providers/
│   │
│   └── member/                     # Member role features
│       ├── screens/
│       │   ├── dashboard/
│       │   ├── my_bookings/        # Personal bookings
│       │   ├── my_clubs/
│       │   ├── events/
│       │   ├── orders/             # Equipment requests
│       │   ├── sponsorships/
│       │   ├── referrals/
│       │   ├── complaints/
│       │   └── settings/
│       ├── widgets/
│       └── providers/
│
├── shared/                         # Shared across all roles
│   ├── screens/
│   │   ├── auth/                  # Login, Signup, Forgot Password
│   │   └── splash/                # Splash screen
│   ├── widgets/                   # Common widgets
│   │   ├── forms/
│   │   ├── cards/
│   │   └── layout/
│   └── providers/                 # Common providers
│
├── theme/                         # App theming
├── routes/                        # Navigation routes
└── assets/                        # App assets
```

## 🎯 Benefits of Role-Based Structure

### 1. **Clear Role Separation**
- Each role has its own folder
- Easy to find role-specific features
- Clear ownership and responsibility

### 2. **Feature Customization**
- Same feature (e.g., "bookings") can be different for each role
- Corporate bookings vs Club bookings vs Member bookings
- Role-specific UI and logic

### 3. **Easy Development**
- Team members can work on specific roles
- No confusion about which feature belongs to which role
- Clear development boundaries

### 4. **Scalable**
- Easy to add new roles
- Easy to add new features to existing roles
- Easy to modify role-specific features

## 🔄 How It Works

### Example: Bookings Feature

**Corporate Role:**
```
lib/roles/corporate/screens/my_bookings/
├── corporate_bookings_list.dart    # Employee bookings
├── corporate_booking_details.dart  # Corporate-specific details
└── corporate_create_booking.dart   # Corporate booking form
```

**Club Role:**
```
lib/roles/club/screens/bookings/
├── club_bookings_calendar.dart     # Calendar view
├── club_booking_management.dart    # Manage all bookings
└── club_booking_analytics.dart     # Booking reports
```

**Member Role:**
```
lib/roles/member/screens/my_bookings/
├── member_bookings_list.dart       # Personal bookings
├── member_booking_details.dart     # Member-specific details
└── member_create_booking.dart      # Simple booking form
```

### Navigation Logic:
```dart
// Based on user role, navigate to appropriate screens
switch (userRole) {
  case 'corporate':
    return CorporateBookingsScreen();
  case 'club':
    return ClubBookingsScreen();
  case 'member':
    return MemberBookingsScreen();
  // ... other roles
}
```

## 🚀 Implementation Strategy

### 1. **Shared Components**
- Common models, services, and utilities
- Shared authentication and navigation
- Common widgets and themes

### 2. **Role-Specific Components**
- Role-specific screens and widgets
- Role-specific business logic
- Role-specific state management

### 3. **Dynamic Navigation**
- Route based on user role
- Role-based sidebar/menu
- Role-based permissions

## 📋 Migration from Current Structure

### Current:
```
lib/screens/bookings/     # Generic bookings
lib/screens/complaints/   # Generic complaints
```

### New:
```
lib/roles/corporate/screens/my_bookings/    # Corporate bookings
lib/roles/club/screens/bookings/            # Club bookings
lib/roles/member/screens/my_bookings/       # Member bookings
```

This approach makes it much clearer which features belong to which roles and allows for role-specific customization.
