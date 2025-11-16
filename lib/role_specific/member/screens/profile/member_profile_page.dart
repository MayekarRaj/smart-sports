import 'package:flutter/material.dart';
import 'package:smart_sports/shared/widgets/role_sidebar.dart';
import 'package:smart_sports/role_specific/common/role_router.dart';
import 'package:smart_sports/shared/navigation/role_navigation_manager.dart';
import 'package:smart_sports/auth/screens/auth_shell.dart';

class MemberProfilePage extends StatefulWidget {
  const MemberProfilePage({super.key});

  @override
  State<MemberProfilePage> createState() => _MemberProfilePageState();
}

class _MemberProfilePageState extends State<MemberProfilePage>
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
    // Show edit button for Profile (0), Members (1), and Bank Details (2) tabs
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
              colors: [Color(0xFF1E40AF), Color(0xFF3B82F6)],
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
            role: UserRole.member,
            selectedIndex: -1, // Profile is accessed via onProfileTap
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
                  const Tab(text: 'Members'),
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
                  _MembersTab(
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
              color: Color(0xFF1E40AF),
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
          child: _TextBox(hint: 'Member', enabled: false),
        ),
        SizedBox(height: isMobile ? 12 : 16),
        _LabeledField(
          label: 'Login Email',
          child: _TextBox(hint: 'member@example.com', enabled: isEditMode),
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
                          backgroundColor: const Color(0xFF1E40AF),
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
                        backgroundColor: const Color(0xFF1E40AF),
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
                    _TextBox(hint: 'City', enabled: isEditMode),
                    const SizedBox(height: 12),
                    _DropdownBox(hint: 'State', enabled: isEditMode),
                    const SizedBox(height: 12),
                    _TextBox(hint: 'Zip Code', enabled: isEditMode),
                    const SizedBox(height: 12),
                    _DropdownBox(hint: 'Country', enabled: isEditMode),
                  ],
                )
              : Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    SizedBox(width: 200, child: _TextBox(hint: 'Address Line 1', enabled: isEditMode)),
                    SizedBox(width: 200, child: _TextBox(hint: 'Address Line 2', enabled: isEditMode)),
                    SizedBox(width: 150, child: _TextBox(hint: 'City', enabled: isEditMode)),
                    SizedBox(width: 150, child: _DropdownBox(hint: 'State', enabled: isEditMode)),
                    SizedBox(width: 120, child: _TextBox(hint: 'Zip Code', enabled: isEditMode)),
                    SizedBox(width: 150, child: _DropdownBox(hint: 'Country', enabled: isEditMode)),
                  ],
                ),
        ),
        SizedBox(height: isMobile ? 12 : 16),
        _LabeledField(
          label: 'Phone Number',
          child: isMobile
              ? Column(
                  children: [
                    _DropdownBox(hint: 'Country Code', enabled: isEditMode),
                    const SizedBox(height: 12),
                    _TextBox(hint: 'Phone Number', enabled: isEditMode, keyboardType: TextInputType.phone),
                  ],
                )
              : Row(
                  children: [
                    SizedBox(width: 120, child: _DropdownBox(hint: 'Country Code', enabled: isEditMode)),
                    const SizedBox(width: 12),
                    Expanded(child: _TextBox(hint: 'Phone Number', enabled: isEditMode, keyboardType: TextInputType.phone)),
                  ],
                ),
        ),
      ],
    );
  }
}

// Members Tab
class _MembersTab extends StatefulWidget {
  final bool isMobile;
  final bool isTablet;
  final bool isDesktop;
  final bool isEditMode;
  const _MembersTab({
    required this.isMobile,
    required this.isTablet,
    required this.isDesktop,
    required this.isEditMode,
  });

  @override
  State<_MembersTab> createState() => _MembersTabState();
}

class _MembersTabState extends State<_MembersTab> {
  final TextEditingController _numberOfMembersController = TextEditingController(text: '2');
  final Map<int, _MemberData> _members = {};

