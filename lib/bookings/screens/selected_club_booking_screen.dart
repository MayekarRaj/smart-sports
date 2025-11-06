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
  String? selectedSlot;
  String? selectedTime;
  Map<String, bool> selectedPrivilegeSlots =
      {}; // Key: 'Court1-8:00', Value: selected
  Map<String, bool> selectedPrivilegeBundles =
      {}; // Key: 'Court1-8:00-8:30', Value: selected

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
            const SizedBox(height: 24),

            // Privilege Slots Section
            _buildPrivilegeSlotsSection(),
            const SizedBox(height: 24),

            // General Slots Section
            _buildGeneralSlotsSection(),
            const SizedBox(height: 24),

            // Selection Summary Section
            _buildSelectionSummary(),
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
          // Clear other section selections
          selectedSlot = null;
          selectedTime = null;
          selectedPrivilegeSlots.clear();
          selectedPrivilegeBundles.clear();

          // Set Full slot selection
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
    // Check if any slot is selected from any section
    final hasFullSlotSelection =
        selectedCourt != null && selectedSlotType != null;
    final hasPrivilegeSlotSelection = selectedPrivilegeSlots.values.any(
      (selected) => selected == true,
    );
    final hasPrivilegeBundleSelection = selectedPrivilegeBundles.values.any(
      (selected) => selected == true,
    );
    final hasGeneralSlotSelection =
        selectedSlot != null && selectedCourt != null && selectedTime != null;

    if (hasFullSlotSelection ||
        hasPrivilegeSlotSelection ||
        hasPrivilegeBundleSelection ||
        hasGeneralSlotSelection) {
      String selectionInfo = '';
      if (hasFullSlotSelection) {
        selectionInfo = '$selectedCourt - $selectedSlotType';
      } else if (hasPrivilegeSlotSelection) {
        final selectedPrivilegeSlot = selectedPrivilegeSlots.entries.firstWhere(
          (e) => e.value == true,
        );
        selectionInfo = 'Privilege Slot: ${selectedPrivilegeSlot.key}';
      } else if (hasPrivilegeBundleSelection) {
        final selectedBundle = selectedPrivilegeBundles.entries.firstWhere(
          (e) => e.value == true,
        );
        selectionInfo = 'Privilege Bundle: ${selectedBundle.key}';
      } else if (hasGeneralSlotSelection) {
        selectionInfo = 'General Slot: $selectedCourt at $selectedTime';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Selected: $selectionInfo. Proceeding to time slots...',
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
            selectedSlot: selectedSlot,
            selectedCourt: selectedCourt,
            selectedTime: selectedTime,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please select a slot from Full Slots, Privilege Slots, or General Slots to continue',
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

  Widget _buildPrivilegeSlotsSection() {
    final times = ['8:00', '8:30', '10:30', '11:00'];
    final courts = ['Court 1', 'Court 2', 'Court 3'];

    // Slot availability data: 'Court1-8:00' -> true (available) or false (not available)
    final slotAvailability = {
      'Court 1-8:00': true,
      'Court 1-8:30': true,
      'Court 1-10:30': true,
      'Court 1-11:00': false,
      'Court 2-8:00': false,
      'Court 2-8:30': true,
      'Court 2-10:30': true,
      'Court 2-11:00': true,
      'Court 3-8:00': true,
      'Court 3-8:30': true,
      'Court 3-10:30': false,
      'Court 3-11:00': true,
    };

    // Bundle data: 'Court1-8:00-8:30' -> {price: 10000, discount: 9800, percent: 30}
    final bundles = {
      'Court 1-8:00-8:30': {'price': 10000, 'discount': 9800, 'percent': 30},
      'Court 2-8:30-10:30': {'price': 10000, 'discount': 9800, 'percent': 20},
      'Court 3-8:00-8:30': {'price': 10000, 'discount': 9800, 'percent': 30},
      'Court 3-10:30-11:00': {'price': 9800, 'discount': 9800, 'percent': 20},
    };

    return Container(
      padding: const EdgeInsets.all(12),
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
          // Header Section
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Privilege Slots',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Selected Date ${_getDayName((selectedDate ?? widget.selectedDate).weekday)}, ${_getMonthNameShort((selectedDate ?? widget.selectedDate).month)} ${(selectedDate ?? widget.selectedDate).day.toString().padLeft(2, '0')}, ${(selectedDate ?? widget.selectedDate).year}',
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Unlock Privilege Slots By Upgrading Now.',
                    style: GoogleFonts.poppins(
                      fontSize: 9,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 4),
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Upgrade to unlock Privilege Slots',
                            style: GoogleFonts.poppins(),
                          ),
                          backgroundColor: Colors.blue,
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Upgrade',
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Time Slots Grid
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Time Headers
                Row(
                  children: [
                    const SizedBox(width: 60), // Space for court labels
                    ...times.map(
                      (time) => Container(
                        width: 75,
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        child: Center(
                          child: Text(
                            time,
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // Court Rows with Slots
                ...List.generate(courts.length, (courtIndex) {
                  final court = courts[courtIndex];
                  return Column(
                    children: [
                      Row(
                        children: [
                          // Court Label
                          SizedBox(
                            width: 60,
                            child: Text(
                              court,
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          // Time Slots
                          ...List.generate(times.length, (timeIndex) {
                            final time = times[timeIndex];
                            final slotKey = '$court-$time';
                            final isAvailable =
                                slotAvailability[slotKey] ?? false;

                            return Container(
                              width: 75,
                              margin: const EdgeInsets.symmetric(horizontal: 3),
                              child: _buildPrivilegeSlotCard(
                                court: court,
                                time: time,
                                isAvailable: isAvailable,
                                slotKey: slotKey,
                              ),
                            );
                          }),
                        ],
                      ),
                      const SizedBox(height: 6),

                      // Bundle Discount Bars
                      Row(
                        children: [
                          const SizedBox(width: 60),
                          ..._buildBundleBars(court, times, bundles),
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildBundleBars(
    String court,
    List<String> times,
    Map<String, Map<String, dynamic>> bundles,
  ) {
    final bars = <Widget>[];
    final slotWidth = 75.0;
    final slotMargin = 3.0;

    // Track which time slots have bundles
    final bundlePositions = <int, Map<String, dynamic>>{};

    // Find all bundles for this court and their positions
    for (int i = 0; i < times.length - 1; i++) {
      final bundleKey = '$court-${times[i]}-${times[i + 1]}';
      if (bundles.containsKey(bundleKey)) {
        bundlePositions[i] = {'key': bundleKey, 'bundle': bundles[bundleKey]!};
      }
    }

    // Build bars with proper spacing
    for (int i = 0; i < times.length - 1; i++) {
      if (bundlePositions.containsKey(i)) {
        final bundleData = bundlePositions[i]!;
        final bundle = bundleData['bundle'] as Map<String, dynamic>;
        final bundleKey = bundleData['key'] as String;
        final span = 2; // Number of time slots this bundle spans

        bars.add(
          GestureDetector(
            onTap: () {
              setState(() {
                // Toggle bundle selection
                selectedPrivilegeBundles[bundleKey] =
                    !(selectedPrivilegeBundles[bundleKey] ?? false);

                // If selecting this bundle, set it as the active selection
                if (selectedPrivilegeBundles[bundleKey] == true) {
                  // Clear other section selections
                  selectedCourt = null;
                  selectedSlotIndex = null;
                  selectedSlot = null;
                  selectedTime = null;
                  selectedPrivilegeSlots.clear();

                  // Set Privilege bundle selection
                  // bundleKey format: "Court 1-8:00-8:30"
                  final parts = bundleKey.split('-');
                  if (parts.length >= 3) {
                    selectedCourt = parts[0]; // "Court 1"
                    selectedSlotType = 'Privilege Bundle';
                    selectedSlot = bundleKey;
                    selectedTime = '${parts[1]}-${parts[2]}'; // "8:00-8:30"
                  }
                } else {
                  // If deselecting, clear if this was the active selection
                  if (selectedSlot == bundleKey) {
                    selectedCourt = null;
                    selectedSlotType = null;
                    selectedSlot = null;
                    selectedTime = null;
                  }
                }
              });
            },
            child: Container(
              width: (slotWidth * span) + (slotMargin * (span - 1)),
              height: 32,
              margin: EdgeInsets.only(
                left: i == 0 ? slotMargin : 0,
                right: slotMargin,
              ),
              decoration: BoxDecoration(
                color: (selectedPrivilegeBundles[bundleKey] ?? false)
                    ? const Color(0xFF007BFF).withOpacity(0.2)
                    : const Color(0xFF007BFF),
                borderRadius: BorderRadius.circular(6),
                border: (selectedPrivilegeBundles[bundleKey] ?? false)
                    ? Border.all(color: const Color(0xFF007BFF), width: 2)
                    : null,
              ),
              child: Center(
                child: Text(
                  'USD ${bundle['price']} ${bundle['discount']} ${bundle['percent']}% off',
                  style: GoogleFonts.poppins(
                    fontSize: 8,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        );
      } else {
        // Empty space for slots without bundles
        bars.add(SizedBox(width: slotWidth + slotMargin));
      }
    }

    return bars;
  }

  Widget _buildPrivilegeSlotCard({
    required String court,
    required String time,
    required bool isAvailable,
    required String slotKey,
  }) {
    final isSelected = selectedPrivilegeSlots[slotKey] ?? false;
    final color = isAvailable ? Colors.green : Colors.red;
    final originalPrice = 5000;
    final discountPrice = isAvailable ? 4900 : 4500;

    return GestureDetector(
      onTap: isAvailable
          ? () {
              setState(() {
                // Toggle selection
                selectedPrivilegeSlots[slotKey] = !isSelected;

                // If selecting this slot, set it as the active selection
                if (!isSelected) {
                  // Clear other section selections
                  selectedCourt = null;
                  selectedSlotIndex = null;
                  selectedSlot = null;
                  selectedTime = null;

                  // Set Privilege slot selection
                  selectedCourt = court;
                  selectedSlotType = 'Privilege Slot';
                  selectedSlot = slotKey;
                  selectedTime = time;
                } else {
                  // If deselecting, clear if this was the active selection
                  if (selectedSlot == slotKey) {
                    selectedCourt = null;
                    selectedSlotType = null;
                    selectedSlot = null;
                    selectedTime = null;
                  }
                }
              });
            }
          : null,
      child: Container(
        height: 95,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSelected ? const Color(0xFF007BFF) : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Left side discount tag
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: 16,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(6),
                    bottomLeft: Radius.circular(6),
                  ),
                ),
                child: RotatedBox(
                  quarterTurns: 3,
                  child: Center(
                    child: Text(
                      '20% OFF',
                      style: GoogleFonts.poppins(
                        fontSize: 7,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Main content
            Padding(
              padding: const EdgeInsets.only(
                left: 16,
                top: 6,
                bottom: 6,
                right: 3,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Text(
                      isAvailable ? 'Available' : 'Not Available',
                      style: GoogleFonts.poppins(
                        fontSize: 7,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  // Price
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'USD $originalPrice',
                        style: GoogleFonts.poppins(
                          fontSize: 7,
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Text(
                        '$discountPrice',
                        style: GoogleFonts.poppins(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
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
    );
  }

  Widget _buildGeneralSlotsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header - Mobile responsive
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'General Slots',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Selected Date ${_getDayName((selectedDate ?? widget.selectedDate).weekday)}, ${_getMonthNameShort((selectedDate ?? widget.selectedDate).month)} ${(selectedDate ?? widget.selectedDate).day}, ${(selectedDate ?? widget.selectedDate).year}',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Time Slots Grid - Mobile responsive
        _buildMobileTimeSlotsGrid(
          [
            ['9:00', '9:30', '10:00', '11:30', '12:00', '12:30', '13:00'],
            ['9:00', '9:30', '10:00', '11:30', '12:00', '12:30', '13:00'],
            ['9:00', '9:30', '10:00', '11:30', '12:00', '12:30', '13:00'],
          ],
          [
            ['Court 1'],
            ['Court 2'],
            ['Court 3'],
          ],
          [
            [
              ['Available', Colors.green],
              ['Available', Colors.green],
              ['Rushing', Colors.orange],
              ['Available', Colors.green],
              ['Not Available', Colors.red],
              ['Rushing', Colors.orange],
              ['Rushing', Colors.orange],
            ],
            [
              ['Rushing', Colors.orange],
              ['Not Available', Colors.red],
              ['Available', Colors.green],
              ['Available', Colors.green],
              ['Rushing', Colors.orange],
              ['Available', Colors.green],
              ['Rushing', Colors.orange],
            ],
            [
              ['Available', Colors.green],
              ['Available', Colors.green],
              ['Available', Colors.green],
              ['Rushing', Colors.orange],
              ['Not Available', Colors.red],
              ['Rushing', Colors.orange],
              ['Rushing', Colors.orange],
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildMobileTimeSlotsGrid(
    List<List<String>> timeSlots,
    List<List<String>> courts,
    List<List<List<dynamic>>> slotStatuses,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
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
          // Time Headers - Mobile responsive
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                const SizedBox(width: 60), // Space for court labels
                ...timeSlots[0].map(
                  (time) => Container(
                    width: 70, // Fixed width for better mobile layout
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    child: Center(
                      child: Text(
                        time,
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Court Rows - Mobile responsive
          ...List.generate(courts.length, (courtIndex) {
            return Column(
              children: [
                // Court Row
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      // Court Label
                      SizedBox(
                        width: 60,
                        child: Text(
                          courts[courtIndex][0],
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      // Time Slots
                      ...List.generate(timeSlots[courtIndex].length, (
                        timeIndex,
                      ) {
                        return Container(
                          width: 70, // Fixed width for better mobile layout
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          child: _buildMobileSlotCard(
                            timeSlots[courtIndex][timeIndex],
                            courts[courtIndex][0],
                            slotStatuses[courtIndex][timeIndex][0],
                            slotStatuses[courtIndex][timeIndex][1],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildMobileSlotCard(
    String time,
    String court,
    String status,
    Color statusColor,
  ) {
    final isSelected = selectedSlot == '$court-$time';

    return GestureDetector(
      onTap: () {
        setState(() {
          // Clear other section selections
          selectedCourt = null;
          selectedSlotIndex = null;
          selectedPrivilegeSlots.clear();
          selectedPrivilegeBundles.clear();

          // Set General slot selection
          selectedSlot = '$court-$time';
          selectedCourt = court;
          selectedSlotType = 'General Slot';
          selectedTime = time;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Selected: $court at $time',
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
      },
      child: Container(
        height: 80, // Fixed height for better mobile touch targets
        margin: const EdgeInsets.all(1),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? const Color(0xFF007BFF) : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 20% Off Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(3),
              ),
              child: Text(
                '20% Off',
                style: GoogleFonts.poppins(
                  fontSize: 7,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            // Status Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                status,
                style: GoogleFonts.poppins(
                  fontSize: 7,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            // Price - Mobile optimized
            Column(
              children: [
                Text(
                  'USD 50.00',
                  style: GoogleFonts.poppins(
                    fontSize: 7,
                    decoration: TextDecoration.lineThrough,
                    color: Colors.grey.shade600,
                  ),
                ),
                Text(
                  'USD 49.00',
                  style: GoogleFonts.poppins(
                    fontSize: 9,
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

  Widget _buildSelectionSummary() {
    // Check if any slot is selected
    final hasFullSlotSelection =
        selectedCourt != null && selectedSlotType != null;
    final hasPrivilegeSlotSelection = selectedPrivilegeSlots.values.any(
      (selected) => selected == true,
    );
    final hasPrivilegeBundleSelection = selectedPrivilegeBundles.values.any(
      (selected) => selected == true,
    );
    final hasGeneralSlotSelection =
        selectedSlot != null && selectedCourt != null && selectedTime != null;

    final hasAnySelection =
        hasFullSlotSelection ||
        hasPrivilegeSlotSelection ||
        hasPrivilegeBundleSelection ||
        hasGeneralSlotSelection;

    if (!hasAnySelection) {
      return const SizedBox.shrink();
    }

    String slotType = '';
    String slotDetails = '';

    if (hasFullSlotSelection) {
      slotType = 'Full Slot';
      slotDetails = '$selectedCourt - $selectedSlotType';
    } else if (hasPrivilegeSlotSelection) {
      final selectedPrivilegeSlot = selectedPrivilegeSlots.entries.firstWhere(
        (e) => e.value == true,
      );
      slotType = 'Privilege Slot';
      slotDetails = selectedPrivilegeSlot.key; // e.g., "Court 1-8:00"
    } else if (hasPrivilegeBundleSelection) {
      final selectedBundle = selectedPrivilegeBundles.entries.firstWhere(
        (e) => e.value == true,
      );
      slotType = 'Privilege Bundle';
      slotDetails = selectedBundle.key; // e.g., "Court 1-8:00-8:30"
    } else if (hasGeneralSlotSelection) {
      slotType = 'General Slot';
      slotDetails = '$selectedCourt at $selectedTime';
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF007BFF), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.check_circle,
                color: const Color(0xFF007BFF),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Selected Slot',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Selection Type Tabs (like the second image)
          Stack(
            children: [
              // Background line indicator
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 3,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(1.5),
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade800,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          slotType,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Center(
                        child: Text(
                          'Details',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Selection Details
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.sports_tennis,
                  color: const Color(0xFF007BFF),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Court & Time',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        slotDetails,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      // Clear all selections
                      selectedCourt = null;
                      selectedSlotIndex = null;
                      selectedSlotType = null;
                      selectedSlot = null;
                      selectedTime = null;
                      selectedPrivilegeSlots.clear();
                      selectedPrivilegeBundles.clear();
                    });
                  },
                  icon: Icon(
                    Icons.close,
                    color: Colors.grey.shade600,
                    size: 20,
                  ),
                  tooltip: 'Clear Selection',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getDayName(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday - 1];
  }

  String _getMonthNameShort(int month) {
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
