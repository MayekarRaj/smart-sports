import 'package:flutter/material.dart';
import 'package:smart_sports/shared/widgets/role_sidebar.dart';
import 'package:smart_sports/role_specific/common/role_router.dart';
import 'package:smart_sports/shared/navigation/role_navigation_manager.dart';
import 'package:smart_sports/role_specific/club/screens/profile/club_profile_page.dart';
import 'package:smart_sports/role_specific/club/screens/events/tournament_details_page.dart';
import 'package:smart_sports/events/screens/add_event_form_screen.dart';

class ClubEventsPage extends StatefulWidget {
  const ClubEventsPage({super.key});

  @override
  State<ClubEventsPage> createState() => _ClubEventsPageState();
}

class _ClubEventsPageState extends State<ClubEventsPage> {
  int _selectedEventTypeIndex = 0; // 0 = Upcoming Events, 1 = Past Events
  int _selectedTabIndex = 0; // 0 = As An Organizer, 1 = As A Subscriber, 2 = Unsubscribed Events
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

  // Tournament subscription state
  final Map<String, bool> _tournamentSubscriptions = {
    'Brown Country Tournament': true,
    'Elite Sports Championship': false,
    'City Sports Festival': true,
    'Summer Games Tournament': false,
    'Winter Sports League': true,
  };

