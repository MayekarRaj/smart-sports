import 'package:flutter/material.dart';
import 'package:smart_sports/shared/widgets/role_sidebar.dart';
import 'package:smart_sports/role_specific/common/role_router.dart';
import 'package:smart_sports/shared/navigation/role_navigation_manager.dart';
import 'courts_list_page.dart';
import 'add_edit_court_screen.dart';

class ClubCourtsPage extends StatefulWidget {
  const ClubCourtsPage({super.key});

  @override
  State<ClubCourtsPage> createState() => _ClubCourtsPageState();
}

class _ClubCourtsPageState extends State<ClubCourtsPage> {
  bool _showFilters = false;
  final ScrollController _scrollController = ScrollController();
  String _selectedBranch = 'Branch 1';
  bool _showBranchDropdown = false;

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 900;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Courts'),
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            onPressed: _handleAddCourt,
            icon: const Icon(Icons.add),
            tooltip: 'Add Court',
          ),
          IconButton(
            onPressed: () => setState(() => _showFilters = !_showFilters),
            icon: Icon(
              _showFilters ? Icons.filter_list_off : Icons.filter_list,
            ),
            tooltip: _showFilters ? 'Hide Filters' : 'Show Filters',
          ),
        ],
      ),
      drawer: Drawer(
        elevation: 0,
        child: SafeArea(
          child: RoleSidebar(
            role: UserRole.club,
            selectedIndex: 2,
            edgeToEdge: true,
            onSelectIndex: (i) => RoleNavigationManager.navigateToScreen(
              context,
              UserRole.club,
              i,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _ClubToggle(),
            const SizedBox(height: 12),
            _ShowSearchRow(isWide: isWide),
            const SizedBox(height: 12),
            if (_showFilters) const _FilterStrip(),
            const SizedBox(height: 16),
            _EliteSportsArenaCard(onTap: () => _showAllCourts(context)),
            const SizedBox(height: 12),
            _EliteSportsArenaCard2(onTap: () => _showAllCourts(context)),
            const SizedBox(height: 16),
            // Branch Selection Dropdown
            _buildBranchSelectionDropdown(),
            const SizedBox(height: 16),
            // Courts for Selected Branch
            _buildCourtsForSelectedBranch(),
            const SizedBox(height: 16),
            // Map Section
            _buildMapSection(),
            const SizedBox(height: 16),
            // Basketball Utilization Table
            _buildBasketballUtilizationTable(),
            const SizedBox(height: 16),
            // Rating & Reviews Section
            _buildRatingReviewsSection(),
            const SizedBox(height: 20),
            const _CoachListSection(),
            const SizedBox(height: 16),
            const _BillingMethodSection(),
            const SizedBox(height: 16),
            const _GuestSeatingSection(),
            const SizedBox(height: 16),
            const _SponsorshipSection(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _handleAddCourt,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Court', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1E40AF),
        foregroundColor: Colors.white,
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _showAllCourts(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const CourtsListPage()));
  }

  void _handleAddCourt() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const AddEditCourtScreen()));
  }

  Widget _buildBranchSelectionDropdown() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Branch',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              setState(() {
                _showBranchDropdown = !_showBranchDropdown;
              });
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[50],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedBranch,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Icon(
                    _showBranchDropdown
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.grey[600],
                  ),
                ],
              ),
            ),
          ),
          if (_showBranchDropdown) ...[
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildBranchOption('Branch 1'),
                  _buildBranchOption('Branch 2'),
                  _buildBranchOption('Branch 3'),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBranchOption(String branch) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedBranch = branch;
          _showBranchDropdown = false;
        });
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: _selectedBranch == branch ? Colors.blue[50] : Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              Icons.location_on,
              size: 16,
              color: _selectedBranch == branch ? Colors.blue : Colors.grey[600],
            ),
            const SizedBox(width: 8),
            Text(
              branch,
              style: TextStyle(
                fontSize: 14,
                fontWeight: _selectedBranch == branch
                    ? FontWeight.w600
                    : FontWeight.w500,
                color: _selectedBranch == branch
                    ? Colors.blue
                    : Colors.grey[800],
              ),
            ),
            if (_selectedBranch == branch) ...[
              const Spacer(),
              Icon(Icons.check, size: 16, color: Colors.blue),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMapSection() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Location Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFF1E40AF),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.location_on, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Location',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          // Map Image
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
              child: Image.asset(
                'assets/images/9c71c0d0f90c1acfa57c561de796ac8136fe5724.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.map, size: 48, color: Colors.grey[400]),
                        const SizedBox(height: 8),
                        Text(
                          'Map View',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          // Location Text
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Adba Sports Complex Xcitenlay Club, Chicago',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourtsForSelectedBranch() {
    // Sample court data for each branch
    final courtsData = {
      'Branch 1': [
        {
          'name': 'Court 1',
          'sport': 'Basketball',
          'status': 'Available',
          'utilization': '82%',
        },
        {
          'name': 'Court 2',
          'sport': 'Tennis',
          'status': 'Available',
          'utilization': '67%',
        },
        {
          'name': 'Court 3',
          'sport': 'Badminton',
          'status': 'Occupied',
          'utilization': '90%',
        },
      ],
      'Branch 2': [
        {
          'name': 'Court 1',
          'sport': 'Football',
          'status': 'Available',
          'utilization': '45%',
        },
        {
          'name': 'Court 2',
          'sport': 'Cricket',
          'status': 'Maintenance',
          'utilization': '0%',
        },
        {
          'name': 'Court 3',
          'sport': 'Volleyball',
          'status': 'Available',
          'utilization': '78%',
        },
      ],
      'Branch 3': [
        {
          'name': 'Court 1',
          'sport': 'Squash',
          'status': 'Available',
          'utilization': '60%',
        },
        {
          'name': 'Court 2',
          'sport': 'Table Tennis',
          'status': 'Available',
          'utilization': '35%',
        },
        {
          'name': 'Court 3',
          'sport': 'Swimming',
          'status': 'Available',
          'utilization': '55%',
        },
      ],
    };

    final courts = courtsData[_selectedBranch] ?? [];

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFF1E40AF),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.sports, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Courts in $_selectedBranch',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${courts.length} Courts',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Courts List
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: courts.map((court) => _buildCourtCard(court)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourtCard(Map<String, String> court) {
    final isAvailable = court['status'] == 'Available';
    final isOccupied = court['status'] == 'Occupied';

    Color statusColor;
    IconData statusIcon;

    if (isAvailable) {
      statusColor = Colors.green;
      statusIcon = Icons.check_circle;
    } else if (isOccupied) {
      statusColor = Colors.orange;
      statusIcon = Icons.person;
    } else {
      statusColor = Colors.red;
      statusIcon = Icons.build;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          // Court Icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getSportIcon(court['sport']!),
              color: statusColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),

          // Court Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  court['name']!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  court['sport']!,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),

          // Status and Utilization
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(statusIcon, color: statusColor, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    court['status']!,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: statusColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${court['utilization']} Utilized',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue[700],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBasketballUtilizationTable() {
    final basketballData = [
      {
        'court': 'Court 1',
        'perDay': {'value': '82%', 'color': 'green'},
        'perWeek': {'value': '67%', 'color': 'yellow'},
        'perMonth': {'value': '8%', 'color': 'red'},
      },
      {
        'court': 'Court 2',
        'perDay': {'value': '63%', 'color': 'yellow'},
        'perWeek': {'value': '90%', 'color': 'green'},
        'perMonth': {'value': '25%', 'color': 'red'},
      },
      {
        'court': 'Court 3',
        'perDay': {'value': '10%', 'color': 'red'},
        'perWeek': {'value': '70%', 'color': 'yellow'},
        'perMonth': {'value': '87%', 'color': 'green'},
      },
      {
        'court': 'Overall Utilization',
        'perDay': {'value': '51.67%', 'color': 'black'},
        'perWeek': {'value': '75.67%', 'color': 'green'},
        'perMonth': {'value': '40%', 'color': 'red'},
      },
    ];

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFF1E40AF),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.sports_basketball, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Basketball Utilization',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          // Table Content
          LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 600;

              if (isMobile) {
                // Mobile view - vertical cards
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: basketballData
                        .map((data) => _buildMobileUtilizationCard(data))
                        .toList(),
                  ),
                );
              } else {
                // Desktop view - table
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: _buildDesktopUtilizationTable(basketballData),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMobileUtilizationCard(Map<String, dynamic> data) {
    final isOverall = data['court'] == 'Overall Utilization';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isOverall ? Colors.grey[50] : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isOverall ? Colors.grey[300]! : Colors.grey[200]!,
          width: isOverall ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data['court'],
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isOverall ? Colors.black87 : Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildUtilizationItem('Per Day', data['perDay'])),
              const SizedBox(width: 8),
              Expanded(
                child: _buildUtilizationItem('Per Week', data['perWeek']),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildUtilizationItem('Per Month', data['perMonth']),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopUtilizationTable(List<Map<String, dynamic>> data) {
    return DataTable(
      headingRowColor: MaterialStateProperty.all(Colors.grey[100]),
      columns: const [
        DataColumn(
          label: Text(
            'Basketball Utilization',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        DataColumn(
          label: Text('Per Day', style: TextStyle(fontWeight: FontWeight.w600)),
        ),
        DataColumn(
          label: Text(
            'Per Week',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        DataColumn(
          label: Text(
            'Per Month',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
      rows: data.map((row) {
        return DataRow(
          cells: [
            DataCell(
              Text(
                row['court'],
                style: TextStyle(
                  fontWeight: row['court'] == 'Overall Utilization'
                      ? FontWeight.w600
                      : FontWeight.w500,
                ),
              ),
            ),
            DataCell(_buildUtilizationCell(row['perDay'])),
            DataCell(_buildUtilizationCell(row['perWeek'])),
            DataCell(_buildUtilizationCell(row['perMonth'])),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildUtilizationItem(String label, Map<String, String> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _getUtilizationColor(data['color']!).withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: _getUtilizationColor(data['color']!).withOpacity(0.3),
            ),
          ),
          child: Text(
            data['value']!,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: _getUtilizationColor(data['color']!),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUtilizationCell(Map<String, String> data) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getUtilizationColor(data['color']!).withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: _getUtilizationColor(data['color']!).withOpacity(0.3),
        ),
      ),
      child: Text(
        data['value']!,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: _getUtilizationColor(data['color']!),
        ),
      ),
    );
  }

  Widget _buildRatingReviewsSection() {
    final reviewsData = [
      {
        'userName': 'Elijah Scott',
        'email': 'Elijahscott@Gmail.Com',
        'rating': 4.8,
        'review':
            'Lorem ipsum predokapp hypogen. Penas nis. Bioska nypp som dong. Cynlogi prelara egotevis. Negt.',
        'date': 'March 1, 2025',
        'time': '12:30:00',
        'status': 'pending', // pending, approved, rejected
      },
      {
        'userName': 'Miles King',
        'email': 'Milesking@Gmail.Com',
        'rating': 4.8,
        'review':
            'Lorem ipsum predokapp hypogen. Penas nis. Bioska nypp som dong. Cynlogi prelara egotevis. Negt.',
        'date': 'March 1, 2025',
        'time': '12:30:00',
        'status': 'pending',
      },
      {
        'userName': 'Tyler Hill',
        'email': 'Tylerhill@Gmail.Com',
        'rating': 4.8,
        'review':
            'Lorem ipsum predokapp hypogen. Penas nis. Bioska nypp som dong. Cynlogi prelara egotevis. Negt.',
        'date': 'March 1, 2025',
        'time': '12:30:00',
        'status': 'pending',
      },
    ];

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFF1E40AF),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.star, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Club Rating & Reviews',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          // Search and Filter Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Column(
              children: [
                // Global Search
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Show 10 Entries',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.grey[600],
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.search,
                              color: Colors.grey[600],
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Search Here',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                            const Spacer(),
                            Icon(
                              Icons.search,
                              color: Colors.grey[600],
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Column Filters
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isMobile = constraints.maxWidth < 600;

                    if (isMobile) {
                      return Column(
                        children: [
                          _buildFilterRow('Users', isMobile),
                          const SizedBox(height: 8),
                          _buildFilterRow('Rating', isMobile),
                          const SizedBox(height: 8),
                          _buildFilterRow('Reviews', isMobile),
                          const SizedBox(height: 8),
                          _buildDateRangeFilter(isMobile),
                        ],
                      );
                    } else {
                      return Row(
                        children: [
                          Expanded(child: _buildFilterRow('Users', isMobile)),
                          const SizedBox(width: 8),
                          Expanded(child: _buildFilterRow('Rating', isMobile)),
                          const SizedBox(width: 8),
                          Expanded(child: _buildFilterRow('Reviews', isMobile)),
                          const SizedBox(width: 8),
                          Expanded(child: _buildDateRangeFilter(isMobile)),
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          // Reviews List
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: reviewsData
                  .map((review) => _buildReviewCard(review))
                  .toList(),
            ),
          ),
          // Pagination
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Showing 1 To 10 Of 30 Entries',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
                Row(
                  children: [
                    _buildPaginationButton('Previous', false),
                    const SizedBox(width: 4),
                    _buildPageNumber(1, true),
                    const SizedBox(width: 4),
                    _buildPageNumber(2, false),
                    const SizedBox(width: 4),
                    _buildPageNumber(3, false),
                    const SizedBox(width: 4),
                    _buildPageNumber(4, false),
                    const SizedBox(width: 4),
                    _buildPaginationButton('Next', true),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterRow(String label, bool isMobile) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Q Search',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ),
          Icon(Icons.filter_list, color: Colors.grey[600], size: 16),
        ],
      ),
    );
  }

  Widget _buildDateRangeFilter(bool isMobile) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Wed, March 5, 2025',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ),
          Icon(Icons.calendar_today, color: Colors.grey[600], size: 16),
        ],
      ),
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 600;

          if (isMobile) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User Info
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.blue[100],
                      child: Text(
                        review['userName'][0],
                        style: TextStyle(
                          color: Colors.blue[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            review['userName'],
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue,
                            ),
                          ),
                          Text(
                            review['email'],
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Rating and Review
                Row(
                  children: [
                    Text(
                      '${review['rating']}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Row(
                      children: List.generate(
                        5,
                        (index) =>
                            Icon(Icons.star, color: Colors.amber, size: 16),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  review['review'],
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
                const SizedBox(height: 8),
                Text(
                  '${review['date']} ${review['time']}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
                const SizedBox(height: 12),
                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: _buildActionButton(
                        icon: Icons.close,
                        label: 'Reject',
                        color: Colors.red,
                        onTap: () {},
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildActionButton(
                        icon: Icons.check,
                        label: 'Approve',
                        color: Colors.blue,
                        onTap: () {},
                      ),
                    ),
                  ],
                ),
              ],
            );
          } else {
            return Row(
              children: [
                // User Column
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.blue[100],
                        child: Text(
                          review['userName'][0],
                          style: TextStyle(
                            color: Colors.blue[700],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              review['userName'],
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.blue,
                              ),
                            ),
                            Text(
                              review['email'],
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                // Rating & Reviews Column
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '${review['rating']}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Row(
                            children: List.generate(
                              5,
                              (index) => Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        review['review'],
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${review['date']} ${review['time']}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                // Action Column
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      _buildActionButton(
                        icon: Icons.close,
                        label: 'Reject',
                        color: Colors.red,
                        onTap: () {},
                      ),
                      const SizedBox(width: 8),
                      _buildActionButton(
                        icon: Icons.check,
                        label: 'Approve',
                        color: Colors.blue,
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 16),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaginationButton(String text, bool enabled) {
    return InkWell(
      onTap: enabled ? () {} : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: enabled ? const Color(0xFF1E40AF) : const Color(0xFFE5E7EB),
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

  Widget _buildPageNumber(int pageNumber, bool isActive) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF1E40AF) : Colors.transparent,
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

  Color _getUtilizationColor(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'green':
        return Colors.green;
      case 'yellow':
        return Colors.orange;
      case 'red':
        return Colors.red;
      case 'black':
        return Colors.black87;
      default:
        return Colors.grey;
    }
  }

  IconData _getSportIcon(String sport) {
    switch (sport.toLowerCase()) {
      case 'basketball':
        return Icons.sports_basketball;
      case 'tennis':
        return Icons.sports_tennis;
      case 'badminton':
        return Icons.sports;
      case 'football':
        return Icons.sports_soccer;
      case 'cricket':
        return Icons.sports_cricket;
      case 'volleyball':
        return Icons.sports_volleyball;
      case 'squash':
        return Icons.sports;
      case 'table tennis':
        return Icons.sports;
      case 'swimming':
        return Icons.pool;
      default:
        return Icons.sports;
    }
  }
}

class _EliteSportsArenaCard extends StatelessWidget {
  final VoidCallback onTap;

  const _EliteSportsArenaCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Court Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 80,
                  height: 70,
                  color: Colors.blue.shade100,
                  child: Icon(
                    Icons.sports_tennis,
                    color: Colors.blue,
                    size: 28,
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Court Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            'Elite Sports Arena',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.bookmark,
                                color: Colors.white,
                                size: 12,
                              ),
                              SizedBox(width: 2),
                              Text(
                                'Fav',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // Location
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Los Angeles, CA',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Available Sports
                    const Text(
                      'SPORTS',
                      style: TextStyle(
                        fontSize: 8,
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 4,
                      children: [
                        _buildSportChip('Basketball'),
                        _buildSportChip('Tennis'),
                        _buildSportChip('Soccer'),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: _buildActionButton(
                            icon: Icons.share,
                            label: 'Share',
                            onTap: () {},
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: _buildActionButton(
                            icon: Icons.sports_tennis,
                            label: 'Coach',
                            onTap: () {},
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: _buildActionButton(
                            icon: Icons.people,
                            label: 'Players',
                            onTap: () {},
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              // Side Info
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Coach Section
                  Column(
                    children: [
                      const Text(
                        'COACH',
                        style: TextStyle(
                          fontSize: 8,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 10,
                            backgroundColor: Colors.yellow,
                            child: Icon(
                              Icons.person,
                              size: 12,
                              color: Colors.white,
                            ),
                          ),
                          Positioned(
                            left: 12,
                            child: CircleAvatar(
                              radius: 10,
                              backgroundColor: Colors.green,
                              child: Icon(
                                Icons.person,
                                size: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Branch Section
                  Column(
                    children: [
                      const Text(
                        'BRANCH',
                        style: TextStyle(
                          fontSize: 8,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: 24,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: const Center(
                          child: Text(
                            '3',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Icon(Icons.star, color: Colors.blue, size: 16),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSportChip(String sport) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        sport,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 8,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.2),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 14),
            const SizedBox(height: 3),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _EliteSportsArenaCard2 extends StatelessWidget {
  final VoidCallback onTap;

  const _EliteSportsArenaCard2({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Court Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 80,
                  height: 70,
                  color: Colors.green.shade100,
                  child: Icon(
                    Icons.sports_soccer,
                    color: Colors.green,
                    size: 28,
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Court Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            'Premier Sports Complex',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.bookmark,
                                color: Colors.white,
                                size: 12,
                              ),
                              SizedBox(width: 2),
                              Text(
                                'Fav',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // Location
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'New York, NY',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Available Sports
                    const Text(
                      'SPORTS',
                      style: TextStyle(
                        fontSize: 8,
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 4,
                      children: [
                        _buildSportChip2('Soccer'),
                        _buildSportChip2('Football'),
                        _buildSportChip2('Cricket'),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: _buildActionButton2(
                            icon: Icons.share,
                            label: 'Share',
                            onTap: () {},
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: _buildActionButton2(
                            icon: Icons.sports_soccer,
                            label: 'Coach',
                            onTap: () {},
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: _buildActionButton2(
                            icon: Icons.people,
                            label: 'Players',
                            onTap: () {},
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              // Side Info
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Coach Section
                  Column(
                    children: [
                      const Text(
                        'COACH',
                        style: TextStyle(
                          fontSize: 8,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 10,
                            backgroundColor: Colors.blue,
                            child: Icon(
                              Icons.person,
                              size: 12,
                              color: Colors.white,
                            ),
                          ),
                          Positioned(
                            left: 12,
                            child: CircleAvatar(
                              radius: 10,
                              backgroundColor: Colors.purple,
                              child: Icon(
                                Icons.person,
                                size: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Branch Section
                  Column(
                    children: [
                      const Text(
                        'BRANCH',
                        style: TextStyle(
                          fontSize: 8,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: 24,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: const Center(
                          child: Text(
                            '5',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Icon(Icons.star, color: Colors.green, size: 16),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSportChip2(String sport) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        sport,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 8,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildActionButton2({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.2),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 14),
            const SizedBox(height: 3),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// UI pieces below

class _ClubToggle extends StatelessWidget {
  const _ClubToggle();
  @override
  Widget build(BuildContext context) {
    Widget pill(String text, bool active) => Container(
      decoration: BoxDecoration(
        color: active ? Colors.black87 : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: active ? Colors.black54 : Colors.black26),
        boxShadow: const [
          BoxShadow(
            blurRadius: 6,
            color: Color(0x14000000),
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        text,
        style: TextStyle(
          color: active ? Colors.white : Colors.black54,
          fontWeight: FontWeight.w600,
        ),
      ),
    );

    return Row(
      children: [
        pill('Club', true),
        const SizedBox(width: 8),
        pill('Corporate', false),
      ],
    );
  }
}

class _ShowSearchRow extends StatelessWidget {
  final bool isWide;
  const _ShowSearchRow({required this.isWide});
  @override
  Widget build(BuildContext context) {
    final dd = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.keyboard_arrow_down,
            color: Colors.grey.shade600,
            size: 16,
          ),
          const SizedBox(width: 4),
          Text(
            'All Sports',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
        ],
      ),
    );

    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Icon(Icons.search, color: Colors.grey.shade600, size: 16),
                const SizedBox(width: 8),
                Text(
                  'Search venues...',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        dd,
      ],
    );
  }
}

class _FilterStrip extends StatelessWidget {
  const _FilterStrip();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildFilterChip('Distance', true),
          const SizedBox(width: 8),
          _buildFilterChip('Price', false),
          const SizedBox(width: 8),
          _buildFilterChip('Rating', false),
          const SizedBox(width: 8),
          _buildFilterChip('Availability', false),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool active) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: active ? Colors.blue : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: active ? Colors.white : Colors.grey.shade600,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _CoachListSection extends StatelessWidget {
  const _CoachListSection();
  @override
  Widget build(BuildContext context) {
    Widget row({required String name, required bool blocked}) => Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.blue.shade100,
            child: Text(
              name[0],
              style: TextStyle(
                color: Colors.blue.shade700,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: blocked ? Colors.red.shade100 : Colors.green.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              blocked ? 'Blocked' : 'Available',
              style: TextStyle(
                color: blocked ? Colors.red.shade700 : Colors.green.shade700,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Coaches',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        row(name: 'John Smith', blocked: false),
        row(name: 'Sarah Johnson', blocked: true),
        row(name: 'Mike Wilson', blocked: false),
      ],
    );
  }
}

class _BillingMethodSection extends StatelessWidget {
  const _BillingMethodSection();
  @override
  Widget build(BuildContext context) {
    Widget line(String unit) => Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.credit_card, color: Colors.grey.shade600, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              unit,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Icon(Icons.radio_button_checked, color: Colors.blue, size: 20),
        ],
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Billing Method',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        line('Credit Card ending in 1234'),
        const SizedBox(height: 8),
        line('PayPal - john@example.com'),
      ],
    );
  }
}

class _GuestSeatingSection extends StatelessWidget {
  const _GuestSeatingSection();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Guest Seating',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Capacity',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '300',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Available',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '150',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SponsorshipSection extends StatelessWidget {
  const _SponsorshipSection();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.star, color: Colors.blue.shade700, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Sponsorship Opportunities',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _SponsorFilter(label: 'Banner Ads'),
                const SizedBox(height: 8),
                _SponsorFilter(label: 'Logo Placement'),
                const SizedBox(height: 8),
                _SponsorFilter(label: 'Event Sponsorship'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SponsorFilter extends StatelessWidget {
  final String label;
  const _SponsorFilter({required this.label});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(
            Icons.check_circle_outline,
            color: Colors.grey.shade600,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Icon(Icons.arrow_forward_ios, color: Colors.grey.shade400, size: 16),
        ],
      ),
    );
  }
}
