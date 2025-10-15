import 'package:flutter/material.dart';
import 'package:smart_sports/shared/widgets/role_sidebar.dart';
import 'package:smart_sports/role_specific/common/role_router.dart';
import 'package:smart_sports/shared/navigation/role_navigation_manager.dart';
import 'corporate_details_page.dart';

class ClubsPage extends StatefulWidget {
  const ClubsPage({super.key});

  @override
  State<ClubsPage> createState() => _ClubsPageState();
}

class _ClubsPageState extends State<ClubsPage> {
  bool _showFilters = false;
  int _selectedTabIndex = 0; // 0: All Clubs, 1: My Clubs
  double _distanceRange = 25.0; // Distance in miles
  final TextEditingController _searchController = TextEditingController();

  // Filter states
  String _selectedSport = 'Sport';
  DateTime? _fromDate;
  DateTime? _toDate;
  TimeOfDay? _fromTime;
  TimeOfDay? _toTime;
  String _selectedDays = 'Select';
  String _selectedStatus = 'Select';

  final List<ClubData> _clubs = [
    ClubData(
      name: 'Elite Sports Arena',
      location: 'Los Angeles, CA',
      rating: 4.8,
      branches: 3,
      courts: 30,
      availableSports: ['Basketball', 'Tennis', 'Cricket'],
      isFavorite: false,
      distance: 5.2,
      status: 'Available',
      discount: '10% Off SPECIAL DISCOUNT',
      coaches: 4,
      imageUrl: 'assets/images/elite_sports_arena.jpg',
    ),
    ClubData(
      name: 'Elite Sports Arena',
      location: 'Los Angeles, CA',
      rating: 4.8,
      branches: 3,
      courts: 30,
      availableSports: ['Basketball', 'Tennis', 'Cricket'],
      isFavorite: true,
      distance: 5.2,
      status: 'Available',
      discount: '10% Off SPECIAL DISCOUNT',
      coaches: 4,
      imageUrl: 'assets/images/elite_sports_arena.jpg',
    ),
    ClubData(
      name: 'Elite Sports Arena',
      location: 'Los Angeles, CA',
      rating: 4.8,
      branches: 3,
      courts: 30,
      availableSports: ['Basketball', 'Tennis', 'Cricket'],
      isFavorite: true,
      distance: 5.2,
      status: 'Available',
      discount: '10% Off SPECIAL DISCOUNT',
      coaches: 4,
      imageUrl: 'assets/images/elite_sports_arena.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Clubs',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
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
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => setState(() => _showFilters = !_showFilters),
            icon: Icon(
              _showFilters ? Icons.filter_list_off : Icons.filter_list,
              color: Colors.white,
            ),
            tooltip: _showFilters ? 'Hide Filters' : 'Show Filters',
          ),
        ],
      ),
      drawer: Drawer(
        elevation: 0,
        child: SafeArea(
          child: RoleSidebar(
            role: UserRole.corporate,
            selectedIndex: 3, // Clubs is at index 3
            edgeToEdge: true,
            onSelectIndex: (i) => RoleNavigationManager.navigateToScreen(
              context,
              UserRole.corporate,
              i,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Mobile Search Section
            MobileSearchSection(
              searchController: _searchController,
              showFilters: _showFilters,
              onToggleFilters: () =>
                  setState(() => _showFilters = !_showFilters),
            ),

            // Mobile Filter Section
            if (_showFilters)
              MobileFilterSection(
                selectedSport: _selectedSport,
                selectedDays: _selectedDays,
                selectedStatus: _selectedStatus,
                fromDate: _fromDate,
                toDate: _toDate,
                fromTime: _fromTime,
                toTime: _toTime,
                onSportChanged: (value) =>
                    setState(() => _selectedSport = value!),
                onDaysChanged: (value) =>
                    setState(() => _selectedDays = value!),
                onStatusChanged: (value) =>
                    setState(() => _selectedStatus = value!),
                onDateSelected: (isFrom, date) {
                  setState(() {
                    if (isFrom) {
                      _fromDate = date;
                    } else {
                      _toDate = date;
                    }
                  });
                },
                onTimeSelected: (isFrom, time) {
                  setState(() {
                    if (isFrom) {
                      _fromTime = time;
                    } else {
                      _toTime = time;
                    }
                  });
                },
              ),

            // Club Tabs
            MobileClubTabs(
              selectedIndex: _selectedTabIndex,
              onTabChanged: (index) =>
                  setState(() => _selectedTabIndex = index),
            ),

            // Distance Slider
            MobileDistanceSlider(
              distanceRange: _distanceRange,
              onDistanceChanged: (value) =>
                  setState(() => _distanceRange = value),
            ),

            // Map Section
            MobileMapSection(),

            // Club Listings
            MobileClubListings(
              clubs: _clubs,
              onFavoriteToggle: (club) => setState(() {
                club.isFavorite = !club.isFavorite;
              }),
              onClubTap: (club) => _navigateToClubDetails(context, club),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _navigateToClubDetails(BuildContext context, ClubData club) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            CorporateDetailsPage(corporate: _convertClubToCorporate(club)),
      ),
    );
  }

  CorporateData _convertClubToCorporate(ClubData club) {
    return CorporateData(
      name: club.name,
      rating: club.rating,
      location: club.location,
      specializations: club.availableSports,
      experience: 5, // Default experience
      employees: 25, // Default employee count
      budget: 50000, // Default budget
    );
  }
}

// Mobile Search Section Component
class MobileSearchSection extends StatelessWidget {
  final TextEditingController searchController;
  final bool showFilters;
  final VoidCallback onToggleFilters;

  const MobileSearchSection({
    super.key,
    required this.searchController,
    required this.showFilters,
    required this.onToggleFilters,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Search Bar
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                hintText: 'Search clubs...',
                border: InputBorder.none,
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Filter Toggle Button
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onToggleFilters,
                  icon: Icon(
                    showFilters ? Icons.filter_list_off : Icons.filter_list,
                  ),
                  label: Text(showFilters ? 'Hide Filters' : 'Show Filters'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: showFilters
                        ? Colors.blue
                        : Colors.grey.shade200,
                    foregroundColor: showFilters
                        ? Colors.white
                        : Colors.black87,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
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
}

// Mobile Filter Section Component
class MobileFilterSection extends StatelessWidget {
  final String selectedSport;
  final String selectedDays;
  final String selectedStatus;
  final DateTime? fromDate;
  final DateTime? toDate;
  final TimeOfDay? fromTime;
  final TimeOfDay? toTime;
  final ValueChanged<String?> onSportChanged;
  final ValueChanged<String?> onDaysChanged;
  final ValueChanged<String?> onStatusChanged;
  final Function(bool isFrom, DateTime date) onDateSelected;
  final Function(bool isFrom, TimeOfDay time) onTimeSelected;

  const MobileFilterSection({
    super.key,
    required this.selectedSport,
    required this.selectedDays,
    required this.selectedStatus,
    required this.fromDate,
    required this.toDate,
    required this.fromTime,
    required this.toTime,
    required this.onSportChanged,
    required this.onDaysChanged,
    required this.onStatusChanged,
    required this.onDateSelected,
    required this.onTimeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Filters',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 12),

          // Sport Filter
          _buildFilterRow(
            'Sport',
            DropdownButtonFormField<String>(
              value: selectedSport,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              items: [
                'Sport',
                'Cricket',
                'Basketball',
                'Tennis',
                'Football',
              ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: onSportChanged,
            ),
          ),

          const SizedBox(height: 8),

          // Date Range
          _buildFilterRow(
            'Date Range',
            Row(
              children: [
                Expanded(
                  child: _buildDateButton(
                    fromDate == null ? 'From Date' : _formatDate(fromDate!),
                    () => _selectDate(context, true),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildDateButton(
                    toDate == null ? 'To Date' : _formatDate(toDate!),
                    () => _selectDate(context, false),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Time Range
          _buildFilterRow(
            'Time Range',
            Row(
              children: [
                Expanded(
                  child: _buildTimeButton(
                    fromTime == null ? 'From Time' : fromTime!.format(context),
                    () => _selectTime(context, true),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildTimeButton(
                    toTime == null ? 'To Time' : toTime!.format(context),
                    () => _selectTime(context, false),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Days Filter
          _buildFilterRow(
            'Days',
            DropdownButtonFormField<String>(
              value: selectedDays,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              items: [
                'Select',
                'Monday',
                'Tuesday',
                'Wednesday',
                'Thursday',
                'Friday',
                'Saturday',
                'Sunday',
              ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: onDaysChanged,
            ),
          ),

          const SizedBox(height: 8),

          // Status Filter
          _buildFilterRow(
            'Status',
            DropdownButtonFormField<String>(
              value: selectedStatus,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              items: [
                'Select',
                'Available',
                'Maintenance',
                'Closed',
              ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: onStatusChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterRow(String label, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  Widget _buildDateButton(String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeButton(String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Row(
          children: [
            const Icon(Icons.access_time, size: 16, color: Colors.grey),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, bool isFrom) async {
    final date = await showDatePicker(
      context: context,
      initialDate: isFrom
          ? (fromDate ?? DateTime.now())
          : (toDate ?? DateTime.now()),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      onDateSelected(isFrom, date);
    }
  }

  Future<void> _selectTime(BuildContext context, bool isFrom) async {
    final time = await showTimePicker(
      context: context,
      initialTime: isFrom
          ? (fromTime ?? TimeOfDay.now())
          : (toTime ?? TimeOfDay.now()),
    );
    if (time != null) {
      onTimeSelected(isFrom, time);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

// Mobile Club Tabs Component
class MobileClubTabs extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabChanged;

  const MobileClubTabs({
    super.key,
    required this.selectedIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(child: _buildTab('All Clubs', 0)),
          const SizedBox(width: 8),
          Expanded(child: _buildTab('My Clubs', 1)),
        ],
      ),
    );
  }

  Widget _buildTab(String text, int index) {
    final isSelected = selectedIndex == index;
    return InkWell(
      onTap: () => onTabChanged(index),
      borderRadius: BorderRadius.circular(25),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade300,
          ),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

// Mobile Distance Slider Component
class MobileDistanceSlider extends StatelessWidget {
  final double distanceRange;
  final ValueChanged<double> onDistanceChanged;

  const MobileDistanceSlider({
    super.key,
    required this.distanceRange,
    required this.onDistanceChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Distance Range (In Miles)',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text('10', style: TextStyle(color: Colors.grey.shade600)),
              Expanded(
                child: Slider(
                  value: distanceRange,
                  min: 10,
                  max: 40,
                  divisions: 30,
                  onChanged: onDistanceChanged,
                  activeColor: Colors.blue,
                  inactiveColor: Colors.grey.shade300,
                ),
              ),
              Text('40', style: TextStyle(color: Colors.grey.shade600)),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${distanceRange.round()} mi',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
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

// Mobile Map Section Component
class MobileMapSection extends StatelessWidget {
  const MobileMapSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      height: 150,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Stack(
        children: [
          // Map Placeholder
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.map, size: 40, color: Colors.grey.shade400),
                const SizedBox(height: 8),
                Text(
                  'Interactive Map',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Buenos Aires',
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                ),
              ],
            ),
          ),

          // Map Legend
          Positioned(
            bottom: 8,
            left: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildLegendItem('A', Colors.green, 'Available'),
                  _buildLegendItem('R', Colors.orange, 'Rushing'),
                  _buildLegendItem('X', Colors.red, 'Not Available'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String letter, Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          child: Center(
            child: Text(
              letter,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
            ),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

// Mobile Club Listings Component
class MobileClubListings extends StatelessWidget {
  final List<ClubData> clubs;
  final Function(ClubData) onFavoriteToggle;
  final Function(ClubData) onClubTap;

  const MobileClubListings({
    super.key,
    required this.clubs,
    required this.onFavoriteToggle,
    required this.onClubTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Section Header
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          child: const Text(
            'Club Listings',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),

        // Club Cards
        ...clubs
            .map(
              (club) => Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: MobileClubCard(
                  club: club,
                  onFavoriteToggle: () => onFavoriteToggle(club),
                  onTap: () => onClubTap(club),
                ),
              ),
            )
            .toList(),

        // Bottom padding for better scrolling
        const SizedBox(height: 20),
      ],
    );
  }
}

// Mobile Club Card Component
class MobileClubCard extends StatelessWidget {
  final ClubData club;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onTap;

  const MobileClubCard({
    super.key,
    required this.club,
    required this.onFavoriteToggle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Club Image and Basic Info
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with name and favorite
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          club.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: onFavoriteToggle,
                        icon: Icon(
                          club.isFavorite
                              ? Icons.bookmark
                              : Icons.bookmark_border,
                          color: club.isFavorite ? Colors.blue : Colors.grey,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Location
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        club.location,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Available Sports
                  const Text(
                    'Available Sports',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: club.availableSports
                        .map(
                          (sport) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              sport,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),

                  const SizedBox(height: 16),

                  // Rating and Stats Row
                  Row(
                    children: [
                      // Rating
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            '${club.rating}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Club Rating',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),

                      const Spacer(),

                      // Stats
                      _buildStatChip('Branches', '${club.branches}'),
                      const SizedBox(width: 8),
                      _buildStatChip('Courts', '${club.courts}'),
                    ],
                  ),
                ],
              ),
            ),

            // Action Buttons
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Expanded(child: _buildActionButton(Icons.share, 'Share')),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildActionButton(Icons.sports_tennis, 'Coach'),
                  ),
                  const SizedBox(width: 8),
                  Expanded(child: _buildActionButton(Icons.group, 'Players')),
                  const SizedBox(width: 8),
                  Expanded(child: _buildActionButton(Icons.reviews, 'Reviews')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: Icon(icon, size: 16),
      label: Text(label, style: const TextStyle(fontSize: 12)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}

// Data model for club information
class ClubData {
  final String name;
  final String location;
  final double rating;
  final int branches;
  final int courts;
  final List<String> availableSports;
  bool isFavorite;
  final double distance;
  final String status;
  final String discount;
  final int coaches;
  final String imageUrl;

  ClubData({
    required this.name,
    required this.location,
    required this.rating,
    required this.branches,
    required this.courts,
    required this.availableSports,
    required this.isFavorite,
    required this.distance,
    required this.status,
    required this.discount,
    required this.coaches,
    required this.imageUrl,
  });
}
