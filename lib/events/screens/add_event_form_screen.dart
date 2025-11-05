import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddEventFormScreen extends StatefulWidget {
  const AddEventFormScreen({super.key});

  @override
  State<AddEventFormScreen> createState() => _AddEventFormScreenState();
}

class _AddEventFormScreenState extends State<AddEventFormScreen> {
  int _selectedTabIndex = 0;
  final _formKey = GlobalKey<FormState>();

  // Form controllers
  final _eventNameController = TextEditingController();
  final _eventDescriptionController = TextEditingController();
  final _firstPrizeController = TextEditingController();
  final _secondPrizeController = TextEditingController();
  final _thirdPrizeController = TextEditingController();
  final _promotionalImageController = TextEditingController();
  final _registrationStartController = TextEditingController();
  final _registrationEndController = TextEditingController();
  final _attendeeChargeController = TextEditingController();
  final _coachChargeController = TextEditingController();
  final _playerChargeController = TextEditingController();
  final _teamChargeController = TextEditingController();
  final _rulesController = TextEditingController();
  final _noOfDaysController = TextEditingController(text: '3');
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();

  // Form data
  List<String> _selectedSports = ['Cricket', 'Football'];
  List<String> _availableSports = [
    'Cricket',
    'Football',
    'Tennis',
    'Basketball',
    'Volleyball',
    'Badminton',
  ];
  String _selectedCurrency = 'USD';
  bool _isScheduleSameForAllDays = true;
  int _noOfDays = 3;
  List<Map<String, dynamic>> _scheduleData = [];

  // Attendance Requirements data
  bool _isAttendeesInfoSame = true;
  bool _isSponsorshipApplicable = true;

  // Sport-specific attendees information
  int _selectedSportTab = 0;
  List<String> _sportTypes = ['Football', 'Cricket', 'Tennis'];

  // Attendees Information - General (when same for all sports)
  String _maxTeams = '4';
  String _playersPerTeam = '40';
  String _coachPerTeam = '8';
  String _gender = 'All';
  String _ageGroup = '18-24';
  String _maxSpectators = '100';

  // Sport-specific attendees information
  Map<String, Map<String, String>> _sportSpecificData = {};

  // Organizer Information
  final _organizerFirstNameController = TextEditingController();
  final _organizerLastNameController = TextEditingController();
  final _organizerContactController = TextEditingController(text: '1234567890');
  final _organizerEmailController = TextEditingController(
    text: 'Aaa@Gmail.Com',
  );
  final _organizerWebsiteController = TextEditingController(text: 'Abc.com');

  // Sponsorship Categories
  bool _corporateSponsorship = true;
  bool _merchandiseSponsorship = true;
  bool _coachSponsorship = false;
  bool _membersSponsorship = false;
  bool _freelancersSponsorship = false;

  // Sponsorship Data
  List<Map<String, dynamic>> _club1Sponsorships = [];
  List<Map<String, dynamic>> _club2Sponsorships = [];
  List<Map<String, dynamic>> _tournamentSponsorships = [];

  @override
  void initState() {
    super.initState();
    _initializeScheduleData();
    _initializeSponsorshipData();
    _initializeSportSpecificData();
  }

  void _initializeScheduleData() {
    _scheduleData = List.generate(_noOfDays, (index) {
      return {
        'day': index + 1,
        'date': _getDateString(index),
        'sportType': index < _selectedSports.length
            ? _selectedSports[index]
            : '',
        'startTime': '',
        'endTime': '',
        'venue': '',
      };
    });
  }

  String _getDateString(int dayOffset) {
    final now = DateTime.now();
    final date = now.add(Duration(days: dayOffset + 7)); // Start from next week
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final months = [
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
    return '${weekdays[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  void _initializeSponsorshipData() {
    // Initialize with sample data
    _club1Sponsorships = [
      {
        'type': 'Bill Board',
        'role': 'Corporate',
        'perDay': '100',
        'perWeek': '100',
        'perMonth': '100',
        'perYear': '100',
      },
      {
        'type': 'Digital Ad',
        'role': 'Merchandise',
        'perDay': '100',
        'perWeek': '100',
        'perMonth': '100',
        'perYear': '100',
      },
      {
        'type': 'Uniform',
        'role': 'Coach',
        'perDay': '100',
        'perWeek': '100',
        'perMonth': '100',
        'perYear': '100',
      },
      {
        'type': 'Video Play',
        'role': 'Freelancer',
        'perDay': '100',
        'perWeek': '100',
        'perMonth': '100',
        'perYear': '100',
      },
    ];

    _club2Sponsorships = List.from(_club1Sponsorships);
    _tournamentSponsorships = List.from(_club1Sponsorships);
  }

  void _initializeSportSpecificData() {
    // Initialize sport-specific data for each sport
    for (String sport in _sportTypes) {
      _sportSpecificData[sport] = {
        'maxTeams': '4',
        'playersPerTeam': '40',
        'coachPerTeam': '8',
        'gender': 'All',
        'ageGroup': '18-24',
        'maxSpectators': '100',
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Add Event',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF007BFF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: _saveEvent,
            child: Text(
              'Save',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildTabNavigation(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_selectedTabIndex == 0) _buildEventDetailsTab(),
                    if (_selectedTabIndex == 1)
                      _buildAttendanceRequirementsTab(),
                    if (_selectedTabIndex == 2) _buildSubscriptionRequestsTab(),
                    const SizedBox(height: 80), // Space for FAB
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _saveEvent,
        backgroundColor: const Color(0xFF007BFF),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.save),
        label: Text(
          'Save Event',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildTabNavigation() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(25),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildTabButton('Event Details', 0),
            _buildTabButton('Attendance Requirements', 1),
            _buildTabButton('Subscription Requests', 2),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(String text, int index) {
    final isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTabIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF007BFF) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : Colors.grey[600],
          ),
        ),
      ),
    );
  }

