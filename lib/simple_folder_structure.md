# Smart Sports Flutter - Simplified Project Structure

## 📁 Simple & Practical Folder Structure

```
lib/
├── main.dart                          # App entry point
├── app.dart                          # Main app widget
│
├── core/                             # Core utilities
│   ├── constants/                    # App constants
│   │   ├── app_constants.dart       # General constants
│   │   ├── api_endpoints.dart       # API URLs
│   │   └── app_colors.dart          # Color palette
│   ├── services/                     # Core services
│   │   ├── api_service.dart         # HTTP client
│   │   ├── storage_service.dart     # Local storage
│   │   ├── auth_service.dart        # Authentication
│   │   └── navigation_service.dart  # Navigation helper
│   ├── utils/                        # Utilities
│   │   ├── validators.dart          # Form validation
│   │   ├── helpers.dart             # Helper functions
│   │   └── extensions.dart          # Dart extensions
│   └── widgets/                      # Core widgets
│       ├── loading_widget.dart      # Loading indicator
│       ├── error_widget.dart        # Error display
│       └── custom_button.dart       # Reusable button
│
├── models/                           # Data models
│   ├── user.dart                    # User model
│   ├── booking.dart                 # Booking model
│   ├── court.dart                   # Court model
│   ├── event.dart                   # Event model
│   ├── complaint.dart               # Complaint model
│   └── api_response.dart            # Generic API response
│
├── services/                         # Business services
│   ├── auth_service.dart            # Authentication logic
│   ├── booking_service.dart         # Booking operations
│   ├── court_service.dart           # Court operations
│   ├── event_service.dart           # Event operations
│   ├── user_service.dart            # User operations
│   ├── complaint_service.dart       # Complaint operations
│   └── payment_service.dart         # Payment operations
│
├── providers/                        # State management
│   ├── auth_provider.dart           # Authentication state
│   ├── user_provider.dart           # User state
│   ├── booking_provider.dart        # Booking state
│   ├── court_provider.dart          # Court state
│   ├── event_provider.dart          # Event state
│   └── complaint_provider.dart      # Complaint state
│
├── screens/                          # All screens/pages
│   ├── auth/                        # Authentication screens
│   │   ├── login_screen.dart
│   │   ├── signup_screen.dart
│   │   └── forgot_password_screen.dart
│   │
│   ├── dashboard/                   # Dashboard screens
│   │   ├── dashboard_screen.dart
│   │   └── role_dashboard_screen.dart
│   │
│   ├── navigation/                  # Navigation screens
│   │   ├── main_navigation_screen.dart
│   │   └── sidebar_screen.dart
│   │
│   ├── bookings/                    # Booking screens
│   │   ├── bookings_list_screen.dart
│   │   ├── booking_details_screen.dart
│   │   ├── create_booking_screen.dart
│   │   └── booking_calendar_screen.dart
│   │
│   ├── courts/                      # Court screens
│   │   ├── courts_list_screen.dart
│   │   ├── court_details_screen.dart
│   │   ├── create_court_screen.dart
│   │   └── court_schedule_screen.dart
│   │
│   ├── events/                      # Event screens
│   │   ├── events_list_screen.dart
│   │   ├── event_details_screen.dart
│   │   ├── create_event_screen.dart
│   │   └── tournament_screen.dart
│   │
│   ├── users/                       # User management screens
│   │   ├── users_list_screen.dart
│   │   ├── user_details_screen.dart
│   │   ├── create_user_screen.dart
│   │   └── user_profile_screen.dart
│   │
│   ├── billing/                     # Billing screens (Corporate)
│   │   ├── invoices_list_screen.dart
│   │   ├── invoice_details_screen.dart
│   │   ├── create_invoice_screen.dart
│   │   └── billing_reports_screen.dart
│   │
│   ├── orders/                      # Order screens
│   │   ├── orders_list_screen.dart
│   │   ├── order_details_screen.dart
│   │   ├── create_order_screen.dart
│   │   └── quotations_screen.dart
│   │
│   ├── sponsorships/                # Sponsorship screens
│   │   ├── sponsorships_list_screen.dart
│   │   ├── sponsorship_details_screen.dart
│   │   ├── create_sponsorship_screen.dart
│   │   └── my_sponsorships_screen.dart
│   │
│   ├── complaints/                  # Complaint screens
│   │   ├── complaints_list_screen.dart
│   │   ├── complaint_details_screen.dart
│   │   └── create_complaint_screen.dart
│   │
│   ├── referrals/                   # Referral screens
│   │   ├── referrals_list_screen.dart
│   │   └── create_referral_screen.dart
│   │
│   └── settings/                    # Settings screens
│       ├── settings_screen.dart
│       ├── profile_settings_screen.dart
│       ├── notification_settings_screen.dart
│       └── privacy_settings_screen.dart
│
├── widgets/                          # Reusable widgets
│   ├── forms/                       # Form widgets
│   │   ├── custom_text_field.dart
│   │   ├── custom_dropdown.dart
│   │   ├── custom_date_picker.dart
│   │   └── custom_button.dart
│   ├── cards/                       # Card widgets
│   │   ├── info_card.dart
│   │   ├── booking_card.dart
│   │   ├── event_card.dart
│   │   └── user_card.dart
│   ├── lists/                       # List widgets
│   │   ├── booking_list_item.dart
│   │   ├── event_list_item.dart
│   │   └── user_list_item.dart
│   └── layout/                      # Layout widgets
│       ├── app_scaffold.dart
│       ├── page_wrapper.dart
│       └── responsive_layout.dart
│
├── theme/                           # App theming
│   ├── app_theme.dart              # Main theme
│   ├── app_colors.dart             # Colors
│   ├── app_text_styles.dart        # Text styles
│   └── app_dimensions.dart         # Spacing & sizing
│
├── routes/                          # Navigation routes
│   ├── app_router.dart             # Main router
│   ├── route_names.dart            # Route constants
│   └── route_guards.dart           # Route protection
│
└── assets/                          # App assets
    ├── images/                      # Images
    │   ├── logos/                   # App logos
    │   ├── icons/                   # Custom icons
    │   └── illustrations/           # Illustrations
    ├── fonts/                       # Custom fonts
    └── animations/                  # Lottie animations
```

