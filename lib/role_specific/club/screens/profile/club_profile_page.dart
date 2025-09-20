import 'package:flutter/material.dart';
import 'package:smart_sports/shared/widgets/role_sidebar.dart';
import 'package:smart_sports/role_specific/common/role_router.dart';
import 'package:smart_sports/role_specific/club/screens/courts/courts_page.dart';
import 'package:smart_sports/role_specific/club/screens/dashboard/club_analytics_dashboard_page.dart';

class ClubProfilePage extends StatefulWidget {
  const ClubProfilePage({super.key});

  @override
  State<ClubProfilePage> createState() => _ClubProfilePageState();
}

void _navigateFromClubSidebar(BuildContext context, int index) {
  switch (index) {
    case 0:
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const ClubAnalyticsDashboardPage()),
      );
      break;
    case 1:
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const _ClubProfilePlaceholder(title: 'Transactions')),
      );
      break;
    case 2:
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const ClubCourtsPage()),
      );
      break;
    case 3:
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const _ClubProfilePlaceholder(title: 'Clubs')),
      );
      break;
    case 4:
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const _ClubProfilePlaceholder(title: 'Bookings')),
      );
      break;
    case 5:
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const _ClubProfilePlaceholder(title: 'Events / Tournaments')),
      );
      break;
    case 6:
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const _ClubProfilePlaceholder(title: 'Sponsorships')),
      );
      break;
    case 7:
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const _ClubProfilePlaceholder(title: 'Users')),
      );
      break;
    case 8:
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const _ClubProfilePlaceholder(title: 'Referrals')),
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
      appBar: AppBar(title: Text(title), leading: Builder(
        builder: (ctx) => IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => Scaffold.of(ctx).openDrawer(),
        ),
      )),
      body: Center(child: Text('$title screen coming soon')),
    );
  }
}

class _ClubProfilePageState extends State<ClubProfilePage> with TickerProviderStateMixin {
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
            role: UserRole.club,
            selectedIndex: 0,
            edgeToEdge: true,
            onSelectIndex: (i) async {
              Navigator.of(context).pop();
              await Future.delayed(const Duration(milliseconds: 160));
              _navigateFromClubSidebar(context, i);
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
              child: _PillTabBar(controller: _tabController, tabs: const [
                Tab(text: 'Profile'),
                Tab(text: 'Branches'),
                Tab(text: 'Bank Details & Financials'),
                Tab(text: 'Subscriptions'),
              ]),
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
            )
          ],
        ),
      ),
    );
  }
}

class _PillTabBar extends StatelessWidget {
  final TabController controller;
  final List<Widget> tabs;
  const _PillTabBar({required this.controller, required this.tabs});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 3,
      shadowColor: Colors.black12,
      borderRadius: BorderRadius.circular(28),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.black12),
          ),
          child: TabBar(
            controller: controller,
            tabs: tabs,
            isScrollable: true,
            indicator: const ShapeDecoration(
              color: Colors.black87,
              shape: StadiumBorder(side: BorderSide.none),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.black87,
            labelStyle: const TextStyle(fontWeight: FontWeight.w700),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
            dividerColor: Colors.transparent,
          ),
        ),
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
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isWide)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _LabeledField(label: 'Name', child: Row(children: const [
                        Expanded(child: _TextBox(hint: 'First Name')),
                        SizedBox(width: 12),
                        Expanded(child: _TextBox(hint: 'Last Name')),
                      ])),
                    ),
                    const SizedBox(width: 16),
                    _AvatarBox(size: 120),
                  ],
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    _LabeledField(label: 'Name', child: _TextBox(hint: 'First Name')),
                    SizedBox(height: 12),
                    _TextBox(hint: 'Last Name'),
                  ],
                ),
              const SizedBox(height: 16),
              if (!isWide) ...[
                const _AvatarBox(size: 100),
                const SizedBox(height: 16),
              ],
              _LabeledField(label: 'Role', child: const _TextBox(hint: 'Club Owner', enabled: false)),
              const SizedBox(height: 12),
              _LabeledField(label: 'Login Email', child: const _TextBox(hint: 'Artist@Ymail.Com', enabled: false)),
              const SizedBox(height: 12),
              _LabeledField(
                label: 'Password',
                child: Row(children: [
                  const Expanded(child: _TextBox(hint: '************', obscure: true)),
                  const SizedBox(width: 12),
                  ElevatedButton(onPressed: (){}, child: const Text('Change Password')),
                ]),
              ),
              const SizedBox(height: 12),
              _LabeledField(
                label: 'Address*(Permanent)',
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: const [
                    SizedBox(width: 180, child: _TextBox(hint: '440022')),
                    SizedBox(width: 200, child: _DropdownBox(hint: 'Nagpur')),
                    SizedBox(width: 220, child: _DropdownBox(hint: 'Maharashtra')),
                    SizedBox(width: 180, child: _DropdownBox(hint: 'India')),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const _TextBox(hint: 'Address Line 1'),
              const SizedBox(height: 12),
              const _TextBox(hint: 'Address Line 2'),
              const SizedBox(height: 12),
              const _TextBox(hint: 'Address Line 3'),
            ],
          ),
        ),
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
        children: [
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Number Of Branches', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                  SizedBox(height: 8),
                  _TextBox(hint: '2'),
                  SizedBox(height: 16),
                  Row(children: [
                    Checkbox(value: true, onChanged: null),
                    SizedBox(width: 8),
                    Expanded(child: Text('All Sports Are Same For Each Branch', style: TextStyle(fontWeight: FontWeight.w700))),
                  ])
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Branch 1 Details', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
                  SizedBox(height: 12),
                  _LabeledField(label: 'Club Name', child: _TextBox(hint: '2')),
                  SizedBox(height: 12),
                  _LabeledField(label: 'Number Of Users', child: _TextBox(hint: '2')),
                ],
              ),
            ),
          )
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
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: (isWide)
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _BankLeft()),
                    const SizedBox(width: 24),
                    const Expanded(child: _BankRight()),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    _BankLeft(),
                    SizedBox(height: 16),
                    _BankRight(),
                  ],
                ),
        ),
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
      child: (isWide)
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Expanded(child: _SubscriptionLeftCard()),
                SizedBox(width: 24),
                Expanded(child: _SubscriptionRightCard()),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                _SubscriptionLeftCard(),
                SizedBox(height: 16),
                _SubscriptionRightCard(),
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
  const _BankLeft();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _LabeledField(label: 'Account Name', child: _TextBox(hint: 'Bank Account Name')),
        SizedBox(height: 12),
        _LabeledField(label: 'Bank Name', child: _TextBox(hint: 'Bank Name')),
        SizedBox(height: 12),
        _LabeledField(label: 'Branch Name', child: _TextBox(hint: 'Branch Name')),
        SizedBox(height: 12),
        _LabeledField(label: 'Account Type', child: _TextBox(hint: 'Saving')),
        SizedBox(height: 12),
        _LabeledField(label: 'Account Number', child: _TextBox(hint: '123456789000000')),
        SizedBox(height: 12),
        _LabeledField(label: 'Swift Code', child: _TextBox(hint: '1234567')),
        SizedBox(height: 12),
        _LabeledField(label: 'IFSC Code', child: _TextBox(hint: '1234567')),
        SizedBox(height: 12),
        _LabeledField(label: 'Stripe ID', child: _TextBox(hint: '1234567')),
      ],
    );
  }
}