  Widget _buildEventDetailsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Event Details'),
        const SizedBox(height: 16),

        _buildFormField(
          controller: _eventNameController,
          label: 'Event Name',
          hint: 'Input Text',
          validator: (value) =>
              value?.isEmpty == true ? 'Event name is required' : null,
        ),
        const SizedBox(height: 16),

        _buildFormField(
          controller: _eventDescriptionController,
          label: 'Event Description',
          hint: 'Input Text',
          maxLines: 3,
          validator: (value) =>
              value?.isEmpty == true ? 'Event description is required' : null,
        ),
        const SizedBox(height: 24),

        _buildTrophySection(),
        const SizedBox(height: 24),

        _buildSportsTypeSection(),
        const SizedBox(height: 24),

        _buildPromotionalImageSection(),
        const SizedBox(height: 24),

        _buildRegistrationDatesSection(),
        const SizedBox(height: 24),

        _buildRegistrationChargesSection(),
        const SizedBox(height: 24),

        _buildRulesSection(),
        const SizedBox(height: 24),

        _buildEventScheduleSection(),
      ],
    );
  }

  Widget _buildTrophySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Trophy',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 600) {
              // Mobile layout - stack vertically
              return Column(
                children: [
                  _buildFormField(
                    controller: _firstPrizeController,
                    label: '1st Prize',
                    hint: 'Input Text',
                  ),
                  const SizedBox(height: 12),
                  _buildFormField(
                    controller: _secondPrizeController,
                    label: '2nd Prize',
                    hint: 'Input Text',
                  ),
                  const SizedBox(height: 12),
                  _buildFormField(
                    controller: _thirdPrizeController,
                    label: '3rd Prize',
                    hint: 'Input Text',
                  ),
                ],
              );
            } else {
              // Tablet layout - horizontal
              return Row(
                children: [
                  Expanded(
                    child: _buildFormField(
                      controller: _firstPrizeController,
                      label: '1st Prize',
                      hint: 'Input Text',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildFormField(
                      controller: _secondPrizeController,
                      label: '2nd Prize',
                      hint: 'Input Text',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildFormField(
                      controller: _thirdPrizeController,
                      label: '3rd Prize',
                      hint: 'Input Text',
                    ),
                  ),
                ],
              );
            }
          },
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerLeft,
          child: ElevatedButton(
            onPressed: () {
              // Add price logic
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF007BFF),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: Text('Add Price', style: GoogleFonts.poppins(fontSize: 12)),
          ),
        ),
      ],
    );
  }

  Widget _buildSportsTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sports Type',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _selectedSports.map((sport) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF007BFF),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    sport,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedSports.remove(sport);
                      });
                    },
                    child: const Icon(
                      Icons.close,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search sports...',
                  hintStyle: GoogleFonts.poppins(fontSize: 14),
                  prefixIcon: const Icon(Icons.search, size: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF007BFF)),
                  ),
                ),
                onSubmitted: (value) {
                  if (value.isNotEmpty && !_selectedSports.contains(value)) {
                    setState(() {
                      _selectedSports.add(value);
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPromotionalImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFormField(
          controller: _promotionalImageController,
          label: 'Event Promotional Image',
          hint: 'Input Text',
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () {
            // Handle image upload
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Image upload feature coming soon!',
                  style: GoogleFonts.poppins(),
                ),
                backgroundColor: const Color(0xFF007BFF),
              ),
            );
          },
          child: Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey[300]!,
                style: BorderStyle.solid,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[50],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.cloud_upload_outlined,
                  size: 48,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 8),
                Text(
                  'Tap to Upload Image',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'JPG, PNG, GIF up to 10MB',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Color(0xFF007BFF),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 20),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegistrationDatesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Registration Dates',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 600) {
              // Mobile layout - stack vertically
              return Column(
                children: [
                  _buildFormField(
                    controller: _registrationStartController,
                    label: 'Registration Start Date',
                    hint: 'Wed, March 05, 2025',
                    readOnly: true,
                    suffixIcon: const Icon(Icons.calendar_today, size: 20),
                    onTap: () => _selectDate(_registrationStartController),
                  ),
                  const SizedBox(height: 12),
                  _buildFormField(
                    controller: _registrationEndController,
                    label: 'Registration End Date',
                    hint: 'Wed, March 05, 2025',
                    readOnly: true,
                    suffixIcon: const Icon(Icons.calendar_today, size: 20),
                    onTap: () => _selectDate(_registrationEndController),
                  ),
                ],
              );
            } else {
              // Tablet layout - horizontal
              return Row(
                children: [
                  Expanded(
                    child: _buildFormField(
                      controller: _registrationStartController,
                      label: 'Registration Start Date',
                      hint: 'Wed, March 05, 2025',
                      readOnly: true,
                      suffixIcon: const Icon(Icons.calendar_today, size: 20),
                      onTap: () => _selectDate(_registrationStartController),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildFormField(
                      controller: _registrationEndController,
                      label: 'Registration End Date',
                      hint: 'Wed, March 05, 2025',
                      readOnly: true,
                      suffixIcon: const Icon(Icons.calendar_today, size: 20),
                      onTap: () => _selectDate(_registrationEndController),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildRegistrationChargesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Registration Charges',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Additional XX% Platform Fee Will Be Charged On The Top Of Below Registration Charges.',
          style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
        ),
        const SizedBox(height: 16),
        _buildChargeRow('Attendee', _attendeeChargeController, true),
        _buildChargeRow('Coach', _coachChargeController, true),
        _buildChargeRow('Player', _playerChargeController, true),
        _buildChargeRow('Team', _teamChargeController, true),
      ],
    );
  }

  Widget _buildChargeRow(
    String label,
    TextEditingController controller,
    bool isChecked,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 400) {
            // Very small screens - stack vertically
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: isChecked,
                      onChanged: (value) {
                        // Handle checkbox change
                      },
                      activeColor: const Color(0xFF007BFF),
                    ),
                    Text(
                      label,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFF007BFF),
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    DropdownButton<String>(
                      value: _selectedCurrency,
                      items: ['USD', 'EUR', 'GBP'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedCurrency = newValue!;
                        });
                      },
                      underline: Container(),
                    ),
                  ],
                ),
              ],
            );
          } else {
            // Normal layout - horizontal
            return Row(
              children: [
                Checkbox(
                  value: isChecked,
                  onChanged: (value) {
                    // Handle checkbox change
                  },
                  activeColor: const Color(0xFF007BFF),
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF007BFF)),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: _selectedCurrency,
                  items: ['USD', 'EUR', 'GBP'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCurrency = newValue!;
                    });
                  },
                  underline: Container(),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildRulesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Rules & Regulations',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              // Toolbar simulation
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildToolbarButton(Icons.format_bold),
                      _buildToolbarButton(Icons.format_italic),
                      _buildToolbarButton(Icons.format_underlined),
                      _buildToolbarButton(Icons.format_strikethrough),
                      _buildToolbarButton(Icons.superscript),
                      _buildToolbarButton(Icons.subscript),
                      _buildToolbarButton(Icons.format_align_left),
                      _buildToolbarButton(Icons.format_align_center),
                      _buildToolbarButton(Icons.format_align_right),
                      _buildToolbarButton(Icons.format_align_justify),
                      _buildToolbarButton(Icons.format_color_text),
                      _buildToolbarButton(Icons.format_color_fill),
                      _buildToolbarButton(Icons.format_list_bulleted),
                      _buildToolbarButton(Icons.format_list_numbered),
                      _buildToolbarButton(Icons.format_indent_increase),
                      _buildToolbarButton(Icons.format_indent_decrease),
                      _buildToolbarButton(Icons.link),
                      _buildToolbarButton(Icons.image),
                      _buildToolbarButton(Icons.table_chart),
                      _buildToolbarButton(Icons.format_clear),
                    ],
                  ),
                ),
              ),
              TextField(
                controller: _rulesController,
                maxLines: 8,
                decoration: const InputDecoration(
                  hintText: 'Input Text',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(12),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildToolbarButton(IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: IconButton(
        icon: Icon(icon, size: 16),
        onPressed: () {
          // Handle toolbar action
        },
        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
        padding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildEventScheduleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Event Schedule',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 600) {
              // Mobile layout - stack vertically
              return Column(
                children: [
                  _buildFormField(
                    controller: _noOfDaysController,
                    label: 'No. Of Days',
                    hint: '3',
                    readOnly: true,
                    suffixIcon: const Icon(Icons.arrow_drop_down, size: 20),
                    onTap: () => _selectNumberOfDays(),
                  ),
                  const SizedBox(height: 12),
                  _buildFormField(
                    controller: _startDateController,
                    label: 'Start Date',
                    hint: 'Wed, March 05, 2025',
                    readOnly: true,
                    suffixIcon: const Icon(Icons.calendar_today, size: 20),
                    onTap: () => _selectDate(_startDateController),
                  ),
                  const SizedBox(height: 12),
                  _buildFormField(
                    controller: _endDateController,
                    label: 'End Date',
                    hint: 'Wed, March 05, 2025',
                    readOnly: true,
                    suffixIcon: const Icon(Icons.calendar_today, size: 20),
                    onTap: () => _selectDate(_endDateController),
                  ),
                ],
              );
            } else {
              // Tablet layout - horizontal
              return Row(
                children: [
                  Expanded(
                    child: _buildFormField(
                      controller: _noOfDaysController,
                      label: 'No. Of Days',
                      hint: '3',
                      readOnly: true,
                      suffixIcon: const Icon(Icons.arrow_drop_down, size: 20),
                      onTap: () => _selectNumberOfDays(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildFormField(
                      controller: _startDateController,
                      label: 'Start Date',
                      hint: 'Wed, March 05, 2025',
                      readOnly: true,
                      suffixIcon: const Icon(Icons.calendar_today, size: 20),
                      onTap: () => _selectDate(_startDateController),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildFormField(
                      controller: _endDateController,
                      label: 'End Date',
                      hint: 'Wed, March 05, 2025',
                      readOnly: true,
                      suffixIcon: const Icon(Icons.calendar_today, size: 20),
                      onTap: () => _selectDate(_endDateController),
                    ),
                  ),
                ],
              );
            }
          },
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 400) {
              // Very small screens - stack radio buttons vertically
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Is Schedule Same For All Days?',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Radio<bool>(
                        value: true,
                        groupValue: _isScheduleSameForAllDays,
                        onChanged: (value) {
                          setState(() {
                            _isScheduleSameForAllDays = value!;
                          });
                        },
                        activeColor: const Color(0xFF007BFF),
                      ),
                      const Text('Yes'),
                      const SizedBox(width: 16),
                      Radio<bool>(
                        value: false,
                        groupValue: _isScheduleSameForAllDays,
                        onChanged: (value) {
                          setState(() {
                            _isScheduleSameForAllDays = value!;
                          });
                        },
                        activeColor: const Color(0xFF007BFF),
                      ),
                      const Text('No'),
                    ],
                  ),
                ],
              );
            } else {
              // Normal layout - horizontal
              return Row(
                children: [
                  Text(
                    'Is Schedule Same For All Days?',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Row(
                    children: [
                      Radio<bool>(
                        value: true,
                        groupValue: _isScheduleSameForAllDays,
                        onChanged: (value) {
                          setState(() {
                            _isScheduleSameForAllDays = value!;
                          });
                        },
                        activeColor: const Color(0xFF007BFF),
                      ),
                      const Text('Yes'),
                      const SizedBox(width: 16),
                      Radio<bool>(
                        value: false,
                        groupValue: _isScheduleSameForAllDays,
                        onChanged: (value) {
                          setState(() {
                            _isScheduleSameForAllDays = value!;
                          });
                        },
                        activeColor: const Color(0xFF007BFF),
                      ),
                      const Text('No'),
                    ],
                  ),
                ],
              );
            }
          },
        ),
        const SizedBox(height: 16),
        _buildScheduleTable(),
      ],
    );
  }

  Widget _buildScheduleTable() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          // Mobile layout - vertical cards
          return Column(
            children: List.generate(_noOfDays, (index) {
              return _buildMobileScheduleCard(index);
            }),
          );
        } else {
          // Tablet/Desktop layout - table
          return Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(flex: 1, child: _buildTableHeader('Day')),
                      Expanded(flex: 2, child: _buildTableHeader('Date')),
                      Expanded(flex: 2, child: _buildTableHeader('Sport Type')),
                      Expanded(flex: 2, child: _buildTableHeader('Start Time')),
                      Expanded(flex: 2, child: _buildTableHeader('End Time')),
                      Expanded(flex: 3, child: _buildTableHeader('Venue')),
                    ],
                  ),
                ),
                // Rows
                ...List.generate(_noOfDays, (index) {
                  return _buildScheduleRow(index);
                }),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildTableHeader(String text) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildMobileScheduleCard(int index) {
    final data = _scheduleData[index];
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Day ${data['day']}',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF007BFF),
                ),
              ),
              Text(
                data['date'],
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildMobileFormField(
            'Sport Type',
            DropdownButton<String>(
              value: data['sportType'].isEmpty ? null : data['sportType'],
              hint: Text(
                'Select Sport',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              isExpanded: true,
              underline: Container(),
              items: _availableSports.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: GoogleFonts.poppins(fontSize: 14)),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _scheduleData[index]['sportType'] = newValue ?? '';
                });
              },
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildMobileFormField(
                  'Start Time',
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'HH',
                            hintStyle: GoogleFonts.poppins(fontSize: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 8,
                            ),
                          ),
                          style: GoogleFonts.poppins(fontSize: 14),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'MM',
                            hintStyle: GoogleFonts.poppins(fontSize: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 8,
                            ),
                          ),
                          style: GoogleFonts.poppins(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMobileFormField(
                  'End Time',
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'HH',
                            hintStyle: GoogleFonts.poppins(fontSize: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 8,
                            ),
                          ),
                          style: GoogleFonts.poppins(fontSize: 14),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'MM',
                            hintStyle: GoogleFonts.poppins(fontSize: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 8,
                            ),
                          ),
                          style: GoogleFonts.poppins(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildMobileFormField(
            'Venue',
            DropdownButton<String>(
              value: data['venue'].isEmpty ? null : data['venue'],
              hint: Text(
                'Select Venue',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              isExpanded: true,
              underline: Container(),
              items:
                  [
                    'Club 1 > Court 1',
                    'Club 1 > Court 2',
                    'Club 2 > Court 1',
                    'Club 2 > Court 2',
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: GoogleFonts.poppins(fontSize: 14),
                      ),
                    );
                  }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _scheduleData[index]['venue'] = newValue ?? '';
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileFormField(String label, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 4),
        child,
      ],
    );
  }

  Widget _buildScheduleRow(int index) {
    final data = _scheduleData[index];
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              'Day ${data['day']}',
              style: GoogleFonts.poppins(fontSize: 12),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(data['date'], style: GoogleFonts.poppins(fontSize: 12)),
          ),
          Expanded(
            flex: 2,
            child: DropdownButton<String>(
              value: data['sportType'].isEmpty ? null : data['sportType'],
              hint: Text(
                'Select',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              isExpanded: true,
              underline: Container(),
              items: _availableSports.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: GoogleFonts.poppins(fontSize: 12)),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _scheduleData[index]['sportType'] = newValue ?? '';
                });
              },
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'HH',
                      hintStyle: GoogleFonts.poppins(fontSize: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                    ),
                    style: GoogleFonts.poppins(fontSize: 12),
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'MM',
                      hintStyle: GoogleFonts.poppins(fontSize: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                    ),
                    style: GoogleFonts.poppins(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'HH',
                      hintStyle: GoogleFonts.poppins(fontSize: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                    ),
                    style: GoogleFonts.poppins(fontSize: 12),
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'MM',
                      hintStyle: GoogleFonts.poppins(fontSize: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                    ),
                    style: GoogleFonts.poppins(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: DropdownButton<String>(
              value: data['venue'].isEmpty ? null : data['venue'],
              hint: Text(
                'Select Venue',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              isExpanded: true,
              underline: Container(),
              items:
                  [
                    'Club 1 > Court 1',
                    'Club 1 > Court 2',
                    'Club 2 > Court 1',
                    'Club 2 > Court 2',
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: GoogleFonts.poppins(fontSize: 12),
                      ),
                    );
                  }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _scheduleData[index]['venue'] = newValue ?? '';
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceRequirementsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Attendance Requirements'),
        const SizedBox(height: 16),

        // Is Attendees Information Same For All Sport Types?
        _buildRadioSection(
          'Is Attendees Information Same For All Sport Types?',
          _isAttendeesInfoSame,
          (value) => setState(() => _isAttendeesInfoSame = value!),
        ),
        const SizedBox(height: 24),

        // Sport-specific tabs (only shown when "No" is selected)
        if (!_isAttendeesInfoSame) ...[
          _buildSportTabs(),
          const SizedBox(height: 16),
        ],

        // Attendees Information Section
        _buildAttendeesInformationSection(),
        const SizedBox(height: 24),

        // Organizer Information Section
        _buildOrganizerInformationSection(),
        const SizedBox(height: 24),

        // Is Sponsorship Applicable?
        _buildRadioSection(
          'Is Sponsorship Applicable?',
          _isSponsorshipApplicable,
          (value) => setState(() => _isSponsorshipApplicable = value!),
        ),
        const SizedBox(height: 16),

        // Sponsorship Categories
        if (_isSponsorshipApplicable) ...[
          _buildSponsorshipCategoriesSection(),
          const SizedBox(height: 16),
          _buildSponsorshipTypeSection(),
        ],
      ],
    );
  }

  Widget _buildRadioSection(
    String title,
    bool value,
    ValueChanged<bool?> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Radio<bool>(
              value: true,
              groupValue: value,
              onChanged: onChanged,
              activeColor: const Color(0xFF007BFF),
            ),
            const Text('Yes'),
            const SizedBox(width: 24),
            Radio<bool>(
              value: false,
              groupValue: value,
              onChanged: onChanged,
              activeColor: const Color(0xFF007BFF),
            ),
            const Text('No'),
          ],
        ),
      ],
    );
  }

  Widget _buildSportTabs() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // Tab buttons
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _sportTypes.asMap().entries.map((entry) {
                  int index = entry.key;
                  String sport = entry.value;
                  bool isSelected = _selectedSportTab == index;

                  return GestureDetector(
                    onTap: () => setState(() => _selectedSportTab = index),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF007BFF)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        sport,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isSelected ? Colors.white : Colors.grey[600],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          // Tab content
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
            child: Text(
              'Configure attendance for ${_sportTypes[_selectedSportTab]}',
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }

  String _getCurrentValue(String key) {
    if (_isAttendeesInfoSame) {
      switch (key) {
        case 'maxTeams':
          return _maxTeams;
        case 'playersPerTeam':
          return _playersPerTeam;
        case 'coachPerTeam':
          return _coachPerTeam;
        case 'gender':
          return _gender;
        case 'ageGroup':
          return _ageGroup;
        case 'maxSpectators':
          return _maxSpectators;
        default:
          return '';
      }
    } else {
      return _sportSpecificData[_sportTypes[_selectedSportTab]]?[key] ?? '';
    }
  }

  void _updateCurrentValue(String key, String value) {
    setState(() {
      if (_isAttendeesInfoSame) {
        switch (key) {
          case 'maxTeams':
            _maxTeams = value;
            break;
          case 'playersPerTeam':
            _playersPerTeam = value;
            break;
          case 'coachPerTeam':
            _coachPerTeam = value;
            break;
          case 'gender':
            _gender = value;
            break;
          case 'ageGroup':
            _ageGroup = value;
            break;
          case 'maxSpectators':
            _maxSpectators = value;
            break;
        }
      } else {
        _sportSpecificData[_sportTypes[_selectedSportTab]]?[key] = value;
      }
    });
  }

  Widget _buildAttendeesInformationSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _isAttendeesInfoSame
                ? 'Attendees Information'
                : 'Attendees Information - ${_sportTypes[_selectedSportTab]}',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 600) {
                // Mobile layout - single column
                return Column(
                  children: [
                    _buildDropdownField(
                      'Max Teams',
                      _getCurrentValue('maxTeams'),
                      ['2', '4', '6', '8', '10'],
                      (value) => _updateCurrentValue('maxTeams', value!),
                    ),
                    const SizedBox(height: 12),
                    _buildDropdownField(
                      'Players/Team',
                      _getCurrentValue('playersPerTeam'),
                      ['20', '30', '40', '50', '60'],
                      (value) => _updateCurrentValue('playersPerTeam', value!),
                    ),
                    const SizedBox(height: 12),
                    _buildDropdownField(
                      'Coach/Team',
                      _getCurrentValue('coachPerTeam'),
                      ['4', '6', '8', '10', '12'],
                      (value) => _updateCurrentValue('coachPerTeam', value!),
                    ),
                    const SizedBox(height: 12),
                    _buildDropdownField(
                      'Gender',
                      _getCurrentValue('gender'),
                      ['All', 'Male', 'Female', 'Mixed'],
                      (value) => _updateCurrentValue('gender', value!),
                    ),
                    const SizedBox(height: 12),
                    _buildDropdownField(
                      'Age Group',
                      _getCurrentValue('ageGroup'),
                      ['18-24', '25-35', '36-45', '46-55', '55+'],
                      (value) => _updateCurrentValue('ageGroup', value!),
                    ),
                    const SizedBox(height: 12),
                    _buildDropdownField(
                      'Max Spectators',
                      _getCurrentValue('maxSpectators'),
                      ['50', '100', '150', '200', '250'],
                      (value) => _updateCurrentValue('maxSpectators', value!),
                    ),
                  ],
                );
              } else {
                // Tablet layout - two columns
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildDropdownField(
                            'Max Teams',
                            _getCurrentValue('maxTeams'),
                            ['2', '4', '6', '8', '10'],
                            (value) => _updateCurrentValue('maxTeams', value!),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildDropdownField(
                            'Players/Team',
                            _getCurrentValue('playersPerTeam'),
                            ['20', '30', '40', '50', '60'],
                            (value) =>
                                _updateCurrentValue('playersPerTeam', value!),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildDropdownField(
                            'Coach/Team',
                            _getCurrentValue('coachPerTeam'),
                            ['4', '6', '8', '10', '12'],
                            (value) =>
                                _updateCurrentValue('coachPerTeam', value!),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildDropdownField(
                            'Gender',
                            _getCurrentValue('gender'),
                            ['All', 'Male', 'Female', 'Mixed'],
                            (value) => _updateCurrentValue('gender', value!),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildDropdownField(
                            'Age Group',
                            _getCurrentValue('ageGroup'),
                            ['18-24', '25-35', '36-45', '46-55', '55+'],
                            (value) => _updateCurrentValue('ageGroup', value!),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildDropdownField(
                            'Max Spectators',
                            _getCurrentValue('maxSpectators'),
                            ['50', '100', '150', '200', '250'],
                            (value) =>
                                _updateCurrentValue('maxSpectators', value!),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField(
    String label,
    String value,
    List<String> items,
    ValueChanged<String?> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF007BFF)),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item, style: GoogleFonts.poppins(fontSize: 14)),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildOrganizerInformationSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Organizer Information',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 600) {
                // Mobile layout - single column
                return Column(
                  children: [
                    _buildFormField(
                      controller: _organizerFirstNameController,
                      label: 'First Name',
                      hint: 'First Name',
                    ),
                    const SizedBox(height: 12),
                    _buildFormField(
                      controller: _organizerLastNameController,
                      label: 'Last Name',
                      hint: 'Last Name',
                    ),
                    const SizedBox(height: 12),
                    _buildFormField(
                      controller: _organizerContactController,
                      label: 'Contact Number',
                      hint: '1234567890',
                    ),
                    const SizedBox(height: 12),
                    _buildFormField(
                      controller: _organizerEmailController,
                      label: 'Contact Email',
                      hint: 'Aaa@Gmail.Com',
                    ),
                    const SizedBox(height: 12),
                    _buildFormField(
                      controller: _organizerWebsiteController,
                      label: 'Ticket Website',
                      hint: 'Abc.com',
                    ),
                  ],
                );
              } else {
                // Tablet layout - two columns
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildFormField(
                            controller: _organizerFirstNameController,
                            label: 'First Name',
                            hint: 'First Name',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildFormField(
                            controller: _organizerLastNameController,
                            label: 'Last Name',
                            hint: 'Last Name',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildFormField(
                      controller: _organizerContactController,
                      label: 'Contact Number',
                      hint: '1234567890',
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildFormField(
                            controller: _organizerEmailController,
                            label: 'Contact Email',
                            hint: 'Aaa@Gmail.Com',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildFormField(
                            controller: _organizerWebsiteController,
                            label: 'Ticket Website',
                            hint: 'Abc.com',
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSponsorshipCategoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sponsorship Categories',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: [
            _buildCheckboxTile(
              'Corporate',
              _corporateSponsorship,
              (value) => setState(() => _corporateSponsorship = value!),
            ),
            _buildCheckboxTile(
              'Merchandise',
              _merchandiseSponsorship,
              (value) => setState(() => _merchandiseSponsorship = value!),
            ),
            _buildCheckboxTile(
              'Coach',
              _coachSponsorship,
              (value) => setState(() => _coachSponsorship = value!),
            ),
            _buildCheckboxTile(
              'Members',
              _membersSponsorship,
              (value) => setState(() => _membersSponsorship = value!),
            ),
            _buildCheckboxTile(
              'Freelancers',
              _freelancersSponsorship,
              (value) => setState(() => _freelancersSponsorship = value!),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCheckboxTile(
    String title,
    bool value,
    ValueChanged<bool?> onChanged,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFF007BFF),
        ),
        Text(title, style: GoogleFonts.poppins(fontSize: 14)),
      ],
    );
  }

  Widget _buildSponsorshipTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Sponsorship Type',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            ElevatedButton.icon(
              onPressed: _addSponsorshipType,
              icon: const Icon(Icons.add, size: 16),
              label: Text(
                'Add Sponsorship Type',
                style: GoogleFonts.poppins(fontSize: 12),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF007BFF),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildSponsorshipTable('Club 1 Sponsorship', _club1Sponsorships),
        const SizedBox(height: 16),
        _buildSponsorshipTable('Club 2 Sponsorship', _club2Sponsorships),
        const SizedBox(height: 16),
        _buildSponsorshipTable(
          'Tournament Specific Sponsorship',
          _tournamentSponsorships,
        ),
      ],
    );
  }

  Widget _buildSponsorshipTable(String title, List<Map<String, dynamic>> data) {
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
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth < 600) {
                      // Mobile layout - simplified header
                      return Row(
                        children: [
                          Expanded(flex: 2, child: _buildTableHeader('Type')),
                          Expanded(flex: 2, child: _buildTableHeader('Role')),
                          Expanded(flex: 1, child: _buildTableHeader('Action')),
                        ],
                      );
                    } else {
                      // Tablet layout - full header
                      return Row(
                        children: [
                          Expanded(flex: 1, child: _buildTableHeader('Action')),
                          Expanded(flex: 2, child: _buildTableHeader('Type')),
                          Expanded(flex: 2, child: _buildTableHeader('Role')),
                          Expanded(
                            flex: 1,
                            child: _buildTableHeader('Per Day'),
                          ),
                          Expanded(
                            flex: 1,
                            child: _buildTableHeader('Per Week'),
                          ),
                          Expanded(
                            flex: 1,
                            child: _buildTableHeader('Per Month'),
                          ),
                          Expanded(
                            flex: 1,
                            child: _buildTableHeader('Per Year'),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
              // Rows
              ...data.asMap().entries.map((entry) {
                return _buildSponsorshipRow(entry.key, entry.value, data);
              }).toList(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSponsorshipRow(
    int index,
    Map<String, dynamic> data,
    List<Map<String, dynamic>> list,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            // Mobile layout - card style
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: DropdownButton<String>(
                        value: data['type'],
                        isExpanded: true,
                        underline: Container(),
                        items:
                            [
                              'Bill Board',
                              'Digital Ad',
                              'Uniform',
                              'Video Play',
                            ].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: GoogleFonts.poppins(fontSize: 12),
                                ),
                              );
                            }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            data['type'] = newValue ?? data['type'];
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DropdownButton<String>(
                        value: data['role'],
                        isExpanded: true,
                        underline: Container(),
                        items:
                            [
                              'Corporate',
                              'Merchandise',
                              'Coach',
                              'Members',
                              'Freelancer',
                            ].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: GoogleFonts.poppins(fontSize: 12),
                                ),
                              );
                            }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            data['role'] = newValue ?? data['role'];
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () => _removeSponsorshipRow(list, index),
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                        size: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'USD ${data['perDay']} per day/week/month/year',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            );
          } else {
            // Tablet layout - table style
            return Row(
              children: [
                Expanded(
                  flex: 1,
                  child: IconButton(
                    onPressed: () => _removeSponsorshipRow(list, index),
                    icon: const Icon(Icons.delete, color: Colors.red, size: 16),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: DropdownButton<String>(
                    value: data['type'],
                    isExpanded: true,
                    underline: Container(),
                    items: ['Bill Board', 'Digital Ad', 'Uniform', 'Video Play']
                        .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: GoogleFonts.poppins(fontSize: 12),
                            ),
                          );
                        })
                        .toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        data['type'] = newValue ?? data['type'];
                      });
                    },
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: DropdownButton<String>(
                    value: data['role'],
                    isExpanded: true,
                    underline: Container(),
                    items:
                        [
                          'Corporate',
                          'Merchandise',
                          'Coach',
                          'Members',
                          'Freelancer',
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: GoogleFonts.poppins(fontSize: 12),
                            ),
                          );
                        }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        data['role'] = newValue ?? data['role'];
                      });
                    },
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: TextField(
                    controller: TextEditingController(text: data['perDay']),
                    decoration: InputDecoration(
                      hintText: '100',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                    ),
                    style: GoogleFonts.poppins(fontSize: 12),
                    onChanged: (value) => data['perDay'] = value,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: TextField(
                    controller: TextEditingController(text: data['perWeek']),
                    decoration: InputDecoration(
                      hintText: '100',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                    ),
                    style: GoogleFonts.poppins(fontSize: 12),
                    onChanged: (value) => data['perWeek'] = value,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: TextField(
                    controller: TextEditingController(text: data['perMonth']),
                    decoration: InputDecoration(
                      hintText: '100',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                    ),
                    style: GoogleFonts.poppins(fontSize: 12),
                    onChanged: (value) => data['perMonth'] = value,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: TextField(
                    controller: TextEditingController(text: data['perYear']),
                    decoration: InputDecoration(
                      hintText: '100',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                    ),
                    style: GoogleFonts.poppins(fontSize: 12),
                    onChanged: (value) => data['perYear'] = value,
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  void _addSponsorshipType() {
    setState(() {
      _club1Sponsorships.add({
        'type': 'Bill Board',
        'role': 'Corporate',
        'perDay': '100',
        'perWeek': '100',
        'perMonth': '100',
        'perYear': '100',
      });
    });
  }

  void _removeSponsorshipRow(List<Map<String, dynamic>> list, int index) {
    setState(() {
      list.removeAt(index);
    });
  }

  Widget _buildSubscriptionRequestsTab() {
    return Center(
      child: Text(
        'Subscription Requests Tab\n(Coming Soon)',
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[600]),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    bool readOnly = false,
    Widget? suffixIcon,
    VoidCallback? onTap,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          readOnly: readOnly,
          onTap: onTap,
          validator: validator,
          style: GoogleFonts.poppins(fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            suffixIcon: suffixIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF007BFF), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            filled: true,
            fillColor: readOnly ? Colors.grey[100] : Colors.white,
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      final months = [
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
      final formattedDate =
          '${weekdays[picked.weekday - 1]}, ${months[picked.month - 1]} ${picked.day}, ${picked.year}';
      controller.text = formattedDate;
    }
  }

  void _selectNumberOfDays() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Number of Days', style: GoogleFonts.poppins()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(7, (index) {
            final days = index + 1;
            return ListTile(
              title: Text(
                '$days Day${days > 1 ? 's' : ''}',
                style: GoogleFonts.poppins(),
              ),
              onTap: () {
                setState(() {
                  _noOfDays = days;
                  _noOfDaysController.text = days.toString();
                  _initializeScheduleData();
                });
                Navigator.pop(context);
              },
            );
          }),
        ),
      ),
    );
  }

  void _saveEvent() {
    if (_formKey.currentState?.validate() ?? false) {
      // Save event logic
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Event saved successfully!',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _eventNameController.dispose();
    _eventDescriptionController.dispose();
    _firstPrizeController.dispose();
    _secondPrizeController.dispose();
    _thirdPrizeController.dispose();
    _promotionalImageController.dispose();
    _registrationStartController.dispose();
    _registrationEndController.dispose();
    _attendeeChargeController.dispose();
    _coachChargeController.dispose();
    _playerChargeController.dispose();
    _teamChargeController.dispose();
    _rulesController.dispose();
    _noOfDaysController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _organizerFirstNameController.dispose();
    _organizerLastNameController.dispose();
    _organizerContactController.dispose();
    _organizerEmailController.dispose();
    _organizerWebsiteController.dispose();
    super.dispose();
  }
}
