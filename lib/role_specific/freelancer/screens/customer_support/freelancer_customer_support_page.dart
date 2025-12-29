import 'package:flutter/material.dart';
import 'package:smart_sports/shared/widgets/role_sidebar.dart';
import 'package:smart_sports/role_specific/common/role_router.dart';
import 'package:smart_sports/shared/navigation/role_navigation_manager.dart';

class FreelancerCustomerSupportPage extends StatefulWidget {
  const FreelancerCustomerSupportPage({super.key});

  @override
  State<FreelancerCustomerSupportPage> createState() =>
      _FreelancerCustomerSupportPageState();
}

class _FreelancerCustomerSupportPageState
    extends State<FreelancerCustomerSupportPage> {
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

  final List<FreelancerComplaint> _complaints = [
    FreelancerComplaint(
      title: 'Used Offensive Language',
      category: 'Behavior',
      description: 'You Used Inappropriate Language During The Semi-Final Match.',
      complaintFrom: 'Opponent Player',
      date: '2025-04-10',
      status: 'Open',
    ),
    FreelancerComplaint(
      title: 'Late Arrival For Team Match',
      category: 'Discipline',
      description: 'H You Arrived 20 Minutes Late And Caused Team Formation Issues.',
      complaintFrom: 'Team Manager',
      date: '2025-04-11',
      status: 'Open',
    ),
    FreelancerComplaint(
      title: 'Equipment Damage',
      category: 'Property',
      description: 'Damaged court equipment during practice session.',
      complaintFrom: 'Facility Manager',
      date: '2025-04-12',
      status: 'Resolved',
    ),
    FreelancerComplaint(
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
        builder: (context) => FreelancerAddComplaintScreen(
          onComplaintSubmitted: (complaint) {
            setState(() {
              _complaints.add(complaint);
            });
          },
        ),
      ),
    );
  }

  void _showViewComplaintScreen(FreelancerComplaint complaint) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FreelancerViewComplaintScreen(complaint: complaint),
      ),
    );
  }

  void _showComplaintDetails(FreelancerComplaint complaint) {
    showDialog(
      context: context,
      builder: (context) => _FreelancerComplaintDetailsDialog(complaint: complaint),
    );
  }

  List<FreelancerComplaint> get _filteredComplaints {
    return _complaints.where((complaint) {
      if (_selectedTab == 'Open' && complaint.status != 'Open') return false;
      if (_selectedTab == 'Resolved' && complaint.status == 'Open') return false;
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
            role: UserRole.freelancer,
            selectedIndex: 9,
            edgeToEdge: true,
            onSelectIndex: (i) => RoleNavigationManager.navigateToScreen(
              context,
              UserRole.freelancer,
              i,
            ),
            onProfileTap: () => RoleNavigationManager.navigateToProfile(
              context,
              UserRole.freelancer,
            ),
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
              colors: [Color(0xFF007BFF), Color(0xFF0056CC)],
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
          IconButton(
            onPressed: () {
              setState(() {
                _showFilters = !_showFilters;
              });
            },
            icon: Icon(
              _showFilters ? Icons.filter_list_off : Icons.filter_list,
              color: Colors.white,
            ),
            tooltip: _showFilters ? 'Hide Filters' : 'Show Filters',
          ),
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: ElevatedButton(
              onPressed: _showRaiseComplaintDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF007BFF),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                minimumSize: const Size(0, 32),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, size: 14),
                  SizedBox(width: 2),
                  Text(
                    'Raise',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
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

          // Filter section
          if (_showFilters)
            Container(
              color: const Color(0xFF2D3748),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
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
                          prefixIcon: Icon(Icons.search, color: Color(0xFF6B7280)),
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
                  style: const TextStyle(color: Color(0xFF1F2937), fontSize: 14),
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
          color: isSelected ? const Color(0xFF007BFF) : Colors.transparent,
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

  Widget _buildComplaintCard(FreelancerComplaint complaint) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
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
                  color: const Color(0xFF007BFF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  complaint.status,
                  style: const TextStyle(
                    color: Color(0xFF007BFF),
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
                    backgroundColor: const Color(0xFF007BFF),
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
}

// Complaint Model
class FreelancerComplaint {
  final String title;
  final String category;
  final String description;
  final String complaintFrom;
  final String date;
  final String status;

  FreelancerComplaint({
    required this.title,
    required this.category,
    required this.description,
    required this.complaintFrom,
    required this.date,
    required this.status,
  });
}

// Add Complaint Screen
class FreelancerAddComplaintScreen extends StatefulWidget {
  final Function(FreelancerComplaint) onComplaintSubmitted;

  const FreelancerAddComplaintScreen({super.key, required this.onComplaintSubmitted});

  @override
  State<FreelancerAddComplaintScreen> createState() =>
      _FreelancerAddComplaintScreenState();
}

class _FreelancerAddComplaintScreenState
    extends State<FreelancerAddComplaintScreen> {
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
  String _dateOfComplaint = 'Wed, March 5, 2025';
  String? _selectedFileName;

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

  final List<String> _urgencyLevelOptions = [
    'High',
    'Medium',
    'Low',
  ];

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
      'Dec'
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
      final complaint = FreelancerComplaint(
        title: _complaintTitleController.text,
        category: _selectedCategory.isEmpty ? 'General' : _selectedCategory,
        description: _descriptionController.text,
        complaintFrom: 'Freelancer',
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
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header Section with Segment Control
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 12 : 16,
                vertical: isMobile ? 8 : 12,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Row(
                children: [
                  // Back Button
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Color(0xFF1F2937),
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    iconSize: 24,
                  ),
                  SizedBox(width: isMobile ? 8 : 12),
                  // Segment Control: ADD COMPLAINT (Selected)
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: isMobile ? 10 : 12,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE3F2FD),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFF2196F3),
                          width: 2,
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'ADD COMPLAINT',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Segment Control: Cancel (Unselected)
                  Expanded(
                    child: InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: isMobile ? 10 : 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFF1F2937),
                            width: 1,
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Submit Button
                  ElevatedButton(
                    onPressed: _submitComplaint,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF009A69),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 16 : 24,
                        vertical: isMobile ? 10 : 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Submit',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Form Content
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.all(isMobile ? 16 : 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Two Column Layout for first row
                      if (isMobile)
                        Column(
                          children: [
                            _buildFormField(
                              label: 'Complainant Name',
                              child: TextFormField(
                                controller: _complainantNameController,
                                decoration: InputDecoration(
                                  hintText: 'Coach Name',
                                  filled: true,
                                  fillColor: const Color(0xFFF3F4F6),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: EdgeInsets.all(isMobile ? 14 : 16),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildFormField(
                              label: 'Complainant Role',
                              child: DropdownButtonFormField<String>(
                                value: _selectedComplainantRole.isEmpty
                                    ? null
                                    : _selectedComplainantRole,
                                decoration: InputDecoration(
                                  hintText: 'Coach',
                                  filled: true,
                                  fillColor: const Color(0xFFF3F4F6),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: EdgeInsets.all(isMobile ? 14 : 16),
                                  suffixIcon: const Icon(Icons.arrow_drop_down),
                                ),
                                items: _complainantRoleOptions
                                    .map((role) => DropdownMenuItem(
                                          value: role,
                                          child: Text(role),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedComplainantRole = value ?? '';
                                  });
                                },
                              ),
                            ),
                          ],
                        )
                      else
                        Row(
                          children: [
                            Expanded(
                              child: _buildFormField(
                                label: 'Complainant Name',
                                child: TextFormField(
                                  controller: _complainantNameController,
                                  decoration: InputDecoration(
                                    hintText: 'Coach Name',
                                    filled: true,
                                    fillColor: const Color(0xFFF3F4F6),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: EdgeInsets.all(isMobile ? 14 : 16),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildFormField(
                                label: 'Complainant Role',
                                child: DropdownButtonFormField<String>(
                                  value: _selectedComplainantRole.isEmpty
                                      ? null
                                      : _selectedComplainantRole,
                                  decoration: InputDecoration(
                                    hintText: 'Coach',
                                    filled: true,
                                    fillColor: const Color(0xFFF3F4F6),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: EdgeInsets.all(isMobile ? 14 : 16),
                                  ),
                                  items: _complainantRoleOptions
                                      .map((role) => DropdownMenuItem(
                                            value: role,
                                            child: Text(role),
                                          ))
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedComplainantRole = value ?? '';
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 16),

                      // Date Of Complaint
                      _buildFormField(
                        label: 'Date Of Complaint',
                        child: InkWell(
                          onTap: _selectDate,
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFFE5E7EB),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    _dateOfComplaint,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF1F2937),
                                    ),
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
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Two Column Layout for Complaint Category and Complaint Against
                      if (isMobile)
                        Column(
                          children: [
                            _buildFormField(
                              label: 'Complaint Category',
                              child: DropdownButtonFormField<String>(
                                value: _selectedCategory.isEmpty
                                    ? null
                                    : _selectedCategory,
                                decoration: InputDecoration(
                                  hintText: 'Input Text',
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: Color(0xFFE5E7EB),
                                    ),
                                  ),
                                  contentPadding: EdgeInsets.all(isMobile ? 14 : 16),
                                  suffixIcon: const Icon(Icons.arrow_drop_down),
                                ),
                                items: _categories
                                    .map((category) => DropdownMenuItem(
                                          value: category,
                                          child: Text(category),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedCategory = value ?? '';
                                  });
                                },
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildFormField(
                              label: 'Complaint Against',
                              child: DropdownButtonFormField<String>(
                                value: _selectedComplaintAgainst,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: Color(0xFFE5E7EB),
                                    ),
                                  ),
                                  contentPadding: EdgeInsets.all(isMobile ? 14 : 16),
                                  suffixIcon: const Icon(Icons.arrow_drop_down),
                                ),
                                items: _complaintAgainstOptions
                                    .map((option) => DropdownMenuItem(
                                          value: option,
                                          child: Text(option),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedComplaintAgainst = value ?? '';
                                  });
                                },
                              ),
                            ),
                          ],
                        )
                      else
                        Row(
                          children: [
                            Expanded(
                              child: _buildFormField(
                                label: 'Complaint Category',
                                child: DropdownButtonFormField<String>(
                                  value: _selectedCategory.isEmpty
                                      ? null
                                      : _selectedCategory,
                                  decoration: InputDecoration(
                                    hintText: 'Input Text',
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        color: Color(0xFFE5E7EB),
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.all(isMobile ? 14 : 16),
                                    suffixIcon:
                                        const Icon(Icons.arrow_drop_down),
                                  ),
                                  items: _categories
                                      .map((category) => DropdownMenuItem(
                                            value: category,
                                            child: Text(category),
                                          ))
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedCategory = value ?? '';
                                    });
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildFormField(
                                label: 'Complaint Against',
                                child: DropdownButtonFormField<String>(
                                  value: _selectedComplaintAgainst,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        color: Color(0xFFE5E7EB),
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.all(isMobile ? 14 : 16),
                                    suffixIcon:
                                        const Icon(Icons.arrow_drop_down),
                                  ),
                                  items: _complaintAgainstOptions
                                      .map((option) => DropdownMenuItem(
                                            value: option,
                                            child: Text(option),
                                          ))
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedComplaintAgainst = value ?? '';
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 12),

                      // Complaint Title (Full Width)
                      _buildFormField(
                        label: 'Complaint Title',
                        child: TextFormField(
                          controller: _complaintTitleController,
                          decoration: InputDecoration(
                            hintText: 'Input Text',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFFE5E7EB),
                              ),
                            ),
                            contentPadding: const EdgeInsets.all(16),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter a complaint title';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Description (Full Width, Multi-line)
                      _buildFormField(
                        label: 'Description',
                        child: TextFormField(
                          controller: _descriptionController,
                          maxLines: 5,
                          decoration: InputDecoration(
                            hintText: 'Input Text',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFFE5E7EB),
                              ),
                            ),
                            contentPadding: const EdgeInsets.all(16),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter a description';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Player/Coach/Club Names
                      _buildFormField(
                        label: 'Player/Coach/Club Names',
                        child: TextFormField(
                          controller: _playerCoachClubController,
                          decoration: InputDecoration(
                            hintText: 'Player',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFFE5E7EB),
                              ),
                            ),
                            contentPadding: const EdgeInsets.all(16),
                            prefixIcon: const Icon(
                              Icons.search,
                              color: Color(0xFF6B7280),
                            ),
                            suffixIcon: const Icon(
                              Icons.arrow_drop_down,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Upload Evidence (Optional)
                      _buildFormField(
                        label: 'Upload Evidence (Optional)',
                        child: InkWell(
                          onTap: _pickFile,
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFFE5E7EB),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    _selectedFileName ?? 'Attach Evidence',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: _selectedFileName != null
                                          ? const Color(0xFF1F2937)
                                          : const Color(0xFF6B7280),
                                    ),
                                  ),
                                ),
                                const Icon(
                                  Icons.attach_file,
                                  color: Color(0xFF6B7280),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Two Column Layout for Preferred Resolution and Urgency Level
                      if (isMobile)
                        Column(
                          children: [
                            _buildFormField(
                              label: 'Preferred Resolution',
                              child: DropdownButtonFormField<String>(
                                value: _selectedPreferredResolution,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: Color(0xFFE5E7EB),
                                    ),
                                  ),
                                  contentPadding: EdgeInsets.all(isMobile ? 14 : 16),
                                  suffixIcon: const Icon(Icons.arrow_drop_down),
                                ),
                                items: _preferredResolutionOptions
                                    .map((option) => DropdownMenuItem(
                                          value: option,
                                          child: Text(option),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedPreferredResolution = value ?? '';
                                  });
                                },
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildFormField(
                              label: 'Urgency Level',
                              child: DropdownButtonFormField<String>(
                                value: _selectedUrgencyLevel,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: Color(0xFFE5E7EB),
                                    ),
                                  ),
                                  contentPadding: EdgeInsets.all(isMobile ? 14 : 16),
                                  suffixIcon: const Icon(Icons.arrow_drop_down),
                                ),
                                items: _urgencyLevelOptions
                                    .map((option) => DropdownMenuItem(
                                          value: option,
                                          child: Text(option),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedUrgencyLevel = value ?? '';
                                  });
                                },
                              ),
                            ),
                          ],
                        )
                      else
                        Row(
                          children: [
                            Expanded(
                              child: _buildFormField(
                                label: 'Preferred Resolution',
                                child: DropdownButtonFormField<String>(
                                  value: _selectedPreferredResolution,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        color: Color(0xFFE5E7EB),
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.all(isMobile ? 14 : 16),
                                    suffixIcon:
                                        const Icon(Icons.arrow_drop_down),
                                  ),
                                  items: _preferredResolutionOptions
                                      .map((option) => DropdownMenuItem(
                                            value: option,
                                            child: Text(option),
                                          ))
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedPreferredResolution = value ?? '';
                                    });
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildFormField(
                                label: 'Urgency Level',
                                child: DropdownButtonFormField<String>(
                                  value: _selectedUrgencyLevel,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        color: Color(0xFFE5E7EB),
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.all(isMobile ? 14 : 16),
                                    suffixIcon:
                                        const Icon(Icons.arrow_drop_down),
                                  ),
                                  items: _urgencyLevelOptions
                                      .map((option) => DropdownMenuItem(
                                            value: option,
                                            child: Text(option),
                                          ))
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedUrgencyLevel = value ?? '';
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
              ),
            ),
          ),
        ],
        ),
      ),
    );
  }

  Widget _buildFormField({required String label, required Widget child}) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isMobile ? 13 : 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1F2937),
          ),
        ),
        SizedBox(height: isMobile ? 6 : 8),
        child,
      ],
    );
  }
}

