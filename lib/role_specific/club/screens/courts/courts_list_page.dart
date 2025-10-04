import 'package:flutter/material.dart';
import 'court_booking_page.dart';

class CourtsListPage extends StatelessWidget {
  const CourtsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Elite Sports Arena - Courts'),
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

            // Courts List
            const Text(
              'Available Courts',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Court 1
            _buildCourtCard(
              context,
              courtName: 'Court 1',
              available: true,
              maxPlayers: 30,
              maxTeams: 3,
              guestCapacity: 300,
              coachCount: 3,
              schedule: const {
                'weekdays': '08:30 - 22:00',
                'saturday': '11:30 - 20:00',
                'sunday': 'Off',
              },
              bookingStatus: const {
                'Available': 18,
                'Booked': 9,
                'Maintenance': 3,
              },
            ),
            const SizedBox(height: 16),

            // Court 2
            _buildCourtCard(
              context,
              courtName: 'Court 2',
              available: false,
              maxPlayers: 24,
              maxTeams: 2,
              guestCapacity: 150,
              coachCount: 2,
              schedule: const {
                'weekdays': '09:00 - 21:00',
                'saturday': '10:00 - 18:00',
                'sunday': 'Off',
              },
              bookingStatus: const {
                'Available': 10,
                'Booked': 18,
                'Maintenance': 2,
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArenaInfoCard() {
    return Container(
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
              children: [
                const Text(
                  'Elite Sports Arena',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
    required Map<String, String> schedule,
    required Map<String, int> bookingStatus,
  }) {
    return InkWell(
      onTap: () => _navigateToBooking(context, courtName),
      borderRadius: BorderRadius.circular(16),
      child: Container(
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
            // Court Header
            Row(
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
                    children: [
                      Text(
                        courtName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
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
            Row(
              children: [
                _buildStatChip('Max Players', '$maxPlayers'),
                const SizedBox(width: 8),
                _buildStatChip('Max Teams', '$maxTeams'),
                const SizedBox(width: 8),
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
            Row(
              children: [
                _buildStatusChip(
                  'Available',
                  bookingStatus['Available'] ?? 0,
                  Colors.green,
                ),
                const SizedBox(width: 8),
                _buildStatusChip(
                  'Booked',
                  bookingStatus['Booked'] ?? 0,
                  Colors.blueGrey,
                ),
                const SizedBox(width: 8),
                _buildStatusChip(
                  'Maintenance',
                  bookingStatus['Maintenance'] ?? 0,
                  Colors.orange,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.blue.shade200),
        ),
        child: Text(
          '$label: $value',
          style: const TextStyle(
            fontSize: 10,
            color: Colors.blue,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildStatusChip(String label, int count, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 10,
              ),
            ),
            Text(
              '$count',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToBooking(BuildContext context, String courtName) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CourtBookingPage(
          courtName: courtName,
          branchName: 'Elite Sports Arena',
        ),
      ),
    );
  }
}
