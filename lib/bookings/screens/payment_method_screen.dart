import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../role_specific/common/role_router.dart';

class PaymentMethodScreen extends StatefulWidget {
  final String? selectedClub;
  final String? selectedSport;
  final String? selectedArea;
  final DateTime? selectedDate;
  final RangeValues? distanceRange;
  final UserRole? role;

  const PaymentMethodScreen({
    Key? key,
    this.selectedClub,
    this.selectedSport,
    this.selectedArea,
    this.selectedDate,
    this.distanceRange,
    this.role,
  }) : super(key: key);

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  String selectedPaymentMethod = 'CREDIT/DEBIT CARD';
  bool isCreditCardExpanded = true;
  bool isPayPalExpanded = false;
  bool isZelleExpanded = false;

  final TextEditingController nameOnCardController = TextEditingController();
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expiryDateController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();

  @override
  void dispose() {
    nameOnCardController.dispose();
    cardNumberController.dispose();
    expiryDateController.dispose();
    cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          'Payment Method',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: widget.role != null ? null : const Color(0xFF007BFF),
        flexibleSpace: widget.role != null
            ? Container(
                decoration: BoxDecoration(
                  gradient: _getRoleGradient(widget.role!),
                ),
              )
            : null,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Amount To Pay Section
            _buildAmountToPaySection(),
            const SizedBox(height: 16),

            // Payment Method Section
            _buildPaymentMethodSection(),
            const SizedBox(height: 16),

            // Final Payment Details Section
            _buildFinalPaymentDetailsSection(),
            const SizedBox(height: 80), // Space for bottom buttons
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: Colors.grey),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'CANCEL',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _handlePayNow,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'PAY NOW',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAmountToPaySection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Total Amount To Pay',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Text(
                'USD 2079',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Method',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),

        // Credit/Debit Card
        _buildPaymentMethodCard(
          'CREDIT / DEBIT CARD',
          Icons.credit_card,
          isCreditCardExpanded,
          () {
            setState(() {
              isCreditCardExpanded = !isCreditCardExpanded;
              if (isCreditCardExpanded) {
                isPayPalExpanded = false;
                isZelleExpanded = false;
                selectedPaymentMethod = 'CREDIT/DEBIT CARD';
              }
            });
          },
          _buildCreditCardForm(),
        ),
        const SizedBox(height: 8),

        // PayPal
        _buildPaymentMethodCard('PAYPAL', Icons.payment, isPayPalExpanded, () {
          setState(() {
            isPayPalExpanded = !isPayPalExpanded;
            if (isPayPalExpanded) {
              isCreditCardExpanded = false;
              isZelleExpanded = false;
              selectedPaymentMethod = 'PAYPAL';
            }
          });
        }, _buildPayPalForm()),
        const SizedBox(height: 8),

