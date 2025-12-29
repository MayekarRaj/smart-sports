import 'package:flutter/material.dart';
import 'payment_method_page.dart';
import '../../core/repositories/auth_repository.dart';
import '../../core/exceptions/api_exception.dart';
import '../../core/models/api_models.dart';
import '../../core/services/storage_service.dart';
import '../../role_specific/common/role_router.dart';

class MemberMembershipPlanPage extends StatefulWidget {
  const MemberMembershipPlanPage({super.key});
  @override
  State<MemberMembershipPlanPage> createState() =>
      _MemberMembershipPlanPageState();
}

class _MemberMembershipPlanPageState extends State<MemberMembershipPlanPage> {
  bool _isFreeMembership = true;
  final AuthRepository _authRepository = AuthRepository();
  final StorageService _storageService = StorageService();
  bool _isLoadingServices = false;
  List<PaidService> _paidServices = [];

  // Privilege services and totals
  final Map<String, bool> _selectedServices = {
    'priority_booking': false,
    'avail_discounts': false,
    'coach_ratings': false,
    'events_tournaments': false,
    'forum': false,
    'slack': false,
  };

  @override
  void initState() {
    super.initState();
    // Fetch services to get their IDs
    _fetchPaidServices();
  }

  /// Fetch paid services from API to get service IDs
  Future<void> _fetchPaidServices() async {
    if (_isLoadingServices) return;

    setState(() {
      _isLoadingServices = true;
    });

    try {
      final response = await _authRepository.getPaidServicesList('member');
      
      if (mounted) {
        setState(() {
          _paidServices = response.data.where((service) => service.isDeleted == 0).toList();
          _isLoadingServices = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingServices = false;
        });
        // Silently fail - we'll use hardcoded mapping if API fails
      }
    }
  }

  /// Map service key to service ID
  int? _getServiceId(String serviceKey) {
    final serviceNameMap = {
      'priority_booking': 'Priority Booking',
      'avail_discounts': 'Avail Discounts',
      'coach_ratings': 'Coach Ratings',
      'events_tournaments': 'Events & Tournaments',
      'forum': 'Forum',
      'slack': 'Slack',
    };

    final serviceName = serviceNameMap[serviceKey];
    if (serviceName != null) {
      final service = _paidServices.firstWhere(
        (s) => s.name.toLowerCase().contains(serviceName.toLowerCase()),
        orElse: () => _paidServices.first,
      );
      return service.id;
    }
    return null;
  }

