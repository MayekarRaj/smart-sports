import 'package:flutter/material.dart';
import '../../core/services/storage_service.dart';
import '../../core/repositories/auth_repository.dart';
import '../../core/models/api_models.dart';
import '../../core/exceptions/api_exception.dart';
import '../../role_specific/common/role_router.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'dart:io';

class PaymentConfirmationPage extends StatefulWidget {
  final double amount;
  final String paymentMethod;
  final String? referenceNumber;
  final File? receiptImage;
  final String? clientSecret;
  final String? stripePaymentMethodId;
  final CardFieldInputDetails? cardFieldDetails;

  const PaymentConfirmationPage({
    super.key,
    required this.amount,
    required this.paymentMethod,
    this.referenceNumber,
    this.receiptImage,
    this.clientSecret,
    this.stripePaymentMethodId,
    this.cardFieldDetails,
  });

  @override
  State<PaymentConfirmationPage> createState() => _PaymentConfirmationPageState();
}

class _PaymentConfirmationPageState extends State<PaymentConfirmationPage> {
  final StorageService _storageService = StorageService();
  final AuthRepository _authRepository = AuthRepository();

  bool _isProcessing = false;

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
              colors: [Color(0xFF1E293B), Color(0xFF334155)],
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
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: const Text(
          '💳 Payment Confirmation',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Amount to Pay Section
              _buildAmountSection(),
              const SizedBox(height: 24),

              // Final Payment Details
              _buildFinalPaymentDetails(),
              const SizedBox(height: 32),

              // Bottom Navigation
              _buildBottomNavigation(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAmountSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red, width: 2),
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
            'Amount To Pay',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Amount To Pay',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'USD ${widget.amount.toInt()}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinalPaymentDetails() {
    return Container(
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF8BB6D9).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.receipt_long,
                  color: Color(0xFF8BB6D9),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Final Payment Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Payment Method
          _buildDetailField(
            'Payment Method:',
            widget.paymentMethod,
            icon: Icons.payment,
          ),
          const SizedBox(height: 16),

          // Payment Status
          _buildDetailField(
            'Payment Status:',
            _isProcessing ? 'PROCESSING' : 'READY TO PAY',
            icon: Icons.info_outline,
            statusColor: _isProcessing ? Colors.orange : Colors.blue,
          ),
          const SizedBox(height: 16),

          // Additional details based on payment method
          if (widget.paymentMethod == 'BANK TRANSFER') ...[
            if (widget.referenceNumber != null && widget.referenceNumber!.isNotEmpty)
              _buildDetailField(
                'Reference Number:',
                widget.referenceNumber!,
                icon: Icons.numbers,
              ),
            if (widget.referenceNumber != null && widget.referenceNumber!.isNotEmpty)
              const SizedBox(height: 16),
            if (widget.receiptImage != null)
              _buildReceiptPreview(),
            if (widget.receiptImage != null)
              const SizedBox(height: 16),
          ],

          // Payment Date and Time
          Row(
            children: [
              Expanded(
                child: _buildDetailField(
                  'Payment Date:',
                  _getCurrentDate(),
                  icon: Icons.calendar_today,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDetailField(
                  'Payment Time:',
                  _getCurrentTime(),
                  icon: Icons.access_time,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailField(
    String label,
    String value, {
    IconData? icon,
    Color? statusColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          decoration: BoxDecoration(
            color: statusColor != null ? statusColor.withOpacity(0.1) : Colors.grey[50],
            border: Border.all(
              color: statusColor != null
                  ? statusColor.withOpacity(0.3)
                  : Colors.grey[300]!,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: statusColor ?? Colors.black87,
                  ),
                ),
              ),
              if (statusColor != null)
                Icon(
                  _isProcessing ? Icons.hourglass_empty : Icons.check_circle,
                  size: 18,
                  color: statusColor,
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReceiptPreview() {
    if (widget.receiptImage == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.receipt, size: 16, color: Colors.grey),
            const SizedBox(width: 6),
            const Text(
              'Payment Receipt:',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  image: DecorationImage(
                    image: FileImage(widget.receiptImage!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.receiptImage!.path.split('/').last,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(Icons.check_circle, color: Colors.green, size: 20),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavigation() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _isProcessing ? null : () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              side: const BorderSide(color: Colors.grey),
            ),
            child: const Text(
              'BACK',
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
          flex: 2,
          child: ElevatedButton(
            onPressed: _isProcessing ? null : _processPayment,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 2,
            ),
            child: _isProcessing
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.payment, color: Colors.white, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'PAY NOW',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  String _getCurrentDate() {
    final now = DateTime.now();
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${now.day} ${months[now.month - 1]} ${now.year}';
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
  }

  void _processPayment() async {
    setState(() {
      _isProcessing = true;
    });

    try {
      if (widget.paymentMethod == 'CREDIT / DEBIT CARD') {
        await _processStripePayment();
      } else if (widget.paymentMethod == 'BANK TRANSFER') {
        await _processBankTransferPayment();
      } else if (widget.paymentMethod == 'PAYPAL') {
        await _processPayPalPayment();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Process Stripe payment
  Future<void> _processStripePayment() async {
    try {
      // Validate card details from CardField
      if (widget.cardFieldDetails == null || !widget.cardFieldDetails!.complete) {
        throw Exception('Please enter complete card details');
      }

      // Create PaymentMethod from CardField details
      // CardField securely tokenizes the card and we can create PaymentMethod
      final paymentMethod = await Stripe.instance.createPaymentMethod(
        params: const PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(),
        ),
      );

      final paymentMethodId = paymentMethod.id;
      if (paymentMethodId == null) {
        throw Exception('Failed to create payment method');
      }

      // Create subscription with the payment method
      final subscriptionRequest = StripeCreateSubscriptionRequest(
        stripePaymentMethodId: paymentMethodId,
        paymentMethod: paymentMethodId,
      );

      final subscriptionResponse = await _authRepository.createStripeSubscription(
        subscriptionRequest,
      );

      // Handle SCA if required
      if (subscriptionResponse.clientSecret != null) {
        // Additional authentication may be required
        // For now, we proceed with payment info saving
      }

      // Save payment information
      final paymentInfoRequest = SavePaymentInformationRequest(
        paymentMethod: 'Stripe',
        stripePaymentMethodId: paymentMethodId,
      );

      await _authRepository.savePaymentInformation(paymentInfoRequest);

      // Show success
      await _showPaymentSuccess();
    } on StripeException catch (e) {
      throw Exception('Stripe error: ${e.error.message ?? e.toString()}');
    } catch (e) {
      rethrow;
    }
  }

  /// Process Bank Transfer payment
  Future<void> _processBankTransferPayment() async {
    if (widget.receiptImage == null) {
      throw Exception('Receipt image is required');
    }

    final paymentInfoRequest = SavePaymentInformationRequest(
      paymentMethod: 'Bank Transfer',
      referenceNumber: widget.referenceNumber,
      paymentReceiptImagePath: widget.receiptImage!.path,
    );

    await _authRepository.savePaymentInformation(paymentInfoRequest);
    await _showPaymentSuccess();
  }

  /// Process PayPal payment
  Future<void> _processPayPalPayment() async {
    final paymentInfoRequest = SavePaymentInformationRequest(
      paymentMethod: 'Paypal',
    );

    await _authRepository.savePaymentInformation(paymentInfoRequest);
    await _showPaymentSuccess();
  }

  /// Show payment success dialog
  Future<void> _showPaymentSuccess() async {
    if (!mounted) return;

    setState(() {
      _isProcessing = false;
    });

    // Get user role from storage
    final userRoleStr = await _storageService.getString('user_role');
    final userRole = userRoleStr?.toUserRole() ?? UserRole.member;

    // Show success dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 28),
            SizedBox(width: 12),
            Text('Payment Successful!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Text(
              'Your payment of USD ${widget.amount.toInt()} has been processed successfully.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.verified, color: Colors.green, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Your membership has been activated!',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              // Navigate to role-specific dashboard
              final dashboard = RoleRouter.dashboardFor(userRole);
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => dashboard),
                (route) => false, // Remove all previous routes
              );
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }
}

