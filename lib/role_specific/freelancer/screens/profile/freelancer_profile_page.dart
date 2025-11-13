import 'package:flutter/material.dart';
import 'package:smart_sports/shared/widgets/role_sidebar.dart';
import 'package:smart_sports/role_specific/common/role_router.dart';
import 'package:smart_sports/shared/navigation/role_navigation_manager.dart';

class FreelancerProfilePage extends StatefulWidget {
  const FreelancerProfilePage({super.key});

  @override
  State<FreelancerProfilePage> createState() => _FreelancerProfilePageState();
}

class _FreelancerProfilePageState extends State<FreelancerProfilePage>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  bool _isEditMode = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _isEditMode = false; // Reset edit mode when switching tabs
      });
    }
  }

  void _toggleEditMode() {
    setState(() {
      _isEditMode = !_isEditMode;
    });
  }

  void _saveProfile() async {
    // Simulate save operation
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      _isEditMode = false;
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  bool _shouldShowEditButton() {
    // Show edit button for Profile (0), Company Details (1), and Bank Details (2) tabs
    return _tabController.index < 3;
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
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
              colors: [Color(0xFF232534), Color(0xFF2C3BC5)],
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
        actions: [
          if (_shouldShowEditButton())
            Container(
              margin: const EdgeInsets.only(right: 8),
              child: ElevatedButton(
                onPressed: _isEditMode ? _saveProfile : _toggleEditMode,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isEditMode
                      ? Colors.green
                      : Colors.white.withOpacity(0.2),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  minimumSize: const Size(0, 36),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _isEditMode ? Icons.save : Icons.edit,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _isEditMode ? 'Save' : 'Edit',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      drawer: Drawer(
        elevation: 0,
        child: SafeArea(
          child: RoleSidebar(
            role: UserRole.freelancer,
            selectedIndex: 10,
            edgeToEdge: true,
            onSelectIndex: (i) => RoleNavigationManager.navigateToScreen(
              context,
              UserRole.freelancer,
              i,
            ),
            onProfileTap: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Tab bar
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: isMobile ? 12 : 16,
                vertical: isMobile ? 8 : 12,
              ),
              child: _PillTabBar(
                controller: _tabController,
                isMobile: isMobile,
                tabs: [
                  const Tab(text: 'Profile'),
                  const Tab(text: 'Company Details'),
                  const Tab(text: 'Bank Details & Financials'),
                  const Tab(text: 'Subscriptions'),
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
                    isEditMode: _isEditMode,
                  ),
                  _CompanyDetailsTab(
                    isMobile: isMobile,
                    isTablet: isTablet,
                    isDesktop: isDesktop,
                    isEditMode: _isEditMode,
                  ),
                  _BankDetailsTab(
                    isMobile: isMobile,
                    isTablet: isTablet,
                    isDesktop: isDesktop,
                    isEditMode: _isEditMode,
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
            indicator: const ShapeDecoration(
              color: Color(0xFF232534),
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

// Profile Tab
class _ProfileTab extends StatelessWidget {
  final bool isMobile;
  final bool isTablet;
  final bool isDesktop;
  final bool isEditMode;
  const _ProfileTab({
    required this.isMobile,
    required this.isTablet,
    required this.isDesktop,
    required this.isEditMode,
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
              // Personal Details Section
              if (isDesktop)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _PersonalDetailsSection(
                        isMobile: isMobile,
                        isEditMode: isEditMode,
                      ),
                    ),
                    const SizedBox(width: 16),
                    _AvatarBox(size: 120),
                  ],
                )
              else ...[
                Center(child: _AvatarBox(size: isMobile ? 80 : 100)),
                SizedBox(height: isMobile ? 16 : 20),
                _PersonalDetailsSection(isMobile: isMobile, isEditMode: isEditMode),
              ],
              SizedBox(height: isMobile ? 16 : 20),
              _SectionDivider(label: 'Company Details'),
              SizedBox(height: isMobile ? 16 : 20),
              _CompanyDetailsSection(isMobile: isMobile, isEditMode: isEditMode),
            ],
          ),
        ),
      ),
    );
  }
}

class _PersonalDetailsSection extends StatelessWidget {
  final bool isMobile;
  final bool isEditMode;
  const _PersonalDetailsSection({
    required this.isMobile,
    required this.isEditMode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _LabeledField(
          label: 'Name',
          child: isMobile
              ? Column(
                  children: [
                    _TextBox(hint: 'First Name', enabled: isEditMode),
                    const SizedBox(height: 12),
                    _TextBox(hint: 'Last Name', enabled: isEditMode),
                  ],
                )
              : Row(
                  children: [
                    Expanded(child: _TextBox(hint: 'First Name', enabled: isEditMode)),
                    const SizedBox(width: 12),
                    Expanded(child: _TextBox(hint: 'Last Name', enabled: isEditMode)),
                  ],
                ),
        ),
        SizedBox(height: isMobile ? 12 : 16),
        _LabeledField(
          label: 'Role',
          child: _TextBox(hint: 'Artist', enabled: isEditMode),
        ),
        SizedBox(height: isMobile ? 12 : 16),
        _LabeledField(
          label: 'Login Email',
          child: _TextBox(hint: 'artist@ymail.com', enabled: isEditMode),
        ),
        SizedBox(height: isMobile ? 12 : 16),
        _LabeledField(
          label: 'Password',
          child: isMobile
              ? Column(
                  children: [
                    const _TextBox(hint: '**********', obscure: true),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF232534),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('CHANGE PASSWORD'),
                      ),
                    ),
                  ],
                )
              : Row(
                  children: [
                    const Expanded(
                      child: _TextBox(hint: '**********', obscure: true),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF232534),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('CHANGE PASSWORD'),
                    ),
                  ],
                ),
        ),
        SizedBox(height: isMobile ? 16 : 20),
        _SectionDivider(label: 'Personal Details'),
        SizedBox(height: isMobile ? 16 : 20),
        _LabeledField(
          label: 'Address* (Permanent)',
          child: isMobile
              ? Column(
                  children: [
                    _TextBox(hint: 'Address Line 1', enabled: isEditMode),
                    const SizedBox(height: 12),
                    _TextBox(hint: 'Address Line 2', enabled: isEditMode),
                    const SizedBox(height: 12),
                    _TextBox(hint: 'Nagpur', enabled: isEditMode),
                    const SizedBox(height: 12),
                    _DropdownBox(hint: 'MAHARASHTRA', enabled: isEditMode),
                    const SizedBox(height: 12),
                    _TextBox(hint: '440022', enabled: isEditMode),
                    const SizedBox(height: 12),
                    _DropdownBox(hint: 'INDIA', enabled: isEditMode),
                  ],
                )
              : Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    SizedBox(width: 200, child: _TextBox(hint: 'Address Line 1', enabled: isEditMode)),
                    SizedBox(width: 200, child: _TextBox(hint: 'Address Line 2', enabled: isEditMode)),
                    SizedBox(width: 150, child: _TextBox(hint: 'Nagpur', enabled: isEditMode)),
                    SizedBox(width: 150, child: _DropdownBox(hint: 'MAHARASHTRA', enabled: isEditMode)),
                    SizedBox(width: 120, child: _TextBox(hint: '440022', enabled: isEditMode)),
                    SizedBox(width: 150, child: _DropdownBox(hint: 'INDIA', enabled: isEditMode)),
                  ],
                ),
        ),
      ],
    );
  }
}

