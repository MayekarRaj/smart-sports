# Smart Sports Flutter Architecture

## 🏗️ Simplified Architecture Overview

### Core Approach
- **Feature-Based Organization**: Each feature is self-contained
- **Role-Based Access Control**: Dynamic UI based on user roles
- **Simple State Management**: Easy to understand and maintain
- **Modular Design**: Easy to add new features

### Simple Architecture

```
┌─────────────────────────────────────┐
│           UI Layer                  │
│  (Pages, Widgets, State Management) │
├─────────────────────────────────────┤
│           Service Layer             │
│  (API Calls, Local Storage)         │
├─────────────────────────────────────┤
│           Model Layer               │
│  (Data Models, DTOs)                │
└─────────────────────────────────────┘
```

### Key Components

1. **UI Layer**
   - Pages for each screen
   - Reusable widgets
   - State management with Provider/Riverpod
   - Role-based navigation

2. **Service Layer**
   - API service classes
   - Local storage helpers
   - Business logic
   - Error handling

3. **Model Layer**
   - Data models
   - JSON serialization
   - Simple data structures

### Role-Based System

The application supports 6 distinct user roles:
- **Corporate**: Employee management, billing, sponsorships
- **Club**: Court management, bookings, member activities
- **Coach**: Personal bookings, nearby clubs, events
- **Merchandiser**: Product fulfillment, sponsorships
- **Freelancer**: Service requests, quotations
- **Member**: Personal bookings, event participation

Each role has:
- Customized sidebar navigation
- Role-specific features and permissions
- Shared common features (Dashboard, Settings, Complaints, etc.)