        // Zelle
        _buildPaymentMethodCard(
          'ZELLE',
          Icons.account_balance,
          isZelleExpanded,
          () {
            setState(() {
              isZelleExpanded = !isZelleExpanded;
              if (isZelleExpanded) {
                isCreditCardExpanded = false;
                isPayPalExpanded = false;
                selectedPaymentMethod = 'ZELLE';
              }
            });
          },
          _buildZelleForm(),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodCard(
    String title,
    IconData icon,
    bool isExpanded,
    VoidCallback onTap,
    Widget? expandedContent,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Icon(icon, size: 20, color: Colors.grey.shade600),
                  const SizedBox(width: 12),
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.grey.shade600,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded && expandedContent != null) ...[
            Container(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: expandedContent,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCreditCardForm() {
    return Column(
      children: [
        const Divider(color: Colors.grey),
        const SizedBox(height: 12),

        // Name On Card
        _buildInputField('Name On Card', 'Blank Fields', nameOnCardController),
        const SizedBox(height: 12),

        // Card Number
        Row(
          children: [
            Expanded(
              child: _buildInputField(
                'Card Number',
                'Blank Fields',
                cardNumberController,
              ),
            ),
            const SizedBox(width: 8),
            // Card logos
            Row(
              children: [
                _buildCardLogo('VISA'),
                const SizedBox(width: 4),
                _buildCardLogo('MC'),
                const SizedBox(width: 4),
                _buildCardLogo('JCB'),
                const SizedBox(width: 4),
                _buildCardLogo('AMEX'),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Expiry Date and CVV
        Row(
          children: [
            Expanded(
              child: _buildInputField(
                'Expiry Date',
                'Blank Fields',
                expiryDateController,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: _buildInputField(
                      'CVV',
                      'Blank Fields',
                      cvvController,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.help_outline,
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPayPalForm() {
    return Column(
      children: [
        const Divider(color: Colors.grey),
        const SizedBox(height: 12),

        // PayPal link
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue.shade200),
          ),
          child: Row(
            children: [
              Icon(Icons.link, size: 16, color: Colors.blue.shade600),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'https://www.paypal.com/paypalme/sekaiichikk',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.blue.shade600,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // PayPal ID
        _buildInputField(
          'Send Payment To Paypal ID',
          'sushant.godghate@sekai-ichi.com',
          TextEditingController(text: 'sushant.godghate@sekai-ichi.com'),
          enabled: false,
        ),
      ],
    );
  }

  Widget _buildZelleForm() {
    return Column(
      children: [
        const Divider(color: Colors.grey),
        const SizedBox(height: 12),

        // Zelle link
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.purple.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.purple.shade200),
          ),
          child: Row(
            children: [
              Icon(Icons.link, size: 16, color: Colors.purple.shade600),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'https://www.zelle.com/zelleme/sekaiichikk',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.purple.shade600,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Zelle ID
        _buildInputField(
          'Send Payment To Zelle ID',
          'sushant.godghate@sekai-ichi.com',
          TextEditingController(text: 'sushant.godghate@sekai-ichi.com'),
          enabled: false,
        ),
      ],
    );
  }

  Widget _buildInputField(
    String label,
    String placeholder,
    TextEditingController controller, {
    bool enabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          enabled: enabled,
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey.shade500,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: Color(0xFF007BFF)),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 8,
            ),
            isDense: true,
          ),
          style: GoogleFonts.poppins(fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildCardLogo(String cardType) {
    return Container(
      width: 24,
      height: 16,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(2),
      ),
      child: Center(
        child: Text(
          cardType,
          style: GoogleFonts.poppins(
            fontSize: 8,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade600,
          ),
        ),
      ),
    );
  }

  Widget _buildFinalPaymentDetailsSection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Final Payment Details',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),

          // Payment details grid
          _buildPaymentDetailRow('Payment Method:', selectedPaymentMethod),
          _buildPaymentDetailRow('Payment Status:', 'BEING PROCESSED'),
          _buildPaymentDetailRow('Payment Date:', 'Wed, March 5, 2025'),
          _buildPaymentDetailRow('Payment Time:', 'HH:MM:SS'),
        ],
      ),
    );
  }

  Widget _buildPaymentDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  void _handlePayNow() {
    // Validate form based on selected payment method
    if (selectedPaymentMethod == 'CREDIT/DEBIT CARD') {
      if (nameOnCardController.text.isEmpty ||
          cardNumberController.text.isEmpty ||
          expiryDateController.text.isEmpty ||
          cvvController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Please fill in all credit card details',
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
        return;
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Payment processed successfully!',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );

    // Navigate back to booking management
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  LinearGradient _getRoleGradient(UserRole role) {
    switch (role) {
      case UserRole.club:
        return const LinearGradient(
          colors: [Color(0xFF283048), Color(0xFF859398)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case UserRole.coach:
        return const LinearGradient(
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case UserRole.corporate:
        return const LinearGradient(
          colors: [Color(0xFFf093fb), Color(0xFFf5576c)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case UserRole.merchandiser:
        return const LinearGradient(
          colors: [Color(0xFF009A69), Color(0xFF232534)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case UserRole.member:
        return const LinearGradient(
          colors: [Color(0xFF283048), Color(0xFF859398)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case UserRole.freelancer:
        return const LinearGradient(
          colors: [Color(0xFF007BFF), Color(0xFF0056CC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }
}
