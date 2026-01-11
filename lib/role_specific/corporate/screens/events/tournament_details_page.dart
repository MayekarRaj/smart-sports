import 'package:flutter/material.dart';
import 'package:smart_sports/shared/widgets/role_sidebar.dart';
import 'package:smart_sports/role_specific/common/role_router.dart';
import 'package:smart_sports/shared/navigation/role_navigation_manager.dart';

class TournamentDetailsPage extends StatefulWidget {
  final String tournamentName;
  final String venue;
  final String location;
  final double rating;
  final List<String> availableSports;
  final String eventDate;
  final String registrationDate;
  final String organizerName;
  final String organizerEmail;
  final String role; // 'Organiser' or 'Coach'

  const TournamentDetailsPage({
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
    this.role = 'Organiser', // Default to Organiser
  });

  @override
  State<TournamentDetailsPage> createState() => _TournamentDetailsPageState();
}

class _TournamentDetailsPageState extends State<TournamentDetailsPage> {
  int _selectedButtonIndex = 0;
  int _selectedSubscriptionTab = 0;
  int _selectedFAQCategory = 0;
  String _searchQuery = '';
  final int _entriesPerPage = 10;
  final Map<int, bool> _expandedFAQItems = {};
  String _selectedCategory = 'Subscription';
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
              colors: [Color(0xFF059669), Color(0xFF1E40AF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
      ),
      drawer: Drawer(
        elevation: 0,
        child: SafeArea(
          child: RoleSidebar(
            role: UserRole.corporate,
            selectedIndex: 5,
            edgeToEdge: true,
            onSelectIndex: (i) => RoleNavigationManager.navigateToScreen(
              context,
              UserRole.corporate,
              i,
            ),
            onProfileTap: () async {
              Navigator.of(context).pop();
              await Future.delayed(const Duration(milliseconds: 160));
            },
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Role Label
            Container(
              margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                children: [
                  Text(
                    'Role',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    widget.role,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            
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
            color: Colors.grey.withValues(alpha: 0.1),
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
            Positioned.fill(
              child: Container(
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage(
                    'assets/images/pngtree-a-large-cricket-stadium-green-field-empty-picture-image_15985507.jpg',
                  ),
                  fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            // Overlay Content
            Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.3),
                      Colors.black.withValues(alpha: 0.7),
                    ],
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                mainAxisSize: MainAxisSize.min,
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

                    const SizedBox(height: 12),

                    // Venue and Rating
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.venue,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              widget.rating.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: List.generate(
                                5,
                                (index) => const Icon(
                                  Icons.star,
                                  color: Colors.yellow,
                                  size: 16,
                                ),
                              ),
                            ),
                            const Text(
                              'Club Rating',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Location
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        widget.location,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Available Sports
                    const Text(
                      'AVAILABLE SPORTS',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: widget.availableSports
                          .map((sport) => _buildSportChip(sport, true))
                          .toList(),
                    ),

                    const SizedBox(height: 12),

                    // Schedule
                    const Text(
                      'SCHEDULE',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    _buildScheduleItem('Event Date', widget.eventDate),
                    _buildScheduleItem(
                      'Registration Last Date',
                      widget.registrationDate,
                    ),

                    const SizedBox(height: 12),

                    // Organizer Info
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'ORGANISER',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const CircleAvatar(
                                radius: 16,
                                backgroundColor: Colors.blue,
                                child: Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.organizerName,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      widget.organizerEmail,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size(60, 30),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                ),
                                child: const Text(
                                  'Connect',
                                  style: TextStyle(fontSize: 10),
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
          const Text(
            'Subscriptions',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.4,
            children: [
              _buildSubscriptionCard('Cricket', 120, 200, 10, 12, 20),
              _buildSubscriptionCard('Tennis', 80, 150, 8, 10, 18),
              _buildSubscriptionCard('Basketball', 95, 180, 12, 15, 25),
              _buildSubscriptionCard('Softball', 60, 120, 6, 8, 15),
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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            sport,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),

          // Players Progress
          _buildProgressSection(
            'Players',
            players,
            maxPlayers,
            Colors.blue,
            true,
          ),

          const SizedBox(height: 8),

          // Sponsors
          _buildSponsorsSection(sponsors),

          const SizedBox(height: 8),

          // Coaches
          _buildProgressSection(
            'Coach\'s',
            coaches,
            maxCoaches,
            Colors.green,
            false,
          ),

          const SizedBox(height: 6),

          // Teams
          _buildProgressSection(
            'Teams',
            coaches,
            maxCoaches,
            Colors.blue,
            false,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection(
    String title,
    int current,
    int max,
    Color color,
    bool isCircular,
  ) {
    final progress = current / max;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 2),
        if (isCircular)
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
                      valueColor: AlwaysStoppedAnimation<Color>(color),
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
          )
        else
          Column(
            children: [
              Row(
                children: List.generate(10, (index) {
                  return Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.only(right: 1),
                    decoration: BoxDecoration(
                      color: index < (progress * 10).round()
                          ? color
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 2),
              Text(
                '$current/$max',
                style: const TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildSponsorsSection(int sponsorCount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Sponsors',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 2),
        Row(
          children: [
            Text(
              sponsorCount.toString(),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(width: 8),
            Row(
              children: List.generate(
                sponsorCount > 4 ? 4 : sponsorCount,
                (index) => Container(
                  width: 12,
                  height: 12,
                  margin: const EdgeInsets.only(right: 2),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade300,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person, size: 8, color: Colors.white),
                ),
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
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Quick Actions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
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
                          color: isSelected ? Colors.blue : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? Colors.blue : Colors.grey.shade300,
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withValues(alpha: 0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              button['icon'],
                              color: isSelected ? Colors.white : Colors.blue,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                button['title'],
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.black87,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            );
          } else {
            // Desktop - grid view
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Quick Actions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 2.5,
                  children: _navigationButtons.asMap().entries.map((entry) {
                    final index = entry.key;
                    final button = entry.value;
                    final isSelected = _selectedButtonIndex == index;

                    return InkWell(
                      onTap: () => setState(() => _selectedButtonIndex = index),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.blue : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? Colors.blue : Colors.grey.shade300,
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withValues(alpha: 0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(
                              button['icon'],
                              color: isSelected ? Colors.white : Colors.blue,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                button['title'],
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.black87,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildContentSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _navigationButtons[_selectedButtonIndex]['title'],
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          _buildContentForSelectedButton(),
        ],
      ),
    );
  }

  Widget _buildContentForSelectedButton() {
    switch (_selectedButtonIndex) {
      case 0: // Event Details
        return _buildEventDetailsContent();
      case 1: // Attendance Requirement
        return _buildAttendanceRequirementContent();
      case 2: // Subscription Request
        return _buildSubscriptionRequestContent();
      case 3: // FAQ
        return _buildFAQContent();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildEventDetailsContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Event Name
          _buildFormField(
            'Event Name',
            TextFormField(
              initialValue: 'Brown Country Softball Tournament',
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Event Description
          _buildFormField(
            'Event Description',
            TextFormField(
              initialValue:
                  'Lorem Ipsum Dolor Sit Amet Consectetur. Ac Quam Cras A Elit. Quis Odio Scelerisque Lacus Pellentesque Vel Sit Tristique Habitant Lacus. In Et Faucibus Pellentesque Commodo Suscipit. Blandit Leo Netus Sed At.',
              maxLines: 4,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Trophy Section
          _buildFormField(
            'Trophy',
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 600) {
                  // Mobile layout - stack vertically
                  return Column(
                    children: [
                      _buildTrophyField('1st Prize', 'Input Text'),
                      const SizedBox(height: 8),
                      _buildTrophyField('2nd Prize', 'Input Text'),
                      const SizedBox(height: 8),
                      _buildTrophyField('3rd Prize', 'Input Text'),
                    ],
                  );
                } else {
                  // Desktop layout - horizontal
                  return Row(
                    children: [
                      Expanded(
                        child: _buildTrophyField('1st Prize', 'Input Text'),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildTrophyField('2nd Prize', 'Input Text'),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildTrophyField('3rd Prize', 'Input Text'),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
          const SizedBox(height: 16),

          // Sports Type
          _buildFormField(
            'Sports Type',
            Row(
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 8,
                    children: [
                      _buildSportChip('Cricket', true),
                      _buildSportChip('Football', false),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.search, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Event Promotional Image
          _buildFormField(
            'Event Promotional Image',
            LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                  height: constraints.maxWidth < 400 ? 100 : 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFE4B5), Color(0xFFFFA500)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 12,
                        top: 12,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'SPORT CLUB',
                              style: TextStyle(
                                fontSize: constraints.maxWidth < 400 ? 16 : 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.purple,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Get 10 days of The Free Trial',
                              style: TextStyle(
                                fontSize: constraints.maxWidth < 400 ? 10 : 12,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              '50% OFF',
                              style: TextStyle(
                                fontSize: constraints.maxWidth < 400 ? 14 : 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                minimumSize: Size(
                                  constraints.maxWidth < 400 ? 70 : 80,
                                  constraints.maxWidth < 400 ? 20 : 24,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                              ),
                              child: Text(
                                'Learn More',
                                style: TextStyle(
                                  fontSize: constraints.maxWidth < 400 ? 8 : 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        right: 12,
                        top: 12,
                        child: Wrap(
                          spacing: 2,
                          runSpacing: 2,
                          children: [
                            _buildSportIcon(Icons.sports_tennis, Colors.green),
                            _buildSportIcon(
                              Icons.sports_volleyball,
                              const Color(0xFF414384),
                            ),
                            _buildSportIcon(Icons.fitness_center, Colors.red),
                            _buildSportIcon(Icons.sports, Colors.blue),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),

          // Registration Details
          _buildFormField(
            'Registration Start Date',
            TextFormField(
              initialValue: 'Wed, March 05, 2025',
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey[50],
                suffixIcon: const Icon(Icons.calendar_today, size: 16),
              ),
            ),
          ),
          const SizedBox(height: 16),

          _buildFormField(
            'Registration End Date',
            TextFormField(
              initialValue: 'Wed, March 05, 2025',
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey[50],
                suffixIcon: const Icon(Icons.calendar_today, size: 16),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Registration Charges
          _buildFormField(
            'Registration Charges',
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Additional XX% Platform Fee Will Be Charged On The Top Of Below Registration Charges.',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(height: 12),
                LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth < 400) {
                      // Mobile layout - single column
                      return Column(
                        children: [
                          _buildChargeField('Attendee', 'USD', '100'),
                          const SizedBox(height: 8),
                          _buildChargeField('Coach', 'USD', '200'),
                          const SizedBox(height: 8),
                          _buildChargeField('Player', 'USD', '150'),
                          const SizedBox(height: 8),
                          _buildChargeField('Team', 'USD', '1000'),
                        ],
                      );
                    } else {
                      // Desktop layout - two columns
                      return Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _buildChargeField(
                                  'Attendee',
                                  'USD',
                                  '100',
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _buildChargeField('Coach', 'USD', '200'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: _buildChargeField(
                                  'Player',
                                  'USD',
                                  '150',
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _buildChargeField('Team', 'USD', '1000'),
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
          ),
          const SizedBox(height: 16),

          // Rules & Regulations
          _buildFormField(
            'Rules & Regulations',
            TextFormField(
              initialValue:
                  'Lorem Ipsum Dolor Sit Amet Consectetur. Sodales Quam Blandit Nisl Diam Adipiscing Consectetur Nibh Elit. Quis Proin Tristique Adipiscing Pellentesque. Faucibus Cras Nec Platea Donec Facilisi. Elementum Aliquam Purus Amet Gravida.',
              maxLines: 4,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Event Schedule
          _buildFormField(
            'Event Schedule',
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth < 600) {
                      // Mobile layout - stack vertically
                      return Column(
                        children: [
                          _buildScheduleField('No. Of Days', '3'),
                          const SizedBox(height: 8),
                          _buildScheduleField(
                            'Start Date',
                            'Wed, March 05, 2025',
                          ),
                          const SizedBox(height: 8),
                          _buildScheduleField(
                            'End Date',
                            'Wed, March 05, 2025',
                          ),
                        ],
                      );
                    } else {
                      // Desktop layout - horizontal
                      return Row(
                        children: [
                          Expanded(
                            child: _buildScheduleField('No. Of Days', '3'),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildScheduleField(
                              'Start Date',
                              'Wed, March 05, 2025',
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildScheduleField(
                              'End Date',
                              'Wed, March 05, 2025',
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
                const SizedBox(height: 12),
                LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth < 400) {
                      // Mobile layout - stack vertically
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Is Schedule Same For All Days?',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Radio<bool>(
                                value: true,
                                groupValue: true,
                                onChanged: (value) {},
                              ),
                              const Text('Yes'),
                              const SizedBox(width: 16),
                              Radio<bool>(
                                value: false,
                                groupValue: true,
                                onChanged: (value) {},
                              ),
                              const Text('No'),
                            ],
                          ),
                        ],
                      );
                    } else {
                      // Desktop layout - horizontal
                      return Row(
                        children: [
                          const Text(
                            'Is Schedule Same For All Days?',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Row(
                            children: [
                              Radio<bool>(
                                value: true,
                                groupValue: true,
                                onChanged: (value) {},
                              ),
                              const Text('Yes'),
                              const SizedBox(width: 16),
                              Radio<bool>(
                                value: false,
                                groupValue: true,
                                onChanged: (value) {},
                              ),
                              const Text('No'),
                            ],
                          ),
                        ],
                      );
                    }
                  },
                ),
                const SizedBox(height: 12),
                _buildScheduleTable(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceRequirementContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'Attendance Requirements',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),

          // Global Settings Question
          _buildFormField(
            'Is Attendees Information Same For All Sport Types?',
            Row(
              children: [
                Radio<bool>(
                  value: true,
                  groupValue: false, // "No" is selected
                  onChanged: (value) {},
                ),
                const Text('Yes'),
                const SizedBox(width: 20),
                Radio<bool>(
                  value: false,
                  groupValue: false, // "No" is selected
                  onChanged: (value) {},
                ),
                const Text('No'),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Sport Type Tabs
          _buildSportTypeTabs(),
          const SizedBox(height: 20),

          // Attendees Information
          _buildAttendeesInformation(),
          const SizedBox(height: 20),

          // Organizer Information
          _buildOrganizerInformation(),
          const SizedBox(height: 20),

          // Sponsorship Applicability
          _buildSponsorshipApplicability(),
          const SizedBox(height: 20),

          // Sponsorship Type Section
          _buildSponsorshipTypeSection(),
          const SizedBox(height: 20),

          // Sponsorship Tables
          _buildSponsorshipTables(),
        ],
      ),
    );
  }

  Widget _buildSubscriptionRequestContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const Text(
            'Subscription Requests',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),

          // Tab Navigation
          _buildSubscriptionTabs(),
          const SizedBox(height: 20),

          // Content based on selected tab
          _buildSubscriptionContent(),
        ],
      ),
    );
  }

  Widget _buildFAQContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const Text(
            'FAQ',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),

          // Search and Entries Control
          _buildSearchAndEntriesControl(),
          const SizedBox(height: 16),

          // Category Filters
          _buildCategoryFilters(),
          const SizedBox(height: 20),

          // FAQ Items List
          _buildFAQItemsList(),
          const SizedBox(height: 20),

          // Add FAQ Button
          _buildAddFAQButton(),
        ],
      ),
    );
  }

  Widget _buildFormField(String label, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  Widget _buildTrophyField(String label, String placeholder) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 2),
        TextFormField(
          decoration: InputDecoration(
            hintText: placeholder,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 8,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSportChip(String sport, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue : Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        sport,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildSportIcon(IconData icon, Color color) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Icon(icon, color: Colors.white, size: 14),
    );
  }

  Widget _buildChargeField(String label, String currency, String amount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 2),
        Row(
          children: [
            Container(
              width: 60,
              height: 32,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Center(
                child: Text(currency, style: const TextStyle(fontSize: 12)),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: TextFormField(
                initialValue: amount,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildScheduleField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 2),
        TextFormField(
          initialValue: value,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 8,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScheduleTable() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          // Mobile layout - card-based
          return Column(
            children: [
              _buildMobileScheduleCard(
                'Day 1',
                'Wed, March 05, 2025',
                'Cricket',
                'HH',
                'MM',
                'HH',
                'MM',
                'Club 1 > Court 1',
              ),
              const SizedBox(height: 8),
              _buildMobileScheduleCard(
                'Day 2',
                'Thu, March 06, 2025',
                '',
                '',
                '',
                '',
                '',
                '',
              ),
              const SizedBox(height: 8),
              _buildMobileScheduleCard(
                'Day 3',
                'Fri, March 07, 2025',
                'Football',
                'HH',
                'MM',
                'HH',
                'MM',
                'Club 1 > Court 2',
              ),
            ],
          );
        } else {
          // Desktop layout - table
          return Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(8),
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
                      Expanded(flex: 2, child: _buildTableHeader('Venue')),
                    ],
                  ),
                ),
                // Rows
                _buildTableRow(
                  'Day 1',
                  'Wed, March 05, 2025',
                  'Cricket',
                  'HH',
                  'MM',
                  'HH',
                  'MM',
                  'Club 1 > Court 1',
                ),
                _buildTableRow(
                  'Day 2',
                  'Thu, March 06, 2025',
                  '',
                  '',
                  '',
                  '',
                  '',
                  '',
                ),
                _buildTableRow(
                  'Day 3',
                  'Fri, March 07, 2025',
                  'Football',
                  'HH',
                  'MM',
                  'HH',
                  'MM',
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
    String day,
    String date,
    String sportType,
    String startHH,
    String startMM,
    String endHH,
    String endMM,
    String venue,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                day,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const Spacer(),
              Text(
                date,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Sport Type',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 2),
                    sportType.isEmpty
                        ? TextFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                            ),
                          )
                        : Text(sportType, style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Start Time',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            initialValue: startHH,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 4,
                              ),
                            ),
                          ),
                        ),
                        const Text(':', style: TextStyle(fontSize: 12)),
                        Expanded(
                          child: TextFormField(
                            initialValue: startMM,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 4,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'End Time',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            initialValue: endHH,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 4,
                              ),
                            ),
                          ),
                        ),
                        const Text(':', style: TextStyle(fontSize: 12)),
                        Expanded(
                          child: TextFormField(
                            initialValue: endMM,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 4,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Venue',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 2),
              venue.isEmpty
                  ? TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                      ),
                    )
                  : Text(
                      venue,
                      style: const TextStyle(fontSize: 12, color: Colors.blue),
                    ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildTableRow(
    String day,
    String date,
    String sportType,
    String startHH,
    String startMM,
    String endHH,
    String endMM,
    String venue,
  ) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(day, style: const TextStyle(fontSize: 12)),
          ),
          Expanded(
            flex: 2,
            child: Text(date, style: const TextStyle(fontSize: 12)),
          ),
          Expanded(
            flex: 2,
            child: sportType.isEmpty
                ? TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 4,
                      ),
                    ),
                  )
                : Text(sportType, style: const TextStyle(fontSize: 12)),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: startHH,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 4,
                      ),
                    ),
                  ),
                ),
                const Text(':', style: TextStyle(fontSize: 12)),
                Expanded(
                  child: TextFormField(
                    initialValue: startMM,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 4,
                      ),
                    ),
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
                  child: TextFormField(
                    initialValue: endHH,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 4,
                      ),
                    ),
                  ),
                ),
                const Text(':', style: TextStyle(fontSize: 12)),
                Expanded(
                  child: TextFormField(
                    initialValue: endMM,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 4,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: venue.isEmpty
                ? TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 4,
                      ),
                    ),
                  )
                : Text(
                    venue,
                    style: const TextStyle(fontSize: 12, color: Colors.blue),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // Attendance Requirement Helper Methods
  Widget _buildSportTypeTabs() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(child: _buildTabButton('Football', true)),
          Expanded(child: _buildTabButton('Cricket', false)),
          Expanded(child: _buildTabButton('Tennis', false)),
        ],
      ),
    );
  }

  Widget _buildTabButton(String title, bool isSelected) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.black87 : Colors.grey[600],
          ),
        ),
      ),
    );
  }

  Widget _buildAttendeesInformation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Attendees Information',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
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
                  _buildInputField('Max Teams', '10'),
                  const SizedBox(height: 12),
                  _buildInputField('Players/Team', '11'),
                  const SizedBox(height: 12),
                  _buildInputField('Coach/Team', '2'),
                  const SizedBox(height: 12),
                  _buildInputField('Gender', 'Male'),
                  const SizedBox(height: 12),
                  _buildInputField('Age Group', '18-24'),
                  const SizedBox(height: 12),
                  _buildInputField('Max Spectators', '300'),
                ],
              );
            } else {
              // Desktop layout - two columns
              return Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        _buildInputField('Max Teams', '10'),
                        const SizedBox(height: 12),
                        _buildInputField('Players/Team', '11'),
                        const SizedBox(height: 12),
                        _buildInputField('Coach/Team', '2'),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      children: [
                        _buildInputField('Gender', 'Male'),
                        const SizedBox(height: 12),
                        _buildInputField('Age Group', '18-24'),
                        const SizedBox(height: 12),
                        _buildInputField('Max Spectators', '300'),
                      ],
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

  Widget _buildOrganizerInformation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Organizer Information',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
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
                  _buildInputField('First Name', '', 'First Name'),
                  const SizedBox(height: 12),
                  _buildInputField('Last Name', '', 'Last Name'),
                  const SizedBox(height: 12),
                  _buildInputField('Contact Number', '91 1111 222 333'),
                  const SizedBox(height: 12),
                  _buildInputField('Contact Email', 'Organiser@Ss.Com'),
                  const SizedBox(height: 12),
                  _buildInputField('Ticket Website', 'Smartsports.com'),
                ],
              );
            } else {
              // Desktop layout - two columns
              return Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        _buildInputField('First Name', '', 'First Name'),
                        const SizedBox(height: 12),
                        _buildInputField('Last Name', '', 'Last Name'),
                        const SizedBox(height: 12),
                        _buildInputField('Contact Number', '91 1111 222 333'),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      children: [
                        _buildInputField('Contact Email', 'Organiser@Ss.Com'),
                        const SizedBox(height: 12),
                        _buildInputField('Ticket Website', 'Smartsports.com'),
                      ],
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

  Widget _buildSponsorshipApplicability() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Is Sponsorship Applicable ?',
          style: TextStyle(
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
              groupValue: true, // "Yes" is selected
              onChanged: (value) {},
            ),
            const Text('Yes'),
            const SizedBox(width: 20),
            Radio<bool>(
              value: false,
              groupValue: true, // "Yes" is selected
              onChanged: (value) {},
            ),
            const Text('No'),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          'Sponsorship Roles:',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: [
            _buildCheckboxTile('Corporate', true),
            _buildCheckboxTile('Merchandise', true),
            _buildCheckboxTile('Coach', false),
            _buildCheckboxTile('Members', false),
            _buildCheckboxTile('Freelancers', false),
          ],
        ),
      ],
    );
  }

  Widget _buildCheckboxTile(String title, bool isChecked) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(value: isChecked, onChanged: (value) {}),
        Text(title, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  Widget _buildSponsorshipTypeSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Sponsorship Type',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.add, size: 16),
          label: const Text('Add Sponsorship Type'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[300],
            foregroundColor: Colors.black87,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSponsorshipTables() {
    return Column(
      children: [
        _buildSponsorshipTable('Club 1 Sponsorship', [
          [
            'Bill Board',
            'Corporate',
            'USD 100',
            'USD 100',
            'USD 100',
            'USD 100',
          ],
          [
            'Digital Ad',
            'Merchandise',
            'USD 100',
            'USD 100',
            'USD 100',
            'USD 100',
          ],
          ['Uniform', 'Coach', 'USD 100', 'USD 100', 'USD 100', 'USD 100'],
          [
            'Video Play',
            'Freelancer',
            'USD 100',
            'USD 100',
            'USD 100',
            'USD 100',
          ],
        ]),
        const SizedBox(height: 16),
        _buildSponsorshipTable('Club 2 Sponsorship', [
          [
            'Bill Board',
            'Corporate',
            'USD 100',
            'USD 100',
            'USD 100',
            'USD 100',
          ],
          [
            'Digital Ad',
            'Merchandise',
            'USD 100',
            'USD 100',
            'USD 100',
            'USD 100',
          ],
          ['Uniform', 'Coach', 'USD 100', 'USD 100', 'USD 100', 'USD 100'],
          [
            'Video Play',
            'Freelancer',
            'USD 100',
            'USD 100',
            'USD 100',
            'USD 100',
          ],
        ]),
        const SizedBox(height: 16),
        _buildSponsorshipTable('Tournament Specific Sponsorship', [
          [
            'Cricket Bat',
            'Merchandise',
            'USD 100',
            'USD 100',
            'USD 100',
            'USD 100',
          ],
          [
            'Digital Ad',
            'Merchandise',
            'USD 100',
            'USD 100',
            'USD 100',
            'USD 100',
          ],
          ['Uniform', 'Coach', 'USD 100', 'USD 100', 'USD 100', 'USD 100'],
          [
            'Video Play',
            'Freelancer',
            'USD 100',
            'USD 100',
            'USD 100',
            'USD 100',
          ],
        ]),
      ],
    );
  }

  Widget _buildSponsorshipTable(String title, List<List<String>> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
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
                      // Mobile layout - scrollable table
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildSponsorshipTableHeader('Type', 80),
                            _buildSponsorshipTableHeader(
                              'Applicable To Role',
                              120,
                            ),
                            _buildSponsorshipTableHeader('Per Day', 80),
                            _buildSponsorshipTableHeader('Per Week', 80),
                            _buildSponsorshipTableHeader('Per Month', 80),
                            _buildSponsorshipTableHeader('Per Year', 80),
                          ],
                        ),
                      );
                    } else {
                      // Desktop layout - normal table
                      return Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: _buildSponsorshipTableHeader('Type', 0),
                          ),
                          Expanded(
                            flex: 2,
                            child: _buildSponsorshipTableHeader(
                              'Applicable To Role',
                              0,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: _buildSponsorshipTableHeader('Per Day', 0),
                          ),
                          Expanded(
                            flex: 1,
                            child: _buildSponsorshipTableHeader('Per Week', 0),
                          ),
                          Expanded(
                            flex: 1,
                            child: _buildSponsorshipTableHeader('Per Month', 0),
                          ),
                          Expanded(
                            flex: 1,
                            child: _buildSponsorshipTableHeader('Per Year', 0),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
              // Rows
              ...data.map((row) => _buildSponsorshipTableRow(row)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSponsorshipTableRow(List<String> data) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            // Mobile layout - scrollable table
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildTableCell(data[0], 80),
                  _buildTableCell(data[1], 120),
                  _buildTableCell(data[2], 80),
                  _buildTableCell(data[3], 80),
                  _buildTableCell(data[4], 80),
                  _buildTableCell(data[5], 80),
                ],
              ),
            );
          } else {
            // Desktop layout - normal table
            return Row(
              children: [
                Expanded(flex: 2, child: _buildTableCell(data[0], 0)),
                Expanded(flex: 2, child: _buildTableCell(data[1], 0)),
                Expanded(flex: 1, child: _buildTableCell(data[2], 0)),
                Expanded(flex: 1, child: _buildTableCell(data[3], 0)),
                Expanded(flex: 1, child: _buildTableCell(data[4], 0)),
                Expanded(flex: 1, child: _buildTableCell(data[5], 0)),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildSponsorshipTableHeader(String text, double width) {
    return SizedBox(
      width: width > 0 ? width : null,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildTableCell(String text, double width) {
    return SizedBox(
      width: width > 0 ? width : null,
      child: Text(
        text,
        style: const TextStyle(fontSize: 12, color: Colors.black87),
      ),
    );
  }

  Widget _buildInputField(String label, String value, [String? hintText]) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: value,
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  // Subscription Request Helper Methods
  Widget _buildSubscriptionTabs() {
    final tabs = ['Teams', 'Coach\'s', 'Players', 'Sponsor\'s', 'Attendees'];

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: tabs.asMap().entries.map((entry) {
            final index = entry.key;
            final tab = entry.value;
            final isSelected = _selectedSubscriptionTab == index;

            return GestureDetector(
              onTap: () => setState(() => _selectedSubscriptionTab = index),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  tab,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.black87 : Colors.grey[600],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildSubscriptionContent() {
    switch (_selectedSubscriptionTab) {
      case 0: // Teams
        return _buildTeamsContent();
      case 1: // Coach's
        return _buildCoachesContent();
      case 2: // Players
        return _buildPlayersContent();
      case 3: // Sponsor's
        return _buildSponsorsContent();
      case 4: // Attendees
        return _buildAttendeesContent();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildTeamsContent() {
    return Column(
      children: [
        _buildTeamRequestCard(
          'Team A',
          'Aayush@Email.com',
          'Aayush Mehto',
          'XXXXXXXXXX',
          'Player',
          'Nagpur, Maharashtra',
          'N/A',
          'rejected',
        ),
        const SizedBox(height: 12),
        _buildTeamRequestCard(
          'Team A',
          'Aayush@Email.com',
          'Aayush Mehto',
          'XXXXXXXXXX',
          'Player',
          'Nagpur, Maharashtra',
          'Checked In',
          'accepted',
        ),
        const SizedBox(height: 12),
        _buildTeamRequestCard(
          'Team A',
          'Aayush@Email.com',
          'Aayush Mehto',
          'XXXXXXXXXX',
          'Player',
          'Nagpur, Maharashtra',
          'Checked In',
          'accepted',
        ),
        const SizedBox(height: 12),
        _buildTeamRequestCard(
          'Team A',
          'Aayush@Email.com',
          'Aayush Mehto',
          'XXXXXXXXXX',
          'Player',
          'Nagpur, Maharashtra',
          'N/A',
          'rejected',
        ),
      ],
    );
  }

  Widget _buildCoachesContent() {
    return Column(
      children: [
        _buildCoachRequestCard(
          'Anil Kumar',
          'Anil.Coach@gmail.com',
          '8 Years',
          'Male',
          'ICC Level 2 Certified',
          'Batting Coach / Fielding Coach',
          'accepted',
        ),
        const SizedBox(height: 12),
        _buildCoachRequestCard(
          'Anil Kumar',
          'Anil.Coach@gmail.com',
          '8 Years',
          'Male',
          'ICC Level 2 Certified',
          'Batting Coach / Fielding Coach',
          'accepted',
        ),
        const SizedBox(height: 12),
        _buildCoachRequestCard(
          'Anil Kumar',
          'Anil.Coach@gmail.com',
          '8 Years',
          'Male',
          'ICC Level 2 Certified',
          'Batting Coach / Fielding Coach',
          'accepted',
        ),
        const SizedBox(height: 12),
        _buildCoachRequestCard(
          'Anil Kumar',
          'Anil.Coach@gmail.com',
          '8 Years',
          'Male',
          'ICC Level 2 Certified',
          'Batting Coach / Fielding Coach',
          'rejected',
        ),
        const SizedBox(height: 12),
        _buildCoachRequestCard(
          'Anil Kumar',
          'Anil.Coach@gmail.com',
          '8 Years',
          'Male',
          'ICC Level 2 Certified',
          'Batting Coach / Fielding Coach',
          'pending',
        ),
      ],
    );
  }

  Widget _buildPlayersContent() {
    return Column(
      children: [
        _buildPlayerRequestCard(
          'Elijah Scott',
          'Rohit@Email.Com',
          '20',
          'Male',
          '+91-XXXXXXXXXX',
          'Pune, Maharashtra',
          'accepted',
        ),
        const SizedBox(height: 12),
        _buildPlayerRequestCard(
          'Elijah Scott',
          'Rohit@Email.Com',
          '20',
          'Male',
          '+91-XXXXXXXXXX',
          'Pune, Maharashtra',
          'accepted',
        ),
        const SizedBox(height: 12),
        _buildPlayerRequestCard(
          'Elijah Scott',
          'Rohit@Email.Com',
          '20',
          'Male',
          '+91-XXXXXXXXXX',
          'Pune, Maharashtra',
          'accepted',
        ),
        const SizedBox(height: 12),
        _buildPlayerRequestCard(
          'Elijah Scott',
          'Rohit@Email.Com',
          '20',
          'Male',
          '+91-XXXXXXXXXX',
          'Pune, Maharashtra',
          'rejected',
        ),
        const SizedBox(height: 12),
        _buildPlayerRequestCard(
          'Elijah Scott',
          'Rohit@Email.Com',
          '20',
          'Male',
          '+91-XXXXXXXXXX',
          'Pune, Maharashtra',
          'pending',
        ),
      ],
    );
  }

  Widget _buildSponsorsContent() {
    return Column(
      children: [
        _buildSponsorRequestCard(
          'PepsiCo India',
          'Www.Pepsico.Com',
          'Rajesh Khanna',
          'Marketing Manager',
          'Cricket',
          'Bill Board',
          'accepted',
        ),
        const SizedBox(height: 12),
        _buildSponsorRequestCard(
          'PepsiCo India',
          'Www.Pepsico.Com',
          'Rajesh Khanna',
          'Marketing Manager',
          'Cricket',
          'Bill Board',
          'accepted',
        ),
        const SizedBox(height: 12),
        _buildSponsorRequestCard(
          'PepsiCo India',
          'Www.Pepsico.Com',
          'Rajesh Khanna',
          'Marketing Manager',
          'Cricket',
          'Bill Board',
          'accepted',
        ),
        const SizedBox(height: 12),
        _buildSponsorRequestCard(
          'PepsiCo India',
          'Www.Pepsico.Com',
          'Rajesh Khanna',
          'Marketing Manager',
          'Cricket',
          'Bill Board',
          'rejected',
        ),
        const SizedBox(height: 12),
        _buildSponsorRequestCard(
          'PepsiCo India',
          'Www.Pepsico.Com',
          'Rajesh Khanna',
          'Marketing Manager',
          'Cricket',
          'Bill Board',
          'pending',
        ),
      ],
    );
  }

  Widget _buildAttendeesContent() {
    return Column(
      children: [
        _buildAttendeeRequestCard(
          'Aayush Mehta',
          'Aayush@gmail.com',
          '20',
          'Male',
          '+91-XXXXXXXXXX',
          'Nagpur, Maharashtra',
          'accepted',
        ),
        const SizedBox(height: 12),
        _buildAttendeeRequestCard(
          'Aayush Mehta',
          'Aayush@gmail.com',
          '20',
          'Male',
          '+91-XXXXXXXXXX',
          'Nagpur, Maharashtra',
          'accepted',
        ),
        const SizedBox(height: 12),
        _buildAttendeeRequestCard(
          'Aayush Mehta',
          'Aayush@gmail.com',
          '20',
          'Male',
          '+91-XXXXXXXXXX',
          'Nagpur, Maharashtra',
          'accepted',
        ),
        const SizedBox(height: 12),
        _buildAttendeeRequestCard(
          'Aayush Mehta',
          'Aayush@gmail.com',
          '20',
          'Male',
          '+91-XXXXXXXXXX',
          'Nagpur, Maharashtra',
          'rejected',
        ),
        const SizedBox(height: 12),
        _buildAttendeeRequestCard(
          'Aayush Mehta',
          'Aayush@gmail.com',
          '20',
          'Male',
          '+91-XXXXXXXXXX',
          'Nagpur, Maharashtra',
          'pending',
        ),
      ],
    );
  }

  Widget _buildTeamRequestCard(
    String teamName,
    String email,
    String contactName,
    String phone,
    String role,
    String location,
    String status,
    String actionType,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            // Mobile layout - stacked
            return Column(
              children: [
                Row(
                  children: [
                    _buildCricketIcon(),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            teamName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          Text(
                            email,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          Row(
                            children: List.generate(
                              5,
                              (index) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildContactDetails(contactName, phone, role, location),
                const SizedBox(height: 12),
                _buildActionButtons(status, actionType),
              ],
            );
          } else {
            // Desktop layout - horizontal
            return Row(
              children: [
                _buildCricketIcon(),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        teamName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      Text(
                        email,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      Row(
                        children: List.generate(
                          5,
                          (index) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _buildContactDetails(
                    contactName,
                    phone,
                    role,
                    location,
                  ),
                ),
                _buildActionButtons(status, actionType),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildCoachRequestCard(
    String name,
    String email,
    String experience,
    String gender,
    String certification,
    String specialization,
    String actionType,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            // Mobile layout - stacked
            return Column(
              children: [
                Row(
                  children: [
                    _buildCoachAvatar(),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          Text(
                            email,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          Row(
                            children: List.generate(
                              5,
                              (index) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildCoachDetails(
                  experience,
                  gender,
                  certification,
                  specialization,
                ),
                const SizedBox(height: 12),
                _buildActionButtons('', actionType),
              ],
            );
          } else {
            // Desktop layout - horizontal
            return Row(
              children: [
                _buildCoachAvatar(),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      Text(
                        email,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      Row(
                        children: List.generate(
                          5,
                          (index) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _buildCoachDetails(
                    experience,
                    gender,
                    certification,
                    specialization,
                  ),
                ),
                _buildActionButtons('', actionType),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildPlayerRequestCard(
    String name,
    String email,
    String age,
    String gender,
    String phone,
    String location,
    String actionType,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            // Mobile layout - stacked
            return Column(
              children: [
                Row(
                  children: [
                    _buildPlayerAvatar(),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          Text(
                            email,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          Row(
                            children: List.generate(
                              5,
                              (index) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildPlayerDetails(age, gender, phone, location),
                const SizedBox(height: 12),
                _buildActionButtons('', actionType),
              ],
            );
          } else {
            // Desktop layout - horizontal
            return Row(
              children: [
                _buildPlayerAvatar(),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      Text(
                        email,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      Row(
                        children: List.generate(
                          5,
                          (index) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _buildPlayerDetails(age, gender, phone, location),
                ),
                _buildActionButtons('', actionType),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildSponsorRequestCard(
    String companyName,
    String website,
    String contactName,
    String role,
    String sport,
    String sponsorshipType,
    String actionType,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            // Mobile layout - stacked
            return Column(
              children: [
                Row(
                  children: [
                    _buildSponsorIcon(),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            companyName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          Text(
                            website,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          Row(
                            children: List.generate(
                              5,
                              (index) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildSponsorDetails(contactName, role, sport, sponsorshipType),
                const SizedBox(height: 12),
                _buildActionButtons('', actionType),
              ],
            );
          } else {
            // Desktop layout - horizontal
            return Row(
              children: [
                _buildSponsorIcon(),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        companyName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      Text(
                        website,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      Row(
                        children: List.generate(
                          5,
                          (index) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _buildSponsorDetails(
                    contactName,
                    role,
                    sport,
                    sponsorshipType,
                  ),
                ),
                _buildActionButtons('', actionType),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildAttendeeRequestCard(
    String name,
    String email,
    String age,
    String gender,
    String phone,
    String location,
    String actionType,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            // Mobile layout - stacked
            return Column(
              children: [
                Row(
                  children: [
                    _buildAttendeeAvatar(),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          Text(
                            email,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          Row(
                            children: List.generate(
                              5,
                              (index) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildPlayerDetails(age, gender, phone, location),
                const SizedBox(height: 12),
                _buildActionButtons('', actionType),
              ],
            );
          } else {
            // Desktop layout - horizontal
            return Row(
              children: [
                _buildAttendeeAvatar(),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      Text(
                        email,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      Row(
                        children: List.generate(
                          5,
                          (index) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _buildPlayerDetails(age, gender, phone, location),
                ),
                _buildActionButtons('', actionType),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildCricketIcon() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.red, width: 2),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.sports_cricket, color: Colors.red, size: 20),
          Text(
            'CRICKET',
            style: TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoachAvatar() {
    return const CircleAvatar(
      radius: 25,
      backgroundColor: Colors.blue,
      child: Icon(Icons.person, color: Colors.white, size: 30),
    );
  }

  Widget _buildPlayerAvatar() {
    return const CircleAvatar(
      radius: 25,
      backgroundColor: Colors.green,
      child: Icon(Icons.person, color: Colors.white, size: 30),
    );
  }

  Widget _buildSponsorIcon() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.blue, width: 2),
      ),
      child: const Icon(Icons.public, color: Colors.blue, size: 30),
    );
  }

  Widget _buildAttendeeAvatar() {
    return const CircleAvatar(
      radius: 25,
      backgroundColor: const Color(0xFF414384),
      child: Icon(Icons.person, color: Colors.white, size: 30),
    );
  }

  Widget _buildContactDetails(
    String contactName,
    String phone,
    String role,
    String location,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Contact Person Phone No',
          style: TextStyle(fontSize: 10, color: Colors.grey),
        ),
        Text(
          contactName,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        Text(phone, style: const TextStyle(fontSize: 12)),
        Text(role, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        const SizedBox(height: 8),
        const Text(
          'Location',
          style: TextStyle(fontSize: 10, color: Colors.grey),
        ),
        Text(location, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildCoachDetails(
    String experience,
    String gender,
    String certification,
    String specialization,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow('Experience', experience),
        _buildDetailRow('Gender', gender),
        _buildDetailRow('Certification', certification),
        _buildDetailRow('Specialization', specialization),
      ],
    );
  }

  Widget _buildPlayerDetails(
    String age,
    String gender,
    String phone,
    String location,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow('Age', age),
        _buildDetailRow('Gender', gender),
        _buildDetailRow('Phone No', phone),
        _buildDetailRow('Location', location),
      ],
    );
  }

  Widget _buildSponsorDetails(
    String contactName,
    String role,
    String sport,
    String sponsorshipType,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow('Contact Person', contactName),
        _buildDetailRow('Role', role),
        _buildDetailRow('Sponsored Sport', sport),
        _buildDetailRow('Sponsorship', sponsorshipType),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 12))),
        ],
      ),
    );
  }

  Widget _buildActionButtons(String status, String actionType) {
    if (actionType == 'accepted') {
      return LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            // Mobile - full width button
            return SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  if (status.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        status,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  if (status.isNotEmpty) const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check, color: Colors.white, size: 16),
                        SizedBox(width: 4),
                        Text(
                          'Accepted',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            // Desktop - normal button
            return Column(
              children: [
                if (status.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      status,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                if (status.isNotEmpty) const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check, color: Colors.white, size: 16),
                      SizedBox(width: 4),
                      Text(
                        'Accepted',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      );
    } else if (actionType == 'rejected') {
      return LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            // Mobile - full width button
            return SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  if (status.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        status,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  if (status.isNotEmpty) const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.close, color: Colors.white, size: 16),
                        SizedBox(width: 4),
                        Text(
                          'Rejected',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            // Desktop - normal button
            return Column(
              children: [
                if (status.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      status,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                if (status.isNotEmpty) const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.close, color: Colors.white, size: 16),
                      SizedBox(width: 4),
                      Text(
                        'Rejected',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      );
    } else {
      // pending
      return LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            // Mobile - stack buttons vertically
            return Column(
              children: [
                if (status.isNotEmpty)
                  SizedBox(
                    width: double.infinity,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        status.isEmpty ? 'N/A' : status,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ),
                if (status.isNotEmpty) const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.close, color: Colors.white, size: 16),
                              SizedBox(width: 4),
                              Text(
                                'Reject',
                                style: TextStyle(color: Colors.white, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.check, color: Colors.white, size: 16),
                              SizedBox(width: 4),
                              Text(
                                'Accept',
                                style: TextStyle(color: Colors.white, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          } else {
            // Desktop - horizontal buttons
            return Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status.isEmpty ? 'N/A' : status,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close, color: Colors.white, size: 16),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Accept',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      );
    }
  }

  // FAQ Helper Methods
  Widget _buildSearchAndEntriesControl() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          // Mobile layout - stacked
          return Column(
            children: [
              Row(
                children: [
                  const Text(
                    'Show',
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 60,
                    height: 32,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Center(
                      child: Text(
                        _entriesPerPage.toString(),
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Entries',
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildSearchBar(),
            ],
          );
        } else {
          // Desktop layout - horizontal
          return Row(
            children: [
              const Text(
                'Show',
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
              const SizedBox(width: 8),
              Container(
                width: 60,
                height: 32,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: Text(
                    _entriesPerPage.toString(),
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Entries',
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
              const Spacer(),
              SizedBox(width: 300, child: _buildSearchBar()),
            ],
          );
        }
      },
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: const InputDecoration(
                hintText: 'Search Here',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
            ),
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey[600],
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
            child: const Icon(Icons.search, color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilters() {
    final categories = [
      'All',
      'Subscription',
      'Team',
      'Payment',
      'Coach',
      'Sponsor',
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.asMap().entries.map((entry) {
          final index = entry.key;
          final category = entry.value;
          final isSelected = _selectedFAQCategory == index;

          return GestureDetector(
            onTap: () => setState(() => _selectedFAQCategory = index),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? Colors.blue : Colors.grey[300]!,
                ),
              ),
              child: Text(
                category,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : Colors.black87,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFAQItemsList() {
    final faqItems = _getFAQItems();

    return Column(
      children: faqItems.map((item) {
        final index = faqItems.indexOf(item);
        final isExpanded = _expandedFAQItems[index] ?? false;

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            children: [
              GestureDetector(
                onTap: () => setState(() {
                  _expandedFAQItems[index] = !isExpanded;
                }),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      // Category Tag
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          item['category']!,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Question
                      Expanded(
                        child: Text(
                          item['question']!,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      // Expand/Collapse Icon
                      Icon(
                        isExpanded ? Icons.close : Icons.add,
                        color: Colors.grey[600],
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
              if (isExpanded)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Text(
                    item['answer']!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black87,
                      height: 1.4,
                    ),
                  ),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAddFAQButton() {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () => _showFAQSubmissionForm(),
        icon: const Icon(Icons.add, size: 20),
        label: const Text('Add FAQ'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  List<Map<String, String>> _getFAQItems() {
    final allItems = [
      {
        'category': 'Subscription',
        'question': 'How Do I Subscribe To A Team Or Event?',
        'answer':
            'Go To The "Teams" Or "Events" Section, Choose The One You\'re Interested In, And Click The "Subscribe" Button. Complete The Form And Payment To Confirm.',
      },
      {
        'category': 'Team & Player',
        'question': 'Can I Switch Teams After Joining One?',
        'answer':
            'Yes, you can switch teams before the tournament starts. Contact the tournament organizer for assistance with team transfers.',
      },
      {
        'category': 'Subscription',
        'question': 'What Payment Methods Are Accepted?',
        'answer':
            'We accept all major credit cards, debit cards, and digital payment methods like PayPal and Google Pay.',
      },
      {
        'category': 'Payment',
        'question': 'Can I Get A Refund If I Cancel?',
        'answer':
            'Refunds are available up to 48 hours before the tournament starts. A small processing fee may apply.',
      },
      {
        'category': 'Coach',
        'question': 'How Do I Become A Coach?',
        'answer':
            'Submit your coaching application through the "Become A Coach" section. Include your credentials and experience.',
      },
      {
        'category': 'Sponsor',
        'question': 'How Can My Company Sponsor This Event?',
        'answer':
            'Contact our sponsorship team through the "Sponsor" section. We offer various sponsorship packages.',
      },
    ];

    // Filter by category
    List<Map<String, String>> filteredItems = allItems;
    if (_selectedFAQCategory > 0) {
      final selectedCategory = [
        'All',
        'Subscription',
        'Team',
        'Payment',
        'Coach',
        'Sponsor',
      ][_selectedFAQCategory];
      filteredItems = allItems
          .where(
            (item) =>
                item['category']!.toLowerCase().contains(
                  selectedCategory.toLowerCase(),
                ) ||
                (selectedCategory == 'Team' &&
                    item['category'] == 'Team & Player'),
          )
          .toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filteredItems = filteredItems
          .where(
            (item) =>
                item['question']!.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ) ||
                item['answer']!.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ),
          )
          .toList();
    }

    return filteredItems.take(_entriesPerPage).toList();
  }

  void _showFAQSubmissionForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  const Text(
                    'FAQ',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            // Form
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Select Category
                    const Text(
                      'Select Category',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedCategory,
                          isExpanded: true,
                          items:
                              [
                                    'Subscription',
                                    'Team',
                                    'Payment',
                                    'Coach',
                                    'Sponsor',
                                  ]
                                  .map(
                                    (category) => DropdownMenuItem(
                                      value: category,
                                      child: Text(category),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (value) =>
                              setState(() => _selectedCategory = value!),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Your Question
                    const Text(
                      'Your Question',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Rich Text Editor (Simplified)
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          // Toolbar
                          Container(
                            padding: const EdgeInsets.all(8),
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
                                children: [
                                  _buildToolbarButton(Icons.format_bold),
                                  _buildToolbarButton(Icons.format_italic),
                                  _buildToolbarButton(Icons.format_underlined),
                                  _buildToolbarButton(
                                    Icons.format_strikethrough,
                                  ),
                                  const SizedBox(width: 8),
                                  _buildToolbarButton(Icons.format_align_left),
                                  _buildToolbarButton(
                                    Icons.format_align_center,
                                  ),
                                  _buildToolbarButton(Icons.format_align_right),
                                  _buildToolbarButton(
                                    Icons.format_align_justify,
                                  ),
                                  const SizedBox(width: 8),
                                  _buildToolbarButton(
                                    Icons.format_list_bulleted,
                                  ),
                                  _buildToolbarButton(
                                    Icons.format_list_numbered,
                                  ),
                                  const SizedBox(width: 8),
                                  _buildToolbarButton(Icons.link),
                                  _buildToolbarButton(Icons.image),
                                  _buildToolbarButton(Icons.videocam),
                                  _buildToolbarButton(Icons.attach_file),
                                ],
                              ),
                            ),
                          ),
                          // Text Input
                          Expanded(
                            child: TextField(
                              controller: _questionController,
                              maxLines: null,
                              decoration: const InputDecoration(
                                hintText: 'Input Text',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    // Submit Button
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle submit
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('FAQ submitted successfully!'),
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
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Submit'),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolbarButton(IconData icon) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 32,
        height: 32,
        margin: const EdgeInsets.only(right: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Icon(icon, size: 16, color: Colors.grey[600]),
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
              child: Text(
                'Payment Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: _buildUserTypeButton('FREE USER', _userType == 'FREE USER', () {
                    setModalState(() {
                      _userType = 'FREE USER';
                    });
                  }),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildUserTypeButton('PRIVILEGE USER', _userType == 'PRIVILEGE USER', () {
                    setModalState(() {
                      _userType = 'PRIVILEGE USER';
                    });
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
                    decoration: BoxDecoration(
                      color: Colors.lightBlue.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Payment Details',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildEventSection(),
                  const SizedBox(height: 24),
                  _buildTotalPaymentsSection(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
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
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(color: Colors.grey.shade400),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
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
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
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
          border: Border.all(
            color: isSelected ? Colors.grey.shade400 : Colors.transparent,
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.black87 : Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
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
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: const Text('1 Slot'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
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
                child: Text(
                  amount == 0 ? '-' : amount.toInt().toString(),
                  style: const TextStyle(color: Colors.black87, fontSize: 13, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
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
              color: Colors.grey.shade800,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
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
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, -2))],
            ),
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
                    child: const Text('CANCEL', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Payment processed successfully')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
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
      decoration: BoxDecoration(
        color: Colors.lightBlue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.lightBlue.shade200, style: BorderStyle.solid),
      ),
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
                  child: const Center(
                    child: Text('Total Amount To Pay', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Text(
                    'USD ${_totalIncludingTax.toInt()}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF232534)),
                    textAlign: TextAlign.center,
                  ),
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
      decoration: BoxDecoration(
        color: Colors.lightBlue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.lightBlue.shade200, style: BorderStyle.solid),
      ),
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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onToggle,
            child: Container(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(icon, size: 20, color: Colors.grey.shade700),
                      const SizedBox(width: 8),
                      Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF232534))),
                    ],
                  ),
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
              Row(
                children: [
                  _buildCardIcon('VISA'),
                  const SizedBox(width: 4),
                  _buildCardIcon('MC'),
                  const SizedBox(width: 4),
                  _buildCardIcon('DISCOVER'),
                  const SizedBox(width: 4),
                  _buildCardIcon('AMEX'),
                ],
              ),
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
          const Text('https://www.paypal.com/paypalme/sekaiichikk',
              style: TextStyle(color: Colors.blue, fontSize: 12, decoration: TextDecoration.underline)),
          const SizedBox(height: 12),
          const Text('Send Payment To Paypal ID', style: TextStyle(fontSize: 12, color: Color(0xFF232534))),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
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
          const Text('https://www.zelle.com/zelleme/sekaiichikk',
              style: TextStyle(color: Colors.blue, fontSize: 12, decoration: TextDecoration.underline)),
          const SizedBox(height: 12),
          const Text('Send Payment To Zelle ID', style: TextStyle(fontSize: 12, color: Color(0xFF232534))),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
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
      decoration: BoxDecoration(
        color: Colors.lightBlue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.lightBlue.shade200, style: BorderStyle.solid),
      ),
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
      child: Center(
        child: Text(
          cardType.substring(0, 1),
          style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.grey.shade700),
        ),
      ),
    );
  }
}
