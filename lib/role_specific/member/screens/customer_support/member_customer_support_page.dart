import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_sports/shared/widgets/role_sidebar.dart';
import 'package:smart_sports/role_specific/common/role_router.dart';
import 'package:smart_sports/shared/navigation/role_navigation_manager.dart';
import 'package:smart_sports/core/utils/auth_utils.dart';

class MemberCustomerSupportPage extends ConsumerStatefulWidget {
  const MemberCustomerSupportPage({super.key});

  @override
  ConsumerState<MemberCustomerSupportPage> createState() =>
      _MemberCustomerSupportPageState();
}

class _MemberCustomerSupportPageState
    extends ConsumerState<MemberCustomerSupportPage> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _titleSearchController = TextEditingController();
  String _selectedStatus = 'Select';
  String _selectedDay = 'Select';
  String _selectedTab = 'Open';
  bool _showFilters = false;

  String _startDate = 'Wed, March 5, 2025';
  String _endDate = 'Wed, March 5, 2025';
  String _startTime = 'HH:MM';
  String _endTime = 'HH:MM';

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

  final List<MemberComplaint> _complaints = [
    MemberComplaint(
      title: 'Booking Cancellation Issue',
      category: 'Booking',
      description:
          'I am unable to cancel my booking for the court reservation on March 15th.',
      complaintFrom: 'Member',
      date: '2025-03-10',
      status: 'Open',
    ),
    MemberComplaint(
      title: 'Payment Refund Request',
      category: 'Payment',
      description: 'Requesting refund for cancelled event registration.',
      complaintFrom: 'Member',
      date: '2025-03-08',
      status: 'Resolved',
    ),
    MemberComplaint(
      title: 'Account Update Problem',
      category: 'Account',
      description: 'Cannot update my profile information and preferences.',
      complaintFrom: 'Member',
      date: '2025-03-09',
      status: 'In Progress',
    ),
    MemberComplaint(
      title: 'Event Registration Error',
      category: 'Event',
      description: 'Unable to register for the upcoming tournament.',
      complaintFrom: 'Member',
      date: '2025-03-11',
      status: 'Open',
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
        builder: (context) => _AddComplaintScreen(
          onComplaintSubmitted: (complaint) {
            setState(() {
              _complaints.add(complaint);
            });
          },
        ),
      ),
    );
  }

  void _showViewComplaintScreen(MemberComplaint complaint) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _ViewComplaintScreen(complaint: complaint),
      ),
    );
  }

  List<MemberComplaint> get _filteredComplaints {
    List<MemberComplaint> filtered = _complaints.where((complaint) {
      if (_selectedTab == 'Open' && complaint.status != 'Open') return false;
      if (_selectedTab == 'Resolved' && complaint.status == 'Open')
        return false;
      return true;
    }).toList();

    // Apply search filter
    if (_searchController.text.isNotEmpty) {
      filtered = filtered.where((complaint) {
        return complaint.title
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()) ||
            complaint.description
                .toLowerCase()
                .contains(_searchController.text.toLowerCase());
      }).toList();
    }

    // Apply title search filter
    if (_titleSearchController.text.isNotEmpty) {
      filtered = filtered.where((complaint) {
        return complaint.title
            .toLowerCase()
            .contains(_titleSearchController.text.toLowerCase());
      }).toList();
    }

    // Apply status filter
    if (_selectedStatus != 'Select') {
      filtered = filtered
          .where((complaint) => complaint.status == _selectedStatus)
          .toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      drawer: Drawer(
        elevation: 0,
        child: SafeArea(
          child: RoleSidebar(
            role: UserRole.member,
            selectedIndex: 8,
            edgeToEdge: true,
            onSelectIndex: (i) => RoleNavigationManager.navigateToScreen(
              context,
              UserRole.member,
              i,
            ),
            onProfileTap: () => RoleNavigationManager.navigateToProfile(
              context,
              UserRole.member,
            ),
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
                        Navigator.of(dialogContext).pop();
                        AuthUtils.handleLogout(context, ref);
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
        automaticallyImplyLeading: false,
        title: const Text(
          'Customer Support',
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
              color: Colors.white,
            ),
            tooltip: _showFilters ? 'Hide Filters' : 'Show Filters',
          ),
          // Raise Complaint Button
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: ElevatedButton(
              onPressed: _showRaiseComplaintDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF009A69),
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
                    onChanged: (_) => setState(() {}),
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
                        onChanged: (_) => setState(() {}),
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
                          child: _buildDateField(_startDate, (date) {
                            setState(() {
                              _startDate = date;
                            });
                          }),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildDateField(_endDate, (date) {
                            setState(() {
                              _endDate = date;
                            });
                          }),
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
                          child: _buildTimeField(_startTime, (time) {
                            setState(() {
                              _startTime = time;
                            });
                          }),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildTimeField(_endTime, (time) {
                            setState(() {
                              _endTime = time;
                            });
                          }),
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

                  // Complaints list
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

  Widget _buildDateField(String value, Function(String) onDateSelected) {
    return InkWell(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
        );
        if (picked != null) {
          final formatted = _formatDate(picked);
          onDateSelected(formatted);
        }
      },
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

  Widget _buildTimeField(String value, Function(String) onTimeSelected) {
    return InkWell(
      onTap: () async {
        final TimeOfDay? picked = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (picked != null) {
          final formatted =
              '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
          onTimeSelected(formatted);
        }
      },
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
          color: isSelected ? const Color(0xFF009A69) : Colors.transparent,
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

  Widget _buildComplaintCard(MemberComplaint complaint) {
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
                  color: _getStatusColor(complaint.status)
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  complaint.status,
                  style: TextStyle(
                    color: _getStatusColor(complaint.status),
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
                    backgroundColor: const Color(0xFF009A69),
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

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Open':
        return Colors.orange;
      case 'In Progress':
        return const Color(0xFF009A69);
      case 'Resolved':
        return Colors.green;
      case 'Closed':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  void _showComplaintDetails(MemberComplaint complaint) {
    showDialog(
      context: context,
      builder: (context) => _ComplaintDetailsDialog(complaint: complaint),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
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
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return '${weekdays[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

class MemberComplaint {
  final String title;
  final String category;
  final String description;
  final String complaintFrom;
  final String date;
  final String status;

  MemberComplaint({
    required this.title,
    required this.category,
    required this.description,
    required this.complaintFrom,
    required this.date,
    required this.status,
  });
}

// Complaint Details Dialog
class _ComplaintDetailsDialog extends StatelessWidget {
  final MemberComplaint complaint;

  const _ComplaintDetailsDialog({required this.complaint});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    complaint.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildDetailRow('Category', complaint.category),
            const SizedBox(height: 12),
            _buildDetailRow('Status', complaint.status),
            const SizedBox(height: 12),
            _buildDetailRow('Date', complaint.date),
            const SizedBox(height: 12),
            _buildDetailRow('From', complaint.complaintFrom),
            const SizedBox(height: 12),
            const Text(
              'Description',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              complaint.description,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF374151),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Close'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            '$label:',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF6B7280),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF1F2937),
            ),
          ),
        ),
      ],
    );
  }
}

// Add Complaint Screen
class _AddComplaintScreen extends StatefulWidget {
  final Function(MemberComplaint) onComplaintSubmitted;

  const _AddComplaintScreen({required this.onComplaintSubmitted});

  @override
  State<_AddComplaintScreen> createState() => _AddComplaintScreenState();
}

class _AddComplaintScreenState extends State<_AddComplaintScreen> {
  final _formKey = GlobalKey<FormState>();
  final _complaintTitleController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _selectedCategory = 'Booking';

  final List<String> _categories = [
    'Booking',
    'Payment',
    'Account',
    'Event',
    'General',
  ];

  @override
  void dispose() {
    _complaintTitleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitComplaint() {
    if (_formKey.currentState!.validate()) {
      final complaint = MemberComplaint(
        title: _complaintTitleController.text,
        category: _selectedCategory,
        description: _descriptionController.text,
        complaintFrom: 'Member',
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Raise Complaint'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFormField(
                label: 'Category',
                child: DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
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
              _buildFormField(
                label: 'Title',
                child: TextFormField(
                  controller: _complaintTitleController,
                  decoration: InputDecoration(
                    hintText: 'Enter complaint title',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),
              _buildFormField(
                label: 'Description',
                child: TextFormField(
                  controller: _descriptionController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Describe your complaint in detail',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
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
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _submitComplaint,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF009A69),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Submit'),
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

  Widget _buildFormField({required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

// View Complaint Screen with Chat
class _ViewComplaintScreen extends StatefulWidget {
  final MemberComplaint complaint;

  const _ViewComplaintScreen({required this.complaint});

  @override
  State<_ViewComplaintScreen> createState() => _ViewComplaintScreenState();
}

class _ViewComplaintScreenState extends State<_ViewComplaintScreen> {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(widget.complaint.title),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          // Complaint Info Card
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.complaint.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                    ),
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getStatusColor(widget.complaint.status)
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        widget.complaint.status,
                        style: TextStyle(
                          color: _getStatusColor(widget.complaint.status),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Category: ${widget.complaint.category}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Date: ${widget.complaint.date}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  widget.complaint.description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF374151),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Chat Messages
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildMessageBubble(message);
              },
            ),
          ),

          // Message Input
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _sendMessage,
                  icon: const Icon(Icons.send),
                  color: const Color(0xFF009A69),
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFF009A69).withOpacity(0.1),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Align(
      alignment: message.isAdmin ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: message.isAdmin
              ? Colors.grey.shade200
              : const Color(0xFF009A69),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: TextStyle(
                color: message.isAdmin ? Colors.black87 : Colors.white,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${message.timestamp.hour}:${message.timestamp.minute.toString().padLeft(2, '0')}',
              style: TextStyle(
                color: message.isAdmin
                    ? Colors.grey.shade600
                    : Colors.white70,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Open':
        return Colors.orange;
      case 'In Progress':
        return const Color(0xFF009A69);
      case 'Resolved':
        return Colors.green;
      case 'Closed':
        return Colors.grey;
      default:
        return Colors.grey;
    }
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
