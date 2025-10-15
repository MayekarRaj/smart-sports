import 'package:flutter/material.dart';
import 'package:smart_sports/shared/widgets/role_sidebar.dart';
import 'package:smart_sports/role_specific/common/role_router.dart';
import 'package:smart_sports/role_specific/coach/screens/courts/courts_page.dart';
import 'package:smart_sports/role_specific/coach/screens/dashboard/coach_analytics_dashboard_page.dart';
import 'package:smart_sports/role_specific/coach/screens/users/coach_users_page.dart';

class CorporateProfilePage extends StatefulWidget {
  const CorporateProfilePage({super.key});

  @override
  State<CorporateProfilePage> createState() => _CorporateProfilePageState();
}

void _navigateFromCoachSidebar(BuildContext context, int index) {
  switch (index) {
    case 0:
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const CoachAnalyticsDashboardPage()),
      );
      break;
    case 1:
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const _ClubProfilePlaceholder(title: 'Transactions'),
        ),
      );
      break;
    case 2:
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const ClubCourtsPage()),
      );
      break;
    case 3:
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const _ClubProfilePlaceholder(title: 'Clubs'),
        ),
      );
      break;
    case 4:
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const _ClubProfilePlaceholder(title: 'Bookings'),
        ),
      );
      break;
    case 5:
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) =>
              const _ClubProfilePlaceholder(title: 'Events / Tournaments'),
        ),
      );
      break;
    case 6:
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const _ClubProfilePlaceholder(title: 'Sponsorships'),
        ),
      );
      break;
    case 7:
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const CoachUsersPage()),
      );
      break;
    case 8:
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const _ClubProfilePlaceholder(title: 'Referrals'),
        ),
      );
      break;
    default:
      break;
  }
}

class _ClubProfilePlaceholder extends StatelessWidget {
  final String title;
  const _ClubProfilePlaceholder({required this.title});
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
    final screenSize = MediaQuery.of(context).size;
    final isMobile = screenSize.width < 768;
    final isTablet = screenSize.width >= 768 && screenSize.width < 1024;
    final isDesktop = screenSize.width >= 1024;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        centerTitle: isMobile,
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
              _navigateFromCoachSidebar(context, i);
            },
            onProfileTap: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Mobile-optimized tab bar
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: isMobile ? 12 : 16,
                vertical: isMobile ? 8 : 12,
              ),
              child: _PillTabBar(
                controller: _tabController,
                isMobile: isMobile,
                tabs: [
                  Tab(text: isMobile ? 'Profile' : 'Profile'),
                  Tab(text: isMobile ? 'Branches' : 'Branches'),
                  Tab(
                    text: isMobile
                        ? 'Bank Details'
                        : 'Bank Details & Financials',
                  ),
                  Tab(text: isMobile ? 'Subscriptions' : 'Subscriptions'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _ProfileTab(
                    isMobile: isMobile,
                    isTablet: isTablet,
                    isDesktop: isDesktop,
                  ),
                  _BranchesTab(
                    isMobile: isMobile,
                    isTablet: isTablet,
                    isDesktop: isDesktop,
                  ),
                  _BankDetailsTab(
                    isMobile: isMobile,
                    isTablet: isTablet,
                    isDesktop: isDesktop,
                  ),
                  _SubscriptionsTab(
                    isMobile: isMobile,
                    isTablet: isTablet,
                    isDesktop: isDesktop,
                  ),
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
  final List<Widget> tabs;
  final bool isMobile;
  const _PillTabBar({
    required this.controller,
    required this.tabs,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 3,
      shadowColor: Colors.black12,
      borderRadius: BorderRadius.circular(isMobile ? 20 : 28),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(isMobile ? 20 : 28),
        child: Container(
          padding: EdgeInsets.all(isMobile ? 4 : 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(isMobile ? 20 : 28),
            border: Border.all(color: Colors.black12),
          ),
          child: TabBar(
            controller: controller,
            tabs: tabs,
            isScrollable: isMobile,
            indicator: ShapeDecoration(
              color: const Color(0xFF232534), // Coach gradient start
              shape: StadiumBorder(side: BorderSide.none),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.black87,
            labelStyle: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: isMobile ? 12 : 14,
            ),
            unselectedLabelStyle: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: isMobile ? 12 : 14,
            ),
            dividerColor: Colors.transparent,
            tabAlignment: isMobile ? TabAlignment.start : TabAlignment.center,
          ),
        ),
      ),
    );
  }
}

