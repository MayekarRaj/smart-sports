import 'package:flutter/material.dart';
import 'payment_method_dialog.dart';

class UnpaidServicesPaymentScreen extends StatefulWidget {
  final Color roleColor;
  final Map<String, bool> unpaidServices;
  final Map<String, double> unpaidServicePrices;
  final Map<String, String> unpaidServiceDescriptions;
  final int numberOfUsers;

  const UnpaidServicesPaymentScreen({
    super.key,
    required this.roleColor,
    required this.unpaidServices,
    required this.unpaidServicePrices,
    required this.unpaidServiceDescriptions,
    required this.numberOfUsers,
  });

  @override
  State<UnpaidServicesPaymentScreen> createState() =>
      _UnpaidServicesPaymentScreenState();
}

class _UnpaidServicesPaymentScreenState
    extends State<UnpaidServicesPaymentScreen> {
  DateTime _subscriptionStartDate = DateTime(2025, 11, 17);
  DateTime _subscriptionEndDate = DateTime(2026, 11, 16);

  double get _netTotal {
    double total = 0.0;
    widget.unpaidServices.forEach((service, isSelected) {
      if (isSelected) {
        total += widget.unpaidServicePrices[service] ?? 0.0;
      }
    });
    return total;
  }

  double get _discountAmount => 20.0;
  double get _referralDiscount => 60.0;
  double get _grandTotal => _netTotal - _discountAmount - _referralDiscount;
  double get _consumptionTax => _grandTotal * 0.10;
  double get _totalWithTax => _grandTotal + _consumptionTax;

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  String _formatCurrency(double amount) {
    return amount.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Unpaid Services Payment',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Unpaid Services Section
            _buildUnpaidServicesSection(),
            const SizedBox(height: 24),
            // Billing Summary Section
            _buildBillingSummarySection(),
            const SizedBox(height: 24),
            // Payment Details Section
            _buildPaymentDetailsSection(),
            const SizedBox(height: 32),
            // Pay Button
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PaymentMethodDialog(
                        roleColor: widget.roleColor,
                        totalAmount: _totalWithTax,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  'Pay',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
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
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF8BB6D9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Unpaid Services',
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
          ...widget.unpaidServices.entries.map((entry) {
            final service = entry.key;
            final isSelected = entry.value;
            return _buildServiceItem(service, isSelected);
          }),
        ],
      ),
    );
  }

  Widget _buildServiceItem(String service, bool isSelected) {
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
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: widget.roleColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.check,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: widget.roleColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              _getServiceIcon(service),
              color: widget.roleColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        service == 'Users' ? 'Users $widget.numberOfUsers' : service,
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
                          'USD ${_formatCurrency(widget.unpaidServicePrices[service] ?? 0.0)}',
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
                  widget.unpaidServiceDescriptions[service] ?? '',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getServiceIcon(String service) {
    switch (service) {
      case 'Users':
        return Icons.people;
      case 'Forum':
        return Icons.forum;
      case 'Slack':
        return Icons.notifications_active;
      default:
        return Icons.check_circle;
    }
  }

  Widget _buildBillingSummarySection() {
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
            'Billing Summary',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 20),
          _buildSummaryRow('NET TOTAL AMOUNT TO PAY:', _netTotal),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: _buildSummaryRow('DISCOUNT AMOUNT:', _discountAmount),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: _buildSummaryRow('DISCOUNT FOR REFERRAL:', _referralDiscount),
          ),
          const SizedBox(height: 12),
          _buildSummaryRow('GRAND TOTAL AMOUNT TO PAY:', _grandTotal, isBold: true),
          const SizedBox(height: 12),
          _buildSummaryRow('CONSUMPTION TAX AMOUNT (10%):', _consumptionTax),
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

  Widget _buildSummaryRow(String label, double amount, {bool isBold = false}) {
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
            color: isBold ? const Color(0xFF1F2937) : Colors.grey.shade700,
          ),
        ),
      ],
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
          _buildReadOnlyField('Payment Method', 'BANK TRANSFER'),
          const SizedBox(height: 16),
          _buildReadOnlyField('Payment Status', 'PENDING'),
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
          _buildReadOnlyField('Payment Date', 'MMM DD, YYYY'),
          const SizedBox(height: 16),
          _buildReadOnlyField('Payment Time', 'XX:XX:XX'),
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

