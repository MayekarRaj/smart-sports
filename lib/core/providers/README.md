# Riverpod State Management Guide

## 📚 Overview

This project uses **Riverpod** for state management. Riverpod provides:
- ✅ Compile-time safety
- ✅ No context dependency
- ✅ Excellent API state management
- ✅ Automatic memory management
- ✅ Easy testing

## 🏗️ Architecture

```
lib/core/providers/
├── auth_provider.dart      # Authentication state
└── booking_provider.dart   # Booking state
```

## 🔑 Key Providers

### Auth Provider
- `authStateProvider` - Main auth state (loading, authenticated, error)
- `currentUserProvider` - Current authenticated user
- `isAuthenticatedProvider` - Boolean check if user is authenticated
- `userIdProvider` - Current user ID

### Booking Provider
- `bookingsProvider` - List of bookings
- `bookingDetailsProvider` - Single booking details
- `bookingHistoryProvider` - Booking history

## 💡 Usage Examples

### 1. Using Auth State in Widgets

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_sports/core/providers/auth_provider.dart';

// ConsumerWidget - For widgets that need to watch state
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    
    if (authState.isLoading) {
      return CircularProgressIndicator();
    }
    
    if (authState.isAuthenticated) {
      return Text('Welcome ${authState.user!.name}');
    }
    
    return Text('Please sign in');
  }
}

// ConsumerStatefulWidget - For stateful widgets
class MyStatefulWidget extends ConsumerStatefulWidget {
  @override
  ConsumerState<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends ConsumerState<MyStatefulWidget> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    return Text(user?.name ?? 'Guest');
  }
}
```

### 2. Calling Auth Actions

```dart
// Sign in
await ref.read(authStateProvider.notifier).signIn(
  email: 'user@example.com',
  password: 'password',
);

// Sign up
final request = SignUpRequest(/* ... */);
await ref.read(authStateProvider.notifier).signUp(request);

// Sign out
await ref.read(authStateProvider.notifier).signOut();
```

### 3. Listening to State Changes

```dart
// Listen to auth state changes
ref.listen<AuthState>(authStateProvider, (previous, next) {
  if (next.isAuthenticated) {
    // Navigate to dashboard
    Navigator.pushReplacement(...);
  } else if (next.hasError) {
    // Show error
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(next.error!)),
    );
  }
});
```

### 4. Using in Services (No Context Needed)

```dart
// In any service or repository
class MyService {
  final Ref ref;
  
  MyService(this.ref);
  
  Future<void> doSomething() async {
    final user = ref.read(currentUserProvider);
    if (user != null) {
      // Use user data
    }
  }
}
```

### 5. Fetching Bookings

```dart
// In a widget
class BookingsList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingsAsync = ref.watch(bookingsProvider(null));
    
    return bookingsAsync.when(
      data: (bookings) => ListView.builder(
        itemCount: bookings.length,
        itemBuilder: (context, index) => BookingCard(bookings[index]),
      ),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}
```

## 🎯 Best Practices

1. **Use `ref.watch()` for reactive UI** - Widget rebuilds when state changes
2. **Use `ref.read()` for one-time reads** - Doesn't cause rebuilds
3. **Use `ref.listen()` for side effects** - Navigation, showing dialogs, etc.
4. **Keep providers simple** - One provider per feature/domain
5. **Use `FutureProvider` for async data** - Automatic loading/error states

## 🔄 Migration from setState

### Before (setState)
```dart
class MyWidget extends StatefulWidget {
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  bool _isLoading = false;
  
  void _loadData() {
    setState(() => _isLoading = true);
    // ... load data
    setState(() => _isLoading = false);
  }
}
```

### After (Riverpod)
```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(isLoadingProvider);
    // ... UI
  }
}
```

## 📖 Resources

- [Riverpod Documentation](https://riverpod.dev/)
- [Riverpod Examples](https://riverpod.dev/docs/introduction/getting_started)