class _BankRight extends StatelessWidget {
  const _BankRight();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Bank Passbook', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black12),
              ),
              child: const Text('Jpg,Png,Pdf', style: TextStyle(color: Colors.grey)),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(onPressed: (){}, child: const Text('Browse')),
        ]),
        const SizedBox(height: 8),
        const Text('(The file size must be less than 10 MB Only)', style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 12),
        const Text('Preview'),
        const SizedBox(height: 8),
        Container(
          height: 140,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black12),
          ),
        ),
        const SizedBox(height: 16),
        const _LabeledField(label: 'Paypal ID', child: _TextBox(hint: 'Artist1234@Gmail.Com')),
        const SizedBox(height: 12),
        const _LabeledField(label: 'Paypal URL', child: _TextBox(hint: '1234567')),
      ],
    );
  }
}

class _SubscriptionLeftCard extends StatelessWidget {
  const _SubscriptionLeftCard();
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF2ECC71),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(12),
              child: Row(
                children: const [
                  Icon(Icons.verified, color: Colors.white),
                  SizedBox(width: 8),
                  Expanded(child: Text('Member  •  Access To All Type Of Role Type Members (Local Area) Including Corporates.', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700))),
                  SizedBox(width: 8),
                  Chip(label: Text('Buy / Renew'), backgroundColor: Colors.white),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ...List.generate(6, (i) => Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: _PriceRow(title: i == 5 ? 'Total Amount' : (i == 1 ? 'Discount Amount' : 'Forum Fee'), value: 'USD 1200', color: i == 1 || i == 2 ? Colors.red : (i == 5 ? Colors.green : Colors.grey.shade800)),
            )),
          ],
        ),
      ),
    );
  }
}

class _SubscriptionRightCard extends StatelessWidget {
  const _SubscriptionRightCard();
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Final Payment Details', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
            SizedBox(height: 12),
            _KeyValueField(label: 'Payment Method:', value: 'Bank Transfer'),
            _KeyValueField(label: 'Payment Status:', value: 'Paid'),
            _KeyValueField(label: 'Start Date:', value: '2022 Nov 17'),
            _KeyValueField(label: 'End Date:', value: '2022 Nov 17'),
            _KeyValueField(label: 'Payment Date:', value: '2022 Nov 17'),
            _KeyValueField(label: 'Payment Time', value: '01:12:30'),
          ],
        ),
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  final String label; final Widget child;
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
  final String hint; final bool enabled; final bool obscure;
  const _TextBox({required this.hint, this.enabled = true, this.obscure = false});
  @override
  Widget build(BuildContext context) {
    return TextField(
      enabled: enabled,
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFDFE3E8))),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFDFE3E8))),
        disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE0E0E0))),
      ),
    );
  }
}

class _DropdownBox extends StatelessWidget {
  final String hint; const _DropdownBox({required this.hint});
  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFDFE3E8))),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFDFE3E8))),
      ),
      child: Row(
        children: [
          Expanded(child: Text(hint, style: const TextStyle(color: Colors.black54))),
          const Icon(Icons.arrow_drop_down),
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String title; final String value; final Color color;
  const _PriceRow({required this.title, required this.value, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: Row(
        children: [
          Expanded(child: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700))),
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _KeyValueField extends StatelessWidget {
  final String label; final String value;
  const _KeyValueField({required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          SizedBox(width: 180, child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700))),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black12),
              ),
              child: Text(value, style: const TextStyle(color: Colors.black54)),
            ),
          ),
        ],
      ),
    );
  }
}
