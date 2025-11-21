import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../../auth/screens/auth_shell.dart';

/// Utility class for authentication-related operations
class AuthUtils {
  /// Handle user logout - clears auth state and navigates to AuthShell
  static Future<void> handleLogout(
    BuildContext context,
    WidgetRef ref,
  ) async {
    try {
      // Call signOut which clears token and auth state
      await ref.read(authStateProvider.notifier).signOut();
      
      // Navigate to AuthShell and clear navigation stack
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const AuthShell()),
          (route) => false,
        );
      }
    } catch (e) {
      // If logout fails, still navigate to AuthShell
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const AuthShell()),
          (route) => false,
        );
      }
    }
  }
}

