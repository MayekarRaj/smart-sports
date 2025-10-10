# Club Referral Management - Mobile-First Design

## Overview
A mobile-first Flutter UI for club referral management, inspired by modern web design patterns but optimized for mobile devices. Features comprehensive filtering, search functionality, and an invite referral system.

## Features

### 🎨 Mobile-First Design
- **Card-based Layout**: Tables replaced with stacked ReferralCard widgets for better mobile UX
- **Collapsible Filters**: Accordion-style filter section to save screen space
- **Responsive Search**: Global search with real-time filtering
- **Invite Referral Button**: Prominent button in the app bar for easy access

### 🔍 Advanced Filtering
- **Status Filter**: Filter by Subscribed, Un-Subscribed, Pending
- **Date Range Filter**: Filter by Today, This Week, This Month, Last 3 Months
- **Time Range Filter**: Filter by Morning, Afternoon, Evening
- **Day Filter**: Filter by specific days of the week
- **Real-time Search**: Search across referral names, emails, and referred by

### ✨ Invite Referral System
- **Multiple Invitation Methods**: Email, SMS, and Direct Link sharing
- **Personal Messages**: Add custom messages to invitations
- **Referral Link Generation**: Automatic generation and copying of referral links
- **Form Validation**: Comprehensive validation for all input fields

### 📱 Mobile Optimizations
- **Touch-friendly**: Large tap targets and intuitive gestures
- **Compact Layout**: Efficient use of screen space
- **Pagination**: Mobile-friendly pagination controls
- **Status Indicators**: Color-coded status badges
- **Smooth Animations**: Animated filter expansion and transitions

## File Structure

```
lib/role_specific/club/screens/referrals/
├── club_referrals_page.dart      # Main mobile-first referrals page
├── referral_card.dart            # Individual referral card widget
├── referral_data_service.dart    # Mock data service
├── referral.dart                 # Referral data model
├── invite_referral_dialog.dart   # Invite referral dialog
└── README.md                    # This documentation
```

## Usage

### Navigation
```dart
// Navigate to club referrals page
Navigator.pushNamed(context, '/club-referrals');
```

### ReferralCard Widget
The ReferralCard displays:
- Referral name and status
- Email address
- Referred by information
- Referral and subscription dates
- Clickable referral link

### Invite Referral Dialog
The dialog supports three invitation methods:
1. **Email**: Send invitation via email with personal message
2. **SMS**: Send invitation via SMS with personal message
3. **Link**: Generate and copy referral link directly

## Data Model

### Referral
```dart
class Referral {
  final String referralName;
  final String referralEmail;
  final String referredBy;
  final String referredDate;
  final String status;
  final String subscribedDate;
  final String referralLink;
}
```

## Status Types
- **Subscribed**: Green badge - User has subscribed
- **Un-Subscribed**: Red badge - User has unsubscribed
- **Pending**: Yellow badge - User invitation is pending

## Color Scheme
- **Primary Blue**: #1E40AF (Buttons, active states)
- **Dark Blue**: #1E3A8A (Filter section)
- **Success Green**: #10B981 (Success messages)
- **Error Red**: #991B1B (Error states)
- **Warning Yellow**: #92400E (Pending states)
- **Gray**: #6B7280 (Text, icons)

## Responsive Design
- **Mobile First**: Optimized for mobile devices
- **Card Layout**: Replaces traditional table layout
- **Collapsible Filters**: Saves screen space
- **Touch Targets**: Minimum 44px touch targets
- **Readable Text**: Minimum 14px font size

## Future Enhancements
- Real-time data synchronization
- Push notifications for new referrals
- Analytics dashboard for referral performance
- Bulk invitation features
- Integration with email/SMS services
- Advanced reporting and insights