class _CompanyDetailsSection extends StatelessWidget {
  final bool isMobile;
  final bool isEditMode;
  const _CompanyDetailsSection({
    required this.isMobile,
    required this.isEditMode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _LabeledField(
          label: 'Company Name',
          child: _TextBox(hint: 'Company Name', enabled: isEditMode),
        ),
        SizedBox(height: isMobile ? 12 : 16),
        _LabeledField(
          label: 'Designation',
          child: _TextBox(hint: 'Director', enabled: isEditMode),
        ),
        SizedBox(height: isMobile ? 12 : 16),
        _LabeledField(
          label: 'Department',
          child: _TextBox(hint: 'Administration', enabled: isEditMode),
        ),
        SizedBox(height: isMobile ? 12 : 16),
        _LabeledField(
          label: 'Telephone',
          child: Row(
            children: [
              SizedBox(width: 120, child: _DropdownBox(hint: 'INDIA (+91)', enabled: isEditMode)),
              const SizedBox(width: 12),
              Expanded(child: _TextBox(hint: '12-3456-7890', enabled: isEditMode)),
            ],
          ),
        ),
        SizedBox(height: isMobile ? 12 : 16),
        _LabeledField(
          label: 'Fax',
          child: Row(
            children: [
              SizedBox(width: 120, child: _DropdownBox(hint: 'INDIA (+91)', enabled: isEditMode)),
              const SizedBox(width: 12),
              Expanded(child: _TextBox(hint: '12-3456-7890', enabled: isEditMode)),
            ],
          ),
        ),
        SizedBox(height: isMobile ? 12 : 16),
        _LabeledField(
          label: 'Mobile Number',
          child: Row(
            children: [
              SizedBox(width: 120, child: _DropdownBox(hint: 'INDIA (+91)', enabled: isEditMode)),
              const SizedBox(width: 12),
              Expanded(child: _TextBox(hint: '12-3456-7890', enabled: isEditMode)),
            ],
          ),
        ),
        SizedBox(height: isMobile ? 12 : 16),
        _LabeledField(
          label: 'Website',
          child: _TextBox(hint: 'www.xyzcompany.com', enabled: isEditMode),
        ),
      ],
    );
  }
}