  /// Save optional paid services
  Future<void> _saveOptionalPaidServices() async {
    // Get selected service IDs
    final selectedServiceIds = <int>[];
    for (var key in _selectedServices.keys) {
      if (_selectedServices[key] == true) {
        final serviceId = _getServiceId(key);
        if (serviceId != null) {
          selectedServiceIds.add(serviceId);
        }
      }
    }

    if (selectedServiceIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one service'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isLoadingServices = true);

    try {
      final request = SaveOptionalPaidServicesRequest(
        userRole: 'member',
        optionalServicesIds: selectedServiceIds,
      );

      final response = await _authRepository.saveOptionalPaidServices(request);

      if (mounted) {
        setState(() => _isLoadingServices = false);
        
        // Save role to storage if not already saved
        final roleStr = await _storageService.getString('user_role');
        if (roleStr == null || roleStr.isEmpty) {
          await _storageService.saveString('user_role', 'member');
        }
        
        // Extract subscription_id from response (if present)
        final subscriptionId = response.data?['subscription_id']?.toString();
        
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentMethodPage(
              amount: _finalAmount,
              subscriptionId: subscriptionId,
            ),
          ),
        );
      }
    } on ApiException catch (e) {
      if (mounted) {
        setState(() => _isLoadingServices = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save services: ${e.message}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingServices = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save services: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Selected club types for Priority Booking
  final Set<String> _selectedClubTypes = {};

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
          '🧑‍🎾 Member Membership Plans',
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
            'With Free Membership, You Will Continue To Use Our Following Services.',
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
                _BenefitRow(text: 'Select Your Employer And Use Corporate Health Benefits'),
                _BenefitRow(text: 'Check Club Ratings And Reviews'),
                _BenefitRow(text: 'Reserve Your Court For Any Sport Clubs'),
                _BenefitRow(text: 'Receive Events And Tournaments Information\'s'),
                _BenefitRow(text: 'Find A Coach Available For The Club'),
                _BenefitRow(text: 'Track Your Utilization Records With Financial Investments'),
                _BenefitRow(text: 'Find Merchandisers Or Freelancer For Your Sport Utilities/Accessories.'),
                _BenefitRow(text: 'Readable Access To The Forum Discussion'),
              ],
            ),
          ),
          const SizedBox(height: 22),
          const Text(
            'With Free Membership, You Will Be Missing Our Following Services, However You Will Avail First XX Days Of Free Trial For All * Indicated Services.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.red,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 14),
          MemberMobileMissingServicesList(),
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
            hasClubTypes: true,
          ),
          _buildServiceOption(
            'avail_discounts',
            'Avail Discounts',
            'You Will Be Able To Use Special Discounts Offers Provided By Clubs.',
            100,
          ),
          _buildServiceOption(
            'coach_ratings',
            'Coach Ratings',
            'You Will Be Able To Unlock Coach Ratings To Select Your Coach.',
            100,
          ),
          _buildServiceOption(
            'events_tournaments',
            'Events & Tournaments',
            'You will be allowed to schedule multiple events and tournaments.',
            200,
          ),
          _buildServiceOption(
            'forum',
            'Forum',
            'You Will Have Access To All Forum Discussions Within Our Platform And Able To Save Stories With Photos.',
            100,
          ),
          _buildServiceOption(
            'slack',
            'Slack',
            'Automatic Mobile Notifications Per Month: You Will Get Emails And Mobile Notification Of Our Various Services.',
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
    double price, {
    bool hasClubTypes = false,
  }) {
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: _selectedServices[key] ?? false,
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
                children: const [
                  Text(
                    'Monthly Fee',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(width: 8),
              Text(
                'USD ${price.toInt()}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          if (hasClubTypes && (_selectedServices[key] ?? false)) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildClubTypeChip('Tennis Club'),
                _buildClubTypeChip('Baseball'),
                _buildClubTypeChip('Cricket'),
                _buildClubTypeChip('Basketball'),
                IconButton(
                  icon: const Icon(Icons.arrow_drop_down, size: 20),
                  onPressed: () {
                    // Handle dropdown
                  },
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildClubTypeChip(String label) {
    final isSelected = _selectedClubTypes.contains(label);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedClubTypes.remove(label);
          } else {
            _selectedClubTypes.add(label);
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF8BB6D9)
              : Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF8BB6D9)
                : Colors.grey[300]!,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
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
        break;
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
    final bool isGreen = color == Colors.green;
    final bool isRed = color == Colors.red;
    final Color textColor = isGreen
        ? Colors.green
        : (isRed ? Colors.red : Colors.grey[800]!);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
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
                color: textColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Text(
              '${isDiscount ? '-' : ''}USD ${amount.toInt()}',
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
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
              onPressed: () async {
                if (_isFreeMembership) {
                  // Save role to storage if not already saved
                  final roleStr = await _storageService.getString('user_role');
                  if (roleStr == null || roleStr.isEmpty) {
                    await _storageService.saveString('user_role', 'member');
                  }
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Free membership activated'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  
                  // Navigate to member dashboard
                  final dashboard = RoleRouter.dashboardFor(UserRole.member);
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => dashboard),
                    (route) => false, // Remove all previous routes
                  );
                } else {
                  // Save optional paid services before navigating to payment
                  await _saveOptionalPaidServices();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: _isLoadingServices
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
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

class MemberMobileMissingServicesList extends StatelessWidget {
  const MemberMobileMissingServicesList({super.key});
  @override
  Widget build(BuildContext context) {
    final List<_MobileMissingService> missing = [
      _MobileMissingService(
        icon: Icons.calendar_today,
        iconColor: Colors.green,
        name: 'Priority Booking Slot For Designated Clubs',
        description:
            'You Can Only Get Bookings For Available Slots. However, We Also Have Reserved Slots For Paid Members Where Priority Is Given To The Business Users Only.',
        hasTrial: true,
      ),
      _MobileMissingService(
        icon: Icons.local_offer,
        iconColor: Colors.red,
        name: 'Special Discounts On Court Bookings & Avail Sponsorship',
        description:
            'Club Offered Special Discounts Will Be Available For The Court Booking. You Can Also Avail Any Sponsorship If Available.',
        hasTrial: true,
      ),
      _MobileMissingService(
        icon: Icons.star,
        iconColor: Colors.green,
        name: 'Unlock Coach Ratings',
        description:
            'You Will Be Able To Unlock Coach Ratings To Select Your Preferred Coach.',
        hasTrial: false,
      ),
      _MobileMissingService(
        icon: Icons.emoji_events,
        iconColor: Colors.amber,
        name: 'Scheduling Events & Tournaments & Avail Sponsorship',
        description:
            'You will be able to schedule events and tournaments, avail sponsorship\'s if available and promote the same to all members, corporate, coaches and merchandisers.',
        hasTrial: true,
      ),
      _MobileMissingService(
        icon: Icons.forum,
        iconColor: Colors.blue,
        name: 'Forum Discussion',
        description:
            'We Have Forum Discussion In The Platform Which Is Only Accessible To The Business Users. Moreover, Your Club Stories Like Tournaments, Group Play, Match Results Etc With Photographs Can Only Be Stored With Business User Membership.',
        hasTrial: true,
      ),
      _MobileMissingService(
        icon: Icons.notifications,
        iconColor: Colors.purple,
        name: 'Slack Mobile Notifications',
        description:
            'Various Alerts Like Your Booking, Tournaments, Etc Can Be Received With The Business User Membership Only.',
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
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: item.iconColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      item.icon,
                      color: item.iconColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text.rich(
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
                        const SizedBox(height: 5),
                        Text(
                          item.description,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF222E40),
                            height: 1.39,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _MobileMissingService {
  final IconData icon;
  final Color iconColor;
  final String name;
  final String description;
  final bool hasTrial;
  const _MobileMissingService({
    required this.icon,
    required this.iconColor,
    required this.name,
    required this.description,
    this.hasTrial = false,
  });
}
