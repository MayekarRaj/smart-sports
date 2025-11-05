import 'package:flutter/material.dart';
import 'payment_method_page.dart';

class CorporateMembershipPlanPage extends StatefulWidget {
  const CorporateMembershipPlanPage({super.key});
  @override
  State<CorporateMembershipPlanPage> createState() =>
      _CorporateMembershipPlanPageState();
}

class _CorporateMembershipPlanPageState
    extends State<CorporateMembershipPlanPage> {
  bool _isFreeMembership = true;

  // Paid services selection (privilege membership)
  final Map<String, bool> _selectedServices = {
    'coach_ratings': false,
    'events_tournaments': false,
    'forum': false,
    'slack': false,
  };

  double get _totalAmount {
    double total = 0;
    if (_selectedServices['coach_ratings'] == true) total += 100;
    if (_selectedServices['events_tournaments'] == true) total += 200;
    if (_selectedServices['forum'] == true) total += 100;
    if (_selectedServices['slack'] == true) total += 100;
    return total;
  }

  double get _discountAmount => 20;
  double get _referralDiscount => 50;
  double get _grandTotal => _totalAmount - _discountAmount - _referralDiscount;
  double get _taxAmount => (_grandTotal > 0 ? _grandTotal : 0) * 0.10;
  double get _finalAmount => (_grandTotal > 0 ? _grandTotal : 0) + _taxAmount;
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
          '🏢 Corporate Membership Plans',
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
            _buildMembershipTypeSelection(),
            const SizedBox(height: 20),
            if (_isFreeMembership) _buildFreeMembershipBenefits(),
            if (!_isFreeMembership) _buildPremiumServices(),
            const SizedBox(height: 32),
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
            'With Free Corporate Membership, you will continue to use:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 18),
          Padding(
            padding: const EdgeInsets.only(left: 2.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                _BenefitRow(
                  text: 'Access To Clubs Within All Branch Office Localities',
                ),
                _BenefitRow(text: 'Check Club Ratings And Reviews'),
                _BenefitRow(
                  text:
                      'Employees Can Tag Company Followed By The Admin Approval',
                ),
                _BenefitRow(
                  text:
                      'Release Payments On Monthly Basis Directly By Office Finances Or Members Pays Directly Based On The Choice You Have Made At The Time Of Registration',
                ),
                _BenefitRow(
                  text:
                      'Access To Coach For Training And Merchandisers For Promotions',
                ),
                _BenefitRow(text: 'Subscribe To The Events And Tournaments'),
                _BenefitRow(
                  text: 'Access To The Employees Welfare Utilization Dashboard',
                ),
                _BenefitRow(
                  text:
                      'Track Financial Investments On The Health Welfare Program',
                ),
                _BenefitRow(text: 'Readable Access To The Forum Discussion'),
              ],
            ),
          ),
          const SizedBox(height: 22),
          const Text(
            'With Free Corporate Membership, you will lack the following (but get XX days trial for *)',
            style: TextStyle(
              fontSize: 14,
              color: Colors.red,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 14),
          CorporateMobileMissingServicesList(),
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
            'coach_ratings',
            'Coach Ratings',
            'You Will Be Able To Unlock Coach Ratings To Select Your Coach',
            100,
          ),
          _buildServiceOption(
            'events_tournaments',
            'Events & Tournaments',
            'You will be allowed to schedule multiple events and tournaments',
            200,
          ),
          _buildServiceOption(
            'forum',
            'Forum',
            'You Will Have Access To All Forum Discussions And Able To Save Stories With Photos.',
            100,
          ),
          _buildServiceOption(
            'slack',
            'Slack',
            'Automatic Mobile Notifications Per Month. You Will Get Email And Mobile Notification Of Our Various Services',
            100,
          ),

          const SizedBox(height: 16),
          _buildPricingSummary(),
        ],
      ),
    );
  }

  Widget _buildServiceOption(
    String key,
    String title,
    String description,
    double price,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            value: _selectedServices[key],
            onChanged: (value) {
              setState(() {
                _selectedServices[key] = value ?? false;
              });
            },
            activeColor: const Color(0xFF8BB6D9),
          ),
          const SizedBox(width: 4),
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
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(fontSize: 12, color: Colors.red[400]),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
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
    );
  }

  Widget _getServiceIcon(String key) {
    IconData icon;
    Color color;
    switch (key) {
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
      margin: const EdgeInsets.only(top: 8),
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
    final Color bg = color == Colors.green
        ? Colors.green
        : (color == Colors.red ? Colors.red : Colors.grey[800]!);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: bg,
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
              style: const TextStyle(
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Free membership activated'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.of(context).popUntil((route) => route.isFirst);
                } else {
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
}

class _BenefitRow extends StatelessWidget {
  final String text;
  const _BenefitRow({required this.text});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          const Icon(Icons.check, size: 18, color: Colors.green),
          const SizedBox(width: 7),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CorporateMobileMissingServicesList extends StatelessWidget {
  const CorporateMobileMissingServicesList({super.key});
  @override
  Widget build(BuildContext context) {
    final List<_MobileMissingService> missing = [
      _MobileMissingService(
        emoji: '⭐',
        name: 'Unlock Coach Ratings',
        description:
            'You Will Be Able To Unlock Coach Ratings To Select Your Preferred Coach.',
      ),
      _MobileMissingService(
        emoji: '🏆',
        name: 'Scheduling Events & Tournaments & Avail Sponsorship',
        description:
            'You will be able to schedule events and tournaments, avail sponsorship’s if available and promote the same to all members, corporate, coaches and merchandisers.',
        hasTrial: true,
      ),
      _MobileMissingService(
        emoji: '💬',
        name: 'Forum Discussion',
        description:
            'You will be able to post the stories as owner in Forum Discussion, your club stories like Tournaments, group play, match results etc with photographs can be posted.',
        hasTrial: true,
      ),
      _MobileMissingService(
        emoji: '📲',
        name: 'Slack Mobile Notifications',
        description:
            'Various alerts like your Booking, Tournaments, etc can be received with the Business User Membership only.',
        hasTrial: true,
      ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(missing.length, (i) {
        final item = missing[i];
        return Container(
          margin: const EdgeInsets.only(bottom: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.emoji, style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text.rich(
                            TextSpan(
                              text: item.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                                color: Colors.black,
                              ),
                              children: [
                                if (item.hasTrial)
                                  const TextSpan(
                                    text: ' *',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.only(left: 35, right: 2),
                child: Text(
                  item.description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF222E40),
                    height: 1.39,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _MobileMissingService {
  final String emoji;
  final String name;
  final String description;
  final bool hasTrial;
  const _MobileMissingService({
    required this.emoji,
    required this.name,
    required this.description,
    this.hasTrial = false,
  });
}
