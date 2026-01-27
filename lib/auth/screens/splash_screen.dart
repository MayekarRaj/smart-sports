import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/services/storage_service.dart';
import '../../role_specific/common/role_router.dart';
import 'auth_shell.dart';
import '../../core/constants/registration_constants.dart';
import 'role_selection_page.dart';
import 'club_registration_page.dart';
import 'corporate_registration_page.dart';
import 'merchandise_registration_page.dart';
import 'coach_registration_page.dart';
import 'member_registration_page.dart';
import 'freelancer_registration_page.dart';

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

    // If authenticated, check registration step
    if (authState.isAuthenticated && authState.user != null) {
      final storageService = StorageService();
      final step = await storageService.getString(
        RegistrationConstants.KEY_REGISTRATION_STEP,
      );

      if (mounted) {
        // Check if user has no role (Profile setup incomplete)
        if (authState.user?.role == null) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const RoleSelectionPage()),
          );
          return;
        }

        if (step == RegistrationConstants.STEP_EMAIL_VERIFIED) {
          // Resume at Role Selection
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const RoleSelectionPage()),
          );
          return;
        } else if (step == RegistrationConstants.STEP_ROLE_SELECTED) {
          // Resume at specific registration form
          final role = await storageService.getString(
            RegistrationConstants.KEY_TEMP_ROLE,
          );
          _navigateToRegistrationForm(role);
          return;
        }
      }

      await _navigateToDashboard(authState.user!.role);
      return;
    }

    // If not authenticated, navigate to AuthShell
    if (mounted) {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const AuthShell()));
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
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => dashboard));
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
            colors: [Color(0xFF1E293B), Color(0xFF334155)],
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
                child: Padding(
                  padding: const EdgeInsets.all(
                    20.0,
                  ), // Added padding for better visual
                  child: Image.asset(
                    'assets/images/app_icon.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // App Name
              const Text(
                'Universal Sport Connect (USC)',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28, // Slightly reduced to fit 2 lines if needed
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Match, Play, Repeat',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.italic,
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

  void _navigateToRegistrationForm(String? role) {
    if (!mounted) return;

    Widget page;
    switch (role) {
      case 'club':
        page = const ClubRegistrationPage();
        break;
      case 'corporate':
        page = const CorporateRegistrationPage();
        break;
      case 'merchandise':
        page = const MerchandiseRegistrationPage();
        break;
      case 'coach':
        page = const CoachRegistrationPage();
        break;
      case 'member':
        page = const MemberRegistrationPage();
        break;
      case 'freelancer':
        page = const FreelancerRegistrationPage();
        break;
      default:
        page = const RoleSelectionPage();
    }

    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => page));
  }
}
