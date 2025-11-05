import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../role_specific/common/role_router.dart';
import 'payment_method_screen.dart';

class PurchaseScreen extends StatefulWidget {
  final String? selectedClub;
  final String? selectedSport;
  final String? selectedArea;
  final DateTime? selectedDate;
  final RangeValues? distanceRange;
  final UserRole? role;

  const PurchaseScreen({
    Key? key,
    this.selectedClub,
    this.selectedSport,
    this.selectedArea,
    this.selectedDate,
    this.distanceRange,
    this.role,
  }) : super(key: key);

  @override
  State<PurchaseScreen> createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  String selectedType = 'Input Text';
  String selectedMerchandiser1 = 'John Deo';
  String selectedMerchandiser2 = 'Jane Smith';

  // Product selection states
  Map<String, bool> sportswearSelected = {
    'Football': true,
    'Tennis': false,
    'Hoop': false,
  };

  Map<String, bool> jdSportsSelected = {
    'Football': true,
    'Tennis': false,
    'Hoop': false,
  };

  Map<String, int> sportswearQuantities = {
    'Football': 10,
    'Tennis': 10,
    'Hoop': 10,
  };

  Map<String, int> jdSportsQuantities = {
    'Football': 10,
    'Tennis': 10,
    'Hoop': 10,
  };

  final List<String> types = [
    'Input Text',
    'Equipment',
    'Accessories',
    'Apparel',
  ];
  final List<String> merchandisers = [
    'John Deo',
    'Jane Smith',
    'Mike Johnson',
    'Sarah Wilson',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          'Purchase',
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
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Selection Section
            _buildSelectionSection(),
            const SizedBox(height: 16),

            // Products Section
            _buildProductsSection(),
            const SizedBox(height: 16),

            // Summary Section
            _buildSummarySection(),
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
                    'Cancel',
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
                  onPressed: _handleProceedToPay,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF007BFF),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Proceed To Pay',
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

