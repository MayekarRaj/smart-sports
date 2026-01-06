import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_sports/shared/widgets/role_sidebar.dart';
import 'package:smart_sports/shared/navigation/role_navigation_manager.dart';
import 'package:smart_sports/role_specific/common/role_router.dart';
import 'package:smart_sports/auth/screens/auth_shell.dart';
import 'package:smart_sports/core/utils/auth_utils.dart';
import 'add_sponsorship_screen.dart';

class ClubSponsorshipsPage extends ConsumerStatefulWidget {
  const ClubSponsorshipsPage({super.key});

  @override
  ConsumerState<ClubSponsorshipsPage> createState() => _ClubSponsorshipsPageState();
}

class _ClubSponsorshipsPageState extends ConsumerState<ClubSponsorshipsPage> {
  final TextEditingController _eventNameController = TextEditingController();

  String _selectedOfferTypeTab = 'My Offers'; // Top-level: My Offers, Corporate Offers, Merchandisers Offer, Freelancers Offer
  String _selectedMainTab = 'My Offers'; // Secondary: My Offers, Requested, In Progress, Upcoming, Archived
  String _selectedInternalTab = 'Club';
  String _selectedDays = 'Select';
  String _selectedStatus = 'Select';

  DateTime? _startDate;
  DateTime? _endDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  bool _showFilterBox = false;

  final List<String> _offerTypeTabs = [
    'My Offers',
    'Corporate Offers',
    'Merchandisers Offer',
    'Freelancers Offer',
  ];
  
