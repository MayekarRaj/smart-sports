import 'package:flutter/material.dart';

/// Navigation service for handling app-wide navigation
/// Provides utility methods for common navigation patterns
class NavigationService {
  static final NavigationService _instance = NavigationService._internal();
  factory NavigationService() => _instance;
  NavigationService._internal();

  /// Global navigator key for accessing Navigator without BuildContext
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  /// Get current context
  BuildContext? get currentContext => navigatorKey.currentContext;

  /// Navigate to a route
  Future<T?>? navigateTo<T>(String routeName, {Object? arguments}) {
    return navigatorKey.currentState?.pushNamed<T>(
      routeName,
      arguments: arguments,
    );
  }

  /// Navigate and replace current route
  Future<T?>? navigateReplacement<T>(String routeName, {Object? arguments}) {
    final state = navigatorKey.currentState;
    if (state == null) return null;
    return state.pushReplacementNamed<T, T>(routeName, arguments: arguments);
  }

  /// Navigate and remove all previous routes
  Future<T?>? navigateAndRemoveUntil<T>(
    String routeName, {
    Object? arguments,
    bool Function(Route<dynamic>)? predicate,
  }) {
    return navigatorKey.currentState?.pushNamedAndRemoveUntil<T>(
      routeName,
      predicate ?? (route) => false,
      arguments: arguments,
    );
  }

  /// Go back
  void goBack<T>([T? result]) {
    navigatorKey.currentState?.pop(result);
  }

  /// Check if can go back
  bool canGoBack() {
    return navigatorKey.currentState?.canPop() ?? false;
  }
}