// Company Details Tab
class _CompanyDetailsTab extends StatelessWidget {
  final bool isMobile;
  final bool isTablet;
  final bool isDesktop;
  final bool isEditMode;
  const _CompanyDetailsTab({
    required this.isMobile,
    required this.isTablet,
    required this.isDesktop,
    required this.isEditMode,
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
              _LabeledField(
                label: 'Number Of Users',
                child: _TextBox(hint: '2', enabled: isEditMode),
              ),
              const SizedBox(height: 8),
              Text(
                '(You Will Be Allowed To Add Users From Your Admin Panel After Subscription.)',
                style: TextStyle(
                  color: Colors.red.shade700,
                  fontSize: isMobile ? 11 : 12,
                ),
              ),
              SizedBox(height: isMobile ? 20 : 24),
              CheckboxListTile(
                title: const Text('Company Address Is Same As Sign Up Address?'),
                value: false,
                onChanged: isEditMode ? (value) {} : null,
                contentPadding: EdgeInsets.zero,
              ),
              SizedBox(height: isMobile ? 16 : 20),
              _SectionDivider(label: 'Company Address'),
              SizedBox(height: isMobile ? 16 : 20),
              _LabeledField(
                label: 'Address 1',
                child: _TextBox(hint: 'Xyz', enabled: isEditMode),
              ),
              SizedBox(height: isMobile ? 12 : 16),
              _LabeledField(
                label: 'Address 2',
                child: _TextBox(hint: 'Xyz', enabled: isEditMode),
              ),
              SizedBox(height: isMobile ? 12 : 16),
              isMobile
                  ? Column(
                      children: [
                        _LabeledField(
                          label: 'City',
                          child: _DropdownBox(hint: 'Xyz', enabled: isEditMode),
                        ),
                        const SizedBox(height: 12),
                        _LabeledField(
                          label: 'State',
                          child: _DropdownBox(hint: 'Xyz', enabled: isEditMode),
                        ),
                        const SizedBox(height: 12),
                        _LabeledField(
                          label: 'Zip Code',
                          child: _TextBox(hint: 'Xyz', enabled: isEditMode),
                        ),
                        const SizedBox(height: 12),
                        _LabeledField(
                          label: 'Country',
                          child: _TextBox(hint: 'Xyz', enabled: isEditMode),
                        ),
                      ],
                    )
                  : Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        SizedBox(
                          width: 200,
                          child: _LabeledField(
                            label: 'City',
                            child: _DropdownBox(hint: 'Xyz', enabled: isEditMode),
                          ),
                        ),
                        SizedBox(
                          width: 200,
                          child: _LabeledField(
                            label: 'State',
                            child: _DropdownBox(hint: 'Xyz', enabled: isEditMode),
                          ),
                        ),
                        SizedBox(
                          width: 150,
                          child: _LabeledField(
                            label: 'Zip Code',
                            child: _TextBox(hint: 'Xyz', enabled: isEditMode),
                          ),
                        ),
                        SizedBox(
                          width: 150,
                          child: _LabeledField(
                            label: 'Country',
                            child: _TextBox(hint: 'Xyz', enabled: isEditMode),
                          ),
                        ),
                      ],
                    ),
              SizedBox(height: isMobile ? 20 : 24),
              CheckboxListTile(
                title: const Text('Contact Details Is Same As Sign Up Contact Details?'),
                value: false,
                onChanged: isEditMode ? (value) {} : null,
                contentPadding: EdgeInsets.zero,
              ),
              SizedBox(height: isMobile ? 16 : 20),
              _SectionDivider(label: 'Contact Details'),
              SizedBox(height: isMobile ? 16 : 20),
              isMobile
                  ? Column(
                      children: [
                        _LabeledField(
                          label: 'Designation',
                          child: _TextBox(hint: 'Designation', enabled: isEditMode),
                        ),
                        const SizedBox(height: 12),
                        _LabeledField(
                          label: 'Department',
                          child: _TextBox(hint: 'Department', enabled: isEditMode),
                        ),
                        const SizedBox(height: 12),
                        _LabeledField(
                          label: 'Office Number',
                          child: _TextBox(hint: '+91 9876543210', enabled: isEditMode),
                        ),
                        const SizedBox(height: 12),
                        _LabeledField(
                          label: 'Mobile Number',
                          child: _TextBox(hint: '+91 9876543210', enabled: isEditMode),
                        ),
                        const SizedBox(height: 12),
                        _LabeledField(
                          label: 'Company Website',
                          child: _TextBox(hint: 'https://abc.com', enabled: isEditMode),
                        ),
                      ],
                    )
                  : Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        SizedBox(
                          width: 200,
                          child: _LabeledField(
                            label: 'Designation',
                            child: _TextBox(hint: 'Designation', enabled: isEditMode),
                          ),
                        ),
                        SizedBox(
                          width: 200,
                          child: _LabeledField(
                            label: 'Department',
                            child: _TextBox(hint: 'Department', enabled: isEditMode),
                          ),
                        ),
                        SizedBox(
                          width: 200,
                          child: _LabeledField(
                            label: 'Office Number',
                            child: _TextBox(hint: '+91 9876543210', enabled: isEditMode),
                          ),
                        ),
                        SizedBox(
                          width: 200,
                          child: _LabeledField(
                            label: 'Mobile Number',
                            child: _TextBox(hint: '+91 9876543210', enabled: isEditMode),
                          ),
                        ),
                        SizedBox(
                          width: 300,
                          child: _LabeledField(
                            label: 'Company Website',
                            child: _TextBox(hint: 'https://abc.com', enabled: isEditMode),
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

// Bank Details Tab
class _BankDetailsTab extends StatelessWidget {
  final bool isMobile;
  final bool isTablet;
  final bool isDesktop;
  final bool isEditMode;
  const _BankDetailsTab({
    required this.isMobile,
    required this.isTablet,
    required this.isDesktop,
    required this.isEditMode,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 12 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
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
                        Expanded(child: _BankLeft(isMobile: isMobile, isEditMode: isEditMode)),
                        const SizedBox(width: 24),
                        Expanded(child: _BankRight(isMobile: isMobile, isEditMode: isEditMode)),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _BankLeft(isMobile: isMobile, isEditMode: isEditMode),
                        SizedBox(height: isMobile ? 16 : 20),
                        _BankRight(isMobile: isMobile, isEditMode: isEditMode),
                      ],
                    ),
            ),
          ),
          SizedBox(height: isMobile ? 16 : 20),
          _FinancialsSection(isMobile: isMobile),
        ],
      ),
    );
  }
}

