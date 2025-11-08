import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/models/api_models.dart';
import '../../core/repositories/auth_repository.dart';
import '../../core/exceptions/api_exception.dart';
import '../../core/utils/phone_parser.dart';
import 'corporate_membership_plan_page.dart';

class CorporateRegistrationPage extends ConsumerStatefulWidget {
  const CorporateRegistrationPage({super.key});

  @override
  ConsumerState<CorporateRegistrationPage> createState() =>
      _CorporateRegistrationPageState();
}

class _CorporateRegistrationPageState extends ConsumerState<CorporateRegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();
  final AuthRepository _authRepository = AuthRepository();
  bool _isLoading = false;

  // Invoice Options
  String _selectedInvoiceOption = 'Monthly Invoice To Company';

  // Family Members
  String _familyMembersOption = 'Allowed';

  // Address Options
  bool _companyAddressSameAsSignup = false;
  bool _contactDetailsSameAsSignup = false;

  // Company Address Controllers
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
        backgroundColor: const Color(0xFF059669),
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
          'Corporate Registration',
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
                    // Invoice Section
                    _buildSubSectionHeader('Invoice'),
                    const SizedBox(height: 12),
                    _buildRadioOption(
                      'Monthly Invoice To Company',
                      _selectedInvoiceOption,
                      (value) =>
                          setState(() => _selectedInvoiceOption = value!),
                    ),
                    const SizedBox(height: 8),
                    _buildRadioOption(
                      'Employees Pay By Themselves',
                      _selectedInvoiceOption,
                      (value) =>
                          setState(() => _selectedInvoiceOption = value!),
                    ),
                    const SizedBox(height: 20),

                    // Family Members Section
                    _buildSubSectionHeader('Family Members'),
                    const SizedBox(height: 12),
                    _buildRadioOption(
                      'Allowed',
                      _familyMembersOption,
                      (value) => setState(() => _familyMembersOption = value!),
                    ),
                    const SizedBox(height: 8),
                    _buildRadioOption(
                      'Not Allowed',
                      _familyMembersOption,
                      (value) => setState(() => _familyMembersOption = value!),
                    ),
                    const SizedBox(height: 20),

                    // Company Address Checkbox
                    _buildCheckboxOption(
                      'Company Address Is Same As Sign Up Address?',
                      _companyAddressSameAsSignup,
                      (value) =>
                          setState(() => _companyAddressSameAsSignup = value!),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Company Address Section (if not same as signup)
              if (!_companyAddressSameAsSignup) _buildCompanyAddressSection(),
              if (!_companyAddressSameAsSignup) const SizedBox(height: 16),

              // Contact Details Checkbox
              _buildContactDetailsCheckboxSection(),
              const SizedBox(height: 16),

              // Contact Details Section (if not same as signup)
              if (!_contactDetailsSameAsSignup) _buildContactDetailsSection(),
              if (!_contactDetailsSameAsSignup) const SizedBox(height: 16),

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
                  child: const Icon(
                    Icons.business,
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

  Widget _buildSubSectionHeader(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildRadioOption(
    String title,
    String groupValue,
    Function(String?) onChanged,
  ) {
    return Row(
      children: [
        Radio<String>(
          value: title,
          groupValue: groupValue,
          onChanged: onChanged,
          activeColor: const Color(0xFF667EEA),
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
          activeColor: const Color(0xFF667EEA),
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

  Widget _buildCompanyAddressSection() {
    return _buildSectionCard(
      title: 'Company Address',
      titleColor: Colors.white,
      titleBackground: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
      ),
    );
  }

  Widget _buildContactDetailsCheckboxSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
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
      child: _buildCheckboxOption(
        'Contact Details Is Same As Sign Up Contact Details?',
        _contactDetailsSameAsSignup,
        (value) => setState(() => _contactDetailsSameAsSignup = value!),
      ),
    );
  }

  Widget _buildContactDetailsSection() {
    return _buildSectionCard(
      title: 'Contact Details',
      titleColor: Colors.white,
      titleBackground: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
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
              onPressed: _isLoading ? null : _submitCorporateRegistration,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF059669),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 2,
                shadowColor: Colors.black26,
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Row(
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

  Future<void> _submitCorporateRegistration() async {
    if (!_formKey.currentState!.validate()) return;
    if (!mounted) return;

    setState(() => _isLoading = true);

    try {
      // Parse phone numbers
      final officePhone = PhoneParser.parsePhoneNumber(_officeNumberController.text);
      final mobilePhone = PhoneParser.parsePhoneNumber(_mobileNumberController.text);

      // Map invoice type
      // "Monthly Invoice To Company" = 1, "Employees Pay By Themselves" = 0
      final invoiceType = _selectedInvoiceOption == 'Monthly Invoice To Company' ? 1 : 0;

      // Map family members
      // "Allowed" = 1, "Not Allowed" = 0 (based on API example showing is_allowed_family_members: 1)
      final isAllowedFamilyMembers = _familyMembersOption == 'Allowed' ? 1 : 0;

      // Build request
      final request = CorporateSignupRequest(
        userRole: 'corporate',
        invoiceType: invoiceType,
        isAllowedFamilyMembers: isAllowedFamilyMembers,
        isCompanyAddressSameAsSignupAddress: _companyAddressSameAsSignup ? 1 : 0,
        isContactDetailsSameAsSignupContactDetails: _contactDetailsSameAsSignup ? 1 : 0,
        companyAddress: _companyAddressSameAsSignup
            ? null
            : CorporateAddress(
                addressLine1: _address1Controller.text.trim(),
                addressLine2: _address2Controller.text.trim().isNotEmpty
                    ? _address2Controller.text.trim()
                    : null,
                addressLine3: null,
                city: _cityController.text.trim(),
                state: _stateController.text.trim(),
                zipCode: _zipController.text.trim(),
                country: _countryController.text.trim(),
              ),
        contactDetails: _contactDetailsSameAsSignup
            ? null
            : CorporateContactDetails(
                designation: _designationController.text.trim().isNotEmpty
                    ? _designationController.text.trim()
                    : null,
                department: _departmentController.text.trim().isNotEmpty
                    ? _departmentController.text.trim()
                    : null,
                officePhoneExt: officePhone['ext']?.isNotEmpty == true
                    ? officePhone['ext']
                    : null,
                officePhone: officePhone['number']?.isNotEmpty == true
                    ? officePhone['number']
                    : null,
                mobilePhoneExt: mobilePhone['ext']?.isNotEmpty == true
                    ? mobilePhone['ext']
                    : null,
                mobilePhone: mobilePhone['number']?.isNotEmpty == true
                    ? mobilePhone['number']
                    : null,
                companyWebsite: _websiteController.text.trim().isNotEmpty
                    ? _websiteController.text.trim()
                    : null,
              ),
      );

      // Call API
      final response = await _authRepository.corporateSignup(request);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Corporate registration successful!'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate to membership plan page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const CorporateMembershipPlanPage(),
          ),
        );
      }
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration failed: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
