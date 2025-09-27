import 'package:flutter/material.dart';
import 'package:smart_sports/events/screens/mobile_create_event_page.dart';
import 'package:smart_sports/shared/widgets/role_sidebar.dart';
import 'package:smart_sports/role_specific/common/role_router.dart';
import 'package:smart_sports/role_specific/corporate/screens/dashboard/corporate_analytics_dashboard_page.dart';
import 'package:smart_sports/role_specific/corporate/screens/courts/corporate_courts_page.dart';
import 'package:smart_sports/role_specific/corporate/screens/profile/corporate_profile_page.dart';
import 'package:smart_sports/role_specific/corporate/screens/transactions/corporate_transactions_page.dart';
import 'package:smart_sports/role_specific/corporate/screens/bookings/corporate_bookings_page.dart';

class CorporateEventsPage extends StatelessWidget {
  const CorporateEventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events / Tournaments'),
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
      ),
      drawer: Drawer(
        elevation: 0,
        child: SafeArea(
          child: RoleSidebar(
            role: UserRole.corporate,
            selectedIndex: 5,
            edgeToEdge: true,
            onSelectIndex: (i) async {
              Navigator.of(context).pop();
              await Future.delayed(const Duration(milliseconds: 160));
              _navigateFromEventsSidebar(context, i);
            },
            onProfileTap: () async {
              Navigator.of(context).pop();
              await Future.delayed(const Duration(milliseconds: 160));
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const CorporateProfilePage()),
              );
            },
          ),
        ),
      ),
      body: const MobileCreateEventPage(),
    );
  }
}

void _navigateFromEventsSidebar(BuildContext context, int index) {
  switch (index) {
    case 0:
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const CorporateAnalyticsDashboardPage(),
        ),
      );
      break;
    case 1:
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const CorporateTransactionsPage()),
      );
      break;
    case 2:
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const CorporateCourtsPage()),
      );
      break;
    case 4:
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const CorporateBookingsPage()),
      );
      break;
    case 5:
      // Already on events
      break;
    default:
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const CorporateAnalyticsDashboardPage(),
        ),
      );
  }
}
