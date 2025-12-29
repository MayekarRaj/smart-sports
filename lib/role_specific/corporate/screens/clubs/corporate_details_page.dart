import 'package:flutter/material.dart';

class CorporateDetailsPage extends StatefulWidget {
  final CorporateData corporate;

  const CorporateDetailsPage({super.key, required this.corporate});

  @override
  State<CorporateDetailsPage> createState() => _CorporateDetailsPageState();
}

class _CorporateDetailsPageState extends State<CorporateDetailsPage> {
  int _selectedBranchIndex = 0;
  int _selectedSportIndex = 1; // Basketball is selected by default
  bool _showMoreDetails = false;
  bool _isFavourite = false;

  final List<String> _branches = ['Branch 1', 'Branch 2', 'Branch 3'];

  final List<String> _sports = [
    'Cricket',
    'Basketball',
    'Tennis',
    'Carom',
    'Chess',
    'Badminton',
    'Squash',
    'Football',
    'Swimming',
    'Gym',
    'Table Tennis',
  ];

  // Sport to court mapping for each branch
  final Map<String, Map<String, List<CourtData>>> _branchSportCourts = {
    'Branch 1': {
      'Basketball': [
        CourtData(
          name: 'Court 1',
          status: 'Available',
          maxPlayers: 30,
          maxTeams: 3,
          guestCapacity: 300,
          imageUrl: 'assets/images/court1.jpg',
          schedule: {
            'weekdays': '08:30 - 22:00',
            'saturday': '11:30 - 20:00',
            'sunday': 'Off',
          },
        ),
        CourtData(
          name: 'Court 2',
          status: 'Available',
          maxPlayers: 25,
          maxTeams: 2,
          guestCapacity: 250,
          imageUrl: 'assets/images/court2.jpg',
          schedule: {
            'weekdays': '08:30 - 22:00',
            'saturday': '11:30 - 20:00',
            'sunday': 'Off',
          },
        ),
        CourtData(
          name: 'Court 3',
          status: 'Available',
          maxPlayers: 20,
          maxTeams: 2,
          guestCapacity: 200,
          imageUrl: 'assets/images/court3.jpg',
          schedule: {
            'weekdays': '08:30 - 22:00',
            'saturday': '11:30 - 20:00',
            'sunday': 'Off',
          },
        ),
      ],
      'Cricket': [],
      'Tennis': [],
      'Carom': [],
      'Chess': [],
    },
    'Branch 2': {
      'Tennis': [
        CourtData(
          name: 'Tennis Court A',
          status: 'Available',
          maxPlayers: 4,
          maxTeams: 2,
          guestCapacity: 50,
          imageUrl: 'assets/images/tennis_court_a.jpg',
          schedule: {
            'weekdays': '07:00 - 21:00',
            'saturday': '09:00 - 19:00',
            'sunday': '10:00 - 18:00',
          },
        ),
        CourtData(
          name: 'Tennis Court B',
          status: 'Available',
          maxPlayers: 4,
          maxTeams: 2,
          guestCapacity: 50,
          imageUrl: 'assets/images/tennis_court_b.jpg',
          schedule: {
            'weekdays': '07:00 - 21:00',
            'saturday': '09:00 - 19:00',
            'sunday': '10:00 - 18:00',
          },
        ),
      ],
      'Badminton': [
        CourtData(
          name: 'Badminton Court',
          status: 'Available',
          maxPlayers: 4,
          maxTeams: 2,
          guestCapacity: 30,
          imageUrl: 'assets/images/badminton_court.jpg',
          schedule: {
            'weekdays': '06:00 - 22:00',
            'saturday': '08:00 - 20:00',
            'sunday': '09:00 - 19:00',
          },
        ),
      ],
      'Squash': [
        CourtData(
          name: 'Squash Court',
          status: 'Available',
          maxPlayers: 2,
          maxTeams: 1,
          guestCapacity: 20,
          imageUrl: 'assets/images/squash_court.jpg',
          schedule: {
            'weekdays': '08:00 - 20:00',
            'saturday': '10:00 - 18:00',
            'sunday': '11:00 - 17:00',
          },
        ),
      ],
      'Basketball': [],
      'Cricket': [],
      'Carom': [],
      'Chess': [],
    },
    'Branch 3': {
      'Cricket': [
        CourtData(
          name: 'Cricket Ground',
          status: 'Available',
          maxPlayers: 22,
          maxTeams: 2,
          guestCapacity: 500,
          imageUrl: 'assets/images/cricket_ground.jpg',
          schedule: {
            'weekdays': '06:00 - 20:00',
            'saturday': '07:00 - 19:00',
            'sunday': '08:00 - 18:00',
          },
        ),
      ],
      'Football': [
        CourtData(
          name: 'Football Field',
          status: 'Available',
          maxPlayers: 22,
          maxTeams: 2,
          guestCapacity: 400,
          imageUrl: 'assets/images/football_field.jpg',
          schedule: {
            'weekdays': '06:00 - 20:00',
            'saturday': '07:00 - 19:00',
            'sunday': '08:00 - 18:00',
          },
        ),
      ],
      'Swimming': [
        CourtData(
          name: 'Swimming Pool',
          status: 'Available',
          maxPlayers: 20,
          maxTeams: 4,
          guestCapacity: 100,
          imageUrl: 'assets/images/swimming_pool.jpg',
          schedule: {
            'weekdays': '05:00 - 21:00',
            'saturday': '06:00 - 20:00',
            'sunday': '07:00 - 19:00',
          },
        ),
      ],
      'Gym': [
        CourtData(
          name: 'Gymnasium',
          status: 'Available',
          maxPlayers: 50,
          maxTeams: 10,
          guestCapacity: 80,
          imageUrl: 'assets/images/gymnasium.jpg',
          schedule: {
            'weekdays': '05:00 - 23:00',
            'saturday': '06:00 - 22:00',
            'sunday': '07:00 - 21:00',
          },
        ),
      ],
      'Table Tennis': [
        CourtData(
          name: 'Table Tennis Hall',
          status: 'Available',
          maxPlayers: 8,
          maxTeams: 4,
          guestCapacity: 40,
          imageUrl: 'assets/images/table_tennis.jpg',
          schedule: {
            'weekdays': '08:00 - 22:00',
            'saturday': '09:00 - 21:00',
            'sunday': '10:00 - 20:00',
          },
        ),
      ],
      'Basketball': [],
      'Tennis': [],
      'Carom': [],
      'Chess': [],
    },
  };

