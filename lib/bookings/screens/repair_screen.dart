import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../role_specific/common/role_router.dart';

class RepairScreen extends StatefulWidget {
  final String? selectedClub;
  final String? selectedSport;
  final String? selectedArea;
  final DateTime? selectedDate;
  final RangeValues? distanceRange;
  final UserRole? role;

  const RepairScreen({
    Key? key,
    this.selectedClub,
    this.selectedSport,
    this.selectedArea,
    this.selectedDate,
    this.distanceRange,
    this.role,
  }) : super(key: key);

  @override
  State<RepairScreen> createState() => _RepairScreenState();
}

class _RepairScreenState extends State<RepairScreen> {
  String selectedType = 'Select Type';
  String selectedMerchandiser1 = 'John Deo';
  String selectedMerchandiser2 = 'Jone Smith';

  // Repairing Center selections
  bool footballRepairSelected = true;
  bool tennisRepairSelected = false;
  bool hoopRepairSelected = false;
  int footballRepairQuantity = 10;
  int tennisRepairQuantity = 10;
  int hoopRepairQuantity = 10;

  // Repairing Services selections
  bool footballServiceSelected = true;
  bool tennisServiceSelected = false;
  bool hoopServiceSelected = false;
  int footballServiceQuantity = 10;
  int tennisServiceQuantity = 10;
  int hoopServiceQuantity = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          'Repair Services',
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
            // Select Type Section
            _buildSelectTypeSection(),
            const SizedBox(height: 16),

            // Services Section
            _buildServicesSection(),
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

  Widget _buildSelectTypeSection() {
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
            'Select Type',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),

          // Select Type dropdown
          _buildDropdownField(
            'Select Type',
            selectedType,
            [
              'Select Type',
              'Repair Services',
              'Maintenance',
              'Equipment Check',
            ],
            (value) => setState(() => selectedType = value!),
          ),
          const SizedBox(height: 12),

          // Merchandiser 1
          _buildDropdownField(
            'Merchandiser',
            selectedMerchandiser1,
            ['John Deo', 'Jane Smith', 'Mike Johnson', 'Sarah Wilson'],
            (value) => setState(() => selectedMerchandiser1 = value!),
          ),
          const SizedBox(height: 8),

          // Merchandiser 2
          _buildDropdownField(
            'Merchandiser',
            selectedMerchandiser2,
            ['Jone Smith', 'John Deo', 'Mike Johnson', 'Sarah Wilson'],
            (value) => setState(() => selectedMerchandiser2 = value!),
          ),
          const SizedBox(height: 8),