  @override
  void initState() {
    super.initState();
    _numberOfMembersController.addListener(_updateMembers);
    _initializeMembers(2);
  }

  void _initializeMembers(int count) {
    for (int i = 1; i <= count; i++) {
      if (!_members.containsKey(i)) {
        _members[i] = _MemberData();
      }
    }
    // Remove extra members if count decreased
    final keysToRemove = _members.keys.where((key) => key > count).toList();
    for (final key in keysToRemove) {
      _members[key]?.dispose();
      _members.remove(key);
    }
  }

  void _updateMembers() {
    final count = int.tryParse(_numberOfMembersController.text) ?? 0;
    if (count > 0 && count <= 10) {
      setState(() {
        _initializeMembers(count);
      });
    }
  }

  @override
  void dispose() {
    _numberOfMembersController.dispose();
    for (final member in _members.values) {
      member.dispose();
    }
    _members.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final memberCount = int.tryParse(_numberOfMembersController.text) ?? 0;
    final validMemberCount = memberCount > 0 && memberCount <= 10 ? memberCount : 0;

    return SingleChildScrollView(
      padding: EdgeInsets.all(widget.isMobile ? 12 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Number of Family Members Section
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(widget.isMobile ? 12 : 18),
            ),
            child: Padding(
              padding: EdgeInsets.all(widget.isMobile ? 12 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _LabeledField(
                    label: 'Number Of Family Members',
                    child: _TextBox(
                      hint: '2',
                      controller: _numberOfMembersController,
                      keyboardType: TextInputType.number,
                      enabled: widget.isEditMode,
                    ),
                  ),
                  if (memberCount > 10 || memberCount < 1) ...[
                    SizedBox(height: widget.isMobile ? 8 : 12),
                    Text(
                      'Please enter a number between 1 and 10',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: widget.isMobile ? 11 : 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          // Member Details
          if (validMemberCount > 0) ...[
            ...List.generate(validMemberCount, (index) {
              final memberNumber = index + 1;
              final member = _members[memberNumber];
              if (member == null) return const SizedBox.shrink();
              return Padding(
                padding: EdgeInsets.only(top: widget.isMobile ? 12 : 16),
                child: _MemberDetailsCard(
                  memberNumber: memberNumber,
                  member: member,
                  isMobile: widget.isMobile,
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

// Member Data Model
class _MemberData {
  final TextEditingController firstNameController = TextEditingController(text: 'Peter');
  final TextEditingController lastNameController = TextEditingController(text: 'Stillman');
  final TextEditingController emailController = TextEditingController(text: 'Peter123@Gmail.Com');
  final TextEditingController dobController = TextEditingController();
  final TextEditingController contactController = TextEditingController(text: '9876543210');
  final TextEditingController address1Controller = TextEditingController(text: 'Xyz');
  final TextEditingController address2Controller = TextEditingController(text: 'Xyz');
  final TextEditingController cityController = TextEditingController(text: 'Xyz');
  final TextEditingController stateController = TextEditingController(text: 'Xyz');
  final TextEditingController zipCodeController = TextEditingController(text: 'Xyz');
  final TextEditingController countryController = TextEditingController(text: 'Xyz');
  final TextEditingController distanceController = TextEditingController(text: '5');

  String gender = 'Male';
  String membershipType = 'Adult (18 And Above)';
  String countryCode = '+91';
  String distanceUnit = 'Km';

  bool addressSameAsSignUp = true;
  bool practicePlanSameAsMain = true;
  bool preferredClubsSameAsMain = true;

  final Set<String> selectedSports = {'Tennis', 'Baseball', 'Cricket', 'Basketball'};
  final List<_PracticePlan> practicePlans = [];
  final Set<String> selectedClubs = {'Urban Titans', 'Steel Panthers'};

  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    dobController.dispose();
    contactController.dispose();
    address1Controller.dispose();
    address2Controller.dispose();
    cityController.dispose();
    stateController.dispose();
    zipCodeController.dispose();
    countryController.dispose();
    distanceController.dispose();
  }
}

class _PracticePlan {
  String practiceDays = 'Weekdays';
  TimeOfDay? startTime;
  TimeOfDay? endTime;
}

// Member Details Card Widget
class _MemberDetailsCard extends StatefulWidget {
  final int memberNumber;
  final _MemberData member;
  final bool isMobile;
  final bool isEditMode;

  const _MemberDetailsCard({
    required this.memberNumber,
    required this.member,
    required this.isMobile,
    required this.isEditMode,
  });

  @override
  State<_MemberDetailsCard> createState() => _MemberDetailsCardState();
}

class _MemberDetailsCardState extends State<_MemberDetailsCard> {
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

  final List<String> _genderOptions = ['Male', 'Female', 'Other'];
  final List<String> _membershipTypes = [
    'Adult (18 And Above)',
    'Youth (13-17)',
    'Child (Below 13)',
  ];
  final List<String> _countryCodes = ['+91', '+1', '+44', '+86'];
  final List<String> _practiceDaysOptions = [
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
  final List<String> _distanceUnits = ['Km', 'Miles'];

  @override
  void initState() {
    super.initState();
    // Initialize with default practice plans
    if (widget.member.practicePlans.isEmpty) {
      widget.member.practicePlans.addAll([
        _PracticePlan()..practiceDays = 'Weekdays',
        _PracticePlan()..practiceDays = 'Weekend',
      ]);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        widget.member.dobController.text =
            '${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}-${picked.year}';
      });
    }
  }

  Future<void> _selectTime(BuildContext context, _PracticePlan plan, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime
          ? (plan.startTime ?? const TimeOfDay(hour: 9, minute: 0))
          : (plan.endTime ?? const TimeOfDay(hour: 17, minute: 0)),
    );
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          plan.startTime = picked;
        } else {
          plan.endTime = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(widget.isMobile ? 12 : 18),
      ),
      child: Padding(
        padding: EdgeInsets.all(widget.isMobile ? 12 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Member Header
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
                widget.memberNumber == 1
                    ? 'Member ${widget.memberNumber} Details (Head)'
                    : 'Member ${widget.memberNumber} Details',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: widget.isMobile ? 14 : 16,
                ),
              ),
            ),
            SizedBox(height: widget.isMobile ? 16 : 20),

            // Personal Information
            _LabeledField(
              label: 'First Name',
              child: _TextBox(
                hint: 'First Name',
                controller: widget.member.firstNameController,
                enabled: widget.isEditMode,
              ),
            ),
            SizedBox(height: widget.isMobile ? 12 : 16),
            _LabeledField(
              label: 'Last Name',
              child: _TextBox(
                hint: 'Last Name',
                controller: widget.member.lastNameController,
                enabled: widget.isEditMode,
              ),
            ),
            SizedBox(height: widget.isMobile ? 12 : 16),
            _LabeledField(
              label: 'Email Address',
              child: _TextBox(
                hint: 'Email Address',
                controller: widget.member.emailController,
                keyboardType: TextInputType.emailAddress,
                enabled: widget.isEditMode,
              ),
            ),
            SizedBox(height: widget.isMobile ? 12 : 16),
            _LabeledField(
              label: 'Date Of Birth',
              child: GestureDetector(
                onTap: widget.isEditMode ? () => _selectDate(context) : null,
                child: _TextBox(
                  hint: 'MM-DD-YYYY',
                  controller: widget.member.dobController,
                  enabled: false,
                ),
              ),
            ),
            SizedBox(height: widget.isMobile ? 12 : 16),
            _LabeledField(
              label: 'Gender',
              child: _DropdownBox(
                hint: widget.member.gender,
                value: widget.member.gender,
                items: _genderOptions,
                enabled: widget.isEditMode,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      widget.member.gender = value;
                    });
                  }
                },
              ),
            ),
            SizedBox(height: widget.isMobile ? 12 : 16),
            _LabeledField(
              label: 'Contact Number',
              child: Row(
                children: [
                  SizedBox(
                    width: widget.isMobile ? 100 : 120,
                    child: _DropdownBox(
                      hint: widget.member.countryCode,
                      value: widget.member.countryCode,
                      items: _countryCodes,
                      enabled: widget.isEditMode,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            widget.member.countryCode = value;
                          });
                        }
                      },
                    ),
                  ),
                  SizedBox(width: widget.isMobile ? 8 : 12),
                  Expanded(
                    child: _TextBox(
                      hint: 'Contact Number',
                      controller: widget.member.contactController,
                      keyboardType: TextInputType.phone,
                      enabled: widget.isEditMode,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: widget.isMobile ? 12 : 16),
            _LabeledField(
              label: 'Membership Type',
              child: _DropdownBox(
                hint: widget.member.membershipType,
                value: widget.member.membershipType,
                items: _membershipTypes,
                enabled: widget.isEditMode,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      widget.member.membershipType = value;
                    });
                  }
                },
              ),
            ),
            SizedBox(height: widget.isMobile ? 16 : 20),

