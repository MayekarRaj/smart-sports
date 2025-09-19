# Smart Sports Flutter - Hybrid Architecture Guide

> **Sakiichi - Mirai Team Project**  
> **Architecture:** Hybrid Approach (Shared + Role-Specific)  
> **Framework:** Flutter with Simple Architecture  
> **Team:** Harsh (Lead), Megha (UI/UX), Manish (QA & Documentation)

## 📋 Overview

The Smart Sports application uses a **Hybrid Architecture** that combines the best of both feature-based and role-based approaches. This structure provides:

- **Shared features** for common functionality across all roles
- **Role-specific features** for customized functionality per user role
- **Common components** for reusable code and consistency
- **Core utilities** for app-wide functionality

## 🏗️ Complete Folder Structure

```
lib/
├── main.dart                          # App entry point
├── app.dart                          # Main app widget
│
├── core/                             # Core utilities (app-wide)
│   ├── constants/                    # App constants and configurations
│   │   ├── app_constants.dart       # General app constants
│   │   ├── api_endpoints.dart       # API endpoint URLs
│   │   └── app_colors.dart          # Color palette
│   ├── services/                     # Core services
│   │   ├── api_service.dart         # HTTP client and API calls
│   │   ├── storage_service.dart     # Local storage management
│   │   ├── auth_service.dart        # Authentication logic
│   │   └── navigation_service.dart  # Navigation helper
│   ├── utils/                        # Utility functions
│   │   ├── validators.dart          # Form validation helpers
│   │   ├── helpers.dart             # General helper functions
│   │   └── extensions.dart          # Dart extensions
│   └── widgets/                      # Core reusable widgets
│       ├── loading_widget.dart      # Loading indicators
│       ├── error_widget.dart        # Error display widgets
│       └── custom_button.dart       # Standardized buttons
│
├── common/                           # Shared components (cross-role)
│   ├── models/                      # Shared data models
│   │   ├── user.dart               # User model
│   │   ├── booking.dart            # Booking model
│   │   ├── court.dart              # Court model
│   │   ├── event.dart              # Event model
│   │   ├── complaint.dart          # Complaint model
│   │   └── api_response.dart       # Generic API response
│   ├── services/                    # Shared business services
│   │   ├── booking_service.dart    # Booking operations
│   │   ├── court_service.dart      # Court operations
│   │   ├── event_service.dart      # Event operations
│   │   ├── user_service.dart       # User operations
│   │   └── complaint_service.dart  # Complaint operations
│   └── widgets/                     # Shared UI components
│       ├── forms/                  # Common form widgets
│       ├── cards/                  # Common card widgets
│       └── layout/                 # Common layout widgets
│
├── shared/                           # Shared features (same for all roles)
│   ├── screens/                     # Common screens
│   │   ├── auth/                   # Authentication screens
│   │   │   ├── login_screen.dart
│   │   │   ├── signup_screen.dart
│   │   │   ├── forgot_password_screen.dart
│   │   │   └── otp_verification_screen.dart
│   │   ├── splash/                 # App splash screen
│   │   │   └── splash_screen.dart
│   │   ├── complaints/             # Generic complaint handling
│   │   │   ├── complaints_list_screen.dart
│   │   │   ├── complaint_details_screen.dart
│   │   │   └── create_complaint_screen.dart
│   │   └── settings/               # Common app settings
│   │       ├── settings_screen.dart
│   │       ├── profile_settings_screen.dart
│   │       ├── notification_settings_screen.dart
│   │       └── privacy_settings_screen.dart
│   ├── widgets/                     # Shared UI components
│   │   ├── forms/                  # Common form widgets
│   │   │   ├── custom_text_field.dart
│   │   │   ├── custom_dropdown.dart
│   │   │   ├── custom_date_picker.dart
│   │   │   └── custom_button.dart
│   │   ├── cards/                  # Common card widgets
│   │   │   ├── info_card.dart
│   │   │   ├── booking_card.dart
│   │   │   ├── event_card.dart
│   │   │   └── user_card.dart
│   │   └── layout/                 # Common layout widgets
│   │       ├── app_scaffold.dart
│   │       ├── page_wrapper.dart
│   │       └── responsive_layout.dart
│   └── providers/                   # Shared state management
│       ├── auth_provider.dart      # Authentication state
│       ├── user_provider.dart      # User state
│       └── app_provider.dart       # App-wide state
│
├── role_specific/                    # Role-specific features
│   ├── corporate/                   # Corporate role features
│   │   ├── screens/                # Corporate-specific screens
│   │   │   ├── dashboard/          # Corporate dashboard
│   │   │   │   └── corporate_dashboard_screen.dart
│   │   │   ├── users/              # Employee management
│   │   │   │   ├── users_list_screen.dart
│   │   │   │   ├── user_details_screen.dart
│   │   │   │   ├── create_user_screen.dart
│   │   │   │   └── user_profile_screen.dart
│   │   │   ├── billing/            # Invoice management
│   │   │   │   ├── invoices_list_screen.dart
│   │   │   │   ├── invoice_details_screen.dart
│   │   │   │   ├── create_invoice_screen.dart
│   │   │   │   └── billing_reports_screen.dart
│   │   │   ├── my_clubs/           # Corporate club access
│   │   │   │   ├── corporate_clubs_list_screen.dart
│   │   │   │   └── corporate_club_details_screen.dart
│   │   │   ├── my_bookings/        # Corporate booking view
│   │   │   │   ├── corporate_bookings_list_screen.dart
│   │   │   │   ├── corporate_booking_details_screen.dart
│   │   │   │   └── corporate_create_booking_screen.dart
│   │   │   ├── events/             # Corporate events
│   │   │   │   ├── corporate_events_list_screen.dart
│   │   │   │   ├── corporate_event_details_screen.dart
│   │   │   │   └── corporate_create_event_screen.dart
│   │   │   ├── sponsorships/       # Corporate sponsorships
│   │   │   │   ├── corporate_sponsorships_list_screen.dart
│   │   │   │   ├── corporate_sponsorship_details_screen.dart
│   │   │   │   └── corporate_create_sponsorship_screen.dart
│   │   │   └── referrals/          # Corporate referrals
│   │   │       ├── corporate_referrals_list_screen.dart
│   │   │       └── corporate_create_referral_screen.dart
│   │   ├── widgets/                # Corporate-specific widgets
│   │   │   ├── employee_card.dart
│   │   │   ├── invoice_card.dart
│   │   │   └── corporate_booking_card.dart
│   │   └── providers/              # Corporate state management
│   │       ├── corporate_provider.dart
│   │       ├── billing_provider.dart
│   │       └── users_provider.dart
│   │
│   ├── club/                       # Club role features
│   │   ├── screens/                # Club-specific screens
│   │   │   ├── dashboard/          # Club dashboard
│   │   │   │   └── club_dashboard_screen.dart
│   │   │   ├── courts/             # Court management
│   │   │   │   ├── courts_list_screen.dart
│   │   │   │   ├── court_details_screen.dart
│   │   │   │   ├── create_court_screen.dart
│   │   │   │   └── court_schedule_screen.dart
│   │   │   ├── bookings/           # Booking calendar
│   │   │   │   ├── club_bookings_calendar_screen.dart
│   │   │   │   ├── club_booking_management_screen.dart
│   │   │   │   └── club_booking_analytics_screen.dart
│   │   │   ├── events/             # Club events
│   │   │   │   ├── club_events_list_screen.dart
│   │   │   │   ├── club_event_details_screen.dart
│   │   │   │   └── club_create_event_screen.dart
│   │   │   ├── orders/             # Equipment orders
│   │   │   │   ├── club_orders_list_screen.dart
│   │   │   │   ├── club_order_details_screen.dart
│   │   │   │   └── club_create_order_screen.dart
│   │   │   ├── sponsorships/       # Club sponsorships
│   │   │   │   ├── club_sponsorships_list_screen.dart
│   │   │   │   └── club_sponsorship_details_screen.dart
│   │   │   ├── users/              # Club members
│   │   │   │   ├── club_members_list_screen.dart
│   │   │   │   ├── club_member_details_screen.dart
│   │   │   │   └── club_create_member_screen.dart
│   │   │   └── referrals/          # Club referrals
│   │   │       ├── club_referrals_list_screen.dart
│   │   │       └── club_create_referral_screen.dart
│   │   ├── widgets/                # Club-specific widgets
│   │   │   ├── court_card.dart
│   │   │   ├── booking_calendar_widget.dart
│   │   │   └── member_card.dart
│   │   └── providers/              # Club state management
│   │       ├── club_provider.dart
│   │       ├── courts_provider.dart
│   │       └── bookings_provider.dart
│   │
│   ├── coach/                      # Coach role features
│   │   ├── screens/                # Coach-specific screens
│   │   │   ├── dashboard/          # Coach dashboard
│   │   │   ├── my_clubs/           # Nearby clubs
│   │   │   ├── my_bookings/        # Coach bookings
│   │   │   ├── events/             # Coach events
│   │   │   ├── sponsorships/       # Coach sponsorships
│   │   │   └── referrals/          # Coach referrals
│   │   ├── widgets/                # Coach-specific widgets
│   │   └── providers/              # Coach state management
│   │
│   ├── merchandiser/               # Merchandiser role features
│   │   ├── screens/                # Merchandiser-specific screens
│   │   │   ├── dashboard/          # Merchandiser dashboard
│   │   │   ├── events/             # Merchandiser events
│   │   │   ├── sponsorships/       # View-only sponsorships
│   │   │   ├── orders/             # Order fulfillment
│   │   │   └── referrals/          # Merchandiser referrals
│   │   ├── widgets/                # Merchandiser-specific widgets
│   │   └── providers/              # Merchandiser state management
│   │
│   ├── freelancer/                 # Freelancer role features
│   │   ├── screens/                # Freelancer-specific screens
│   │   │   ├── dashboard/          # Freelancer dashboard
│   │   │   ├── orders/             # Service requests
│   │   │   ├── events/             # Freelancer events
│   │   │   ├── sponsorships/       # Freelancer sponsorships
│   │   │   └── referrals/          # Freelancer referrals
│   │   ├── widgets/                # Freelancer-specific widgets
│   │   └── providers/              # Freelancer state management
│   │
│   └── member/                     # Member role features
│       ├── screens/                # Member-specific screens
│       │   ├── dashboard/          # Member dashboard
│       │   ├── my_bookings/        # Personal bookings
│       │   ├── my_clubs/           # Favorite clubs
│       │   ├── events/             # Member events
│       │   ├── orders/             # Equipment requests
│       │   ├── sponsorships/       # Member sponsorships
│       │   └── referrals/          # Member referrals
│       ├── widgets/                # Member-specific widgets
│       └── providers/              # Member state management
│
├── theme/                           # App theming
│   ├── app_theme.dart              # Main theme configuration
│   ├── app_colors.dart             # Color palette
│   ├── app_text_styles.dart        # Typography
│   └── app_dimensions.dart         # Spacing and sizing
│
├── routes/                          # Navigation routes
│   ├── app_router.dart             # Main router configuration
│   ├── route_names.dart            # Route name constants
│   └── route_guards.dart           # Route protection logic
│
└── assets/                          # App assets
    ├── images/                      # Image assets
    │   ├── logos/                   # App logos
    │   ├── icons/                   # Custom icons
    │   └── illustrations/           # Illustrations
    ├── fonts/                       # Custom fonts
    └── animations/                  # Lottie animations
```