          // Add button
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF007BFF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                onPressed: () {
                  // Add new merchandiser logic
                },
                icon: const Icon(Icons.add, color: Colors.white, size: 20),
                padding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField(
    String label,
    String value,
    List<String> items,
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
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: GoogleFonts.poppins(fontSize: 12),
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          style: GoogleFonts.poppins(fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildServicesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Repairing Center
        _buildServiceSubsection(
          'REPAIRING CENTER',
          _calculateRepairingCenterSubtotal(),
          _buildRepairingCenterTable(),
        ),
        const SizedBox(height: 16),

        // Repairing Services
        _buildServiceSubsection(
          'REPAIRING SERVICES',
          _calculateRepairingServicesSubtotal(),
          _buildRepairingServicesTable(),
        ),
      ],
    );
  }

  Widget _buildServiceSubsection(String title, double subtotal, Widget table) {
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
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF007BFF),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    Text(
                      'SUBTOTAL',
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'USD ${subtotal.toStringAsFixed(0)}',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          table,
        ],
      ),
    );
  }

  Widget _buildRepairingCenterTable() {
    return Column(
      children: [
        _buildTableHeader(),
        const SizedBox(height: 8),
        _buildServiceRow(
          'Football Repair',
          Icons.sports_soccer,
          'USD 50',
          footballRepairSelected,
          footballRepairQuantity,
          (value) => setState(() => footballRepairSelected = value!),
          (quantity) => setState(() => footballRepairQuantity = quantity),
        ),
        _buildServiceRow(
          'Tennis Repair',
          Icons.sports_tennis,
          'USD 50',
          tennisRepairSelected,
          tennisRepairQuantity,
          (value) => setState(() => tennisRepairSelected = value!),
          (quantity) => setState(() => tennisRepairQuantity = quantity),
        ),
        _buildServiceRow(
          'Hoop Repair',
          Icons.sports_basketball,
          'USD 50',
          hoopRepairSelected,
          hoopRepairQuantity,
          (value) => setState(() => hoopRepairSelected = value!),
          (quantity) => setState(() => hoopRepairQuantity = quantity),
        ),
      ],
    );
  }

  Widget _buildRepairingServicesTable() {
    return Column(
      children: [
        _buildTableHeader(),
        const SizedBox(height: 8),
        _buildServiceRow(
          'Football Repair',
          Icons.sports_soccer,
          'USD 50',
          footballServiceSelected,
          footballServiceQuantity,
          (value) => setState(() => footballServiceSelected = value!),
          (quantity) => setState(() => footballServiceQuantity = quantity),
        ),
        _buildServiceRow(
          'Tennis Repair',
          Icons.sports_tennis,
          'USD 50',
          tennisServiceSelected,
          tennisServiceQuantity,
          (value) => setState(() => tennisServiceSelected = value!),
          (quantity) => setState(() => tennisServiceQuantity = quantity),
        ),
        _buildServiceRow(
          'Hoop Repair',
          Icons.sports_basketball,
          'USD 50',
          hoopServiceSelected,
          hoopServiceQuantity,
          (value) => setState(() => hoopServiceSelected = value!),
          (quantity) => setState(() => hoopServiceQuantity = quantity),
        ),
      ],
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 50,
            child: Text(
              'Action',
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              'Service Name',
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          SizedBox(
            width: 50,
            child: Text(
              'Product Image',
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          SizedBox(
            width: 50,
            child: Text(
              'Cost',
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          SizedBox(
            width: 70,
            child: Text(
              'Quantity',
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          SizedBox(
            width: 70,
            child: Text(
              'Total',
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceRow(
    String serviceName,
    IconData icon,
    String cost,
    bool isSelected,
    int quantity,
    ValueChanged<bool?> onChanged,
    ValueChanged<int> onQuantityChanged,
  ) {
    double costValue = double.parse(cost.replaceAll('USD ', ''));
    double total = costValue * quantity;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          // Action checkbox
          SizedBox(
            width: 50,
            child: Checkbox(
              value: isSelected,
              onChanged: onChanged,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              activeColor: const Color(0xFF007BFF),
            ),
          ),

          // Service Name
          Expanded(
            flex: 3,
            child: Text(
              serviceName,
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
            child: Icon(icon, size: 18, color: Colors.grey.shade600),
          ),

          // Cost
          SizedBox(
            width: 50,
            child: Text(
              cost,
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
              children: [
                GestureDetector(
                  onTap: () => onQuantityChanged(quantity - 1),
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Icon(
                      Icons.remove,
                      size: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  quantity.toString(),
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
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Icon(
                      Icons.add,
                      size: 14,
                      color: Colors.grey.shade600,
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
              'USD ${total.toStringAsFixed(0)}',
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

  Widget _buildSummarySection() {
    double johnDoeTotal = _calculateRepairingCenterSubtotal();
    double janeSmithTotal = _calculateRepairingServicesSubtotal();
    double totalAmount = johnDoeTotal + janeSmithTotal;

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

          // John Doe (Freelancer)
          _buildSummaryRow(
            'JOHN DOE (FREELANCER)',
            'USD ${johnDoeTotal.toStringAsFixed(0)}',
            Colors.grey.shade800,
          ),
          const SizedBox(height: 8),

          // Jane Smith (Merchandiser)
          _buildSummaryRow(
            'JANE SMITH (MERCHANDISER)',
            'USD ${janeSmithTotal.toStringAsFixed(0)}',
            Colors.grey.shade800,
          ),
          const SizedBox(height: 12),

          // Total Amount
          _buildSummaryRow(
            'TOTAL AMOUNT',
            'USD ${totalAmount.toStringAsFixed(0)}',
            Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String amount, Color backgroundColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              amount,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _calculateRepairingCenterSubtotal() {
    double subtotal = 0;
    if (footballRepairSelected) subtotal += 50 * footballRepairQuantity;
    if (tennisRepairSelected) subtotal += 50 * tennisRepairQuantity;
    if (hoopRepairSelected) subtotal += 50 * hoopRepairQuantity;
    return subtotal;
  }

  double _calculateRepairingServicesSubtotal() {
    double subtotal = 0;
    if (footballServiceSelected) subtotal += 50 * footballServiceQuantity;
    if (tennisServiceSelected) subtotal += 50 * tennisServiceQuantity;
    if (hoopServiceSelected) subtotal += 50 * hoopServiceQuantity;
    return subtotal;
  }

  void _handleProceedToPay() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Proceeding to payment for repair services...',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );

    // Navigate to payment screen or handle payment logic
    // Navigator.of(context).push(...);
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