            // Sports Interested In
            Text(
              'Sports Interested In',
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
                final isSelected = widget.member.selectedSports.contains(sport);
                return FilterChip(
                  label: Text(sport),
                  selected: isSelected,
                  onSelected: widget.isEditMode
                      ? (selected) {
                          setState(() {
                            if (selected) {
                              widget.member.selectedSports.add(sport);
                            } else {
                              widget.member.selectedSports.remove(sport);
                            }
                          });
                        }
                      : null,
                  selectedColor: Colors.blue[100],
                  checkmarkColor: Colors.blue[900],
                  deleteIcon: isSelected && widget.isEditMode
                      ? const Icon(Icons.close, size: 16, color: Colors.red)
                      : null,
                  onDeleted: isSelected && widget.isEditMode
                      ? () {
                          setState(() {
                            widget.member.selectedSports.remove(sport);
                          });
                        }
                      : null,
                );
              }).toList(),
            ),
            SizedBox(height: widget.isMobile ? 16 : 20),

            // Checkboxes
            Row(
              children: [
                Checkbox(
                  value: widget.member.addressSameAsSignUp,
                  onChanged: widget.isEditMode
                      ? (value) {
                          setState(() {
                            widget.member.addressSameAsSignUp = value ?? false;
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
            SizedBox(height: widget.isMobile ? 12 : 16),
            Row(
              children: [
                Checkbox(
                  value: widget.member.practicePlanSameAsMain,
                  onChanged: widget.isEditMode
                      ? (value) {
                          setState(() {
                            widget.member.practicePlanSameAsMain = value ?? false;
                          });
                        }
                      : null,
                  activeColor: const Color(0xFF1E40AF),
                ),
                SizedBox(width: widget.isMobile ? 8 : 12),
                Expanded(
                  child: Text(
                    'Practice Plan Same As Main Member?',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: widget.isMobile ? 13 : 14,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: widget.isMobile ? 12 : 16),
            Row(
              children: [
                Checkbox(
                  value: widget.member.preferredClubsSameAsMain,
                  onChanged: widget.isEditMode
                      ? (value) {
                          setState(() {
                            widget.member.preferredClubsSameAsMain = value ?? false;
                          });
                        }
                      : null,
                  activeColor: const Color(0xFF1E40AF),
                ),
                SizedBox(width: widget.isMobile ? 8 : 12),
                Expanded(
                  child: Text(
                    'Preferred Clubs Are Same As Main Member',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: widget.isMobile ? 13 : 14,
                    ),
                  ),
                ),
              ],
            ),

            // Address Section
            if (!widget.member.addressSameAsSignUp) ...[
              SizedBox(height: widget.isMobile ? 16 : 20),
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
                controller: widget.member.address1Controller,
                enabled: widget.isEditMode,
              ),
              SizedBox(height: widget.isMobile ? 10 : 12),
              _TextBox(
                hint: 'Address 2',
                controller: widget.member.address2Controller,
                enabled: widget.isEditMode,
              ),
              SizedBox(height: widget.isMobile ? 10 : 12),
              Row(
                children: [
                  Expanded(
                    child: _DropdownBox(
                      hint: 'City',
                      value: widget.member.cityController.text.isNotEmpty
                          ? widget.member.cityController.text
                          : null,
                      items: const ['Xyz', 'Nagpur', 'Mumbai', 'Delhi'],
                      enabled: widget.isEditMode,
                      onChanged: (value) {
                        if (value != null) {
                          widget.member.cityController.text = value;
                        }
                      },
                    ),
                  ),
                  SizedBox(width: widget.isMobile ? 8 : 12),
                  Expanded(
                    child: _DropdownBox(
                      hint: 'State',
                      value: widget.member.stateController.text.isNotEmpty
                          ? widget.member.stateController.text
                          : null,
                      items: const ['Xyz', 'Maharashtra', 'Gujarat', 'Karnataka'],
                      enabled: widget.isEditMode,
                      onChanged: (value) {
                        if (value != null) {
                          widget.member.stateController.text = value;
                        }
                      },
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
                      controller: widget.member.zipCodeController,
                      enabled: widget.isEditMode,
                    ),
                  ),
                  SizedBox(width: widget.isMobile ? 8 : 12),
                  Expanded(
                    child: _DropdownBox(
                      hint: 'Country',
                      value: widget.member.countryController.text.isNotEmpty
                          ? widget.member.countryController.text
                          : null,
                      items: const ['Xyz', 'India', 'USA', 'UK'],
                      enabled: widget.isEditMode,
                      onChanged: (value) {
                        if (value != null) {
                          widget.member.countryController.text = value;
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],

            // Practice Plan Section
            if (!widget.member.practicePlanSameAsMain) ...[
              SizedBox(height: widget.isMobile ? 16 : 20),
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
                        'Practice Plan',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: widget.isMobile ? 13 : 14,
                        ),
                      ),
                    ),
                    if (widget.isEditMode)
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            widget.member.practicePlans.add(_PracticePlan());
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
                          '+ Practice Plan',
                          style: TextStyle(fontSize: widget.isMobile ? 11 : 12),
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(height: widget.isMobile ? 12 : 16),
              ...widget.member.practicePlans.asMap().entries.map((entry) {
                final index = entry.key;
                final plan = entry.value;
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
                        child: Row(
                          children: [
                            Text(
                              'Plan ${index + 1}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: widget.isMobile ? 11 : 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (widget.isEditMode && widget.member.practicePlans.length > 1)
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red, size: 18),
                                onPressed: () {
                                  setState(() {
                                    widget.member.practicePlans.removeAt(index);
                                  });
                                },
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                          ],
                        ),
                      ),
                      SizedBox(height: widget.isMobile ? 10 : 12),
                      Row(
                        children: [
                          Expanded(
                            child: _LabeledField(
                              label: 'Practice Days',
                              child: _DropdownBox(
                                hint: plan.practiceDays,
                                value: plan.practiceDays,
                                items: _practiceDaysOptions,
                                enabled: widget.isEditMode,
                                onChanged: (value) {
                                  if (value != null) {
                                    setState(() {
                                      plan.practiceDays = value;
                                    });
                                  }
                                },
                              ),
                            ),
                          ),
                          SizedBox(width: widget.isMobile ? 8 : 12),
                          Expanded(
                            child: _LabeledField(
                              label: 'Practice Time',
                              child: Row(
                                children: [
                                  Expanded(
                                    child: _TimeField(
                                      value: plan.startTime,
                                      onTap: () => _selectTime(context, plan, true),
                                    ),
                                  ),
                                  SizedBox(width: widget.isMobile ? 6 : 8),
                                  Expanded(
                                    child: _TimeField(
                                      value: plan.endTime,
                                      onTap: () => _selectTime(context, plan, false),
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
            ],

            // Preferred Clubs Section
            if (!widget.member.preferredClubsSameAsMain) ...[
              SizedBox(height: widget.isMobile ? 16 : 20),
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
                  'Preferred Club',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: widget.isMobile ? 13 : 14,
                  ),
                ),
              ),
              SizedBox(height: widget.isMobile ? 12 : 16),
              Text(
                'Select Clubs',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: widget.isMobile ? 14 : 16,
                ),
              ),
              SizedBox(height: widget.isMobile ? 8 : 12),
              Wrap(
                spacing: widget.isMobile ? 8 : 12,
                runSpacing: widget.isMobile ? 8 : 12,
                children: widget.member.selectedClubs.map((club) {
                  return Chip(
                    label: Text(club),
                    deleteIcon: widget.isEditMode
                        ? const Icon(Icons.close, size: 16, color: Colors.red)
                        : null,
                    onDeleted: widget.isEditMode
                        ? () {
                            setState(() {
                              widget.member.selectedClubs.remove(club);
                            });
                          }
                        : null,
                    backgroundColor: Colors.blue[100],
                  );
                }).toList(),
              ),
              SizedBox(height: widget.isMobile ? 12 : 16),
              Row(
                children: [
                  Expanded(
                    child: _TextBox(
                      hint: 'Distance',
                      controller: widget.member.distanceController,
                      keyboardType: TextInputType.number,
                      enabled: widget.isEditMode,
                    ),
                  ),
                  SizedBox(width: widget.isMobile ? 8 : 12),
                  SizedBox(
                    width: widget.isMobile ? 80 : 100,
                    child: _DropdownBox(
                      hint: widget.member.distanceUnit,
                      value: widget.member.distanceUnit,
                      items: _distanceUnits,
                      enabled: widget.isEditMode,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            widget.member.distanceUnit = value;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: widget.isMobile ? 8 : 12),
              Text(
                '(You Can Select The Clubs Within Your Preferred Radius From Below Map Too)',
                style: TextStyle(
                  fontSize: widget.isMobile ? 11 : 12,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
              SizedBox(height: widget.isMobile ? 12 : 16),
              Container(
                height: widget.isMobile ? 200 : 300,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black12),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.map, size: 48, color: Colors.grey[400]),
                      const SizedBox(height: 8),
                      Text(
                        'Map View',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '5 Km radius from Residence',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
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
          child: _TextBox(hint: 'member1234@gmail.com', enabled: isEditMode),
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
              backgroundColor: const Color(0xFF1E40AF),
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
                        color: Color(0xFF1E40AF),
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
                          color: Color(0xFF1E40AF),
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
                        color: Color(0xFF1E40AF),
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
                          color: Color(0xFF1E40AF),
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
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  const _TextBox({
    required this.hint,
    this.enabled = true,
    this.obscure = false,
    this.keyboardType,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      enabled: enabled,
      obscureText: obscure,
      keyboardType: keyboardType,
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
  final String? value;
  final List<String>? items;
  final Function(String?)? onChanged;
  const _DropdownBox({
    required this.hint,
    this.enabled = true,
    this.value,
    this.items,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !enabled,
      child: Opacity(
        opacity: enabled ? 1.0 : 0.6,
        child: DropdownButtonFormField<String>(
          value: value,
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
          items: items != null
              ? items!.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList()
              : const [
                  DropdownMenuItem(value: '1', child: Text('Option 1')),
                  DropdownMenuItem(value: '2', child: Text('Option 2')),
                ],
          onChanged: enabled ? (onChanged ?? (value) {}) : null,
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
            color: const Color(0xFF1E40AF),
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
        color: isSelected ? const Color(0xFF1E40AF) : Colors.grey.shade200,
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
