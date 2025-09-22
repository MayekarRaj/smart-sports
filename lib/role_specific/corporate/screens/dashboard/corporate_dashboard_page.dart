import 'package:flutter/material.dart';
import 'package:smart_sports/role_specific/common/role_router.dart';
import 'package:smart_sports/shared/widgets/role_sidebar.dart';
import 'package:smart_sports/role_specific/corporate/screens/profile/corporate_profile_page.dart';
import 'package:smart_sports/role_specific/corporate/screens/courts/corporate_courts_page.dart';
import 'package:smart_sports/role_specific/corporate/screens/dashboard/corporate_analytics_dashboard_page.dart';
import 'package:smart_sports/role_specific/corporate/screens/transactions/corporate_transactions_page.dart';
import 'package:smart_sports/role_specific/corporate/screens/bookings/corporate_bookings_page.dart';
import 'package:smart_sports/role_specific/corporate/screens/events/corporate_events_page.dart';
import 'package:smart_sports/auth/screens/auth_shell.dart';

class CorporateDashboardPage extends StatefulWidget {
  const CorporateDashboardPage({super.key});

  @override
  State<CorporateDashboardPage> createState() => _CorporateDashboardPageState();
}

class _CorporateDashboardPageState extends State<CorporateDashboardPage> {
  int selectedIndex = 0;
  bool _sidebarOpen = true;

  void _signOut() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const AuthShell()),
      (route) => false,
    );
  }

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
                      onSelectIndex: (i) {
                        // Close drawer first to avoid popping the newly pushed page
                        Navigator.of(ctx).pop();
                        setState(() => selectedIndex = i);
                        Future.delayed(
                          const Duration(milliseconds: 220),
                          () => _openSection(i),
                        );
                      },
                      // Avoid double-pop; we'll handle closing in onSelectIndex/onProfileTap
                      onClose: null,
                      onProfileTap: () {
                        Navigator.of(ctx).pop();
                        Future.delayed(
                          const Duration(milliseconds: 180),
                          () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const CorporateProfilePage(),
                            ),
                          ),
                        );
                      },
                      onSignOut: _signOut,
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
                        onSelectIndex: (i) {
                          setState(() => selectedIndex = i);
                          _openSection(i);
                        },
                        onClose: () => setState(() => _sidebarOpen = false),
                        onProfileTap: () {
                          setState(() => _sidebarOpen = false);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const CorporateProfilePage(),
                            ),
                          );
                        },
                        onSignOut: _signOut,
                      ),
                    )
                  : const SizedBox.shrink(key: ValueKey('closed')),
            ),
          // Main content area
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

class _PlaceholderPage extends StatelessWidget {
  final String title;
  final int currentIndex;
  const _PlaceholderPage({required this.title, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
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
            selectedIndex: currentIndex,
            onSelectIndex: (i) async {
              Navigator.of(context).pop();
              await Future.delayed(const Duration(milliseconds: 160));
              _navigateFromCorporateSidebar(context, i);
            },
            edgeToEdge: true,
            onProfileTap: () async {
              Navigator.of(context).pop();
              await Future.delayed(const Duration(milliseconds: 160));
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const CorporateProfilePage()),
              );
            },
            onSignOut: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const AuthShell()),
                (route) => false,
              );
            },
          ),
        ),
      ),
      body: Center(child: Text('$title screen coming soon')),
    );
  }
}

void _navigateFromCorporateSidebar(BuildContext context, int index) {
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
    case 3:
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) =>
              const _PlaceholderPage(title: 'Clubs', currentIndex: 3),
        ),
      );
      break;
    case 4:
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const CorporateBookingsPage()),
      );
      break;
    case 5:
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const CorporateEventsPage()),
      );
      break;
    case 6:
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) =>
              const _PlaceholderPage(title: 'Sponsorships', currentIndex: 6),
        ),
      );
      break;
    case 7:
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) =>
              const _PlaceholderPage(title: 'Users', currentIndex: 7),
        ),
      );
      break;
    case 8:
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) =>
              const _PlaceholderPage(title: 'Referrals', currentIndex: 8),
        ),
      );
      break;
    default:
      break;
  }
}

extension on _CorporateDashboardPageState {
  void _openSection(int index) {
    switch (index) {
      case 0:
        // Open the analytics dashboard screen for Dashboard
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
      case 3:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) =>
                const _PlaceholderPage(title: 'Clubs', currentIndex: 3),
          ),
        );
        break;
      case 4:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const CorporateBookingsPage()),
        );
        break;
      case 5:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const CorporateEventsPage()),
        );
        break;
      case 6:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) =>
                const _PlaceholderPage(title: 'Sponsorships', currentIndex: 6),
          ),
        );
        break;
      case 7:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) =>
                const _PlaceholderPage(title: 'Users', currentIndex: 7),
          ),
        );
        break;
      case 8:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) =>
                const _PlaceholderPage(title: 'Referrals', currentIndex: 8),
          ),
        );
        break;
      default:
        break;
    }
  }
}
