import 'package:flutter/material.dart';
import 'package:smart_sports/bookings/screens/bookings_page.dart';
import 'package:smart_sports/shared/widgets/role_sidebar.dart';
import 'package:smart_sports/role_specific/common/role_router.dart';

class MemberBookingsPage extends StatelessWidget {
  const MemberBookingsPage({super.key});

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
            role: UserRole.member,
            selectedIndex: 4,
            edgeToEdge: true,
            onSelectIndex: (i) => Navigator.of(context).pop(),
          ),
        ),
      ),
      body: const BookingsPage(),
    );
  }
}
