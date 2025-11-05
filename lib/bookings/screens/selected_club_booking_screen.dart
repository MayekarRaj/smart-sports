import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../role_specific/common/role_router.dart';
import 'time_slot_booking_screen.dart';

class SelectedClubBookingScreen extends StatefulWidget {
  final String selectedClub;
  final String selectedSport;
  final String selectedArea;
  final DateTime selectedDate;
  final RangeValues distanceRange;
  final UserRole? role;

  const SelectedClubBookingScreen({
    Key? key,
    required this.selectedClub,
    required this.selectedSport,
    required this.selectedArea,
    required this.selectedDate,
    required this.distanceRange,
    this.role,
  }) : super(key: key);

  @override
  State<SelectedClubBookingScreen> createState() =>
      _SelectedClubBookingScreenState();
}

class _SelectedClubBookingScreenState extends State<SelectedClubBookingScreen> {
  bool isSingleSlot = true;
  bool isMultipleSlot = false;
  bool showCustomizeSlots = false;
  String selectedFrequency = 'Every Day';
  List<bool> selectedDays = [
    true,
    false,
    false,
    false,
    false,
    false,
    true,
  ]; // Sun, Mon, Tue, Wed, Thu, Fri, Sat
  DateTime currentDate = DateTime(2025, 3, 5);
  DateTime? selectedDate = DateTime(2025, 3, 5); // Default to March 5th
  int? selectedSlotIndex;
  String? selectedCourt;
  String? selectedSlotType;

  final TextEditingController startDateController = TextEditingController(
    text: 'Wed, March 5, 2025',
  );
  final TextEditingController endDateController = TextEditingController(
    text: 'Fri, March 7, 2025',
  );
  final TextEditingController startTimeController = TextEditingController(
    text: '08:00 AM',
  );
  final TextEditingController endTimeController = TextEditingController(
    text: '10:30 AM',
  );

