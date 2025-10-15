import 'package:flutter/material.dart';
import 'package:smart_sports/bookings/screens/bookings_page.dart';
import 'package:smart_sports/role_specific/common/role_router.dart';
import 'package:smart_sports/shared/widgets/role_sidebar.dart';
import 'package:smart_sports/shared/navigation/role_navigation_manager.dart';
import 'package:smart_sports/role_specific/corporate/screens/profile/corporate_profile_page.dart';

class CorporateBookingsPage extends StatelessWidget {
  const CorporateBookingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookings'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF232534), Color(0xFF414384)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
      ),
      drawer: Drawer(
        elevation: 0,
        child: SafeArea(
          child: RoleSidebar(
            role: UserRole.corporate,
            selectedIndex: 4,
            edgeToEdge: true,
            onSelectIndex: (i) => RoleNavigationManager.navigateToScreen(
              context,
              UserRole.corporate,
              i,
            ),
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
      body: const BookingsPage(),
    );
  }
}

// Navigation from sidebar now centralized via RoleNavigationManager