  // Button functionality methods
  void _handleShare() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sharing Elite Sports Arena...'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handleCoach() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Coaches'),
        content: const Text(
          'Available coaches for Elite Sports Arena:\n\n• Coach John Smith - Basketball\n• Coach Sarah Johnson - Tennis\n• Coach Mike Davis - Cricket\n• Coach Lisa Brown - Carom',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _handlePlayers() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Players'),
        content: const Text(
          'Active players at Elite Sports Arena:\n\n• 150+ Basketball players\n• 80+ Tennis players\n• 60+ Cricket players\n• 40+ Carom players\n• 30+ Chess players',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _handleReviews() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reviews'),
        content: const Text(
          'Recent reviews for Elite Sports Arena:\n\n⭐⭐⭐⭐⭐ "Excellent facilities and great coaches!" - John D.\n\n⭐⭐⭐⭐⭐ "Best sports arena in the city!" - Sarah M.\n\n⭐⭐⭐⭐ "Good courts, friendly staff" - Mike R.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _handleFavourite() {
    setState(() {
      _isFavourite = !_isFavourite;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isFavourite ? 'Added to Favourites!' : 'Removed from Favourites!',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handleBookSlot(String courtName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Book $courtName'),
        content: const Text(
          'Choose your preferred time slot:\n\n• Morning: 8:30 AM - 12:00 PM\n• Afternoon: 12:00 PM - 5:00 PM\n• Evening: 5:00 PM - 10:00 PM',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Booking request sent for $courtName!'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Book Now'),
          ),
        ],
      ),
    );
  }

  void _handleMoreDetails() {
    setState(() {
      _showMoreDetails = !_showMoreDetails;
    });
  }

  // Get filtered courts based on selected branch and sport
  List<CourtData> get _filteredCourts {
    final selectedBranch = _branches[_selectedBranchIndex];
    final selectedSport = _sports[_selectedSportIndex];

    // Get courts for the selected branch and sport
    final branchSportCourts = _branchSportCourts[selectedBranch];
    if (branchSportCourts == null) return [];

    // Get courts for the specific sport in the selected branch
    final sportCourts = branchSportCourts[selectedSport] ?? [];

    return sportCourts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.corporate.name),
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
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        actions: [
          IconButton(
            onPressed: _handleShare,
            icon: const Icon(Icons.share, color: Colors.white),
          ),
          IconButton(
            onPressed: _handleFavourite,
            icon: Icon(
              _isFavourite ? Icons.bookmark : Icons.bookmark_border,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Arena Header
            MobileArenaHeader(
              corporate: widget.corporate,
              isFavourite: _isFavourite,
              onShare: _handleShare,
              onCoach: _handleCoach,
              onPlayers: _handlePlayers,
              onReviews: _handleReviews,
              onFavourite: _handleFavourite,
            ),

            // Branch Selection
            MobileBranchSelector(
              branches: _branches,
              selectedIndex: _selectedBranchIndex,
              onBranchChanged: (index) {
                setState(() => _selectedBranchIndex = index);
                final branchName = _branches[index];
                final sportName = _sports[_selectedSportIndex];
                final courtCount =
                    _branchSportCourts[branchName]?[sportName]?.length ?? 0;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Selected $branchName - $courtCount $sportName courts available',
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
            ),

            // Sport Selection
            MobileSportSelector(
              sports: _sports,
              selectedIndex: _selectedSportIndex,
              onSportChanged: (index) {
                setState(() => _selectedSportIndex = index);
                final sportName = _sports[index];
                final branchName = _branches[_selectedBranchIndex];
                final courtCount =
                    _branchSportCourts[branchName]?[sportName]?.length ?? 0;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Filtering by $sportName - $courtCount courts available in $branchName',
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
            ),

            // Courts List
            MobileCourtsList(
              courts: _filteredCourts,
              onBookSlot: _handleBookSlot,
            ),

            // More Details Section
            Container(
              margin: const EdgeInsets.all(16),
              child: InkWell(
                onTap: _handleMoreDetails,
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
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        _showMoreDetails
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: Colors.blue,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // More Details Content
            if (_showMoreDetails) ...[
              // Coaches Section
              MobileCoachesSection(),

              const SizedBox(height: 16),

              // Billing Method Section
              MobileBillingMethodSection(),

              const SizedBox(height: 16),

              // Guest Seating Section
              MobileGuestSeatingSection(),

              const SizedBox(height: 16),

              // Sponsorships Section
              MobileSponsorshipsSection(),

              const SizedBox(height: 16),
            ],
          ],
        ),
      ),
    );
  }
}

// Mobile Arena Header Component
class MobileArenaHeader extends StatelessWidget {
  final CorporateData corporate;
  final bool isFavourite;
  final VoidCallback onShare;
  final VoidCallback onCoach;
  final VoidCallback onPlayers;
  final VoidCallback onReviews;
  final VoidCallback onFavourite;

  const MobileArenaHeader({
    super.key,
    required this.corporate,
    required this.isFavourite,
    required this.onShare,
    required this.onCoach,
    required this.onPlayers,
    required this.onReviews,
    required this.onFavourite,
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
          // Arena Name and Favourite
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Elite Sports Arena',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Los Angeles, CA',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: onFavourite,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isFavourite ? Colors.orange : Colors.blue,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isFavourite ? Icons.flag : Icons.flag_outlined,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isFavourite ? 'Favourited' : 'Favourite',
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
                      children: ['Basketball', 'Tennis', 'Cricket']
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
                      _buildCoachAvatar(
                        'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150&h=150&fit=crop',
                      ),
                      Transform.translate(
                        offset: const Offset(-8, 0),
                        child: _buildCoachAvatar(
                          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop',
                        ),
                      ),
                      Transform.translate(
                        offset: const Offset(-16, 0),
                        child: _buildCoachAvatar(
                          'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop',
                        ),
                      ),
                      Transform.translate(
                        offset: const Offset(-24, 0),
                        child: _buildCoachAvatar(
                          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Action Buttons
          Row(
            children: [
              _buildActionButton('Share', Icons.share, onShare),
              const SizedBox(width: 8),
              _buildActionButton('Coach', Icons.person, onCoach),
              const SizedBox(width: 8),
              _buildActionButton('Players', Icons.people, onPlayers),
              const SizedBox(width: 8),
              _buildActionButton('Reviews', Icons.star, onReviews),
            ],
          ),

          const SizedBox(height: 16),

          // Rating Section
          Row(
            children: [
              const Spacer(),
              // Rating Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      const Text(
                        '4.8',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      ...List.generate(
                        5,
                        (index) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                  const Text(
                    'Club Rating',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Branches and Courts Count
          Row(
            children: [
              Expanded(child: _buildCountCard('BRANCHES', '3')),
              const SizedBox(width: 12),
              Expanded(child: _buildCountCard('COURTS', '30')),
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

  Widget _buildActionButton(String label, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(8),
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

  Widget _buildCountCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: branches.asMap().entries.map((entry) {
          final index = entry.key;
          final branch = entry.value;
          final isSelected = selectedIndex == index;

          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                right: index < branches.length - 1 ? 8 : 0,
              ),
              child: InkWell(
                onTap: () => onBranchChanged(index),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.blue : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected ? Colors.blue : Colors.grey.shade300,
                    ),
                  ),
                  child: Text(
                    branch,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
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
      child: SingleChildScrollView(
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
                      color: isSelected ? Colors.blue : Colors.grey.shade300,
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
    );
  }
}

// Mobile Courts List Component
class MobileCourtsList extends StatelessWidget {
  final List<CourtData> courts;
  final Function(String) onBookSlot;

  const MobileCourtsList({
    super.key,
    required this.courts,
    required this.onBookSlot,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...courts
              .map(
                (court) =>
                    MobileCourtCard(court: court, onBookSlot: onBookSlot),
              )
              .toList(),
        ],
      ),
    );
  }
}

// Mobile Court Card Component
class MobileCourtCard extends StatelessWidget {
  final CourtData court;
  final Function(String) onBookSlot;

  const MobileCourtCard({
    super.key,
    required this.court,
    required this.onBookSlot,
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
              child: Icon(
                _getCourtIcon(court.name),
                size: 50,
                color: Colors.grey,
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
                          Text(
                            court.status,
                            style: const TextStyle(
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

                // Book Slot Button
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () => onBookSlot(court.name),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF232534),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'BOOK SLOT',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
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

                // Coach Section
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
                    4,
                    (index) => Container(
                      margin: const EdgeInsets.only(right: 4),
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 16,
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
        border: Border.all(color: Colors.blue.withOpacity(0.3)),
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
            border: Border.all(color: Colors.blue.withOpacity(0.3)),
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

  IconData _getCourtIcon(String courtName) {
    if (courtName.toLowerCase().contains('basketball') ||
        courtName.toLowerCase().contains('court 1') ||
        courtName.toLowerCase().contains('court 2') ||
        courtName.toLowerCase().contains('court 3')) {
      return Icons.sports_basketball;
    } else if (courtName.toLowerCase().contains('tennis')) {
      return Icons.sports_tennis;
    } else if (courtName.toLowerCase().contains('badminton')) {
      return Icons.sports_tennis; // Using tennis icon for badminton
    } else if (courtName.toLowerCase().contains('squash')) {
      return Icons.sports_tennis; // Using tennis icon for squash
    } else if (courtName.toLowerCase().contains('cricket')) {
      return Icons.sports_cricket;
    } else if (courtName.toLowerCase().contains('football')) {
      return Icons.sports_soccer;
    } else if (courtName.toLowerCase().contains('swimming')) {
      return Icons.pool;
    } else if (courtName.toLowerCase().contains('gym')) {
      return Icons.fitness_center;
    } else if (courtName.toLowerCase().contains('table tennis')) {
      return Icons.sports_tennis;
    } else if (courtName.toLowerCase().contains('carom')) {
      return Icons.casino; // Using casino icon for carom
    } else if (courtName.toLowerCase().contains('chess')) {
      return Icons.extension; // Using extension icon for chess
    } else {
      return Icons.sports; // Default sports icon
    }
  }
}

// Mobile Coaches Section Component
class MobileCoachesSection extends StatelessWidget {
  const MobileCoachesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
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

// Mobile Billing Method Section Component
class MobileBillingMethodSection extends StatelessWidget {
  const MobileBillingMethodSection({super.key});

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
          const Text(
            'Billing Method',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
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

// Mobile Corporate Project Card Component
class MobileCorporateProjectCard extends StatelessWidget {
  final String name;
  final double rating;
  final String specialization;
  final String experience;
  final String certification;
  final String availability;
  final String distance;
  final String rate;
  final bool isBlocked;

  const MobileCorporateProjectCard({
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
                  child: Text(
                    item['meter']!,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                Container(
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
                      color: Colors.blue,
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

// Mobile Guest Seating Section Component
class MobileGuestSeatingSection extends StatelessWidget {
  const MobileGuestSeatingSection({super.key});

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
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Guest Seating Available',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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

// Mobile Sponsorships Section Component
class MobileSponsorshipsSection extends StatelessWidget {
  const MobileSponsorshipsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
            'Sponsorships Available For This Club',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
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
class CorporateData {
  final String name;
  final double rating;
  final String location;
  final List<String> specializations;
  final int experience;
  final int employees;
  final double budget;

  CorporateData({
    required this.name,
    required this.rating,
    required this.location,
    required this.specializations,
    required this.experience,
    required this.employees,
    required this.budget,
  });
}

class CourtData {
  final String name;
  final String status;
  final int maxPlayers;
  final int maxTeams;
  final int guestCapacity;
  final String imageUrl;
  final Map<String, String> schedule;

  CourtData({
    required this.name,
    required this.status,
    required this.maxPlayers,
    required this.maxTeams,
    required this.guestCapacity,
    required this.imageUrl,
    required this.schedule,
  });
}
