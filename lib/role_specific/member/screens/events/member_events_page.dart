import 'package:flutter/material.dart';
import 'package:smart_sports/shared/widgets/role_sidebar.dart';
import 'package:smart_sports/role_specific/common/role_router.dart';
import 'package:smart_sports/shared/navigation/role_navigation_manager.dart';
import 'member_tournament_details_page.dart';

class MemberEventsPage extends StatefulWidget {
  const MemberEventsPage({super.key});

  @override
  State<MemberEventsPage> createState() => _MemberEventsPageState();
}

class _MemberEventsPageState extends State<MemberEventsPage> {
  int _selectedTabIndex = 0;
  String _selectedSport = 'Cricket';

  // Filter controllers
  final TextEditingController _eventNameController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  String? _selectedDay;
  String? _selectedStatus;
  bool _isFilterExpanded = false;

  // Event registration state
  final Map<String, bool> _eventRegistrations = {
    'Brown Country Tournament': true,
    'Elite Sports Championship': false,
    'City Sports Festival': true,
    'Summer Games Tournament': false,
    'Winter Sports League': true,
  };

  final List<String> _tabs = [
    'All Events',
    'Registered',
    'Upcoming',
    'Past',
  ];

  final List<String> _sports = [
    'Cricket',
    'Basketball',
    'Tennis',
    'Carrom Board',
    'Chess',
  ];

  final List<String> _days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  final List<String> _statuses = [
    'Active',
    'Inactive',
    'Pending',
    'Completed',
    'Cancelled',
  ];

  @override
  void dispose() {
    _eventNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Events / Tournaments'),
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
      ),
      drawer: Drawer(
        elevation: 0,
        child: SafeArea(
          child: RoleSidebar(
            role: UserRole.member,
            selectedIndex: 4,
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
      body: Column(
        children: [
          // Tab Sections
          _buildTabSections(),

          // Filter Bar
          _buildFilterBar(),

          // Sport Filters
          _buildSportFilters(),

          // Event Cards
          Expanded(child: _buildEventCards()),
        ],
      ),
    );
  }

  Widget _buildTabSections() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: _tabs.asMap().entries.map((entry) {
          final index = entry.key;
          final tab = entry.value;
          final isSelected = _selectedTabIndex == index;

          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: InkWell(
                onTap: () => setState(() => _selectedTabIndex = index),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF009A69).withOpacity(0.1)
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF009A69)
                          : Colors.grey.shade300,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Text(
                    tab,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? const Color(0xFF009A69)
                          : Colors.black54,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Filter Toggle Header
          InkWell(
            onTap: () => setState(() => _isFilterExpanded = !_isFilterExpanded),
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.filter_list, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  const Text(
                    'Filters',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    _isFilterExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.white,
                    size: 24,
                  ),
                ],
              ),
            ),
          ),

