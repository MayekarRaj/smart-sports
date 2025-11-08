import 'package:flutter/material.dart';
import '../../core/repositories/auth_repository.dart';
import '../../core/models/api_models.dart';
import '../../core/exceptions/api_exception.dart';
import '../../core/services/storage_service.dart';
import 'payment_method_page.dart';

class ClubMembershipPlanPage extends StatefulWidget {
  const ClubMembershipPlanPage({super.key});

  @override
  State<ClubMembershipPlanPage> createState() => _ClubMembershipPlanPageState();
}

class _ClubMembershipPlanPageState extends State<ClubMembershipPlanPage> {
  bool _isFreeMembership = true;
  final AuthRepository _authRepository = AuthRepository();
  final StorageService _storageService = StorageService();
  bool _isLoadingServices = false;
  bool _isSubmitting = false;
  List<PaidService> _paidServices = [];
  String? _errorMessage;

  // Privilege services and totals - dynamically populated from API
  final Map<String, bool> _selectedServices = {};

  // Selected branches
  final Set<int> _selectedBranchIds = {};
  
  // Fetched data
  List<ClubBranchListItem> _branches = [];
  bool _isLoadingBranches = false;
  String? _branchesError;

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
    
    if (normalized.contains('access_clubs') || normalized.contains('access clubs')) {
      return 'access_clubs';
    } else if (normalized.contains('access_members') || normalized.contains('access to members')) {
      return 'access_members';
    } else if (normalized.contains('coach_ratings') || normalized.contains('coach ratings')) {
      return 'coach_ratings';
    } else if (normalized.contains('events') || normalized.contains('tournaments')) {
      return 'events_tournaments';
    } else if (normalized.contains('branches')) {
      return 'branches';
    } else if (normalized.contains('users')) {
      return 'users';
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
      final response = await _authRepository.getPaidServicesList('club');
      
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

  /// Fetch club branches when Branches service is selected
  Future<void> _fetchBranches() async {
    if (_isLoadingBranches) return;

    final clubId = await _storageService.getInt('club_id');
    if (clubId == null) {
      if (mounted) {
        setState(() {
          _branchesError = 'Club ID not found';
          _isLoadingBranches = false;
        });
      }
      return;
    }

    setState(() {
      _isLoadingBranches = true;
      _branchesError = null;
    });

    try {
      final response = await _authRepository.getClubBranchList(clubId);
      
      if (mounted) {
        setState(() {
          _branches = response.data;
          _isLoadingBranches = false;
        });
      }
    } on ApiException catch (e) {
      if (mounted) {
        setState(() {
          _branchesError = e.message;
          _isLoadingBranches = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _branchesError = 'Failed to load branches: ${e.toString()}';
          _isLoadingBranches = false;
        });
      }
    }
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
                      if (_paidServices.isEmpty) {
                        _fetchPaidServices();
                      }
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
            'With Free Membership, you will continue to use our following services:',
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
                _BenefitRow(text: 'Maintain Club Schedule'),
                _BenefitRow(text: 'Check Club Ratings and Reviews'),
                _BenefitRow(text: 'Receive Bookings from Members'),
                _BenefitRow(
                  text:
                      'Receive Monthly Revenues for Booking Through Our Platform',
                ),
                _BenefitRow(text: 'Subscription of Coach to the Club'),
                _BenefitRow(text: 'Readable Access to the Forum Discussion'),
              ],
            ),
          ),
          const SizedBox(height: 22),
          const Text(
            'With Free Membership, You Will Be Missing Our Following Services,\nHowever You Will Avail First XX Days Of Free Trial For All * Indicated Services.',
            style: TextStyle(
              fontSize: 15.3,
              color: Colors.red,
              fontWeight: FontWeight.w700,
              height: 1.3,
            ),
          ),
          SizedBox(height: 14),
          // Mobile-optimized missing services list
          MobileMissingClubServicesList(),
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
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red[300]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.red[700]),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(color: Colors.red[700]),
                    ),
                  ),
                  TextButton(
                    onPressed: _fetchPaidServices,
                    child: const Text('Retry'),
                  ),
                ],
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
              final isBranches = serviceKey == 'branches';
              
              return _buildServiceOption(
                serviceKey,
                service.name,
                service.description2.isNotEmpty ? service.description2 : service.description1,
                service.amountValue,
                isBranches: isBranches,
              );
            }),

            const SizedBox(height: 16),
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
    bool isBranches = false,
  }) {
    final isSelected = _selectedServices[key] ?? false;
    
    return InkWell(
      onTap: () {
        setState(() {
          _selectedServices[key] = !isSelected;
        });
        
        // Fetch branches when Branches service is selected
        if (!isSelected && isBranches) {
          if (_branches.isEmpty && !_isLoadingBranches) {
            _fetchBranches();
          }
        }
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
            // Show branches selection if "Branches" service is selected
            if (isBranches && isSelected) ...[
              const SizedBox(height: 16),
              _buildBranchesSection(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBranchesSection() {
    if (_isLoadingBranches) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_branchesError != null) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.red[50],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          _branchesError!,
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    if (_branches.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text(
          'No branches available',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Branches:',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _branches.map((branch) => _buildBranchChip(branch)).toList(),
        ),
      ],
    );
  }

  Widget _buildBranchChip(ClubBranchListItem branch) {
    final isSelected = _selectedBranchIds.contains(branch.id);
    
    return InkWell(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedBranchIds.remove(branch.id);
          } else {
            _selectedBranchIds.add(branch.id);
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF8BB6D9)
              : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF8BB6D9)
                : Colors.grey[300]!,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              branch.clubName,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isSelected
                    ? Colors.white
                    : const Color(0xFF1E293B),
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 6),
              const Icon(
                Icons.check_circle,
                size: 14,
                color: Colors.white,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _getServiceIcon(String key) {
    IconData icon;
    Color color;

    switch (key) {
      case 'access_members':
        icon = Icons.people;
        color = Colors.green;
        break;
      case 'coach_ratings':
        icon = Icons.star;
        color = Colors.orange;
        break;
      case 'events_tournaments':
        icon = Icons.emoji_events;
        color = Colors.amber;
        break;
      case 'branches':
        icon = Icons.business;
        color = Colors.blue;
        break;
      case 'users':
        icon = Icons.person_add;
        color = Colors.purple;
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
              onPressed: _isSubmitting ? null : () {
                if (_isFreeMembership) {
                  _submitFreeMembership();
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

  Future<void> _submitFreeMembership() async {
    if (_isSubmitting) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      await _authRepository.chooseMembershipType('Free');
      
      if (mounted) {
        _showRegistrationComplete();
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

/// A helper row widget for the benefit points
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

class MobileMissingClubServicesList extends StatelessWidget {
  const MobileMissingClubServicesList({super.key});

  @override
  Widget build(BuildContext context) {
    final List<_MobileMissingService> missing = [
      _MobileMissingService(
        emoji: '🧑‍🤝‍🧑',
        name: 'Access To Members',
        description:
            'You will be able to promote your club to the members of your club locality, corporate offices, reach out to merchandisers for promotion and free lancers for support.',
        hasTrial: true,
      ),
      _MobileMissingService(
        emoji: '🟢',
        name: 'Unlock Coach Ratings',
        description:
            'You Will Be Able To Unlock Coach Ratings To Select Your Preferred Coach.',
      ),
      _MobileMissingService(
        emoji: '🏆',
        name: 'Scheduling Events & Tournaments',
        description:
            'You will be able to schedule events and tournaments/matches and promote the same to all members, corporates, coaches and merchandisers.',
        hasTrial: true,
      ),
      _MobileMissingService(
        emoji: '🧑‍🤝‍🧑🏢',
        name: 'Registering And Configuring Multiple Branches',
        description:
            'In a paid membership you can register multiple branches of your club.',
      ),
      _MobileMissingService(
        emoji: '🧑‍💻',
        name: 'Access To Multiple Users',
        description:
            'You will be able to add and provide access to additional internal users to the application to support and manage your business.',
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
            'Various alerts like your Booking, Tournaments, etc can be received on your mobile device in slack app.',
        hasTrial: true,
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
                              style: TextStyle(
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
