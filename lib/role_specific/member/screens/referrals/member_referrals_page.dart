import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_sports/shared/widgets/role_sidebar.dart';
import 'package:smart_sports/role_specific/common/role_router.dart';
import 'package:smart_sports/shared/navigation/role_navigation_manager.dart';

class MemberReferralsPage extends StatefulWidget {
  const MemberReferralsPage({super.key});

  @override
  State<MemberReferralsPage> createState() => _MemberReferralsPageState();
}

class _MemberReferralsPageState extends State<MemberReferralsPage> {
  List<MemberReferral> _allReferrals = [];
  List<MemberReferral> _filteredReferrals = [];
  String _searchQuery = '';
  int _currentPage = 1;
  final int _itemsPerPage = 10;

  // Filter states
  String _selectedStatus = 'Select';
  String _selectedDay = 'Select';
  bool _showFilters = false;
  String _startDate = 'Wed, March 5, 2025';
  String _endDate = 'Wed, March 5, 2025';
  String _startTime = 'HH:MM';
  String _endTime = 'HH:MM';

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadReferrals();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadReferrals() {
    setState(() {
      _allReferrals = _getMockReferrals();
      _applyFilters();
    });
  }

  void _applyFilters() {
    List<MemberReferral> referrals = List.from(_allReferrals);

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      referrals = referrals.where((referral) {
        return referral.referralName.toLowerCase().contains(
              _searchQuery.toLowerCase(),
            ) ||
            referral.referralEmail.toLowerCase().contains(
              _searchQuery.toLowerCase(),
            ) ||
            referral.referredBy.toLowerCase().contains(
              _searchQuery.toLowerCase(),
            );
      }).toList();
    }

    // Apply status filter
    if (_selectedStatus != 'Select') {
      referrals = referrals
          .where((referral) => referral.status == _selectedStatus)
          .toList();
    }

    // Apply day filter
    if (_selectedDay != 'Select') {
      // Implement day filtering logic here
      // For now, we'll keep all referrals regardless of day
    }

