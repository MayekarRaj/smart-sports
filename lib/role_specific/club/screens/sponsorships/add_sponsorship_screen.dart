import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddSponsorshipScreen extends StatefulWidget {
  const AddSponsorshipScreen({super.key});

  @override
  State<AddSponsorshipScreen> createState() => _AddSponsorshipScreenState();
}

class _AddSponsorshipScreenState extends State<AddSponsorshipScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  final _sponsoredByController = TextEditingController(text: 'Abc Co Ltd');
  final _requestedByController = TextEditingController();
  final _utilizationController = TextEditingController();
  final _titleController = TextEditingController(text: 'Brown Country Tournament');
  final _inclusionsController = TextEditingController(
    text: 'Massive Brand Exposure Across All Event Materials, Press, Banners, Jerseys, And Digital Platforms. ABC Sports Cup 2025 Presented By BrandX',
  );
  final _daysToDeliverController = TextEditingController(text: '10');
  final _quantityController = TextEditingController(text: '50');
  final _totalCostController = TextEditingController(text: '50000');
  
  // State variables
  List<String> _applicableTo = [];
  String _selectedSport = 'Tennis';
  String _selectedType = 'Digital Add';
  String _selectedRegion = 'City';
  String _selectedCurrency = 'USD';
  DateTime? _fromDate = DateTime(2025, 3, 5);
  DateTime? _toDate = DateTime(2025, 3, 5);
  
  final List<String> _sportsOptions = ['Tennis', 'Football', 'Cricket', 'Basketball', 'Volleyball'];
  final List<String> _typeOptions = ['Digital Add', 'Banner', 'Jersey', 'Press', 'Other'];
  final List<String> _regionOptions = ['City', 'State', 'Country', 'International'];
  final List<String> _currencyOptions = ['USD', 'EUR', 'GBP', 'INR'];

  @override
  void dispose() {
    _sponsoredByController.dispose();
    _requestedByController.dispose();
    _utilizationController.dispose();
    _titleController.dispose();
    _inclusionsController.dispose();
    _daysToDeliverController.dispose();
    _quantityController.dispose();
    _totalCostController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fromDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        if (isFromDate) {
          _fromDate = picked;
        } else {
          _toDate = picked;
        }
      });
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Wed, March 5, 2025';
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${weekdays[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  void _toggleApplicableTo(String option) {
    setState(() {
      if (_applicableTo.contains(option)) {
        _applicableTo.remove(option);
      } else {
        _applicableTo.add(option);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F0),
      appBar: AppBar(
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFE5E7EB),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            'ADD SPONSORSHIPS',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2937),
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1F2937)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: Color(0xFF6B7280),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // TODO: Save sponsorship
                  Navigator.of(context).pop();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF009A69),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Save',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Applicable To
                _buildSectionTitle('Applicable To'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildCheckboxOption('Club'),
                    const SizedBox(width: 16),
                    _buildCheckboxOption('Booking'),
                    const SizedBox(width: 16),
                    _buildCheckboxOption('Event'),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Sports
                _buildSectionTitle('Sports'),
                const SizedBox(height: 8),
                _buildDropdownField(
                  _selectedSport,
                  _sportsOptions,
                  (value) => setState(() => _selectedSport = value!),
                ),
                const SizedBox(height: 24),
                
                // Type
                _buildSectionTitle('Type'),
                const SizedBox(height: 8),
                _buildDropdownField(
                  _selectedType,
                  _typeOptions,
                  (value) => setState(() => _selectedType = value!),
                ),
                const SizedBox(height: 24),
                
                // Sponsored By
                _buildSectionTitle('Sponsored By'),
                const SizedBox(height: 8),
                _buildTextField(_sponsoredByController, 'Enter sponsor name'),
                const SizedBox(height: 24),
                
                // Requested By
                _buildSectionTitle('Requested By'),
                const SizedBox(height: 8),
                _buildTextField(
                  _requestedByController,
                  'Enter requester name',
                  enabled: false,
                ),
                const SizedBox(height: 24),
                
                // Utilization
                _buildSectionTitle('Utilization'),
                const SizedBox(height: 8),
                _buildTextField(
                  _utilizationController,
                  'Enter utilization',
                  enabled: false,
                ),
                const SizedBox(height: 24),
                
                // Title
                _buildSectionTitle('Title'),
                const SizedBox(height: 8),
                _buildTextField(_titleController, 'Enter title'),
                const SizedBox(height: 24),
                
                // Inclusions
                _buildSectionTitle('Inclusions'),
                const SizedBox(height: 8),
                _buildTextArea(_inclusionsController, 'Enter inclusions'),
                const SizedBox(height: 24),
                
                // From Date
                _buildSectionTitle('From Date'),
                const SizedBox(height: 8),
                _buildDateField(_fromDate, true),
                const SizedBox(height: 24),
                
                // To Date
                _buildSectionTitle('To'),
                const SizedBox(height: 8),
                _buildDateField(_toDate, false),
                const SizedBox(height: 24),
                
                // Region
                _buildSectionTitle('Region'),
                const SizedBox(height: 8),
                _buildDropdownField(
                  _selectedRegion,
                  _regionOptions,
                  (value) => setState(() => _selectedRegion = value!),
                ),
                const SizedBox(height: 24),
                
                // Days To Deliver
                _buildSectionTitle('Days To Deliver'),
                const SizedBox(height: 8),
                _buildTextField(
                  _daysToDeliverController,
                  'Enter days',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 24),
                
                // Quantity
                _buildSectionTitle('Quantity'),
                const SizedBox(height: 8),
                _buildTextField(
                  _quantityController,
                  'Enter quantity',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 24),
                
                // Total Cost
                _buildSectionTitle('Total Cost'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      width: 100,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: DropdownButton<String>(
                        value: _selectedCurrency,
                        isExpanded: true,
                        underline: const SizedBox(),
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: Color(0xFF6B7280),
                        ),
                        style: const TextStyle(
                          color: Color(0xFF1F2937),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        items: _currencyOptions.map((String option) {
                          return DropdownMenuItem<String>(
                            value: option,
                            child: Text(option),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() => _selectedCurrency = value!);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTextField(
                        _totalCostController,
                        'Enter amount',
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Color(0xFF1F2937),
      ),
    );
  }

  Widget _buildCheckboxOption(String label) {
    final isSelected = _applicableTo.contains(label);
    return InkWell(
      onTap: () => _toggleApplicableTo(label),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF009A69) : Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF009A69)
                    : const Color(0xFFE5E7EB),
                width: 2,
              ),
            ),
            child: isSelected
                ? const Icon(
                    Icons.check,
                    size: 14,
                    color: Colors.white,
                  )
                : null,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: isSelected
                  ? const Color(0xFF1F2937)
                  : const Color(0xFF6B7280),
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField(
    String value,
    List<String> options,
    Function(String?) onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: DropdownButton<String>(
        value: value,
        isExpanded: true,
        underline: const SizedBox(),
        icon: const Icon(
          Icons.arrow_drop_down,
          color: Color(0xFF6B7280),
        ),
        style: const TextStyle(
          color: Color(0xFF1F2937),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        items: options.map((String option) {
          return DropdownMenuItem<String>(
            value: option,
            child: Text(option),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint, {
    bool enabled = true,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      inputFormatters: keyboardType == TextInputType.number
          ? [FilteringTextInputFormatter.digitsOnly]
          : null,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
        filled: true,
        fillColor: enabled ? Colors.white : const Color(0xFFF3F4F6),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF009A69), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      validator: (value) {
        if (enabled && (value == null || value.isEmpty)) {
          return 'This field is required';
        }
        return null;
      },
    );
  }

  Widget _buildTextArea(
    TextEditingController controller,
    String hint,
  ) {
    return TextFormField(
      controller: controller,
      maxLines: 5,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF009A69), width: 2),
        ),
        contentPadding: const EdgeInsets.all(16),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'This field is required';
        }
        return null;
      },
    );
  }

  Widget _buildDateField(DateTime? date, bool isFromDate) {
    return InkWell(
      onTap: () => _selectDate(context, isFromDate),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                _formatDate(date),
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF1F2937),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(
              Icons.calendar_today,
              color: Color(0xFF6B7280),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