class _ProfileTab extends StatelessWidget {
  final bool isMobile;
  final bool isTablet;
  final bool isDesktop;
  const _ProfileTab({
    required this.isMobile,
    required this.isTablet,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 12 : 16),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(isMobile ? 12 : 18),
        ),
        child: Padding(
          padding: EdgeInsets.all(isMobile ? 12 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar and Name section
              if (isDesktop)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _LabeledField(
                        label: 'Name',
                        child: Row(
                          children: const [
                            Expanded(child: _TextBox(hint: 'First Name')),
                            SizedBox(width: 12),
                            Expanded(child: _TextBox(hint: 'Last Name')),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    _AvatarBox(size: 120),
                  ],
                )
              else ...[
                // Mobile/Tablet layout
                Center(child: _AvatarBox(size: isMobile ? 80 : 100)),
                SizedBox(height: isMobile ? 16 : 20),
                _LabeledField(
                  label: 'Name',
                  child: Column(
                    children: const [
                      _TextBox(hint: 'First Name'),
                      SizedBox(height: 12),
                      _TextBox(hint: 'Last Name'),
                    ],
                  ),
                ),
              ],

              SizedBox(height: isMobile ? 16 : 20),

              // Role and Email fields
              _LabeledField(
                label: 'Role',
                child: const _TextBox(hint: 'Club Owner', enabled: false),
              ),
              SizedBox(height: isMobile ? 12 : 16),

              _LabeledField(
                label: 'Login Email',
                child: const _TextBox(hint: 'Artist@Ymail.Com', enabled: false),
              ),
              SizedBox(height: isMobile ? 12 : 16),

              // Password field with responsive button
              _LabeledField(
                label: 'Password',
                child: isMobile
                    ? Column(
                        children: [
                          const _TextBox(hint: '************', obscure: true),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(
                                  0xFF232534,
                                ), // Coach gradient start
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                              child: const Text('Change Password'),
                            ),
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          const Expanded(
                            child: _TextBox(
                              hint: '************',
                              obscure: true,
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(
                                0xFF232534,
                              ), // Coach gradient start
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Change Password'),
                          ),
                        ],
                      ),
              ),
              SizedBox(height: isMobile ? 12 : 16),

              // Address section with responsive layout
              _LabeledField(
                label: 'Address*(Permanent)',
                child: isMobile
                    ? Column(
                        children: const [
                          _TextBox(hint: 'Pincode'),
                          SizedBox(height: 12),
                          _DropdownBox(hint: 'City'),
                          SizedBox(height: 12),
                          _DropdownBox(hint: 'State'),
                          SizedBox(height: 12),
                          _DropdownBox(hint: 'Country'),
                        ],
                      )
                    : isTablet
                    ? Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: const [
                          SizedBox(
                            width: 150,
                            child: _TextBox(hint: 'Pincode'),
                          ),
                          SizedBox(
                            width: 150,
                            child: _DropdownBox(hint: 'City'),
                          ),
                          SizedBox(
                            width: 150,
                            child: _DropdownBox(hint: 'State'),
                          ),
                          SizedBox(
                            width: 150,
                            child: _DropdownBox(hint: 'Country'),
                          ),
                        ],
                      )
                    : Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: const [
                          SizedBox(
                            width: 180,
                            child: _TextBox(hint: 'Pincode'),
                          ),
                          SizedBox(
                            width: 200,
                            child: _DropdownBox(hint: 'City'),
                          ),
                          SizedBox(
                            width: 220,
                            child: _DropdownBox(hint: 'State'),
                          ),
                          SizedBox(
                            width: 180,
                            child: _DropdownBox(hint: 'Country'),
                          ),
                        ],
                      ),
              ),
              SizedBox(height: isMobile ? 12 : 16),

              // Address lines
              const _TextBox(hint: 'Address Line 1'),
              SizedBox(height: isMobile ? 12 : 16),
              const _TextBox(hint: 'Address Line 2'),
              SizedBox(height: isMobile ? 12 : 16),
              const _TextBox(hint: 'Address Line 3'),
            ],
          ),
        ),
      ),
    );
  }
}

