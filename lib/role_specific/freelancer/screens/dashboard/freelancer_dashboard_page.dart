import 'package:flutter/material.dart';
import 'package:smart_sports/shared/widgets/role_sidebar.dart';
import 'package:smart_sports/role_specific/common/role_router.dart';

class FreelancerDashboardPage extends StatefulWidget {
  const FreelancerDashboardPage({super.key});

  @override
  State<FreelancerDashboardPage> createState() => _FreelancerDashboardPageState();
}

class _FreelancerDashboardPageState extends State<FreelancerDashboardPage> {
  int selectedIndex = 0;
  bool _sidebarOpen = true;

  String get _title {
    switch (selectedIndex) {
      case 0:
        return 'Freelancer Dashboard';
      case 1:
        return 'Transactions';
      case 2:
        return 'Courts';
      case 3:
        return 'Clubs';
      case 4:
        return 'Bookings';
      case 5:
        return 'Events / Tournaments';
      case 6:
        return 'Sponsorships';
      case 7:
        return 'Users';
      case 8:
        return 'Referrals';
      default:
        return 'Freelancer';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => setState(() => _sidebarOpen = !_sidebarOpen),
        ),
      ),
      body: Row(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: _sidebarOpen
                ? Padding(
                    key: const ValueKey('open'),
                    padding: const EdgeInsets.all(16.0),
                    child: RoleSidebar(
                      role: UserRole.freelancer,
                      selectedIndex: selectedIndex,
                      onSelectIndex: (i) => setState(() => selectedIndex = i),
                    ),
                  )
                : const SizedBox.shrink(key: ValueKey('closed')),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Expanded(child: Center(child: Text('Content area'))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
