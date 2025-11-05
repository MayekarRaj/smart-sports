import 'package:flutter/material.dart';
import 'payment_method_page.dart';

class CoachMembershipPlanPage extends StatefulWidget {
  const CoachMembershipPlanPage({super.key});

  @override
  State<CoachMembershipPlanPage> createState() => _CoachMembershipPlanPageState();
}

class _CoachMembershipPlanPageState extends State<CoachMembershipPlanPage> {
  bool _isFreeMembership = true;

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
              begin: Alignment.topLeft, end: Alignment.bottomRight,
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
          '👨‍🏫 Coach Membership Plans',
          style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700),
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
                  onTap: () { setState(() { _isFreeMembership = true; }); },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: _isFreeMembership ? Colors.grey[300] : Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        bottomLeft: _isFreeMembership ? Radius.zero : const Radius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'FREE MEMBERSHIP',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () { setState(() { _isFreeMembership = false; }); },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: !_isFreeMembership ? Colors.black : Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: const Radius.circular(16),
                        bottomRight: !_isFreeMembership ? Radius.zero : const Radius.circular(16),
                      ),
                    ),
                    child: Text(
                      'PRIVILEGE MEMBERSHIP',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: !_isFreeMembership ? Colors.white : Colors.black87,
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
            'With Free Coach Membership, you will continue to use our following services:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.green),
          ),
          const SizedBox(height: 18),
          Padding(
            padding: const EdgeInsets.only(left: 2.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                _BenefitRow(text: 'Access basic player community'),
                _BenefitRow(text: 'Respond to coaching requests'),
                _BenefitRow(text: 'Browse public tournaments & match events'),
                _BenefitRow(text: 'Gain visibility with basic coach listing'),
              ],
            ),
          ),
          const SizedBox(height: 22),
          const Text(
            'With Free Coach Membership, you will be missing these extra services,\nHowever you will get XX days free trial for all * features.',
            style: TextStyle(fontSize: 14, color: Colors.red, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 14),
          CoachMobileMissingServicesList(),
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
              'Coach Paid Membership Includes:',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 20),
          // ...put premium features for coach here...
          _BenefitRow(text: 'Access to all potential student leads'),
          _BenefitRow(text: 'List as verified professional coach'),
          _BenefitRow(text: 'In-app calendar & advanced scheduling tools'),
          _BenefitRow(text: 'Direct message premium club admins'),
          _BenefitRow(text: 'Participate in private tournaments & events'),
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
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                side: const BorderSide(color: Colors.grey),
              ),
              child: const Text('Cancel', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                side: const BorderSide(color: Colors.grey),
              ),
              child: const Text('Back', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey)),
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
                      builder: (context) => const PaymentMethodPage(amount: 0),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: Text(_isFreeMembership ? 'Submit' : 'Next', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
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

class CoachMobileMissingServicesList extends StatelessWidget {
  const CoachMobileMissingServicesList({super.key});
  @override
  Widget build(BuildContext context) {
    final List<_MobileMissingService> missing = [
      _MobileMissingService(
        emoji: '🧑‍🎓',
        name: 'Invite-Only Player Connections',
        description: 'Get matched to verified, active players and connect within the app.',
        hasTrial: true,
      ),
      _MobileMissingService(
        emoji: '🔔',
        name: 'Push & Email Notifications',
        description: 'Stay updated on player requests, tournament openings and schedule changes via direct notifications.',
        hasTrial: true,
      ),
      _MobileMissingService(
        emoji: '💼',
        name: 'Coach Portfolio Tools',
        description: 'Showcase certificates, endorsements, and personalized training achievements.',
      ),
      _MobileMissingService(
        emoji: '👩‍🏫',
        name: 'Listed in Pro Coach Search',
        description: 'Be featured as a verified coach when clubs or players are looking to book lessons.',
      ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(missing.length, (i) {
        final item = missing[i];
        return Container(
          margin: EdgeInsets.only(bottom: 15),
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
                              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Colors.black),
                              children: [
                                if (item.hasTrial)
                                  const TextSpan(
                                    text: ' *',
                                    style: TextStyle(color: Colors.red, fontSize: 17, fontWeight: FontWeight.w700),
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
              )
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
