import 'package:flutter/material.dart';
import 'package:smart_sports/shared/widgets/role_sidebar.dart';
import 'package:smart_sports/role_specific/common/role_router.dart';
import 'package:smart_sports/shared/navigation/role_navigation_manager.dart';

class FreelancerSponsorshipsPage extends StatefulWidget {
  const FreelancerSponsorshipsPage({super.key});

  @override
  State<FreelancerSponsorshipsPage> createState() =>
      _FreelancerSponsorshipsPageState();
}

class _FreelancerSponsorshipsPageState
    extends State<FreelancerSponsorshipsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Sponsorships'),
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
            role: UserRole.freelancer,
            selectedIndex: 6,
            edgeToEdge: true,
            onSelectIndex: (i) => RoleNavigationManager.navigateToScreen(
              context,
              UserRole.freelancer,
              i,
            ),
            onProfileTap: () => RoleNavigationManager.navigateToProfile(
              context,
              UserRole.freelancer,
            ),
          ),
        ),
      ),
      body: const Center(
        child: Text('Freelancer Sponsorships Page'),
      ),
    );
  }
}

