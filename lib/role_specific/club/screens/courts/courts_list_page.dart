import 'package:flutter/material.dart';
import 'court_booking_page.dart';

class CourtsListPage extends StatefulWidget {
  final String arenaName;
  const CourtsListPage({super.key, this.arenaName = 'Elite Sports Arena'});

  @override
  State<CourtsListPage> createState() => _CourtsListPageState();
}

class _CourtsListPageState extends State<CourtsListPage> {
  String _selectedBranch = 'Branch 1';
  String _selectedSport = 'Basketball';

  // Branch locations
  final Map<String, String> _branchLocations = {
    'Branch 1': 'Adba Sports Complex Xcitenlay Club, Chicago',
    'Branch 2': 'Premier Sports Center, New York',
    'Branch 3': 'Thunder Sports Arena, Los Angeles',
  };

  // Utilization data by branch and sport
  final Map<String, Map<String, List<Map<String, dynamic>>>> _utilizationData =
      {
        'Branch 1': {
          'Basketball': [
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
          ],
          'Tennis': [
            {
              'court': 'Court 1',
              'perDay': {'value': '75%', 'color': 'green'},
              'perWeek': {'value': '60%', 'color': 'yellow'},
              'perMonth': {'value': '15%', 'color': 'red'},
            },
            {
              'court': 'Court 2',
              'perDay': {'value': '55%', 'color': 'yellow'},
              'perWeek': {'value': '85%', 'color': 'green'},
              'perMonth': {'value': '30%', 'color': 'red'},
            },
          ],
          'Cricket': [
            {
              'court': 'Court 1',
              'perDay': {'value': '90%', 'color': 'green'},
              'perWeek': {'value': '80%', 'color': 'green'},
              'perMonth': {'value': '50%', 'color': 'yellow'},
            },
          ],
        },
        'Branch 2': {
          'Basketball': [
            {
              'court': 'Court 1',
              'perDay': {'value': '70%', 'color': 'yellow'},
              'perWeek': {'value': '65%', 'color': 'yellow'},
              'perMonth': {'value': '20%', 'color': 'red'},
            },
            {
              'court': 'Court 2',
              'perDay': {'value': '50%', 'color': 'yellow'},
              'perWeek': {'value': '75%', 'color': 'green'},
              'perMonth': {'value': '35%', 'color': 'red'},
            },
          ],
          'Tennis': [
            {
              'court': 'Court 1',
              'perDay': {'value': '65%', 'color': 'yellow'},
              'perWeek': {'value': '70%', 'color': 'yellow'},
              'perMonth': {'value': '25%', 'color': 'red'},
            },
          ],
        },
        'Branch 3': {
          'Basketball': [
            {
              'court': 'Court 1',
              'perDay': {'value': '88%', 'color': 'green'},
              'perWeek': {'value': '72%', 'color': 'yellow'},
              'perMonth': {'value': '12%', 'color': 'red'},
            },
          ],
        },
      };

