import 'package:flutter/material.dart';
import 'package:smart_sports/shared/widgets/role_sidebar.dart';
import 'package:smart_sports/role_specific/common/role_router.dart';
import 'package:smart_sports/shared/navigation/role_navigation_manager.dart';
import 'member_club_details_page.dart';

class MemberClubsPage extends StatefulWidget {
  const MemberClubsPage({super.key});

  @override
  State<MemberClubsPage> createState() => _MemberClubsPageState();
}

class _MemberClubsPageState extends State<MemberClubsPage> {
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

  final List<MemberClubData> _allClubs = [
    MemberClubData(
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
      coachImages: [
        'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150&h=150&fit=crop',
        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop',
        'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop',
        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop',
      ],
      imageUrl: 'assets/images/elite_sports_arena.jpg',
      isMyClub: false,
    ),
    MemberClubData(
      name: 'Metro Sports Complex',
      location: 'New York, NY',
      rating: 4.6,
      branches: 2,
      courts: 20,
      availableSports: ['Basketball', 'Tennis', 'Volleyball'],
      isFavorite: true,
      distance: 8.5,
      status: 'Available',
      discount: '15% Off SPECIAL DISCOUNT',
      coaches: 3,
      coachImages: [
        'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150&h=150&fit=crop',
        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop',
        'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop',
      ],
      imageUrl: 'assets/images/metro_sports.jpg',
      isMyClub: true,
    ),
    MemberClubData(
      name: 'Downtown Arena',
      location: 'Chicago, IL',
      rating: 4.9,
      branches: 4,
      courts: 40,
      availableSports: ['Cricket', 'Football', 'Badminton'],
      isFavorite: true,
      distance: 12.3,
      status: 'Available',
      discount: '20% Off SPECIAL DISCOUNT',
      coaches: 5,
      coachImages: [
        'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150&h=150&fit=crop',
        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop',
        'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop',
        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop',
        'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150&h=150&fit=crop',
      ],
      imageUrl: 'assets/images/downtown_arena.jpg',
      isMyClub: true,
    ),
    MemberClubData(
      name: 'City Sports Center',
      location: 'Miami, FL',
      rating: 4.7,
      branches: 2,
      courts: 25,
      availableSports: ['Tennis', 'Baseball', 'Soccer'],
      isFavorite: false,
      distance: 15.8,
      status: 'Available',
      discount: '5% Off SPECIAL DISCOUNT',
      coaches: 2,
      coachImages: [
        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop',
        'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop',
      ],
      imageUrl: 'assets/images/city_sports.jpg',
      isMyClub: false,
    ),
  ];

  List<MemberClubData> get _filteredClubs {
    List<MemberClubData> clubs = _selectedTabIndex == 0
        ? _allClubs
        : _allClubs.where((club) => club.isMyClub).toList();

    // Apply search filter
    if (_searchController.text.isNotEmpty) {
      clubs = clubs
          .where(
            (club) =>
                club.name.toLowerCase().contains(
                  _searchController.text.toLowerCase(),
                ) ||
                club.location.toLowerCase().contains(
                  _searchController.text.toLowerCase(),
                ),
          )
          .toList();
    }

    // Apply distance filter
    clubs = clubs.where((club) => club.distance <= _distanceRange).toList();

    // Apply sport filter
    if (_selectedSport != 'Sport') {
      clubs = clubs
          .where((club) => club.availableSports.contains(_selectedSport))
          .toList();
    }

    // Apply status filter
    if (_selectedStatus != 'Select') {
      clubs = clubs.where((club) => club.status == _selectedStatus).toList();
    }

    return clubs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('My Clubs'),
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
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        actions: [
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
            role: UserRole.member,
            selectedIndex: 2,
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
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Mobile Search Section
            _MobileSearchSection(
              searchController: _searchController,
              showFilters: _showFilters,
              onToggleFilters: () =>
                  setState(() => _showFilters = !_showFilters),
              onSearchChanged: () => setState(() {}),
            ),

            // Mobile Filter Section
            if (_showFilters)
              _MobileFilterSection(
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
            _MobileClubTabs(
              selectedIndex: _selectedTabIndex,
              onTabChanged: (index) =>
                  setState(() => _selectedTabIndex = index),
            ),

            // Distance Slider
            _MobileDistanceSlider(
              distanceRange: _distanceRange,
              onDistanceChanged: (value) =>
                  setState(() => _distanceRange = value),
            ),

            // Map Section
            const _MobileMapSection(),

            // Club Listings
            _MobileClubListings(
              clubs: _filteredClubs,
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

  void _navigateToClubDetails(BuildContext context, MemberClubData club) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MemberClubDetailsPage(club: club),
      ),
    );
  }
}

// Data model for club information
class MemberClubData {
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
  final List<String> coachImages;
  final String imageUrl;
  final bool isMyClub;

