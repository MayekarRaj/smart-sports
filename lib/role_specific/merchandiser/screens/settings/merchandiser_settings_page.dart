import 'package:flutter/material.dart';
import 'package:smart_sports/shared/widgets/role_sidebar.dart';
import 'package:smart_sports/role_specific/common/role_router.dart';
import 'package:smart_sports/role_specific/merchandiser/screens/profile/merchandiser_profile_page.dart';
import 'package:smart_sports/role_specific/merchandiser/screens/dashboard/merchandiser_analytics_dashboard_page.dart';
import 'package:smart_sports/role_specific/merchandiser/screens/transactions/merchandiser_transactions_page.dart';
import 'package:smart_sports/role_specific/merchandiser/screens/courts/merchandiser_courts_page.dart';
import 'package:smart_sports/role_specific/merchandiser/screens/bookings/merchandiser_bookings_page.dart';
import 'package:smart_sports/role_specific/merchandiser/screens/events/merchandiser_events_page.dart';
import 'package:smart_sports/role_specific/merchandiser/screens/users/merchandiser_users_page.dart';
import 'package:smart_sports/role_specific/merchandiser/screens/referrals/merchandiser_referrals_page.dart';

class MerchandiserSettingsPage extends StatefulWidget {
  const MerchandiserSettingsPage({super.key});

  @override
  State<MerchandiserSettingsPage> createState() =>
      _MerchandiserSettingsPageState();
}

class _MerchandiserSettingsPageState extends State<MerchandiserSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      drawer: RoleSidebar(
        role: UserRole.merchandiser,
        onSelectIndex: (index) {
          final currentContext = context;
          final navigator = Navigator.of(currentContext);
          if (index == 0) {
            navigator.pushReplacement(
              MaterialPageRoute(
                builder: (_) => const MerchandiserAnalyticsDashboardPage(),
              ),
            );
          } else if (index == 1) {
            navigator.pushReplacement(
              MaterialPageRoute(
                builder: (_) => const MerchandiserTransactionsPage(),
              ),
            );
          } else if (index == 2) {
            navigator.pushReplacement(
              MaterialPageRoute(builder: (_) => const MerchandiserCourtsPage()),
            );
          } else if (index == 3) {
            // Clubs - placeholder
          } else if (index == 4) {
            navigator.pushReplacement(
              MaterialPageRoute(
                builder: (_) => const MerchandiserBookingsPage(),
              ),
            );
          } else if (index == 5) {
            navigator.pushReplacement(
              MaterialPageRoute(builder: (_) => const MerchandiserEventsPage()),
            );
          } else if (index == 6) {
            // Sponsorships - placeholder
          } else if (index == 7) {
            navigator.pushReplacement(
              MaterialPageRoute(builder: (_) => const MerchandiserUsersPage()),
            );
          } else if (index == 8) {
            navigator.pushReplacement(
              MaterialPageRoute(
                builder: (_) => const MerchandiserReferralsPage(),
              ),
            );
          } else if (index == 9) {
            // Customer Support - placeholder
          } else if (index == 10) {
            // Already on settings
          }
        },
        onProfileTap: () {
          final currentContext = context;
          final navigator = Navigator.of(currentContext);
          navigator.pushReplacement(
            MaterialPageRoute(builder: (_) => const MerchandiserProfilePage()),
          );
        },
      ),
      body: const Center(child: Text('Merchandiser Settings Page')),
    );
  }
}
