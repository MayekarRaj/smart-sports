import 'package:flutter/material.dart';
import 'package:smart_sports/shared/widgets/profile_tabs/widgets/subscription_service_tile.dart';
import 'package:smart_sports/shared/widgets/profile_tabs/widgets/price_summary_card.dart';
import 'package:smart_sports/shared/widgets/profile_tabs/widgets/confirmation_dialog.dart';

class SubscriptionsTab extends StatefulWidget {
  final Color roleColor;
  final bool isMobile;

  const SubscriptionsTab({
    super.key,
    required this.roleColor,
    required this.isMobile,
  });

  @override
  State<SubscriptionsTab> createState() => _SubscriptionsTabState();
}

class _SubscriptionsTabState extends State<SubscriptionsTab> {
  String _membershipType = 'Free'; // 'Free' or 'Privilege'

  // Paid Services
  final Map<String, bool> _paidServices = {
    'Priority Booking': true,
    'Avail Discounts': false,
    'Coach Ratings': false,
    'Events & Tournaments': true,
    'Access to Members (All Roles)': false,
  };

  final Map<String, double> _servicePrices = {
    'Priority Booking': 29.99,
    'Avail Discounts': 19.99,
    'Coach Ratings': 14.99,
    'Events & Tournaments': 39.99,
    'Access to Members (All Roles)': 24.99,
  };

  final Map<String, String> _serviceDescriptions = {
    'Priority Booking': 'Get priority access to book courts and facilities',
    'Avail Discounts': 'Enjoy exclusive discounts on bookings and events',
    'Coach Ratings': 'Rate and review coaches to help others',
    'Events & Tournaments': 'Participate in exclusive events and tournaments',
    'Access to Members (All Roles)': 'Access member directory across all roles',
  };

  final Map<String, IconData> _serviceIcons = {
    'Priority Booking': Icons.calendar_today,
    'Avail Discounts': Icons.local_offer,
    'Coach Ratings': Icons.star_rate,
    'Events & Tournaments': Icons.event,
    'Access to Members (All Roles)': Icons.people,
  };

  // Unpaid Services
  final Map<String, bool> _unpaidServices = {
    'Forum': false,
    'Slack (Automatic Mobile Notifications)': false,
  };

  final Map<String, double> _unpaidServicePrices = {
    'Forum': 9.99,
    'Slack (Automatic Mobile Notifications)': 4.99,
  };

  final Map<String, String> _unpaidServiceDescriptions = {
    'Forum': 'Access to community forum discussions',
    'Slack (Automatic Mobile Notifications)': 'Receive automatic notifications on mobile',
  };

  final Map<String, IconData> _unpaidServiceIcons = {
    'Forum': Icons.forum,
    'Slack (Automatic Mobile Notifications)': Icons.notifications_active,
  };

  // Priority Booking selected clubs
  final List<String> _selectedClubs = ['Premier Sports Club', 'Elite Athletic Center'];

  // Payment Details (read-only)
  final String _paymentMethod = 'Bank Transfer';
  final String _paymentStatus = 'Paid';
  final DateTime _subscriptionStartDate = DateTime(2024, 1, 1);
  final DateTime _subscriptionEndDate = DateTime(2024, 12, 31);
  final DateTime _paymentDate = DateTime(2024, 1, 1);
  final TimeOfDay _paymentTime = const TimeOfDay(hour: 14, minute: 30);

  double get _netTotal {
    double total = 0.0;
    _paidServices.forEach((service, isSelected) {
      if (isSelected) {
        total += _servicePrices[service] ?? 0.0;
      }
    });
    _unpaidServices.forEach((service, isSelected) {
      if (isSelected) {
        total += _unpaidServicePrices[service] ?? 0.0;
      }
    });
    return total;
  }

