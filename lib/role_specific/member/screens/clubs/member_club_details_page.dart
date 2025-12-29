import 'package:flutter/material.dart';
import 'member_clubs_page.dart';

class MemberClubDetailsPage extends StatefulWidget {
  final MemberClubData club;

  const MemberClubDetailsPage({super.key, required this.club});

  @override
  State<MemberClubDetailsPage> createState() => _MemberClubDetailsPageState();
}

class _MemberClubDetailsPageState extends State<MemberClubDetailsPage> {
  int _selectedBranchIndex = 0;
  int _selectedSportIndex = 0;
  bool _showMoreDetails = false;
  bool _isFavorite = false;

  final List<String> _branches = ['Branch 1', 'Branch 2', 'Branch 3'];
  final List<String> _sports = [
    'Cricket',
    'Basketball',
    'Tennis',
    'Carom',
    'Chess',
  ];

  final List<MemberCourtData> _courts = [
    MemberCourtData(
      name: 'Court 1',
      status: 'Available',
      maxPlayers: 30,
      maxTeams: 3,
      guestCapacity: 300,
      coaches: 4,
      coachImages: [
        'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150&h=150&fit=crop',
        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop',
        'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop',
        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop',
      ],
      schedule: {
        'weekdays': '08:30 - 22:00',
        'saturday': '11:30 - 20:00',
        'sunday': 'Off',
      },
      imageUrl: 'assets/images/court1.jpg',
    ),
    MemberCourtData(
      name: 'Court 2',
      status: 'Available',
      maxPlayers: 30,
      maxTeams: 3,
      guestCapacity: 300,
      coaches: 4,
      coachImages: [
        'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150&h=150&fit=crop',
        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop',
        'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop',
      ],
      schedule: {
        'weekdays': '08:30 - 22:00',
        'saturday': '11:30 - 20:00',
        'sunday': 'Off',
      },
      imageUrl: 'assets/images/court2.jpg',
    ),
    MemberCourtData(
      name: 'Court 3',
      status: 'Available',
      maxPlayers: 30,
      maxTeams: 3,
      guestCapacity: 300,
      coaches: 4,
      coachImages: [
        'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150&h=150&fit=crop',
        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop',
        'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop',
        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop',
      ],
      schedule: {
        'weekdays': '08:30 - 22:00',
        'saturday': '11:30 - 20:00',
        'sunday': 'Off',
      },
      imageUrl: 'assets/images/court3.jpg',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.club.isFavorite;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(widget.club.name),
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
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Share functionality
            },
            icon: const Icon(Icons.share),
            tooltip: 'Share',
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _isFavorite = !_isFavorite;
              });
            },
            icon: Icon(_isFavorite ? Icons.bookmark : Icons.bookmark_border),
            tooltip: _isFavorite ? 'Remove from favorites' : 'Add to favorites',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Club Header
            _MemberClubHeader(
              club: widget.club,
              isFavorite: _isFavorite,
              onFavoriteToggle: () {
                setState(() {
                  _isFavorite = !_isFavorite;
                });
              },
            ),

            // Branch Selection
            _MemberBranchSelector(
              branches: _branches,
              selectedIndex: _selectedBranchIndex,
              onBranchChanged: (index) =>
                  setState(() => _selectedBranchIndex = index),
            ),

            // Sport Selection
            _MemberSportSelector(
              sports: _sports,
              selectedIndex: _selectedSportIndex,
              onSportChanged: (index) =>
                  setState(() => _selectedSportIndex = index),
            ),

            // Map Section
            _MemberMapSection(location: widget.club.location),

            // Courts List
            _MemberCourtsList(courts: _courts),

            // More Details Section
            _MemberMoreDetailsSection(
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

// Member Club Header Component
class _MemberClubHeader extends StatelessWidget {
  final MemberClubData club;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const _MemberClubHeader({
    required this.club,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

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
          // Club Name and Favorite Button
          Row(
            children: [
              Expanded(
                child: Text(
                  club.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: onFavoriteToggle,
                icon: Icon(
                  isFavorite ? Icons.bookmark : Icons.bookmark_border,
                  size: 16,
                ),
                label: Text(isFavorite ? 'Favourite' : 'Favourite'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isFavorite
                      ? const Color(0xFF009A69)
                      : Colors.grey.shade200,
                  foregroundColor: isFavorite ? Colors.white : Colors.black87,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Location
          Row(
            children: [
              const Icon(Icons.location_on, size: 16, color: Color(0xFF6B7280)),
              const SizedBox(width: 4),
              Text(
                club.location,
                style: const TextStyle(color: Color(0xFF6B7280), fontSize: 14),
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
                                color: const Color(0xFF009A69),
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
                      if (club.coachImages.isNotEmpty)
                        _buildCoachAvatar(club.coachImages[0]),
                      if (club.coachImages.length > 1)
                        Transform.translate(
                          offset: const Offset(-8, 0),
                          child: _buildCoachAvatar(club.coachImages[1]),
                        ),
                      if (club.coachImages.length > 2)
                        Transform.translate(
                          offset: const Offset(-16, 0),
                          child: _buildCoachAvatar(club.coachImages[2]),
                        ),
                      if (club.coachImages.length > 3)
                        Transform.translate(
                          offset: const Offset(-24, 0),
                          child: _buildCoachAvatar(club.coachImages[3]),
                        ),
                      if (club.coaches > club.coachImages.length)
                        Transform.translate(
                          offset: Offset(
                            -8.0 * club.coachImages.length.clamp(0, 3),
                            0,
                          ),
                          child: _buildCoachAvatar(
                            null,
                            remainingCount:
                                club.coaches - club.coachImages.length,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Rating and Stats Row
          Row(
            children: [
              // Rating Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ...List.generate(
                        5,
                        (index) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${club.rating}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const Text(
                    'Club Rating',
                    style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                  ),
                ],
              ),

              const Spacer(),

              // Stats
              _buildStatChip('BRANCHES', '${club.branches}'),
              const SizedBox(width: 8),
              _buildStatChip('COURTS', '${club.courts}'),
            ],
          ),

          const SizedBox(height: 16),

          // Action Buttons
          Row(
            children: [
              Expanded(child: _buildActionButton(Icons.share, 'Share')),
              const SizedBox(width: 8),
              Expanded(child: _buildActionButton(Icons.sports_tennis, 'Coach')),
              const SizedBox(width: 8),
              Expanded(child: _buildActionButton(Icons.group, 'Players')),
              const SizedBox(width: 8),
              Expanded(child: _buildActionButton(Icons.business, 'Sponsor')),
              const SizedBox(width: 8),
              Expanded(child: _buildActionButton(Icons.reviews, 'Reviews')),
            ],
          ),
        ],
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
        backgroundColor: const Color(0xFF009A69),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
}

// Member Branch Selector Component
class _MemberBranchSelector extends StatelessWidget {
  final List<String> branches;
  final int selectedIndex;
  final ValueChanged<int> onBranchChanged;

  const _MemberBranchSelector({
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
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2937),
            ),
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
                        color: isSelected
                            ? const Color(0xFF009A69)
                            : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF009A69)
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

// Member Sport Selector Component
class _MemberSportSelector extends StatelessWidget {
  final List<String> sports;
  final int selectedIndex;
  final ValueChanged<int> onSportChanged;

  const _MemberSportSelector({
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
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2937),
            ),
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
                        color: isSelected
                            ? const Color(0xFF009A69)
                            : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF009A69)
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

// Member Courts List Component
class _MemberCourtsList extends StatelessWidget {
  final List<MemberCourtData> courts;

  const _MemberCourtsList({required this.courts});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Available Courts',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 12),
          ...courts.map((court) => _MemberCourtCard(court: court)).toList(),
        ],
      ),
    );
  }
}

// Member Court Card Component
class _MemberCourtCard extends StatelessWidget {
  final MemberCourtData court;

  const _MemberCourtCard({required this.court});

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
              child: Image.asset(
                court.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.sports_basketball,
                    size: 50,
                    color: Colors.grey,
                  );
                },
              ),
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
                          color: Color(0xFF1F2937),
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
                  children: [
                    if (court.coachImages.isNotEmpty)
                      _buildCoachAvatar(court.coachImages[0]),
                    if (court.coachImages.length > 1)
                      Transform.translate(
                        offset: const Offset(-8, 0),
                        child: _buildCoachAvatar(court.coachImages[1]),
                      ),
                    if (court.coachImages.length > 2)
                      Transform.translate(
                        offset: const Offset(-16, 0),
                        child: _buildCoachAvatar(court.coachImages[2]),
                      ),
                    if (court.coachImages.length > 3)
                      Transform.translate(
                        offset: const Offset(-24, 0),
                        child: _buildCoachAvatar(court.coachImages[3]),
                      ),
                    if (court.coaches > court.coachImages.length)
                      Transform.translate(
                        offset: Offset(
                          -8.0 * court.coachImages.length.clamp(0, 3),
                          0,
                        ),
                        child: _buildCoachAvatar(
                          null,
                          remainingCount:
                              court.coaches - court.coachImages.length,
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 16),

                // Book Slot Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to booking page
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Booking functionality coming soon!'),
                          backgroundColor: Color(0xFF009A69),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'BOOK SLOT',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
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
        border: Border.all(color: const Color(0xFF009A69).withOpacity(0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: Color(0xFF009A69),
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
            border: Border.all(color: const Color(0xFF009A69).withOpacity(0.3)),
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
}

// Member Map Section Component
class _MemberMapSection extends StatelessWidget {
  final String location;

  const _MemberMapSection({required this.location});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: 200,
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
                        location,
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

// Member More Details Section Component
class _MemberMoreDetailsSection extends StatelessWidget {
  final bool showMoreDetails;
  final VoidCallback onToggle;

  const _MemberMoreDetailsSection({
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
          Container(
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
            child: InkWell(
              onTap: onToggle,
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'More Details',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                  ),
                  Icon(
                    showMoreDetails
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: const Color(0xFF009A69),
                  ),
                ],
              ),
            ),
          ),

          // More Details Content
          if (showMoreDetails) ...[
            const SizedBox(height: 16),

            // Coaches Section
            const _MemberCoachesSection(),

            const SizedBox(height: 16),

            // Billing Method Section
            const _MemberBillingSection(),

            const SizedBox(height: 16),

            // Guest Seating Section
            const _MemberGuestSeatingSection(),

            const SizedBox(height: 16),

            // Sponsorship Section
            const _MemberSponsorshipSection(),
          ],
        ],
      ),
    );
  }
}

// Member Coaches Section Component
class _MemberCoachesSection extends StatelessWidget {
  const _MemberCoachesSection();

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
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Coaches',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF009A69),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Upgrade To Unlock Coach Ratings',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Coach Table Header
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF009A69),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  SizedBox(
                    width: 80,
                    child: Text(
                      'Action',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: Text(
                      'Coach',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 90,
                    child: Text(
                      'Coach Ratings',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 80,
                    child: Text(
                      'Gender Pref',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 140,
                    child: Text(
                      'Specialisation',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 140,
                    child: Text(
                      'Coaching Experience',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 140,
                    child: Text(
                      'Certification',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 80,
                    child: Text(
                      'Languages',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 140,
                    child: Text(
                      'Availability',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 80,
                    child: Text(
                      'Distance',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 90,
                    child: Text(
                      'Hourly Rate',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Coach Cards
          ...List.generate(
            3,
            (index) => _MemberCoachCard(
              name: 'Riya Mehra',
              rating: 3.8,
              genderPreference: 'Female',
              specialization: 'Football (U17), Tennis, Strength & Conditioning',
              experience: '5+ Years, Former National Player',
              certification: 'AIFF D-License, NASM CPT, First-Aid Certified',
              languages: 'English, Hindi',
              availability: 'Weekdays 6-9 PM, Weekends Full Day',
              distance: '5 Miles',
              rate: 'USD 50',
              isBlocked: index == 1,
              isUpgraded: false,
            ),
          ),
        ],
      ),
    );
  }
}

// Member Coach Card Component
class _MemberCoachCard extends StatelessWidget {
  final String name;
  final double rating;
  final String genderPreference;
  final String specialization;
  final String experience;
  final String certification;
  final String languages;
  final String availability;
  final String distance;
  final String rate;
  final bool isBlocked;
  final bool isUpgraded;

  const _MemberCoachCard({
    required this.name,
    required this.rating,
    required this.genderPreference,
    required this.specialization,
    required this.experience,
    required this.certification,
    required this.languages,
    required this.availability,
    required this.distance,
    required this.rate,
    required this.isBlocked,
    required this.isUpgraded,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            // Action
            SizedBox(
              width: 80,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: isBlocked ? Colors.red : Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 6,
                  ),
                  minimumSize: const Size(0, 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  isBlocked ? 'Block' : 'Unblock',
                  style: const TextStyle(fontSize: 9),
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Coach
            SizedBox(
              width: 100,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: Colors.blue.shade100,
                    child: const Icon(
                      Icons.person,
                      size: 14,
                      color: Color(0xFF009A69),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 10,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Coach Ratings
            SizedBox(
              width: 90,
              child: isUpgraded
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ...List.generate(
                          5,
                          (index) => Icon(
                            index < rating.toInt()
                                ? Icons.star
                                : Icons.star_border,
                            size: 10,
                            color: Colors.amber,
                          ),
                        ),
                        const SizedBox(width: 2),
                        Text('$rating', style: const TextStyle(fontSize: 10)),
                      ],
                    )
                  : const Text(
                      'Locked',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
            ),
            const SizedBox(width: 8),
            // Gender Preference
            SizedBox(
              width: 80,
              child: Text(
                genderPreference,
                style: const TextStyle(fontSize: 10),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            // Specialisation
            SizedBox(
              width: 140,
              child: Text(
                specialization,
                style: const TextStyle(fontSize: 10),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            // Coaching Experience
            SizedBox(
              width: 140,
              child: Text(
                experience,
                style: const TextStyle(fontSize: 10),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            // Certification
            SizedBox(
              width: 140,
              child: Text(
                certification,
                style: const TextStyle(fontSize: 10),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            // Languages
            SizedBox(
              width: 80,
              child: Text(
                languages,
                style: const TextStyle(fontSize: 10),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            // Availability
            SizedBox(
              width: 140,
              child: Text(
                availability,
                style: const TextStyle(fontSize: 10),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            // Distance
            SizedBox(
              width: 80,
              child: Text(
                distance,
                style: const TextStyle(fontSize: 10),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            // Hourly Rate
            SizedBox(
              width: 90,
              child: Text(
                rate,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF009A69),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Member Billing Section Component
class _MemberBillingSection extends StatelessWidget {
  const _MemberBillingSection();

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
          // Table Header
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF009A69),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Billing Meter',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'Charges',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          ..._buildBillingItems(),
        ],
      ),
    );
  }

  List<Widget> _buildBillingItems() {
    final items = [
      {'meter': 'Per 30 Minutes', 'charge': 'USD 10'},
      {'meter': 'Per Hour', 'charge': 'USD 18'},
      {'meter': 'Per Day', 'charge': 'USD 50'},
      {'meter': 'Per Week', 'charge': 'USD 300'},
      {'meter': 'Per Month', 'charge': 'USD 1000'},
    ];

    return items
        .map(
          (item) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    item['meter']!,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      item['charge']!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF009A69),
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
        .toList();
  }
}

// Member Guest Seating Section Component
class _MemberGuestSeatingSection extends StatelessWidget {
  const _MemberGuestSeatingSection();

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

// Member Sponsorship Section Component
class _MemberSponsorshipSection extends StatelessWidget {
  const _MemberSponsorshipSection();

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
            'Sponsorship\'s Available For This Club',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          // Table Header
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF009A69),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Type',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'Metre',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          ..._buildSponsorshipItems(),
        ],
      ),
    );
  }

  List<Widget> _buildSponsorshipItems() {
    final items = [
      {'type': 'Bill Board', 'meter': 'Per Year'},
      {'type': 'Shoes', 'meter': 'Per Day'},
      {'type': 'Uniform', 'meter': 'Per Week'},
    ];

    return items
        .map(
          (item) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    item['type']!,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      item['meter']!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
        .toList();
  }
}

// Data models
class MemberCourtData {
  final String name;
  final String status;
  final int maxPlayers;
  final int maxTeams;
  final int guestCapacity;
  final int coaches;
  final List<String> coachImages;
  final Map<String, String> schedule;
  final String imageUrl;

  MemberCourtData({
    required this.name,
    required this.status,
    required this.maxPlayers,
    required this.maxTeams,
    required this.guestCapacity,
    required this.coaches,
    required this.coachImages,
    required this.schedule,
    required this.imageUrl,
  });
}
