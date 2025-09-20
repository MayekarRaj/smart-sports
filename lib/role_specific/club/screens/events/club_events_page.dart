import 'package:flutter/material.dart';
import 'package:smart_sports/events/screens/events_editor_page.dart';
import 'package:smart_sports/shared/widgets/role_sidebar.dart';
import 'package:smart_sports/role_specific/common/role_router.dart';
import 'package:smart_sports/role_specific/club/screens/dashboard/club_analytics_dashboard_page.dart';
import 'package:smart_sports/role_specific/club/screens/courts/courts_page.dart';
import 'package:smart_sports/role_specific/club/screens/profile/club_profile_page.dart';
import 'package:smart_sports/role_specific/club/screens/transactions/club_transactions_page.dart';
import 'package:smart_sports/role_specific/club/screens/bookings/club_bookings_page.dart';

class ClubEventsPage extends StatelessWidget {
  const ClubEventsPage({super.key});

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
            role: UserRole.club,
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
                MaterialPageRoute(builder: (_) => const ClubProfilePage()),
              );
            },
          ),
        ),
      ),
      body: const EventsEditorPage(),
    );
  }
}

void _navigateFromEventsSidebar(BuildContext context, int index) {
  switch (index) {
    case 0:
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const ClubAnalyticsDashboardPage()),
      );
      break;
    case 1:
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const ClubTransactionsPage()),
      );
      break;
    case 2:
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const ClubCourtsPage()),
      );
      break;
    case 4:
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const ClubBookingsPage()),
      );
      break;
    case 5:
      // Already on events
      break;
    default:
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const ClubAnalyticsDashboardPage()),
      );
  }
}
