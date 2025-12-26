import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:smart_sports/shared/widgets/role_sidebar.dart';
import 'package:smart_sports/role_specific/common/role_router.dart';
import 'package:smart_sports/shared/navigation/role_navigation_manager.dart';

class FreelancerTournamentDetailsPage extends StatefulWidget {
  final String tournamentName;
  final String venue;
  final String location;
  final double rating;
  final List<String> availableSports;
  final String eventDate;
  final String registrationDate;
  final String organizerName;
  final String organizerEmail;

  const FreelancerTournamentDetailsPage({
    super.key,
    required this.tournamentName,
    required this.venue,
    required this.location,
    required this.rating,
    required this.availableSports,
    required this.eventDate,
    required this.registrationDate,
    required this.organizerName,
    required this.organizerEmail,
  });

  @override
  State<FreelancerTournamentDetailsPage> createState() =>
      _FreelancerTournamentDetailsPageState();
}

class _FreelancerTournamentDetailsPageState
    extends State<FreelancerTournamentDetailsPage> {
  int _selectedButtonIndex = 0;
  Map<int, bool> _expandedFAQItems = {};
  final TextEditingController _questionController = TextEditingController();

  // Payment Details modal state
  String _userType = 'FREE USER';
  String _paymentType = '';
  double _netTotalAmount = 100.0;
  double _discountAmount = 0.0;
  double _referralDiscount = 0.0;
  double _grandTotal = 100.0;
  double _taxAmount = 10.0;
  double _totalIncludingTax = 110.0;
  
  // Payment Method modal state
  String _selectedPaymentMethod = 'CREDIT / DEBIT CARD';
  bool _isCreditCardExpanded = true;
  bool _isPayPalExpanded = false;
  bool _isZelleExpanded = false;
  final TextEditingController _nameOnCardController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  final List<Map<String, dynamic>> _navigationButtons = [
    {'title': 'Event Details', 'icon': Icons.event},
    {'title': 'Attendance Requirement', 'icon': Icons.people},
    {'title': 'Subscription Request', 'icon': Icons.subscriptions},
    {'title': 'FAQ', 'icon': Icons.help},
  ];

  @override
  void dispose() {
    _questionController.dispose();
    _nameOnCardController.dispose();
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tournament Details'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF007BFF), Color(0xFF0056CC)],
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
      ),
      drawer: Drawer(
        elevation: 0,
        child: SafeArea(
          child: RoleSidebar(
            role: UserRole.freelancer,
            selectedIndex: 5,
            edgeToEdge: true,
            onSelectIndex: (i) => RoleNavigationManager.navigateToScreen(
              context,
              UserRole.freelancer,
              i,
            ),
            onProfileTap: () async {
              Navigator.of(context).pop();
              await Future.delayed(const Duration(milliseconds: 160));
              RoleNavigationManager.navigateToProfile(
                context,
                UserRole.freelancer,
              );
            },
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Tournament Header Card
            _buildTournamentHeaderCard(),

            const SizedBox(height: 20),

            // Subscriptions Section
            _buildSubscriptionsSection(),

            const SizedBox(height: 20),

            // Navigation Buttons
            _buildNavigationButtons(),

            const SizedBox(height: 20),

            // Content based on selected button
            _buildContentSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildTournamentHeaderCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Background Image
            Container(
              height: 250,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
              ),
              child: Image.asset(
                'assets/images/pngtree-a-large-cricket-stadium-green-field-empty-picture-image_15985507.jpg',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.image, size: 50),
                  );
                },
              ),
            ),

            // Overlay Content
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.3),
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tournament Title and Favourite
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.tournamentName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
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
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.bookmark,
                                color: Colors.white,
                                size: 16,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Favourite',
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

                    const SizedBox(height: 16),

                    // Venue and Rating
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.venue,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    color: Colors.white70,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    widget.location,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Text(
                                widget.rating.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: List.generate(
                                  5,
                                  (index) => Icon(
                                    Icons.star,
                                    color: index < widget.rating.floor()
                                        ? Colors.yellow
                                        : Colors.white30,
                                    size: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Available Sports
                    const Text(
                      'AVAILABLE SPORTS',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: widget.availableSports.map((sport) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            sport,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubscriptionsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Subscriptions',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              IconButton(
                onPressed: () {
                  // Collapse/Expand functionality
                },
                icon: const Icon(Icons.keyboard_arrow_up, color: Colors.blue),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.blue.shade50,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.1,
            children: [
              _buildSubscriptionCard('Cricket', 180, 240, 10, 12, 20),
              _buildSubscriptionCard('Tennis', 180, 240, 10, 12, 20),
              _buildSubscriptionCard('Basketball', 180, 240, 10, 12, 20),
              _buildSubscriptionCard('Softball', 180, 240, 10, 12, 20),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionCard(
    String sport,
    int players,
    int maxPlayers,
    int sponsors,
    int coaches,
    int maxCoaches,
  ) {
    return Container(
      padding: const EdgeInsets.all(10),
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
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            sport,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),

          // Sponsors Section
          _buildSponsorsSection(sponsors),

          const SizedBox(height: 6),

          // Players Progress (Semi-circular)
          _buildPlayersProgressSection(players, maxPlayers),

          const SizedBox(height: 6),

          // Coaches and Teams Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _buildCircularProgressSection(
                  'Coach\'s',
                  coaches,
                  maxCoaches,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: _buildCircularProgressSection(
                  'Teams',
                  coaches,
                  maxCoaches,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSponsorsSection(int sponsorCount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Sponsors $sponsorCount',
          style: const TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w600,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 3),
        SizedBox(
          height: 20,
          child: Stack(
            children: List.generate(
              6,
              (index) => Positioned(
                left: index * 14.0,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade300,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 12,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlayersProgressSection(int current, int max) {
    final progress = current / max;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Players',
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w600,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 3),
        SizedBox(
          height: 50,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Semi-circular progress indicator
              CustomPaint(
                size: const Size(100, 50),
                painter: SemiCircleProgressPainter(
                  progress: progress,
                  color: Colors.blue,
                ),
              ),
              // Center text
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$current/$max',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const Text(
                      'Players',
                      style: TextStyle(
                        fontSize: 7,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCircularProgressSection(
    String title,
    int current,
    int max,
  ) {
    final progress = current / max;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 8,
            fontWeight: FontWeight.w600,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 3),
        Row(
          children: [
            SizedBox(
              width: 32,
              height: 32,
              child: Stack(
                children: [
                  CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 3,
                    backgroundColor: Colors.grey.shade300,
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                  Center(
                    child: Text(
                      '$current/$max',
                      style: const TextStyle(
                        fontSize: 7,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            // Mobile - wrap buttons
            return Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _navigationButtons.asMap().entries.map((entry) {
                final index = entry.key;
                final button = entry.value;
                final isSelected = _selectedButtonIndex == index;

                return InkWell(
                  onTap: () => setState(() => _selectedButtonIndex = index),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? Colors.blue : Colors.grey.shade300,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          button['icon'],
                          color: isSelected ? Colors.white : Colors.black87,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            button['title'],
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black87,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          } else {
            // Desktop - horizontal scroll
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _navigationButtons.asMap().entries.map((entry) {
                  final index = entry.key;
                  final button = entry.value;
                  final isSelected = _selectedButtonIndex == index;

                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: InkWell(
                      onTap: () => setState(() => _selectedButtonIndex = index),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.blue : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? Colors.blue : Colors.grey.shade300,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              button['icon'],
                              color: isSelected ? Colors.white : Colors.black87,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              button['title'],
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.black87,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildContentSection() {
    switch (_selectedButtonIndex) {
      case 0:
        return _buildEventDetails();
      case 1:
        return _buildAttendanceRequirement();
      case 2:
        return _buildSubscriptionRequest();
      case 3:
        return _buildFAQ();
      default:
        return _buildEventDetails();
    }
  }

  Widget _buildEventDetails() {
    return Container(
      margin: const EdgeInsets.all(16),
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
            'Event Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildDetailRow('Event Date', widget.eventDate),
          const SizedBox(height: 12),
          _buildDetailRow('Registration Date', widget.registrationDate),
          const SizedBox(height: 12),
          _buildDetailRow('Venue', widget.venue),
          const SizedBox(height: 12),
          _buildDetailRow('Location', widget.location),
          const SizedBox(height: 12),
          _buildDetailRow('Organizer', widget.organizerName),
          const SizedBox(height: 12),
          _buildDetailRow('Email', widget.organizerEmail),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAttendanceRequirement() {
    return Container(
      margin: const EdgeInsets.all(16),
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
            'Attendance Requirement',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'All participants must attend the event on time. Late arrivals may result in disqualification.',
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionRequest() {
    return Container(
      margin: const EdgeInsets.all(16),
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
            'Subscription Request',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Subscription request sent!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
            ),
            child: const Text('Subscribe to Event'),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQ() {
    return Container(
      margin: const EdgeInsets.all(16),
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
            'Frequently Asked Questions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildFAQItem(
            0,
            'What is the registration deadline?',
            'The registration deadline is ${widget.registrationDate}.',
          ),
          const SizedBox(height: 12),
          _buildFAQItem(
            1,
            'What sports are available?',
            'Available sports: ${widget.availableSports.join(", ")}.',
          ),
          const SizedBox(height: 12),
          _buildFAQItem(
            2,
            'How do I contact the organizer?',
            'You can contact the organizer at ${widget.organizerEmail}.',
          ),
        ],
      ),
    );
  }

  Widget _buildFAQItem(int index, String question, String answer) {
    final isExpanded = _expandedFAQItems[index] ?? false;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _expandedFAQItems[index] = !isExpanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      question,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Text(
                answer,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Payment Modal Methods - Same as member page
  void _showPaymentDetailsModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => _buildPaymentDetailsModal(setModalState),
      ),
    );
  }

  Widget _buildPaymentDetailsModal(StateSetter setModalState) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        border: Border.all(color: Colors.lightBlue.shade200, width: 2),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.lightBlue.shade100,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: const Center(
              child: Text('Payment Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: _buildUserTypeButton('FREE USER', _userType == 'FREE USER', () {
                    setModalState(() => _userType = 'FREE USER');
                  }),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildUserTypeButton('PRIVILEGE USER', _userType == 'PRIVILEGE USER', () {
                    setModalState(() => _userType = 'PRIVILEGE USER');
                  }),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.lightBlue.shade100, borderRadius: BorderRadius.circular(8)),
                    child: const Text('Payment Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                  const SizedBox(height: 16),
                  _buildEventSection(),
                  const SizedBox(height: 24),
                  _buildTotalPaymentsSection(),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, -2))]),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(color: Colors.grey.shade400),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Cancel', style: TextStyle(color: Colors.black87)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _showPaymentMethodModal();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Pay Now', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserTypeButton(String label, bool isSelected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.grey.shade200 : Colors.black,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isSelected ? Colors.grey.shade400 : Colors.transparent, width: 1),
        ),
        child: Center(
          child: Text(label, style: TextStyle(color: isSelected ? Colors.black87 : Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
        ),
      ),
    );
  }

  Widget _buildEventSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Event', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF232534))),
        const SizedBox(height: 8),
        Row(
          children: [
            const Text('Player', style: TextStyle(fontSize: 14, color: Color(0xFF232534))),
            const SizedBox(width: 16),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade300)),
                child: const Text('1 Slot'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade300)),
                child: Text('USD ${_netTotalAmount.toInt()}'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTotalPaymentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Total Payments', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF232534))),
        const SizedBox(height: 12),
        _buildPaymentRow('Net Total Amount To Pay:', _netTotalAmount, Colors.grey.shade800),
        _buildPaymentRow('Discount Amount:', _discountAmount, Colors.red),
        _buildPaymentRow('Discount For Referral:', _referralDiscount, Colors.red),
        _buildPaymentRow('Grand Total Amount To Pay:', _grandTotal, Colors.grey.shade800),
        _buildPaymentRow('Consumption Tax Amount (10%):', _taxAmount, Colors.grey.shade800),
        _buildPaymentRow('Total Amount INcluding Tax:', _totalIncludingTax, Colors.green),
      ],
    );
  }

  Widget _buildPaymentRow(String label, double amount, Color backgroundColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
          Row(
            children: [
              const Text('USD', style: TextStyle(color: Colors.white, fontSize: 13)),
              const SizedBox(width: 8),
              Container(
                width: 60,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
                child: Text(amount == 0 ? '-' : amount.toInt().toString(), style: const TextStyle(color: Colors.black87, fontSize: 13, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showPaymentMethodModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => _buildPaymentMethodModal(setModalState),
      ),
    );
  }

  Widget _buildPaymentMethodModal(StateSetter setModalState) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.95,
      decoration: BoxDecoration(color: Colors.white, borderRadius: const BorderRadius.vertical(top: Radius.circular(20)), border: Border.all(color: Colors.lightBlue.shade200, width: 2)),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.grey.shade800, borderRadius: const BorderRadius.vertical(top: Radius.circular(20))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Payment Method', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: () => Navigator.of(context).pop()),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAmountToPaySection(),
                  const SizedBox(height: 24),
                  _buildPaymentMethodSelection(setModalState),
                  const SizedBox(height: 24),
                  _buildFinalPaymentDetails(),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, -2))]),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14), side: BorderSide(color: Colors.grey.shade400), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                    child: const Text('CANCEL', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Payment processed successfully')));
                    },
                    style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14), backgroundColor: Colors.green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                    child: const Text('PAY NOW', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountToPaySection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.lightBlue.shade50, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.lightBlue.shade200, style: BorderStyle.solid)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Amount To Pay', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF232534))),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(8)),
                  child: const Center(child: Text('Total Amount To Pay', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade300)),
                  child: Text('USD ${_totalIncludingTax.toInt()}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF232534)), textAlign: TextAlign.center),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodSelection(StateSetter setModalState) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.lightBlue.shade50, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.lightBlue.shade200, style: BorderStyle.solid)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Payment Method', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF232534))),
          const SizedBox(height: 16),
          _buildPaymentMethodCard('CREDIT / DEBIT CARD', Icons.credit_card, _isCreditCardExpanded, () {
            setModalState(() {
              _isCreditCardExpanded = !_isCreditCardExpanded;
              if (_isCreditCardExpanded) {
                _selectedPaymentMethod = 'CREDIT / DEBIT CARD';
                _isPayPalExpanded = false;
                _isZelleExpanded = false;
              }
            });
          }, _isCreditCardExpanded ? _buildCreditCardForm() : null, setModalState),
          const SizedBox(height: 12),
          _buildPaymentMethodCard('PAYPAL', Icons.payment, _isPayPalExpanded, () {
            setModalState(() {
              _isPayPalExpanded = !_isPayPalExpanded;
              if (_isPayPalExpanded) {
                _selectedPaymentMethod = 'PAYPAL';
                _isCreditCardExpanded = false;
                _isZelleExpanded = false;
              }
            });
          }, _isPayPalExpanded ? _buildPayPalForm() : null, setModalState),
          const SizedBox(height: 12),
          _buildPaymentMethodCard('ZELLE', Icons.account_balance_wallet, _isZelleExpanded, () {
            setModalState(() {
              _isZelleExpanded = !_isZelleExpanded;
              if (_isZelleExpanded) {
                _selectedPaymentMethod = 'ZELLE';
                _isCreditCardExpanded = false;
                _isPayPalExpanded = false;
              }
            });
          }, _isZelleExpanded ? _buildZelleForm() : null, setModalState),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodCard(String title, IconData icon, bool isExpanded, VoidCallback onToggle, Widget? content, StateSetter setModalState) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade300)),
      child: Column(
        children: [
          InkWell(
            onTap: onToggle,
            child: Container(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [Icon(icon, size: 20, color: Colors.grey.shade700), const SizedBox(width: 8), Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF232534)))]),
                  Icon(isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: Colors.grey.shade700),
                ],
              ),
            ),
          ),
          if (content != null) content,
        ],
      ),
    );
  }

  Widget _buildCreditCardForm() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8))),
      child: Column(
        children: [
          _buildPaymentFormField('Name On Card', _nameOnCardController, 'Blank Fields'),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildPaymentFormField('Card Number', _cardNumberController, 'Blank Fields')),
              const SizedBox(width: 8),
              Row(children: [_buildCardIcon('VISA'), const SizedBox(width: 4), _buildCardIcon('MC'), const SizedBox(width: 4), _buildCardIcon('DISCOVER'), const SizedBox(width: 4), _buildCardIcon('AMEX')]),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildPaymentFormField('Expiry Date', _expiryDateController, 'Blank Fields')),
              const SizedBox(width: 8),
              Expanded(
                child: Row(
                  children: [
                    Expanded(child: _buildPaymentFormField('CVV', _cvvController, 'Blank Fields')),
                    const SizedBox(width: 8),
                    Icon(Icons.credit_card, size: 20, color: Colors.grey.shade600),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPayPalForm() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('https://www.paypal.com/paypalme/sekaiichikk', style: TextStyle(color: Colors.blue, fontSize: 12, decoration: TextDecoration.underline)),
          const SizedBox(height: 12),
          const Text('Send Payment To Paypal ID', style: TextStyle(fontSize: 12, color: Color(0xFF232534))),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade300)),
            child: const Text('sushant.godghate@sekai-ichi.com', style: TextStyle(fontSize: 13, color: Color(0xFF232534))),
          ),
        ],
      ),
    );
  }

  Widget _buildZelleForm() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('https://www.zelle.com/zelleme/sekaiichikk', style: TextStyle(color: Colors.blue, fontSize: 12, decoration: TextDecoration.underline)),
          const SizedBox(height: 12),
          const Text('Send Payment To Zelle ID', style: TextStyle(fontSize: 12, color: Color(0xFF232534))),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade300)),
            child: const Text('sushant.godghate@sekai-ichi.com', style: TextStyle(fontSize: 13, color: Color(0xFF232534))),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentFormField(String label, TextEditingController controller, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF232534), fontWeight: FontWeight.w500)),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
        ),
      ],
    );
  }

  Widget _buildFinalPaymentDetails() {
    final now = DateTime.now();
    final dateStr = '${_getDayName(now.weekday)}, ${_getMonthName(now.month)} ${now.day}, ${now.year}';
    final timeStr = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.lightBlue.shade50, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.lightBlue.shade200, style: BorderStyle.solid)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Final Payment Details', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF232534))),
          const SizedBox(height: 16),
          _buildPaymentDetailRow('Payment Method:', _selectedPaymentMethod),
          _buildPaymentDetailRow('Payment Status:', 'BEING PROCESSED'),
          _buildPaymentDetailRow('Payment Date:', dateStr),
          _buildPaymentDetailRow('Payment Time', timeStr),
        ],
      ),
    );
  }

  Widget _buildPaymentDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, color: Color(0xFF232534))),
          Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF232534))),
        ],
      ),
    );
  }

  String _getDayName(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday - 1];
  }

  String _getMonthName(int month) {
    const months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    return months[month - 1];
  }

  Widget _buildCardIcon(String cardType) {
    return Container(
      width: 24,
      height: 16,
      decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
      child: Center(child: Text(cardType.substring(0, 1), style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.grey.shade700))),
    );
  }
}

// Custom Painter for Semi-Circular Progress Indicator
class SemiCircleProgressPainter extends CustomPainter {
  final double progress;
  final Color color;

  SemiCircleProgressPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    final backgroundPaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2 - 6;

    // Draw background arc (semi-circle)
    final backgroundRect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawArc(
      backgroundRect,
      math.pi, // Start from left (180 degrees)
      math.pi, // Draw half circle (180 degrees)
      false,
      backgroundPaint,
    );

    // Draw progress arc
    final progressAngle = math.pi * progress;
    canvas.drawArc(
      backgroundRect,
      math.pi, // Start from left
      progressAngle, // Draw progress portion
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(SemiCircleProgressPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}

