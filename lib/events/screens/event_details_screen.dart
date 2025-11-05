import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../role_specific/common/role_router.dart';

class EventDetailsScreen extends StatefulWidget {
  final String eventName;
  final String venue;
  final String location;
  final double rating;
  final List<String> availableSports;
  final String eventDate;
  final String registrationDate;
  final String organizerName;
  final String organizerEmail;
  final bool isSubscribed;
  final UserRole? role;

  // Additional event details for comprehensive view
  final String eventDescription;
  final String firstPrize;
  final String secondPrize;
  final String thirdPrize;
  final String promotionalImageUrl;
  final String registrationStartDate;
  final String registrationEndDate;
  final Map<String, String> registrationCharges;
  final String rulesAndRegulations;
  final int numberOfDays;
  final String startDate;
  final String endDate;
  final bool isScheduleSameForAllDays;
  final List<Map<String, dynamic>> eventSchedule;

  const EventDetailsScreen({
    Key? key,
    required this.eventName,
    required this.venue,
    required this.location,
    required this.rating,
    required this.availableSports,
    required this.eventDate,
    required this.registrationDate,
    required this.organizerName,
    required this.organizerEmail,
    required this.isSubscribed,
    this.role,
    this.eventDescription =
        'Lorem Ipsum Dolor Sit Amet Consectetur. Ac Quam Cras A Elit. Quis Odio Scelerisque Lacus Pellentesque Vel Sit Tristique Habitant Lacus. In Et Faucibus Pellentesque Commodo Suscipit. Blandit Leo Netus Sed At.',
    this.firstPrize = 'Input Text',
    this.secondPrize = 'Input Text',
    this.thirdPrize = 'Input Text',
    this.promotionalImageUrl = 'assets/images/sport_banner.jpg',
    this.registrationStartDate = 'Wed, March 05, 2025',
    this.registrationEndDate = 'Wed, March 05, 2025',
    this.registrationCharges = const {
      'Attendee': '100',
      'Coach': '200',
      'Player': '150',
      'Team': '1000',
    },
    this.rulesAndRegulations =
        'Lorem Ipsum Dolor Sit Amet Consectetur. Sodales Quam Blandit Nisl Diam Adipiscing Consectetur Nibh Elit. Quis Proin Tristique Adipiscing Pellentesque. Faucibus Cras Nec Platea Donec Facilisi. Elementum Aliquam Purus Amet Gravida.',
    this.numberOfDays = 3,
    this.startDate = 'Wed, March 05, 2025',
    this.endDate = 'Wed, March 05, 2025',
    this.isScheduleSameForAllDays = true,
    this.eventSchedule = const [],
  }) : super(key: key);

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen>
    with TickerProviderStateMixin {
  String selectedSport = 'Cricket';
  bool isFavourite = false;
  late TabController _tabController;

  final List<String> sports = [
    'Cricket',
    'Basketball',
    'Tennis',
    'Carom',
    'Chess',
  ];

  // Form controllers
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _eventDescriptionController =
      TextEditingController();
  final TextEditingController _firstPrizeController = TextEditingController();
  final TextEditingController _secondPrizeController = TextEditingController();
  final TextEditingController _thirdPrizeController = TextEditingController();
  final TextEditingController _rulesController = TextEditingController();
  final TextEditingController _noOfDaysController = TextEditingController();
  final TextEditingController _attendeeChargeController =
      TextEditingController();
  final TextEditingController _coachChargeController = TextEditingController();
  final TextEditingController _playerChargeController = TextEditingController();
  final TextEditingController _teamChargeController = TextEditingController();

  // Form state
  String _selectedCurrency = 'USD';
  String _selectedStartDate = 'Wed, March 05, 2025';
  String _selectedEndDate = 'Wed, March 05, 2025';
  bool _isScheduleSameForAllDays = true;
  List<String> _selectedSports = ['Cricket', 'Football'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Initialize form data
    _eventNameController.text = widget.eventName;
    _eventDescriptionController.text = widget.eventDescription;
    _firstPrizeController.text = widget.firstPrize;
    _secondPrizeController.text = widget.secondPrize;
    _thirdPrizeController.text = widget.thirdPrize;
    _rulesController.text = widget.rulesAndRegulations;
    _noOfDaysController.text = widget.numberOfDays.toString();
    _attendeeChargeController.text =
        widget.registrationCharges['Attendee'] ?? '100';
    _coachChargeController.text = widget.registrationCharges['Coach'] ?? '200';
    _playerChargeController.text =
        widget.registrationCharges['Player'] ?? '150';
    _teamChargeController.text = widget.registrationCharges['Team'] ?? '1000';
  }

  @override
  void dispose() {
    _tabController.dispose();
    _eventNameController.dispose();
    _eventDescriptionController.dispose();
    _firstPrizeController.dispose();
    _secondPrizeController.dispose();
    _thirdPrizeController.dispose();
    _rulesController.dispose();
    _noOfDaysController.dispose();
    _attendeeChargeController.dispose();
    _coachChargeController.dispose();
    _playerChargeController.dispose();
    _teamChargeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Event Details',
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          tabs: const [
            Tab(text: 'Event Details'),
            Tab(text: 'Attendance Requirements'),
            Tab(text: 'Subscription Requests'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildEventDetailsTab(),
          _buildAttendanceRequirementsTab(),
          _buildSubscriptionRequestsTab(),
        ],
      ),
    );
  }