## 📋 Key Features of Simplified Structure

### 1. **Simple & Clear Organization**
- Easy to navigate and understand
- No complex nested layers
- Feature-based screen organization

### 2. **Practical Approach**
- Services handle business logic
- Providers manage state
- Models are simple data classes
- Screens are straightforward UI

### 3. **Easy to Scale**
- Add new screens in appropriate folders
- Create new services as needed
- Add new models for new features
- Simple provider pattern for state

### 4. **Team-Friendly**
- Easy for new developers to understand
- Clear separation of concerns
- Minimal learning curve
- Quick to implement features

### 5. **Maintainable**
- Simple file structure
- Easy to find and modify code
- Clear naming conventions
- Minimal complexity

## 🎯 Benefits of This Structure

### For Development
- **Fast Development**: Simple structure means faster feature development
- **Easy Debugging**: Clear organization makes debugging easier
- **Quick Onboarding**: New team members can understand quickly
- **Flexible**: Easy to modify and extend

### For Maintenance
- **Simple Updates**: Easy to update and maintain code
- **Clear Dependencies**: Obvious relationships between files
- **Easy Testing**: Simple structure makes testing straightforward
- **Reduced Complexity**: Less cognitive load for developers

### For Team Collaboration
- **Clear Responsibilities**: Each folder has a clear purpose
- **Easy Code Reviews**: Simple structure makes reviews easier
- **Consistent Patterns**: Easy to follow established patterns
- **Quick Feature Addition**: New features can be added quickly