## 🎯 Architecture Principles

### 1. **Shared Features (lib/shared/)**
Features that are **identical** across all user roles:
- **Authentication** - Login, signup, forgot password
- **Complaints** - Generic complaint handling
- **Settings** - Common app settings
- **Splash Screen** - App loading screen

### 2. **Role-Specific Features (lib/role_specific/)**
Features that are **different** for each user role:
- **Corporate** - Employee management, billing, corporate bookings
- **Club** - Court management, booking calendar, member management
- **Coach** - Personal bookings, nearby clubs, coach fees
- **Member** - Simple bookings, event subscriptions
- **Merchandiser** - Product fulfillment, order management
- **Freelancer** - Service requests, quotations

### 3. **Common Components (lib/common/)**
Reusable components used across multiple roles:
- **Models** - Shared data structures
- **Services** - Shared business logic
- **Widgets** - Reusable UI components

### 4. **Core Utilities (lib/core/)**
App-wide functionality and utilities:
- **Constants** - App configuration
- **Services** - Core services (API, storage, auth)
- **Utils** - Helper functions
- **Widgets** - Core UI components

## 🔄 How It Works

### **Navigation Logic:**
```dart
// Based on user role, navigate to appropriate screens
switch (userRole) {
  case 'corporate':
    return CorporateBookingsScreen();  // Employee management
  case 'club':
    return ClubBookingsScreen();       // Calendar management
  case 'member':
    return MemberBookingsScreen();     // Personal bookings
  // ... other roles
}
```