  final List<String> frequencies = ['Every Day', 'Every Week', 'Every Month'];
  final List<String> weekDays = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];

  @override
  void dispose() {
    startDateController.dispose();
    endDateController.dispose();
    startTimeController.dispose();
    endTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          'Selected Club',
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Selected Club Details Card
            _buildSelectedClubCard(),
            const SizedBox(height: 24),

            // Customize Slots Section
            _buildCustomizeSlotsSection(),
            const SizedBox(height: 24),

            // Select Date Section
            _buildSelectDateSection(),
            const SizedBox(height: 24),

            // Full Slots Section
            _buildFullSlotsSection(),
            const SizedBox(height: 100), // Space for bottom buttons
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.grey),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  'Cancel',
                  style: GoogleFonts.poppins(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.grey),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  'Prev',
                  style: GoogleFonts.poppins(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: _handleNext,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF007BFF),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  'Next',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedClubCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Club Header with Favourite
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.selectedClub,
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
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

          // Location with blue pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF007BFF),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              widget.selectedArea,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Rating and Availability
          Row(
            children: [
              // Rating
              Text(
                '4.8',
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
                  color: starIndex < 4 ? Colors.amber : Colors.grey.shade300,
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
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Available',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
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

          // Facility Details
          Row(
            children: [
              _buildFacilityDetail('BRANCHES', '3'),
              const SizedBox(width: 24),
              _buildFacilityDetail('COURTS', '30'),
            ],
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
            children: ['Basketball', 'Basketball', 'Basketball']
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

          // Action Buttons Row
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildActionButton('Collaborate', Icons.handshake, () {}),
              _buildActionButton('Share', Icons.share, () {}),
              _buildActionButton('Coach', Icons.sports, () {}),
              _buildActionButton('Players', Icons.group, () {}),
              _buildActionButton('Reviews', Icons.star, () {}),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCustomizeSlotsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Customize Slots',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildSlotOption('Book Single Slot', isSingleSlot, () {
                setState(() {
                  isSingleSlot = true;
                  isMultipleSlot = false;
                  showCustomizeSlots = false;
                });
              }),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildSlotOption(
                'Book Multiple Repeated Slot',
                isMultipleSlot,
                () {
                  setState(() {
                    isSingleSlot = false;
                    isMultipleSlot = true;
                    showCustomizeSlots = true;
                  });
                },
              ),
            ),
          ],
        ),

        // Show customize slots form when multiple slot is selected
        if (showCustomizeSlots) ...[
          const SizedBox(height: 24),
          _buildCustomizeSlotsForm(),
        ],
      ],
    );
  }

  Widget _buildSlotOption(String title, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF007BFF).withOpacity(0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF007BFF) : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Checkbox(
              value: isSelected,
              onChanged: (value) => onTap(),
              activeColor: const Color(0xFF007BFF),
            ),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectDateSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Date For Booking',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.15),
                spreadRadius: 2,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Month Navigation
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        currentDate = DateTime(
                          currentDate.year,
                          currentDate.month - 1,
                        );
                      });
                    },
                    icon: const Icon(Icons.chevron_left),
                  ),
                  Text(
                    'March 2025',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        currentDate = DateTime(
                          currentDate.year,
                          currentDate.month + 1,
                        );
                      });
                    },
                    icon: const Icon(Icons.chevron_right),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Calendar Grid
              _buildCalendarGrid(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCalendarGrid() {
    final firstDayOfMonth = DateTime(currentDate.year, currentDate.month, 1);
    final lastDayOfMonth = DateTime(currentDate.year, currentDate.month + 1, 0);
    final firstWeekday = firstDayOfMonth.weekday;

    return Column(
      children: [
        // Weekday headers
        Row(
          children: ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa']
              .map(
                (day) => Expanded(
                  child: Center(
                    child: Text(
                      day,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 8),
        // Calendar days
        ...List.generate(6, (week) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: List.generate(7, (day) {
                final dayNumber = week * 7 + day - firstWeekday + 1;
                final isCurrentMonth =
                    dayNumber > 0 && dayNumber <= lastDayOfMonth.day;
                final currentDayDate = isCurrentMonth
                    ? DateTime(currentDate.year, currentDate.month, dayNumber)
                    : null;
                final isSelected =
                    selectedDate != null &&
                    currentDayDate != null &&
                    selectedDate!.day == dayNumber &&
                    selectedDate!.month == currentDate.month &&
                    selectedDate!.year == currentDate.year;

                Color dayColor;
                Color backgroundColor = Colors.transparent;
                bool isClickable = false;

                if (!isCurrentMonth) {
                  dayColor = Colors.grey.shade300;
                  isClickable = false;
                } else if (dayNumber <= 4) {
                  dayColor = Colors.grey.shade400; // Past dates
                  isClickable = false;
                } else if (dayNumber >= 5 && dayNumber <= 8) {
                  dayColor = Colors.green; // Available dates
                  isClickable = true;
                  if (isSelected) {
                    backgroundColor = const Color(0xFF007BFF).withOpacity(0.2);
                  }
                } else if (dayNumber >= 9 && dayNumber <= 15) {
                  dayColor = Colors.orange; // Rushing dates
                  isClickable = true;
                } else if (dayNumber >= 16 && dayNumber <= 22) {
                  dayColor = Colors.red; // Unavailable dates
                  isClickable = false;
                } else if (dayNumber >= 23 && dayNumber <= 29) {
                  dayColor = Colors.orange; // Rushing dates
                  isClickable = true;
                } else {
                  dayColor = Colors.green; // Available dates
                  isClickable = true;
                }

                return Expanded(
                  child: GestureDetector(
                    onTap: isClickable && isCurrentMonth
                        ? () {
                            setState(() {
                              selectedDate = currentDayDate;
                            });
                            // Show feedback for date selection
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Selected: March $dayNumber, 2025',
                                  style: GoogleFonts.poppins(),
                                ),
                                backgroundColor: Colors.green,
                                behavior: SnackBarBehavior.floating,
                                duration: const Duration(seconds: 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            );
                          }
                        : null,
                    child: Container(
                      height: 40,
                      margin: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(8),
                        border: isClickable && !isSelected
                            ? Border.all(color: Colors.grey.shade200, width: 1)
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          isCurrentMonth ? dayNumber.toString() : '',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w500,
                            color: dayColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildFullSlotsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Full Slots',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade800,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            'Select Available slots to make your court booking. You can select the not available slots in waiting if the booking got cancelled your slot will be confirmed.',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.white,
              height: 1.4,
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Court Slots
        ...List.generate(3, (courtIndex) => _buildCourtSlots(courtIndex + 1)),
      ],
    );
  }

  Widget _buildCourtSlots(int courtNumber) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Court $courtNumber',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildSlotCard(
                'Whole Month',
                'Not Available',
                Colors.red,
                courtNumber,
                0,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSlotCard(
                'Full Week',
                'Available',
                Colors.green,
                courtNumber,
                1,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSlotCard(
                'Full Day',
                'Rushing',
                Colors.orange,
                courtNumber,
                2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSlotCard(
    String title,
    String status,
    Color statusColor,
    int courtNumber,
    int slotIndex,
  ) {
    final isSelected =
        selectedCourt == 'Court $courtNumber' && selectedSlotIndex == slotIndex;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCourt = 'Court $courtNumber';
          selectedSlotIndex = slotIndex;
          selectedSlotType = title;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF007BFF) : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
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
              title,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                status,
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '20% Off',
              style: GoogleFonts.poppins(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  'USD 5000',
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    decoration: TextDecoration.lineThrough,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '4900',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ],
        ),
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
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
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

  void _handleNext() {
    if (selectedCourt != null && selectedSlotType != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Selected: $selectedCourt - $selectedSlotType. Proceeding to time slots...',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      // Navigate to time slot booking screen
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => TimeSlotBookingScreen(
            selectedClub: widget.selectedClub,
            selectedSport: widget.selectedSport,
            selectedArea: widget.selectedArea,
            selectedDate: selectedDate ?? widget.selectedDate,
            distanceRange: widget.distanceRange,
            role: widget.role,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please select a court and slot to continue',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }

  Widget _buildCustomizeSlotsForm() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Repetition Frequency
          Text(
            'Repetition Frequency',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: frequencies.map((frequency) {
              final isSelected = selectedFrequency == frequency;
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedFrequency = frequency;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSelected
                          ? const Color(0xFF007BFF)
                          : Colors.white,
                      foregroundColor: isSelected
                          ? Colors.white
                          : Colors.black87,
                      side: BorderSide(
                        color: isSelected
                            ? const Color(0xFF007BFF)
                            : Colors.black,
                        width: 1,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      elevation: 0,
                    ),
                    child: Text(
                      frequency,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // Select Days
          Text(
            'Select Days',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          // Use a more flexible layout for days
          LayoutBuilder(
            builder: (context, constraints) {
              final screenWidth = constraints.maxWidth;
              final isNarrow = screenWidth < 400;

              if (isNarrow) {
                // For narrow screens, show days in a vertical list
                return Column(
                  children: weekDays.asMap().entries.map((entry) {
                    int index = entry.key;
                    String day = entry.value;
                    final isSelected = selectedDays[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Checkbox(
                            value: isSelected,
                            onChanged: (value) {
                              setState(() {
                                selectedDays[index] = value ?? false;
                              });
                            },
                            activeColor: const Color(0xFF007BFF),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            day,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              } else {
                // For wider screens, use a more flexible layout
                return Wrap(
                  spacing: 6,
                  runSpacing: 8,
                  children: weekDays.asMap().entries.map((entry) {
                    int index = entry.key;
                    String day = entry.value;
                    final isSelected = selectedDays[index];
                    return Container(
                      constraints: BoxConstraints(
                        minWidth: 60,
                        maxWidth: (screenWidth - 40) / 3, // More flexible width
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Checkbox(
                            value: isSelected,
                            onChanged: (value) {
                              setState(() {
                                selectedDays[index] = value ?? false;
                              });
                            },
                            activeColor: const Color(0xFF007BFF),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ),
                          const SizedBox(width: 2),
                          Expanded(
                            child: Text(
                              day,
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              }
            },
          ),
          const SizedBox(height: 20),

          // Date Range Input
          Row(
            children: [
              Expanded(
                child: _buildDateField('Start Date', startDateController),
              ),
              const SizedBox(width: 16),
              Expanded(child: _buildDateField('End Date', endDateController)),
            ],
          ),
          const SizedBox(height: 16),

          // Time Range Input
          Row(
            children: [
              Expanded(
                child: _buildTimeField('Start Time', startTimeController),
              ),
              const SizedBox(width: 16),
              Expanded(child: _buildTimeField('End Time', endTimeController)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF007BFF)),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          readOnly: true,
          onTap: () => _selectDate(context, controller),
          style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
        ),
      ],
    );
  }

  Widget _buildTimeField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF007BFF)),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          readOnly: true,
          onTap: () => _selectTime(context, controller),
          style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
        ),
      ],
    );
  }

  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        controller.text =
            '${_getWeekday(picked.weekday)}, ${_getMonthName(picked.month)} ${picked.day}, ${picked.year}';
      });
    }
  }

  Future<void> _selectTime(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        controller.text = '${picked.format(context)}';
      });
    }
  }

  String _getWeekday(int weekday) {
    const weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return weekdays[weekday - 1];
  }

  String _getMonthName(int month) {
    const months = [
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
