# Booking Management Screen

A comprehensive mobile-first booking management interface built with Flutter, featuring collapsible filters, interactive booking cards, and smooth animations.

## Features

### 🎯 Core Functionality
- **Collapsible Filter Bar**: Event name, date range, time picker, days, and status filters
- **Interactive Booking Cards**: Tap to expand/collapse detailed information
- **Status Management**: Waiting, Wait List Confirmed, Confirmed, and Cancelled states
- **Equipment Actions**: Purchase and Repair buttons with bottom sheet modals
- **Cancel Booking**: Confirmation dialog with refund policy

### 🎨 UI Components
- **BookingCard**: Comprehensive card with venue info, coach details, players, schedule
- **FilterBar**: Collapsible filter section with date/time pickers
- **CoachTile**: Coach information display with avatar
- **PlayerAvatarRow**: Horizontal row of player avatars with overflow indicator

### 🎭 Animations & Interactions
- **Card Animations**: Scale animation on tap with smooth transitions
- **Fade Animations**: Staggered card loading with fade-in effects
- **Expandable Content**: Smooth height animations for detailed information
- **Pull-to-Refresh**: Refresh booking list with pull gesture

### 🎨 Design System
- **Color Palette**:
  - Primary Blue: `#007BFF`
  - Waiting: `#FF9800` (Orange)
  - Wait List Confirmed: `#FFD600` (Yellow)
  - Confirmed: `#4CAF50` (Green)
- **Typography**: Google Fonts Poppins
- **Modern UI**: Rounded corners, shadows, and clean spacing

## File Structure

```
lib/bookings/
├── models/
│   └── booking_model.dart          # Data models and mock data
├── screens/
│   └── booking_management_screen.dart  # Main screen
├── widgets/
│   ├── booking_card.dart           # Individual booking card
│   ├── filter_bar.dart            # Collapsible filter section
│   ├── coach_tile.dart            # Coach information widget
│   └── player_avatar_row.dart     # Player avatars widget
└── README.md                      # This file
```

## Usage

### Basic Implementation
```dart
import 'package:smart_sports/bookings/screens/booking_management_screen.dart';

// Navigate to booking management
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const BookingManagementScreen(),
  ),
);
```

### Route Integration
The screen is already integrated into the main app routing:
```dart
// In main.dart
routes: {
  '/bookings': (_) => const BookingManagementScreen(),
}
```

## Mock Data

The screen includes comprehensive mock data with:
- 3 sample bookings in different states
- Coach information with avatars
- Player lists with profile images
- Booking schedules and equipment actions

## State Management

Currently uses simple `setState` for state management. The architecture supports easy migration to:
- Provider
- Riverpod
- Bloc
- GetX

## Customization

### Adding New Status Types
1. Update `BookingStatus` enum in `booking_model.dart`
2. Add color mapping in `_buildStatusBadges()` method
3. Update filter logic in `_filterBookings()` method

### Adding New Filter Options
1. Extend `FilterBar` widget with new input fields
2. Update callback methods in `BookingManagementScreen`
3. Implement filter logic in `_filterBookings()` method

### Customizing Animations
- Modify `AnimationController` duration in `BookingCard`
- Adjust `AnimatedContainer` duration for expandable content
- Customize fade-in timing in `BookingManagementScreen`

## Dependencies

- `google_fonts: ^6.2.1` - Typography
- `flutter/material.dart` - Core UI components
- `cached_network_image: ^3.4.1` - Image caching (for avatars)

## Testing

To test the booking management screen:
1. Set `home: const BookingManagementScreen()` in `main.dart`
2. Run `flutter run`
3. Test filter functionality, card interactions, and animations

## Future Enhancements

- [ ] API integration for real booking data
- [ ] Advanced filtering with multiple criteria
- [ ] Search functionality
- [ ] Booking creation/editing
- [ ] Push notifications for booking updates
- [ ] Offline support with local storage