### **Feature Placement Decision Tree:**
```
Is this feature the same for ALL roles?
├── YES → lib/shared/
└── NO → Is this feature different for each role?
    ├── YES → lib/role_specific/[role]/
    └── NO → lib/common/
```

### **Example: Bookings Feature**

**Shared (lib/shared/):**
- Complaint about booking issues

**Common (lib/common/):**
- Booking model, booking service

**Role-Specific (lib/role_specific/):**
- **Corporate:** Employee booking management
- **Club:** Booking calendar and management
- **Member:** Personal booking interface

## 📋 Development Guidelines

### **1. Where to Place New Features**

#### **Place in lib/shared/ if:**
- Feature is identical for all roles
- No role-specific customization needed
- Common functionality (auth, settings, complaints)

#### **Place in lib/role_specific/ if:**
- Feature is different for each role
- Role-specific UI and logic required
- Customized functionality per role

#### **Place in lib/common/ if:**
- Feature is shared but has role variations
- Reusable components across roles
- Shared business logic

### **2. File Naming Conventions**

#### **Screens:**
- Shared: `login_screen.dart`
- Role-specific: `corporate_dashboard_screen.dart`
- Common: `booking_details_screen.dart`

#### **Widgets:**
- Shared: `custom_button.dart`
- Role-specific: `corporate_booking_card.dart`
- Common: `booking_card.dart`