  double get _discountAmount => _netTotal * 0.1; // 10% discount
  double get _referralDiscount => 5.0; // Fixed referral discount
  double get _grandTotal => _netTotal - _discountAmount - _referralDiscount;
  double get _consumptionTax => _grandTotal * 0.10; // 10% tax
  double get _totalWithTax => _grandTotal + _consumptionTax;

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => SubscriptionConfirmationDialog(
        roleColor: widget.roleColor,
        onConfirm: () {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Subscription updated successfully'),
              backgroundColor: Colors.green,
            ),
          );
        },
        onCancel: () {
          Navigator.of(context).pop();
        },
        onApplyFromToday: () {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Changes will be applied from today'),
              backgroundColor: Colors.blue,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Membership Type Selector
          _buildMembershipTypeSelector(),
          const SizedBox(height: 24),
          // Paid Services Section
          _buildPaidServicesSection(),
          const SizedBox(height: 24),
          // Price Summary
          PriceSummaryCard(
            netTotal: _netTotal,
            discountAmount: _discountAmount,
            referralDiscount: _referralDiscount,
            grandTotal: _grandTotal,
            consumptionTax: _consumptionTax,
            totalWithTax: _totalWithTax,
            roleColor: widget.roleColor,
          ),
          const SizedBox(height: 24),
          // Payment Details Section
          _buildPaymentDetailsSection(),
          const SizedBox(height: 24),
          // Unpaid Services Section
          _buildUnpaidServicesSection(),
          const SizedBox(height: 24),
          // Action Buttons
          _buildActionButtons(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildMembershipTypeSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _membershipType = 'Free';
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _membershipType == 'Free'
                      ? widget.roleColor
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: _membershipType == 'Free'
                      ? [
                          BoxShadow(
                            color: widget.roleColor.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  'Free Membership',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _membershipType == 'Free'
                        ? Colors.white
                        : Colors.grey.shade600,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _membershipType = 'Privilege';
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _membershipType == 'Privilege'
                      ? widget.roleColor
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: _membershipType == 'Privilege'
                      ? [
                          BoxShadow(
                            color: widget.roleColor.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  'Privilege Membership',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _membershipType == 'Privilege'
                        ? Colors.white
                        : Colors.grey.shade600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaidServicesSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: widget.roleColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.workspace_premium,
                  color: widget.roleColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Optional Paid Services',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: widget.roleColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ..._paidServices.entries.map((entry) {
            final service = entry.key;
            final isSelected = entry.value;
            return SubscriptionServiceTile(
              title: service,
              description: _serviceDescriptions[service] ?? '',
              monthlyFee: _servicePrices[service] ?? 0.0,
              isSelected: isSelected,
              onChanged: (value) {
                setState(() {
                  _paidServices[service] = value;
                });
              },
              icon: _serviceIcons[service] ?? Icons.check_circle,
              roleColor: widget.roleColor,
              trailingWidget: service == 'Priority Booking'
                  ? _buildPriorityBookingWidget()
                  : null,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPriorityBookingWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _selectedClubs.map((club) {
            return Chip(
              label: Text(club),
              backgroundColor: widget.roleColor.withValues(alpha: 0.1),
              labelStyle: TextStyle(color: widget.roleColor),
              deleteIcon: Icon(Icons.close, size: 16, color: widget.roleColor),
              onDeleted: () {
                setState(() {
                  _selectedClubs.remove(club);
                });
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: () {
            _showClubSelectionDialog();
          },
          icon: const Icon(Icons.add, size: 16),
          label: const Text('Update'),
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.roleColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  void _showClubSelectionDialog() {
    final availableClubs = [
      'Premier Sports Club',
      'Elite Athletic Center',
      'City Sports Complex',
      'Metro Sports Hub',
      'Community Sports Center',
    ];
    final tempSelected = List<String>.from(_selectedClubs);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Select Clubs'),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: availableClubs.length,
                  itemBuilder: (context, index) {
                    final club = availableClubs[index];
                    final isSelected = tempSelected.contains(club);
                    return CheckboxListTile(
                      title: Text(club),
                      value: isSelected,
                      onChanged: (value) {
                        setDialogState(() {
                          if (value == true) {
                            tempSelected.add(club);
                          } else {
                            tempSelected.remove(club);
                          }
                        });
                      },
                      activeColor: widget.roleColor,
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedClubs.clear();
                      _selectedClubs.addAll(tempSelected);
                    });
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.roleColor,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Update'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildPaymentDetailsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: widget.roleColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.payment,
                  color: widget.roleColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Payment Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: widget.roleColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildReadOnlyField('Payment Method', _paymentMethod),
          const SizedBox(height: 16),
          _buildReadOnlyField('Payment Status', _paymentStatus),
          const SizedBox(height: 16),
          _buildReadOnlyField(
            'Subscription Start Date',
            '${_subscriptionStartDate.day}/${_subscriptionStartDate.month}/${_subscriptionStartDate.year}',
          ),
          const SizedBox(height: 16),
          _buildReadOnlyField(
            'Subscription End Date',
            '${_subscriptionEndDate.day}/${_subscriptionEndDate.month}/${_subscriptionEndDate.year}',
          ),
          const SizedBox(height: 16),
          _buildReadOnlyField(
            'Payment Date',
            '${_paymentDate.day}/${_paymentDate.month}/${_paymentDate.year}',
          ),
          const SizedBox(height: 16),
          _buildReadOnlyField(
            'Payment Time',
            _paymentTime.format(context),
          ),
        ],
      ),
    );
  }

  Widget _buildUnpaidServicesSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: widget.roleColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.cancel_outlined,
                  color: widget.roleColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Optional Unpaid Services',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: widget.roleColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ..._unpaidServices.entries.map((entry) {
            final service = entry.key;
            final isSelected = entry.value;
            return SubscriptionServiceTile(
              title: service,
              description: _unpaidServiceDescriptions[service] ?? '',
              monthlyFee: _unpaidServicePrices[service] ?? 0.0,
              isSelected: isSelected,
              onChanged: (value) {
                setState(() {
                  _unpaidServices[service] = value;
                });
              },
              icon: _unpaidServiceIcons[service] ?? Icons.cancel,
              roleColor: widget.roleColor,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF64748B),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: BorderSide(color: Colors.grey.shade300),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1F2937),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: BorderSide(color: Colors.grey.shade300),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Back',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1F2937),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: _showConfirmationDialog,
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.roleColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Update Subscription',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

