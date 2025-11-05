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
                return Column(children: [_buildMobileCourtDetails(court)]);
              } else {
                // Tablet layout - side by side
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 2, child: _buildMobileCourtDetails(court)),
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

  Widget _buildMobileCourtDetails(Map<String, dynamic> court) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Full Day Service Time
        _buildScheduleSection(
          'Full Day Service Time',
          List<Map<String, String>>.from(court['schedules']),
          true,
        ),
        const SizedBox(height: 16),

        // Privilege Slots
        _buildScheduleSection(
          'Privilege Slots',
          List<Map<String, String>>.from(court['privilegeSlots']),
          false,
        ),
        const SizedBox(height: 16),

        // Other Details
        _buildCourtOtherDetails(court),
      ],
    );
  }

  Widget _buildScheduleSection(
    String title,
    List<Map<String, String>> schedules,
    bool isFullDay,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        ...schedules
            .map((schedule) => _buildScheduleRow(schedule, isFullDay))
            .toList(),
      ],
    );
  }

  Widget _buildScheduleRow(Map<String, String> schedule, bool isFullDay) {
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
            onPressed: () => _deleteSchedule(schedule),
            icon: const Icon(Icons.delete, color: Colors.red, size: 16),
          ),
        ],
      ),
    );
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
          onChanged: (value) {
            setState(() {
              court['status'] = value;
            });
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
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    coach['isBlocked'] = !coach['isBlocked'];
                  });
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
              onChanged: (value) {
                setState(() {
                  _billingRates[period] = value;
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

  // Action Methods
  void _addCourt() {
    setState(() {
      _courts.add({
        'courtNumber': '${_courts.length + 1}',
        'isIndoor': false,
        'schedules': [],
        'privilegeSlots': [],
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

  void _deleteSchedule(Map<String, String> schedule) {
    setState(() {
      for (var court in _courts) {
        court['schedules'].remove(schedule);
        court['privilegeSlots'].remove(schedule);
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
