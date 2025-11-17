import 'package:flutter/material.dart';
import '../../core/repositories/auth_repository.dart';
import '../../core/models/api_models.dart';
import '../../core/exceptions/api_exception.dart';
import '../../core/services/storage_service.dart';
import 'payment_method_page.dart';

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
  bool _isSubmitting = false;
  bool _isLoadingServices = false;
  List<PaidService> _paidServices = [];
  String? _errorMessage;

  // Privilege services and totals - dynamically populated from API
  final Map<String, bool> _selectedServices = {};

  // Selected clubs for Priority Booking
  final Set<int> _selectedClubIds = {};
  
  // Fetched clubs data
  List<MemberPreferredClub> _clubs = [];
  bool _isLoadingClubs = false;
  String? _clubsError;

  double get _totalAmount {
    double total = 0;
    for (var service in _paidServices) {
      final serviceKey = _getServiceKey(service.name);
      if (_selectedServices[serviceKey] == true) {
        total += service.amountValue;
      }
    }
    return total;
  }

  /// Map service name to key for selectedServices map
  String _getServiceKey(String serviceName) {
    final normalized = serviceName.toLowerCase()
        .replaceAll(' ', '_')
        .replaceAll('&', '')
        .replaceAll('(', '')
        .replaceAll(')', '');
    
    if (normalized.contains('priority_booking') || normalized.contains('priority booking')) {
      return 'priority_booking';
    } else if (normalized.contains('avail_discounts') || normalized.contains('avail discounts')) {
      return 'avail_discounts';
    } else if (normalized.contains('coach_ratings') || normalized.contains('coach ratings')) {
      return 'coach_ratings';
    } else if (normalized.contains('events') || normalized.contains('tournaments')) {
      return 'events_tournaments';
    } else if (normalized.contains('forum')) {
      return 'forum';
    } else if (normalized.contains('slack')) {
      return 'slack';
    }
    
    return normalized;
  }

  /// Fetch paid services from API
  Future<void> _fetchPaidServices() async {
    if (_isLoadingServices) return;

    setState(() {
      _isLoadingServices = true;
      _errorMessage = null;
    });

    try {
      final response = await _authRepository.getPaidServicesList('member');
      
      if (mounted) {
        setState(() {
          _paidServices = response.data.where((service) => service.isDeleted == 0).toList();
          for (var service in _paidServices) {
            final key = _getServiceKey(service.name);
            if (!_selectedServices.containsKey(key)) {
              _selectedServices[key] = false;
            }
          }
          _isLoadingServices = false;
        });
      }
    } on ApiException catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.message;
          _isLoadingServices = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to load services: ${e.toString()}';
          _isLoadingServices = false;
        });
      }
    }
  }

  /// Fetch member preferred clubs when Priority Booking is selected
  Future<void> _fetchClubs() async {
    if (_isLoadingClubs) return;

    setState(() {
      _isLoadingClubs = true;
      _clubsError = null;
    });

    try {
      // Get user_id from storage
      final userIdString = await _storageService.getString('user_id');
      if (userIdString == null || userIdString.isEmpty) {
        throw Exception('User ID not found');
      }
      final userId = int.tryParse(userIdString);
      if (userId == null) {
        throw Exception('Invalid user ID');
      }

      final response = await _authRepository.getMemberPreferredClubs(userId);
      
      if (mounted) {
        setState(() {
          _clubs = response.data.data;
          _isLoadingClubs = false;
        });
      }
    } on ApiException catch (e) {
      if (mounted) {
        setState(() {
          _clubsError = e.message;
          _isLoadingClubs = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _clubsError = 'Failed to load clubs: ${e.toString()}';
          _isLoadingClubs = false;
        });
      }
    }
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
                    // Fetch paid services when privilege membership is selected
                    if (_paidServices.isEmpty && !_isLoadingServices) {
                      _fetchPaidServices();
                    }
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

          if (_isLoadingServices)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: CircularProgressIndicator(),
              ),
            )
          else if (_errorMessage != null)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text(
                      _errorMessage!,
                      style: TextStyle(color: Colors.red[700]),
                    ),
                    TextButton(
                      onPressed: _fetchPaidServices,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            )
          else if (_paidServices.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text('No paid services available'),
              ),
            )
          else ...[
            // Build service options dynamically from API
            ..._paidServices.map((service) {
              final serviceKey = _getServiceKey(service.name);
              final hasClubTypes = serviceKey == 'priority_booking';
              
              return _buildServiceOption(
                serviceKey,
                service.name,
                (service.description2?.isNotEmpty == true) 
                    ? service.description2! 
                    : (service.description1 ?? ''),
                service.amountValue,
                hasClubTypes: hasClubTypes,
              );
            }),

            const SizedBox(height: 16),
            _buildPricingSummary(),
          ],
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
    final isSelected = _selectedServices[key] ?? false;
    
    return InkWell(
      onTap: () {
        setState(() {
          final wasSelected = isSelected;
          _selectedServices[key] = !isSelected;
          // Fetch clubs when Priority Booking is being selected (toggled from false to true)
          if (key == 'priority_booking' && !wasSelected && _clubs.isEmpty && !_isLoadingClubs) {
            _fetchClubs();
          }
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? const Color(0xFF8BB6D9) : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? const Color(0xFF8BB6D9).withOpacity(0.05) : Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon
                _getServiceIcon(key),
                const SizedBox(width: 12),
                // Title and Description
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E293B),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
                          height: 1.4,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Price Section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'Monthly Fee',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'USD ${price.toInt()}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // Selected indicator
            if (isSelected)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: const Color(0xFF8BB6D9),
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Selected',
                      style: TextStyle(
                        fontSize: 12,
                        color: const Color(0xFF8BB6D9),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            if (hasClubTypes && isSelected) ...[
              const SizedBox(height: 16),
              if (_isLoadingClubs)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (_clubsError != null)
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, size: 16, color: Colors.red[700]),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _clubsError!,
                          style: TextStyle(fontSize: 12, color: Colors.red[700]),
                        ),
                      ),
                      TextButton(
                        onPressed: _fetchClubs,
                        child: const Text('Retry', style: TextStyle(fontSize: 12)),
                      ),
                    ],
                  ),
                )
              else if (_clubs.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'No clubs available',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                )
              else
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ..._clubs.map((club) => _buildClubChip(club)),
                  ],
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildClubChip(MemberPreferredClub club) {
    final isSelected = _selectedClubIds.contains(club.clubId);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedClubIds.remove(club.clubId);
          } else {
            _selectedClubIds.add(club.clubId);
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
          club.clubName,
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
    
    final normalizedKey = key.toLowerCase();
    
    if (normalizedKey.contains('priority_booking') || normalizedKey.contains('priority booking')) {
      icon = Icons.calendar_today;
      color = Colors.green;
    } else if (normalizedKey.contains('avail_discounts') || normalizedKey.contains('avail discounts')) {
      icon = Icons.local_offer;
      color = Colors.red;
    } else if (normalizedKey.contains('coach_ratings') || normalizedKey.contains('coach ratings')) {
      icon = Icons.star;
      color = Colors.orange;
    } else if (normalizedKey.contains('events') || normalizedKey.contains('tournaments')) {
      icon = Icons.emoji_events;
      color = Colors.amber;
    } else if (normalizedKey.contains('forum')) {
      icon = Icons.forum;
      color = Colors.blue;
    } else if (normalizedKey.contains('slack')) {
      icon = Icons.notifications;
      color = Colors.purple;
    } else {
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
              onPressed: _isSubmitting ? null : () async {
                if (_isFreeMembership) {
                  await _submitFreeMembership();
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
              child: _isSubmitting && _isFreeMembership
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      'Submit',
                      style: TextStyle(
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

  Future<void> _submitFreeMembership() async {
    if (_isSubmitting) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      await _authRepository.chooseMembershipType('Free');
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Free membership activated'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit membership: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
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