class _BankLeft extends StatelessWidget {
  final bool isMobile;
  final bool isEditMode;
  const _BankLeft({required this.isMobile, required this.isEditMode});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _LabeledField(
          label: 'Account Name',
          child: _TextBox(hint: '', enabled: isEditMode),
        ),
        SizedBox(height: isMobile ? 12 : 16),
        _LabeledField(
          label: 'Bank Name',
          child: _TextBox(hint: '', enabled: isEditMode),
        ),
        SizedBox(height: isMobile ? 12 : 16),
        _LabeledField(
          label: 'Branch Name',
          child: _TextBox(hint: '', enabled: isEditMode),
        ),
        SizedBox(height: isMobile ? 12 : 16),
        _LabeledField(
          label: 'Account Type',
          child: _DropdownBox(hint: 'SAVING', enabled: isEditMode),
        ),
        SizedBox(height: isMobile ? 12 : 16),
        _LabeledField(
          label: 'Account Number',
          child: _TextBox(hint: 'X00000000X', enabled: isEditMode),
        ),
        SizedBox(height: isMobile ? 12 : 16),
        _LabeledField(
          label: 'Swift Code',
          child: _TextBox(hint: 'X0000X', enabled: isEditMode),
        ),
        SizedBox(height: isMobile ? 12 : 16),
        _LabeledField(
          label: 'IFSC Code',
          child: _TextBox(hint: 'XXXXXX', enabled: isEditMode),
        ),
        SizedBox(height: isMobile ? 12 : 16),
        _LabeledField(
          label: 'Stripe ID',
          child: _TextBox(hint: 'XXXXXXXXXXX', enabled: isEditMode),
        ),
        SizedBox(height: isMobile ? 12 : 16),
        _LabeledField(
          label: 'Paypal ID',
          child: _TextBox(hint: 'artist1234@gmail.com', enabled: isEditMode),
        ),
        SizedBox(height: isMobile ? 12 : 16),
        _LabeledField(
          label: 'Paypal URL',
          child: _TextBox(hint: 'XXXXXXXXXXXXX', enabled: isEditMode),
        ),
      ],
    );
  }
}

