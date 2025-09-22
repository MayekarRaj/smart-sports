import 'package:flutter/material.dart';
import 'package:smart_sports/bookings/screens/bookings_page.dart';
import 'package:smart_sports/role_specific/common/role_router.dart';
import 'package:smart_sports/shared/widgets/role_sidebar.dart';
import 'package:smart_sports/role_specific/merchandiser/screens/dashboard/merchandiser_dashboard_page.dart';
import 'package:smart_sports/role_specific/merchandiser/screens/courts/merchandiser_courts_page.dart';
import 'package:smart_sports/role_specific/merchandiser/screens/profile/merchandiser_profile_page.dart';
import 'package:smart_sports/role_specific/merchandiser/screens/transactions/merchandiser_transactions_page.dart';

class MerchandiserBookingsPage extends StatelessWidget {
  const MerchandiserBookingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookings'),
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
            role: UserRole.merchandiser,
            selectedIndex: 4,
            edgeToEdge: true,
            onSelectIndex: (i) async {
              Navigator.of(context).pop();
              await Future.delayed(const Duration(milliseconds: 160));
              _navigateFromMerchandiserSidebar(context, i);
            },
            onProfileTap: () async {
              Navigator.of(context).pop();
              await Future.delayed(const Duration(milliseconds: 160));
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const MerchandiserProfilePage()),
              );
            },
          ),
        ),
      ),
      body: const BookingsPage(),
    );
  }
}

void _navigateFromMerchandiserSidebar(BuildContext context, int index) {
  switch (index) {
    case 0:
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MerchandiserDashboardPage()),
      );
      break;
    case 1:
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MerchandiserTransactionsPage()),
      );
      break;
    case 2:
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MerchandiserCourtsPage()),
      );
      break;
    case 3:
      Navigator.of(context).pop();
      break;
    case 4:
      // Already on bookings
      break;
    default:
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MerchandiserDashboardPage()),
      );
  }
}
