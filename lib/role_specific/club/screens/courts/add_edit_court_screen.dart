import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddEditCourtScreen extends StatefulWidget {
  const AddEditCourtScreen({super.key});

  @override
  State<AddEditCourtScreen> createState() => _AddEditCourtScreenState();
}

class _AddEditCourtScreenState extends State<AddEditCourtScreen>
    with TickerProviderStateMixin {
  late TabController _branchTabController;
  late TabController _sportTabController;

  // Court data
  final List<String> _branches = ['Branch 1', 'Branch 2', 'Branch 3'];
  final List<String> _sports = ['Basketball', 'Football', 'Tennis'];

  // Court schedule data
  final List<Map<String, dynamic>> _courts = [
    {
      'courtNumber': '2',
      'isIndoor': false,
      'schedules': [
        {'day': 'Monday', 'startTime': '09:00', 'endTime': '18:00'},
        {'day': 'Tuesday', 'startTime': '09:00', 'endTime': '18:00'},
        {'day': 'Wednesday', 'startTime': '09:00', 'endTime': '18:00'},
        {'day': 'Thursday', 'startTime': '09:00', 'endTime': '18:00'},
        {'day': 'Sunday', 'startTime': '09:00', 'endTime': '18:00'},
      ],
      'privilegeSlots': [
        {'day': 'Monday', 'startTime': '19:00', 'endTime': '21:00'},
        {'day': 'Tuesday', 'startTime': '19:00', 'endTime': '21:00'},
      ],
      'privilegeSlotStatus': 'Available',
      'discount': '20',
      'breakAfterBooking': true,
      'breakMinutes': '20',
      'maxPlayers': '10',
      'maxTeams': '10',
      'status': 'Maintenance / Shut Down',
    },
    {
      'courtNumber': '3',
      'isIndoor': true,
      'schedules': [
        {'day': 'Monday', 'startTime': '08:00', 'endTime': '20:00'},
        {'day': 'Tuesday', 'startTime': '08:00', 'endTime': '20:00'},
        {'day': 'Wednesday', 'startTime': '08:00', 'endTime': '20:00'},
        {'day': 'Thursday', 'startTime': '08:00', 'endTime': '20:00'},
        {'day': 'Friday', 'startTime': '08:00', 'endTime': '20:00'},
        {'day': 'Saturday', 'startTime': '08:00', 'endTime': '20:00'},
        {'day': 'Sunday', 'startTime': '08:00', 'endTime': '20:00'},
      ],
      'privilegeSlots': [
        {'day': 'Monday', 'startTime': '20:00', 'endTime': '22:00'},
        {'day': 'Tuesday', 'startTime': '20:00', 'endTime': '22:00'},
        {'day': 'Wednesday', 'startTime': '20:00', 'endTime': '22:00'},
      ],
      'privilegeSlotStatus': 'Available',
      'discount': '15',
      'breakAfterBooking': false,
      'breakMinutes': '15',
      'maxPlayers': '8',
      'maxTeams': '4',
      'status': 'Available',
    },
  ];

  // Coaches data
  final List<Map<String, dynamic>> _coaches = [
    {
      'name': 'Riya Mehra',
      'rating': 4.0,
      'gender': 'Male, Female, Other',
      'specialization': 'Football (U17), Tennis, Strength & Conditioning',
      'experience': '5+ Years, Former National Player',
      'certification': 'AIFF D-License, NASM CPT, First-Aid Certified',
      'language': 'English',
      'availability': 'Weekdays 6-9 PM, Weekends Full Day',
      'distance': '5 Miles From Event Venue, Richardson 62226',
      'hourlyRate': 'USD 50',
      'isBlocked': false,
    },
  ];

  // Billing data
  final Map<String, String> _billingRates = {
    'Per 30 Min': '10',
    'Per Hour': '10',
    'Per Day': '10',
    'Per Week': '10',
    'Per Month': '10',
  };

  // Guest seating
  bool _guestSeatingAvailable = true;

  // Subscription status (TODO: Get from user profile/API)
  bool _isPremiumUser = false; // Set to true for premium users

  // Sponsorship data
  final List<Map<String, dynamic>> _sponsorships = [
    {
      'type': 'Digital Ad',
      'inclusions': 'Club',
      'applicableRole': 'Club',
      'perDay': '100',
      'perWeek': '100',
      'perMonth': '100',
      'perYear': '100',
    },
    {
      'type': 'Sport Kit',
      'inclusions': 'Player',
      'applicableRole': 'Player',
      'perDay': '100',
      'perWeek': '100',
      'perMonth': '100',
      'perYear': '100',
    },
  ];

  @override
  void initState() {
    super.initState();
    _branchTabController = TabController(length: _branches.length, vsync: this);
    _sportTabController = TabController(length: _sports.length, vsync: this);
  }

  @override
  void dispose() {
    _branchTabController.dispose();
    _sportTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'ADD/EDIT COURT',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF1E40AF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          _buildActionButton('Export', Icons.download, () {}),
          _buildActionButton('Import', Icons.upload, () {}),
          _buildActionButton(
            'Cancel',
            Icons.close,
            () => Navigator.of(context).pop(),
          ),
          _buildActionButton('Save', Icons.save, _handleSave),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Branch Selection Tabs
            _buildBranchTabs(),
            const SizedBox(height: 16),

            // Sport Selection Tabs
            _buildSportTabs(),
            const SizedBox(height: 24),

            // Court Schedule Section
            _buildCourtScheduleSection(),
            const SizedBox(height: 24),

            // Coaches Section
            _buildCoachesSection(),
            const SizedBox(height: 24),

            // Change Schedule Section
            _buildChangeScheduleSection(),
            const SizedBox(height: 24),

            // Billing Method Section
            _buildBillingMethodSection(),
            const SizedBox(height: 24),

            // Guest Seating Section
            _buildGuestSeatingSection(),
            const SizedBox(height: 24),

            // Sponsorship Type Section
            _buildSponsorshipSection(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 16, color: Colors.white),
        label: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1E40AF),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
      ),
    );
  }

  Widget _buildBranchTabs() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TabBar(
        controller: _branchTabController,
        indicatorColor: const Color(0xFF1E40AF),
        labelColor: const Color(0xFF1E40AF),
        unselectedLabelColor: Colors.grey[600],
        labelStyle: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        onTap: (index) {
          // Handle branch selection
        },
        tabs: _branches.map((branch) => Tab(text: branch)).toList(),
      ),
    );
  }

  Widget _buildSportTabs() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TabBar(
        controller: _sportTabController,
        indicatorColor: const Color(0xFF1E40AF),
        labelColor: const Color(0xFF1E40AF),
        unselectedLabelColor: Colors.grey[600],
        labelStyle: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        onTap: (index) {
          // Handle sport selection
        },
        tabs: _sports.map((sport) => Tab(text: sport)).toList(),
      ),
    );
  }

  Widget _buildCourtScheduleSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
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
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFF1E40AF),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Text(
                  'Court Schedule',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: _addCourt,
                  icon: const Icon(Icons.add, size: 16, color: Colors.white),
                  label: Text(
                    'Add Court',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.2),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Information Notes
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.blue[50],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Important Information:',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue[800],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '• Conditions Should Be Set With Refunds Etc.\n'
                  '• Similarly, When Using Delete Schedule Or Delete Team Or Redefining Team, The New Changes Will Only Applicable For New Bookings, Past Bookings Will Work As It is Booked.\n'
                  '• But The Cost Of Coach Will Be Displayed To Every User At Free.\n'
                  '• Fees Should Be Provided To The Booking. Notification Shd Be Sent To Those Players.',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.blue[700],
                  ),
                ),
              ],
            ),
          ),

          // Courts List
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: _courts.asMap().entries.map((entry) {
                int index = entry.key;
                Map<String, dynamic> court = entry.value;
                return _buildCourtCard(index, court);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourtCard(int index, Map<String, dynamic> court) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Court Header
          Row(
            children: [
              Text(
                'Court ${court['courtNumber']}',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _addSchedule(index),
                    icon: const Icon(Icons.add, size: 14, color: Colors.white),
                    label: Text(
                      'Add Schedule',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () => _deleteCourt(index),
                    icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                  ),
                ],
              ),
            ],
          ),

          // Indoor Checkbox
          Row(
            children: [
              Checkbox(
                value: court['isIndoor'],
                onChanged: (value) {
                  setState(() {
                    court['isIndoor'] = value ?? false;
                  });
                },
                activeColor: const Color(0xFF1E40AF),
              ),
              Text(
                'Indoor',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Court Details in Mobile Layout
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 600) {
                // Mobile layout - stack vertically
                return Column(children: [_buildMobileCourtDetails(index, court)]);
              } else {
                // Tablet layout - side by side
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 2, child: _buildMobileCourtDetails(index, court)),
                    const SizedBox(width: 16),
                    Expanded(flex: 1, child: _buildCourtStatus(court)),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMobileCourtDetails(int courtIndex, Map<String, dynamic> court) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Full Day Service Time
        _buildScheduleSection(
          'Full Day Service Time',
          List<Map<String, dynamic>>.from(court['schedules']),
          true,
          courtIndex,
        ),
        const SizedBox(height: 16),

        // Privilege Slots
        _buildScheduleSection(
          'Privilege Slots',
          List<Map<String, dynamic>>.from(court['privilegeSlots']),
          false,
          courtIndex,
        ),
        const SizedBox(height: 12),
        // Separate Status Box for Privilege Slots
        _buildPrivilegeSlotStatusBox(court),
        const SizedBox(height: 16),

        // Other Details
        _buildCourtOtherDetails(court),
      ],
    );
  }

  Widget _buildScheduleSection(
    String title,
    List<Map<String, dynamic>> schedules,
    bool isFullDay,
    int courtIndex,
  ) {
    final isPrivilegeSlot = title == 'Privilege Slots';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            if (isPrivilegeSlot)
              ElevatedButton.icon(
                onPressed: () => _addPrivilegeSlot(courtIndex),
                icon: const Icon(Icons.add, size: 14, color: Colors.white),
                label: Text(
                  'Add',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E40AF),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        ...schedules
            .map((schedule) => _buildScheduleRow(schedule, isFullDay, isPrivilegeSlot, courtIndex))
            .toList(),
      ],
    );
  }

  Widget _buildPrivilegeSlotStatusBox(Map<String, dynamic> court) {
    final status = court['privilegeSlotStatus'] ?? 'Available';
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Status',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: status == 'Maintenance / Shut Down'
                  ? LinearGradient(
                      colors: [
                        Colors.red.shade400,
                        Colors.red.shade600,
                      ],
                    )
                  : null,
              color: status == 'Available' ? Colors.green.withOpacity(0.1) : null,
              borderRadius: BorderRadius.circular(20),
              border: status == 'Available'
                  ? Border.all(color: Colors.green, width: 1.5)
                  : null,
              boxShadow: status == 'Maintenance / Shut Down'
                  ? [
                      BoxShadow(
                        color: Colors.red.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: DropdownButton<String>(
              value: status,
              isExpanded: true,
              underline: const SizedBox(),
              icon: Icon(
                Icons.arrow_drop_down,
                size: 20,
                color: status == 'Maintenance / Shut Down' ? Colors.white : Colors.green,
              ),
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: status == 'Maintenance / Shut Down' ? Colors.white : Colors.green,
              ),
              items: ['Available', 'Maintenance / Shut Down'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) async {
                if (newValue != null && newValue != status) {
                  final oldStatus = status;
                  // Check if changing from Available to Maintenance/Shut Down
                  if (oldStatus == 'Available' && 
                      newValue == 'Maintenance / Shut Down') {
                    // Check for existing bookings in privilege slots
                    final hasBookings = await _checkExistingPrivilegeSlotBookings(court);
                    if (hasBookings) {
                      // Show cancellation dialog
                      final result = await _showCancellationDialog(context, court);
                      if (result == null || result == false) {
                        return; // User cancelled, don't change status
                      }
                    }
                  }
                  setState(() {
                    court['privilegeSlotStatus'] = newValue;
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleRow(Map<String, dynamic> schedule, bool isFullDay, bool isPrivilegeSlot, int courtIndex) {
    if (isPrivilegeSlot) {
      // Privilege slot row without status
      return Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        schedule['day']!,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () => _selectDateForPrivilegeSlot(context, schedule),
                        icon: const Icon(Icons.calendar_today, size: 18, color: Color(0xFF1E40AF)),
                        tooltip: 'Add Date',
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  if (schedule['date'] != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      schedule['date']!,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF1E40AF),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Expanded(child: _buildTimeInput(schedule['startTime']!)),
            const SizedBox(width: 8),
            Expanded(child: _buildTimeInput(schedule['endTime']!)),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () => _deleteSchedule(schedule, courtIndex, isPrivilegeSlot),
              icon: const Icon(Icons.delete, color: Colors.red, size: 16),
            ),
          ],
        ),
      );
    } else {
      // Regular schedule row (Full Day Service Time)
      return Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                schedule['day']!,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
            Expanded(child: _buildTimeInput(schedule['startTime']!)),
            const SizedBox(width: 8),
            Expanded(child: _buildTimeInput(schedule['endTime']!)),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () => _deleteSchedule(schedule, courtIndex, isPrivilegeSlot),
              icon: const Icon(Icons.delete, color: Colors.red, size: 16),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildTimeInput(String time) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        time,
        style: GoogleFonts.poppins(fontSize: 12),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildCourtOtherDetails(Map<String, dynamic> court) {
    return Column(
      children: [
        // Discount
        _buildInputRow('Discount', court['discount'], (value) {
          setState(() {
            court['discount'] = value;
          });
        }),
        const SizedBox(height: 12),

        // Break After Each Booking
        Row(
          children: [
            Checkbox(
              value: court['breakAfterBooking'],
              onChanged: (value) {
                setState(() {
                  court['breakAfterBooking'] = value ?? false;
                });
              },
              activeColor: const Color(0xFF1E40AF),
            ),
            Text(
              'Break After Each Booking?',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: DropdownButtonFormField<String>(
                value: 'Minutes',
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                ),
                items: ['Minutes', 'Hours'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: GoogleFonts.poppins(fontSize: 12),
                    ),
                  );
                }).toList(),
                onChanged: (value) {},
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 60,
              child: TextFormField(
                initialValue: court['breakMinutes'],
                style: GoogleFonts.poppins(fontSize: 12),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    court['breakMinutes'] = value;
                  });
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Max Players and Max Teams
        Row(
          children: [
            Expanded(
              child: _buildInputRow('Max Players', court['maxPlayers'], (
                value,
              ) {
                setState(() {
                  court['maxPlayers'] = value;
                });
              }),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildInputRow('Max Teams', court['maxTeams'], (value) {
                setState(() {
                  court['maxTeams'] = value;
                });
              }),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInputRow(
    String label,
    String value,
    Function(String) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        TextFormField(
          initialValue: value,
          style: GoogleFonts.poppins(fontSize: 12),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 8,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildCourtStatus(Map<String, dynamic> court) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Status',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: court['status'],
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
          ),
          items: ['Available', 'Maintenance / Shut Down', 'Occupied'].map((
            String value,
          ) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: GoogleFonts.poppins(fontSize: 12)),
            );
          }).toList(),
          onChanged: (value) async {
            if (value != null && value != court['status']) {
              final oldStatus = court['status'];
              // Check if changing from Available to Maintenance/Shut Down
              if (oldStatus == 'Available' && 
                  (value == 'Maintenance / Shut Down' || value == 'Occupied')) {
                // Check for existing bookings
                final hasBookings = await _checkExistingBookings(court);
                if (hasBookings) {
                  // Show cancellation dialog
                  final result = await _showCancellationDialog(context, court);
                  if (result == null || result == false) {
                    return; // User cancelled, don't change status
                  }
                }
              }
              setState(() {
                court['status'] = value;
              });
            }
          },
        ),
      ],
    );
  }

  Widget _buildCoachesSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
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
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFF1E40AF),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Text(
                  'Coaches',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: Text(
                    'Upgrade To Unlock Coach Ratings And Reviews',
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Coaches List
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: _coaches
                  .map((coach) => _buildCoachCard(coach))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoachCard(Map<String, dynamic> coach) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Coach Header
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xFF1E40AF),
                child: Text(
                  coach['name'][0],
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
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
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    // Show ratings only for premium users
                    if (_isPremiumUser)
                      Row(
                        children: List.generate(5, (index) {
                          return Icon(
                            index < coach['rating']
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.amber,
                            size: 16,
                          );
                        }),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.orange[50],
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.orange[200]!),
                        ),
                        child: Text(
                          'Upgrade to Premium to view ratings',
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            color: Colors.orange[800],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (!coach['isBlocked']) {
                    // Check if coach is assigned to any bookings
                    final hasBookings = await _checkCoachBookings(coach);
                    if (hasBookings) {
                      // Show dialog with options
                      final result = await _showCoachBlockingDialog(context, coach);
                      if (result == null) {
                        return; // User cancelled
                      }
                    } else {
                      setState(() {
                        coach['isBlocked'] = true;
                      });
                    }
                  } else {
                    setState(() {
                      coach['isBlocked'] = false;
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: coach['isBlocked']
                      ? Colors.green
                      : Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                child: Text(
                  coach['isBlocked'] ? 'Unblock' : 'Block',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Coach Details
          _buildCoachDetailRow('Gender', coach['gender']),
          _buildCoachDetailRow('Specialisation', coach['specialization']),
          _buildCoachDetailRow('Coaching Experience', coach['experience']),
          _buildCoachDetailRow('Certification', coach['certification']),
          _buildCoachDetailRow('Language Spoken', coach['language']),
          _buildCoachDetailRow('Availability', coach['availability']),
          _buildCoachDetailRow('Distance', coach['distance']),
          _buildCoachDetailRow('Hourly Rate', coach['hourlyRate']),
        ],
      ),
    );
  }

  Widget _buildCoachDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChangeScheduleSection() {
    return Column(
      children: [
        _buildChangeScheduleCard('Closure'),
        const SizedBox(height: 16),
        _buildChangeScheduleCard('Maintenance'),
      ],
    );
  }

  Widget _buildChangeScheduleCard(String type) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Change Schedule',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Schedule Type',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      DropdownButtonFormField<String>(
                        value: type,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                        ),
                        items: ['Closure', 'Maintenance'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: GoogleFonts.poppins(fontSize: 12),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {},
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'From Date',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      TextFormField(
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          suffixIcon: const Icon(
                            Icons.calendar_today,
                            size: 16,
                          ),
                        ),
                        readOnly: true,
                        onTap: () => _selectDate(context),
                      ),
                    ],
                  ),
                ),
                if (type == 'Maintenance') ...[
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'To Date',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        TextFormField(
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            suffixIcon: const Icon(
                              Icons.calendar_today,
                              size: 16,
                            ),
                          ),
                          readOnly: true,
                          onTap: () => _selectDate(context),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Note',
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E40AF),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: Text(
                    type == 'Closure' ? 'Close' : 'Save',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBillingMethodSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Billing Method & Charges',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            ..._billingRates.entries
                .map((entry) => _buildBillingRow(entry.key, entry.value))
                .toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildBillingRow(String period, String amount) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              period,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: DropdownButtonFormField<String>(
              value: 'USD',
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 8,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
              ),
              items: ['USD', 'EUR', 'INR'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: GoogleFonts.poppins(fontSize: 12)),
                );
              }).toList(),
              onChanged: (value) {},
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextFormField(
              initialValue: amount,
              style: GoogleFonts.poppins(fontSize: 12),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 8,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _billingRates[period] = value;
                  // Auto-calculate other periods based on formula
                  _calculateBillingRates(period, value);
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuestSeatingSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Guest Seating',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Checkbox(
                  value: _guestSeatingAvailable,
                  onChanged: (value) {
                    setState(() {
                      _guestSeatingAvailable = value ?? false;
                    });
                  },
                  activeColor: const Color(0xFF1E40AF),
                ),
                Text(
                  'Available',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(width: 16),
                Checkbox(
                  value: !_guestSeatingAvailable,
                  onChanged: (value) {
                    setState(() {
                      _guestSeatingAvailable = !(value ?? false);
                    });
                  },
                  activeColor: const Color(0xFF1E40AF),
                ),
                Text(
                  'Not Available',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Capacity',
                hintText: 'Input Text',
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
              ),
              onChanged: (value) {
                // Handle capacity change
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSponsorshipSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
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
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFF1E40AF),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Text(
                  'Sponsorship Type',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: _addSponsorship,
                  icon: const Icon(Icons.add, size: 16, color: Colors.white),
                  label: Text(
                    'Add Sponsorship',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.2),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Sponsorship List
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: _sponsorships.asMap().entries.map((entry) {
                int index = entry.key;
                Map<String, dynamic> sponsorship = entry.value;
                return _buildSponsorshipCard(index, sponsorship);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSponsorshipCard(int index, Map<String, dynamic> sponsorship) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Sponsorship ${index + 1}',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => _deleteSponsorship(index),
                icon: const Icon(Icons.close, color: Colors.red, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildSponsorshipDropdown(
                  'Type',
                  sponsorship['type'],
                  (value) {
                    setState(() {
                      sponsorship['type'] = value ?? 'Digital Ad';
                    });
                  },
                  ['Digital Ad', 'Sport Kit', 'Video Play', 'Bill Board'],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSponsorshipDropdown(
                  'Inclusions',
                  sponsorship['inclusions'],
                  (value) {
                    setState(() {
                      sponsorship['inclusions'] = value ?? 'Club';
                    });
                  },
                  ['Club', 'Player'],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildSponsorshipDropdown(
            'Applicable To Role',
            sponsorship['applicableRole'],
            (value) {
              setState(() {
                sponsorship['applicableRole'] = value ?? 'Club';
              });
            },
            ['Club', 'Player'],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildSponsorshipInput(
                  'Per Day',
                  sponsorship['perDay'],
                  (value) {
                    setState(() {
                      sponsorship['perDay'] = value;
                    });
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildSponsorshipInput(
                  'Per Week',
                  sponsorship['perWeek'],
                  (value) {
                    setState(() {
                      sponsorship['perWeek'] = value;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildSponsorshipInput(
                  'Per Month',
                  sponsorship['perMonth'],
                  (value) {
                    setState(() {
                      sponsorship['perMonth'] = value;
                    });
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildSponsorshipInput(
                  'Per Year',
                  sponsorship['perYear'],
                  (value) {
                    setState(() {
                      sponsorship['perYear'] = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSponsorshipDropdown(
    String label,
    String value,
    ValueChanged<String?> onChanged,
    List<String> items,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 8,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item, style: GoogleFonts.poppins(fontSize: 12)),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildSponsorshipInput(
    String label,
    String value,
    Function(String) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        TextFormField(
          initialValue: value,
          style: GoogleFonts.poppins(fontSize: 12),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 8,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }

  // Business Logic Methods
  void _calculateBillingRates(String changedPeriod, String value) {
    final perDayValue = double.tryParse(_billingRates['Per Day'] ?? '0') ?? 0.0;
    
    if (perDayValue == 0) return;
    
    // Formula: per week = 5 times per day, per month = 2x week, per year = 5x month
    if (changedPeriod == 'Per Day') {
      final perDay = double.tryParse(value) ?? 0.0;
      _billingRates['Per Week'] = (perDay * 5).toStringAsFixed(2);
      final perWeek = double.parse(_billingRates['Per Week']!);
      _billingRates['Per Month'] = (perWeek * 2).toStringAsFixed(2);
      final perMonth = double.parse(_billingRates['Per Month']!);
      _billingRates['Per Year'] = (perMonth * 5).toStringAsFixed(2);
    } else if (changedPeriod == 'Per Week') {
      final perWeek = double.tryParse(value) ?? 0.0;
      _billingRates['Per Day'] = (perWeek / 5).toStringAsFixed(2);
      _billingRates['Per Month'] = (perWeek * 2).toStringAsFixed(2);
      final perMonth = double.parse(_billingRates['Per Month']!);
      _billingRates['Per Year'] = (perMonth * 5).toStringAsFixed(2);
    } else if (changedPeriod == 'Per Month') {
      final perMonth = double.tryParse(value) ?? 0.0;
      _billingRates['Per Week'] = (perMonth / 2).toStringAsFixed(2);
      final perWeek = double.parse(_billingRates['Per Week']!);
      _billingRates['Per Day'] = (perWeek / 5).toStringAsFixed(2);
      _billingRates['Per Year'] = (perMonth * 5).toStringAsFixed(2);
    } else if (changedPeriod == 'Per Year') {
      final perYear = double.tryParse(value) ?? 0.0;
      _billingRates['Per Month'] = (perYear / 5).toStringAsFixed(2);
      final perMonth = double.parse(_billingRates['Per Month']!);
      _billingRates['Per Week'] = (perMonth / 2).toStringAsFixed(2);
      final perWeek = double.parse(_billingRates['Per Week']!);
      _billingRates['Per Day'] = (perWeek / 5).toStringAsFixed(2);
    }
  }

  Future<bool> _checkExistingBookings(Map<String, dynamic> court) async {
    // TODO: Implement actual API call to check for existing bookings
    // For now, simulate checking
    await Future.delayed(const Duration(milliseconds: 500));
    // Simulate: return true if there are bookings
    return true; // Change this to actual booking check
  }

  Future<bool> _checkExistingPrivilegeSlotBookings(Map<String, dynamic> court) async {
    // TODO: Implement actual API call to check for privilege slot bookings
    await Future.delayed(const Duration(milliseconds: 500));
    return true; // Change this to actual booking check
  }

  Future<bool> _checkCoachBookings(Map<String, dynamic> coach) async {
    // TODO: Implement actual API call to check if coach is assigned to bookings
    await Future.delayed(const Duration(milliseconds: 500));
    return true; // Change this to actual booking check
  }

  Future<String?> _showCoachBlockingDialog(BuildContext context, Map<String, dynamic> coach) async {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        String action = 'Change Coach';
        bool notifyUsers = true;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(
                'Coach Has Active Bookings',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'This coach is assigned to active bookings. Choose an action:',
                      style: GoogleFonts.poppins(fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Action:',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: action,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      items: [
                        'Change Coach',
                        'Refund Coach Fees',
                        'Change Coach & Refund',
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value, style: GoogleFonts.poppins(fontSize: 12)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setDialogState(() {
                          action = value ?? 'Change Coach';
                        });
                      },
                    ),
                    if (action == 'Change Coach' || action == 'Change Coach & Refund') ...[
                      const SizedBox(height: 12),
                      Text(
                        'Select Replacement Coach:',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: null,
                        decoration: InputDecoration(
                          hintText: 'Select Coach',
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        items: _coaches
                            .where((c) => c['name'] != coach['name'] && !c['isBlocked'])
                            .map((c) {
                          return DropdownMenuItem<String>(
                            value: c['name'],
                            child: Text(
                              c['name'],
                              style: GoogleFonts.poppins(fontSize: 12),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {},
                      ),
                    ],
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Checkbox(
                          value: notifyUsers,
                          onChanged: (value) {
                            setDialogState(() {
                              notifyUsers = value ?? true;
                            });
                          },
                          activeColor: const Color(0xFF1E40AF),
                        ),
                        Expanded(
                          child: Text(
                            'Send notification to affected players',
                            style: GoogleFonts.poppins(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(null),
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.poppins(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Implement coach blocking logic
                    // - Change coach if selected
                    // - Refund fees if selected
                    // - Send notifications if selected
                    Navigator.of(context).pop(action);
                    setState(() {
                      coach['isBlocked'] = true;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E40AF),
                    foregroundColor: Colors.white,
                  ),
                  child: Text(
                    'Confirm',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<bool?> _showCancellationDialog(BuildContext context, Map<String, dynamic> court) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        String cancellationType = 'Full Refund';
        String refundPercentage = '100';
        bool notifyUsers = true;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(
                'Existing Bookings Found',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'This court has existing bookings. Please set cancellation conditions:',
                      style: GoogleFonts.poppins(fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Cancellation Type:',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: cancellationType,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      items: [
                        'Full Refund',
                        'Partial Refund',
                        'No Refund',
                        'Credit to Account',
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value, style: GoogleFonts.poppins(fontSize: 12)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setDialogState(() {
                          cancellationType = value ?? 'Full Refund';
                        });
                      },
                    ),
                    if (cancellationType == 'Partial Refund') ...[
                      const SizedBox(height: 12),
                      Text(
                        'Refund Percentage:',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        initialValue: refundPercentage,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          suffixText: '%',
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        onChanged: (value) {
                          refundPercentage = value;
                        },
                      ),
                    ],
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Checkbox(
                          value: notifyUsers,
                          onChanged: (value) {
                            setDialogState(() {
                              notifyUsers = value ?? true;
                            });
                          },
                          activeColor: const Color(0xFF1E40AF),
                        ),
                        Expanded(
                          child: Text(
                            'Send notification to affected users',
                            style: GoogleFonts.poppins(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.poppins(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Save cancellation settings
                    // TODO: Implement actual cancellation logic
                    Navigator.of(context).pop(true);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E40AF),
                    foregroundColor: Colors.white,
                  ),
                  child: Text(
                    'Confirm',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Action Methods
  void _addCourt() {
    setState(() {
      _courts.add({
        'courtNumber': '${_courts.length + 1}',
        'isIndoor': false,
        'schedules': [],
        'privilegeSlots': [],
        'privilegeSlotStatus': 'Available',
        'discount': '0',
        'breakAfterBooking': false,
        'breakMinutes': '15',
        'maxPlayers': '10',
        'maxTeams': '5',
        'status': 'Available',
      });
    });
  }

  void _deleteCourt(int index) {
    setState(() {
      _courts.removeAt(index);
    });
  }

  void _addSchedule(int courtIndex) {
    setState(() {
      _courts[courtIndex]['schedules'].add({
        'day': 'Monday',
        'startTime': '09:00',
        'endTime': '18:00',
      });
    });
  }

  void _deleteSchedule(Map<String, dynamic> schedule, int courtIndex, bool isPrivilegeSlot) async {
    // Show warning dialog
    final confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Delete Schedule',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Are you sure you want to delete this schedule?',
                style: GoogleFonts.poppins(fontSize: 14),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Text(
                  'Note: New changes will only apply to new bookings. Past bookings will work as they were booked.',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.blue[800],
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: Text(
                'Delete',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      setState(() {
        if (isPrivilegeSlot) {
          _courts[courtIndex]['privilegeSlots'].remove(schedule);
        } else {
          _courts[courtIndex]['schedules'].remove(schedule);
        }
      });
    }
  }

  void _addPrivilegeSlot(int courtIndex) {
    setState(() {
      _courts[courtIndex]['privilegeSlots'].add({
        'day': 'Monday',
        'startTime': '19:00',
        'endTime': '21:00',
      });
      // Initialize privilegeSlotStatus if not exists
      if (!_courts[courtIndex].containsKey('privilegeSlotStatus')) {
        _courts[courtIndex]['privilegeSlotStatus'] = 'Available';
      }
    });
  }

  void _addSponsorship() {
    setState(() {
      _sponsorships.add({
        'type': 'Digital Ad',
        'inclusions': 'Club',
        'applicableRole': 'Club',
        'perDay': '100',
        'perWeek': '100',
        'perMonth': '100',
        'perYear': '100',
      });
    });
  }

  void _deleteSponsorship(int index) {
    setState(() {
      _sponsorships.removeAt(index);
    });
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      // Handle date selection
    }
  }

  void _selectDateForPrivilegeSlot(BuildContext context, Map<String, dynamic> schedule) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        // Format date as DD-MM-YYYY
        final formattedDate = '${picked.day.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.year}';
        schedule['date'] = formattedDate;
        // Update day if needed
        final weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
        schedule['day'] = weekdays[picked.weekday - 1];
      });
    }
  }

  void _handleSave() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Court saved successfully!',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
    Navigator.of(context).pop();
  }
}
