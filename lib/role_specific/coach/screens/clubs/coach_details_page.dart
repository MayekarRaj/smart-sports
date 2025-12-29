import 'package:flutter/material.dart';
import 'coach_page.dart';

class ClubDetailsPage extends StatefulWidget {
  final ClubData club;

  const ClubDetailsPage({super.key, required this.club});

  @override
  State<ClubDetailsPage> createState() => _ClubDetailsPageState();
}

class _ClubDetailsPageState extends State<ClubDetailsPage> {
  int _selectedBranchIndex = 0;
  int _selectedSportIndex = 0;
  bool _showMoreDetails = false;

  final List<String> _branches = ['Branch 1', 'Branch 2', 'Branch 3'];
  final List<String> _sports = [
    'Cricket',
    'Basketball',
    'Tennis',
    'Carom',
    'Chess',
  ];

  final List<CourtData> _courts = [
    CourtData(
      name: 'Court 1',
      status: 'Available',
      maxPlayers: 30,
      maxTeams: 3,
      guestCapacity: 300,
      coaches: 4,
      schedule: {
        'weekdays': '08:30 - 22:00',
        'saturday': '11:30 - 20:00',
        'sunday': 'Off',
      },
      imageUrl: 'assets/images/court1.jpg',
    ),
    CourtData(
      name: 'Court 2',
      status: 'Available',
      maxPlayers: 30,
      maxTeams: 3,
      guestCapacity: 300,
      coaches: 4,
      schedule: {
        'weekdays': '08:30 - 22:00',
        'saturday': '11:30 - 20:00',
        'sunday': 'Off',
      },
      imageUrl: 'assets/images/court2.jpg',
    ),
    CourtData(
      name: 'Court 3',
      status: 'Available',
      maxPlayers: 30,
      maxTeams: 3,
      guestCapacity: 300,
      coaches: 4,
      schedule: {
        'weekdays': '08:30 - 22:00',
        'saturday': '11:30 - 20:00',
        'sunday': 'Off',
      },
      imageUrl: 'assets/images/court3.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.club.name),
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.share)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.bookmark_border)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Club Header
            MobileClubHeader(club: widget.club),

            // Branch Selection
            MobileBranchSelector(
              branches: _branches,
              selectedIndex: _selectedBranchIndex,
              onBranchChanged: (index) =>
                  setState(() => _selectedBranchIndex = index),
            ),

            // Sport Selection
            MobileSportSelector(
              sports: _sports,
              selectedIndex: _selectedSportIndex,
              onSportChanged: (index) =>
                  setState(() => _selectedSportIndex = index),
            ),

            // Courts List
            MobileCourtsList(courts: _courts),

            // More Details Section
            MobileMoreDetailsSection(
              showMoreDetails: _showMoreDetails,
              onToggle: () =>
                  setState(() => _showMoreDetails = !_showMoreDetails),
            ),
          ],
        ),
      ),
    );
  }
}

// Mobile Club Header Component
class MobileClubHeader extends StatelessWidget {
  final ClubData club;