  Widget _buildEventDetailsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Event Name Section
          _buildFormField('Event Name', _eventNameController),
          const SizedBox(height: 16),

          // Event Description Section
          _buildFormField(
            'Event Description',
            _eventDescriptionController,
            maxLines: 3,
          ),
          const SizedBox(height: 16),

          // Trophy Section
          _buildTrophySection(),
          const SizedBox(height: 16),

          // Sports Type Section
          _buildSportsTypeSection(),
          const SizedBox(height: 16),

          // Event Promotional Image Section
          _buildPromotionalImageSection(),
          const SizedBox(height: 16),

          // Registration Dates Section
          _buildRegistrationDatesSection(),
          const SizedBox(height: 16),

          // Registration Charges Section
          _buildRegistrationChargesSection(),
          const SizedBox(height: 16),

          // Rules & Regulations Section
          _buildRulesAndRegulationsSection(),
          const SizedBox(height: 16),

          // Event Schedule Section
          _buildEventScheduleSection(),
          const SizedBox(height: 16),

          // Save Button
          _buildSaveButton(),
        ],
      ),
    );
  }

  Widget _buildAttendanceRequirementsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quick Actions Section
          _buildQuickActionsSection(),
          const SizedBox(height: 24),

          // Attendance Requirements Section
          _buildAttendanceRequirementsSection(),
        ],
      ),
    );
  }

  Widget _buildSubscriptionRequestsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Subscription Requests',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Manage subscription requests for this event.',
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),
          // Add subscription requests content here
          _buildPlaceholderCard('Pending Requests', '12'),
          const SizedBox(height: 12),
          _buildPlaceholderCard('Approved Requests', '45'),
          const SizedBox(height: 12),
          _buildPlaceholderCard('Rejected Requests', '3'),
        ],
      ),
    );
  }

  Widget _buildFormField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
  }) {
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
            decoration: InputDecoration(
              hintText: 'Input Text',
              hintStyle: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[400],
              ),
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
              filled: true,
              fillColor: Colors.grey[50],
            ),
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader(String text) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildQuickActionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 400) {
              // Mobile layout - single column
              return Column(
                children: [
                  _buildQuickActionButton('Event Details', Icons.event, false),
                  const SizedBox(height: 12),
                  _buildQuickActionButton(
                    'Attendance Require...',
                    Icons.people,
                    true,
                  ),
                  const SizedBox(height: 12),
                  _buildQuickActionButton(
                    'Subscription Request',
                    Icons.subscriptions,
                    false,
                  ),
                  const SizedBox(height: 12),
                  _buildQuickActionButton('FAQ', Icons.help_outline, false),
                ],
              );
            } else {
              // Tablet layout - 2x2 grid
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildQuickActionButton(
                          'Event Details',
                          Icons.event,
                          false,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildQuickActionButton(
                          'Attendance Require...',
                          Icons.people,
                          true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildQuickActionButton(
                          'Subscription Request',
                          Icons.subscriptions,
                          false,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildQuickActionButton(
                          'FAQ',
                          Icons.help_outline,
                          false,
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
    );
  }

  Widget _buildQuickActionButton(String title, IconData icon, bool isSelected) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF007BFF) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? const Color(0xFF007BFF) : Colors.grey[300]!,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            // Handle quick action tap
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('$title tapped', style: GoogleFonts.poppins()),
                backgroundColor: Colors.blue,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: isSelected ? Colors.white : const Color(0xFF007BFF),
                  size: 24,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? Colors.white : Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAttendanceRequirementsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
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
          Text(
            'Attendance Requirement',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Attendance Requirements:',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          _buildRequirementItem(
            'Minimum 80% attendance required for all participants',
          ),
          _buildRequirementItem('Absence must be reported 24 hours in advance'),
          _buildRequirementItem(
            'Medical certificates required for extended absences',
          ),
          _buildRequirementItem(
            'Late arrivals will be marked as partial attendance',
          ),
        ],
      ),
    );
  }

  Widget _buildRequirementItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(top: 6, right: 12),
            decoration: const BoxDecoration(
              color: Color(0xFF007BFF),
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return Container(
      width: double.infinity,
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFF007BFF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Event details saved successfully!',
                style: GoogleFonts.poppins(),
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        },
        child: Text(
          'Save Event Details',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildTrophySection() {
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
            'Trophy',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 600) {
                // Mobile layout - single column
                return Column(
                  children: [
                    _buildTrophyField('1st Prize', _firstPrizeController),
                    const SizedBox(height: 12),
                    _buildTrophyField('2nd Prize', _secondPrizeController),
                    const SizedBox(height: 12),
                    _buildTrophyField('3rd Prize', _thirdPrizeController),
                  ],
                );
              } else {
                // Tablet layout - three columns
                return Row(
                  children: [
                    Expanded(
                      child: _buildTrophyField(
                        '1st Prize',
                        _firstPrizeController,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTrophyField(
                        '2nd Prize',
                        _secondPrizeController,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTrophyField(
                        '3rd Prize',
                        _thirdPrizeController,
                      ),
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

  Widget _buildTrophyField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Input Text',
            hintStyle: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[400],
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(color: Color(0xFF007BFF)),
            ),
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
          ),
          style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
        ),
      ],
    );
  }

  Widget _buildSportsTypeSection() {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Sports Type',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              Icon(Icons.search, color: Colors.grey[600], size: 20),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: sports.map((sport) {
              bool isSelected = _selectedSports.contains(sport);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedSports.remove(sport);
                    } else {
                      _selectedSports.add(sport);
                    }
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF007BFF)
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF007BFF)
                          : Colors.grey[300]!,
                    ),
                  ),
                  child: Text(
                    sport,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPromotionalImageSection() {
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
            'Event Promotional Image',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFFE5B4), Color(0xFFE6E6FA)],
              ),
            ),
            child: Stack(
              children: [
                // Sports equipment icons
                Positioned(
                  top: 20,
                  left: 20,
                  child: Icon(
                    Icons.sports_tennis,
                    size: 30,
                    color: Colors.orange[700],
                  ),
                ),
                Positioned(
                  top: 40,
                  right: 30,
                  child: Icon(
                    Icons.sports_volleyball,
                    size: 25,
                    color: Colors.blue[700],
                  ),
                ),
                Positioned(
                  bottom: 40,
                  left: 30,
                  child: Icon(
                    Icons.fitness_center,
                    size: 28,
                    color: Colors.green[700],
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: Icon(
                    Icons.sports,
                    size: 24,
                    color: Colors.purple[700],
                  ),
                ),
                // Text content
                Positioned(
                  top: 60,
                  left: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SPORT CLUB',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Get 10 days of\nThe Free Trial',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '50% OFF',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Learn More button
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue[700],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Learn More',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
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

  Widget _buildRegistrationDatesSection() {
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
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 600) {
                // Mobile layout - single column
                return Column(
                  children: [
                    _buildDateField(
                      'Registration Start Date',
                      widget.registrationStartDate,
                    ),
                    const SizedBox(height: 12),
                    _buildDateField(
                      'Registration End Date',
                      widget.registrationEndDate,
                    ),
                  ],
                );
              } else {
                // Tablet layout - two columns
                return Row(
                  children: [
                    Expanded(
                      child: _buildDateField(
                        'Registration Start Date',
                        widget.registrationStartDate,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildDateField(
                        'Registration End Date',
                        widget.registrationEndDate,
                      ),
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

  Widget _buildDateField(String label, String value) {
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
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey[50],
          ),
          child: Row(
            children: [
              Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 8),
              Text(
                value,
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRegistrationChargesSection() {
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
            'Registration Charges',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Additional XX% Platform Fee Will Be Charged On The Top Of Below Registration Charges.',
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
          ),
          const SizedBox(height: 16),
          _buildChargeRow('Attendee', _attendeeChargeController),
          const SizedBox(height: 12),
          _buildChargeRow('Coach', _coachChargeController),
          const SizedBox(height: 12),
          _buildChargeRow('Player', _playerChargeController),
          const SizedBox(height: 12),
          _buildChargeRow('Team', _teamChargeController),
        ],
      ),
    );
  }

  Widget _buildChargeRow(String label, TextEditingController controller) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 400) {
          // Mobile layout - stack vertically
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
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.grey[50],
                    ),
                    child: Text(
                      _selectedCurrency,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: controller,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: '0',
                        hintStyle: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey[400],
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: const BorderSide(
                            color: Color(0xFF007BFF),
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        } else {
          // Tablet layout - horizontal
          return Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.grey[50],
                ),
                child: Text(
                  _selectedCurrency,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 1,
                child: TextFormField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: '0',
                    hintStyle: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[400],
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: const BorderSide(color: Color(0xFF007BFF)),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildRulesAndRegulationsSection() {
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
            'Rules & Regulations',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _rulesController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Enter rules and regulations...',
              hintStyle: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[400],
              ),
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
              filled: true,
              fillColor: Colors.grey[50],
            ),
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.black87,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventScheduleSection() {
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
            'Event Schedule',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
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
                    _buildScheduleField('No. Of Days', _noOfDaysController),
                    const SizedBox(height: 12),
                    _buildScheduleField('Start Date', _selectedStartDate),
                    const SizedBox(height: 12),
                    _buildScheduleField('End Date', _selectedEndDate),
                  ],
                );
              } else {
                // Tablet layout - three columns
                return Row(
                  children: [
                    Expanded(
                      child: _buildScheduleField(
                        'No. Of Days',
                        _noOfDaysController,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildScheduleField(
                        'Start Date',
                        _selectedStartDate,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildScheduleField('End Date', _selectedEndDate),
                    ),
                  ],
                );
              }
            },
          ),
          const SizedBox(height: 16),
          Text(
            'Is Schedule Same For All Days?',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
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
              const SizedBox(width: 24),
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
          const SizedBox(height: 16),
          _buildScheduleTable(),
        ],
      ),
    );
  }

  Widget _buildScheduleField(String label, dynamic value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        if (value is TextEditingController)
          TextFormField(
            controller: value,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: '0',
              hintStyle: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[400],
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: Color(0xFF007BFF)),
              ),
              filled: true,
              fillColor: Colors.grey[50],
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
            ),
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
          )
        else
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(4),
              color: Colors.grey[50],
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  value.toString(),
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildScheduleTable() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          // Mobile layout - use cards instead of table
          return Column(
            children: [
              _buildMobileScheduleCard(
                1,
                'Wed, March 05, 2025',
                'Cricket',
                'HH MM',
                'HH MM',
                'Club 1 > Court 1',
              ),
              const SizedBox(height: 8),
              _buildMobileScheduleCard(
                2,
                'Thu, March 06, 2025',
                '',
                '',
                '',
                '',
              ),
              const SizedBox(height: 8),
              _buildMobileScheduleCard(
                3,
                'Fri, March 07, 2025',
                'Football',
                'HH MM',
                'HH MM',
                'Club 1 > Court 2',
              ),
            ],
          );
        } else {
          // Tablet layout - use table
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
                      Expanded(flex: 1, child: _buildTableHeader('Start Time')),
                      Expanded(flex: 1, child: _buildTableHeader('End Time')),
                      Expanded(flex: 2, child: _buildTableHeader('Venue')),
                    ],
                  ),
                ),
                // Rows
                _buildScheduleRow(
                  1,
                  'Wed, March 05, 2025',
                  'Cricket',
                  'HH MM',
                  'HH MM',
                  'Club 1 > Court 1',
                ),
                _buildScheduleRow(2, 'Thu, March 06, 2025', '', '', '', ''),
                _buildScheduleRow(
                  3,
                  'Fri, March 07, 2025',
                  'Football',
                  'HH MM',
                  'HH MM',
                  'Club 1 > Court 2',
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildMobileScheduleCard(
    int day,
    String date,
    String sport,
    String startTime,
    String endTime,
    String venue,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF007BFF),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Day $day',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  date,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          if (sport.isNotEmpty) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.sports, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  sport,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ],
          if (startTime.isNotEmpty && endTime.isNotEmpty) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  '$startTime - $endTime',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
          if (venue.isNotEmpty) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    venue,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildScheduleRow(
    int day,
    String date,
    String sport,
    String startTime,
    String endTime,
    String venue,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text('$day', style: GoogleFonts.poppins(fontSize: 12)),
          ),
          Expanded(
            flex: 2,
            child: Text(date, style: GoogleFonts.poppins(fontSize: 12)),
          ),
          Expanded(
            flex: 2,
            child: Text(sport, style: GoogleFonts.poppins(fontSize: 12)),
          ),
          Expanded(
            flex: 1,
            child: Text(startTime, style: GoogleFonts.poppins(fontSize: 12)),
          ),
          Expanded(
            flex: 1,
            child: Text(endTime, style: GoogleFonts.poppins(fontSize: 12)),
          ),
          Expanded(
            flex: 2,
            child: Text(venue, style: GoogleFonts.poppins(fontSize: 12)),
          ),
        ],
      ),
    );
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
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case UserRole.corporate:
        return const LinearGradient(
          colors: [Color(0xFFf093fb), Color(0xFFf5576c)],
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
