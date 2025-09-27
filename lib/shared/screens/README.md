# Shared Screens

This directory contains reusable screen components that can be used across all roles in the Smart Sports app.

## Available Screens

### 1. Coming Soon Page (`coming_soon_page.dart`)

A customizable "coming soon" page with multiple variants:

- **`ComingSoonPage`**: Generic coming soon page
- **`UnderMaintenancePage`**: Maintenance page with optional return time
- **`ErrorPage`**: Error page with retry functionality

#### Usage:
```dart
// Basic coming soon page
ComingSoonPage(
  title: 'New Feature',
  subtitle: 'This feature is under development',
  icon: Icons.construction,
)

// Under maintenance page
UnderMaintenancePage(
  message: 'We are performing scheduled maintenance',
  estimatedReturn: DateTime.now().add(Duration(hours: 2)),
)

// Error page
ErrorPage(
  title: 'Something went wrong',
  message: 'Please try again later',
  onRetry: () => Navigator.pop(),
)
```

### 2. Settings Page (`settings_page.dart`)

A flexible settings page with predefined common settings items:

#### Usage:
```dart
SettingsPage(
  title: 'Account Settings',
  sections: [
    SettingsSection(
      title: 'Account',
      items: [
        CommonSettingsItems.profile(
          onTap: () => Navigator.push(...),
          subtitle: 'Manage your profile',
        ),
        CommonSettingsItems.notifications(
          onTap: () => Navigator.push(...),
        ),
      ],
    ),
    SettingsSection(
      title: 'Support',
      items: [
        CommonSettingsItems.help(
          onTap: () => Navigator.push(...),
        ),
        CommonSettingsItems.signOut(
          onTap: () => _signOut(),
        ),
      ],
    ),
  ],
)
```

### 3. Loading Pages (`loading_page.dart`)

Multiple loading screen variants:

- **`LoadingPage`**: Simple circular progress indicator
- **`SkeletonLoadingPage`**: Skeleton loading animation
- **`ProgressLoadingPage`**: Progress bar with percentage

#### Usage:
```dart
// Simple loading
LoadingPage(
  message: 'Loading your data...',
)

// Skeleton loading
SkeletonLoadingPage(
  message: 'Loading content...',
)

// Progress loading
ProgressLoadingPage(
  message: 'Uploading files...',
  progress: 0.7, // 70% complete
)
```

### 4. Notification Page (`notification_page.dart`)

A comprehensive notification management screen:

#### Usage:
```dart
NotificationPage(
  notifications: [
    NotificationTypes.booking(
      id: '1',
      title: 'Booking Confirmed',
      message: 'Your court booking for tomorrow is confirmed',
      timestamp: DateTime.now(),
    ),
    NotificationTypes.payment(
      id: '2',
      title: 'Payment Received',
      message: 'Payment of \$50 has been received',
      timestamp: DateTime.now().subtract(Duration(hours: 2)),
    ),
  ],
  onMarkAllRead: () => _markAllAsRead(),
  onNotificationTap: (notification) => _handleNotification(notification),
  onNotificationDelete: (notification) => _deleteNotification(notification),
)
```

## Predefined Components

### CommonSettingsItems

Pre-built settings items for common functionality:

- `profile()` - Profile management
- `notifications()` - Notification settings
- `privacy()` - Privacy & security
- `help()` - Help & support
- `about()` - About page
- `signOut()` - Sign out button
- `theme()` - Theme selection
- `language()` - Language selection

### NotificationTypes

Pre-built notification types:

- `booking()` - Booking-related notifications
- `payment()` - Payment notifications
- `event()` - Event notifications
- `system()` - System notifications
- `warning()` - Warning notifications

## Importing

Use the index file to import all shared screens:

```dart
import 'package:smart_sports/shared/screens/index.dart';
```

Or import specific screens:

```dart
import 'package:smart_sports/shared/screens/coming_soon_page.dart';
import 'package:smart_sports/shared/screens/settings_page.dart';
```

## Customization

All screens support theming and can be customized with:

- Custom colors
- Custom icons
- Custom messages
- Custom callbacks
- Responsive design
- Dark/light mode support

## Best Practices

1. **Consistency**: Use the same shared screens across all roles for consistency
2. **Customization**: Customize colors and messages to match role-specific branding
3. **Accessibility**: All screens include proper accessibility features
4. **Responsive**: All screens work on different screen sizes
5. **Theming**: Screens automatically adapt to light/dark themes
