import 'package:flutter/material.dart';
import 'package:smart_sports/shared/widgets/role_sidebar.dart';
import 'package:smart_sports/role_specific/common/role_router.dart';
import 'package:smart_sports/shared/navigation/role_navigation_manager.dart';
import 'package:smart_sports/auth/screens/auth_shell.dart';
import 'package:smart_sports/shared/widgets/profile_tab_components.dart';
import 'package:smart_sports/shared/widgets/profile_tab_content_builder.dart';
import 'package:smart_sports/shared/widgets/profile_tabs/members_tab.dart';
import 'package:smart_sports/shared/widgets/profile_tabs/bank_details_tab.dart';
import 'package:smart_sports/shared/widgets/profile_tabs/subscriptions_tab.dart';

class MemberProfilePage extends StatefulWidget {
  const MemberProfilePage({super.key});

  @override
  State<MemberProfilePage> createState() => _MemberProfilePageState();
}

class _MemberProfilePageState extends State<MemberProfilePage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late TabController _tabController;
  final Color _roleColor = const Color(0xFF009A69); // Green for Member

  // Form controllers
  final _firstNameController = TextEditingController(text: 'Emily');
  final _lastNameController = TextEditingController(text: 'Davis');
  final _passwordController = TextEditingController();
  final _addressLine1Controller = TextEditingController(
    text: '123 Main Street',
  );
  final _addressLine2Controller = TextEditingController(text: 'Apt 4B');
  final _cityController = TextEditingController(text: 'New York');
  final _pincodeController = TextEditingController(text: '10001');
  final _companyNameController = TextEditingController(
    text: 'Tech Solutions Inc.',
  );
  final _designationController = TextEditingController(
    text: 'Software Engineer',
  );
  final _departmentController = TextEditingController(text: 'Engineering');
  final _telephoneController = TextEditingController(text: '1234567890');
  final _faxController = TextEditingController(text: '1234567891');
  final _mobileController = TextEditingController(text: '9876543210');
  final _websiteController = TextEditingController(text: 'www.example.com');

  String _selectedState = 'New York';
  String _selectedCountry = 'United States';
  String _selectedTelephoneCode = '+1';
  String _selectedFaxCode = '+1';
  String _selectedMobileCode = '+1';

  bool _isEditMode = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_handleTabChange);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  void _handleTabChange() {
    if (!mounted) return;
    if (_tabController.indexIsChanging) {
      setState(() {
        _isEditMode = false; // Reset edit mode when switching tabs
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _tabController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _passwordController.dispose();
    _addressLine1Controller.dispose();
    _addressLine2Controller.dispose();
    _cityController.dispose();
    _pincodeController.dispose();
    _companyNameController.dispose();
    _designationController.dispose();
    _departmentController.dispose();
    _telephoneController.dispose();
    _faxController.dispose();
    _mobileController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isMobile = screenSize.width < 768;
    final isTablet = screenSize.width >= 768 && screenSize.width < 1024;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      drawer: Drawer(
        elevation: 0,
        child: SafeArea(
          child: RoleSidebar(
            role: UserRole.member,
            selectedIndex: -1,
            edgeToEdge: true,
            onSelectIndex: (i) => RoleNavigationManager.navigateToScreen(
              context,
              UserRole.member,
              i,
            ),
            onProfileTap: () => Navigator.of(context).pop(),
            onSignOut: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const AuthShell()),
                (route) => false,
              );
            },
          ),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              expandedHeight: isMobile ? 180.0 : 220.0,
              floating: false,
              pinned: true,
              elevation: 0,
              backgroundColor: const Color(0xFF009A69),
              leading: Builder(
                builder: (ctx) => IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white),
                  onPressed: () => Scaffold.of(ctx).openDrawer(),
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  'Profile',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isMobile ? 22 : 26,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
                centerTitle: true,
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF009A69), Color(0xFF232534)],
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: -50,
                        right: -50,
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.1),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -30,
                        left: -30,
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.08),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile
                      ? 20.0
                      : isTablet
                      ? 32.0
                      : 40.0,
                  vertical: 24.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tab Navigation
                    ProfilePillTabBar(
                      controller: _tabController,
                      roleColor: _roleColor,
                      isMobile: isMobile,
                      tabs: const [
                        Tab(text: 'Profile'),
                        Tab(text: 'Members'),
                        Tab(text: 'Bank Details & Financials'),
                        Tab(text: 'Subscriptions'),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Tab Content
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          ProfileTabContentBuilder(
                            roleColor: _roleColor,
                            isMobile: isMobile,
                            isEditMode: _isEditMode,
                            onEditModeChanged: (value) {
                              setState(() => _isEditMode = value);
                            },
                            firstNameController: _firstNameController,
                            lastNameController: _lastNameController,
                            passwordController: _passwordController,
                            addressLine1Controller: _addressLine1Controller,
                            addressLine2Controller: _addressLine2Controller,
                            cityController: _cityController,
                            pincodeController: _pincodeController,
                            companyNameController: _companyNameController,
                            designationController: _designationController,
                            departmentController: _departmentController,
                            telephoneController: _telephoneController,
                            faxController: _faxController,
                            mobileController: _mobileController,
                            websiteController: _websiteController,
                            selectedState: _selectedState,
                            selectedCountry: _selectedCountry,
                            selectedTelephoneCode: _selectedTelephoneCode,
                            selectedFaxCode: _selectedFaxCode,
                            selectedMobileCode: _selectedMobileCode,
                            onStateChanged: (value) {
                              setState(() => _selectedState = value);
                            },
                            onCountryChanged: (value) {
                              setState(() => _selectedCountry = value);
                            },
                            onTelephoneCodeChanged: (value) {
                              setState(() => _selectedTelephoneCode = value);
                            },
                            onFaxCodeChanged: (value) {
                              setState(() => _selectedFaxCode = value);
                            },
                            onMobileCodeChanged: (value) {
                              setState(() => _selectedMobileCode = value);
                            },
                            roleLabel: 'Member',
                            userEmail: 'emily.davis@example.com',
                          ),
                          MembersTab(roleColor: _roleColor, isMobile: isMobile),
                          BankDetailsTab(
                            roleColor: _roleColor,
                            isMobile: isMobile,
                          ),
                          SubscriptionsTab(
                            roleColor: _roleColor,
                            isMobile: isMobile,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
