import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../core/services/storage_service.dart';
import '../../core/repositories/auth_repository.dart';
import '../../core/models/api_models.dart';
import 'payment_confirmation_page.dart';

class PaymentMethodPage extends StatefulWidget {
  final double amount;
  final String? subscriptionId; // Required only when Add Club or Branch

  const PaymentMethodPage({
    super.key,
    required this.amount,
    this.subscriptionId,
  });

  @override
  State<PaymentMethodPage> createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethodPage> {
  String _selectedPaymentMethod = 'CREDIT / DEBIT CARD';
  final _paypalIdController = TextEditingController(
    text: 'sushant.godghate@sekai-ichi.com',
  );
  final _referenceNumberController = TextEditingController();
  final StorageService _storageService = StorageService();
  final AuthRepository _authRepository = AuthRepository();
  final ImagePicker _imagePicker = ImagePicker();

  bool _isLoadingSetupIntent = false;
  String? _clientSecret;
  String? _customerId;
  String? _stripePaymentMethodId;
  File? _receiptImage;
  CardFieldInputDetails? _cardFieldDetails;

  @override
  void initState() {
    super.initState();
    // Initialize SetupIntent when credit card is selected by default
    if (_selectedPaymentMethod == 'CREDIT / DEBIT CARD') {
      _initializeStripeIfNeeded();
    }
    
    // CardField handles validation automatically
  }

  @override
  void dispose() {
    _paypalIdController.dispose();
    _referenceNumberController.dispose();
    super.dispose();
  }

  /// Initialize Stripe SetupIntent when credit card payment is selected
  /// MANDATORY - SetupIntent must be created before user can proceed
  Future<void> _initializeStripeIfNeeded() async {
    if (_selectedPaymentMethod == 'CREDIT / DEBIT CARD' && _clientSecret == null && !_isLoadingSetupIntent) {
      await _createSetupIntent();
    }
  }

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
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: const Text(
          '💳 Payment Method',
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

              // Payment Method Selection
              _buildPaymentMethodSection(),
              const SizedBox(height: 24),

              // Payment Form
              if (_selectedPaymentMethod == 'CREDIT / DEBIT CARD')
                _buildStripeCardForm()
              else if (_selectedPaymentMethod == 'BANK TRANSFER')
                _buildBankTransferForm()
              else
                _buildPayPalForm(),

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
                Text("USD", style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),),
                Text(
                  widget.amount > 0 
                    ? '${widget.amount.toStringAsFixed(2)}'
                    : '0.00',
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

  Widget _buildPaymentMethodSection() {
    return Container(
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
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'Payment Method',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          _buildPaymentMethodOption(
            'CREDIT / DEBIT CARD',
            Icons.credit_card,
            _selectedPaymentMethod == 'CREDIT / DEBIT CARD',
          ),
          const Divider(height: 1),
          _buildPaymentMethodOption(
            'BANK TRANSFER',
            Icons.account_balance,
            _selectedPaymentMethod == 'BANK TRANSFER',
          ),
          const Divider(height: 1),
          _buildPaymentMethodOption(
            'PAYPAL',
            Icons.payment,
            _selectedPaymentMethod == 'PAYPAL',
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodOption(
    String method,
    IconData icon,
    bool isSelected,
  ) {
    return GestureDetector(
      onTap: () async {
        setState(() {
          _selectedPaymentMethod = method;
        });
        // Initialize Stripe SetupIntent MANDATORY when credit card is selected
        if (method == 'CREDIT / DEBIT CARD') {
          await _initializeStripeIfNeeded();
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF8BB6D9).withOpacity(0.1)
              : Colors.white,
          borderRadius: method == 'PAYPAL'
              ? const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                )
              : null,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF8BB6D9).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: const Color(0xFF8BB6D9), size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                method,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? const Color(0xFF8BB6D9) : Colors.black87,
                ),
              ),
            ),
            if (isSelected)
              const Icon(Icons.keyboard_arrow_up, color: Color(0xFF8BB6D9))
            else
              const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildStripeCardForm() {
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
          if (_isLoadingSetupIntent)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(40.0),
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      'Initializing payment...',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else if (_clientSecret == null)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.warning, color: Colors.orange.shade700),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Unable to initialize payment. Please try again.',
                          style: TextStyle(color: Colors.orange.shade700),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _createSetupIntent,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(
                        'Retry',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Card Details',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  // decoration: BoxDecoration(
                  //   color: Colors.grey[50],
                  //   borderRadius: BorderRadius.circular(8),
                  //   border: Border.all(color: Colors.grey[300]!),
                  // ),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: CardField(
                    onCardChanged: (card) {
                      setState(() {
                        _cardFieldDetails = card;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Your card details are securely processed by Stripe.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildBankTransferForm() {
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
          _buildTextField(
            controller: _referenceNumberController,
            label: 'Reference Number',
            hint: 'Enter bank transfer reference number',
            keyboardType: TextInputType.text,
          ),
          const SizedBox(height: 16),
          const Text(
            'Payment Receipt',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: _pickReceiptImage,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _receiptImage != null
                      ? Colors.green
                      : Colors.grey.shade300,
                  width: _receiptImage != null ? 2 : 1,
                ),
              ),
              child: _receiptImage != null
                  ? Column(
                      children: [
                        Image.file(
                          _receiptImage!,
                          height: 150,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _receiptImage!.path.split('/').last,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: _pickReceiptImage,
                          child: const Text('Change Image'),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.cloud_upload, color: Colors.grey),
                        const SizedBox(width: 8),
                        const Text(
                          'Upload Payment Receipt',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
            ),
          ),
          if (_receiptImage == null)
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                'Required for Bank Transfer',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.orange,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPayPalForm() {
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
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF8BB6D9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'https://www.paypal.com/paypalme/sekaiichik',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'Send Payment To Paypal ID',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              _paypalIdController.text,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: Colors.grey[400],
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              suffixIcon: suffixIcon,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
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
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              side: const BorderSide(color: Colors.grey),
            ),
            child: const Text(
              'CANCEL',
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
            onPressed: _validateAndNavigate,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8BB6D9),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 2,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text(
                  'CONTINUE',
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

  void _validateAndNavigate() async {
    // Validate based on payment method
    if (_selectedPaymentMethod == 'CREDIT / DEBIT CARD') {
      // MANDATORY: SetupIntent must be created before proceeding
      if (_clientSecret == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please wait for payment to initialize. If it fails, please retry.'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }
      
      // Validate card details are complete using CardField
      if (_cardFieldDetails == null || !_cardFieldDetails!.complete) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter complete card details'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }
    } else if (_selectedPaymentMethod == 'BANK TRANSFER') {
      if (_referenceNumberController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter reference number'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }
      if (_receiptImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please upload payment receipt'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }
    }

    // Navigate to confirmation page
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentConfirmationPage(
            amount: widget.amount,
            paymentMethod: _selectedPaymentMethod,
            referenceNumber: _referenceNumberController.text.trim().isNotEmpty
                ? _referenceNumberController.text.trim()
                : null,
            receiptImage: _receiptImage,
            clientSecret: _clientSecret,
            stripePaymentMethodId: _stripePaymentMethodId,
            cardFieldDetails: _cardFieldDetails,
            subscriptionId: widget.subscriptionId,
          ),
        ),
      );
    }
  }

  /// Create Stripe SetupIntent
  Future<void> _createSetupIntent() async {
    if (_isLoadingSetupIntent) return;

    setState(() {
      _isLoadingSetupIntent = true;
    });

    try {
      final response = await _authRepository.createStripeSetupIntent();
      
      if (mounted) {
        setState(() {
          _clientSecret = response.clientSecret;
          _customerId = response.customerId;
          _isLoadingSetupIntent = false;
        });

        // Note: We don't need to initialize payment sheet for SetupIntent
        // The clientSecret is used directly in confirmSetupIntent
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingSetupIntent = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to initialize payment: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Pick receipt image for Bank Transfer
  Future<void> _pickReceiptImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _receiptImage = File(image.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick image: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

}
