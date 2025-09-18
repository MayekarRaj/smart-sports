# 🏆 Smart Sports - Flutter Application

> **Sakiichi - Mirai Team Project**  
> **Team Members:** Harsh (Lead), Megha (UI/UX), Manish (QA & Documentation)  
> **Timeline:** 1 Month  
> **Framework:** Flutter with Simple Architecture

## 📋 Project Overview

Smart Sports is a comprehensive sports management application that provides role-based access control for different user types in the sports ecosystem. The application supports 6 distinct user roles, each with customized features and permissions.

### 🎯 Key Features

- **Role-Based Access Control (RBAC)** - 6 different user roles
- **Multi-Platform Support** - iOS, Android, Web
- **Simple Architecture** - Easy to understand and maintain
- **Payment Integration** - Stripe and Razorpay support
- **Location Services** - Maps integration for clubs and courts
- **Local Storage** - Simple data persistence
- **Responsive Design** - Works on all screen sizes

## 👥 User Roles & Features

### 🏢 Corporate
- Employee and dependent management
- Billing and invoice management
- Sponsorship management
- User approval workflows

### 🏟️ Club
- Court management and scheduling
- Booking calendar (daily/monthly view)
- Equipment orders and delivery tracking
- Member management

### 🏃 Coach
- Personal booking management
- Nearby clubs with map integration
- Event participation and coaching
- Coach fee management

### 🛍️ Merchandiser
- Product fulfillment
- Order management
- Sponsorship opportunities
- Equipment delivery tracking

### 🔧 Freelancer
- Service request management
- Quotation and bidding system
- Equipment repair services
- Payment processing

### 👤 Member
- Court booking management
- Event subscriptions
- Equipment requests
- Personal activity tracking

## 🏗️ Simplified Architecture

### Simple & Practical Approach

```
┌─────────────────────────────────────┐
│           UI Layer                  │
│  (Screens, Widgets, State Management)│
├─────────────────────────────────────┤
│           Service Layer             │
│  (API Calls, Business Logic)        │
├─────────────────────────────────────┤
│           Model Layer               │
│  (Data Models, DTOs)                │
└─────────────────────────────────────┘
```

### Key Principles

- **Feature-Based Organization** - Each feature is self-contained
- **Simple State Management** - Easy to understand and maintain
- **Direct API Calls** - No complex abstractions
- **Clear File Structure** - Easy to navigate and find code

## 🛠️ Technology Stack

### Core Technologies
- **Flutter** - Cross-platform UI framework
- **Dart** - Programming language
- **Simple Architecture** - Easy to understand and maintain

### State Management
- **Provider** - Simple state management solution
- **OR Riverpod** - More advanced state management (optional)

### Networking
- **HTTP** - Simple HTTP client
- **Dio** - Advanced HTTP client (if needed)

### Local Storage
- **Shared Preferences** - Simple key-value storage
- **Hive** - Local database (if needed)

### Navigation
- **Go Router** - Simple routing solution

### UI/UX
- **Material Design 3** - Modern design system
- **Flutter ScreenUtil** - Responsive design
- **Cached Network Image** - Image caching

## 📁 Simple Project Structure

```
lib/
├── main.dart                          # App entry point
├── app.dart                          # Main app widget
│
├── core/                             # Core utilities
│   ├── constants/                    # App constants
│   ├── services/                     # Core services
│   ├── utils/                        # Utilities
│   └── widgets/                      # Core widgets
│
├── models/                           # Data models
│   ├── user.dart                    # User model
│   ├── booking.dart                 # Booking model
│   ├── court.dart                   # Court model
│   └── event.dart                   # Event model
│
├── services/                         # Business services
│   ├── auth_service.dart            # Authentication logic
│   ├── booking_service.dart         # Booking operations
│   ├── court_service.dart           # Court operations
│   └── event_service.dart           # Event operations
│
├── providers/                        # State management
│   ├── auth_provider.dart           # Authentication state
│   ├── user_provider.dart           # User state
│   └── booking_provider.dart        # Booking state
│
├── screens/                          # All screens/pages
│   ├── auth/                        # Authentication screens
│   ├── dashboard/                   # Dashboard screens
│   ├── bookings/                    # Booking screens
│   ├── courts/                      # Court screens
│   ├── events/                      # Event screens
│   └── settings/                    # Settings screens
│
├── widgets/                          # Reusable widgets
│   ├── forms/                       # Form widgets
│   ├── cards/                       # Card widgets
│   └── layout/                      # Layout widgets
│
├── theme/                           # App theming
│   ├── app_theme.dart              # Main theme
│   ├── app_colors.dart             # Colors
│   └── app_text_styles.dart        # Text styles
│
└── assets/                          # App assets
    ├── images/                      # Images
    ├── fonts/                       # Custom fonts
    └── animations/                  # Lottie animations
```