  // Courts data by branch and sport
  final Map<String, Map<String, List<Map<String, dynamic>>>> _courtsData = {
    'Branch 1': {
      'Basketball': [
        {
          'courtName': 'Court 1',
          'available': true,
          'maxPlayers': 30,
          'maxTeams': 3,
          'guestCapacity': 300,
          'coachCount': 3,
          'rating': 4.8,
          'coaches': [
            {'name': 'John Smith', 'rating': 4.9, 'sport': 'Basketball'},
            {'name': 'Sarah Johnson', 'rating': 4.7, 'sport': 'Basketball'},
            {'name': 'Mike Wilson', 'rating': 4.8, 'sport': 'Basketball'},
          ],
          'schedule': {
            'weekdays': '08:30 - 22:00',
            'saturday': '11:30 - 20:00',
            'sunday': 'Off',
          },
          'bookingStatus': {'Available': 18, 'Booked': 9, 'Maintenance': 3},
        },
        {
          'courtName': 'Court 2',
          'available': false,
          'maxPlayers': 24,
          'maxTeams': 2,
          'guestCapacity': 150,
          'coachCount': 2,
          'rating': 4.6,
          'coaches': [
            {'name': 'Emily Davis', 'rating': 4.8, 'sport': 'Basketball'},
            {'name': 'David Brown', 'rating': 4.5, 'sport': 'Basketball'},
          ],
          'schedule': {
            'weekdays': '09:00 - 21:00',
            'saturday': '10:00 - 18:00',
            'sunday': 'Off',
          },
          'bookingStatus': {'Available': 10, 'Booked': 18, 'Maintenance': 2},
        },
        {
          'courtName': 'Court 3',
          'available': true,
          'maxPlayers': 20,
          'maxTeams': 2,
          'guestCapacity': 200,
          'coachCount': 2,
          'rating': 4.7,
          'coaches': [
            {'name': 'Robert Lee', 'rating': 4.9, 'sport': 'Basketball'},
            {'name': 'Lisa Chen', 'rating': 4.6, 'sport': 'Basketball'},
          ],
          'schedule': {
            'weekdays': '10:00 - 20:00',
            'saturday': '12:00 - 18:00',
            'sunday': 'Off',
          },
          'bookingStatus': {'Available': 15, 'Booked': 12, 'Maintenance': 3},
        },
      ],
      'Tennis': [
        {
          'courtName': 'Court 1',
          'available': true,
          'maxPlayers': 4,
          'maxTeams': 2,
          'guestCapacity': 50,
          'coachCount': 2,
          'rating': 4.9,
          'coaches': [
            {'name': 'Tennis Pro', 'rating': 5.0, 'sport': 'Tennis'},
            {'name': 'Tennis Master', 'rating': 4.8, 'sport': 'Tennis'},
          ],
          'schedule': {
            'weekdays': '07:00 - 21:00',
            'saturday': '08:00 - 19:00',
            'sunday': '09:00 - 17:00',
          },
          'bookingStatus': {'Available': 20, 'Booked': 8, 'Maintenance': 2},
        },
      ],
      'Cricket': [
        {
          'courtName': 'Court 1',
          'available': true,
          'maxPlayers': 22,
          'maxTeams': 2,
          'guestCapacity': 500,
          'coachCount': 3,
          'rating': 4.8,
          'coaches': [
            {'name': 'Cricket Coach', 'rating': 4.9, 'sport': 'Cricket'},
            {'name': 'Cricket Pro', 'rating': 4.7, 'sport': 'Cricket'},
          ],
          'schedule': {
            'weekdays': '06:00 - 22:00',
            'saturday': '07:00 - 20:00',
            'sunday': '08:00 - 18:00',
          },
          'bookingStatus': {'Available': 25, 'Booked': 3, 'Maintenance': 2},
        },
      ],
    },
    'Branch 2': {
      'Basketball': [
        {
          'courtName': 'Court 1',
          'available': true,
          'maxPlayers': 28,
          'maxTeams': 3,
          'guestCapacity': 250,
          'coachCount': 2,
          'rating': 4.7,
          'coaches': [
            {'name': 'Branch 2 Coach 1', 'rating': 4.8, 'sport': 'Basketball'},
            {'name': 'Branch 2 Coach 2', 'rating': 4.6, 'sport': 'Basketball'},
          ],
          'schedule': {
            'weekdays': '09:00 - 21:00',
            'saturday': '10:00 - 19:00',
            'sunday': 'Off',
          },
          'bookingStatus': {'Available': 12, 'Booked': 15, 'Maintenance': 3},
        },
      ],
    },
    'Branch 3': {
      'Basketball': [
        {
          'courtName': 'Court 1',
          'available': true,
          'maxPlayers': 32,
          'maxTeams': 3,
          'guestCapacity': 350,
          'coachCount': 3,
          'rating': 4.9,
          'coaches': [
            {'name': 'Branch 3 Coach 1', 'rating': 5.0, 'sport': 'Basketball'},
            {'name': 'Branch 3 Coach 2', 'rating': 4.8, 'sport': 'Basketball'},
          ],
          'schedule': {
            'weekdays': '08:00 - 22:00',
            'saturday': '09:00 - 20:00',
            'sunday': '10:00 - 18:00',
          },
          'bookingStatus': {'Available': 20, 'Booked': 8, 'Maintenance': 2},
        },
      ],
    },
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.arenaName} - Courts'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Arena Info Card
            _buildArenaInfoCard(),
            const SizedBox(height: 20),

            // Branch Selection
            _buildBranchSelection(),
            const SizedBox(height: 16),

            // Sport Selection
            _buildSportSelection(),
            const SizedBox(height: 20),

            // Location Map
            _buildLocationMap(),
            const SizedBox(height: 20),

