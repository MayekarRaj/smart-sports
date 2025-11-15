import 'package:flutter/material.dart';
import 'package:smart_sports/shared/widgets/role_sidebar.dart';
import 'package:smart_sports/role_specific/common/role_router.dart';
import 'package:smart_sports/shared/navigation/role_navigation_manager.dart';

class FreelancerUsersPage extends StatefulWidget {
  const FreelancerUsersPage({super.key});

  @override
  State<FreelancerUsersPage> createState() => _FreelancerUsersPageState();
}

class _FreelancerUsersPageState extends State<FreelancerUsersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Users'),
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
            selectedIndex: 8,
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
        child: Text('Freelancer Users Page'),
      ),
    );
  }
}