  final List<String> _tabs = [
    'As An Organizer',
    'As A Subscriber',
    'Unsubscribed Events',
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
        title: const Text('Events / Tournaments'),
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _handleAddEvent(),
            icon: const Icon(Icons.add),
            tooltip: 'Add Event',
          ),
        ],
      ),
      drawer: Drawer(
        elevation: 0,
        child: SafeArea(
          child: RoleSidebar(
            role: UserRole.club,
            selectedIndex: 5,
            edgeToEdge: true,
            onSelectIndex: (i) => RoleNavigationManager.navigateToScreen(
              context,
              UserRole.club,
              i,
            ),
            onProfileTap: () async {
              Navigator.of(context).pop();
              await Future.delayed(const Duration(milliseconds: 160));
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ClubProfilePage()),
              );
            },
          ),
        ),
      ),
      body: Column(
        children: [
          // Event Type Tabs (Upcoming Events / Past Events)
          _buildEventTypeTabs(),
          
          // Tab Sections (As An Organizer / As A Subscriber / Unsubscribed Events)
          if (_selectedEventTypeIndex == 0) _buildTabSections(),

          // Filter Bar
          _buildFilterBar(),

          // Sport Filters
          _buildSportFilters(),

          // Event Cards
          Expanded(child: _buildEventCards()),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _handleAddEvent(),
        icon: const Icon(Icons.add),
        label: const Text('Add Event'),
        backgroundColor: const Color(0xFF007BFF),
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildEventTypeTabs() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () => setState(() => _selectedEventTypeIndex = 0),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                decoration: BoxDecoration(
                  color: _selectedEventTypeIndex == 0
                      ? Colors.grey.shade800
                      : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _selectedEventTypeIndex == 0
                        ? Colors.grey.shade700
                        : Colors.grey.shade300,
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  'Upcoming Events',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: _selectedEventTypeIndex == 0
                        ? Colors.white
                        : Colors.grey.shade700,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: InkWell(
              onTap: () => setState(() => _selectedEventTypeIndex = 1),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                decoration: BoxDecoration(
                  color: _selectedEventTypeIndex == 1
                      ? Colors.grey.shade800
                      : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _selectedEventTypeIndex == 1
                        ? Colors.grey.shade700
                        : Colors.grey.shade300,
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  'Past Events',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: _selectedEventTypeIndex == 1
                        ? Colors.white
                        : Colors.grey.shade700,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
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
                        ? Colors.blue.shade50
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? Colors.blue : Colors.grey.shade300,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Text(
                    tab,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.blue.shade700 : Colors.black54,
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
                  Icon(Icons.filter_list, color: Colors.white, size: 20),
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
                            style: const TextStyle(color: Colors.white),
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
                    color: isSelected ? Colors.blue : Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: isSelected ? Colors.blue : Colors.grey.shade300,
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.3),
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
    List<Map<String, dynamic>> tournaments = _getTournamentsForTab();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        children: tournaments.map((tournament) {
          return Column(
            children: [_buildEventCard(tournament), const SizedBox(height: 20)],
          );
        }).toList(),
      ),
    );
  }

  List<Map<String, dynamic>> _getTournamentsForTab() {
    List<Map<String, dynamic>> allTournaments = [
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
        'isSubscribed':
            _tournamentSubscriptions['Brown Country Tournament'] ?? false,
        'isOrganizer': true,
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
        'isSubscribed':
            _tournamentSubscriptions['Elite Sports Championship'] ?? false,
        'isOrganizer': false,
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
        'isSubscribed':
            _tournamentSubscriptions['City Sports Festival'] ?? false,
        'isOrganizer': false,
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
        'isSubscribed':
            _tournamentSubscriptions['Summer Games Tournament'] ?? false,
        'isOrganizer': false,
      },
      {
        'name': 'Winter Sports League',
        'venue': 'Mountain Sports Resort',
        'location': 'Denver, CO',
        'rating': 4.7,
        'sports': ['Skiing', 'Ice Hockey', 'Snowboarding'],
        'eventDate': 'Sat, December 15, 2025',
        'registrationDate': 'Fri, December 14, 2025',
        'organizerName': 'Tom Anderson',
        'organizerEmail': 'tom.anderson@email.com',
        'isSubscribed':
            _tournamentSubscriptions['Winter Sports League'] ?? false,
        'isOrganizer': false,
      },
    ];

    switch (_selectedTabIndex) {
      case 0: // As An Organizer
        return allTournaments
            .where((tournament) => tournament['isOrganizer'])
            .toList();
      case 1: // As A Subscriber
        return allTournaments
            .where(
              (tournament) =>
                  tournament['isSubscribed'] && !tournament['isOrganizer'],
            )
            .toList();
      case 2: // Unsubscribed Events
        return allTournaments
            .where(
              (tournament) =>
                  !tournament['isSubscribed'] && !tournament['isOrganizer'],
            )
            .toList();
      default:
        return allTournaments;
    }
  }

  Widget _buildEventCard(Map<String, dynamic> tournament) {
    return InkWell(
      onTap: () => _navigateToTournamentDetails(tournament),
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
              Positioned.fill(
                child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/images/pngtree-a-large-cricket-stadium-green-field-empty-picture-image_15985507.jpg',
                    ),
                    fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              // Overlay Content
              Container(
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
                  mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tournament Title and Favourite
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              tournament['name'],
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
                              color: Colors.blue.shade600,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blue.withOpacity(0.3),
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
                                  tournament['venue'],
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
                                      tournament['location'],
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
                                  tournament['rating'].toString(),
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
                                      color:
                                          index < tournament['rating'].floor()
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
                        children: (tournament['sports'] as List<String>).map((
                          sport,
                        ) {
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
                              tournament['eventDate'],
                            ),
                            const SizedBox(height: 6),
                            _buildScheduleItem(
                              'Registration Last Date',
                              tournament['registrationDate'],
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
                                          color: Colors.blue.shade600,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.blue.withOpacity(
                                                0.3,
                                              ),
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
                                              tournament['organizerName'],
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              tournament['organizerEmail'],
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
                                          color: Colors.blue.shade600,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
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

                          // Subscribe/Unsubscribe Button
                          GestureDetector(
                            onTap: () => _handleSubscriptionToggle(tournament),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              decoration: BoxDecoration(
                                color: tournament['isSubscribed']
                                    ? Colors.red.shade600
                                    : Colors.green.shade600,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        (tournament['isSubscribed']
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
                                    tournament['isSubscribed']
                                        ? Icons.cancel
                                        : Icons.check_circle,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    tournament['isSubscribed']
                                        ? 'Unsubscribe'
                                        : 'Subscribe',
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
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToTournamentDetails(Map<String, dynamic> tournament) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TournamentDetailsPage(
          tournamentName: tournament['name'],
          venue: tournament['venue'],
          location: tournament['location'],
          rating: tournament['rating'],
          availableSports: tournament['sports'],
          eventDate: '${tournament['eventDate']} - ${tournament['eventDate']}',
          registrationDate: tournament['registrationDate'],
          organizerName: tournament['organizerName'],
          organizerEmail: tournament['organizerEmail'],
          role: tournament['isOrganizer'] ? 'Organiser' : 'Coach',
        ),
      ),
    );
  }

  void _handleSubscriptionToggle(Map<String, dynamic> tournament) {
    setState(() {
      _tournamentSubscriptions[tournament['name']] =
          !tournament['isSubscribed'];
    });

    // Show confirmation message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          tournament['isSubscribed']
              ? 'Unsubscribed from ${tournament['name']}'
              : 'Subscribed to ${tournament['name']}',
        ),
        backgroundColor: tournament['isSubscribed']
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
        color: Colors.blue.shade600,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
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

  void _handleAddEvent() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Event'),
          content: const Text('Are you sure you want to add a new event?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Navigate to Add Event Form Screen
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AddEventFormScreen(),
                  ),
                );
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}

// Navigation from sidebar now centralized via RoleNavigationManager
