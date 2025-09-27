import 'package:flutter/material.dart';
import 'package:smart_sports/shared/widgets/role_sidebar.dart';
import 'package:smart_sports/role_specific/common/role_router.dart';
import 'package:smart_sports/role_specific/corporate/screens/courts/corporate_courts_page.dart';
import 'package:smart_sports/role_specific/corporate/screens/dashboard/corporate_analytics_dashboard_page.dart';
import 'package:smart_sports/role_specific/corporate/screens/users/corporate_users_page.dart';
import 'package:smart_sports/role_specific/corporate/screens/referrals/corporate_referrals_page.dart';

class CorporateProfilePage extends StatefulWidget {
  const CorporateProfilePage({super.key});

  @override
  State<CorporateProfilePage> createState() => _CorporateProfilePageState();
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
        MaterialPageRoute(
          builder: (_) =>
              const _CorporateProfilePlaceholder(title: 'Transactions'),
        ),
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
          builder: (_) => const _CorporateProfilePlaceholder(title: 'Clubs'),
        ),
      );
      break;
    case 4:
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const _CorporateProfilePlaceholder(title: 'Bookings'),
        ),
      );
      break;
    case 5:
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) =>
              const _CorporateProfilePlaceholder(title: 'Events / Tournaments'),
        ),
      );
      break;
    case 6:
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) =>
              const _CorporateProfilePlaceholder(title: 'Sponsorships'),
        ),
      );
      break;
    case 7:
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const CorporateUsersPage()),
      );
      break;
    case 8:
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const CorporateReferralsPage()),
      );
      break;
    default:
      break;
  }
}

class _CorporateProfilePlaceholder extends StatelessWidget {
  final String title;
  const _CorporateProfilePlaceholder({required this.title});

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
            selectedIndex: 0,
            edgeToEdge: true,
            onSelectIndex: (i) async {
              Navigator.of(context).pop();
              await Future.delayed(const Duration(milliseconds: 160));
              _navigateFromCorporateSidebar(context, i);
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
      body: Center(child: Text('$title screen coming soon')),
    );
  }
}

class _CorporateProfilePageState extends State<CorporateProfilePage>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bool isWide = width >= 900;
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        centerTitle: false,
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
            selectedIndex: 0,
            edgeToEdge: true,
            onSelectIndex: (i) async {
              Navigator.of(context).pop();
              await Future.delayed(const Duration(milliseconds: 160));
              _navigateFromCorporateSidebar(context, i);
            },
            onProfileTap: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: _PillTabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Profile'),
                  Tab(text: 'Branches'),
                  Tab(text: 'Bank Details & Financials'),
                  Tab(text: 'Subscriptions'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _ProfileTab(isWide: isWide),
                  _BranchesTab(isWide: isWide),
                  _BankDetailsTab(isWide: isWide),
                  _SubscriptionsTab(isWide: isWide),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PillTabBar extends StatelessWidget {
  final TabController controller;
  final List<Tab> tabs;
  const _PillTabBar({required this.controller, required this.tabs});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: controller,
        tabs: tabs,
        indicator: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        labelColor: Colors.black87,
        unselectedLabelColor: Colors.grey,
        labelStyle: const TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
      ),
    );
  }
}

class _ProfileTab extends StatelessWidget {
  final bool isWide;
  const _ProfileTab({required this.isWide});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Corporate Profile Information',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          if (isWide)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _ProfileForm()),
                const SizedBox(width: 24),
                Expanded(child: _ProfileImage()),
              ],
            )
          else
            Column(
              children: [
                _ProfileImage(),
                const SizedBox(height: 24),
                _ProfileForm(),
              ],
            ),
        ],
      ),
    );
  }
}

class _BranchesTab extends StatelessWidget {
  final bool isWide;
  const _BranchesTab({required this.isWide});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Corporate Branches',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          const Center(child: Text('Branch details coming soon')),
        ],
      ),
    );
  }
}

class _BankDetailsTab extends StatelessWidget {
  final bool isWide;
  const _BankDetailsTab({required this.isWide});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Bank Details & Financials',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          const Center(child: Text('Bank details coming soon')),
        ],
      ),
    );
  }
}

class _SubscriptionsTab extends StatelessWidget {
  final bool isWide;
  const _SubscriptionsTab({required this.isWide});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Subscriptions',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          const Center(child: Text('Subscription details coming soon')),
        ],
      ),
    );
  }
}

class _ProfileForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Company Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Company Name'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Phone Number'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Industry'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Number of Employees',
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Save Changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey,
              child: Icon(Icons.business, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: () {}, child: const Text('Change Logo')),
          ],
        ),
      ),
    );
  }
}
