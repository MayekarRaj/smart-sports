# Club Users Management - Mobile-First Design

## Overview
A mobile-first Flutter UI for club user management, inspired by modern web design patterns but optimized for mobile devices. Features pill-style tabs, collapsible filters, and card-based user display.

## Features

### 🎨 Mobile-First Design
- **Card-based Layout**: Tables replaced with stacked UserCard widgets for better mobile UX
- **Pill-style Tabs**: Modern tab design with smooth animations
- **Collapsible Filters**: Accordion-style filter section to save screen space
- **Responsive Search**: Global search with real-time filtering

### 🔍 Advanced Filtering
- **Department Filter**: Filter by Design, Management, Development, Marketing, Sales
- **Status Filter**: Filter by Active, Inactive, Pending, Suspended
- **Real-time Search**: Search across user names, companies, emails, and designations
- **Tab-based Filtering**: Separate Admin Users and Employees

### ✨ Smooth Animations
- **Tab Switching**: Animated transitions between Admin and Employee tabs
- **Filter Expansion**: Smooth accordion animation for filter section
- **Card Interactions**: Subtle hover and tap effects

### 📱 Mobile Optimizations
- **Touch-friendly**: Large tap targets and intuitive gestures
- **Compact Layout**: Efficient use of screen space
- **Pagination**: Mobile-friendly pagination controls
- **Status Indicators**: Color-coded status badges

## File Structure

```
lib/role_specific/club/screens/users/
├── club_users_page.dart      # Main mobile-first users page
├── user_card.dart           # Individual user card widget
├── user_data_service.dart   # Mock data service
├── demo_users_screen.dart   # Demo/landing screen
└── README.md               # This documentation
```

## Usage

### Navigation
```dart
// Navigate to club users page
Navigator.pushNamed(context, '/club-users');

// Or navigate to demo screen
Navigator.pushNamed(context, '/demo-users');
```

### UserCard Widget
```dart
UserCard(
  user: user,
  onTap: () {
    // Handle user tap
  },
)
```

## Design System

### Colors
- **Primary Blue**: `#1E40AF` - Main brand color
- **Dark Blue**: `#1E3A8A` - Filter section background
- **Gray**: `#6B7280` - Secondary text
- **Light Gray**: `#F3F4F6` - Tab background
- **White**: `#FFFFFF` - Card backgrounds

### Typography
- **Headings**: 20px, FontWeight.w600
- **Body**: 14px, FontWeight.w500
- **Labels**: 12px, FontWeight.w600
- **Small Text**: 13px, FontWeight.w500

### Spacing
- **Card Padding**: 16px
- **Section Spacing**: 8px, 12px, 16px
- **Border Radius**: 12px for cards, 25px for tabs

## Key Components

### ClubUsersPage
Main page with:
- App bar with search functionality
- Collapsible filter section
- Pill-style tab bar
- User cards list
- Pagination controls

### UserCard
Individual user display with:
- Avatar with role-based colors
- User information (name, company, department)
- Contact details (phone, email)
- Status indicator
- Tap interaction

### UserDataService
Mock data service providing:
- Sample user data matching Figma design
- Search functionality
- Role-based filtering
- Department and status filtering

## Animation Details

### Filter Animation
- **Duration**: 300ms
- **Curve**: Curves.easeInOut
- **Type**: SizeTransition with rotation

### Tab Animation
- **Duration**: 200ms (default)
- **Type**: AnimatedContainer with color transitions

## Mobile UX Considerations

1. **Touch Targets**: Minimum 44px touch targets
2. **Scroll Performance**: Optimized ListView with proper item builders
3. **Keyboard Handling**: Proper text input focus management
4. **Loading States**: Empty state with helpful messaging
5. **Error Handling**: Graceful fallbacks for missing data

## Future Enhancements

- [ ] Pull-to-refresh functionality
- [ ] Swipe gestures for user actions
- [ ] Advanced date range filtering
- [ ] Export functionality
- [ ] Bulk actions
- [ ] User profile deep linking
- [ ] Offline support
- [ ] Real-time updates

## Testing

The interface includes:
- Mock data for immediate testing
- Demo screen for easy navigation
- Error-free linting
- Responsive design testing

## Dependencies

- Flutter Material Design
- No external dependencies required
- Built-in Flutter animations
- Standard Material widgets