  MemberClubData({
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
    required this.coachImages,
    required this.imageUrl,
    required this.isMyClub,
  });
}

// Mobile Search Section Component
class _MobileSearchSection extends StatelessWidget {
  final TextEditingController searchController;
  final bool showFilters;
  final VoidCallback onToggleFilters;
  final VoidCallback onSearchChanged;

  const _MobileSearchSection({
    required this.searchController,
    required this.showFilters,
    required this.onToggleFilters,
    required this.onSearchChanged,
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
              onChanged: (_) => onSearchChanged(),
              decoration: const InputDecoration(
                hintText: 'Search Here',
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
                        ? const Color(0xFF009A69)
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
class _MobileFilterSection extends StatelessWidget {
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

  const _MobileFilterSection({
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
              color: Color(0xFF009A69),
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
            'Time',
            Row(
              children: [
                Expanded(
                  child: _buildTimeButton(
                    fromTime == null ? 'HH:MM' : fromTime!.format(context),
                    () => _selectTime(context, true),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildTimeButton(
                    toTime == null ? 'HH:MM' : toTime!.format(context),
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
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
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
    return '${days[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

// Mobile Club Tabs Component
class _MobileClubTabs extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabChanged;

  const _MobileClubTabs({
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
          color: isSelected ? const Color(0xFF009A69) : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected ? const Color(0xFF009A69) : Colors.grey.shade300,
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
class _MobileDistanceSlider extends StatelessWidget {
  final double distanceRange;
  final ValueChanged<double> onDistanceChanged;

  const _MobileDistanceSlider({
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
                  activeColor: const Color(0xFF009A69),
                  inactiveColor: Colors.grey.shade300,
                ),
              ),
              Text('40', style: TextStyle(color: Colors.grey.shade600)),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF009A69),
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
class _MobileMapSection extends StatelessWidget {
  const _MobileMapSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      height: 250,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Stack(
        children: [
          // Map Image
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              'assets/images/9c71c0d0f90c1acfa57c561de796ac8136fe5724.png',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Center(
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
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                );
              },
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
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildLegendItem('A', Colors.green, 'Slots Available'),
                      _buildLegendItem('R', Colors.orange, 'Slots Rushing'),
                      _buildLegendItem('X', Colors.red, 'Slots Not Available'),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'You can change the club selection of your choice from Map.',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade600,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
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
          width: 20,
          height: 20,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          child: Center(
            child: Text(
              letter,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
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
class _MobileClubListings extends StatelessWidget {
  final List<MemberClubData> clubs;
  final Function(MemberClubData) onFavoriteToggle;
  final Function(MemberClubData) onClubTap;

  const _MobileClubListings({
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
                child: _MobileClubCard(
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
class _MobileClubCard extends StatelessWidget {
  final MemberClubData club;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onTap;

  const _MobileClubCard({
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
        border: Border.all(color: Colors.purple.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Left Section - Club Image (1/3 width)
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.33,
                    color: Colors.grey.shade300,
                    child: Image.asset(
                      club.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(
                            Icons.sports_basketball,
                            size: 50,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // Right Section - Club Details (2/3 width)
                Expanded(
                  child: InkWell(
                    onTap: onTap,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Header with name and favorite
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  club.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 4),
                              GestureDetector(
                                onTap: onFavoriteToggle,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      club.isFavorite
                                          ? Icons.bookmark
                                          : Icons.bookmark_border,
                                      color: Colors.blue,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 2),
                                    Flexible(
                                      child: Text(
                                        'Mark As Favourite',
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 6),

                          // Location - Light blue oval button
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.lightBlue.shade50,
                              border: Border.all(color: Colors.blue, width: 1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              club.location,
                              style: TextStyle(
                                color: Colors.blue.shade700,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          const SizedBox(height: 10),

                          // Available Sports and Coach Row
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Available Sports Section
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      'AVAILABLE SPORTS',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Wrap(
                                      spacing: 4,
                                      runSpacing: 4,
                                      children: club.availableSports
                                          .take(3)
                                          .map(
                                            (sport) => Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 4,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.lightBlue.shade50,
                                                border: Border.all(
                                                  color: Colors.blue,
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Text(
                                                sport,
                                                style: TextStyle(
                                                  color: Colors.blue.shade700,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(width: 8),

                              // Coach Section
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    'COACH',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (club.coachImages.isNotEmpty)
                                        _buildCoachAvatar(club.coachImages[0]),
                                      if (club.coachImages.length > 1)
                                        Transform.translate(
                                          offset: const Offset(-8, 0),
                                          child: _buildCoachAvatar(
                                            club.coachImages[1],
                                          ),
                                        ),
                                      if (club.coachImages.length > 2)
                                        Transform.translate(
                                          offset: const Offset(-16, 0),
                                          child: _buildCoachAvatar(
                                            club.coachImages[2],
                                          ),
                                        ),
                                      if (club.coaches >
                                          club.coachImages.length)
                                        Transform.translate(
                                          offset: Offset(
                                            -8.0 *
                                                club.coachImages.length.clamp(
                                                  0,
                                                  3,
                                                ),
                                            0,
                                          ),
                                          child: _buildCoachAvatar(
                                            null,
                                            remainingCount:
                                                club.coaches -
                                                club.coachImages.length,
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          // Rating, Branches, and Courts Row
                          Row(
                            children: [
                              // Club Rating
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '${club.rating}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: List.generate(5, (index) {
                                      return Icon(
                                        index < club.rating.floor()
                                            ? Icons.star
                                            : Icons.star_border,
                                        size: 14,
                                        color: index < club.rating.floor()
                                            ? Colors.amber
                                            : Colors.grey.shade400,
                                      );
                                    }),
                                  ),
                                  const SizedBox(height: 2),
                                  const Text(
                                    'Club Rating',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),

                              const Spacer(),

                              // Branches and Courts
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      _buildStatChip(
                                        'BRANCHES',
                                        '${club.branches}',
                                      ),
                                      const SizedBox(width: 6),
                                      _buildStatChip(
                                        'COURTS',
                                        '${club.courts}',
                                      ),
                                    ],
                                  ),
                                ],
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

          // Action Buttons
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Expanded(child: _buildActionButton(Icons.share, 'Share')),
                const SizedBox(width: 4),
                Expanded(child: _buildActionButton(Icons.sports, 'Coach')),
                const SizedBox(width: 4),
                Expanded(child: _buildActionButton(Icons.people, 'Players')),
                const SizedBox(width: 4),
                Expanded(child: _buildActionButton(Icons.handshake, 'Sponsor')),
                const SizedBox(width: 4),
                Expanded(
                  child: _buildActionButton(Icons.rate_review, 'Reviews'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: Icon(icon, size: 14),
      label: Text(
        label,
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 0,
        minimumSize: const Size(0, 32),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }

  Widget _buildCoachAvatar(String? imageUrl, {int? remainingCount}) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipOval(
        child: imageUrl != null
            ? Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.person, size: 20, color: Colors.grey),
                ),
              )
            : Container(
                color: Colors.grey.shade300,
                child: Center(
                  child: remainingCount != null && remainingCount > 0
                      ? Text(
                          '+$remainingCount',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        )
                      : const Icon(Icons.person, size: 20, color: Colors.grey),
                ),
              ),
      ),
    );
  }

  Widget _buildStatChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: const TextStyle(fontSize: 9, color: Colors.grey)),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
