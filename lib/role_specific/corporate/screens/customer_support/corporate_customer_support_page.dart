import 'package:flutter/material.dart';
import 'package:smart_sports/auth/screens/auth_shell.dart';
import 'package:smart_sports/shared/widgets/role_sidebar.dart';
import 'package:smart_sports/role_specific/common/role_router.dart';
import 'package:smart_sports/role_specific/corporate/screens/profile/corporate_profile_page.dart';
import 'package:smart_sports/role_specific/corporate/screens/dashboard/corporate_analytics_dashboard_page.dart';
import 'package:smart_sports/role_specific/corporate/screens/transactions/corporate_transactions_page.dart';
import 'package:smart_sports/role_specific/club/screens/courts/courts_page.dart';
import 'package:smart_sports/role_specific/corporate/screens/bookings/corporate_bookings_page.dart';
import 'package:smart_sports/role_specific/corporate/screens/events/corporate_events_page.dart';
import 'package:smart_sports/role_specific/corporate/screens/users/corporate_users_page.dart';
import 'package:smart_sports/role_specific/corporate/screens/referrals/corporate_referrals_page.dart';
import 'package:smart_sports/role_specific/corporate/screens/settings/corporate_settings_page.dart';

class CorporateCustomerSupportPage extends StatefulWidget {
  const CorporateCustomerSupportPage({super.key});

  @override
  State<CorporateCustomerSupportPage> createState() =>
      _CorporateCustomerSupportPageState();
}

