import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_sports/role_specific/coach/screens/referrals/referral_data_service.dart';
import 'package:smart_sports/role_specific/coach/screens/referrals/referral_card.dart';
import 'package:smart_sports/role_specific/coach/screens/referrals/invite_referral_dialog.dart';
import 'package:smart_sports/role_specific/coach/screens/referrals/referral.dart';
import 'package:smart_sports/shared/widgets/role_sidebar.dart';
import 'package:smart_sports/role_specific/common/role_router.dart';
import 'package:smart_sports/role_specific/coach/screens/profile/coach_profile_page.dart';
import 'package:smart_sports/role_specific/coach/screens/dashboard/coach_analytics_dashboard_page.dart';
import 'package:smart_sports/role_specific/coach/screens/transactions/coach_transactions_page.dart';
import 'package:smart_sports/role_specific/coach/screens/courts/courts_page.dart';
import 'package:smart_sports/role_specific/coach/screens/bookings/coach_bookings_page.dart';
import 'package:smart_sports/role_specific/coach/screens/events/coach_events_page.dart';
import 'package:smart_sports/role_specific/coach/screens/users/coach_users_page.dart';
import 'package:smart_sports/role_specific/coach/screens/customer_support/coach_customer_support_page.dart';
import 'package:smart_sports/role_specific/coach/screens/settings/coach_settings_page.dart';
import 'package:smart_sports/core/utils/auth_utils.dart';

class CorporateReferralsPage extends ConsumerStatefulWidget {
  const CorporateReferralsPage({super.key});

  @override
  ConsumerState<CorporateReferralsPage> createState() => _CorporateReferralsPageState();
}

class _CorporateReferralsPageState extends ConsumerState<CorporateReferralsPage> {
  List<Referral> _allReferrals = [];
  List<Referral> _filteredReferrals = [];
  String _searchQuery = '';
  int _currentPage = 1;
  final int _itemsPerPage = 10;

  // Filter states
  String _selectedStatus = 'Select';
  String _selectedDay = 'Monday';
  bool _showFilters = false;

  @override
  void initState() {
    super.initState();
    _loadReferrals();
  }

  void _loadReferrals() {
    setState(() {
      _allReferrals = ReferralDataService.getMockReferrals();
      _applyFilters();
    });
  }

  void _applyFilters() {
    List<Referral> referrals = List.from(_allReferrals);

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
      builder: (context) => const InviteReferralDialog(),
    );
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
            selectedIndex: 8, // Referrals is index 8
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
                  MaterialPageRoute(builder: (_) => const CoachProfilePage()),
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
        title: const Text(
          'Referral Management',
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
              colors: [Color(0xFF232534), Color(0xFF414384)],
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
                foregroundColor: const Color(
                  0xFF232534,
                ), // Coach gradient start
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
                      return ReferralCard(
                        referral: referral,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Tapped on ${referral.referralName}',
                              ),
                              backgroundColor: const Color(
                                0xFF232534,
                              ), // Coach gradient start
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
            Expanded(child: Text(value, style: const TextStyle(fontSize: 14))),
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
            Expanded(child: Text(value, style: const TextStyle(fontSize: 14))),
            const Icon(Icons.schedule, size: 16, color: Color(0xFF6B7280)),
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
          onChanged: onChanged,
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(item, style: const TextStyle(fontSize: 14)),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildPaginationButton(String text, bool enabled, VoidCallback onTap) {
    return InkWell(
      onTap: enabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: enabled
              ? const Color(0xFF232534)
              : const Color(0xFFE5E7EB), // Coach gradient start
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: enabled ? Colors.white : const Color(0xFF9CA3AF),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildPageNumber(int pageNumber) {
    final isActive = _currentPage == pageNumber;
    return InkWell(
      onTap: () {
        setState(() {
          _currentPage = pageNumber;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? const Color(0xFF232534)
              : Colors.transparent, // Coach gradient start
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          pageNumber.toString(),
          style: TextStyle(
            color: isActive ? Colors.white : const Color(0xFF6B7280),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  void _navigateFromSidebar(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const CoachAnalyticsDashboardPage(),
          ),
        );
        break;
      case 1:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const CoachTransactionsPage()),
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
          MaterialPageRoute(builder: (_) => const CoachBookingsPage()),
        );
        break;
      case 5:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const CoachEventsPage()),
        );
        break;
      case 6:
        // Sponsorships - placeholder
        break;
      case 7:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const CoachUsersPage()),
        );
        break;
      case 8:
        // Already on referrals
        break;
      case 9:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const CoachCustomerSupportPage()),
        );
        break;
      case 10:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const CoachSettingsPage()),
        );
        break;
    }
  }
}