    setState(() {
      _filteredReferrals = referrals;
    });
  }

  void _showInviteReferralDialog() {
    showDialog(
      context: context,
      builder: (context) => const _InviteReferralDialog(),
    );
  }

  List<MemberReferral> _getMockReferrals() {
    return List.generate(25, (index) {
      return MemberReferral(
        referralName: 'Stan Proko',
        referralEmail: 'Jhon@Gmail.Com',
        referredBy: 'Anthony',
        referredDate: '01/02/2021',
        status: index < 5 ? 'Subscribed' : 'Un-Subscribed',
        subscribedDate: '01/02/2021',
        referralLink: 'Www.Refferal_link',
      );
    });
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
            selectedIndex: 6,
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
          ),
        ),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Referrals',
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
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
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
          // Invite Referral Button
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: ElevatedButton.icon(
              onPressed: _showInviteReferralDialog,
              icon: const Icon(Icons.person_add, size: 18),
              label: const Text(
                'Invite',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF009A69),
                elevation: 2,
                shadowColor: Colors.black26,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                minimumSize: const Size(80, 36),
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
            child: Container(
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
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                  _applyFilters();
                },
                decoration: const InputDecoration(
                  hintText: 'Search referrals...',
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
          ),

          // Filter section - Only show when toggled
          if (_showFilters)
            Container(
              color: Colors.grey.shade800,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Title Row
                  _buildFilterRow(
                    label: 'Title',
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search',
                          hintStyle: GoogleFonts.poppins(fontSize: 12),
                          prefixIcon: const Icon(Icons.search, size: 18),
                          suffixIcon: const Icon(Icons.filter_list, size: 18),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Date Range Row
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
                  // Time Row
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
                  // Days and Status Row
                  Row(
                    children: [
                      Expanded(
                        child: _buildFilterRow(
                          label: 'Days',
                          child: _buildDropdownField(
                            _selectedDay,
                            [
                              'Select',
                              'Monday',
                              'Tuesday',
                              'Wednesday',
                              'Thursday',
                              'Friday',
                              'Saturday',
                              'Sunday',
                            ],
                            (value) {
                              setState(() {
                                _selectedDay = value ?? 'Select';
                              });
                              _applyFilters();
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildFilterRow(
                          label: 'Status',
                          child: _buildDropdownField(
                            _selectedStatus,
                            [
                              'Select',
                              'Subscribed',
                              'Un-Subscribed',
                              'Pending',
                            ],
                            (value) {
                              setState(() {
                                _selectedStatus = value ?? 'Select';
                              });
                              _applyFilters();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

          // Referrals list
          Expanded(
            child: _filteredReferrals.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.people_outline,
                          size: 64,
                          color: Color(0xFF9CA3AF),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No referrals found',
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
                    itemCount: _filteredReferrals.length,
                    itemBuilder: (context, index) {
                      final referral = _filteredReferrals[index];
                      return _MemberReferralCard(
                        referral: referral,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Tapped on ${referral.referralName}',
                              ),
                              backgroundColor: const Color(0xFF009A69),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),

          // Pagination
          if (_filteredReferrals.length > _itemsPerPage)
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Showing ${(_currentPage - 1) * _itemsPerPage + 1} to ${(_currentPage * _itemsPerPage).clamp(0, _filteredReferrals.length)} of ${_filteredReferrals.length} entries',
                    style: const TextStyle(
                      color: Color(0xFF6B7280),
                      fontSize: 14,
                    ),
                  ),
                  Row(
                    children: [
                      _buildPaginationButton('Previous', _currentPage > 1, () {
                        setState(() {
                          _currentPage--;
                        });
                      }),
                      const SizedBox(width: 8),
                      _buildPageNumber(1),
                      const SizedBox(width: 4),
                      _buildPageNumber(2),
                      const SizedBox(width: 4),
                      _buildPageNumber(3),
                      const SizedBox(width: 4),
                      _buildPageNumber(4),
                      const SizedBox(width: 8),
                      _buildPaginationButton(
                        'Next',
                        _currentPage <
                            (_filteredReferrals.length / _itemsPerPage).ceil(),
                        () {
                          setState(() {
                            _currentPage++;
                          });
                        },
                      ),
                    ],
                  ),
                ],
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
          style: GoogleFonts.poppins(
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
            const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
            const Icon(Icons.access_time, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField(
    String value,
    List<String> items,
    ValueChanged<String?> onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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
              child: Text(
                item,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey.shade700,
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
          icon: const Icon(Icons.arrow_drop_down, size: 20),
        ),
      ),
    );
  }

  Widget _buildPaginationButton(
    String label,
    bool enabled,
    VoidCallback onPressed,
  ) {
    return TextButton(
      onPressed: enabled ? onPressed : null,
      style: TextButton.styleFrom(
        foregroundColor: enabled ? const Color(0xFF009A69) : Colors.grey,
      ),
      child: Text(label),
    );
  }

  Widget _buildPageNumber(int page) {
    final isActive = _currentPage == page;
    return InkWell(
      onTap: () {
        setState(() {
          _currentPage = page;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF009A69) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          '$page',
          style: TextStyle(
            color: isActive ? Colors.white : const Color(0xFF6B7280),
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
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

// Referral Data Model
class MemberReferral {
  final String referralName;
  final String referralEmail;
  final String referredBy;
  final String referredDate;
  final String status;
  final String subscribedDate;
  final String referralLink;

  MemberReferral({
    required this.referralName,
    required this.referralEmail,
    required this.referredBy,
    required this.referredDate,
    required this.status,
    required this.subscribedDate,
    required this.referralLink,
  });
}

// Referral Card Widget
class _MemberReferralCard extends StatelessWidget {
  final MemberReferral referral;
  final VoidCallback? onTap;

  const _MemberReferralCard({required this.referral, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with name and status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        referral.referralName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                    ),
                    _buildStatusChip(referral.status),
                  ],
                ),
                const SizedBox(height: 8),

                // Email
                _buildInfoRow(
                  icon: Icons.email_outlined,
                  label: 'Email',
                  value: referral.referralEmail,
                ),
                const SizedBox(height: 6),

                // Referred By
                _buildInfoRow(
                  icon: Icons.person_outline,
                  label: 'Referred By',
                  value: referral.referredBy,
                ),
                const SizedBox(height: 6),

                // Referred Date
                _buildInfoRow(
                  icon: Icons.calendar_today_outlined,
                  label: 'Referred Date',
                  value: referral.referredDate,
                ),
                const SizedBox(height: 6),

                // Subscribed Date (if available)
                if (referral.subscribedDate.isNotEmpty)
                  _buildInfoRow(
                    icon: Icons.check_circle_outline,
                    label: 'Subscribed Date',
                    value: referral.subscribedDate,
                  ),
                const SizedBox(height: 8),

                // Referral Link
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.link,
                        size: 16,
                        color: Color(0xFF6B7280),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          referral.referralLink,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF009A69),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.open_in_new,
                        size: 16,
                        color: Color(0xFF6B7280),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF6B7280)),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF6B7280),
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 14, color: Color(0xFF1F2937)),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip(String status) {
    Color backgroundColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'subscribed':
        backgroundColor = const Color(0xFFD1FAE5);
        textColor = const Color(0xFF065F46);
        break;
      case 'un-subscribed':
        backgroundColor = const Color(0xFFFEE2E2);
        textColor = const Color(0xFF991B1B);
        break;
      case 'pending':
        backgroundColor = const Color(0xFFFEF3C7);
        textColor = const Color(0xFF92400E);
        break;
      default:
        backgroundColor = const Color(0xFFF3F4F6);
        textColor = const Color(0xFF6B7280);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}

// Invite Referral Dialog
class _InviteReferralDialog extends StatefulWidget {
  const _InviteReferralDialog();

  @override
  State<_InviteReferralDialog> createState() => _InviteReferralDialogState();
}

class _InviteReferralDialogState extends State<_InviteReferralDialog> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(
    text: 'admin@xyz.com , admin@xyz.com , admin@xyz.com',
  );
  final _messageController = TextEditingController(
    text: 'Hello, Invitee name, company name, City and Country is inviting you to subscribe to Smart Planner application. This application is useful to ... promotion message. Add Sign Up URL. Thank you and we are looking forward to your subscription. Sincerely, Director, SEKAI-ICHI Engg........ Yokohama, JAPAN.',
  );

  bool _isLoading = false;
  String _selectedParagraph = 'paragraph';
  bool _isBold = false;
  bool _isItalic = false;
  bool _isUnderline = false;
  bool _isStrikethrough = false;
  TextAlign _textAlign = TextAlign.left;
  bool _isBulletList = false;
  bool _isNumberedList = false;
  bool _isBlockquote = false;

  @override
  void dispose() {
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _sendInvite() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Referral invitation sent successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _pickFile() async {
    // File picker implementation would go here
    // For now, just show a message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('File picker functionality would be implemented here'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.95,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Close button
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close, color: Color(0xFF6B7280)),
                padding: const EdgeInsets.all(16),
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      const Center(
                        child: Text(
                          'Invite Referrals',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Subtitle
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            '(Generates an email list by entering multiple email addresses separated by a comma in a single input field)',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              height: 1.4,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Email Section
                      const Text(
                        'Email',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Enter email addresses separated by commas',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFF009A69),
                              width: 2,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.all(16),
                        ),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF3B82F6),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter at least one email address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),

                      // Invite Message Section
                      const Text(
                        'Invite Message',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Rich Text Editor Toolbar
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                          color: const Color(0xFFF9FAFB),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: Row(
                          children: [
                            // Paragraph dropdown
                            DropdownButton<String>(
                              value: _selectedParagraph,
                              underline: const SizedBox(),
                              items: const [
                                DropdownMenuItem(
                                  value: 'paragraph',
                                  child: Text('paragraph'),
                                ),
                              ],
                              onChanged: (value) {
                                setState(() => _selectedParagraph = value!);
                              },
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(width: 8),
                            // Formatting buttons
                            _buildToolbarButton(
                              icon: Icons.format_bold,
                              isActive: _isBold,
                              onTap: () => setState(() => _isBold = !_isBold),
                            ),
                            _buildToolbarButton(
                              icon: Icons.format_italic,
                              isActive: _isItalic,
                              onTap: () => setState(() => _isItalic = !_isItalic),
                            ),
                            _buildToolbarButton(
                              icon: Icons.format_underlined,
                              isActive: _isUnderline,
                              onTap: () => setState(() => _isUnderline = !_isUnderline),
                            ),
                            _buildToolbarButton(
                              icon: Icons.strikethrough_s,
                              isActive: _isStrikethrough,
                              onTap: () => setState(() => _isStrikethrough = !_isStrikethrough),
                            ),
                            const SizedBox(width: 8),
                            // Alignment buttons
                            _buildToolbarButton(
                              icon: Icons.format_align_left,
                              isActive: _textAlign == TextAlign.left,
                              onTap: () => setState(() => _textAlign = TextAlign.left),
                            ),
                            _buildToolbarButton(
                              icon: Icons.format_align_center,
                              isActive: _textAlign == TextAlign.center,
                              onTap: () => setState(() => _textAlign = TextAlign.center),
                            ),
                            _buildToolbarButton(
                              icon: Icons.format_align_right,
                              isActive: _textAlign == TextAlign.right,
                              onTap: () => setState(() => _textAlign = TextAlign.right),
                            ),
                            _buildToolbarButton(
                              icon: Icons.format_align_justify,
                              isActive: _textAlign == TextAlign.justify,
                              onTap: () => setState(() => _textAlign = TextAlign.justify),
                            ),
                            const SizedBox(width: 8),
                            // List buttons
                            _buildToolbarButton(
                              icon: Icons.format_list_bulleted,
                              isActive: _isBulletList,
                              onTap: () => setState(() => _isBulletList = !_isBulletList),
                            ),
                            _buildToolbarButton(
                              icon: Icons.format_list_numbered,
                              isActive: _isNumberedList,
                              onTap: () => setState(() => _isNumberedList = !_isNumberedList),
                            ),
                            _buildToolbarButton(
                              icon: Icons.format_quote,
                              isActive: _isBlockquote,
                              onTap: () => setState(() => _isBlockquote = !_isBlockquote),
                            ),
                            _buildToolbarButton(
                              icon: Icons.format_indent_increase,
                              isActive: false,
                              onTap: () {},
                            ),
                            _buildToolbarButton(
                              icon: Icons.format_indent_decrease,
                              isActive: false,
                              onTap: () {},
                            ),
                          ],
                        ),
                      ),
                      // Rich Text Editor Content
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(color: Colors.grey[300]!),
                            right: BorderSide(color: Colors.grey[300]!),
                            bottom: BorderSide(color: Colors.grey[300]!),
                          ),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                          ),
                        ),
                        child: TextFormField(
                          controller: _messageController,
                          maxLines: 8,
                          textAlign: _textAlign,
                          decoration: InputDecoration(
                            hintText: 'Enter your invitation message...',
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(16),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: _isBold ? FontWeight.bold : FontWeight.normal,
                            fontStyle: _isItalic ? FontStyle.italic : FontStyle.normal,
                            decoration: TextDecoration.combine([
                              if (_isUnderline) TextDecoration.underline,
                              if (_isStrikethrough) TextDecoration.lineThrough,
                            ]),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Attachment Section
                      const Text(
                        'Attachment',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 12),
                      InkWell(
                        onTap: _pickFile,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.attach_file, color: Colors.grey[400]),
                              const SizedBox(width: 12),
                              Text(
                                'select images or pdf',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[400],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '[Required file size is less than 6 MB]',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.red[600],
                        ),
                      ),
                      const SizedBox(height: 40),

                      // SEND INVITE Button
                      Center(
                        child: Container(
                          width: double.infinity,
                          height: 56,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(28),
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF4B5563),
                                Color(0xFF009A69),
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                          ),
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _sendInvite,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor:
                                          AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : const Text(
                                    'SEND INVITE',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolbarButton({
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF009A69) : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(
          icon,
          size: 18,
          color: isActive ? Colors.white : const Color(0xFF6B7280),
        ),
      ),
    );
  }
}