class _BranchesTab extends StatelessWidget {
  final bool isMobile;
  final bool isTablet;
  final bool isDesktop;
  const _BranchesTab({
    required this.isMobile,
    required this.isTablet,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 12 : 16),
      child: Column(
        children: [
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(isMobile ? 12 : 18),
            ),
            child: Padding(
              padding: EdgeInsets.all(isMobile ? 12 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Number Of Branches',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: isMobile ? 14 : 16,
                    ),
                  ),
                  SizedBox(height: isMobile ? 8 : 12),
                  const _TextBox(hint: '2'),
                  SizedBox(height: isMobile ? 16 : 20),
                  Row(
                    children: [
                      Checkbox(
                        value: true,
                        onChanged: null,
                        activeColor: const Color(
                          0xFF232534,
                        ), // Coach gradient start
                      ),
                      SizedBox(width: isMobile ? 8 : 12),
                      Expanded(
                        child: Text(
                          'All Sports Are Same For Each Branch',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: isMobile ? 13 : 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: isMobile ? 12 : 16),
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(isMobile ? 12 : 18),
            ),
            child: Padding(
              padding: EdgeInsets.all(isMobile ? 12 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Branch 1 Details',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: isMobile ? 16 : 18,
                    ),
                  ),
                  SizedBox(height: isMobile ? 12 : 16),
                  const _LabeledField(
                    label: 'Club Name',
                    child: _TextBox(hint: 'Branch Name'),
                  ),
                  SizedBox(height: isMobile ? 12 : 16),
                  const _LabeledField(
                    label: 'Number Of Users',
                    child: _TextBox(hint: 'User Count'),
                  ),
                  SizedBox(height: isMobile ? 12 : 16),
                  const _LabeledField(
                    label: 'Branch Address',
                    child: _TextBox(hint: 'Branch Address'),
                  ),
                  SizedBox(height: isMobile ? 12 : 16),
                  const _LabeledField(
                    label: 'Contact Number',
                    child: _TextBox(hint: 'Contact Number'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BankDetailsTab extends StatelessWidget {
  final bool isMobile;
  final bool isTablet;
  final bool isDesktop;
  const _BankDetailsTab({
    required this.isMobile,
    required this.isTablet,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 12 : 16),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(isMobile ? 12 : 18),
        ),
        child: Padding(
          padding: EdgeInsets.all(isMobile ? 12 : 16),
          child: isDesktop
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _BankLeft(isMobile: isMobile)),
                    const SizedBox(width: 24),
                    Expanded(child: _BankRight(isMobile: isMobile)),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _BankLeft(isMobile: isMobile),
                    SizedBox(height: isMobile ? 16 : 20),
                    _BankRight(isMobile: isMobile),
                  ],
                ),
        ),
      ),
    );
  }
}

class _SubscriptionsTab extends StatelessWidget {
  final bool isMobile;
  final bool isTablet;
  final bool isDesktop;
  const _SubscriptionsTab({
    required this.isMobile,
    required this.isTablet,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 12 : 16),
      child: isDesktop
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _SubscriptionLeftCard(isMobile: isMobile)),
                const SizedBox(width: 24),
                Expanded(child: _SubscriptionRightCard(isMobile: isMobile)),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SubscriptionLeftCard(isMobile: isMobile),
                SizedBox(height: isMobile ? 12 : 16),
                _SubscriptionRightCard(isMobile: isMobile),
              ],
            ),
    );
  }
}

