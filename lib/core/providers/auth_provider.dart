import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/api_models.dart';
import '../services/auth_service.dart';
import '../repositories/auth_repository.dart';

// ==================== Service Providers ====================

/// AuthService provider - Singleton service instance
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

/// AuthRepository provider - Singleton repository instance
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

// ==================== Auth State Provider ====================

/// Auth state notifier - Manages authentication state
final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthNotifier(authService);
});

/// Auth state notifier class
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(AuthState.initial()) {
    _checkAuthStatus();
  }

  /// Check if user is already authenticated on app start
  Future<void> _checkAuthStatus() async {
    try {
      final isAuth = await _authService.isAuthenticated();
      if (isAuth) {
        final userId = await _authService.getStoredUserId();
        if (userId != null) {
          try {
            final user = await _authService.getProfile(userId);
            state = AuthState.authenticated(user);
          } catch (e) {
            // If profile fetch fails, user might not be valid anymore
            state = AuthState.unauthenticated();
          }
        } else {
          state = AuthState.unauthenticated();
        }
      } else {
        state = AuthState.unauthenticated();
      }
    } catch (e) {
      state = AuthState.error('Failed to check authentication status');
    }
  }

  /// Sign in user
  Future<void> signIn({
    required String email,
    required String password,
    bool keepMeLoggedIn = false,
  }) async {
    state = AuthState.loading();
    try {
      final response = await _authService.signIn(
        email: email,
        password: password,
        keepMeLoggedIn: keepMeLoggedIn,
      );
      // Convert SignInUser to UserProfile for consistency
      state = AuthState.authenticated(response.user.toUserProfile());
    } catch (e) {
      state = AuthState.error(
        e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  /// Sign up user
  Future<void> signUp(SignUpRequest request) async {
    state = AuthState.loading();
    try {
      final response = await _authService.signUp(request);
      // Convert SignUpUser to UserProfile for consistency
      final userProfile = UserProfile(
        id: response.user.id,
        name: response.user.fullName,
        email: response.user.email,
        role: null, // Can be set from API if needed
        phone: null,
        avatar: null,
      );
      state = AuthState.authenticated(userProfile);
    } catch (e) {
      state = AuthState.error(
        e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  /// Sign out user
  Future<void> signOut() async {
    try {
      await _authService.logout();
      state = AuthState.unauthenticated();
    } catch (e) {
      state = AuthState.error('Failed to sign out: ${e.toString()}');
    }
  }

  /// Refresh user profile
  Future<void> refreshProfile() async {
    if (state.user == null) return;

    try {
      final user = await _authService.getProfile(state.user!.id);
      state = AuthState.authenticated(user);
    } catch (e) {
      // Don't update state on error, just log it
      state = AuthState.error('Failed to refresh profile');
    }
  }

  /// Clear error state
  void clearError() {
    if (state.isAuthenticated) {
      state = AuthState.authenticated(state.user!);
    } else {
      state = AuthState.unauthenticated();
    }
  }
}

/// Auth state class
class AuthState {
  final bool isLoading;
  final UserProfile? user;
  final String? error;

  AuthState({
    required this.isLoading,
    this.user,
    this.error,
  });

  factory AuthState.initial() => AuthState(isLoading: true);

  factory AuthState.loading() => AuthState(isLoading: true);

  factory AuthState.authenticated(UserProfile user) =>
      AuthState(isLoading: false, user: user);

  factory AuthState.unauthenticated() =>
      AuthState(isLoading: false);

  factory AuthState.error(String error) =>
      AuthState(isLoading: false, error: error);

  /// Check if user is authenticated
  bool get isAuthenticated => user != null && !isLoading;

  /// Check if there's an error
  bool get hasError => error != null && error!.isNotEmpty;

  /// Create a copy with updated values
  AuthState copyWith({
    bool? isLoading,
    UserProfile? user,
    String? error,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      error: error,
    );
  }
}

// ==================== Convenience Providers ====================

/// Current user provider - Returns authenticated user or null
final currentUserProvider = Provider<UserProfile?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.user;
});

/// Is authenticated provider - Returns true if user is authenticated
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.isAuthenticated;
});

/// User ID provider - Returns current user ID or null
final userIdProvider = Provider<int?>((ref) {
  final user = ref.watch(currentUserProvider);
  return user?.id;
});

