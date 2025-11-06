import 'package:flutter/material.dart';
import 'package:smart_sports/shared/widgets/role_sidebar.dart';
import 'package:smart_sports/role_specific/common/role_router.dart';
import 'package:smart_sports/role_specific/club/screens/courts/courts_page.dart';
import 'package:smart_sports/role_specific/club/screens/dashboard/club_analytics_dashboard_page.dart';
import 'package:smart_sports/role_specific/club/screens/users/club_users_page.dart';

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
        MaterialPageRoute(builder: (_) => const ClubUsersPage()),
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

class _ClubProfilePageState extends State<ClubProfilePage>
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

  bool _shouldShowEditButton() {
    // Show edit button for Profile (0), Branches (1), and Bank (2) tabs
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
    // Mobile-first: treat most screens as mobile for better UX
    final isMobile = screenSize.width < 1024;
    final isTablet = screenSize.width >= 1024 && screenSize.width < 1440;
    final isDesktop = screenSize.width >= 1440;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        centerTitle: isMobile,
        backgroundColor: const Color(0xFF1E40AF), // Club blue
        foregroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        actions: _shouldShowEditButton()
            ? [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: isMobile ? 8 : 12),
                  child: ElevatedButton.icon(
                    onPressed: _toggleEditMode,
                    icon: Icon(
                      _isEditMode ? Icons.save : Icons.edit,
                      size: isMobile ? 16 : 18,
                    ),
                    label: Text(
                      _isEditMode ? 'Save' : 'Edit',
                      style: TextStyle(
                        fontSize: isMobile ? 12 : 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isEditMode ? Colors.green : Colors.white,
                      foregroundColor: _isEditMode ? Colors.white : const Color(0xFF1E40AF),
                      elevation: 0,
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 12 : 16,
                        vertical: isMobile ? 8 : 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ]
            : null,
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
            // Mobile-optimized tab bar
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: isMobile ? 8 : 16,
                vertical: isMobile ? 6 : 12,
              ),
              child: _PillTabBar(
                controller: _tabController,
                isMobile: isMobile,
                tabs: [
                  const Tab(text: 'Profile'),
                  const Tab(text: 'Branches'),
                  Tab(text: isMobile ? 'Bank' : 'Bank Details'),
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
                  _BranchesTab(
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
      elevation: 2,
      shadowColor: Colors.black12,
      borderRadius: BorderRadius.circular(isMobile ? 16 : 28),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(isMobile ? 16 : 28),
        child: Container(
          padding: EdgeInsets.all(isMobile ? 3 : 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(isMobile ? 16 : 28),
            border: Border.all(color: Colors.black12),
          ),
          child: TabBar(
            controller: controller,
            tabs: tabs,
            isScrollable: true, // Always scrollable for mobile
            indicator: ShapeDecoration(
              color: const Color(0xFF1E40AF), // Club blue
              shape: StadiumBorder(side: BorderSide.none),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.black87,
            labelStyle: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: isMobile ? 11 : 14,
            ),
            unselectedLabelStyle: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: isMobile ? 11 : 14,
            ),
            dividerColor: Colors.transparent,
            tabAlignment: TabAlignment.start,
            labelPadding: EdgeInsets.symmetric(
              horizontal: isMobile ? 12 : 16,
              vertical: isMobile ? 8 : 10,
            ),
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
  final bool isEditMode;
  const _ProfileTab({
    required this.isMobile,
    required this.isTablet,
    required this.isDesktop,
    this.isEditMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 8 : 16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(isMobile ? 10 : 18),
        ),
        child: Padding(
          padding: EdgeInsets.all(isMobile ? 10 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar and Name section - Always mobile layout
              Center(child: _AvatarBox(size: isMobile ? 70 : 100)),
              SizedBox(height: isMobile ? 12 : 20),
              _LabeledField(
                label: 'Name',
                child: Column(
                  children: [
                    _TextBox(hint: 'First Name', isEditMode: isEditMode),
                    const SizedBox(height: 10),
                    _TextBox(hint: 'Last Name', isEditMode: isEditMode),
                  ],
                ),
              ),

              SizedBox(height: isMobile ? 12 : 20),

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

              // Password field - Always mobile layout
              _LabeledField(
                label: 'Password',
                child: Column(
                  children: [
                    _TextBox(
                      hint: '************',
                      obscure: true,
                      enabled: isEditMode,
                      isEditMode: isEditMode,
                    ),
                    SizedBox(height: isMobile ? 10 : 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E40AF),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            vertical: isMobile ? 14 : 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Change Password',
                          style: TextStyle(
                            fontSize: isMobile ? 14 : 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: isMobile ? 12 : 16),

              // Address section - Always mobile layout
              _LabeledField(
                label: 'Address*(Permanent)',
                child: Column(
                  children: [
                    _TextBox(hint: 'Pincode', isEditMode: isEditMode),
                    const SizedBox(height: 10),
                    _DropdownBox(hint: 'City', isEditMode: isEditMode),
                    const SizedBox(height: 10),
                    _DropdownBox(hint: 'State', isEditMode: isEditMode),
                    const SizedBox(height: 10),
                    _DropdownBox(hint: 'Country', isEditMode: isEditMode),
                  ],
                ),
              ),
              SizedBox(height: isMobile ? 12 : 16),

              // Address lines
              _TextBox(hint: 'Address Line 1', isEditMode: isEditMode),
              SizedBox(height: isMobile ? 10 : 16),
              _TextBox(hint: 'Address Line 2', isEditMode: isEditMode),
              SizedBox(height: isMobile ? 10 : 16),
              _TextBox(hint: 'Address Line 3', isEditMode: isEditMode),
              SizedBox(height: isMobile ? 16 : 24),

              // Company Details Section
              _CompanyDetailsSection(
                isMobile: isMobile,
                isTablet: isTablet,
                isDesktop: isDesktop,
                isEditMode: isEditMode,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BranchesTab extends StatefulWidget {
  final bool isMobile;
  final bool isTablet;
  final bool isDesktop;
  final bool isEditMode;
  const _BranchesTab({
    required this.isMobile,
    required this.isTablet,
    required this.isDesktop,
    this.isEditMode = false,
  });

  @override
  State<_BranchesTab> createState() => _BranchesTabState();
}

class _BranchesTabState extends State<_BranchesTab> {
  final TextEditingController _numberOfBranchesController = TextEditingController(text: '2');
  bool _allSportsSame = false;
  
  // Store branch data
  final Map<int, _BranchData> _branches = {};

  @override
  void initState() {
    super.initState();
    _numberOfBranchesController.addListener(_updateBranches);
    _initializeBranches(2);
  }

  void _initializeBranches(int count) {
    for (int i = 1; i <= count; i++) {
      if (!_branches.containsKey(i)) {
        _branches[i] = _BranchData();
      }
    }
    // Remove extra branches if count decreased
    final keysToRemove = _branches.keys.where((key) => key > count).toList();
    for (final key in keysToRemove) {
      _branches[key]?.dispose();
      _branches.remove(key);
    }
  }

  void _updateBranches() {
    final count = int.tryParse(_numberOfBranchesController.text) ?? 0;
    if (count > 0 && count <= 20) {
      setState(() {
        _initializeBranches(count);
      });
    }
  }

  @override
  void dispose() {
    _numberOfBranchesController.dispose();
    for (final branch in _branches.values) {
      branch.dispose();
    }
    _branches.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final branchCount = int.tryParse(_numberOfBranchesController.text) ?? 0;
    final validBranchCount = branchCount > 0 && branchCount <= 20 ? branchCount : 0;

    return SingleChildScrollView(
      padding: EdgeInsets.all(widget.isMobile ? 8 : 16),
      child: Column(
        children: [
          // Number Of Branches Section
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(widget.isMobile ? 10 : 18),
            ),
            child: Padding(
              padding: EdgeInsets.all(widget.isMobile ? 10 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Number Of Branches',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: widget.isMobile ? 14 : 16,
                    ),
                  ),
                  SizedBox(height: widget.isMobile ? 8 : 12),
                  _TextBox(
                    hint: '2',
                    controller: _numberOfBranchesController,
                    keyboardType: TextInputType.number,
                    isEditMode: widget.isEditMode,
                  ),
                  if (branchCount > 1) ...[
                    SizedBox(height: widget.isMobile ? 6 : 8),
                    Text(
                      '(It Will Be Paid Service To Use This Platform For More Than 1 Branch)',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: widget.isMobile ? 11 : 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                  if (branchCount > 20 || branchCount < 1) ...[
                    SizedBox(height: widget.isMobile ? 6 : 8),
                    Text(
                      'Please enter a number between 1 and 20',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: widget.isMobile ? 11 : 12,
                      ),
                    ),
                  ],
                  SizedBox(height: widget.isMobile ? 16 : 20),
                  Row(
                    children: [
                      Checkbox(
                        value: _allSportsSame,
                        onChanged: widget.isEditMode
                            ? (value) {
                                setState(() {
                                  _allSportsSame = value ?? false;
                                });
                              }
                            : null,
                        activeColor: const Color(0xFF1E40AF),
                      ),
                      SizedBox(width: widget.isMobile ? 8 : 12),
                      Expanded(
                        child: Text(
                          'All Sports Are Same For Each Branch',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: widget.isMobile ? 13 : 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Branch Details
          if (validBranchCount > 0) ...[
            ...List.generate(validBranchCount, (index) {
              final branchNumber = index + 1;
              final branch = _branches[branchNumber];
              if (branch == null) return const SizedBox.shrink();
              return Padding(
                padding: EdgeInsets.only(top: widget.isMobile ? 10 : 16),
                child: _BranchDetailsCard(
                  branchNumber: branchNumber,
                  branch: branch,
                  isMobile: widget.isMobile,
                  allSportsSame: _allSportsSame,
                  isEditMode: widget.isEditMode,
                ),
              );
            }),
          ],
        ],
      ),
    );
  }
}

// Branch Data Model
class _BranchData {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usersController = TextEditingController(text: '1');
  final TextEditingController address1Controller = TextEditingController();
  final TextEditingController address2Controller = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController zipCodeController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController officeNumberController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController websiteController = TextEditingController();
  
  bool addressSameAsSignUp = true;
  bool contactSameAsSignUp = true;
  String officeCountryCode = '+91';
  String mobileCountryCode = '+91';
  
  // Operational Details
  final List<_TimeSlot> timeSlots = [];
  
  // Sports
  final Set<String> selectedSports = {};
  
  void dispose() {
    nameController.dispose();
    usersController.dispose();
    address1Controller.dispose();
    address2Controller.dispose();
    cityController.dispose();
    stateController.dispose();
    zipCodeController.dispose();
    countryController.dispose();
    officeNumberController.dispose();
    mobileNumberController.dispose();
    websiteController.dispose();
  }
}

class _TimeSlot {
  String openDays = 'Weekdays';
  TimeOfDay? startTime;
  TimeOfDay? endTime;
}

// Branch Details Card Widget
class _BranchDetailsCard extends StatefulWidget {
  final int branchNumber;
  final _BranchData branch;
  final bool isMobile;
  final bool allSportsSame;
  final bool isEditMode;
  
  const _BranchDetailsCard({
    required this.branchNumber,
    required this.branch,
    required this.isMobile,
    required this.allSportsSame,
    this.isEditMode = false,
  });

  @override
  State<_BranchDetailsCard> createState() => _BranchDetailsCardState();
}

class _BranchDetailsCardState extends State<_BranchDetailsCard> {
  final List<String> _availableSports = [
    'Tennis',
    'Baseball',
    'Cricket',
    'Basketball',
    'Football',
    'Soccer',
    'Volleyball',
    'Badminton',
  ];
  
  final List<String> _openDaysOptions = [
    'Weekdays',
    'Weekend',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
  
  final List<String> _countryCodes = ['+91', '+1', '+44', '+86'];

  @override
  void initState() {
    super.initState();
    // Initialize with default time slots
    if (widget.branch.timeSlots.isEmpty) {
      widget.branch.timeSlots.addAll([
        _TimeSlot()..openDays = 'Weekdays',
        _TimeSlot()..openDays = 'Weekend',
      ]);
    }
    // Initialize sports if all sports same is enabled
    if (widget.allSportsSame && widget.branchNumber == 1) {
      widget.branch.selectedSports.addAll(['Tennis', 'Baseball', 'Cricket', 'Basketball']);
    }
  }

  Future<void> _selectTime(BuildContext context, _TimeSlot slot, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime 
          ? (slot.startTime ?? const TimeOfDay(hour: 9, minute: 0))
          : (slot.endTime ?? const TimeOfDay(hour: 17, minute: 0)),
    );
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          slot.startTime = picked;
        } else {
          slot.endTime = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(widget.isMobile ? 10 : 18),
      ),
      child: Padding(
        padding: EdgeInsets.all(widget.isMobile ? 10 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Branch Header
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: widget.isMobile ? 12 : 16,
                vertical: widget.isMobile ? 8 : 10,
              ),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(widget.isMobile ? 8 : 12),
              ),
              child: Text(
                'Branch ${widget.branchNumber} Details',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: widget.isMobile ? 14 : 16,
                ),
              ),
            ),
            SizedBox(height: widget.isMobile ? 12 : 16),
            
            // Club Name
            _LabeledField(
              label: 'Club Name',
              child: _TextBox(
                hint: 'Xyz',
                controller: widget.branch.nameController,
                isEditMode: widget.isEditMode,
              ),
            ),
            SizedBox(height: widget.isMobile ? 12 : 16),
            
            // Number Of Users
            _LabeledField(
              label: 'Number Of Users',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _TextBox(
                    hint: '1',
                    controller: widget.branch.usersController,
                    keyboardType: TextInputType.number,
                    isEditMode: widget.isEditMode,
                  ),
                  ValueListenableBuilder<TextEditingValue>(
                    valueListenable: widget.branch.usersController,
                    builder: (context, value, child) {
                      final userCount = int.tryParse(value.text) ?? 0;
                      if (userCount > 1) {
                        return Padding(
                          padding: EdgeInsets.only(top: widget.isMobile ? 6 : 8),
                          child: Text(
                            '(It Is A Paid Service For More Than 1 User/Branch. You Will Be Allowed To Add Users From Your Admin Panel After Subscription.)',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: widget.isMobile ? 10 : 11,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: widget.isMobile ? 12 : 16),
            
            // Address Checkbox
            Row(
              children: [
                Checkbox(
                  value: widget.branch.addressSameAsSignUp,
                  onChanged: widget.isEditMode
                      ? (value) {
                          setState(() {
                            widget.branch.addressSameAsSignUp = value ?? false;
                          });
                        }
                      : null,
                  activeColor: const Color(0xFF1E40AF),
                ),
                SizedBox(width: widget.isMobile ? 8 : 12),
                Expanded(
                  child: Text(
                    'Address Is Same As Sign Up Address?',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: widget.isMobile ? 13 : 14,
                    ),
                  ),
                ),
              ],
            ),
            
            // Address Section
            if (!widget.branch.addressSameAsSignUp) ...[
              SizedBox(height: widget.isMobile ? 8 : 12),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: widget.isMobile ? 12 : 16,
                  vertical: widget.isMobile ? 8 : 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(widget.isMobile ? 8 : 12),
                ),
                child: Text(
                  'Address',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: widget.isMobile ? 13 : 14,
                  ),
                ),
              ),
              SizedBox(height: widget.isMobile ? 12 : 16),
              _TextBox(
                hint: 'Address 1',
                controller: widget.branch.address1Controller,
                isEditMode: widget.isEditMode,
              ),
              SizedBox(height: widget.isMobile ? 10 : 12),
              _TextBox(
                hint: 'Address 2',
                controller: widget.branch.address2Controller,
                isEditMode: widget.isEditMode,
              ),
              SizedBox(height: widget.isMobile ? 10 : 12),
              Row(
                children: [
                  Expanded(
                    child: _DropdownBox(
                      hint: 'City',
                      controller: widget.branch.cityController,
                      isEditMode: widget.isEditMode,
                    ),
                  ),
                  SizedBox(width: widget.isMobile ? 8 : 12),
                  Expanded(
                    child: _DropdownBox(
                      hint: 'State',
                      controller: widget.branch.stateController,
                      isEditMode: widget.isEditMode,
                    ),
                  ),
                ],
              ),
              SizedBox(height: widget.isMobile ? 10 : 12),
              Row(
                children: [
                  Expanded(
                    child: _TextBox(
                      hint: 'Zip Code',
                      controller: widget.branch.zipCodeController,
                      isEditMode: widget.isEditMode,
                    ),
                  ),
                  SizedBox(width: widget.isMobile ? 8 : 12),
                  Expanded(
                    child: _DropdownBox(
                      hint: 'Country',
                      controller: widget.branch.countryController,
                      isEditMode: widget.isEditMode,
                    ),
                  ),
                ],
              ),
              SizedBox(height: widget.isMobile ? 12 : 16),
            ],
            
            // Contact Details Checkbox
            Row(
              children: [
                Checkbox(
                  value: widget.branch.contactSameAsSignUp,
                  onChanged: widget.isEditMode
                      ? (value) {
                          setState(() {
                            widget.branch.contactSameAsSignUp = value ?? false;
                          });
                        }
                      : null,
                  activeColor: const Color(0xFF1E40AF),
                ),
                SizedBox(width: widget.isMobile ? 8 : 12),
                Expanded(
                  child: Text(
                    'Contact Details Is Same As Sign Up Contact Details?',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: widget.isMobile ? 13 : 14,
                    ),
                  ),
                ),
              ],
            ),
            
            // Contact Details Section
            if (!widget.branch.contactSameAsSignUp) ...[
              SizedBox(height: widget.isMobile ? 8 : 12),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: widget.isMobile ? 12 : 16,
                  vertical: widget.isMobile ? 8 : 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(widget.isMobile ? 8 : 12),
                ),
                child: Text(
                  'Contact Details',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: widget.isMobile ? 13 : 14,
                  ),
                ),
              ),
              SizedBox(height: widget.isMobile ? 12 : 16),
              // Office Number
              _LabeledField(
                label: 'Office Number',
                child: Row(
                  children: [
                    SizedBox(
                      width: widget.isMobile ? 80 : 100,
                      child: _CountryCodeDropdown(
                        value: widget.branch.officeCountryCode,
                        items: _countryCodes,
                        onChanged: widget.isEditMode
                            ? (value) {
                                if (value != null) {
                                  setState(() {
                                    widget.branch.officeCountryCode = value;
                                  });
                                }
                              }
                            : null,
                      ),
                    ),
                    SizedBox(width: widget.isMobile ? 8 : 12),
                    Expanded(
                      child: _TextBox(
                        hint: '9876543210',
                        controller: widget.branch.officeNumberController,
                        keyboardType: TextInputType.phone,
                        isEditMode: widget.isEditMode,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: widget.isMobile ? 12 : 16),
              // Mobile Number
              _LabeledField(
                label: 'Mobile Number',
                child: Row(
                  children: [
                    SizedBox(
                      width: widget.isMobile ? 80 : 100,
                      child: _CountryCodeDropdown(
                        value: widget.branch.mobileCountryCode,
                        items: _countryCodes,
                        onChanged: widget.isEditMode
                            ? (value) {
                                if (value != null) {
                                  setState(() {
                                    widget.branch.mobileCountryCode = value;
                                  });
                                }
                              }
                            : null,
                      ),
                    ),
                    SizedBox(width: widget.isMobile ? 8 : 12),
                    Expanded(
                      child: _TextBox(
                        hint: '9876543210',
                        controller: widget.branch.mobileNumberController,
                        keyboardType: TextInputType.phone,
                        isEditMode: widget.isEditMode,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: widget.isMobile ? 12 : 16),
              // Company Website
              _LabeledField(
                label: 'Company Website',
                child: _TextBox(
                  hint: 'https://abc.com',
                  controller: widget.branch.websiteController,
                  keyboardType: TextInputType.url,
                  isEditMode: widget.isEditMode,
                ),
              ),
              SizedBox(height: widget.isMobile ? 12 : 16),
            ],
            
            // Club Operational Details
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: widget.isMobile ? 12 : 16,
                vertical: widget.isMobile ? 8 : 10,
              ),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(widget.isMobile ? 8 : 12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Club Operational Details',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: widget.isMobile ? 13 : 14,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        widget.branch.timeSlots.add(_TimeSlot());
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[900],
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: widget.isMobile ? 12 : 16,
                        vertical: widget.isMobile ? 6 : 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      '+ Days & Time',
                      style: TextStyle(fontSize: widget.isMobile ? 11 : 12),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: widget.isMobile ? 12 : 16),
            
            // Time Slots
            ...widget.branch.timeSlots.asMap().entries.map((entry) {
              final index = entry.key;
              final slot = entry.value;
              return Padding(
                padding: EdgeInsets.only(bottom: widget.isMobile ? 12 : 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: widget.isMobile ? 10 : 12,
                        vertical: widget.isMobile ? 4 : 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[700],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Time ${index + 1}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: widget.isMobile ? 11 : 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: widget.isMobile ? 10 : 12),
                    Row(
                      children: [
                        Expanded(
                          child: _LabeledField(
                            label: 'Open Days',
                            child: _DropdownBox(
                              hint: slot.openDays,
                              onChanged: (value) {
                                setState(() {
                                  slot.openDays = value ?? 'Weekdays';
                                });
                              },
                              items: _openDaysOptions,
                            ),
                          ),
                        ),
                        SizedBox(width: widget.isMobile ? 8 : 12),
                        Expanded(
                          child: _LabeledField(
                            label: 'Club Time',
                            child: Row(
                              children: [
                                Expanded(
                                  child: _TimeField(
                                    value: slot.startTime,
                                    onTap: () => _selectTime(context, slot, true),
                                  ),
                                ),
                                SizedBox(width: widget.isMobile ? 6 : 8),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      widget.branch.timeSlots.add(_TimeSlot());
                                    });
                                  },
                                  child: Container(
                                    width: widget.isMobile ? 28 : 32,
                                    height: widget.isMobile ? 28 : 32,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF1E40AF),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.add,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ),
                                ),
                                SizedBox(width: widget.isMobile ? 6 : 8),
                                Expanded(
                                  child: _TimeField(
                                    value: slot.endTime,
                                    onTap: () => _selectTime(context, slot, false),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
            
            SizedBox(height: widget.isMobile ? 12 : 16),
            
            // Sports Section
            Text(
              'Sports',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: widget.isMobile ? 14 : 16,
              ),
            ),
            SizedBox(height: widget.isMobile ? 8 : 12),
            Wrap(
              spacing: widget.isMobile ? 8 : 12,
              runSpacing: widget.isMobile ? 8 : 12,
              children: _availableSports.map((sport) {
                final isSelected = widget.branch.selectedSports.contains(sport);
                return FilterChip(
                  label: Text(sport),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        widget.branch.selectedSports.add(sport);
                      } else {
                        widget.branch.selectedSports.remove(sport);
                      }
                    });
                  },
                  selectedColor: Colors.blue[100],
                  checkmarkColor: Colors.blue[900],
                  deleteIcon: isSelected
                      ? const Icon(Icons.close, size: 16, color: Colors.red)
                      : null,
                  onDeleted: isSelected
                      ? () {
                          setState(() {
                            widget.branch.selectedSports.remove(sport);
                          });
                        }
                      : null,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

// Time Field Widget
class _TimeField extends StatelessWidget {
  final TimeOfDay? value;
  final VoidCallback onTap;
  
  const _TimeField({
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFDFE3E8)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              value != null
                  ? '${value!.hour.toString().padLeft(2, '0')}:${value!.minute.toString().padLeft(2, '0')}'
                  : '00:00',
              style: TextStyle(
                color: value != null ? Colors.black87 : Colors.grey[600],
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            Icon(Icons.access_time, color: Colors.grey[600], size: 18),
          ],
        ),
      ),
    );
  }
}

class _BankDetailsTab extends StatefulWidget {
  final bool isMobile;
  final bool isTablet;
  final bool isDesktop;
  final bool isEditMode;
  const _BankDetailsTab({
    required this.isMobile,
    required this.isTablet,
    required this.isDesktop,
    this.isEditMode = false,
  });

  @override
  State<_BankDetailsTab> createState() => _BankDetailsTabState();
}

class _BankDetailsTabState extends State<_BankDetailsTab> {
  // Financials state
  String _revenueFilter = 'Flexible Duration';
  String _expensesFilter = 'Flexible Duration';
  DateTime? _revenueStartDate;
  DateTime? _revenueEndDate;
  DateTime? _expensesStartDate;
  DateTime? _expensesEndDate;

  Future<void> _selectDate(BuildContext context, bool isRevenue, bool isStart) async {
    final date = await showDatePicker(
      context: context,
      initialDate: isRevenue
          ? (isStart ? (_revenueStartDate ?? DateTime.now()) : (_revenueEndDate ?? DateTime.now()))
          : (isStart ? (_expensesStartDate ?? DateTime.now()) : (_expensesEndDate ?? DateTime.now())),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      setState(() {
        if (isRevenue) {
          if (isStart) {
            _revenueStartDate = date;
          } else {
            _revenueEndDate = date;
          }
        } else {
          if (isStart) {
            _expensesStartDate = date;
          } else {
            _expensesEndDate = date;
          }
        }
      });
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    final months = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'];
    return '${months[date.month - 1]}-${date.day.toString().padLeft(2, '0')}-${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(widget.isMobile ? 8 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bank Details Card
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(widget.isMobile ? 10 : 18),
            ),
            child: Padding(
              padding: EdgeInsets.all(widget.isMobile ? 10 : 16),
              child: widget.isDesktop
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _BankLeft(
                            isMobile: widget.isMobile,
                            isEditMode: widget.isEditMode,
                          ),
                        ),
                        SizedBox(width: widget.isMobile ? 12 : 24),
                        Expanded(
                          child: _BankRight(
                            isMobile: widget.isMobile,
                            isEditMode: widget.isEditMode,
                          ),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _BankLeft(
                          isMobile: widget.isMobile,
                          isEditMode: widget.isEditMode,
                        ),
                        SizedBox(height: widget.isMobile ? 12 : 20),
                        _BankRight(
                          isMobile: widget.isMobile,
                          isEditMode: widget.isEditMode,
                        ),
                      ],
                    ),
            ),
          ),
          SizedBox(height: widget.isMobile ? 12 : 20),
          // Financials Section
          _FinancialsSection(
            isMobile: widget.isMobile,
            revenueFilter: _revenueFilter,
            expensesFilter: _expensesFilter,
            revenueStartDate: _revenueStartDate,
            revenueEndDate: _revenueEndDate,
            expensesStartDate: _expensesStartDate,
            expensesEndDate: _expensesEndDate,
            onRevenueFilterChanged: (value) => setState(() => _revenueFilter = value),
            onExpensesFilterChanged: (value) => setState(() => _expensesFilter = value),
            onSelectDate: _selectDate,
            formatDate: _formatDate,
          ),
        ],
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
      padding: EdgeInsets.all(isMobile ? 8 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SubscriptionLeftCard(isMobile: isMobile),
          SizedBox(height: isMobile ? 10 : 16),
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
  final bool isEditMode;
  const _BankLeft({
    required this.isMobile,
    this.isEditMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _LabeledField(
          label: 'Account Name',
          child: _TextBox(hint: 'Bank Account Name', isEditMode: isEditMode),
        ),
        SizedBox(height: isMobile ? 12 : 16),
        _LabeledField(
          label: 'Bank Name',
          child: _TextBox(hint: 'Bank Name', isEditMode: isEditMode),
        ),
        SizedBox(height: isMobile ? 12 : 16),
        _LabeledField(
          label: 'Branch Name',
          child: _TextBox(hint: 'Branch Name', isEditMode: isEditMode),
        ),
        SizedBox(height: isMobile ? 12 : 16),
        _LabeledField(
          label: 'Account Type',
          child: _TextBox(hint: 'Saving', isEditMode: isEditMode),
        ),
        SizedBox(height: isMobile ? 12 : 16),
        _LabeledField(
          label: 'Account Number',
          child: _TextBox(hint: '123456789000000', isEditMode: isEditMode),
        ),
        SizedBox(height: isMobile ? 12 : 16),
        _LabeledField(
          label: 'Swift Code',
          child: _TextBox(hint: '1234567', isEditMode: isEditMode),
        ),
        SizedBox(height: isMobile ? 12 : 16),
        _LabeledField(
          label: 'IFSC Code',
          child: _TextBox(hint: '1234567', isEditMode: isEditMode),
        ),
        SizedBox(height: isMobile ? 12 : 16),
        _LabeledField(
          label: 'Stripe ID',
          child: _TextBox(hint: '1234567', isEditMode: isEditMode),
        ),
        SizedBox(height: isMobile ? 12 : 16),
        _LabeledField(
          label: 'Stripe Secret Key',
          child: _TextBox(hint: 'XXXXXXXX', obscure: true, isEditMode: isEditMode),
        ),
      ],
    );
  }
}

class _BankRight extends StatelessWidget {
  final bool isMobile;
  final bool isEditMode;
  const _BankRight({
    required this.isMobile,
    this.isEditMode = false,
  });

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
                        backgroundColor: const Color(0xFF1E40AF),
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
        _LabeledField(
          label: 'Paypal ID',
          child: _TextBox(hint: 'Artist1234@Gmail.Com', isEditMode: isEditMode),
        ),
        SizedBox(height: isMobile ? 12 : 16),
        _LabeledField(
          label: 'Paypal URL',
          child: _TextBox(hint: '1234567', isEditMode: isEditMode),
        ),
        SizedBox(height: isMobile ? 12 : 16),
        _LabeledField(
          label: 'Zelle ID',
          child: _TextBox(hint: 'XXXXXXXXXXX', obscure: true, isEditMode: isEditMode),
        ),
      ],
    );
  }
}

// Financials Section Widget
class _FinancialsSection extends StatelessWidget {
  final bool isMobile;
  final String revenueFilter;
  final String expensesFilter;
  final DateTime? revenueStartDate;
  final DateTime? revenueEndDate;
  final DateTime? expensesStartDate;
  final DateTime? expensesEndDate;
  final Function(String) onRevenueFilterChanged;
  final Function(String) onExpensesFilterChanged;
  final Function(BuildContext, bool, bool) onSelectDate;
  final String Function(DateTime?) formatDate;

  const _FinancialsSection({
    required this.isMobile,
    required this.revenueFilter,
    required this.expensesFilter,
    required this.revenueStartDate,
    required this.revenueEndDate,
    required this.expensesStartDate,
    required this.expensesEndDate,
    required this.onRevenueFilterChanged,
    required this.onExpensesFilterChanged,
    required this.onSelectDate,
    required this.formatDate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Financials Header
        Center(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 24 : 32,
              vertical: isMobile ? 10 : 12,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF1E40AF),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              'Financials',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: isMobile ? 14 : 16,
              ),
            ),
          ),
        ),
        SizedBox(height: isMobile ? 16 : 24),
        // Revenue Earned Section
        _RevenueExpensesSection(
          title: 'REVENUE EARNED',
          isMobile: isMobile,
          filter: revenueFilter,
          startDate: revenueStartDate,
          endDate: revenueEndDate,
          onFilterChanged: onRevenueFilterChanged,
          onSelectDate: (isStart) => onSelectDate(context, true, isStart),
          formatDate: formatDate,
          cards: [
            _FinancialCard(
              title: 'TOTAL REVENUES',
              amount: 'USD 50,000',
              color: const Color(0xFF1E40AF),
              isMobile: isMobile,
            ),
            _FinancialCard(
              title: 'PAYMENT RELEASED BY SEKAI-ICHI',
              amount: 'USD 30,000',
              color: Colors.green,
              isMobile: isMobile,
            ),
            _FinancialCard(
              title: 'PAYMENT PENDING',
              amount: 'USD 20,000',
              color: Colors.red,
              isMobile: isMobile,
            ),
          ],
        ),
        SizedBox(height: isMobile ? 20 : 32),
        // Subscription Expenses Section
        _RevenueExpensesSection(
          title: 'SUBSCRIPTION EXPENSES',
          isMobile: isMobile,
          filter: expensesFilter,
          startDate: expensesStartDate,
          endDate: expensesEndDate,
          onFilterChanged: onExpensesFilterChanged,
          onSelectDate: (isStart) => onSelectDate(context, false, isStart),
          formatDate: formatDate,
          cards: [
            _FinancialCard(
              title: 'TOTAL EXPENSES',
              amount: 'USD 30,000',
              color: const Color(0xFF1E40AF),
              isMobile: isMobile,
            ),
            _FinancialCard(
              title: 'PAYMENT RELEASED TO SEKAI-ICHI',
              amount: 'USD 30,000',
              color: Colors.green,
              isMobile: isMobile,
            ),
            _FinancialCard(
              title: 'PAYMENT PENDING',
              amount: 'USD 0',
              color: Colors.red,
              isMobile: isMobile,
            ),
          ],
        ),
      ],
    );
  }
}

// Revenue/Expenses Section Widget
class _RevenueExpensesSection extends StatelessWidget {
  final String title;
  final bool isMobile;
  final String filter;
  final DateTime? startDate;
  final DateTime? endDate;
  final Function(String) onFilterChanged;
  final Function(bool) onSelectDate;
  final String Function(DateTime?) formatDate;
  final List<Widget> cards;

  const _RevenueExpensesSection({
    required this.title,
    required this.isMobile,
    required this.filter,
    required this.startDate,
    required this.endDate,
    required this.onFilterChanged,
    required this.onSelectDate,
    required this.formatDate,
    required this.cards,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: isMobile ? 16 : 18,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: isMobile ? 10 : 16),
        // Filter Tabs - Scrollable on mobile
        isMobile
            ? SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ['All', 'Financial Year', 'Flexible Duration'].map((tab) {
                    final isSelected = filter == tab;
                    return Padding(
                      padding: EdgeInsets.only(right: isMobile ? 8 : 12),
                      child: GestureDetector(
                        onTap: () => onFilterChanged(tab),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: isMobile ? 14 : 20,
                            vertical: isMobile ? 8 : 10,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.grey[800] : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected ? Colors.grey[800]! : Colors.grey[300]!,
                            ),
                          ),
                          child: Text(
                            tab,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black87,
                              fontWeight: FontWeight.w600,
                              fontSize: isMobile ? 11 : 14,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              )
            : Wrap(
                spacing: isMobile ? 8 : 12,
                runSpacing: isMobile ? 8 : 12,
                children: ['All', 'Financial Year', 'Flexible Duration'].map((tab) {
                  final isSelected = filter == tab;
                  return GestureDetector(
                    onTap: () => onFilterChanged(tab),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 16 : 20,
                        vertical: isMobile ? 8 : 10,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.grey[800] : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? Colors.grey[800]! : Colors.grey[300]!,
                        ),
                      ),
                      child: Text(
                        tab,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.w600,
                          fontSize: isMobile ? 12 : 14,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
        SizedBox(height: isMobile ? 12 : 16),
        // Date Range
        Row(
          children: [
            Expanded(
              child: _DateField(
                label: 'Start Date',
                value: startDate,
                formatDate: formatDate,
                onTap: () => onSelectDate(true),
                isMobile: isMobile,
              ),
            ),
            SizedBox(width: isMobile ? 8 : 12),
            Expanded(
              child: _DateField(
                label: 'End Date',
                value: endDate,
                formatDate: formatDate,
                onTap: () => onSelectDate(false),
                isMobile: isMobile,
              ),
            ),
          ],
        ),
        SizedBox(height: isMobile ? 16 : 20),
        // Summary Cards - Horizontal layout with scroll on mobile
        isMobile
            ? SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: cards.map((card) {
                    return Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      margin: EdgeInsets.only(right: 12),
                      child: card,
                    );
                  }).toList(),
                ),
              )
            : Row(
                children: cards.map((card) => Expanded(child: card)).toList(),
              ),
      ],
    );
  }
}

// Date Field Widget
class _DateField extends StatelessWidget {
  final String label;
  final DateTime? value;
  final String Function(DateTime?) formatDate;
  final VoidCallback onTap;
  final bool isMobile;

  const _DateField({
    required this.label,
    required this.value,
    required this.formatDate,
    required this.onTap,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 12 : 16,
          vertical: isMobile ? 14 : 16,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFDFE3E8)),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today, color: Colors.grey[600], size: isMobile ? 16 : 18),
            SizedBox(width: isMobile ? 8 : 12),
            Expanded(
              child: Text(
                value != null ? formatDate(value) : label,
                style: TextStyle(
                  color: value != null ? Colors.black87 : Colors.grey[600],
                  fontSize: isMobile ? 13 : 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Financial Card Widget
class _FinancialCard extends StatelessWidget {
  final String title;
  final String amount;
  final Color color;
  final bool isMobile;

  const _FinancialCard({
    required this.title,
    required this.amount,
    required this.color,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: isMobile ? 6 : 8,
            offset: Offset(0, isMobile ? 2 : 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: isMobile ? 11 : 12,
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: isMobile ? 8 : 12),
          Text(
            amount,
            style: TextStyle(
              color: Colors.white,
              fontSize: isMobile ? 20 : 24,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
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
    final isMobile = MediaQuery.of(context).size.width < 1024;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: isMobile ? 13 : 14,
          ),
        ),
        SizedBox(height: isMobile ? 6 : 8),
        child,
      ],
    );
  }
}

class _TextBox extends StatelessWidget {
  final String hint;
  final bool enabled;
  final bool obscure;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool? isEditMode;
  const _TextBox({
    required this.hint,
    this.enabled = true,
    this.obscure = false,
    this.controller,
    this.keyboardType,
    this.isEditMode,
  });
  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 1024;
    final effectiveEnabled = isEditMode != null ? (enabled && isEditMode!) : enabled;
    return TextField(
      controller: controller,
      enabled: effectiveEnabled,
      obscureText: obscure,
      keyboardType: keyboardType,
      style: TextStyle(fontSize: isMobile ? 14 : 16),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(fontSize: isMobile ? 14 : 16),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(
          horizontal: isMobile ? 14 : 16,
          vertical: isMobile ? 16 : 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(isMobile ? 12 : 14),
          borderSide: const BorderSide(color: Color(0xFFDFE3E8)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(isMobile ? 12 : 14),
          borderSide: const BorderSide(color: Color(0xFFDFE3E8)),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(isMobile ? 12 : 14),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
      ),
    );
  }
}

class _DropdownBox extends StatelessWidget {
  final String hint;
  final TextEditingController? controller;
  final Function(String?)? onChanged;
  final List<String>? items;
  final bool? isEditMode;
  const _DropdownBox({
    required this.hint,
    this.controller,
    this.onChanged,
    this.items,
    this.isEditMode,
  });
  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 1024;
    final effectiveEnabled = isEditMode != null ? isEditMode! : true;
    
    if (items != null && onChanged != null && effectiveEnabled) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(isMobile ? 12 : 14),
          border: Border.all(color: const Color(0xFFDFE3E8)),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 14 : 16,
          vertical: isMobile ? 16 : 18,
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: (controller != null && controller!.text.isNotEmpty) ? controller!.text : null,
            hint: Text(
              hint,
              style: const TextStyle(color: Colors.black54),
            ),
            isExpanded: true,
            items: items!.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: effectiveEnabled
                ? (value) {
                    if (controller != null && value != null) {
                      controller!.text = value;
                    }
                    if (onChanged != null) {
                      onChanged!(value);
                    }
                  }
                : null,
            icon: const Icon(Icons.arrow_drop_down),
          ),
        ),
      );
    }
    return InputDecorator(
      decoration: InputDecoration(
        filled: true,
        fillColor: effectiveEnabled ? Colors.white : Colors.grey[100],
        contentPadding: EdgeInsets.symmetric(
          horizontal: isMobile ? 14 : 16,
          vertical: isMobile ? 16 : 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(isMobile ? 12 : 14),
          borderSide: const BorderSide(color: Color(0xFFDFE3E8)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(isMobile ? 12 : 14),
          borderSide: const BorderSide(color: Color(0xFFDFE3E8)),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(isMobile ? 12 : 14),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              (controller != null && controller!.text.isNotEmpty) ? controller!.text : hint,
              style: TextStyle(
                color: effectiveEnabled
                    ? ((controller != null && controller!.text.isNotEmpty) ? Colors.black87 : Colors.black54)
                    : Colors.grey[600],
              ),
            ),
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

class _CompanyDetailsSection extends StatefulWidget {
  final bool isMobile;
  final bool isTablet;
  final bool isDesktop;
  final bool isEditMode;
  const _CompanyDetailsSection({
    required this.isMobile,
    required this.isTablet,
    required this.isDesktop,
    this.isEditMode = false,
  });

  @override
  State<_CompanyDetailsSection> createState() => _CompanyDetailsSectionState();
}

class _CompanyDetailsSectionState extends State<_CompanyDetailsSection> {
  final _companyNameController = TextEditingController(text: 'Company Name');
  final _designationController = TextEditingController(text: 'Director');
  final _departmentController = TextEditingController(text: 'Administration');
  final _telephoneController = TextEditingController(text: '12-3456-7890');
  final _faxController = TextEditingController(text: '12-3456-7890');
  final _mobileController = TextEditingController(text: '12-3456-7890');
  final _websiteController = TextEditingController(text: 'www.xyzcompany.com');
  
  String _telephoneCountryCode = 'INDIA (+91)';
  String _faxCountryCode = 'INDIA (+91)';
  String _mobileCountryCode = 'INDIA (+91)';

  final List<String> _countryCodes = [
    'INDIA (+91)',
    'USA (+1)',
    'UK (+44)',
    'CHINA (+86)',
  ];

  @override
  void dispose() {
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Company Details Header
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: widget.isMobile ? 10 : 16,
            vertical: widget.isMobile ? 10 : 12,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF1E40AF),
            borderRadius: BorderRadius.circular(widget.isMobile ? 10 : 12),
          ),
          child: Text(
            'Company Details',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: widget.isMobile ? 14 : 16,
            ),
          ),
        ),
        SizedBox(height: widget.isMobile ? 12 : 20),

        // Company Name
        _LabeledField(
          label: 'Company Name',
          child: _TextBox(
            hint: 'Company Name',
            controller: _companyNameController,
            isEditMode: widget.isEditMode,
          ),
        ),
        SizedBox(height: widget.isMobile ? 12 : 16),

        // Designation
        _LabeledField(
          label: 'Designation',
          child: _TextBox(
            hint: 'Director',
            controller: _designationController,
            isEditMode: widget.isEditMode,
          ),
        ),
        SizedBox(height: widget.isMobile ? 12 : 16),

        // Department
        _LabeledField(
          label: 'Department',
          child: _TextBox(
            hint: 'Administration',
            controller: _departmentController,
            isEditMode: widget.isEditMode,
          ),
        ),
        SizedBox(height: widget.isMobile ? 12 : 16),

        // Telephone - Always mobile layout
        _LabeledField(
          label: 'Telephone',
          child: Column(
            children: [
              _CountryCodeDropdown(
                value: _telephoneCountryCode,
                items: _countryCodes,
                onChanged: widget.isEditMode
                    ? (value) {
                        if (value != null) {
                          setState(() {
                            _telephoneCountryCode = value;
                          });
                        }
                      }
                    : null,
              ),
              SizedBox(height: widget.isMobile ? 10 : 12),
              _TextBox(
                hint: '12-3456-7890',
                controller: _telephoneController,
                keyboardType: TextInputType.phone,
                isEditMode: widget.isEditMode,
              ),
            ],
          ),
        ),
        SizedBox(height: widget.isMobile ? 12 : 16),

        // Fax - Always mobile layout
        _LabeledField(
          label: 'Fax',
          child: Column(
            children: [
              _CountryCodeDropdown(
                value: _faxCountryCode,
                items: _countryCodes,
                onChanged: widget.isEditMode
                    ? (value) {
                        if (value != null) {
                          setState(() {
                            _faxCountryCode = value;
                          });
                        }
                      }
                    : null,
              ),
              SizedBox(height: widget.isMobile ? 10 : 12),
              _TextBox(
                hint: '12-3456-7890',
                controller: _faxController,
                keyboardType: TextInputType.phone,
                isEditMode: widget.isEditMode,
              ),
            ],
          ),
        ),
        SizedBox(height: widget.isMobile ? 12 : 16),

        // Mobile Number - Always mobile layout
        _LabeledField(
          label: 'Mobile Number',
          child: Column(
            children: [
              _CountryCodeDropdown(
                value: _mobileCountryCode,
                items: _countryCodes,
                onChanged: widget.isEditMode
                    ? (value) {
                        if (value != null) {
                          setState(() {
                            _mobileCountryCode = value;
                          });
                        }
                      }
                    : null,
              ),
              SizedBox(height: widget.isMobile ? 10 : 12),
              _TextBox(
                hint: '12-3456-7890',
                controller: _mobileController,
                keyboardType: TextInputType.phone,
                isEditMode: widget.isEditMode,
              ),
            ],
          ),
        ),
        SizedBox(height: widget.isMobile ? 12 : 16),

        // Website
        _LabeledField(
          label: 'Website',
          child: _TextBox(
            hint: 'www.xyzcompany.com',
            controller: _websiteController,
            keyboardType: TextInputType.url,
            isEditMode: widget.isEditMode,
          ),
        ),
      ],
    );
  }
}

class _CountryCodeDropdown extends StatelessWidget {
  final String value;
  final List<String> items;
  final Function(String?)? onChanged;
  const _CountryCodeDropdown({
    required this.value,
    required this.items,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFDFE3E8)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          isDense: true,
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onChanged: onChanged != null ? (value) => onChanged!(value) : null,
          icon: const Icon(Icons.arrow_drop_down, color: Colors.black54, size: 20),
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
