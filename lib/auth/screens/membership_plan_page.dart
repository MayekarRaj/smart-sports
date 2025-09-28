import 'package:flutter/material.dart';
import 'payment_method_page.dart';

class MembershipPlanPage extends StatefulWidget {
  const MembershipPlanPage({super.key});

  @override
  State<MembershipPlanPage> createState() => _MembershipPlanPageState();
}

class _MembershipPlanPageState extends State<MembershipPlanPage> {
  bool _isFreeMembership = true;
  final Map<String, bool> _selectedServices = {
    'priority_booking': false,
    'avail_discounts': false,
    'coach_ratings': false,
    'events_tournaments': false,
    'forum': false,
    'slack': false,
  };

  double get _totalAmount {
    double total = 0;
    if (_selectedServices['priority_booking'] == true) total += 200;
    if (_selectedServices['avail_discounts'] == true) total += 100;
    if (_selectedServices['coach_ratings'] == true) total += 100;
    if (_selectedServices['events_tournaments'] == true) total += 200;
    if (_selectedServices['forum'] == true) total += 100;
    if (_selectedServices['slack'] == true) total += 100;
    return total;
  }

  double get _discountAmount => 20;
  double get _referralDiscount => 80;
  double get _grandTotal => _totalAmount - _discountAmount - _referralDiscount;
  double get _taxAmount => _grandTotal * 0.10;
  double get _finalAmount => _grandTotal + _taxAmount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: const Text(
          '💎 Membership Plans',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Membership Type Selection
            _buildMembershipTypeSelection(),
            const SizedBox(height: 20),

            // Free Membership Benefits
            if (_isFreeMembership) _buildFreeMembershipBenefits(),

            // Premium Services
            if (!_isFreeMembership) _buildPremiumServices(),

            // Pricing Summary (only for premium)
            if (!_isFreeMembership) _buildPricingSummary(),

            const SizedBox(height: 32),

            // Bottom Navigation
            _buildBottomNavigation(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildMembershipTypeSelection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isFreeMembership = true;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: _isFreeMembership
                          ? Colors.grey[300]
                          : Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        bottomLeft: _isFreeMembership
                            ? Radius.zero
                            : const Radius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'FREE MEMBERSHIP',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isFreeMembership = false;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: !_isFreeMembership ? Colors.black : Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: const Radius.circular(16),
                        bottomRight: !_isFreeMembership
                            ? Radius.zero
                            : const Radius.circular(16),
                      ),
                    ),
                    child: Text(
                      'PRIVILEGE MEMBERSHIP',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: !_isFreeMembership
                            ? Colors.white
                            : Colors.black87,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFreeMembershipBenefits() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'With Free Membership, You Will Continue To Use Our Following Services.',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 20),

          ..._buildBenefitsList([
            'Select Your Employer And Use Corporate Health Benefits',
            'Check Club Ratings And Reviews',
            'Reserve Your Court For Any Sport Clubs',
            'Receive Events And Tournaments Information\'s',
            'Find A Coach Available For The Club',
            'Track Your Utilization Records With Financial Investments',
            'Find Merchandisers Or Freelancer For Your Sport Utilities/Accessories.',
            'Readable Access To The Forum Discussion',
          ], Colors.black87),

          const SizedBox(height: 20),

          const Text(
            'With Free Membership, You Will Be Missing Our Following Services, However You Will Avail First XX Days Of Free Trial For All * Indicated Services.',
            style: TextStyle(fontSize: 14, color: Colors.red),
          ),
          const SizedBox(height: 16),

