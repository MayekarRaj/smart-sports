import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_sports/common/models/user.dart' as models;
import 'package:smart_sports/role_specific/merchandiser/screens/users/user_data_service.dart';
import 'package:smart_sports/role_specific/merchandiser/screens/users/user_card.dart';
import 'package:smart_sports/shared/widgets/role_sidebar.dart';
import 'package:smart_sports/role_specific/common/role_router.dart';
import 'package:smart_sports/role_specific/merchandiser/screens/profile/merchandiser_profile_page.dart';
import 'package:smart_sports/shared/navigation/role_navigation_manager.dart';
// Navigation to other screens is handled via RoleNavigationManager from the sidebar.
import 'package:smart_sports/role_specific/merchandiser/screens/users/add_user_screen.dart';
import 'package:smart_sports/core/utils/auth_utils.dart';

class MerchandiserUsersPage extends ConsumerStatefulWidget {
  const MerchandiserUsersPage({super.key});

  @override
  ConsumerState<MerchandiserUsersPage> createState() => _MerchandiserUsersPageState();
}

class _MerchandiserUsersPageState extends ConsumerState<MerchandiserUsersPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _filterAnimationController;
  late Animation<double> _filterAnimation;

  List<models.User> _allUsers = [];
  List<models.User> _filteredUsers = [];
  String _searchQuery = '';
  bool _isFilterExpanded = false;
  int _currentPage = 1;
  final int _itemsPerPage = 10;

  // Filter states
  String _selectedDepartment = 'All';
  String _selectedStatus = 'All';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _filterAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _filterAnimation = CurvedAnimation(
      parent: _filterAnimationController,
      curve: Curves.easeInOut,
    );
    _loadUsers();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _filterAnimationController.dispose();
    super.dispose();
  }

  void _loadUsers() {
    setState(() {
      _allUsers = UserDataService.getMockUsers();
      _applyFilters();
    });
  }

  void _handleAddUser() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const AddUserScreen()));
  }

  void _applyFilters() {
    List<models.User> users = _allUsers;

    // Apply tab filter
    if (_tabController.index == 0) {
      users = UserDataService.getAdminUsers();
    } else {
      users = UserDataService.getEmployeeUsers();
    }

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      users = UserDataService.searchUsers(_searchQuery, users);
    }

    // Apply department filter
    if (_selectedDepartment != 'All') {
      users = users
          .where((user) => user.department.label == _selectedDepartment)
          .toList();
    }

    // Apply status filter
    if (_selectedStatus != 'All') {
      users = users
          .where((user) => user.status.label == _selectedStatus)
          .toList();
    }

    setState(() {
      _filteredUsers = users;
    });
  }

  void _toggleFilters() {
    setState(() {
      _isFilterExpanded = !_isFilterExpanded;
    });

    if (_isFilterExpanded) {
      _filterAnimationController.forward();
    } else {
      _filterAnimationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      drawer: Drawer(
        elevation: 0,
        child: SafeArea(
          child: RoleSidebar(
            role: UserRole.merchandiser,
            selectedIndex: 7, // Users is index 7
            edgeToEdge: true,
            onSelectIndex: (i) => RoleNavigationManager.navigateToScreen(
              context,
              UserRole.merchandiser,
              i,
            ),
            onProfileTap: () async {
              final navigator = Navigator.of(context);
              navigator.pop();
              await Future.delayed(const Duration(milliseconds: 160));
              if (mounted) {
                navigator.push(
                  MaterialPageRoute(
                    builder: (_) => const MerchandiserProfilePage(),
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
          'Merchandise Users',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.grey[700]!, Colors.grey[600]!],
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
          IconButton(
            icon: const Icon(Icons.person_add, color: Colors.white),
            onPressed: _handleAddUser,
            tooltip: 'Add User',
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                // Search bar
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
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                      _applyFilters();
                    },
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
                    Text(
                      'Show $_itemsPerPage Entries',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      '${_filteredUsers.length} users found',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Filter section
          Container(
            color: Colors.grey[600], // Gray theme
            child: Column(
              children: [
                // Filter toggle button
                InkWell(
                  onTap: _toggleFilters,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Filters',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        AnimatedRotation(
                          turns: _isFilterExpanded ? 0.5 : 0,
                          duration: const Duration(milliseconds: 300),
                          child: const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Collapsible filter content
                SizeTransition(
                  sizeFactor: _filterAnimation,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Column(
                      children: [
                        // Department filter
                        _buildFilterDropdown(
                          label: 'Department',
                          value: _selectedDepartment,
                          items: [
                            'All',
                            'Design',
                            'Management',
                            'Development',
                            'Marketing',
                            'Sales',
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedDepartment = value!;
                            });
                            _applyFilters();
                          },
                        ),
                        const SizedBox(height: 12),
                        // Status filter
                        _buildFilterDropdown(
                          label: 'Status',
                          value: _selectedStatus,
                          items: [
                            'All',
                            'Active',
                            'Inactive',
                            'Pending',
                            'Suspended',
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedStatus = value!;
                            });
                            _applyFilters();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Tab bar with pill-style design
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(25),
              ),
              child: TabBar(
                controller: _tabController,
                onTap: (index) {
                  _applyFilters();
                },
                indicator: BoxDecoration(
                  color: Colors.grey[600], // Gray theme
                  borderRadius: BorderRadius.circular(25),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: const Color(0xFF6B7280),
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
                tabs: const [
                  Tab(text: 'Admin User'),
                  Tab(text: 'Employees'),
                ],
              ),
            ),
          ),

          // Users list
          Expanded(
            child: _filteredUsers.isEmpty
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
                          'No users found',
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
                    itemCount: _filteredUsers.length,
                    itemBuilder: (context, index) {
                      final user = _filteredUsers[index];
                      return UserCard(
                        user: user,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Tapped on ${user.userName}'),
                              backgroundColor: const Color(
                                0xFF232534,
                              ), // Coach gradient start
                            ),
                          );
                        },
                        onView: () {
                          // View user functionality is handled in UserCard
                        },
                      );
                    },
                  ),
          ),

          // Pagination
          if (_filteredUsers.length > _itemsPerPage)
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Showing ${(_currentPage - 1) * _itemsPerPage + 1} to ${(_currentPage * _itemsPerPage).clamp(0, _filteredUsers.length)} of ${_filteredUsers.length} entries',
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
                            (_filteredUsers.length / _itemsPerPage).ceil(),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _handleAddUser,
        backgroundColor: Colors.grey[600],
        foregroundColor: Colors.white,
        icon: const Icon(Icons.person_add),
        label: const Text('Add User'),
      ),
    );
  }

  Widget _buildFilterDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: value,
                    isExpanded: true,
                    onChanged: onChanged,
                    items: items.map((String item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            item,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaginationButton(String text, bool enabled, VoidCallback onTap) {
    return InkWell(
      onTap: enabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: enabled
              ? Colors.grey[600]
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
              ? Colors.grey[600]
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

  // Navigation from sidebar now centralized via RoleNavigationManager
}