class _AvatarBox extends StatelessWidget {
  final double size;
  const _AvatarBox({required this.size});
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        color: Colors.grey.shade200,
        width: size,
        height: size,
        child: const Icon(Icons.person, size: 64, color: Colors.grey),
      ),
    );
  }
}

class _BankLeft extends StatelessWidget {
  final bool isMobile;
  const _BankLeft({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _LabeledField(
          label: 'Account Name',
          child: _TextBox(hint: 'Bank Account Name'),
        ),
        SizedBox(height: isMobile ? 12 : 16),
        const _LabeledField(
          label: 'Bank Name',
          child: _TextBox(hint: 'Bank Name'),
        ),
        SizedBox(height: isMobile ? 12 : 16),
        const _LabeledField(
          label: 'Branch Name',
          child: _TextBox(hint: 'Branch Name'),
        ),
        SizedBox(height: isMobile ? 12 : 16),
        const _LabeledField(
          label: 'Account Type',
          child: _TextBox(hint: 'Saving'),
        ),
        SizedBox(height: isMobile ? 12 : 16),
        const _LabeledField(
          label: 'Account Number',
          child: _TextBox(hint: '123456789000000'),
        ),
        SizedBox(height: isMobile ? 12 : 16),
        const _LabeledField(
          label: 'Swift Code',
          child: _TextBox(hint: '1234567'),
        ),
        SizedBox(height: isMobile ? 12 : 16),
        const _LabeledField(
          label: 'IFSC Code',
          child: _TextBox(hint: '1234567'),
        ),
        SizedBox(height: isMobile ? 12 : 16),
        const _LabeledField(
          label: 'Stripe ID',
          child: _TextBox(hint: '1234567'),
        ),
      ],
    );
  }
}

class _BankRight extends StatelessWidget {
  final bool isMobile;
  const _BankRight({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bank Passbook',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: isMobile ? 14 : 16,
          ),
        ),
        SizedBox(height: isMobile ? 8 : 12),
        isMobile
            ? Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black12),
                    ),
                    child: const Text(
                      'Jpg,Png,Pdf',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(
                          0xFF232534,
                        ), // Coach gradient start
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Browse'),
                    ),
                  ),
                ],
              )
            : Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.black12),
                      ),
                      child: const Text(
                        'Jpg,Png,Pdf',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E40AF),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Browse'),
                  ),
                ],
              ),
        SizedBox(height: isMobile ? 8 : 12),
        Text(
          '(The file size must be less than 10 MB Only)',
          style: TextStyle(color: Colors.grey, fontSize: isMobile ? 12 : 14),
        ),
        SizedBox(height: isMobile ? 12 : 16),
        Text(
          'Preview',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: isMobile ? 13 : 14,
          ),
        ),
        SizedBox(height: isMobile ? 8 : 12),
        Container(
          height: isMobile ? 100 : 140,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black12),
          ),
        ),
        SizedBox(height: isMobile ? 12 : 16),
        const _LabeledField(
          label: 'Paypal ID',
          child: _TextBox(hint: 'Artist1234@Gmail.Com'),
        ),
        SizedBox(height: isMobile ? 12 : 16),
        const _LabeledField(
          label: 'Paypal URL',
          child: _TextBox(hint: '1234567'),
        ),
      ],
    );
  }
}

