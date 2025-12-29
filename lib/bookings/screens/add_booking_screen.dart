import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../role_specific/common/role_router.dart';
import 'selected_club_booking_screen.dart';

class AddBookingScreen extends StatefulWidget {
  final UserRole? role;

  const AddBookingScreen({Key? key, this.role}) : super(key: key);

  @override
  State<AddBookingScreen> createState() => _AddBookingScreenState();
}

class _AddBookingScreenState extends State<AddBookingScreen> {
  String selectedSport = 'Cricket';
  String selectedArea = 'Jamtha Stadium, Nagpur';
  DateTime selectedDate = DateTime(2025, 3, 5);
  RangeValues distanceRange = const RangeValues(10, 40);
  String? selectedClub;
  bool isClubSelected = false;
  int? selectedClubIndex;

  final List<String> sports = [
    'Cricket',
    'Basketball',
    'Football',
    'Tennis',
    'Badminton',
    'Volleyball',
  ];

  final List<String> areas = [
    'Jamtha Stadium, Nagpur',
    'Wankhede Stadium, Mumbai',
    'Eden Gardens, Kolkata',
    'Chinnaswamy Stadium, Bangalore',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          'ADD BOOKING',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: widget.role != null ? null : const Color(0xFF007BFF),
        flexibleSpace: widget.role != null
            ? Container(
                decoration: BoxDecoration(
                  gradient: _getRoleGradient(widget.role!),
                ),
              )
            : null,
        elevation: 0,
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: _handleNext,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF007BFF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: Text(
              'Next',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sports Type Section
            _buildSportsTypeSection(),
            const SizedBox(height: 20),

            // Select Club Section
            _buildSelectClubSection(),
            const SizedBox(height: 20),

            // Selected Club Section (if club is selected)
            if (isClubSelected) ...[
              _buildSelectedClubSection(),
              const SizedBox(height: 20),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSportsTypeSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sports Type',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedSport,
                isExpanded: true,
                style: GoogleFonts.poppins(fontSize: 16, color: Colors.black87),
                items: sports.map((String sport) {
                  return DropdownMenuItem<String>(
                    value: sport,
                    child: Text(sport),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectedSport = newValue;
                    });
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectClubSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Club',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),

          // Search By Area & City
          Text(
            'Search by area and city',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          _buildSearchField(
            'Search By Area & City',
            selectedArea,
            Icons.location_on,
            () => _showAreaPicker(),
          ),
          const SizedBox(height: 16),

          // Search Club Availability
          _buildSearchField(
            'Search Club Availability:',
            '${_getDayName(selectedDate.weekday)}, ${_getMonthName(selectedDate.month)} ${selectedDate.day}, ${selectedDate.year}',
            Icons.calendar_today,
            () => _showDatePicker(),
          ),
          const SizedBox(height: 16),

          // Distance Range Slider
          _buildDistanceSlider(),
          const SizedBox(height: 20),

          // Map View
          _buildMapView(),
          const SizedBox(height: 20),

          // Map Legend
          _buildMapLegend(),
          const SizedBox(height: 20),

          // Clubs Section
          _buildClubsSection(),
        ],
      ),
    );
  }

  Widget _buildSearchField(
    String label,
    String value,
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey.shade600, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                value,
                style: GoogleFonts.poppins(fontSize: 16, color: Colors.black87),
              ),
            ),
            Icon(Icons.arrow_drop_down, color: Colors.grey.shade600),
          ],
        ),
      ),
    );
  }

  Widget _buildDistanceSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Search By Distance Range (In Miles)',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: RangeSlider(
                values: distanceRange,
                min: 0,
                max: 50,
                divisions: 10,
                activeColor: const Color(0xFF007BFF),
                inactiveColor: Colors.grey.shade300,
                labels: RangeLabels(
                  '${distanceRange.start.round()}',
                  '${distanceRange.end.round()}',
                ),
                onChanged: (RangeValues values) {
                  setState(() {
                    distanceRange = values;
                  });
                },
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Filters applied successfully!',
                      style: GoogleFonts.poppins(),
                    ),
                    backgroundColor: const Color(0xFF007BFF),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF007BFF),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              child: Text(
                'Apply',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMapView() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Stack(
        children: [
          // Map Image
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/images/9c71c0d0f90c1acfa57c561de796ac8136fe5724.png',
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.map,
                            size: 48,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Interactive Map',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Club locations and areas',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Map title overlay
          Positioned(
            left: 16,
            top: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Interactive Map',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          // Club details overlay
          Positioned(
            right: 16,
            top: 16,
            child: Container(
              width: 200,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Elite Sports Arena',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.more_vert,
                        color: Colors.grey.shade600,
                        size: 20,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Los Angeles, CA',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        '4.8',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(width: 4),
                      ...List.generate(
                        5,
                        (index) => Icon(
                          Icons.star,
                          size: 16,
                          color: index < 4
                              ? Colors.amber
                              : Colors.grey.shade300,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Available',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '10% Off SPECIAL DISCOUNT',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedClub = 'Elite Sports Arena';
                          isClubSelected = true;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF007BFF),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                      child: Text(
                        'Select Club',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapLegend() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'You can change the club selection of your choice from Map.',
          style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 400) {
              // Stack vertically on small screens
              return Column(
                children: [
                  Row(
                    children: [
                      _buildLegendItem('A', Colors.green, 'Slots Available'),
                      const SizedBox(width: 16),
                      _buildLegendItem('R', Colors.orange, 'Slots Rushing'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildLegendItem('X', Colors.red, 'Slots Not Available'),
                ],
              );
            }
            // Use horizontal layout on larger screens
            return Row(
              children: [
                Expanded(
                  child: _buildLegendItem('A', Colors.green, 'Slots Available'),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildLegendItem('R', Colors.orange, 'Slots Rushing'),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildLegendItem(
                    'X',
                    Colors.red,
                    'Slots Not Available',
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildLegendItem(String letter, Color color, String label) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          child: Center(
            child: Text(
              letter,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildClubsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Clubs',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),

        // Club Cards
        ...List.generate(3, (index) => _buildClubCard(index)),
      ],
    );
  }

  Widget _buildClubCard(int index) {
    final clubs = [
      {
        'name': 'Elite Sports Arena',
        'location': 'Los Angeles, CA',
        'rating': 4.8,
        'availability': 'Available',
        'discount': '10% Off SPECIAL DISCOUNT',
        'branches': '3',
        'courts': '30',
        'sports': ['Basketball', 'Basketball', 'Basketball'],
      },
      {
        'name': 'Premier Sports Center',
        'location': 'New York, NY',
        'rating': 4.6,
        'availability': 'Available',
        'discount': '15% Off SPECIAL DISCOUNT',
        'branches': '2',
        'courts': '25',
        'sports': ['Tennis', 'Tennis', 'Tennis'],
      },
      {
        'name': 'Champions Sports Club',
        'location': 'Chicago, IL',
        'rating': 4.9,
        'availability': 'Rushing',
        'discount': '5% Off SPECIAL DISCOUNT',
        'branches': '4',
        'courts': '35',
        'sports': ['Football', 'Football', 'Football'],
      },
    ];

    final club = clubs[index];
    final isAvailable = club['availability'] == 'Available';

    final isSelected = selectedClubIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedClubIndex = index;
          selectedClub = club['name'] as String;
          isClubSelected = true;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF007BFF) : Colors.transparent,
            width: isSelected ? 3 : 0,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? const Color(0xFF007BFF).withOpacity(0.2)
                  : Colors.grey.withOpacity(0.15),
              spreadRadius: isSelected ? 3 : 2,
              blurRadius: isSelected ? 15 : 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Club Header with Favourite and Selection Indicator
            Row(
              children: [
                Expanded(
                  child: Text(
                    club['name'] as String,
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                ),
                if (isSelected)
                  Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Color(0xFF007BFF),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.bookmark,
                        size: 16,
                        color: Colors.blue.shade700,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Favourite',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.blue.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Location with blue pill
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF007BFF),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                club['location'] as String,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Available Sports
            Text(
              'AVAILABLE SPORTS',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: (club['sports'] as List<String>)
                  .map(
                    (sport) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF007BFF),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        sport,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 16),

            // Coach Section
            Text(
              'COACH',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: List.generate(
                4,
                (index) => Container(
                  margin: const EdgeInsets.only(right: 8),
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Icon(
                    Icons.person,
                    color: Colors.grey.shade600,
                    size: 20,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Rating and Availability
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Club Rating title
                Text(
                  'Club Rating',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    // Rating
                    Text(
                      '${club['rating']}',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(width: 4),
                    ...List.generate(
                      5,
                      (starIndex) => Icon(
                        Icons.star,
                        size: 20,
                        color: starIndex < (club['rating'] as double).floor()
                            ? Colors.amber
                            : Colors.grey.shade300,
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Availability Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isAvailable ? Colors.green : Colors.orange,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        club['availability'] as String,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Discount Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '10% Off',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    'SPECIAL DISCOUNT',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Facility Details
            Row(
              children: [
                _buildClubFacilityDetail(
                  'BRANCHES',
                  club['branches'] as String,
                ),
                const SizedBox(width: 24),
                _buildClubFacilityDetail('COURTS', club['courts'] as String),
              ],
            ),
            const SizedBox(height: 16),

            // Action Buttons Row
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildClubActionButton('Sponsor', Icons.handshake, () {
                  setState(() {
                    selectedClub = club['name'] as String;
                    isClubSelected = true;
                  });
                }),
                _buildClubActionButton('Share', Icons.share, () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Share feature coming soon!',
                        style: GoogleFonts.poppins(),
                      ),
                      backgroundColor: const Color(0xFF007BFF),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                }),
                _buildClubActionButton('Coach', Icons.sports, () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Coach feature coming soon!',
                        style: GoogleFonts.poppins(),
                      ),
                      backgroundColor: const Color(0xFF007BFF),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                }),
                _buildClubActionButton('Players', Icons.group, () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Players feature coming soon!',
                        style: GoogleFonts.poppins(),
                      ),
                      backgroundColor: const Color(0xFF007BFF),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                }),
                _buildClubActionButton('Reviews', Icons.star, () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Reviews feature coming soon!',
                        style: GoogleFonts.poppins(),
                      ),
                      backgroundColor: const Color(0xFF007BFF),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClubFacilityDetail(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildClubActionButton(
    String label,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(
        label,
        style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF007BFF),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _buildSelectedClubSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selected Club',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),

          // Club Header
          Row(
            children: [
              Expanded(
                child: Text(
                  'Elite Sports Arena',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.bookmark, size: 16, color: Colors.blue.shade700),
                    const SizedBox(width: 4),
                    Text(
                      'Favourite',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Los Angeles, CA',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 16),

          // Available Sports
          Wrap(
            spacing: 8,
            children: List.generate(
              3,
              (index) => Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF007BFF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Basketball',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Coach Section
          Text(
            'COACH',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: List.generate(
              3,
              (index) => Container(
                margin: const EdgeInsets.only(right: 8),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person,
                  color: Colors.grey.shade600,
                  size: 20,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Rating and Availability
          Row(
            children: [
              Text(
                '4.8',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(width: 4),
              ...List.generate(
                5,
                (index) => Icon(
                  Icons.star,
                  size: 18,
                  color: index < 4 ? Colors.amber : Colors.grey.shade300,
                ),
              ),
              const SizedBox(width: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Available',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '10% Off SPECIAL DISCOUNT',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.blue.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Facility Details
          Row(
            children: [
              _buildFacilityDetail('BRANCHES', '3'),
              const SizedBox(width: 24),
              _buildFacilityDetail('COURTS', '30'),
            ],
          ),
          const SizedBox(height: 20),

          // Action Buttons
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildActionButton('Sponsor', Icons.handshake),
              _buildActionButton('Share', Icons.share),
              _buildActionButton('Coach', Icons.sports),
              _buildActionButton('Players', Icons.group),
              _buildActionButton('Reviews', Icons.star),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFacilityDetail(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(String label, IconData icon) {
    return ElevatedButton.icon(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '$label feature coming soon!',
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: const Color(0xFF007BFF),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      },
      icon: Icon(icon, size: 18),
      label: Text(
        label,
        style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF007BFF),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }

  void _showAreaPicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select Area & City',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            ...areas.map(
              (area) => ListTile(
                title: Text(area, style: GoogleFonts.poppins()),
                onTap: () {
                  setState(() {
                    selectedArea = area;
                  });
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDatePicker() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _handleNext() {
    if (isClubSelected && selectedClub != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Selected: $selectedClub. Proceeding to booking details...',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      // Navigate to selected club booking screen
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SelectedClubBookingScreen(
            selectedClub: selectedClub!,
            selectedSport: selectedSport,
            selectedArea: selectedArea,
            selectedDate: selectedDate,
            distanceRange: distanceRange,
            role: widget.role,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please select a club to continue',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }

  String _getDayName(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday - 1];
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  LinearGradient _getRoleGradient(UserRole role) {
    switch (role) {
      case UserRole.club:
        return const LinearGradient(
          colors: [Color(0xFF283048), Color(0xFF859398)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case UserRole.coach:
        return const LinearGradient(
          colors: [Color(0xFF232534), Color(0xFF2C3BC5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case UserRole.corporate:
        return const LinearGradient(
          colors: [Color(0xFF232534), Color(0xFF414384)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case UserRole.merchandiser:
        return const LinearGradient(
          colors: [Color(0xFF009A69), Color(0xFF232534)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case UserRole.member:
        return const LinearGradient(
          colors: [Color(0xFF283048), Color(0xFF859398)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case UserRole.freelancer:
        return const LinearGradient(
          colors: [Color(0xFF007BFF), Color(0xFF0056CC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }
}