          // Collapsible Filter Content
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            height: _isFilterExpanded ? null : 0,
            child: _isFilterExpanded
                ? Container(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Event Name
                        _buildFilterField(
                          'Event Name',
                          TextField(
                            controller: _eventNameController,
                            style: const TextStyle(color: Colors.black87),
                            decoration: InputDecoration(
                              hintText: 'Search',
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              prefixIcon: Icon(
                                Icons.search,
                                color: Colors.grey[400],
                              ),
                              suffixIcon: Icon(
                                Icons.filter_list,
                                color: Colors.grey[400],
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Date Range and Time Row
                        LayoutBuilder(
                          builder: (context, constraints) {
                            if (constraints.maxWidth < 600) {
                              // Mobile layout - stacked
                              return Column(
                                children: [
                                  _buildDateRangeField(),
                                  const SizedBox(height: 16),
                                  _buildTimeField(),
                                ],
                              );
                            } else {
                              // Desktop layout - horizontal
                              return Row(
                                children: [
                                  Expanded(child: _buildDateRangeField()),
                                  const SizedBox(width: 16),
                                  Expanded(child: _buildTimeField()),
                                ],
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 16),

                        // Days and Status Row
                        LayoutBuilder(
                          builder: (context, constraints) {
                            if (constraints.maxWidth < 600) {
                              // Mobile layout - stacked
                              return Column(
                                children: [
                                  _buildDaysField(),
                                  const SizedBox(height: 16),
                                  _buildStatusField(),
                                ],
                              );
                            } else {
                              // Desktop layout - horizontal
                              return Row(
                                children: [
                                  Expanded(child: _buildDaysField()),
                                  const SizedBox(width: 16),
                                  Expanded(child: _buildStatusField()),
                                ],
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterField(String label, Widget child) {
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

  Widget _buildDateRangeField() {
    return _buildFilterField(
      'Date Range',
      Row(
        children: [
          Expanded(
            child: _buildDateField(
              'Start Date',
              _startDate,
              (date) => setState(() => _startDate = date),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildDateField(
              'End Date',
              _endDate,
              (date) => setState(() => _endDate = date),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateField(
    String hint,
    DateTime? value,
    Function(DateTime?) onChanged,
  ) {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: value ?? DateTime.now(),
          firstDate: DateTime.now().subtract(const Duration(days: 365)),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (date != null) {
          onChanged(date);
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
                value != null
                    ? '${value.day}/${value.month}/${value.year}'
                    : hint,
                style: TextStyle(
                  color: value != null ? Colors.black87 : Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ),
            Icon(Icons.calendar_today, color: Colors.grey[600], size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeField() {
    return _buildFilterField(
      'Time',
      Row(
        children: [
          Expanded(
            child: _buildTimeFieldItem(
              'Start Time',
              _startTime,
              (time) => setState(() => _startTime = time),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildTimeFieldItem(
              'End Time',
              _endTime,
              (time) => setState(() => _endTime = time),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeFieldItem(
    String hint,
    TimeOfDay? value,
    Function(TimeOfDay?) onChanged,
  ) {
    return InkWell(
      onTap: () async {
        final time = await showTimePicker(
          context: context,
          initialTime: value ?? TimeOfDay.now(),
        );
        if (time != null) {
          onChanged(time);
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
                value != null
                    ? '${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}'
                    : 'HH:MM',
                style: TextStyle(
                  color: value != null ? Colors.black87 : Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ),
            Icon(Icons.access_time, color: Colors.grey[600], size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildDaysField() {
    return _buildFilterField(
      'Days',
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: _selectedDay,
            hint: const Text('Select', style: TextStyle(color: Colors.grey)),
            isExpanded: true,
            items: _days.map((day) {
              return DropdownMenuItem(
                value: day,
                child: Text(day, style: const TextStyle(color: Colors.black87)),
              );
            }).toList(),
            onChanged: (value) => setState(() => _selectedDay = value),
            icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[600]),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusField() {
    return _buildFilterField(
      'Status',
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: _selectedStatus,
            hint: const Text('Select', style: TextStyle(color: Colors.grey)),
            isExpanded: true,
            items: _statuses.map((status) {
              return DropdownMenuItem(
                value: status,
                child: Text(
                  status,
                  style: const TextStyle(color: Colors.black87),
                ),
              );
            }).toList(),
            onChanged: (value) => setState(() => _selectedStatus = value),
            icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[600]),
          ),
        ),
      ),
    );
  }

  Widget _buildSportFilters() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _sports.map((sport) {
            final isSelected = _selectedSport == sport;
            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: InkWell(
                onTap: () => setState(() => _selectedSport = sport),
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF009A69) : Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF009A69)
                          : Colors.grey.shade300,
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: const Color(0xFF009A69).withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Text(
                    sport,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildEventCards() {
    List<Map<String, dynamic>> events = _getEventsForTab();

    if (events.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'No events found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your filters',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        children: events.map((event) {
          return Column(
            children: [_buildEventCard(event), const SizedBox(height: 20)],
          );
        }).toList(),
      ),
    );
  }

  List<Map<String, dynamic>> _getEventsForTab() {
    List<Map<String, dynamic>> allEvents = [
      {
        'name': 'Brown Country Tournament',
        'venue': 'Elite Sports Arena',
        'location': 'Los Angeles, CA',
        'rating': 4.8,
        'sports': ['Cricket', 'Tennis', 'Basketball', 'Softball'],
        'eventDate': 'Fri, April 18, 2025',
        'registrationDate': 'Thu, April 17, 2025',
        'organizerName': 'Miles King',
        'organizerEmail': 'Elijahscott@Gmail.Com',
        'isRegistered':
            _eventRegistrations['Brown Country Tournament'] ?? false,
        'status': 'Upcoming',
      },
      {
        'name': 'Elite Sports Championship',
        'venue': 'Metro Sports Complex',
        'location': 'New York, NY',
        'rating': 4.6,
        'sports': ['Basketball', 'Tennis', 'Volleyball'],
        'eventDate': 'Sat, May 10, 2025',
        'registrationDate': 'Fri, May 9, 2025',
        'organizerName': 'Sarah Johnson',
        'organizerEmail': 'sarah.johnson@email.com',
        'isRegistered':
            _eventRegistrations['Elite Sports Championship'] ?? false,
        'status': 'Upcoming',
      },
      {
        'name': 'City Sports Festival',
        'venue': 'Downtown Arena',
        'location': 'Chicago, IL',
        'rating': 4.9,
        'sports': ['Cricket', 'Football', 'Badminton'],
        'eventDate': 'Sun, June 15, 2025',
        'registrationDate': 'Sat, June 14, 2025',
        'organizerName': 'Mike Davis',
        'organizerEmail': 'mike.davis@email.com',
        'isRegistered': _eventRegistrations['City Sports Festival'] ?? false,
        'status': 'Upcoming',
      },
      {
        'name': 'Summer Games Tournament',
        'venue': 'Beach Sports Center',
        'location': 'Miami, FL',
        'rating': 4.4,
        'sports': ['Tennis', 'Swimming', 'Beach Volleyball'],
        'eventDate': 'Fri, July 20, 2025',
        'registrationDate': 'Thu, July 19, 2025',
        'organizerName': 'Lisa Wilson',
        'organizerEmail': 'lisa.wilson@email.com',
        'isRegistered':
            _eventRegistrations['Summer Games Tournament'] ?? false,
        'status': 'Upcoming',
      },
      {
        'name': 'Winter Sports League',
        'venue': 'Mountain Sports Resort',
        'location': 'Denver, CO',
        'rating': 4.7,
        'sports': ['Skiing', 'Ice Hockey', 'Snowboarding'],
        'eventDate': 'Sat, December 15, 2024',
        'registrationDate': 'Fri, December 14, 2024',
        'organizerName': 'Tom Anderson',
        'organizerEmail': 'tom.anderson@email.com',
        'isRegistered': _eventRegistrations['Winter Sports League'] ?? false,
        'status': 'Past',
      },
    ];

    switch (_selectedTabIndex) {
      case 0: // All Events
        return allEvents;
      case 1: // Registered
        return allEvents
            .where((event) => event['isRegistered'] == true)
            .toList();
      case 2: // Upcoming
        return allEvents
            .where((event) => event['status'] == 'Upcoming')
            .toList();
      case 3: // Past
        return allEvents
            .where((event) => event['status'] == 'Past')
            .toList();
      default:
        return allEvents;
    }
  }

  Widget _buildEventCard(Map<String, dynamic> event) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MemberTournamentDetailsPage(
              tournamentName: event['name'],
              venue: event['venue'],
              location: event['location'],
              rating: event['rating'],
              availableSports: event['sports'],
              eventDate: event['eventDate'],
              registrationDate: event['registrationDate'],
              organizerName: event['organizerName'],
              organizerEmail: event['organizerEmail'],
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // Background Image
              Container(
                height: 320,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/images/pngtree-a-large-cricket-stadium-green-field-empty-picture-image_15985507.jpg',
                    ),
                    fit: BoxFit.cover,
                    onError: (exception, stackTrace) {
                      // Handle image error
                    },
                  ),
                ),
              ),

              // Overlay Content
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.2),
                        Colors.black.withOpacity(0.8),
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tournament Title and Favourite
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              event['name'],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.5),
                                    offset: const Offset(0, 1),
                                    blurRadius: 2,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF009A69),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF009A69).withOpacity(0.3),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.bookmark,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  'Favourite',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Venue and Rating
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  event['venue'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black54,
                                        offset: Offset(0, 1),
                                        blurRadius: 1,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      color: Colors.white70,
                                      size: 14,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      event['location'],
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  event['rating'].toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: List.generate(
                                    5,
                                    (index) => Icon(
                                      Icons.star,
                                      color: index < event['rating'].floor()
                                          ? Colors.yellow
                                          : Colors.white30,
                                      size: 14,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                const Text(
                                  'Club Rating',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Available Sports
                      const Text(
                        'AVAILABLE SPORTS',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: (event['sports'] as List<String>).map((sport) {
                          return _buildSportChip(sport);
                        }).toList(),
                      ),

                      const SizedBox(height: 16),

                      // Schedule
                      const Text(
                        'SCHEDULE',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            _buildScheduleItem(
                              'Event Date',
                              event['eventDate'],
                            ),
                            const SizedBox(height: 6),
                            _buildScheduleItem(
                              'Registration Last Date',
                              event['registrationDate'],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Organizer and Action
                      Row(
                        children: [
                          // Organizer Info
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'ORGANISER',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Container(
                                        width: 32,
                                        height: 32,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF009A69),
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(0xFF009A69)
                                                  .withOpacity(0.3),
                                              blurRadius: 4,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: const Icon(
                                          Icons.person,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              event['organizerName'],
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              event['organizerEmail'],
                                              style: const TextStyle(
                                                color: Colors.white70,
                                                fontSize: 11,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF009A69),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: const Text(
                                          'Connect',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          // Register/Unregister Button
                          GestureDetector(
                            onTap: () => _handleRegistrationToggle(event),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              decoration: BoxDecoration(
                                color: event['isRegistered']
                                    ? Colors.red.shade600
                                    : Colors.green.shade600,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: (event['isRegistered']
                                            ? Colors.red
                                            : Colors.green)
                                        .withOpacity(0.3),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    event['isRegistered']
                                        ? Icons.cancel
                                        : Icons.check_circle,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    event['isRegistered']
                                        ? 'Unregister'
                                        : 'Register',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
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
      ),
    );
  }

  void _handleRegistrationToggle(Map<String, dynamic> event) {
    setState(() {
      _eventRegistrations[event['name']] = !event['isRegistered'];
    });

    // Show confirmation message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          event['isRegistered']
              ? 'Unregistered from ${event['name']}'
              : 'Registered for ${event['name']}',
        ),
        backgroundColor: event['isRegistered']
            ? Colors.red.shade600
            : Colors.green.shade600,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildSportChip(String sport) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF009A69),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF009A69).withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        sport,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildScheduleItem(String label, String value) {
    return Row(
      children: [
        SizedBox(
          width: 130,
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
