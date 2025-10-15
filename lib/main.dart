import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'auth/screens/auth_shell.dart';
import 'auth/screens/forgot_password_page.dart';
import 'auth/screens/reset_password_page.dart';
import 'auth/screens/change_password_page.dart';
import 'bookings/screens/bookings_page.dart';
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

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Sports',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const AuthShell(),
      // Temporary: Add direct navigation for testing
      // home: const ClubReferralsPage(),
      // home: const coach.CoachUsersPage(), // Uncomment to test coach directly
      routes: {
        '/forgot': (_) => const ForgotPasswordPage(),
        '/reset': (_) => const ResetPasswordPage(),
        '/change': (_) => const ChangePasswordPage(),
        '/bookings': (_) => const BookingsPage(),
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
