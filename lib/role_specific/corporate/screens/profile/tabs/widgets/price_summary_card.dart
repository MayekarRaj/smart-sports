import 'package:flutter/material.dart';

class PriceSummaryCard extends StatelessWidget {
  final double netTotal;
  final double discountAmount;
  final double referralDiscount;
  final double grandTotal;
  final double consumptionTax;
  final double totalWithTax;
  final Color roleColor;

  const PriceSummaryCard({
    super.key,
    required this.netTotal,
    required this.discountAmount,
    required this.referralDiscount,
    required this.grandTotal,
    required this.consumptionTax,
    required this.totalWithTax,
    required this.roleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Price Calculation Summary',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: roleColor,
            ),
          ),
          const SizedBox(height: 20),
          _buildPriceRow('Net Total Amount to Pay', netTotal),
          const SizedBox(height: 12),
          _buildPriceRow('Discount Amount', -discountAmount, isDiscount: true),
          const SizedBox(height: 12),
          _buildPriceRow('Discount for Referral', -referralDiscount, isDiscount: true),
          const Divider(height: 24),
          _buildPriceRow('Grand Total Amount to Pay', grandTotal, isBold: true),
          const SizedBox(height: 12),
          _buildPriceRow('Consumption Tax Amount (10%)', consumptionTax),
          const Divider(height: 24),
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
                  'Total Amount Including Tax',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF10B981),
                  ),
                ),
                Text(
                  'USD ${_formatCurrency(totalWithTax)}',
                  style: const TextStyle(
                    fontSize: 20,
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
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isBold ? FontWeight.w600 : FontWeight.w500,
            color: const Color(0xFF1F2937),
          ),
        ),
        Text(
          '${isDiscount ? '-' : ''}USD ${_formatCurrency(amount.abs())}',
          style: TextStyle(
            fontSize: 14,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
            color: isDiscount
                ? Colors.red.shade600
                : isBold
                    ? const Color(0xFF1F2937)
                    : Colors.grey.shade700,
          ),
        ),
      ],
    );
  }

  String _formatCurrency(double amount) {
    return amount.toStringAsFixed(2).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}