  final List<String> _mainTabs = [
    'My Offers',
    'Requested',
    'In Progress',
    'Upcoming',
    'Archived',
  ];
  final List<String> _internalTabs = ['Club', 'Booking', 'Event'];
  final List<String> _daysOptions = [
    'Select',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
  final List<String> _statusOptions = [
    'Select',
    'Active',
    'Pending',
    'Completed',
    'Cancelled',
  ];

  final List<Map<String, dynamic>> _offers = [
    {
      'title': 'Elite Sports Arena',
      'description':
          'Massive Brand Exposure Across All Event Materials, Press, Banners, Jerseys, And Digital Platforms.',
      'type': 'Digital Add',
      'sports': 'Tennis',
      'region': 'State',
      'daysToDeliver': '10',
      'eventDate': 'Fri, April 18, 2025',
      'totalCost': '50',
      'currency': 'USD',
      'sponsoredBy': {
        'name': 'Miles King',
        'email': 'Elijahscott@Gmail.Com',
        'avatar': null,
      },
      'requestedBy': 'Alia Austin',
      'bookingId': '12345678',
      'status': 'Sponsored',
    },
    {
      'title': 'Elite Sports Arena',
      'description':
          'Massive Brand Exposure Across All Event Materials, Press, Banners, Jerseys, And Digital Platforms.',
      'type': 'Digital Add',
      'sports': 'Tennis',
      'region': 'State',
      'daysToDeliver': '10',
      'eventDate': 'Fri, April 18, 2025',
      'totalCost': '50',
      'currency': 'USD',
      'sponsoredBy': {
        'name': 'Miles King',
        'email': 'Elijahscott@Gmail.Com',
        'avatar': null,
      },
      'requestedBy': 'Alia Austin',
      'bookingId': '12345678',
      'status': 'Delivered',
    },
    {
      'title': 'Elite Sports Arena',
      'description':
          'Massive Brand Exposure Across All Event Materials, Press, Banners, Jerseys, And Digital Platforms.',
      'type': 'Digital Add',
      'sports': 'Tennis',
      'region': 'State',
      'daysToDeliver': '10',
      'eventDate': 'Fri, April 18, 2025',
      'totalCost': '50',
      'currency': 'USD',
      'sponsoredBy': {
        'name': 'Miles King',
        'email': 'Elijahscott@Gmail.Com',
        'avatar': null,
      },
      'requestedBy': 'Alia Austin',
      'bookingId': '12345678',
      'status': 'Paid',
    },
  ];

  @override
  void dispose() {
    _eventNameController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Wed, March 5, 2025';
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${weekdays[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _formatTime(TimeOfDay? time) {
    if (time == null) return 'HH:MM';
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F0), // Light peach/pink background
      drawer: Drawer(
        elevation: 0,
        child: SafeArea(
          child: RoleSidebar(
            role: UserRole.club,
            selectedIndex: 6,
            edgeToEdge: true,
            onSelectIndex: (i) => RoleNavigationManager.navigateToScreen(
              context,
              UserRole.club,
              i,
            ),
            onProfileTap: () =>
                RoleNavigationManager.navigateToProfile(context, UserRole.club),
            onSignOut: () => AuthUtils.handleLogout(context, ref),
          ),
        ),
      ),
      appBar: AppBar(
        title: const Text(
          'Sponsorships',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1F2937),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Color(0xFF1F2937)),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AddSponsorshipScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.add, color: Colors.white, size: 18),
              label: const Text(
                'Add New Sponsorship',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF009A69),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Filter/Search Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: const Color(0xFFFFF5F0),
              child: Column(
                children: [
                  // Event Name
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: TextField(
                      controller: _eventNameController,
                      decoration: InputDecoration(
                        hintText: 'Q Search',
                        hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Color(0xFF6B7280),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.filter_list,
                            color: _showFilterBox
                                ? const Color(0xFF009A69)
                                : const Color(0xFF6B7280),
                          ),
                          onPressed: () {
                            setState(() {
                              _showFilterBox = !_showFilterBox;
                            });
                          },
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),

                  // Date Range, Time, Days, Status Row
                  if (_showFilterBox)
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final isMobile = constraints.maxWidth < 600;
                        if (isMobile) {
                          return Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildDateField(
                                      'Start Date',
                                      _startDate,
                                      true,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: _buildDateField(
                                      'End Date',
                                      _endDate,
                                      false,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildTimeField(
                                      'Start Time',
                                      _startTime,
                                      true,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: _buildTimeField(
                                      'End Time',
                                      _endTime,
                                      false,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildDropdownField(
                                      'Days',
                                      _selectedDays,
                                      _daysOptions,
                                      (value) {
                                        setState(
                                          () =>
                                              _selectedDays = value ?? 'Select',
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: _buildDropdownField(
                                      'Status',
                                      _selectedStatus,
                                      _statusOptions,
                                      (value) {
                                        setState(
                                          () => _selectedStatus =
                                              value ?? 'Select',
                                        );
                                      },
                                      isHighlighted:
                                          _selectedStatus != 'Select',
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        } else {
                          return Row(
                            children: [
                              Expanded(
                                child: _buildDateField(
                                  'Start Date',
                                  _startDate,
                                  true,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _buildDateField(
                                  'End Date',
                                  _endDate,
                                  false,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _buildTimeField(
                                  'Start Time',
                                  _startTime,
                                  true,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _buildTimeField(
                                  'End Time',
                                  _endTime,
                                  false,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _buildDropdownField(
                                  'Days',
                                  _selectedDays,
                                  _daysOptions,
                                  (value) {
                                    setState(
                                      () => _selectedDays = value ?? 'Select',
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _buildDropdownField(
                                  'Status',
                                  _selectedStatus,
                                  _statusOptions,
                                  (value) {
                                    setState(
                                      () => _selectedStatus = value ?? 'Select',
                                    );
                                  },
                                  isHighlighted: _selectedStatus != 'Select',
                                ),
                              ),
                            ],
                          );
                        }
                      },
                    ),
                ],
              ),
            ),

            // Top-Level Offer Type Tabs
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: const Color(0xFFFFF5F0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: _offerTypeTabs.asMap().entries.map((entry) {
                    final index = entry.key;
                    final tab = entry.value;
                    final isSelected = _selectedOfferTypeTab == tab;
                    final isFirst = index == 0;
                    final isLast = index == _offerTypeTabs.length - 1;
                    
                    return Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.grey.shade800
                              : Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: isFirst ? const Radius.circular(12) : Radius.zero,
                            bottomLeft: isFirst ? const Radius.circular(12) : Radius.zero,
                            topRight: isLast ? const Radius.circular(12) : Radius.zero,
                            bottomRight: isLast ? const Radius.circular(12) : Radius.zero,
                          ),
                          border: Border(
                            right: isLast
                                ? BorderSide.none
                                : BorderSide(
                                    color: Colors.grey.shade300,
                                    width: 1,
                                  ),
                          ),
                        ),
                        child: InkWell(
                          onTap: () => setState(() {
                            _selectedOfferTypeTab = tab;
                            if (tab != 'My Offers') {
                              _selectedMainTab = 'My Offers';
                            }
                          }),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 14,
                            ),
                            child: Text(
                              tab,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : Colors.grey.shade700,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            // Secondary Navigation Tabs (only show when "My Offers" is selected in top-level)
            if (_selectedOfferTypeTab == 'My Offers')
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                color: const Color(0xFFFFF5F0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _mainTabs.map((tab) {
                      final isSelected = _selectedMainTab == tab;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: InkWell(
                          onTap: () => setState(() => _selectedMainTab = tab),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF009A69)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFF009A69)
                                    : const Color(0xFFE5E7EB),
                              ),
                            ),
                            child: Text(
                              tab,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : const Color(0xFF1F2937),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),

            // Main Content Area
            Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Internal Tabs
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Color(0xFFE5E7EB)),
                      ),
                    ),
                    child: Row(
                      children: _internalTabs.map((tab) {
                        final isSelected = _selectedInternalTab == tab;
                        return Padding(
                          padding: const EdgeInsets.only(right: 24),
                          child: InkWell(
                            onTap: () =>
                                setState(() => _selectedInternalTab = tab),
                            child: Container(
                              padding: const EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: isSelected
                                        ? const Color(0xFF009A69)
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                              ),
                              child: Text(
                                tab,
                                style: TextStyle(
                                  color: isSelected
                                      ? const Color(0xFF009A69)
                                      : const Color(0xFF6B7280),
                                  fontSize: 14,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  // Offers List
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    itemCount: _offers.length,
                    itemBuilder: (context, index) {
                      return _buildOfferCard(_offers[index]);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateField(String label, DateTime? date, bool isStartDate) {
    return InkWell(
      onTap: () => _selectDate(context, isStartDate),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatDate(date),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF1F2937),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.calendar_today,
              color: Color(0xFF6B7280),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeField(String label, TimeOfDay? time, bool isStartTime) {
    return InkWell(
      onTap: () => _selectTime(context, isStartTime),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(time),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF1F2937),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.access_time, color: Color(0xFF6B7280), size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField(
    String label,
    String value,
    List<String> options,
    Function(String?) onChanged, {
    bool isHighlighted = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: isHighlighted
            ? const Color(0xFF009A69).withValues(alpha: 0.1)
            : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isHighlighted
              ? const Color(0xFF009A69)
              : const Color(0xFFE5E7EB),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isHighlighted
                  ? const Color(0xFF009A69)
                  : const Color(0xFF9CA3AF),
            ),
          ),
          const SizedBox(height: 4),
          DropdownButton<String>(
            value: value,
            isExpanded: true,
            underline: const SizedBox(),
            icon: Icon(
              Icons.arrow_drop_down,
              color: isHighlighted
                  ? const Color(0xFF009A69)
                  : const Color(0xFF6B7280),
            ),
            style: TextStyle(
              color: isHighlighted
                  ? const Color(0xFF009A69)
                  : const Color(0xFF1F2937),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            items: options.map((String option) {
              return DropdownMenuItem<String>(
                value: option,
                child: Text(option),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildOfferCard(Map<String, dynamic> offer) {
    // Different layout for In Progress tab
    if (_selectedMainTab == 'In Progress') {
      return _buildInProgressCard(offer);
    }
    // Different layout for Upcoming tab
    if (_selectedMainTab == 'Upcoming') {
      return _buildUpcomingCard(offer);
    }
    // Different layout for Archived tab
    if (_selectedMainTab == 'Archived') {
      return _buildArchivedCard(offer);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Logo and Title
          Row(
            children: [
              // Logo placeholder
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF009A69).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.shield, color: Color(0xFF009A69)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  offer['title'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Description
          Text(
            offer['description'],
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),

          // Tags
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildTag('Type ${offer['type']}'),
              _buildTag('Sports ${offer['sports']}'),
              _buildTag('Region ${offer['region']}'),
              _buildTag('Days To Delivered ${offer['daysToDeliver']}'),
            ],
          ),
          const SizedBox(height: 12),

          // Event Date and Total Cost Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Event Date ${offer['eventDate']}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF1F2937),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Total Cost ${offer['currency']} ${offer['totalCost']}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF1F2937),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Sponsored By Section and Action Buttons
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sponsored By Section
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Sponsored By',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF9CA3AF),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          // Avatar
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: const Color(
                              0xFF009A69,
                            ).withValues(alpha: 0.1),
                            child: const Icon(
                              Icons.person,
                              color: Color(0xFF009A69),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Name and Email
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  offer['sponsoredBy']['name'],
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF2563EB),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  offer['sponsoredBy']['email'],
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF6B7280),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Action Buttons - Different for Requested tab
              if (_selectedMainTab == 'Requested')
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Requested Button
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF6B35),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Requested',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Action Buttons Row
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // X Button
                        InkWell(
                          onTap: () {
                            // TODO: Handle decline action
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color(0xFFEF4444),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Accept Button
                        InkWell(
                          onTap: () {
                            // TODO: Handle accept action
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF009A69),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Accept',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              else
                // Status Button for other tabs
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2563EB),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    offer['status'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInProgressCard(Map<String, dynamic> offer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Section: Logo, Title, Description (stacked vertically for mobile)
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF009A69).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.shield, color: Color(0xFF009A69)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  offer['title'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            offer['description'],
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),

          // Sponsored By box and Sponsored button (stacked vertically for mobile)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sponsored By',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF9CA3AF),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: const Color(
                        0xFF009A69,
                      ).withValues(alpha: 0.1),
                      child: const Icon(Icons.person, color: Color(0xFF009A69)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            offer['sponsoredBy']['name'],
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF2563EB),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            offer['sponsoredBy']['email'],
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF009A69),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Sponsored',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Tags
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildTag('Type ${offer['type']}'),
              _buildTag('Sports ${offer['sports']}'),
              _buildTag('Region ${offer['region']}'),
              _buildTag('Days To Deliver ${offer['daysToDeliver']}'),
            ],
          ),
          const SizedBox(height: 12),

          // Event Date and Total Cost (mobile-friendly wrap)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Text(
                'Event Date ${offer['eventDate']}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF1F2937),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Total Cost ${offer['currency']} ${offer['totalCost']}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF1F2937),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Requested By and Booking Id boxes (mobile-friendly)
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: Text(
                    'Requested By ${offer['requestedBy'] ?? 'N/A'}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF1F2937),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: Text(
                    'Booking Id ${offer['bookingId'] ?? 'N/A'}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF1F2937),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingCard(Map<String, dynamic> offer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Section: Logo, Title, Description (stacked vertically for mobile)
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF009A69).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.shield, color: Color(0xFF009A69)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  offer['title'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            offer['description'],
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),

          // Sponsored By box and Sponsored button (stacked vertically for mobile)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sponsored By',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF9CA3AF),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: const Color(
                        0xFF009A69,
                      ).withValues(alpha: 0.1),
                      child: const Icon(Icons.person, color: Color(0xFF009A69)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            offer['sponsoredBy']['name'],
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF2563EB),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            offer['sponsoredBy']['email'],
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF009A69),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Sponsored',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Tags
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildTag('Type ${offer['type']}'),
              _buildTag('Sports ${offer['sports']}'),
              _buildTag('Region ${offer['region']}'),
              _buildTag('Days To Deliver ${offer['daysToDeliver']}'),
            ],
          ),
          const SizedBox(height: 12),

          // Event Date and Total Cost (in a row)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Event Date ${offer['eventDate']}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF1F2937),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Total Cost ${offer['currency']} ${offer['totalCost']}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF1F2937),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildArchivedCard(Map<String, dynamic> offer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Section: Logo, Title, Description (stacked vertically for mobile)
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF009A69).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.shield, color: Color(0xFF009A69)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  offer['title'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            offer['description'],
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),

          // Tags
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildTag('Type ${offer['type']}'),
              _buildTag('Sports ${offer['sports']}'),
              _buildTag('Region ${offer['region']}'),
              _buildTag('Days To Deliver ${offer['daysToDeliver']}'),
            ],
          ),
          const SizedBox(height: 12),

          // Event Date and Total Cost Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Event Date ${offer['eventDate']} ${offer['eventDate']}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF1F2937),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Total Cost ${offer['currency']} ${offer['totalCost']}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF1F2937),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Sponsored By box and Sponsored button (stacked vertically for mobile)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sponsored By',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF9CA3AF),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: const Color(
                        0xFF009A69,
                      ).withValues(alpha: 0.1),
                      child: const Icon(Icons.person, color: Color(0xFF009A69)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            offer['sponsoredBy']['name'],
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF2563EB),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            offer['sponsoredBy']['email'],
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF009A69),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Sponsored',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFECFDF5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          color: Color(0xFF1F2937),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