          ..._buildPremiumFeaturesList(),
        ],
      ),
    );
  }

  Widget _buildPremiumServices() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF8BB6D9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Optional Paid Services',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 20),

          _buildServiceOption(
            'priority_booking',
            'Priority Booking',
            'You Will Be Allowed To Avail Priority Booking Slots For Your Preferred Clubs Selected @ USD 50 /Club.',
            200,
            ['Tennis Club', 'Baseball', 'Cricket', 'Basketball'],
          ),

          _buildServiceOption(
            'avail_discounts',
            'Avail Discounts',
            'You Will Be Able To Unlock Coach Ratings To Select Your Coach',
            100,
            null,
          ),

          _buildServiceOption(
            'coach_ratings',
            'Coach Ratings',
            'You Will Be Able To Unlock Coach Ratings To Select Your Coach',
            100,
            null,
          ),

          _buildServiceOption(
            'events_tournaments',
            'Events & Tournaments',
            'You will be allowed to schedule multiple events and tournaments',
            200,
            null,
          ),

          _buildServiceOption(
            'forum',
            'Forum',
            'You Will Have Access To All Forum Discussions Within Our Platform And Able To Save Stories With Photos.',
            100,
            null,
          ),

          _buildServiceOption(
            'slack',
            'Slack',
            'Automatic Mobile Notifications Per Month. You Will Get Email And Mobile Notification Of Our Various Services',
            100,
            null,
          ),
        ],
      ),
    );
  }

  Widget _buildServiceOption(
    String key,
    String title,
    String description,
    double price,
    List<String>? tags,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Checkbox(
                value: _selectedServices[key],
                onChanged: (value) {
                  setState(() {
                    _selectedServices[key] = value!;
                  });
                },
                activeColor: const Color(0xFF8BB6D9),
              ),
              const SizedBox(width: 8),
              _getServiceIcon(key),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (tags != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'You Will Be Allowed To Avail Priority Booking Slots For Your Preferred Clubs Selected @ USD 50 /Club.',
                        style: TextStyle(fontSize: 12, color: Colors.red[400]),
                      ),
                    ],
                  ],
                ),
              ),
              Column(
                children: [
                  const Text(
                    'Monthly Fee',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Text(
                    'USD ${price.toInt()}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (tags != null) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: tags
                  .map(
                    (tag) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        tag,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _getServiceIcon(String key) {
    IconData icon;
    Color color;

    switch (key) {
      case 'priority_booking':
        icon = Icons.calendar_today;
        color = Colors.green;
        break;
      case 'avail_discounts':
        icon = Icons.local_offer;
        color = Colors.red;
        break;
      case 'coach_ratings':
        icon = Icons.star;
        color = Colors.orange;
        break;
      case 'events_tournaments':
        icon = Icons.emoji_events;
        color = Colors.amber;
        break;
      case 'forum':
        icon = Icons.forum;
        color = Colors.blue;
        break;
      case 'slack':
        icon = Icons.notifications;
        color = Colors.purple;
        break;
      default:
        icon = Icons.help;
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }

  Widget _buildPricingSummary() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildPriceRow(
            'NET TOTAL AMOUNT TO PAY:',
            _totalAmount,
            Colors.grey[800]!,
            false,
          ),
          _buildPriceRow('DISCOUNT AMOUNT:', _discountAmount, Colors.red, true),
          _buildPriceRow(
            'DISCOUNT FOR REFERRAL:',
            _referralDiscount,
            Colors.red,
            true,
          ),
          _buildPriceRow(
            'GRAND TOTAL AMOUNT TO PAY:',
            _grandTotal,
            Colors.grey[800]!,
            false,
          ),
          _buildPriceRow(
            'CONSUMPTION TAX AMOUNT (10%):',
            _taxAmount,
            Colors.grey[800]!,
            false,
          ),
          _buildPriceRow(
            'TOTAL AMOUNT INCLUDING TAX:',
            _finalAmount,
            Colors.green,
            false,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(
    String label,
    double amount,
    Color color,
    bool isDiscount, {
    bool isLast = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: color == Colors.green
            ? Colors.green
            : (color == Colors.red ? Colors.red : Colors.grey[800]),
        borderRadius: isLast
            ? const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              )
            : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            '${isDiscount ? '-' : ''}USD ${amount.toInt()}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildBenefitsList(List<String> benefits, Color color) {
    return benefits
        .map(
          (benefit) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '• ',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: Text(
                    benefit,
                    style: TextStyle(fontSize: 14, color: color, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
        )
        .toList();
  }

  List<Widget> _buildPremiumFeaturesList() {
    final features = [
      {
        'icon': Icons.calendar_today,
        'title': 'Priority Booking Slot For Designated Clubs',
        'subtitle':
            'You Can Only Get Bookings For Available Slots. However, We Also Have Reserved Slots For Paid Members Where Priority Is Given To The Business Users Only.',
        'color': Colors.green,
      },
      {
        'icon': Icons.local_offer,
        'title': 'Special Discounts On Court Bookings & Avail Sponsorship',
        'subtitle':
            'Club Offered Special Discounts Will Be Available For The Court Booking. You Can Also Avail Any Sponsorship If Available.',
        'color': Colors.red,
      },
      {
        'icon': Icons.star,
        'title': 'Unlock Coach Ratings',
        'subtitle':
            'You Will Be Able To Unlock Coach Ratings To Select Your Preferred Coach.',
        'color': Colors.orange,
      },
      {
        'icon': Icons.emoji_events,
        'title': 'Scheduling Events & Tournaments & Avail Sponsorship',
        'subtitle':
            'You will be able to schedule events and tournaments, avail sponsorship if available and promote the same to all members, corporate, coaches and merchandisers.',
        'color': Colors.amber,
      },
      {
        'icon': Icons.forum,
        'title': 'Forum Discussion',
        'subtitle':
            'We Have Forum Discussion In The Platform Which Is Only Accessible To The Business Users. Moreover, Your Club Stories Like Tournaments, Group Play, Match Results Etc With Photographs Can Only Be Stored With Business User Membership.',
        'color': Colors.blue,
      },
      {
        'icon': Icons.notifications,
        'title': 'Slack Mobile Notifications',
        'subtitle':
            'Various Alerts Like Your Booking, Tournaments, Etc Can Be Received With The Business User Membership Only.',
        'color': Colors.purple,
      },
    ];

    return features
        .map(
          (feature) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (feature['color'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    feature['icon'] as IconData,
                    color: feature['color'] as Color,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              feature['title'] as String,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const Text(
                            '*',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        feature['subtitle'] as String,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
        .toList();
  }

  Widget _buildBottomNavigation() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                side: const BorderSide(color: Colors.grey),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                side: const BorderSide(color: Colors.grey),
              ),
              child: const Text(
                'Back',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                if (_isFreeMembership) {
                  // Complete registration for free membership
                  _showRegistrationComplete();
                } else {
                  // Navigate to payment for premium membership
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PaymentMethodPage(amount: _finalAmount),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                _isFreeMembership ? 'Submit' : 'Next',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showRegistrationComplete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Registration Complete!'),
        content: const Text(
          'Your free membership has been activated successfully.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
