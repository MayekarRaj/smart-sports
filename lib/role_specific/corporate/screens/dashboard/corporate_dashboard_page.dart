import 'package:flutter/material.dart';
import 'package:smart_sports/shared/widgets/role_sidebar.dart';
import 'package:smart_sports/role_specific/common/role_router.dart';

class CorporateDashboardPage extends StatefulWidget {
  const CorporateDashboardPage({super.key});

  @override
  State<CorporateDashboardPage> createState() => _CorporateDashboardPageState();
}

class _CorporateDashboardPageState extends State<CorporateDashboardPage> {
  int selectedIndex = 0;
  bool _sidebarOpen = true;

  String get _title {
    switch (selectedIndex) {
      case 0:
        return 'Corporate Dashboard';
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
        return 'Corporate';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 1000;
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              if (!isWide) {
                Scaffold.of(ctx).openDrawer();
              } else {
                setState(() => _sidebarOpen = !_sidebarOpen);
              }
            },
          ),
        ),
      ),
      drawer: isWide
          ? null
          : Builder(
              builder: (ctx) {
                final width = MediaQuery.of(ctx).size.width;
                return Drawer(
                  elevation: 0,
                  width: width,
                  child: SafeArea(
                    child: RoleSidebar(
                      role: UserRole.corporate,
                      selectedIndex: selectedIndex,
                      onSelectIndex: (i) => setState(() => selectedIndex = i),
                      edgeToEdge: true,
                    ),
                  ),
                );
              },
            ),
      body: Row(
        children: [
          if (isWide)
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: _sidebarOpen
                  ? Padding(
                      key: const ValueKey('open'),
                      padding: const EdgeInsets.all(16.0),
                      child: RoleSidebar(
                        role: UserRole.corporate,
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