  const MobileClubHeader({super.key, required this.club});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
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
          // Club Name and Rating
          Row(
            children: [
              Expanded(
                child: Text(
                  club.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 20),
                  const SizedBox(width: 4),
                  Text(
                    '${club.rating}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Location
          Row(
            children: [
              const Icon(Icons.location_on, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                club.location,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Available Sports and Coach Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Available Sports Section
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'AVAILABLE SPORTS',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6B7280),
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
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Coach Section
              if ((club.coachImages).isNotEmpty || club.coaches > 0)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'COACH',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if ((club.coachImages).isNotEmpty)
                          _buildCoachAvatar((club.coachImages)[0]),
                        if ((club.coachImages).length > 1)
                          Transform.translate(
                            offset: const Offset(-8, 0),
                            child: _buildCoachAvatar((club.coachImages)[1]),
                          ),
                        if ((club.coachImages).length > 2)
                          Transform.translate(
                            offset: const Offset(-16, 0),
                            child: _buildCoachAvatar((club.coachImages)[2]),
                          ),
                        if ((club.coachImages).length > 3)
                          Transform.translate(
                            offset: const Offset(-24, 0),
                            child: _buildCoachAvatar((club.coachImages)[3]),
                          ),
                        if (club.coaches > (club.coachImages).length)
                          Transform.translate(
                            offset: Offset(
                              -8.0 *
                                  (club.coachImages).length.clamp(0, 3),
                              0,
                            ),
                            child: _buildCoachAvatar(
                              null,
                              remainingCount:
                                  club.coaches - (club.coachImages).length,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
            ],
          ),

          const SizedBox(height: 12),

          // Stats
          Row(
            children: [
              _buildStatChip('Branches', '${club.branches}'),
              const SizedBox(width: 8),
              _buildStatChip('Courts', '${club.courts}'),
              const SizedBox(width: 8),
              _buildStatChip('Coaches', '${club.coaches}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCoachAvatar(String? imageUrl, {int? remainingCount}) {
    return Container(
      width: 40,
      height: 40,
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
                  child: const Icon(Icons.person, size: 24, color: Colors.grey),
                ),
              )
            : Container(
                color: Colors.grey.shade300,
                child: Center(
                  child: remainingCount != null && remainingCount > 0
                      ? Text(
                          '+$remainingCount',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        )
                      : const Icon(Icons.person, size: 24, color: Colors.grey),
                ),
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
}

// Mobile Branch Selector Component
class MobileBranchSelector extends StatelessWidget {
  final List<String> branches;
  final int selectedIndex;
  final ValueChanged<int> onBranchChanged;

  const MobileBranchSelector({
    super.key,
    required this.branches,
    required this.selectedIndex,
    required this.onBranchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Branch',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: branches.asMap().entries.map((entry) {
                final index = entry.key;
                final branch = entry.value;
                final isSelected = selectedIndex == index;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: InkWell(
                    onTap: () => onBranchChanged(index),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? Colors.blue
                              : Colors.grey.shade300,
                        ),
                      ),
                      child: Text(
                        branch,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// Mobile Sport Selector Component
class MobileSportSelector extends StatelessWidget {
  final List<String> sports;
  final int selectedIndex;
  final ValueChanged<int> onSportChanged;

  const MobileSportSelector({
    super.key,
    required this.sports,
    required this.selectedIndex,
    required this.onSportChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Sport',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: sports.asMap().entries.map((entry) {
                final index = entry.key;
                final sport = entry.value;
                final isSelected = selectedIndex == index;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: InkWell(
                    onTap: () => onSportChanged(index),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? Colors.blue
                              : Colors.grey.shade300,
                        ),
                      ),
                      child: Text(
                        sport,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// Mobile Courts List Component
class MobileCourtsList extends StatelessWidget {
  final List<CourtData> courts;

  const MobileCourtsList({super.key, required this.courts});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Available Courts',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...courts.map((court) => MobileCourtCard(court: court)).toList(),
        ],
      ),
    );
  }
}

// Mobile Court Card Component
class MobileCourtCard extends StatelessWidget {
  final CourtData court;

  const MobileCourtCard({super.key, required this.court});

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Court Image
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: Container(
              height: 150,
              width: double.infinity,
              color: Colors.grey.shade300,
              child: const Icon(Icons.sports, size: 50, color: Colors.grey),
            ),
          ),

          // Court Details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Court Name and Status
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        court.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            'Available',
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

                const SizedBox(height: 12),

                // Court Metrics
                Row(
                  children: [
                    Expanded(
                      child: _buildMetricCard(
                        'MAX PLAYERS',
                        '${court.maxPlayers}',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildMetricCard('MAX TEAMS', '${court.maxTeams}'),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildMetricCard(
                        'GUEST CAP',
                        '${court.guestCapacity}',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Coaches
                const Text(
                  'COACH',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: List.generate(
                    court.coaches,
                    (index) => Container(
                      margin: const EdgeInsets.only(right: 8),
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 16,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Schedule
                const Text(
                  'Schedule',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 8),
                _buildScheduleItem('Weekdays', court.schedule['weekdays']!),
                const SizedBox(height: 8),
                _buildScheduleItem('Saturday', court.schedule['saturday']!),
                const SizedBox(height: 8),
                _buildScheduleItem(
                  'Sunday & National Holidays',
                  court.schedule['sunday']!,
                ),

                const SizedBox(height: 16),

                // Book Slot Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'BOOK SLOT',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.blue,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleItem(String label, String time) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue.shade200),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            time,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

// Mobile More Details Section Component
class MobileMoreDetailsSection extends StatelessWidget {
  final bool showMoreDetails;
  final VoidCallback onToggle;

  const MobileMoreDetailsSection({
    super.key,
    required this.showMoreDetails,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // More Details Header
          InkWell(
            onTap: onToggle,
            child: Container(
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
              child: Row(
                children: [
                  const Text(
                    'More Details',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  Icon(
                    showMoreDetails
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.blue,
                  ),
                ],
              ),
            ),
          ),

          // More Details Content
          if (showMoreDetails) ...[
            const SizedBox(height: 16),

            // Coaches Section
            MobileCoachesSection(),

            const SizedBox(height: 16),

            // Billing Method Section
            MobileBillingSection(),

            const SizedBox(height: 16),

            // Guest Seating Section
            MobileGuestSeatingSection(),

            const SizedBox(height: 16),

            // Sponsorship Section
            MobileSponsorshipSection(),
          ],
        ],
      ),
    );
  }
}

// Mobile Coaches Section Component
class MobileCoachesSection extends StatelessWidget {
  const MobileCoachesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF8B5CF6), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Heading
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFF374151),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: const Row(
              children: [
                Icon(Icons.verified_user, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text(
                  'Verify Coach Details',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          // Table
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: _buildCoachTable(),
          ),
        ],
      ),
    );
  }

  Widget _buildCoachTable() {
    final coaches = [
      {'isBlocked': false},
      {'isBlocked': true},
      {'isBlocked': false},
    ];

    return Table(
      border: TableBorder.all(color: Colors.grey.shade300),
      columnWidths: const {
        0: FixedColumnWidth(100), // Action
        1: FixedColumnWidth(150), // Coach
        2: FixedColumnWidth(150), // Rating
        3: FixedColumnWidth(120), // Gender Preference
        4: FixedColumnWidth(200), // Specialisation
        5: FixedColumnWidth(180), // Coaching Experience
        6: FixedColumnWidth(200), // Certification
        7: FixedColumnWidth(120), // Language Spoken
        8: FixedColumnWidth(180), // Availability
        9: FixedColumnWidth(200), // Distance
        10: FixedColumnWidth(150), // Hourly/Session Rate
      },
      children: [
        // Header Row
        TableRow(
          decoration: const BoxDecoration(color: Color(0xFF374151)),
          children: [
            _buildHeaderCell('Action'),
            _buildHeaderCell('Coach'),
            _buildHeaderCell('Rating'),
            _buildHeaderCell('Gender Preference'),
            _buildHeaderCell('Specialisation'),
            _buildHeaderCell('Coaching Experience'),
            _buildHeaderCell('Certification'),
            _buildHeaderCell('Language Spoken'),
            _buildHeaderCell('Availability'),
            _buildHeaderCell('Distance'),
            _buildHeaderCell('Hourly/Session Rate'),
          ],
        ),
        // Data Rows
        ...coaches.map((coach) => _buildCoachRow(coach['isBlocked'] as bool)),
      ],
    );
  }

  Widget _buildHeaderCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  TableRow _buildCoachRow(bool isBlocked) {
    return TableRow(
      decoration: const BoxDecoration(color: Colors.white),
      children: [
        _buildActionCell(isBlocked),
        _buildCoachCell(),
        _buildRatingCell(),
        _buildGenderPreferenceCell(),
        _buildSpecialisationCell(),
        _buildExperienceCell(),
        _buildCertificationCell(),
        _buildLanguageCell(),
        _buildAvailabilityCell(),
        _buildDistanceCell(),
        _buildRateCell(),
      ],
    );
  }

  Widget _buildActionCell(bool isBlocked) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Center(
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: isBlocked ? Colors.red : Colors.green,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            minimumSize: const Size(80, 36),
          ),
          child: Text(
            isBlocked ? 'Block' : 'Unblock',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  Widget _buildCoachCell() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.yellow.shade200,
            backgroundImage: const NetworkImage(
              'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150',
            ),
            onBackgroundImageError: (_, __) {},
          ),
          const SizedBox(height: 8),
          const Text(
            'Riya Mehra',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRatingCell() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                '4.8',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 4),
              ...List.generate(5, (index) => const Icon(
                    Icons.star,
                    color: Colors.yellow,
                    size: 14,
                  )),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '(20 Reviews)',
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderPreferenceCell() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: const Text(
        'Male, Female, Other',
        style: TextStyle(fontSize: 11, color: Colors.black87),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildSpecialisationCell() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: const Text(
        'Football (U17), Tennis, Strength & Conditioning',
        style: TextStyle(fontSize: 11, color: Colors.black87),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildExperienceCell() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: const Text(
        '5+ Years, Former National Player',
        style: TextStyle(fontSize: 11, color: Colors.black87),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildCertificationCell() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: const Text(
        'AIFF D-License, NASM CPT, First-Aid Certified',
        style: TextStyle(fontSize: 11, color: Colors.black87),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildLanguageCell() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: const Text(
        'English',
        style: TextStyle(fontSize: 11, color: Colors.black87),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildAvailabilityCell() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: const Text(
        'Weekdays 6-9 PM, Weekends Full Day',
        style: TextStyle(fontSize: 11, color: Colors.black87),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildDistanceCell() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: const Text(
        '5 Miles From Event Venue Richardson 62226',
        style: TextStyle(fontSize: 11, color: Colors.black87),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildRateCell() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'USD 50',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          GestureDetector(
            onTap: () {},
            child: const Text(
              'More Options',
              style: TextStyle(
                fontSize: 10,
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

// Mobile Coach Card Component
class MobileCoachCard extends StatelessWidget {
  final String name;
  final double rating;
  final String specialization;
  final String experience;
  final String certification;
  final String availability;
  final String distance;
  final String rate;
  final bool isBlocked;

  const MobileCoachCard({
    super.key,
    required this.name,
    required this.rating,
    required this.specialization,
    required this.experience,
    required this.certification,
    required this.availability,
    required this.distance,
    required this.rate,
    required this.isBlocked,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.blue.shade100,
                child: const Icon(Icons.person, color: Colors.blue),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Row(
                      children: [
                        ...List.generate(
                          5,
                          (index) => Icon(
                            index < rating ? Icons.star : Icons.star_border,
                            size: 12,
                            color: Colors.amber,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text('$rating', style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: isBlocked ? Colors.red : Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  isBlocked ? 'Block' : 'Unblock',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            specialization,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 4),
          Text(
            experience,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 4),
          Text(
            certification,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 4),
          Text(
            'Language: English',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 4),
          Text(
            availability,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 4),
          Text(
            distance,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 4),
          Text(
            'Rate: $rate',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

// Mobile Billing Section Component
class MobileBillingSection extends StatelessWidget {
  const MobileBillingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
          const Text(
            'Billing Method',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildBillingTable(),
        ],
      ),
    );
  }

  Widget _buildBillingTable() {
    final items = [
      {'meter': 'Per 30 Minutes', 'charge': 'USD 10'},
      {'meter': 'Per Hour', 'charge': 'USD 18'},
      {'meter': 'Per Day', 'charge': 'USD 50'},
      {'meter': 'Per Week', 'charge': 'USD 300'},
      {'meter': 'Per Month', 'charge': 'USD 1000'},
    ];

    return Table(
      border: TableBorder.all(
        color: Colors.grey.shade300,
        width: 1,
      ),
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(1),
      },
      children: [
        // Header Row
        TableRow(
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
          ),
          children: [
            _buildHeaderCell('Billing Meter'),
            _buildHeaderCell('Charges'),
          ],
        ),
        // Data Rows
        ...items.map((item) => TableRow(
              children: [
                _buildDataCell(item['meter']!, isLeft: true),
                _buildDataCell(item['charge']!, isLeft: false),
              ],
            )),
      ],
    );
  }

  Widget _buildHeaderCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildDataCell(String text, {required bool isLeft}) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black87,
        ),
        textAlign: isLeft ? TextAlign.left : TextAlign.right,
      ),
    );
  }
}

// Mobile Guest Seating Section Component
class MobileGuestSeatingSection extends StatelessWidget {
  const MobileGuestSeatingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Guest Seating Available',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Max Guest Capacity 100',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

// Mobile Sponsorship Section Component
class MobileSponsorshipSection extends StatelessWidget {
  const MobileSponsorshipSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
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
          const Text(
            'Sponsorship\'s Available For This Club',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildSponsorshipTable(),
        ],
      ),
    );
  }

  Widget _buildSponsorshipTable() {
    final items = [
      {'type': 'Bill Board', 'meter': 'Per Year'},
      {'type': 'Shoes', 'meter': 'Per Day'},
      {'type': 'Uniform', 'meter': 'Per Week'},
    ];

    return Table(
      border: TableBorder.all(
        color: Colors.black,
        width: 1,
      ),
      columnWidths: const {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(1),
      },
      children: [
        // Header Row
        TableRow(
          children: [
            _buildSponsorshipHeaderCell('Type'),
            _buildSponsorshipHeaderCell('Meter'),
          ],
        ),
        // Data Rows
        ...items.map((item) => TableRow(
              children: [
                _buildSponsorshipDataCell(item['type']!),
                _buildSponsorshipDataCell(item['meter']!),
              ],
            )),
      ],
    );
  }

  Widget _buildSponsorshipHeaderCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildSponsorshipDataCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black87,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

// Data models
class CourtData {
  final String name;
  final String status;
  final int maxPlayers;
  final int maxTeams;
  final int guestCapacity;
  final int coaches;
  final Map<String, String> schedule;
  final String imageUrl;

  CourtData({
    required this.name,
    required this.status,
    required this.maxPlayers,
    required this.maxTeams,
    required this.guestCapacity,
    required this.coaches,
    required this.schedule,
    required this.imageUrl,
  });
}
