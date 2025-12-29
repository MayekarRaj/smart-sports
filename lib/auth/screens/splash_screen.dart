import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/services/storage_service.dart';
import '../../role_specific/common/role_router.dart';
import 'auth_shell.dart';

/// Splash screen that checks authentication status and navigates accordingly
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Wait for auth state to be checked, then navigate
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuthAndNavigate();
    });
  }

  Future<void> _checkAuthAndNavigate() async {
    // Wait a bit for auth state to initialize
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (!mounted) return;

    final authState = ref.read(authStateProvider);
    
    // If still loading, wait a bit more
    if (authState.isLoading) {
      await Future.delayed(const Duration(milliseconds: 1000));
      if (!mounted) return;
      _checkAuthAndNavigate(); // Retry
      return;
    }

    // If authenticated, navigate to dashboard
    if (authState.isAuthenticated && authState.user != null) {
      await _navigateToDashboard(authState.user!.role);
      return;
    }

    // If not authenticated, navigate to AuthShell
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const AuthShell()),
      );
    }
  }

  Future<void> _navigateToDashboard(String? roleString) async {
    if (!mounted) return;

    // Get role from UserProfile or storage
    UserRole? userRole;
    
    if (roleString != null && roleString.isNotEmpty) {
      userRole = roleString.toUserRole();
    }
    
    // If role not in UserProfile, try storage
    if (userRole == null) {
      final storageService = StorageService();
      final storedRole = await storageService.getString('user_role');
      if (storedRole != null && storedRole.isNotEmpty) {
        userRole = storedRole.toUserRole();
      }
    }
    
    // Default to member if role still not found
    userRole ??= UserRole.member;

    // Navigate to role-specific dashboard
    final dashboard = RoleRouter.dashboardFor(userRole);
    
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => dashboard),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1E293B),
              Color(0xFF334155),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Logo
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.sports_cricket,
                  size: 60,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 32),
              // App Name
              const Text(
                'Smart Sports',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Your Ultimate Sports Management Platform',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 48),
              // Loading Indicator
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

