import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  @override
  void initState() {
    super.initState();
    _loadReferrals();
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
        return referral.referralName
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            referral.referralEmail
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            referral.referredBy.toLowerCase().contains(_searchQuery.toLowerCase());
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
    return [
      MemberReferral(
        referralName: 'John Doe',
        referralEmail: 'john@example.com',
        referredBy: 'You',
        referredDate: '01/02/2025',
        status: 'Subscribed',
        subscribedDate: '01/02/2025',
        referralLink: 'https://smartsports.app/referral/MEM123',
      ),
      MemberReferral(
        referralName: 'Jane Smith',
        referralEmail: 'jane@example.com',
        referredBy: 'You',
        referredDate: '15/03/2025',
        status: 'Subscribed',
        subscribedDate: '16/03/2025',
        referralLink: 'https://smartsports.app/referral/MEM123',
      ),
      MemberReferral(
        referralName: 'Mike Johnson',
        referralEmail: 'mike@example.com',
        referredBy: 'You',
        referredDate: '22/03/2025',
        status: 'Pending',
        subscribedDate: '',
        referralLink: 'https://smartsports.app/referral/MEM123',
      ),
      MemberReferral(
        referralName: 'Sarah Wilson',
        referralEmail: 'sarah@example.com',
        referredBy: 'You',
        referredDate: '05/04/2025',
        status: 'Un-Subscribed',
        subscribedDate: '05/04/2025',
        referralLink: 'https://smartsports.app/referral/MEM123',
      ),
      MemberReferral(
        referralName: 'David Brown',
        referralEmail: 'david@example.com',
        referredBy: 'You',
        referredDate: '12/04/2025',
        status: 'Subscribed',
        subscribedDate: '13/04/2025',
        referralLink: 'https://smartsports.app/referral/MEM123',
      ),
    ];
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
            selectedIndex: 7,
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
              colors: [Color(0xFF1E40AF), Color(0xFF3B82F6)],
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
                foregroundColor: const Color(0xFF1E40AF),
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
          // Statistics Cards
          _buildStatisticsSection(),

          // Referral Code Section
          _buildReferralCodeSection(),

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
              color: const Color(0xFF1E40AF),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
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
                            items: [
                              'Select',
                              'Monday',
                              'Tuesday',
                              'Wednesday',
                              'Thursday',
                              'Friday',
                              'Saturday',
                              'Sunday',
                            ],
                            onChanged: (value) {
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
                            value: _selectedStatus,
                            items: [
                              'Select',
                              'Subscribed',
                              'Un-Subscribed',
                              'Pending',
                            ],
                            onChanged: (value) {
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
                              backgroundColor: const Color(0xFF1E40AF),
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

  Widget _buildStatisticsSection() {
    final totalReferrals = _allReferrals.length;
    final subscribedCount =
        _allReferrals.where((r) => r.status == 'Subscribed').length;
    final pendingCount =
        _allReferrals.where((r) => r.status == 'Pending').length;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Total Referrals',
              '$totalReferrals',
              Icons.people,
              const Color(0xFF1E40AF),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Subscribed',
              '$subscribedCount',
              Icons.check_circle,
              Colors.green,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Pending',
              '$pendingCount',
              Icons.pending,
              Colors.orange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReferralCodeSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E40AF), Color(0xFF3B82F6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Referral Code',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'MEM123',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E40AF),
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () {
                  Clipboard.setData(const ClipboardData(text: 'MEM123'));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Referral code copied!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                icon: const Icon(Icons.copy, color: Colors.white),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.2),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Share this code with friends to earn rewards!',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white70,
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

  Widget _buildPaginationButton(
      String label, bool enabled, VoidCallback onPressed) {
    return TextButton(
      onPressed: enabled ? onPressed : null,
      style: TextButton.styleFrom(
        foregroundColor: enabled ? const Color(0xFF1E40AF) : Colors.grey,
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
          color: isActive ? const Color(0xFF1E40AF) : Colors.transparent,
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

  const _MemberReferralCard({
    required this.referral,
    this.onTap,
  });

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
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                            color: Color(0xFF1E40AF),
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
        Icon(
          icon,
          size: 16,
          color: const Color(0xFF6B7280),
        ),
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
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF1F2937),
            ),
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
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _messageController = TextEditingController();

  bool _isLoading = false;
  String _selectedMethod = 'email';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
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

  void _copyReferralLink() {
    const referralLink = 'https://smartsports.app/referral/MEM123';
    Clipboard.setData(const ClipboardData(text: referralLink));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Referral link copied to clipboard!'),
        backgroundColor: Color(0xFF1E40AF),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.95,
        constraints: const BoxConstraints(maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFF1E40AF),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.person_add, color: Colors.white, size: 24),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Invite Referral',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Invitation Method Selection
                      const Text(
                        'Invitation Method',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Mobile-friendly method selection
                      Column(
                        children: [
                          _buildMethodButton(
                            'Email',
                            Icons.email,
                            _selectedMethod == 'email',
                            () => setState(() => _selectedMethod = 'email'),
                          ),
                          const SizedBox(height: 8),
                          _buildMethodButton(
                            'SMS',
                            Icons.sms,
                            _selectedMethod == 'sms',
                            () => setState(() => _selectedMethod = 'sms'),
                          ),
                          const SizedBox(height: 8),
                          _buildMethodButton(
                            'Link',
                            Icons.link,
                            _selectedMethod == 'link',
                            () => setState(() => _selectedMethod = 'link'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Referral Link Section (for link method)
                      if (_selectedMethod == 'link') ...[
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE5E7EB)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Your Referral Link',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1F2937),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: const Color(0xFFE5E7EB),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'https://smartsports.app/referral/MEM123',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF6B7280),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    InkWell(
                                      onTap: _copyReferralLink,
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF1E40AF),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: const Icon(
                                          Icons.copy,
                                          size: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],

                      // Form Fields (for email and SMS methods)
                      if (_selectedMethod != 'link') ...[
                        // Name Field
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: 'Referral Name',
                            hintText: 'Enter referral name',
                            prefixIcon: const Icon(Icons.person_outline),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: const Color(0xFFF9FAFB),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter referral name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Email/Phone Field
                        if (_selectedMethod == 'email')
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: 'Email Address',
                              hintText: 'Enter email address',
                              prefixIcon: const Icon(Icons.email_outlined),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: const Color(0xFFF9FAFB),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter email address';
                              }
                              if (!value.contains('@')) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          )
                        else
                          TextFormField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              labelText: 'Phone Number',
                              hintText: 'Enter phone number',
                              prefixIcon: const Icon(Icons.phone_outlined),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: const Color(0xFFF9FAFB),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter phone number';
                              }
                              return null;
                            },
                          ),
                        const SizedBox(height: 16),

                        // Message Field
                        TextFormField(
                          controller: _messageController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            labelText: 'Personal Message (Optional)',
                            hintText:
                                'Add a personal message to your invitation',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: const Color(0xFFF9FAFB),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],

                      // Action Buttons
                      Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _sendInvite,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1E40AF),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          Colors.white,
                                        ),
                                      ),
                                    )
                                  : const Text(
                                      'Send Invitation',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () => Navigator.of(context).pop(),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                side: const BorderSide(
                                  color: Color(0xFFD1D5DB),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                  color: Color(0xFF6B7280),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMethodButton(
    String label,
    IconData icon,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1E40AF) : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF1E40AF)
                : const Color(0xFFE5E7EB),
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : const Color(0xFF6B7280),
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : const Color(0xFF6B7280),
              ),
            ),
            const Spacer(),
            if (isSelected)
              const Icon(Icons.check_circle, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }
}
