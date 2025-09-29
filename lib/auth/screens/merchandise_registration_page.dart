import 'package:flutter/material.dart';
import 'membership_plan_page.dart';

class MerchandiseRegistrationPage extends StatefulWidget {
  const MerchandiseRegistrationPage({super.key});

  @override
  State<MerchandiseRegistrationPage> createState() =>
      _MerchandiseRegistrationPageState();
}

class _MerchandiseRegistrationPageState
    extends State<MerchandiseRegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  // Company Details Controllers
  final _branchesController = TextEditingController(text: '2');
  final List<String> _selectedSports = [
    'Tennis',
    'Baseball',
    'Cricket',
    'Basketball',
  ];

  // Branch Data
  final List<Map<String, dynamic>> _branches = [
    {
      'name': 'Xyz',
      'users': 1,
      'addressSameAsSignup': true,
      'contactSameAsSignup': true,
    },
    {
      'name': 'Xyz',
      'users': 2,
      'addressSameAsSignup': false,
      'contactSameAsSignup': false,
    },
  ];

  // Address Controllers
  final _address1Controller = TextEditingController(text: 'Xyz');
  final _address2Controller = TextEditingController(text: 'Xyz');
  final _cityController = TextEditingController(text: 'Xyz');
  final _stateController = TextEditingController(text: 'Xyz');
  final _zipController = TextEditingController(text: 'Xyz');
  final _countryController = TextEditingController(text: 'Xyz');

  // Contact Details Controllers
  final _designationController = TextEditingController();
  final _departmentController = TextEditingController();
  final _officeNumberController = TextEditingController(
    text: '+91 - 9876543210',
  );
  final _mobileNumberController = TextEditingController(
    text: '+91 - 9876543210',
  );
  final _websiteController = TextEditingController(text: 'https://abc.com');

  @override
  void dispose() {
    _branchesController.dispose();
    _address1Controller.dispose();
    _address2Controller.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    _countryController.dispose();
    _designationController.dispose();
    _departmentController.dispose();
    _officeNumberController.dispose();
    _mobileNumberController.dispose();
    _websiteController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF7C3AED),
        elevation: 2,
        shadowColor: Colors.black26,
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
          'Merchandise Registration',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              const SizedBox(height: 16),

              // Company Details Section
              _buildSectionCard(
                title: 'Company Details',
                titleColor: Colors.white,
                titleBackground: const Color(0xFF8BB6D9),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField(
                      controller: _branchesController,
                      label: 'Number Of Branches',
                      hint: '2',
                      keyboardType: TextInputType.number,
                      suffixText:
                          '(It Will Be Paid Service To Use This Platform For More Than 1 Branch)',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Branch 1 Details Section
              _buildBranchSection(1),
              const SizedBox(height: 16),

              // Branch 2 Details Section (if multiple branches)
              if (int.tryParse(_branchesController.text) != null &&
                  int.parse(_branchesController.text) > 1)
                _buildBranchSection(2),
              if (int.tryParse(_branchesController.text) != null &&
                  int.parse(_branchesController.text) > 1)
                const SizedBox(height: 16),

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

  Widget _buildSectionCard({
    required String title,
    required Color titleColor,
    required Color titleBackground,
    required Widget child,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            decoration: BoxDecoration(
              color: titleBackground,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: titleBackground.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getSectionIcon(title),
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Padding(padding: const EdgeInsets.all(24), child: child),
        ],
      ),
    );
  }

  IconData _getSectionIcon(String title) {
    switch (title) {
      case 'Company Details':
        return Icons.shopping_bag;
      case 'Branch 1 Details':
      case 'Branch 2 Details':
        return Icons.account_tree;
      default:
        return Icons.info;
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    String? suffixText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF64748B),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
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
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
        ),
        if (suffixText != null) ...[
          const SizedBox(height: 4),
          Text(
            suffixText,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.red,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildCheckboxOption(
    String title,
    bool value,
    Function(bool?) onChanged,
  ) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFF8E2DE2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1E293B),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBranchSection(int branchNumber) {
    final branchData = _branches[branchNumber - 1];

    return _buildSectionCard(
      title: 'Branch $branchNumber Details',
      titleColor: Colors.white,
      titleBackground: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField(
            controller: TextEditingController(
              text: branchData['name'].toString(),
            ),
            label: 'Branch Name',
            hint: 'Enter branch name',
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: TextEditingController(
              text: branchData['users'].toString(),
            ),
            label: 'Number Of Users',
            hint: 'Enter number of users',
            keyboardType: TextInputType.number,
            suffixText: branchNumber == 2
                ? '(It Is A Paid Service For More Than 1 User/Branch. You Will Be Allowed To Add Users From Your Admin Panel After Subscription.)'
                : null,
          ),
          const SizedBox(height: 16),
          _buildCheckboxOption(
            'Address Is Same As Sign Up Address?',
            branchData['addressSameAsSignup'] as bool,
            (value) => setState(() {
              _branches[branchNumber - 1]['addressSameAsSignup'] = value!;
            }),
          ),

          // Address Section (if not same as signup)
          if (!(branchData['addressSameAsSignup'] as bool)) ...[
            const SizedBox(height: 16),
            _buildAddressSubSection(),
          ],

          const SizedBox(height: 16),
          _buildCheckboxOption(
            'Contact Details Is Same As Sign Up Contact Details?',
            branchData['contactSameAsSignup'] as bool,
            (value) => setState(() {
              _branches[branchNumber - 1]['contactSameAsSignup'] = value!;
            }),
          ),

          // Contact Details Section (if not same as signup)
          if (!(branchData['contactSameAsSignup'] as bool)) ...[
            const SizedBox(height: 16),
            _buildContactDetailsSubSection(),
          ],

          const SizedBox(height: 16),
          _buildSportsSubSection(),
        ],
      ),
    );
  }

  Widget _buildAddressSubSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            'Address',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 12),
        _buildTextField(
          controller: _address1Controller,
          label: 'Address 1',
          hint: 'Enter address line 1',
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _address2Controller,
          label: 'Address 2',
          hint: 'Enter address line 2',
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildDropdownField(
                label: 'City',
                value: _cityController.text,
                items: ['Xyz', 'City 1', 'City 2'],
                onChanged: (value) => _cityController.text = value!,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildDropdownField(
                label: 'State',
                value: _stateController.text,
                items: ['Xyz', 'State 1', 'State 2'],
                onChanged: (value) => _stateController.text = value!,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: _zipController,
                label: 'Zip Code',
                hint: 'Enter zip code',
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildDropdownField(
                label: 'Country',
                value: _countryController.text,
                items: ['Xyz', 'Country 1', 'Country 2'],
                onChanged: (value) => _countryController.text = value!,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildContactDetailsSubSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            'Contact Details',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: _designationController,
                label: 'Designation',
                hint: 'Enter designation',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildTextField(
                controller: _departmentController,
                label: 'Department',
                hint: 'Enter department',
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: _officeNumberController,
                label: 'Office Number',
                hint: 'Enter office number',
                keyboardType: TextInputType.phone,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildTextField(
                controller: _mobileNumberController,
                label: 'Mobile Number',
                hint: 'Enter mobile number',
                keyboardType: TextInputType.phone,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _websiteController,
          label: 'Company Website',
          hint: 'Enter website URL',
          keyboardType: TextInputType.url,
        ),
      ],
    );
  }

  Widget _buildSportsSubSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Sports',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF64748B),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _selectedSports.map((sport) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF8E2DE2).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFF8E2DE2)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            sport,
                            style: const TextStyle(
                              color: Color(0xFF8E2DE2),
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              size: 10,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_down,
                color: Color(0xFF64748B),
                size: 20,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF64748B),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
            items: items.map((String item) {
              return DropdownMenuItem<String>(value: item, child: Text(item));
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                side: BorderSide(color: Colors.grey[300]!, width: 1.5),
                backgroundColor: Colors.grey[50],
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF64748B),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                side: BorderSide(color: Colors.grey[300]!, width: 1.5),
                backgroundColor: Colors.grey[50],
              ),
              child: const Text(
                'Back',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF64748B),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MembershipPlanPage(),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7C3AED),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 2,
                shadowColor: Colors.black26,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Next',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