            // Utilization Section
            _buildUtilizationSection(),
            const SizedBox(height: 20),

            // Courts List
            Text(
              'Available Courts - $_selectedSport',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Dynamic Courts based on branch and sport
            ..._buildCourtsList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildArenaInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Arena Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 80,
              height: 80,
              color: Colors.blue.shade100,
              child: const Icon(
                Icons.sports_tennis,
                color: Colors.blue,
                size: 40,
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Arena Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.arenaName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
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
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '2 Courts Available',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourtCard(
    BuildContext context, {
    required String courtName,
    required bool available,
    required int maxPlayers,
    required int maxTeams,
    required int guestCapacity,
    required int coachCount,
    required double rating,
    required List<Map<String, dynamic>> coaches,
    required Map<String, String> schedule,
    required Map<String, int> bookingStatus,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => _navigateToBooking(context, courtName),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Court Header
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Court Icon
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: available
                          ? Colors.green.shade100
                          : Colors.red.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.sports_tennis,
                      color: available ? Colors.green : Colors.red,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Court Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          courtName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: available ? Colors.green : Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            available ? 'Available' : 'Unavailable',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Arrow Icon
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey.shade400,
                    size: 16,
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Court Stats
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildStatChip('Max Players', '$maxPlayers'),
                  _buildStatChip('Max Teams', '$maxTeams'),
                  _buildStatChip('Guest Cap', '$guestCapacity'),
                ],
              ),

              const SizedBox(height: 12),

              // Schedule
              const Text(
                'Schedule',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(
                'Weekdays: ${schedule['weekdays']}',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
              Text(
                'Saturday: ${schedule['saturday']}',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
              Text(
                'Sunday: ${schedule['sunday']}',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),

              const SizedBox(height: 12),

              // Booking Status
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildStatusChip(
                    'Available',
                    bookingStatus['Available'] ?? 0,
                    Colors.green,
                  ),
                  _buildStatusChip(
                    'Booked',
                    bookingStatus['Booked'] ?? 0,
                    Colors.blueGrey,
                  ),
                  _buildStatusChip(
                    'Maintenance',
                    bookingStatus['Maintenance'] ?? 0,
                    Colors.orange,
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Rating Section
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber[200]!),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      '$rating',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'Court Rating',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Coaches Section
              const Text(
                'Coaches',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...coaches.map((coach) => _buildCoachCard(coach)).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCoachCard(Map<String, dynamic> coach) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.blue[100],
            child: Text(
              coach['name'][0],
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
                  coach['name'],
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  coach['sport'],
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 16),
              const SizedBox(width: 4),
              Text(
                '${coach['rating']}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Text(
        '$label: $value',
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.blue,
        ),
      ),
    );
  }

  Widget _buildStatusChip(String label, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        '$label: $count',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildBranchSelection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Branch',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildBranchChip('Branch 1')),
              const SizedBox(width: 8),
              Expanded(child: _buildBranchChip('Branch 2')),
              const SizedBox(width: 8),
              Expanded(child: _buildBranchChip('Branch 3')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBranchChip(String branch) {
    final isSelected = _selectedBranch == branch;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedBranch = branch;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1E40AF) : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF1E40AF) : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_on,
              color: isSelected ? Colors.white : Colors.grey[600],
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              branch,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationMap() {
    return Container(
      width: double.infinity,
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
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: const Row(
              children: [
                Icon(Icons.location_on, color: Colors.white, size: 20),
                SizedBox(width: 8),
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
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Location',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.red[700],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _branchLocations[_selectedBranch] ?? 'Location not available',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSportSelection() {
    final sports = ['Cricket', 'Basketball', 'Tennis', 'Carrom Board', 'Chess'];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Sport',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: sports.map((sport) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _buildSportChip(sport),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSportChip(String sport) {
    final isSelected = _selectedSport == sport;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedSport = sport;
        });
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1E40AF) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF1E40AF) : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Text(
          sport,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _buildUtilizationSection() {
    final utilizationData =
        _utilizationData[_selectedBranch]?[_selectedSport] ?? [];

    if (utilizationData.isEmpty) {
      return const SizedBox.shrink();
    }

    // Calculate overall utilization
    double totalPerDay = 0;
    double totalPerWeek = 0;
    double totalPerMonth = 0;
    int count = utilizationData.length;

    for (var data in utilizationData) {
      totalPerDay += double.parse(
        data['perDay']['value'].toString().replaceAll('%', ''),
      );
      totalPerWeek += double.parse(
        data['perWeek']['value'].toString().replaceAll('%', ''),
      );
      totalPerMonth += double.parse(
        data['perMonth']['value'].toString().replaceAll('%', ''),
      );
    }

    final overallData = {
      'court': 'Overall Utilization',
      'perDay': {
        'value': '${(totalPerDay / count).toStringAsFixed(2)}%',
        'color': 'black',
      },
      'perWeek': {
        'value': '${(totalPerWeek / count).toStringAsFixed(2)}%',
        'color': totalPerWeek / count > 70 ? 'green' : 'black',
      },
      'perMonth': {
        'value': '${(totalPerMonth / count).toStringAsFixed(0)}%',
        'color': totalPerMonth / count > 50 ? 'green' : 'red',
      },
    };

    return Container(
      width: double.infinity,
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
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.analytics, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  '$_selectedSport Utilization',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          // Utilization Table/Cards
          LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 600;

              if (isMobile) {
                // Mobile: Cards
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      ...utilizationData
                          .map((data) => _buildUtilizationCard(data))
                          .toList(),
                      const SizedBox(height: 12),
                      _buildUtilizationCard(overallData),
                    ],
                  ),
                );
              } else {
                // Desktop: Table
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: _buildUtilizationTable(utilizationData, overallData),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildUtilizationCard(Map<String, dynamic> data) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data['court'],
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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

  Widget _buildUtilizationTable(
    List<Map<String, dynamic>> data,
    Map<String, dynamic> overallData,
  ) {
    final allData = [...data, overallData];

    return DataTable(
      headingRowColor: MaterialStateProperty.all(Colors.grey[100]),
      columns: [
        DataColumn(
          label: Text(
            '$_selectedSport Utilization',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        const DataColumn(
          label: Text('Per Day', style: TextStyle(fontWeight: FontWeight.w600)),
        ),
        const DataColumn(
          label: Text(
            'Per Week',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        const DataColumn(
          label: Text(
            'Per Month',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
      rows: allData.map((row) {
        final isOverall = row['court'] == 'Overall Utilization';
        return DataRow(
          cells: [
            DataCell(
              Text(
                row['court'],
                style: TextStyle(
                  fontWeight: isOverall ? FontWeight.w600 : FontWeight.w500,
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

  Widget _buildUtilizationCell(Map<String, dynamic> data) {
    Color color;
    switch (data['color']) {
      case 'green':
        color = Colors.green;
        break;
      case 'yellow':
        color = Colors.orange;
        break;
      case 'red':
        color = Colors.red;
        break;
      case 'black':
        color = Colors.black87;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        data['value']!,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildUtilizationItem(String label, Map<String, String> data) {
    Color color;
    switch (data['color']) {
      case 'green':
        color = Colors.green;
        break;
      case 'yellow':
        color = Colors.orange;
        break;
      case 'red':
        color = Colors.red;
        break;
      case 'black':
        color = Colors.black87;
        break;
      default:
        color = Colors.grey;
    }

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
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Text(
            data['value']!,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildCourtsList(BuildContext context) {
    final courts = _courtsData[_selectedBranch]?[_selectedSport] ?? [];

    if (courts.isEmpty) {
      return [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Center(
            child: Text(
              'No courts available for $_selectedSport at $_selectedBranch',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ),
        ),
      ];
    }

    return courts.map((courtData) {
      return _buildCourtCard(
        context,
        courtName: courtData['courtName'] as String,
        available: courtData['available'] as bool,
        maxPlayers: courtData['maxPlayers'] as int,
        maxTeams: courtData['maxTeams'] as int,
        guestCapacity: courtData['guestCapacity'] as int,
        coachCount: courtData['coachCount'] as int,
        rating: courtData['rating'] as double,
        coaches: courtData['coaches'] as List<Map<String, dynamic>>,
        schedule: courtData['schedule'] as Map<String, String>,
        bookingStatus: courtData['bookingStatus'] as Map<String, int>,
      );
    }).toList();
  }

  void _navigateToBooking(BuildContext context, String courtName) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CourtBookingPage(
          courtName: courtName,
          branchName: widget.arenaName,
        ),
      ),
    );
  }
}