  Widget _buildSelectionSection() {
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
          // Select Type
          _buildDropdownField('Select Type', selectedType, (value) {
            setState(() {
              selectedType = value!;
            });
          }),
          const SizedBox(height: 12),

          // Merchandisers
          Row(
            children: [
              Expanded(
                child: _buildDropdownField(
                  'Merchandiser',
                  selectedMerchandiser1,
                  (value) {
                    setState(() {
                      selectedMerchandiser1 = value!;
                    });
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildDropdownField(
                  'Merchandiser',
                  selectedMerchandiser2,
                  (value) {
                    setState(() {
                      selectedMerchandiser2 = value!;
                    });
                  },
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF007BFF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  onPressed: () {
                    // Add more merchandiser logic
                  },
                  icon: const Icon(Icons.add, color: Colors.white, size: 20),
                  padding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField(
    String label,
    String value,
    ValueChanged<String?> onChanged,
  ) {
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
        DropdownButtonFormField<String>(
          value: value,
          onChanged: onChanged,
          decoration: InputDecoration(
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
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 8,
            ),
            isDense: true,
          ),
          style: GoogleFonts.poppins(fontSize: 12),
          items: (label == 'Select Type' ? types : merchandisers).map((
            String item,
          ) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: GoogleFonts.poppins(fontSize: 12),
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildProductsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Products',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),

        // Sportswear Section
        _buildProductSubsection(
          'Sportswear',
          sportswearSelected,
          sportswearQuantities,
        ),
        const SizedBox(height: 20),

        // JD Sports Section
        _buildProductSubsection(
          'JD Sports',
          jdSportsSelected,
          jdSportsQuantities,
        ),
      ],
    );
  }

  Widget _buildProductSubsection(
    String title,
    Map<String, bool> selected,
    Map<String, int> quantities,
  ) {
    final subtotal = _calculateSubtotal(selected, quantities);

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Text(
                'SUBTOTAL USD $subtotal',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Table Header
          _buildTableHeader(),
          const SizedBox(height: 8),

          // Product Rows
          ...selected.keys.map(
            (product) => _buildProductRow(
              product,
              selected[product]!,
              quantities[product]!,
              (isSelected) {
                setState(() {
                  selected[product] = isSelected;
                });
              },
              (quantity) {
                setState(() {
                  quantities[product] = quantity;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // Action
          SizedBox(
            width: 50,
            child: Text(
              'Action',
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          // Product Name
          Expanded(
            flex: 3,
            child: Text(
              'Product Name',
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          // Product Image
          SizedBox(
            width: 50,
            child: Text(
              'Image',
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          // Cost
          SizedBox(
            width: 50,
            child: Text(
              'Cost',
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          // Quantity
          SizedBox(
            width: 70,
            child: Text(
              'Qty',
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          // Total
          SizedBox(
            width: 70,
            child: Text(
              'Total',
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductRow(
    String productName,
    bool isSelected,
    int quantity,
    ValueChanged<bool> onSelectionChanged,
    ValueChanged<int> onQuantityChanged,
  ) {
    final cost = 50; // USD 50 per item
    final total = isSelected ? cost * quantity : 0;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          // Action (Checkbox)
          SizedBox(
            width: 50,
            child: Checkbox(
              value: isSelected,
              onChanged: (value) => onSelectionChanged(value ?? false),
              activeColor: const Color(0xFF007BFF),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
          // Product Name
          Expanded(
            flex: 3,
            child: Text(
              productName,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          // Product Image
          SizedBox(
            width: 50,
            height: 35,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Icon(
                _getProductIcon(productName),
                size: 18,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          // Cost
          SizedBox(
            width: 50,
            child: Text(
              'USD $cost',
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          // Quantity
          SizedBox(
            width: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: quantity > 0
                      ? () => onQuantityChanged(quantity - 1)
                      : null,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: quantity > 0
                          ? Colors.grey.shade300
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Icon(
                      Icons.remove,
                      size: 14,
                      color: quantity > 0
                          ? Colors.black87
                          : Colors.grey.shade400,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '$quantity',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: () => onQuantityChanged(quantity + 1),
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(
                      Icons.add,
                      size: 14,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Total
          SizedBox(
            width: 70,
            child: Text(
              'USD $total',
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getProductIcon(String productName) {
    switch (productName.toLowerCase()) {
      case 'football':
        return Icons.sports_soccer;
      case 'tennis':
        return Icons.sports_tennis;
      case 'hoop':
        return Icons.sports_basketball;
      default:
        return Icons.sports;
    }
  }

  Widget _buildSummarySection() {
    final johnDoeTotal = _calculateSubtotal(
      sportswearSelected,
      sportswearQuantities,
    );
    final janeSmithTotal = _calculateSubtotal(
      jdSportsSelected,
      jdSportsQuantities,
    );
    final totalAmount = johnDoeTotal + janeSmithTotal;

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
            'Summary',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),

          // John Doe
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'JOHN DOE (FREELANCER)',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Text(
                'USD $johnDoeTotal',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Jane Smith
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'JANE SMITH (MERCHANDISER)',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Text(
                'USD $janeSmithTotal',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Total Amount
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green.shade200),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'TOTAL AMOUNT',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.green.shade800,
                  ),
                ),
                Text(
                  'USD $totalAmount',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.green.shade800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  int _calculateSubtotal(
    Map<String, bool> selected,
    Map<String, int> quantities,
  ) {
    int subtotal = 0;
    selected.forEach((product, isSelected) {
      if (isSelected) {
        subtotal += 50 * quantities[product]!; // USD 50 per item
      }
    });
    return subtotal;
  }

  void _handleProceedToPay() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PaymentMethodScreen(
          selectedClub: widget.selectedClub,
          selectedSport: widget.selectedSport,
          selectedArea: widget.selectedArea,
          selectedDate: widget.selectedDate,
          distanceRange: widget.distanceRange,
          role: widget.role,
        ),
      ),
    );
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
