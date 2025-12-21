import 'package:flutter/material.dart';
import 'widgets/subscription_service_tile.dart';
import 'widgets/price_summary_card.dart';
import 'widgets/confirmation_dialog.dart';

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

  // Payment Details (editable in edit mode)
  String _paymentMethod = 'Bank Transfer';
  String _paymentStatus = 'Paid';
  DateTime _subscriptionStartDate = DateTime(2024, 1, 1);
  DateTime _subscriptionEndDate = DateTime(2024, 12, 31);
  DateTime _paymentDate = DateTime(2024, 1, 1);
  TimeOfDay _paymentTime = const TimeOfDay(hour: 14, minute: 30);

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
          _buildEditableField('Payment Method', _paymentMethod, (value) {
            setState(() {
              _paymentMethod = value;
            });
          }),
          const SizedBox(height: 16),
          _buildEditableField('Payment Status', _paymentStatus, (value) {
            setState(() {
              _paymentStatus = value;
            });
          }),
          const SizedBox(height: 16),
          _buildDateField(
            'Subscription Start Date',
            _subscriptionStartDate,
            (date) {
              setState(() {
                _subscriptionStartDate = date;
              });
            },
          ),
          const SizedBox(height: 16),
          _buildDateField(
            'Subscription End Date',
            _subscriptionEndDate,
            (date) {
              setState(() {
                _subscriptionEndDate = date;
              });
            },
          ),
          const SizedBox(height: 16),
          _buildDateField(
            'Payment Date',
            _paymentDate,
            (date) {
              setState(() {
                _paymentDate = date;
              });
            },
          ),
          const SizedBox(height: 16),
          _buildTimeField(
            'Payment Time',
            _paymentTime,
            (time) {
              setState(() {
                _paymentTime = time;
              });
            },
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

  Widget _buildEditableField(
    String label,
    String value,
    ValueChanged<String> onChanged,
  ) {
    if (!_isEditMode) {
      return _buildReadOnlyField(label, value);
    }

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
        TextFormField(
          initialValue: value,
          onChanged: onChanged,
          style: const TextStyle(fontSize: 14, color: Colors.black87),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: widget.roleColor, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField(
    String label,
    DateTime value,
    ValueChanged<DateTime> onChanged,
  ) {
    if (!_isEditMode) {
      return _buildReadOnlyField(
        label,
        '${value.day}/${value.month}/${value.year}',
      );
    }

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
        InkWell(
          onTap: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: value,
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (picked != null && picked != value) {
              onChanged(picked);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '${value.day}/${value.month}/${value.year}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                ),
                Icon(Icons.calendar_today, size: 18, color: widget.roleColor),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeField(
    String label,
    TimeOfDay value,
    ValueChanged<TimeOfDay> onChanged,
  ) {
    if (!_isEditMode) {
      return _buildReadOnlyField(label, value.format(context));
    }

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
        InkWell(
          onTap: () async {
            final TimeOfDay? picked = await showTimePicker(
              context: context,
              initialTime: value,
            );
            if (picked != null && picked != value) {
              onChanged(picked);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value.format(context),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                ),
                Icon(Icons.access_time, size: 18, color: widget.roleColor),
              ],
            ),
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

