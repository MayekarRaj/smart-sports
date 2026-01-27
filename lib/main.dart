import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/services/payment_settings_service.dart';
import 'core/providers/auth_provider.dart';
import 'auth/screens/auth_shell.dart';
import 'auth/screens/splash_screen.dart';
import 'auth/screens/forgot_password_page.dart';
import 'auth/screens/reset_password_page.dart';
import 'auth/screens/change_password_page.dart';
import 'bookings/screens/booking_management_screen.dart';
import 'role_specific/club/screens/users/club_users_page.dart' as club;
import 'role_specific/club/screens/users/demo_users_screen.dart';
import 'role_specific/coach/screens/users/coach_users_page.dart' as coach;
import 'role_specific/merchandiser/screens/users/merchandiser_users_page.dart';
import 'role_specific/club/screens/referrals/club_referrals_page.dart';
import 'role_specific/club/screens/referrals/demo_referrals_screen.dart';
import 'role_specific/club/screens/dashboard/club_analytics_dashboard_page.dart';
import 'role_specific/club/screens/transactions/club_transactions_page.dart';
import 'role_specific/club/screens/courts/courts_page.dart';
import 'role_specific/club/screens/bookings/club_bookings_page.dart';
import 'role_specific/club/screens/events/club_events_page.dart';
import 'role_specific/club/screens/clubs/clubs_page.dart';

// Global navigator key to allow navigation from outside the widget tree or root widget
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Stripe is initialized dynamically in PaymentSettingsService

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch payment settings to trigger fetch on app start
    // ignore: unused_local_variable
    final paymentSettings = ref.watch(paymentSettingsServiceProvider);

    // Listen for auth state changes to handle global logout
    ref.listen(authStateProvider, (previous, next) {
      if (previous?.isAuthenticated == true && !next.isAuthenticated) {
        // User was logged out (e.g. session expired and refresh failed)
        // Navigate to AuthShell and clear stack
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          '/auth',
          (route) => false,
        );
      }
    });

    return MaterialApp(
      navigatorKey: navigatorKey, // Assign global key
      title: 'Universal Sport Connect (USC)',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const SplashScreen(),
      routes: {
        '/auth': (_) => const AuthShell(), // Added auth route
        '/forgot': (_) => const ForgotPasswordPage(),
        '/reset': (_) => const ResetPasswordPage(),
        '/change': (_) => const ChangePasswordPage(),
        '/bookings': (_) => const BookingManagementScreen(),
        '/club-users': (_) => const club.ClubUsersPage(),
        '/demo-users': (_) => const DemoUsersScreen(),
        '/corporate-users': (_) => const club.ClubUsersPage(),
        '/coach-users': (_) => const coach.CoachUsersPage(),
        '/merchandiser-users': (_) => const MerchandiserUsersPage(),
        '/club-referrals': (_) => const ClubReferralsPage(),
        '/demo-referrals': (_) => const DemoReferralsScreen(),
        '/club-dashboard': (_) => const ClubAnalyticsDashboardPage(),
        '/club-transactions': (_) => const ClubTransactionsPage(),
        '/club-courts': (_) => const ClubCourtsPage(),
        '/club-clubs': (_) => const ClubsPage(),
        '/club-bookings': (_) => const ClubBookingsPage(),
        '/club-events': (_) => const ClubEventsPage(),
        '/club-sponsorships': (_) =>
            const _PlaceholderPage(title: 'Sponsorships'),
      },
    );
  }
}

class _PlaceholderPage extends StatelessWidget {
  final String title;

  const _PlaceholderPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color(0xFF1E40AF),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.construction, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              '$title Screen',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Coming Soon',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}