#### **Services:**
- Core: `api_service.dart`
- Common: `booking_service.dart`
- Role-specific: `corporate_billing_service.dart`

### **3. Import Structure**

#### **From Shared:**
```dart
import 'package:smart_sports/shared/screens/auth/login_screen.dart';
import 'package:smart_sports/shared/widgets/forms/custom_text_field.dart';
```

#### **From Role-Specific:**
```dart
import 'package:smart_sports/role_specific/corporate/screens/billing/invoices_list_screen.dart';
import 'package:smart_sports/role_specific/corporate/widgets/invoice_card.dart';
```

#### **From Common:**
```dart
import 'package:smart_sports/common/models/booking.dart';
import 'package:smart_sports/common/services/booking_service.dart';
```

## 🚀 Development Workflow

### **Phase 1: Shared Features**
1. Build authentication system
2. Create common settings
3. Implement complaint handling
4. Set up splash screen

### **Phase 2: Common Components**
1. Create shared models
2. Build common services
3. Develop reusable widgets
4. Set up core utilities

### **Phase 3: Role-Specific Features**
1. Start with one role (e.g., Corporate)
2. Build role-specific screens
3. Create role-specific widgets
4. Implement role-specific logic
5. Repeat for other roles

### **Phase 4: Integration**
1. Connect shared and role-specific features
2. Implement navigation logic
3. Add role-based permissions
4. Test cross-role functionality

## 📊 Benefits of This Structure

### **✅ Advantages:**
- **Clear Separation** - Know exactly where each feature belongs
- **Easy Development** - Start with shared features, add role-specific ones
- **Team Collaboration** - Different developers can work on different roles
- **Scalable** - Easy to add new roles or modify existing ones
- **Maintainable** - Fix shared bugs once, role-specific bugs in isolation
- **Flexible** - Can move features between shared/role-specific as needed
- **Performance** - Load only role-specific code when needed

### **⚠️ Considerations:**
- **Decision Complexity** - Need to decide where each feature belongs
- **Learning Curve** - Developers need to understand the structure
- **Code Review** - Need to review both shared and role-specific code
- **Documentation** - Need to document both approaches

## 🎯 Team Responsibilities

### **Harsh (Lead Developer):**
- Core architecture and navigation
- Shared features and common components
- Integration between shared and role-specific
- Final testing and deployment

### **Megha (UI/UX Developer):**
- Shared widgets and common UI components
- Role-specific UI implementations
- Theme and styling system
- Responsive design implementation

### **Manish (QA & Documentation):**
- Role-specific feature development
- Testing across all roles
- Documentation maintenance
- Quality assurance

## 📚 Additional Resources

- **Architecture Overview:** `lib/architecture_overview.md`
- **Package Selection:** `lib/simple_packages.md`
- **Comparison Guide:** `lib/architecture_comparison.md`
- **Role-Based Structure:** `lib/role_based_structure.md`

---

**This hybrid architecture provides the perfect balance between simplicity and organization for your Smart Sports application. It allows for fast development while maintaining clear separation of concerns and scalability for future growth.**