## 🚀 Getting Started

### Prerequisites

- **Flutter SDK** (3.16.0 or higher)
- **Dart SDK** (3.2.0 or higher)
- **Android Studio** or **VS Code**
- **Git** for version control

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd smart_sports
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the application**
   ```bash
   flutter run
   ```

### Development Setup

1. **Run tests**
   ```bash
   flutter test
   ```

2. **Check code quality**
   ```bash
   flutter analyze
   ```

## 📱 Platform Support

### Android
- **Minimum SDK:** 21 (Android 5.0)
- **Target SDK:** 34 (Android 14)

### iOS
- **Minimum Version:** iOS 12.0
- **Target Version:** iOS 17.0

### Web
- **Browsers:** Chrome, Firefox, Safari, Edge

## 🔧 Development Guidelines

### Code Style
- Follow **Dart Style Guide**
- Use **Flutter Lints** for basic linting
- Write **clear and simple** code
- Use **meaningful variable names**

### Git Workflow
- **Feature branches** for new features
- **Pull requests** for code review
- **Simple commit messages**
- **Regular commits**

### Testing Strategy
- **Unit Tests** - Test business logic
- **Widget Tests** - Test UI components
- **Simple tests** - Focus on important functionality

## 📊 Performance Optimization

### Simple Optimizations
- **Image Caching** - Use `cached_network_image`
- **List Performance** - Use `ListView.builder`
- **Memory Management** - Dispose controllers properly
- **Network Optimization** - Cache API responses

## 🔒 Security Features

### Basic Security
- **Secure Storage** - Store sensitive data securely
- **API Key Protection** - Protect API keys
- **Input Validation** - Validate user inputs

### Authentication
- **JWT Tokens** - Simple token management
- **Session Management** - Basic session handling

## 🌐 Internationalization

### Supported Languages
- **English** (Default)
- **Spanish** (es)
- **Hindi** (hi)

### Adding New Languages
1. Create new `.arb` file in `lib/l10n/`
2. Add translations for all keys
3. Update `pubspec.yaml` configuration

## 🧪 Testing

### Test Structure
```
test/
├── unit/                           # Unit tests
├── widget/                        # Widget tests
└── integration/                   # Integration tests
```

### Running Tests
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/unit/auth_test.dart

# Run tests with coverage
flutter test --coverage
```

## 🚀 Deployment

### Android
1. **Generate signed APK**
   ```bash
   flutter build apk --release
   ```

2. **Generate App Bundle**
   ```bash
   flutter build appbundle --release
   ```

### iOS
1. **Build for iOS**
   ```bash
   flutter build ios --release
   ```

2. **Archive in Xcode**
   - Open `ios/Runner.xcworkspace`
   - Archive and upload to App Store

### Web
1. **Build for web**
   ```bash
   flutter build web --release
   ```

2. **Deploy to hosting**
   - Upload `build/web/` to web server

## 🤝 Contributing

### Development Process
1. **Create feature branch** from `main`
2. **Implement feature** following simple patterns
3. **Write tests** for new functionality
4. **Create pull request** for review
5. **Merge after approval**

### Code Review Checklist
- [ ] Code is simple and clear
- [ ] Tests are written and passing
- [ ] No unnecessary complexity
- [ ] Follows naming conventions

## 📞 Support & Contact

### Team Contacts
- **Harsh (Lead Developer)** - harsh@example.com
- **Megha (UI/UX Developer)** - megha@example.com
- **Manish (QA & Documentation)** - manish@example.com

### Project Management
- **Redmine** - Task tracking and project management
- **GitLab** - Version control and CI/CD
- **Figma** - Design and prototyping

## 📄 License

This project is proprietary software developed for Sakiichi - Mirai team. All rights reserved.

## 🎯 Roadmap

### Phase 1 (Month 1) - Core Features
- [x] Project setup and architecture
- [ ] Authentication system
- [ ] Role-based navigation
- [ ] Dashboard implementation
- [ ] Basic CRUD operations

### Phase 2 (Month 2) - Advanced Features
- [ ] Payment integration
- [ ] Real-time updates
- [ ] Advanced booking system
- [ ] Event management
- [ ] Notification system

### Phase 3 (Month 3) - Optimization
- [ ] Performance optimization
- [ ] Advanced analytics
- [ ] Multi-language support
- [ ] App store deployment

---

**Built with ❤️ by Sakiichi - Mirai Team**