class _BankRight extends StatelessWidget {
  final bool isMobile;
  final bool isEditMode;
  const _BankRight({required this.isMobile, required this.isEditMode});

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
        const SizedBox(height: 4),
        Text(
          'Preview',
          style: TextStyle(
            fontSize: isMobile ? 11 : 12,
            color: Colors.grey.shade600,
          ),
        ),
        SizedBox(height: isMobile ? 8 : 12),
        Container(
          width: double.infinity,
          height: isMobile ? 200 : 300,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.image, size: 48, color: Colors.grey.shade400),
              const SizedBox(height: 8),
              Text(
                'Bank Passbook Image',
                style: TextStyle(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 4),
              Text(
                '(The file size must be less than 2MB Only)',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: isMobile ? 12 : 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isEditMode ? () {} : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF232534),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: const Text('Browse'),
          ),
        ),
      ],
    );
  }
}

class _FinancialsSection extends StatelessWidget {
  final bool isMobile;
  const _FinancialsSection({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _RevenueSection(isMobile: isMobile),
        SizedBox(height: isMobile ? 20 : 24),
        _ExpensesSection(isMobile: isMobile),
      ],
    );
  }
}

class _RevenueSection extends StatelessWidget {
  final bool isMobile;
  const _RevenueSection({required this.isMobile});

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
              'REVENUE EARNED',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: isMobile ? 16 : 18,
              ),
            ),
            SizedBox(height: isMobile ? 12 : 16),
            Row(
              children: [
                _FilterButton(label: 'All', isSelected: false),
                const SizedBox(width: 8),
                _FilterButton(label: 'Financial Year', isSelected: true),
                const SizedBox(width: 8),
                _FilterButton(label: 'Flexible Duration', isSelected: false),
              ],
            ),
            SizedBox(height: isMobile ? 12 : 16),
            isMobile
                ? Column(
                    children: [
                      Row(
                        children: const [
                          Expanded(child: _DateField(label: 'Start Month', value: 'JAN')),
                          SizedBox(width: 8),
                          Expanded(child: _DateField(label: 'Year', value: '2021')),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: const [
                          Expanded(child: _DateField(label: 'End Month', value: 'DEC')),
                          SizedBox(width: 8),
                          Expanded(child: _DateField(label: 'Year', value: '2021')),
                        ],
                      ),
                    ],
                  )
                : Row(
                    children: const [
                      _DateField(label: 'Start Month', value: 'JAN'),
                      SizedBox(width: 12),
                      _DateField(label: 'Year', value: '2021'),
                      SizedBox(width: 24),
                      _DateField(label: 'End Month', value: 'DEC'),
                      SizedBox(width: 12),
                      _DateField(label: 'Year', value: '2021'),
                    ],
                  ),
            SizedBox(height: isMobile ? 16 : 20),
            isMobile
                ? Column(
                    children: const [
                      _FinancialCard(
                        label: 'TOTAL REVENUES',
                        amount: 'USD 50,000',
                        color: Color(0xFF232534),
                      ),
                      SizedBox(height: 12),
                      _FinancialCard(
                        label: 'PAYMENT RELEASED BY SEKAI-ICHI',
                        amount: 'USD 30,000',
                        color: Colors.green,
                      ),
                      SizedBox(height: 12),
                      _FinancialCard(
                        label: 'PAYMENT PENDING',
                        amount: 'USD 20,000',
                        color: Colors.red,
                      ),
                    ],
                  )
                : Row(
                    children: const [
                      Expanded(
                        child: _FinancialCard(
                          label: 'TOTAL REVENUES',
                          amount: 'USD 50,000',
                          color: Color(0xFF232534),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _FinancialCard(
                          label: 'PAYMENT RELEASED BY SEKAI-ICHI',
                          amount: 'USD 30,000',
                          color: Colors.green,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _FinancialCard(
                          label: 'PAYMENT PENDING',
                          amount: 'USD 20,000',
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}

class _ExpensesSection extends StatelessWidget {
  final bool isMobile;
  const _ExpensesSection({required this.isMobile});

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
              'SUBSCRIPTION EXPENSES',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: isMobile ? 16 : 18,
              ),
            ),
            SizedBox(height: isMobile ? 12 : 16),
            Row(
              children: [
                _FilterButton(label: 'All', isSelected: false),
                const SizedBox(width: 8),
                _FilterButton(label: 'Financial Year', isSelected: true),
                const SizedBox(width: 8),
                _FilterButton(label: 'Flexible Duration', isSelected: false),
              ],
            ),
            SizedBox(height: isMobile ? 12 : 16),
            isMobile
                ? Column(
                    children: [
                      Row(
                        children: const [
                          Expanded(child: _DateField(label: 'Start Month', value: 'JAN')),
                          SizedBox(width: 8),
                          Expanded(child: _DateField(label: 'Year', value: '2021')),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: const [
                          Expanded(child: _DateField(label: 'End Month', value: 'DEC')),
                          SizedBox(width: 8),
                          Expanded(child: _DateField(label: 'Year', value: '2021')),
                        ],
                      ),
                    ],
                  )
                : Row(
                    children: const [
                      _DateField(label: 'Start Month', value: 'JAN'),
                      SizedBox(width: 12),
                      _DateField(label: 'Year', value: '2021'),
                      SizedBox(width: 24),
                      _DateField(label: 'End Month', value: 'DEC'),
                      SizedBox(width: 12),
                      _DateField(label: 'Year', value: '2021'),
                    ],
                  ),
            SizedBox(height: isMobile ? 16 : 20),
            isMobile
                ? Column(
                    children: const [
                      _FinancialCard(
                        label: 'TOTAL EXPENSES',
                        amount: 'USD 30,000',
                        color: Color(0xFF232534),
                      ),
                      SizedBox(height: 12),
                      _FinancialCard(
                        label: 'PAYMENT RELEASED TO SEKAI-ICHI',
                        amount: 'USD 30,000',
                        color: Colors.green,
                      ),
                      SizedBox(height: 12),
                      _FinancialCard(
                        label: 'PAYMENT PENDING',
                        amount: 'USD 0',
                        color: Colors.red,
                      ),
                    ],
                  )
                : Row(
                    children: const [
                      Expanded(
                        child: _FinancialCard(
                          label: 'TOTAL EXPENSES',
                          amount: 'USD 30,000',
                          color: Color(0xFF232534),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _FinancialCard(
                          label: 'PAYMENT RELEASED TO SEKAI-ICHI',
                          amount: 'USD 30,000',
                          color: Colors.green,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _FinancialCard(
                          label: 'PAYMENT PENDING',
                          amount: 'USD 0',
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}

// Subscriptions Tab
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
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(isMobile ? 12 : 18),
        ),
        child: Padding(
          padding: EdgeInsets.all(isMobile ? 12 : 16),
          child: const Center(
            child: Text('Subscriptions content coming soon'),
          ),
        ),
      ),
    );
  }
}

// Helper Widgets
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

class _LabeledField extends StatelessWidget {
  final String label;
  final Widget child;
  const _LabeledField({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
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
        fillColor: enabled ? Colors.white : Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
    );
  }
}

class _DropdownBox extends StatelessWidget {
  final String hint;
  final bool enabled;
  const _DropdownBox({required this.hint, this.enabled = true});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !enabled,
      child: Opacity(
        opacity: enabled ? 1.0 : 0.6,
        child: DropdownButtonFormField<String>(
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: enabled ? Colors.white : Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          ),
          items: const [
            DropdownMenuItem(value: '1', child: Text('Option 1')),
            DropdownMenuItem(value: '2', child: Text('Option 2')),
          ],
          onChanged: enabled ? (value) {} : null,
        ),
      ),
    );
  }
}

class _SectionDivider extends StatelessWidget {
  final String label;
  const _SectionDivider({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: Colors.blue.shade700,
            thickness: 2,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF232534),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: Colors.blue.shade700,
            thickness: 2,
          ),
        ),
      ],
    );
  }
}

class _FilterButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  const _FilterButton({required this.label, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF232534) : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  final String label;
  final String value;
  const _DateField({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(width: 8),
              Icon(Icons.arrow_drop_down, size: 20, color: Colors.grey.shade600),
            ],
          ),
        ),
      ],
    );
  }
}

class _FinancialCard extends StatelessWidget {
  final String label;
  final String amount;
  final Color color;
  const _FinancialCard({
    required this.label,
    required this.amount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            amount,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