class _SubscriptionLeftCard extends StatelessWidget {
  final bool isMobile;
  const _SubscriptionLeftCard({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(isMobile ? 12 : 18),
      ),
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 12 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF2ECC71),
                borderRadius: BorderRadius.circular(isMobile ? 8 : 12),
              ),
              padding: EdgeInsets.all(isMobile ? 8 : 12),
              child: isMobile
                  ? Column(
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.verified, color: Colors.white, size: 20),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Member',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Chip(
                              label: Text(
                                'Buy / Renew',
                                style: TextStyle(fontSize: 12),
                              ),
                              backgroundColor: Colors.white,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Access To All Type Of Role Type Members (Local Area) Including Corporates.',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    )
                  : Row(
                      children: const [
                        Icon(Icons.verified, color: Colors.white),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Member  •  Access To All Type Of Role Type Members (Local Area) Including Corporates.',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Chip(
                          label: Text('Buy / Renew'),
                          backgroundColor: Colors.white,
                        ),
                      ],
                    ),
            ),
            SizedBox(height: isMobile ? 12 : 16),
            ...List.generate(
              6,
              (i) => Padding(
                padding: EdgeInsets.only(bottom: isMobile ? 8 : 12),
                child: _PriceRow(
                  title: i == 5
                      ? 'Total Amount'
                      : (i == 1 ? 'Discount Amount' : 'Forum Fee'),
                  value: 'USD 1200',
                  color: i == 1 || i == 2
                      ? Colors.red
                      : (i == 5 ? Colors.green : Colors.grey.shade800),
                  isMobile: isMobile,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SubscriptionRightCard extends StatelessWidget {
  final bool isMobile;
  const _SubscriptionRightCard({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(isMobile ? 12 : 18),
      ),
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 12 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Final Payment Details',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: isMobile ? 16 : 18,
              ),
            ),
            SizedBox(height: isMobile ? 12 : 16),
            _KeyValueField(
              label: 'Payment Method:',
              value: 'Bank Transfer',
              isMobile: isMobile,
            ),
            _KeyValueField(
              label: 'Payment Status:',
              value: 'Paid',
              isMobile: isMobile,
            ),
            _KeyValueField(
              label: 'Start Date:',
              value: '2022 Nov 17',
              isMobile: isMobile,
            ),
            _KeyValueField(
              label: 'End Date:',
              value: '2022 Nov 17',
              isMobile: isMobile,
            ),
            _KeyValueField(
              label: 'Payment Date:',
              value: '2022 Nov 17',
              isMobile: isMobile,
            ),
            _KeyValueField(
              label: 'Payment Time',
              value: '01:12:30',
              isMobile: isMobile,
            ),
          ],
        ),
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  final String label;
  final Widget child;
  const _LabeledField({required this.label, required this.child});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

class _TextBox extends StatelessWidget {
  final String hint;
  final bool enabled;
  final bool obscure;
  const _TextBox({
    required this.hint,
    this.enabled = true,
    this.obscure = false,
  });
  @override
  Widget build(BuildContext context) {
    return TextField(
      enabled: enabled,
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFDFE3E8)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFDFE3E8)),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
      ),
    );
  }
}

class _DropdownBox extends StatelessWidget {
  final String hint;
  const _DropdownBox({required this.hint});
  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFDFE3E8)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFDFE3E8)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(hint, style: const TextStyle(color: Colors.black54)),
          ),
          const Icon(Icons.arrow_drop_down),
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final bool isMobile;
  const _PriceRow({
    required this.title,
    required this.value,
    required this.color,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(isMobile ? 8 : 12),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 8 : 12,
        vertical: isMobile ? 10 : 14,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: isMobile ? 12 : 14,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: isMobile ? 12 : 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _KeyValueField extends StatelessWidget {
  final String label;
  final String value;
  final bool isMobile;
  const _KeyValueField({
    required this.label,
    required this.value,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isMobile ? 8 : 12),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                ),
                const SizedBox(height: 4),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: Text(
                    value,
                    style: const TextStyle(color: Colors.black54, fontSize: 14),
                  ),
                ),
              ],
            )
          : Row(
              children: [
                SizedBox(
                  width: isMobile ? 120 : 180,
                  child: Text(
                    label,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: isMobile ? 13 : 14,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black12),
                    ),
                    child: Text(
                      value,
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
