import 'package:flutter/material.dart';
import 'widgets/subscription_service_tile.dart';
import 'widgets/unpaid_services_payment_screen.dart';

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
  bool _isEditMode = false;
  String _membershipType = 'Privilege'; // 'Free' or 'Privilege'

  // Paid Services - matching image
  final Map<String, bool> _paidServices = {
    'Access To Members (All Roles)': true,
    'Coach Ratings': true,
    'Events & Tournaments': true,
    'Branches': true,
  };

  final Map<String, double> _servicePrices = {
    'Access To Members (All Roles)': 200.0,
    'Coach Ratings': 100.0,
    'Events & Tournaments': 200.0,
    'Branches': 200.0, // 4 branches @ USD 50/branch
  };

  final Map<String, String> _serviceDescriptions = {
    'Access To Members (All Roles)': 'Access to all type of role type members (local/area) including corporates.',
    'Coach Ratings': 'You Will Be Able To Unlock Coach Ratings To Select Your Coach.',
    'Events & Tournaments': 'You will be allowed to schedule multiple events and tournaments.',
    'Branches': 'Register and configure 4 branches to manage different locations efficiently @USD 50 / branch',
  };

  int _numberOfBranches = 4;
  final List<String> _selectedBranches = ['Branch 1', 'Branch 2', 'Branch 3', 'Branch 4'];

  int _numberOfUsers = 4;

  // Unpaid Services - matching image
  final Map<String, bool> _unpaidServices = {
    'Users': false,
    'Forum': false,
    'Slack': false,
  };

  final Map<String, double> _unpaidServicePrices = {
    'Users': 200.0, // 4 users @ USD 50/user
    'Forum': 100.0,
    'Slack': 100.0,
  };

  final Map<String, String> _unpaidServiceDescriptions = {
    'Users': 'You will be allowed to add and provide access to 4 users @ USD 50 / user',
    'Forum': 'You will have access to forum discussions within our platform & able to save your Stories with Photos.',
    'Slack': 'Automatic Mobile Notifications Per Month: You Will Get Emails And Mobile Notification Of Our Various Services.',
  };

  // Payment Details (editable in edit mode)
  String _paymentMethod = 'BANK TRANSFER';
  String _paymentStatus = 'PAID';
  DateTime _subscriptionStartDate = DateTime(2025, 11, 17);
  DateTime _subscriptionEndDate = DateTime(2026, 11, 16);
  DateTime _paymentDate = DateTime(2025, 11, 17);
  TimeOfDay _paymentTime = const TimeOfDay(hour: 1, minute: 12);

  double get _netTotal {
    double total = 0.0;
    _paidServices.forEach((service, isSelected) {
      if (isSelected) {
        total += _servicePrices[service] ?? 0.0;
      }
    });
    return total;
  }

  double get _discountAmount => 20.0; // USD 20
  double get _referralDiscount => 110.0; // USD 110
  double get _grandTotal => _netTotal - _discountAmount - _referralDiscount;
  double get _consumptionTax => _grandTotal * 0.10; // 10% tax
  double get _totalWithTax => _grandTotal + _consumptionTax;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Edit/Save Button
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _isEditMode = !_isEditMode;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(_isEditMode ? 'Changes saved' : 'Edit mode enabled'),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                },
                icon: Icon(_isEditMode ? Icons.save : Icons.edit),
                label: Text(_isEditMode ? 'Save' : 'Edit'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.roleColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Membership Type Selector
          _buildMembershipTypeSelector(),
          const SizedBox(height: 24),
          // Paid Services Section
          _buildPaidServicesSection(),
          const SizedBox(height: 24),
          // Price Summary
          _buildPriceSummary(),
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

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              // Handle cancel
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: const BorderSide(color: Colors.black, width: 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              backgroundColor: Colors.white,
            ),
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              // Handle back
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: const BorderSide(color: Colors.black, width: 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              backgroundColor: Colors.white,
            ),
            child: const Text(
              'Back',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: () {
              // Navigate to unpaid services payment screen with all services selected
              final selectedUnpaidServices = Map<String, bool>.from(_unpaidServices);
              // Ensure all unpaid services are selected for payment
              selectedUnpaidServices.updateAll((key, value) => true);
              
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => UnpaidServicesPaymentScreen(
                    roleColor: widget.roleColor,
                    unpaidServices: selectedUnpaidServices,
                    unpaidServicePrices: _unpaidServicePrices,
                    unpaidServiceDescriptions: _unpaidServiceDescriptions,
                    numberOfUsers: _numberOfUsers,
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 2,
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
                      ? const Color(0xFF1F2937)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Text(
                  'FREE MEMBERSHIP',
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
                      ? const Color(0xFF1F2937)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Text(
                  'PRIVILEGE MEMBERSHIP',
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
              icon: Icons.check_circle_outline,
              roleColor: widget.roleColor,
              trailingWidget: service == 'Branches'
                  ? _buildBranchesWidget()
                  : null,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildBranchesWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Row(
          children: [
            Text(
              '$_numberOfBranches',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: widget.roleColor,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ..._selectedBranches.take(4).map((branch) {
                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey.shade200,
                            border: Border.all(color: Colors.grey.shade300, width: 2),
                          ),
                          child: Center(
                            child: Text(
                              branch.replaceAll('Branch ', ''),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: -2,
                          right: -2,
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                  if (_isEditMode)
                    ElevatedButton(
                      onPressed: () {
                        _showBranchEditDialog();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.roleColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        minimumSize: const Size(60, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Edit'),
                    ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showBranchEditDialog() {
    showDialog(
      context: context,
      builder: (context) {
        int tempBranches = _numberOfBranches;
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Edit Branches'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Number of Branches',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    initialValue: tempBranches.toString(),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      final count = int.tryParse(value);
                      if (count != null && count > 0 && count <= 10) {
                        setDialogState(() {
                          tempBranches = count;
                        });
                      }
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _numberOfBranches = tempBranches;
                      _servicePrices['Branches'] = tempBranches * 50.0;
                      _selectedBranches.clear();
                      for (int i = 1; i <= tempBranches; i++) {
                        _selectedBranches.add('Branch $i');
                      }
                    });
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.roleColor,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildPriceSummary() {
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
          const Text(
            'Payment Summary',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 20),
          _buildPriceRow('NET TOTAL AMOUNT TO PAY:', _netTotal),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: _buildPriceRow('DISCOUNT AMOUNT:', _discountAmount, isDiscount: true),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: _buildPriceRow('DISCOUNT FOR REFERRAL:', _referralDiscount, isDiscount: true),
          ),
          const SizedBox(height: 12),
          _buildPriceRow('GRAND TOTAL AMOUNT TO PAY:', _grandTotal, isBold: true),
          const SizedBox(height: 12),
          _buildPriceRow('CONSUMPTION TAX AMOUNT (10%):', _consumptionTax),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF10B981),
                width: 2,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'TOTAL AMOUNT INCLUDING TAX',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF10B981),
                  ),
                ),
                Text(
                  'USD ${_formatCurrency(_totalWithTax)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF10B981),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(
    String label,
    double amount, {
    bool isDiscount = false,
    bool isBold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
              color: const Color(0xFF1F2937),
            ),
          ),
        ),
        Text(
          'USD ${_formatCurrency(amount)}',
          style: TextStyle(
            fontSize: 14,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
            color: isDiscount
                ? Colors.red.shade700
                : isBold
                    ? const Color(0xFF1F2937)
                    : Colors.grey.shade700,
          ),
        ),
      ],
    );
  }

  String _formatCurrency(double amount) {
    return amount.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
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
              const Text(
                'Payment Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1F2937),
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
            '${_subscriptionStartDate.day} ${_getMonthName(_subscriptionStartDate.month)}, ${_subscriptionStartDate.year}',
          ),
          const SizedBox(height: 16),
          _buildReadOnlyField(
            'Subscription End Date',
            '${_subscriptionEndDate.day} ${_getMonthName(_subscriptionEndDate.month)}, ${_subscriptionEndDate.year}',
          ),
          const SizedBox(height: 16),
          _buildReadOnlyField(
            'Payment Date',
            '${_paymentDate.day} ${_getMonthName(_paymentDate.month)}, ${_paymentDate.year}',
          ),
          const SizedBox(height: 16),
          _buildReadOnlyField(
            'Payment Time',
            '${_paymentTime.hour.toString().padLeft(2, '0')}:${_paymentTime.minute.toString().padLeft(2, '0')}:30',
          ),
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
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
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF8BB6D9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Optional Unpaid Services',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange.shade200),
            ),
            child: const Text(
              'Following privilege membership has not been subscribed Please select the plan below to avail these privilege services.',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF1F2937),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 20),
          ..._unpaidServices.entries.map((entry) {
            final service = entry.key;
            final isSelected = entry.value;
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: isSelected,
                    onChanged: _isEditMode
                        ? (value) {
                            setState(() {
                              _unpaidServices[service] = value ?? false;
                            });
                          }
                        : null,
                    activeColor: widget.roleColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
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
                                service,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1F2937),
                                ),
                              ),
                            ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'Monthly Fee',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          'USD ${_formatCurrency(_unpaidServicePrices[service] ?? 0.0)}',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: widget.roleColor,
                          ),
                        ),
                      ],
                    ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _unpaidServiceDescriptions[service] ?? '',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        if (service == 'Users') ...[
                          const SizedBox(height: 8),
                          Text(
                            'Monthly Fee USD ${_formatCurrency(_unpaidServicePrices[service] ?? 0.0)}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
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
}