class _CorporateCustomerSupportPageState
    extends State<CorporateCustomerSupportPage> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _titleSearchController = TextEditingController();
  String _selectedStatus = 'Select';
  String _selectedDay = 'Select';
  String _selectedTab = 'Open';
  bool _showFilters = false;

  final List<String> _statusOptions = [
    'Select',
    'Open',
    'In Progress',
    'Resolved',
    'Closed',
  ];

  final List<String> _dayOptions = [
    'Select',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  final List<Complaint> _complaints = [
    Complaint(
      title: 'Used Offensive Language',
      category: 'Behavior',
      description:
          'You Used Inappropriate Language During The Semi-Final Match.',
      complaintFrom: 'Opponent Player',
      date: '2025-04-10',
      status: 'Open',
    ),
    Complaint(
      title: 'Late Arrival For Team Match',
      category: 'Discipline',
      description:
          'H You Arrived 20 Minutes Late And Caused Team Formation Issues.',
      complaintFrom: 'Team Manager',
      date: '2025-04-11',
      status: 'Open',
    ),
    Complaint(
      title: 'Equipment Damage',
      category: 'Property',
      description: 'Damaged court equipment during practice session.',
      complaintFrom: 'Facility Manager',
      date: '2025-04-12',
      status: 'Resolved',
    ),
    Complaint(
      title: 'Noise Disturbance',
      category: 'Behavior',
      description: 'Excessive noise during quiet hours.',
      complaintFrom: 'Neighbor',
      date: '2025-04-13',
      status: 'In Progress',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _titleSearchController.dispose();
    super.dispose();
  }

  void _showRaiseComplaintDialog() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddComplaintScreen(
          onComplaintSubmitted: (complaint) {
            setState(() {
              _complaints.add(complaint);
            });
          },
        ),
      ),
    );
  }

  void _showViewComplaintScreen(Complaint complaint) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ViewComplaintScreen(complaint: complaint),
      ),
    );
  }

  List<Complaint> get _filteredComplaints {
    return _complaints.where((complaint) {
      if (_selectedTab == 'Open' && complaint.status != 'Open') return false;
      if (_selectedTab == 'Resolved' && complaint.status == 'Open')
        return false;
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      drawer: Drawer(
        elevation: 0,
        child: SafeArea(
          child: RoleSidebar(
            role: UserRole.corporate,
            selectedIndex: 9, // Customer Support is index 9
            edgeToEdge: true,
            onSelectIndex: (i) async {
              final navigator = Navigator.of(context);
              final currentContext = context;
              navigator.pop();
              await Future.delayed(const Duration(milliseconds: 160));
              if (mounted) {
                _navigateFromSidebar(currentContext, i);
              }
            },
            onProfileTap: () async {
              final navigator = Navigator.of(context);
              navigator.pop();
              await Future.delayed(const Duration(milliseconds: 160));
              if (mounted) {
                navigator.push(
                  MaterialPageRoute(
                    builder: (_) => const CorporateProfilePage(),
                  ),
                );
              }
            },
            onSignOut: () {
              showDialog(
                context: context,
                builder: (BuildContext dialogContext) => AlertDialog(
                  title: const Text('Sign Out'),
                  content: const Text('Are you sure you want to sign out?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop(); // Close dialog
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => const AuthShell()),
                          (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Sign Out'),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      appBar: AppBar(
        title: const Text(
          'Complain...',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF009A69), Color(0xFF232534)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        centerTitle: false,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          // Filter Button
          IconButton(
            onPressed: () {
              setState(() {
                _showFilters = !_showFilters;
              });
            },
            icon: Icon(
              _showFilters ? Icons.filter_list_off : Icons.filter_list,
              color: const Color(0xFF1F2937),
            ),
            tooltip: _showFilters ? 'Hide Filters' : 'Show Filters',
          ),
          // Raise Complaint Button
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: ElevatedButton(
              onPressed: _showRaiseComplaintDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(
                  0xFF232534,
                ), // Coach gradient start
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                minimumSize: const Size(0, 32),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.add, size: 14),
                  const SizedBox(width: 2),
                  const Text(
                    'Raise',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0),
          child: Container(),
        ),
      ),
      body: Column(
        children: [
          // Search bar - Always visible
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Search bar
                Container(
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
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search Here',
                      hintStyle: TextStyle(color: Color(0xFF9CA3AF)),
                      prefixIcon: Icon(Icons.search, color: Color(0xFF6B7280)),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Entries info
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Show 10 Entries',
                      style: TextStyle(color: Color(0xFF6B7280), fontSize: 14),
                    ),
                    Text(
                      '${_filteredComplaints.length} complaints found',
                      style: const TextStyle(
                        color: Color(0xFF6B7280),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Filter section - Only show when _showFilters is true
          if (_showFilters)
            Container(
              color: const Color(0xFF2D3748),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Title filter
                  _buildFilterRow(
                    label: 'Title',
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        controller: _titleSearchController,
                        decoration: const InputDecoration(
                          hintText: 'Search',
                          prefixIcon: Icon(
                            Icons.search,
                            color: Color(0xFF6B7280),
                          ),
                          suffixIcon: Icon(
                            Icons.filter_list,
                            color: Color(0xFF6B7280),
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Date Range filter
                  _buildFilterRow(
                    label: 'Date Range',
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildDateField(
                            label: 'From',
                            value: 'Wed, March 5, 2025',
                            onTap: () {
                              // Handle date picker
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildDateField(
                            label: 'To',
                            value: 'Wed, March 5, 2025',
                            onTap: () {
                              // Handle date picker
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Time filter
                  _buildFilterRow(
                    label: 'Time',
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildTimeField(
                            label: 'From',
                            value: 'HH:MM',
                            onTap: () {
                              // Handle time picker
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildTimeField(
                            label: 'To',
                            value: 'HH:MM',
                            onTap: () {
                              // Handle time picker
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Days and Status filters
                  Row(
                    children: [
                      Expanded(
                        child: _buildFilterRow(
                          label: 'Days',
                          child: _buildDropdownField(
                            value: _selectedDay,
                            items: _dayOptions,
                            onChanged: (value) {
                              setState(() {
                                _selectedDay = value ?? 'Select';
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildFilterRow(
                          label: 'Status',
                          child: _buildDropdownField(
                            value: _selectedStatus,
                            items: _statusOptions,
                            onChanged: (value) {
                              setState(() {
                                _selectedStatus = value ?? 'Select';
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

          // Complaints list
          Expanded(
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  // Tabs
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        _buildTab('Open', _selectedTab == 'Open'),
                        const SizedBox(width: 16),
                        _buildTab('Resolved', _selectedTab == 'Resolved'),
                      ],
                    ),
                  ),
                  const Divider(height: 1),

                  // Complaints table
                  Expanded(
                    child: _filteredComplaints.isEmpty
                        ? const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.inbox_outlined,
                                  size: 64,
                                  color: Color(0xFF9CA3AF),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'No complaints found',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Color(0xFF6B7280),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Try adjusting your search or filters',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF9CA3AF),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.only(top: 8),
                            itemCount: _filteredComplaints.length,
                            itemBuilder: (context, index) {
                              final complaint = _filteredComplaints[index];
                              return _buildComplaintCard(complaint);
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterRow({required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  Widget _buildDateField({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value,
                style: const TextStyle(color: Color(0xFF1F2937), fontSize: 14),
              ),
            ),
            const Icon(
              Icons.calendar_today,
              size: 16,
              color: Color(0xFF6B7280),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeField({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value,
                style: const TextStyle(color: Color(0xFF1F2937), fontSize: 14),
              ),
            ),
            const Icon(Icons.access_time, size: 16, color: Color(0xFF6B7280)),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: items.contains(value) ? value : items.first,
          isExpanded: true,
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  item,
                  style: const TextStyle(
                    color: Color(0xFF1F2937),
                    fontSize: 14,
                  ),
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildTab(String label, bool isSelected) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedTab = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1E40AF) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF6B7280),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildComplaintCard(Complaint complaint) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      complaint.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Category: ${complaint.category}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E40AF).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  complaint.status,
                  style: const TextStyle(
                    color: Color(0xFF1E40AF),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            complaint.description,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF374151),
              height: 1.4,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  'From: ${complaint.complaintFrom}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ),
              Text(
                complaint.date,
                style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _showComplaintDetails(complaint),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Details', style: TextStyle(fontSize: 12)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _showViewComplaintScreen(complaint),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E40AF),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'View Complaint',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showComplaintDetails(Complaint complaint) {
    showDialog(
      context: context,
      builder: (context) => _ComplaintDetailsDialog(complaint: complaint),
    );
  }

  void _navigateFromSidebar(BuildContext context, int index) {
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
          MaterialPageRoute(builder: (_) => const ClubCourtsPage()),
        );
        break;
      case 3:
        // Clubs - placeholder
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
        // Sponsorships - placeholder
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
      case 9:
        // Already on customer support
        break;
      case 10:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const CorporateSettingsPage()),
        );
        break;
    }
  }
}

class Complaint {
  final String title;
  final String category;
  final String description;
  final String complaintFrom;
  final String date;
  final String status;

  Complaint({
    required this.title,
    required this.category,
    required this.description,
    required this.complaintFrom,
    required this.date,
    required this.status,
  });
}

// Add Complaint Screen - Full Screen Implementation
class AddComplaintScreen extends StatefulWidget {
  final Function(Complaint) onComplaintSubmitted;

  const AddComplaintScreen({super.key, required this.onComplaintSubmitted});

  @override
  State<AddComplaintScreen> createState() => _AddComplaintScreenState();
}

class _AddComplaintScreenState extends State<AddComplaintScreen> {
  final _formKey = GlobalKey<FormState>();
  final _complainantNameController = TextEditingController();
  final _complaintTitleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _playerCoachClubController = TextEditingController();

  String _selectedCategory = '';
  String _selectedComplaintAgainst = 'Player';
  String _selectedPreferredResolution = '2 Working Days';
  String _selectedUrgencyLevel = 'High';
  String _selectedComplainantRole = '';
  String _selectedRole = '';
  String _dateOfComplaint = 'Wed, March 5, 2025';
  DateTime _selectedDate = DateTime.now();
  String? _selectedFileName;
  bool _isLoading = false;
  List<String> _attachedFiles = [];

  final List<String> _categories = [
    'Input Text',
    'Booking',
    'Payment',
    'Account',
    'Event',
    'General',
  ];

  final List<String> _complaintAgainstOptions = [
    'Player',
    'Coach',
    'Club',
    'Member',
  ];

  final List<String> _preferredResolutionOptions = [
    '2 Working Days',
    '5 Working Days',
    '1 Week',
    '2 Weeks',
  ];

  final List<String> _urgencyLevelOptions = ['High', 'Medium', 'Low'];

  final List<String> _complainantRoleOptions = [
    'Coach',
    'Player',
    'Member',
    'Club',
  ];

  @override
  void dispose() {
    _complainantNameController.dispose();
    _complaintTitleController.dispose();
    _descriptionController.dispose();
    _playerCoachClubController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _dateOfComplaint = _formatDate(picked);
      });
    }
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return '${weekdays[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  Future<void> _pickFile() async {
    // File picker implementation would go here
    setState(() {
      _selectedFileName = 'evidence.pdf'; // Simulated
    });
  }

  void _submitComplaint() {
    if (_formKey.currentState!.validate()) {
      final complaint = Complaint(
        title: _complaintTitleController.text,
        category: _selectedCategory.isEmpty ? 'General' : _selectedCategory,
        description: _descriptionController.text,
        complaintFrom: _complainantNameController.text.trim(),
        date: DateTime.now().toString().split(' ')[0],
        status: 'Open',
      );

      widget.onComplaintSubmitted(complaint);
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Complaint submitted successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: const Text(
          'ADD COMPLAINT',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: _isLoading ? null : _submitComplaint,
            child: Text(
              'Submit',
              style: TextStyle(
                color: _isLoading ? Colors.grey : Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header line
              Container(
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),

              // Complainant Name
              _buildFormField(
                label: 'Complainant Name',
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextFormField(
                    controller: _complainantNameController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Complainant Role
              _buildFormField(
                label: 'Complainant Role',
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextFormField(
                    readOnly: true,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: const TextStyle(fontSize: 16),
                    initialValue: _selectedRole,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Date Of Complaint
              _buildFormField(
                label: 'Date Of Complaint',
                child: InkWell(
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) {
                      setState(() {
                        _selectedDate = date;
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        const Icon(
                          Icons.calendar_today,
                          size: 20,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Complaint Category
              _buildFormField(
                label: 'Complaint Category',
                child: DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: InputDecoration(
                    hintText: 'Input Text',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                  ),
                  items: _categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value!;
                    });
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Complaint Title
              _buildFormField(
                label: 'Complaint Title',
                child: TextFormField(
                  controller: _complaintTitleController,
                  decoration: InputDecoration(
                    hintText: 'Input Text',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter complaint title';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Description
              _buildFormField(
                label: 'Description',
                child: TextFormField(
                  controller: _descriptionController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Input Text',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter description';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Complaint Against
              _buildFormField(
                label: 'Complaint Against',
                child: DropdownButtonFormField<String>(
                  value: _selectedComplaintAgainst,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                  ),
                  items: _complaintAgainstOptions.map((option) {
                    return DropdownMenuItem(value: option, child: Text(option));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedComplaintAgainst = value!;
                    });
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Player/Coach/Club Names
              _buildFormField(
                label: 'Player/Coach/Club Names',
                child: TextFormField(
                  controller: _playerCoachClubController,
                  decoration: InputDecoration(
                    hintText: 'Q Player',
                    prefixIcon: const Icon(Icons.search, size: 20),
                    suffixIcon: const Icon(Icons.keyboard_arrow_down, size: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Upload Evidence
              _buildFormField(
                label: 'Upload Evidence (Optional)',
                child: InkWell(
                  onTap: () {
                    // Simulate file upload
                    setState(() {
                      _attachedFiles.add(
                        'Evidence_${_attachedFiles.length + 1}.pdf',
                      );
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.attach_file,
                          size: 20,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _attachedFiles.isEmpty
                              ? 'Attach Evidence'
                              : '${_attachedFiles.length} file(s) attached',
                          style: TextStyle(
                            color: _attachedFiles.isEmpty
                                ? Colors.grey
                                : Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Divider line
              Container(
                height: 2,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
              const SizedBox(height: 24),

              // Preferred Resolution
              _buildFormField(
                label: 'Preferred Resolution',
                child: DropdownButtonFormField<String>(
                  value: _selectedPreferredResolution,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                  ),
                  items: _preferredResolutionOptions.map((resolution) {
                    return DropdownMenuItem(
                      value: resolution,
                      child: Text(resolution),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedPreferredResolution = value!;
                    });
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Urgency Level
              _buildFormField(
                label: 'Urgency Level',
                child: DropdownButtonFormField<String>(
                  value: _selectedUrgencyLevel,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                  ),
                  items: _urgencyLevelOptions.map((urgency) {
                    return DropdownMenuItem(
                      value: urgency,
                      child: Text(urgency),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedUrgencyLevel = value!;
                    });
                  },
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormField({required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

class _ComplaintDetailsDialog extends StatelessWidget {
  final Complaint complaint;

  const _ComplaintDetailsDialog({required this.complaint});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 10,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.95,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color(0xFFFEF7F7), // Light pinkish background
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Color(0xFF1E40AF),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Complaint Details',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'ID: #${complaint.hashCode.toString().substring(0, 8)}',
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.white70,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 24,
                      ),
                      padding: const EdgeInsets.all(8),
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: complaint.status == 'Open'
                            ? const Color(0xFF414384).withValues(alpha: 0.15)
                            : Colors.green.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: complaint.status == 'Open'
                              ? const Color(0xFF414384)
                              : Colors.green,
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color:
                                (complaint.status == 'Open'
                                        ? const Color(0xFF414384)
                                        : Colors.green)
                                    .withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            complaint.status == 'Open'
                                ? Icons.schedule_rounded
                                : Icons.check_circle_rounded,
                            size: 18,
                            color: complaint.status == 'Open'
                                ? const Color(0xFF414384)
                                : Colors.green,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            complaint.status,
                            style: TextStyle(
                              color: complaint.status == 'Open'
                                  ? const Color(0xFF414384)
                                  : Colors.green,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Title
                    _buildDetailField('Title', complaint.title),
                    const SizedBox(height: 16),

                    // Category
                    _buildDetailField('Category', complaint.category),
                    const SizedBox(height: 16),

                    // Description
                    _buildDetailField(
                      'Description',
                      complaint.description,
                      isMultiline: true,
                    ),
                    const SizedBox(height: 16),

                    // Complaint From
                    _buildDetailField(
                      'Complaint From',
                      complaint.complaintFrom,
                    ),
                    const SizedBox(height: 16),

                    // Date
                    _buildDetailField('Date', complaint.date),
                    const SizedBox(height: 16),

                    // Additional Information
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFE5E7EB),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF1E40AF,
                                  ).withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Icon(
                                  Icons.info_outline,
                                  size: 16,
                                  color: Color(0xFF1E40AF),
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'Additional Information',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1F2937),
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF6B7280,
                                  ).withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Icon(
                                  Icons.access_time_rounded,
                                  size: 16,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Created: ${complaint.date}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF6B7280),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF6B7280,
                                  ).withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Icon(
                                  Icons.category_rounded,
                                  size: 16,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Category: ${complaint.category}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF6B7280),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: const BorderSide(
                                  color: Color(0xFFD1D5DB),
                                  width: 1.5,
                                ),
                              ),
                              side: const BorderSide(
                                color: Color(0xFFD1D5DB),
                                width: 1.5,
                              ),
                            ),
                            child: const Text(
                              'Close',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF374151),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              // Add action for responding to complaint
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Response feature coming soon!',
                                  ),
                                  backgroundColor: Colors.blue,
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(
                                0xFF232534,
                              ), // Coach gradient start
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 3,
                              shadowColor: const Color(
                                0xFF1E40AF,
                              ).withValues(alpha: 0.3),
                            ),
                            child: const Text(
                              'Respond',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailField(
    String label,
    String value, {
    bool isMultiline = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1F2937),
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFD1D5DB), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 15,
              color: const Color(0xFF1F2937),
              height: isMultiline ? 1.5 : 1.3,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

// View Complaint Screen - Full Screen Implementation
class ViewComplaintScreen extends StatefulWidget {
  final Complaint complaint;

  const ViewComplaintScreen({super.key, required this.complaint});

  @override
  State<ViewComplaintScreen> createState() => _ViewComplaintScreenState();
}

class _ViewComplaintScreenState extends State<ViewComplaintScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    // Add initial admin message
    _messages.add(
      ChatMessage(
        text:
            'Hello! I\'m here to help you with your complaint. How can I assist you today?',
        isAdmin: true,
        timestamp: DateTime.now(),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    if (!mounted) return;

    try {
      setState(() {
        _messages.add(
          ChatMessage(
            text: _messageController.text.trim(),
            isAdmin: false,
            timestamp: DateTime.now(),
          ),
        );
      });

      _messageController.clear();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error sending message: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: Text(
          'Complaint #${widget.complaint.hashCode.toString().substring(0, 8)}',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              // Add more actions if needed
            },
            icon: const Icon(Icons.more_vert, color: Colors.black),
          ),
        ],
      ),
      body: Column(
        children: [
          // Complaint Details Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.complaint.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Status: ${widget.complaint.status}',
                  style: TextStyle(
                    fontSize: 14,
                    color: widget.complaint.status == 'Open'
                        ? const Color(0xFF414384)
                        : Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Category: ${widget.complaint.category}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),

          // Chat Messages
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildChatBubble(message);
              },
            ),
          ),

          // Message Input
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey[200]!)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    maxLines: null,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: const Color(0xFF1E40AF),
                  child: IconButton(
                    onPressed: _sendMessage,
                    icon: const Icon(Icons.send, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatBubble(ChatMessage message) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: message.isAdmin
            ? MainAxisAlignment.start
            : MainAxisAlignment.end,
        children: [
          if (message.isAdmin) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.grey[300],
              child: const Icon(Icons.person, size: 16, color: Colors.white),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: message.isAdmin
                    ? Colors.grey[200]
                    : const Color(0xFF1E40AF),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: TextStyle(
                      color: message.isAdmin ? Colors.black : Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${message.timestamp.hour.toString().padLeft(2, '0')}:${message.timestamp.minute.toString().padLeft(2, '0')}',
                    style: TextStyle(
                      color: message.isAdmin
                          ? Colors.grey[600]
                          : Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (!message.isAdmin) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFF1E40AF),
              child: const Icon(Icons.person, size: 16, color: Colors.white),
            ),
          ],
        ],
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isAdmin;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isAdmin,
    required this.timestamp,
  });
}