// View Complaint Screen
class FreelancerViewComplaintScreen extends StatefulWidget {
  final FreelancerComplaint complaint;

  const FreelancerViewComplaintScreen({super.key, required this.complaint});

  @override
  State<FreelancerViewComplaintScreen> createState() =>
      _FreelancerViewComplaintScreenState();
}

class _FreelancerViewComplaintScreenState
    extends State<FreelancerViewComplaintScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<FreelancerChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _messages.add(
      FreelancerChatMessage(
        text: 'Hello! I\'m here to help you with your complaint. How can I assist you today?',
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
    setState(() {
      _messages.add(
        FreelancerChatMessage(
          text: _messageController.text.trim(),
          isAdmin: false,
          timestamp: DateTime.now(),
        ),
      );
    });
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Complaint #${widget.complaint.hashCode.toString().substring(0, 8)}'),
        backgroundColor: const Color(0xFF007BFF),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
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
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Status: ${widget.complaint.status}',
                  style: TextStyle(
                    fontSize: 14,
                    color: widget.complaint.status == 'Open'
                        ? Colors.orange
                        : Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
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
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: const Color(0xFF007BFF),
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

  Widget _buildChatBubble(FreelancerChatMessage message) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment:
            message.isAdmin ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (message.isAdmin) ...[
            const CircleAvatar(
              radius: 16,
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, size: 16, color: Colors.white),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: message.isAdmin
                    ? Colors.grey[200]
                    : const Color(0xFF007BFF),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: message.isAdmin ? Colors.black : Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          if (!message.isAdmin) ...[
            const SizedBox(width: 8),
            const CircleAvatar(
              radius: 16,
              backgroundColor: Color(0xFF007BFF),
              child: Icon(Icons.person, size: 16, color: Colors.white),
            ),
          ],
        ],
      ),
    );
  }
}

// Chat Message Model
class FreelancerChatMessage {
  final String text;
  final bool isAdmin;
  final DateTime timestamp;

  FreelancerChatMessage({
    required this.text,
    required this.isAdmin,
    required this.timestamp,
  });
}

// Complaint Details Dialog
class _FreelancerComplaintDetailsDialog extends StatelessWidget {
  final FreelancerComplaint complaint;

  const _FreelancerComplaintDetailsDialog({required this.complaint});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.95,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Color(0xFF007BFF),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  const Text(
                    'Complaint Details',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailField('Title', complaint.title),
                    const SizedBox(height: 16),
                    _buildDetailField('Category', complaint.category),
                    const SizedBox(height: 16),
                    _buildDetailField('Description', complaint.description, isMultiline: true),
                    const SizedBox(height: 16),
                    _buildDetailField('From', complaint.complaintFrom),
                    const SizedBox(height: 16),
                    _buildDetailField('Date', complaint.date),
                    const SizedBox(height: 16),
                    _buildDetailField('Status', complaint.status),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailField(String label, String value, {bool isMultiline = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1F2937),
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
          ),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF1F2937),
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
